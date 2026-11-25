import 'dart:async';

import 'package:flutter/services.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';
import 'package:vkid_flutter_sdk/library_vkid.dart';
import 'package:yandex_login_sdk/yandex_login_sdk.dart';

abstract interface class PasskeySdk {
  Future<AuthenticateResponseType> authenticate(AuthenticateRequestType request);
}

final class NativePasskeySdk implements PasskeySdk {
  final _authenticator = PasskeyAuthenticator();

  @override
  Future<AuthenticateResponseType> authenticate(AuthenticateRequestType request) => _authenticator.authenticate(request);
}

abstract interface class YandexSdk {
  Future<String> signIn(String clientId);
}

final class NativeYandexSdk implements YandexSdk {
  @override
  Future<String> signIn(String clientId) async {
    final result = await YandexLoginSdk.signIn(clientId: clientId, strategy: YandexLoginStrategy.auto);
    // Токен разовый: очищаем кэш SDK, чтобы следующий вход не переиспользовал его без UI.
    unawaited(YandexLoginSdk.signOut().catchError((Object _) {}));
    return result.token;
  }
}

/// Пользователь закрыл окно авторизации VK ID — не ошибка.
final class VkAuthCancelledException implements Exception {
  const VkAuthCancelledException();

  @override
  String toString() => 'VkAuthCancelledException';
}

/// Сбой авторизации VK ID: ошибка SDK или VK, либо SDK не настроен в этой сборке.
final class VkAuthException implements Exception {
  const VkAuthException(this.description);

  final String description;

  @override
  String toString() => 'VkAuthException: $description';
}

abstract interface class VkSdk {
  /// Client_id приложения VK ID, вшитый в сборку (iOS — Info.plist, Android —
  /// манифест); пусто — VK в этой сборке не настроен, вход через него недоступен.
  /// Не бросает.
  Future<String> clientId();

  /// Авторизация VK ID (приложение VK или браузер) → OAuth access_token с правом
  /// `phone`. Бросает [VkAuthCancelledException], если пользователь закрыл окно VK,
  /// и [VkAuthException] — при прочих сбоях.
  Future<String> signIn();

  /// Завершает сессию VK ID на устройстве. В отличие от Яндекса, logout VK SDK —
  /// запрос на сервер VK, который отзывает токен, поэтому [signIn] не делает этого
  /// сам: вызывать можно только после того, как сервер Iperon подтвердил номер
  /// по токену (AUTH_VK). Не бросает.
  Future<void> logout();
}

final class NativeVkSdk implements VkSdk {
  static const _channel = MethodChannel('com.vk.id/vkid');

  @override
  Future<String> clientId() async {
    try {
      return await _channel.invokeMethod<String>('clientId') ?? '';
    } on PlatformException {
      // Платформа без плагина (macOS — MissingPluginException) или сбой канала:
      // считаем VK не настроенным.
      return '';
    }
  }

  @override
  Future<String> signIn() async {
    if ((await clientId()).isEmpty) {
      throw const VkAuthException('VK ID is not configured in this build');
    }

    final vkid = await VKID.getInstance();
    final completer = Completer<String>();
    vkid.authorize(
      onAuth: (data) => completer.complete(data.token),
      onError: (error) => switch (error) {
        AuthCancelledError() => completer.completeError(const VkAuthCancelledException()),
        AuthOtherError(:final description) => completer.completeError(VkAuthException(description)),
      },
      params: const AuthParams(scopes: {'phone'}),
    );
    return completer.future;
  }

  @override
  Future<void> logout() async {
    try {
      if ((await clientId()).isEmpty) return;
      (await VKID.getInstance()).logout();
    } on PlatformException {
      // Выход из SDK — вспомогательная операция (VK-сессию на устройстве не
      // оставляем): сбой канала не должен ронять вызывающего.
    }
  }
}
