import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf.dart';
import '../../utils.dart';
import 'auth_login_completer.dart';
import 'auth_qr_state.dart';

/// Содержимое QR входа на десктопе: `iperon://login?token=<base64url>` (его же
/// разбирает сканер на телефоне, `parseQrLoginToken`).
String qrLoginData(List<int> token) => 'iperon://login?token=${base64Url.encode(token).replaceAll('=', '')}';

/// Токен из отсканированного QR; `null` — это не QR входа Iperon.
Uint8List? parseQrLoginToken(String raw) {
  final uri = Uri.tryParse(raw.trim());
  if (uri == null || uri.scheme != 'iperon' || uri.host != 'login') return null;
  final token = uri.queryParameters['token'];
  if (token == null || token.isEmpty) return null;
  try {
    return base64Url.decode(base64Url.normalize(token));
  } on FormatException {
    return null;
  }
}

/// Вход на десктопе по QR с телефона (docs/plans/desktop-client.md §3.4,
/// `qr_login_v1.proto`): берёт токен (`AUTH_QR` Create), показывает его QR и
/// опрашивает (Check) каждые [_poll]. Истёк — новый токен; подтвердили на
/// телефоне — облачный пароль (если включён) или [AuthLoginCompleter].
class AuthQrCubit extends Cubit<AuthQrState> {
  AuthQrCubit() : super(const AuthQrState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();

  static const _poll = Duration(seconds: 2);

  /// Обновить QR чуть раньше срока: пока телефон сканирует, токен не истечёт.
  static const _refreshBefore = Duration(seconds: 10);

  Timer? _timer;
  List<int> _token = const [];
  DateTime _expiresAt = DateTime.fromMillisecondsSinceEpoch(0);
  bool _checking = false;

  Future<void> initialization() => _create();

  /// «Повторить» после ошибки.
  Future<void> retry() => _create();

  Future<void> _create() async {
    _timer?.cancel();
    emit(state.copyWith(status: Status.loading, error: ""));
    final packageInfo = await utils.packageInfo();
    final deviceInfo = await utils.deviceInfo();
    final response = await _request(
      AuthQr_Request(
        newToken: AuthQr_Create(
          device: AuthQr_Device(
            deviceModel: deviceInfo.deviceModel,
            os: deviceInfo.osCode,
            osVersion: deviceInfo.osVersion,
            appVersion: packageInfo.appVersion,
          ),
        ),
      ),
    );
    if (isClosed || response == null) return;
    _token = response.token;
    _expiresAt = DateTime.fromMillisecondsSinceEpoch(response.expiresAt.toInt());
    emit(state.copyWith(status: Status.success, qrData: qrLoginData(_token)));
    _timer = Timer.periodic(_poll, (_) => unawaited(_check()));
  }

  Future<void> _check() async {
    if (_checking || state.completing) return;
    if (DateTime.now().isAfter(_expiresAt.subtract(_refreshBefore))) {
      await _create();
      return;
    }
    _checking = true;
    try {
      final response = await _request(AuthQr_Request(poll: AuthQr_Check(token: _token)));
      if (isClosed || response == null) return;
      switch (response.status) {
        case AuthQr_Status.PENDING:
          return;
        case AuthQr_Status.EXPIRED:
          await _create();
        case AuthQr_Status.ACCEPTED:
          _timer?.cancel();
          await _complete(response);
      }
    } finally {
      _checking = false;
    }
  }

  Future<void> _complete(AuthQr_Response response) async {
    // Двухшаговая проверка: вход по QR её не обходит.
    if (response.hasTwoStepVerification) {
      final hex = utils.bytesToHex(Uint8List.fromList(response.confirmationSession));
      emit(state.copyWith(redirectURI: "/auth/cloud_password?confirmationSession=$hex"));
      return;
    }
    emit(state.copyWith(completing: true));
    final completion = await AuthLoginCompleter().complete(response.confirmationSession);
    if (isClosed) return;
    if (completion.error.isNotEmpty) {
      emit(state.copyWith(completing: false, error: completion.error));
      return;
    }
    emit(state.copyWith(redirectURI: completion.redirectURI));
  }

  /// Pre-auth unary `AUTH_QR`; ошибка — в state (`null`).
  Future<AuthQr_Response?> _request(AuthQr_Request request) async {
    late Message responseMessage;
    final status = await api.call(() async {
      responseMessage = await api.client.unary(Message(messageType: MessageType.AUTH_QR, message: request.writeToBuffer()));
    });
    if (status.status == APIStatus.error) {
      _timer?.cancel();
      if (!isClosed) emit(state.copyWith(status: Status.initialization, error: status.error));
      return null;
    }
    return AuthQr_Response.fromBuffer(responseMessage.message);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
