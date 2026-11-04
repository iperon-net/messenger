import 'dart:async';

import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';
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
