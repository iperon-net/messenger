
import 'package:get_it/get_it.dart';

import 'api.dart';
import 'crypto.dart';
import 'logger.dart';
import 'repositories/repositories.dart';
import 'routers.dart';
import 'utils.dart';


GetIt getIt = GetIt.instance;

Future<void> configureCommonDependencies() async {
  getIt.registerSingletonAsync<Logger>(() async => Logger());
  getIt.registerSingletonAsync<Utils>(() async => Utils());
  getIt.registerSingletonAsync<Crypto>(() async => Crypto(), dependsOn: [Logger]);
  getIt.registerSingletonAsync<Repositories>(() async => Repositories(), dependsOn: [Logger]);
  getIt.registerSingletonAsync<Routers>(() async => Routers(), dependsOn: [Logger]);
  getIt.registerSingletonAsync<API>(() async => API()..initialization(), dependsOn: [Logger]);

  await getIt.allReady();
}
