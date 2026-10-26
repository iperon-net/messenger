import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../api.dart';
import '../../cubit.dart' show parseQrLoginToken;
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' show osWithVersion;
import '../../protobuf.dart';
import '../../utils.dart';

/// Подтверждение входа на десктопе по QR (`AUTH_QR_CONFIRM`): `accept` false —
/// только узнать, что за устройство, true — впустить. `error` — i18n-ключ.
Future<({AuthQrConfirm_Response? device, String error})> qrLoginConfirm(Uint8List token, {required bool accept}) async {
  if (!await getIt.get<Utils>().hasNetwork()) return (device: null, error: 'grpcError.unableConnectServer');
  final (status, payload) = await getIt.get<API>().unaryEncodedWithResponse(
    MessageType.AUTH_QR_CONFIRM,
    AuthQrConfirm_Request(token: token, accept: accept).writeToBuffer(),
  );
  if (status.status == APIStatus.error || payload == null) return (device: null, error: status.error);
  return (device: AuthQrConfirm_Response.fromBuffer(payload), error: '');
}

/// Что за устройство входит: «MacBookPro18,4 · macOS 26.6 · Iperon 0.0.540» и
/// город по IP — для окна подтверждения.
String deviceLinkDescription(Translations t, AuthQrConfirm_Response response) {
  final device = response.device;
  final russian = LocaleSettings.currentLocale == AppLocale.ru;
  final location = russian
      ? (response.locationRussian.isNotEmpty ? response.locationRussian : response.locationEnglish)
      : (response.locationEnglish.isNotEmpty ? response.locationEnglish : response.locationRussian);
  return [
    [device.deviceModel, osWithVersion(device.os, device.osVersion)].where((part) => part.isNotEmpty).join(' · '),
    if (location.isNotEmpty) location,
  ].join('\n');
}

/// Текст ошибки по i18n-ключу (неизвестный ключ — «неизвестная ошибка»).
String deviceLinkError(BuildContext context, String key) {
  try {
    return context.t[key];
  } catch (_) {
    return context.t.grpcError.unknownError;
  }
}

/// Сканер «Подключить устройство» — общее для Cupertino и Material: камера ищет
/// QR входа, нашла — спрашивает сервер, кто входит, показывает подтверждение
/// ([confirm]) и впускает. [onError] / [onLinked] — сообщение и выход с экрана.
mixin DeviceLinkScanner<T extends StatefulWidget> on State<T> {
  final scanner = MobileScannerController(formats: const [BarcodeFormat.qrCode]);
  bool _busy = false;

  /// Подтвердить вход устройства (описание — [deviceLinkDescription]).
  Future<bool> confirm(String description);

  void onError(String message);

  void onLinked();

  void onDetect(BarcodeCapture capture) {
    if (_busy) return;
    final raw = capture.barcodes.map((code) => code.rawValue).nonNulls.firstOrNull;
    if (raw == null) return;
    unawaited(_handle(raw));
  }

  Future<void> _handle(String raw) async {
    _busy = true;
    var linked = false;
    try {
      final token = parseQrLoginToken(raw);
      if (token == null) {
        onError(context.t.deviceLink.invalidCode);
        return;
      }
      await scanner.stop();
      final info = await qrLoginConfirm(token, accept: false);
      if (!mounted) return;
      if (info.device == null) {
        onError(deviceLinkError(context, info.error));
        return;
      }
      if (!await confirm(deviceLinkDescription(context.t, info.device!)) || !mounted) return;
      final accepted = await qrLoginConfirm(token, accept: true);
      if (!mounted) return;
      if (accepted.device == null) {
        onError(deviceLinkError(context, accepted.error));
        return;
      }
      linked = true;
      onLinked();
    } finally {
      // Не вошли (отмена, ошибка, чужой QR) — после паузы сканируем дальше (тот
      // же код в кадре не повторит ошибку сразу); вошли — экран закрывается.
      if (!linked) {
        await Future<void>.delayed(const Duration(seconds: 2));
        if (mounted) {
          _busy = false;
          if (!scanner.value.isRunning) unawaited(scanner.start());
        }
      }
    }
  }

  @override
  void dispose() {
    unawaited(scanner.dispose());
    super.dispose();
  }
}
