import 'package:envied/envied.dart';

part 'settings.g.dart';


@Envied(path: '.env')
class Settings {

  @EnviedField(varName: 'DATABASE_NAME',  defaultValue: 'iperon.db')
  static const String databaseName = _Settings.databaseName;

  @EnviedField(varName: 'IS_DELETE_DATABASE', defaultValue: false)
  static const bool isDeleteDatabase = _Settings.isDeleteDatabase;

  @EnviedField(varName: 'DATABASE_VERSION', defaultValue: 1)
  static const int databaseVersion = _Settings.databaseVersion;

  @EnviedField(varName: 'PUBLIC_KEY_ECDH_FINGERPRINT')
  static const String publicKeyECDHFingerprint = _Settings.publicKeyECDHFingerprint;

  @EnviedField(varName: 'YANDEX_OAUTH_CLIENT_ID')
  static const String yandexOauthClientId = _Settings.yandexOauthClientId;
}


