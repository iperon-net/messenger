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
}
