import 'package:envied/envied.dart';

part 'settings.g.dart';


@Envied()
class Settings {
  @EnviedField(varName: 'DATABASE_NAME',  defaultValue: 'iperon.db')
  static const String databaseName = _Settings.databaseName;

  @EnviedField(varName: 'IS_DELETE_DATABASE', defaultValue: false)
  static const bool isDeleteDatabase = _Settings.isDeleteDatabase;

  @EnviedField(varName: 'DATABASE_VERSION', defaultValue: 1)
  static const int databaseVersion = _Settings.databaseVersion;

  @EnviedField(varName: 'GRPC_HOST')
  static const String grpcHost = _Settings.grpcHost;

  @EnviedField(varName: 'GRPC_PORT', defaultValue: 443)
  static const int grpcPort = _Settings.grpcPort;
}
