import 'package:get_it/get_it.dart';

import 'logger.dart';
import 'repositories/repositories.dart';
import 'secure_storage.dart';

GetIt getIt = GetIt.instance;

Future<void> configureGlobalDI() async {

  getIt.registerSingletonAsync<Logger>(() async => Logger());
  getIt.registerSingletonAsync<SecureStorage>(() async => SecureStorage(), dependsOn: [Logger]);
  getIt.registerSingletonAsync<Repositories>(() async => Repositories()..initialization(), dependsOn: [Logger, SecureStorage]);


  await getIt.allReady();
}
