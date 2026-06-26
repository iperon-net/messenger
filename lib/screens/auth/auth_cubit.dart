import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart' as convertor;
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:messenger/di.dart';
import 'package:yandex_login_sdk/yandex_login_sdk.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../logger.dart';
import '../../protobuf/protos/auth_v1.pb.dart';
import '../../settings.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  final phoneUtil = PhoneNumberUtil.instance;

  final _logger = getIt.get<Logger>();
  final _api = getIt.get<API>();

  /// Синхронная валидация поля. Возвращает i18n-КЛЮЧ ошибки или null.
  /// Локализацию выполняет экран: `context.t[key]`.
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'enterYourMobilePhoneNumber';

    final PhoneNumber phoneNumber;
    try {
      phoneNumber = phoneUtil.parse(value, "RU");
    } catch (err) {
      _logger.error(err);
      return 'enterYourMobilePhoneNumber';
    }

    if (phoneUtil.getNumberType(phoneNumber) != PhoneNumberType.mobile) {
      return 'currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators';
    }

    return null;
  }

  /// Отправка номера. Не знает про навигацию и локализацию — кладёт в state
  /// `errorKey` (ключ ошибки) и `redirectUrl` (маршрут перехода), а экран реагирует.
  Future<void> submit(String rawPhone) async {
    emit(state.copyWith(status: Status.loading, errorKey: '', redirectUrl: ''));

    final PhoneNumber phoneNumber;
    try {
      phoneNumber = phoneUtil.parse(rawPhone, "RU");
    } catch (_) {
      emit(state.copyWith(status: Status.success, errorKey: 'enterYourMobilePhoneNumber'));
      return;
    }

    final e164 = "${phoneNumber.countryCode}${phoneNumber.nationalNumber}";

    // ModerationApplicationStore workflow (SMS)
    if (Settings.phoneNumberModerationApplicationStore == e164) {
      late AuthSMSResponse res;
      final error = await _api.call(() async {
        res = await _api.auth.sMS(AuthSMSRequest(phoneNumber: e164), options: await _api.callOptions());
      });

      if (isClosed) return;

      if (error.isNotEmpty) {
        emit(state.copyWith(status: Status.success, errorKey: error));
        return;
      }

      final query = Uri(queryParameters: {
        'smsSession': convertor.hex.encode(res.smsSession),
        'phoneNumber': phoneUtil.format(phoneNumber, PhoneNumberFormat.international).toString(),
      }).query;
      emit(state.copyWith(status: Status.success, redirectUrl: "/auth/sms?$query"));
      return;
    }

    // CallPassword workflow
    late AuthCallPasswordResponse response;
    final error = await _api.call(() async {
      response = await _api.auth.callPassword(AuthCallPasswordRequest(phoneNumber: e164), options: await _api.callOptions());
    });

    if (isClosed) return;

    if (error.isNotEmpty) {
      emit(state.copyWith(status: Status.success, errorKey: error));
      return;
    }

    final query = Uri(queryParameters: {
      'callPasswordSession': convertor.hex.encode(response.callPasswordSession),
      'confirmationPhoneNumber': response.confirmationPhoneNumber,
      'timeout': response.timeout.toString(),
    }).query;
    emit(state.copyWith(status: Status.success, redirectUrl: "/auth/callpassword?$query"));

    _logger.info("waiting for a call from the phone $e164");
  }

  /// Экран вызывает после выполнения перехода, чтобы не навигировать повторно.
  void redirectHandled() => emit(state.copyWith(redirectUrl: ''));

  /// Сброс серверной ошибки при редактировании поля,
  /// чтобы прежняя ошибка не «прилипала» к новому вводу.
  void clearError() {
    if (state.errorKey.isNotEmpty) emit(state.copyWith(errorKey: ''));
  }

  Future<void> signIn() async {
    try {
      final result = await YandexLoginSdk.signIn(clientId: Settings.yandexOauthClientId);
      // NB: не логируем сам токен — это чувствительные данные.
      _logger.debug('Yandex sign-in succeeded (token length: ${result.token.length})');
      // TODO: обменять result.token на сессию и выставить redirectUrl.
    } on YandexAuthCancelledException {
      _logger.error('YandexAuthCancelledException');
    } on YandexAuthUnsupportedException {
      _logger.error('YandexAuthUnsupportedException');
    } on YandexAuthException catch (e) {
      _logger.error('Yandex SDK error: $e');
    }
  }

  Future<void> telegram() async {}
}
