
import 'package:get_it/get_it.dart';

import 'api.dart';
import 'crypto.dart';
import 'logger.dart';
import 'repositories/repositories.dart';
import 'routers.dart';
import 'services/services.dart';
import 'utils.dart';

GetIt getIt = GetIt.instance;

Future<void> registerCommonDependencies() async {
  if (!getIt.isRegistered<Logger>()) getIt.registerSingletonAsync<Logger>(() async => Logger());
  if (!getIt.isRegistered<Utils>()) getIt.registerSingletonAsync<Utils>(() async => Utils());
  if (!getIt.isRegistered<Crypto>()) getIt.registerSingletonAsync<Crypto>(() async => Crypto(), dependsOn: [Logger]);
  if (!getIt.isRegistered<Repositories>()) getIt.registerSingletonAsync<Repositories>(() async => Repositories(), dependsOn: [Logger]);
  if (!getIt.isRegistered<Routers>()) getIt.registerSingletonAsync<Routers>(() async => Routers(), dependsOn: [Logger]);
  if (!getIt.isRegistered<API>()) getIt.registerSingletonAsync<API>(() async => API(), dependsOn: [Logger]);
  if (!getIt.isRegistered<Services>()) getIt.registerSingletonAsync<Services>(() async => Services(), dependsOn: [API]);

  await getIt.allReady();

  final repositories = getIt.get<Repositories>();
  final api = getIt.get<API>();
  final services = getIt.get<Services>();

  // Initialization DI
  await repositories.initialization();
  await api.initialization();
  await services.initialization();
}

Future<void> unregisterCommonDependencies() async {
  if (getIt.isRegistered<Logger>()) await getIt.unregister<Logger>();
  if (getIt.isRegistered<Utils>()) await getIt.unregister<Utils>();
  if (getIt.isRegistered<Crypto>()) await getIt.unregister<Crypto>();
  if (getIt.isRegistered<Repositories>()) await getIt.unregister<Repositories>();
  if (getIt.isRegistered<Routers>()) await getIt.unregister<Routers>();
  if (getIt.isRegistered<API>()) await getIt.unregister<API>();
  if (getIt.isRegistered<Services>()) await getIt.unregister<Services>();
}
