
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/repositories.dart';
import 'logger.dart';
import 'routers.dart';
import 'auth.dart';
import 'settings.dart';
import 'utils.dart';
import 'api.dart';
import 'crypto.dart';


GetIt getIt = GetIt.instance;

Future<void> registerCommonDependencies() async {
  if (!getIt.isRegistered<Logger>()) getIt.registerSingletonAsync<Logger>(() async => Logger());
  if (!getIt.isRegistered<Settings>()) getIt.registerSingletonAsync<Settings>(() async => Settings.initialization(), dependsOn: [Logger]);
  if (!getIt.isRegistered<Repositories>()) getIt.registerSingletonAsync<Repositories>(() async => Repositories.initialization(), dependsOn: [Settings]);
  if (!getIt.isRegistered<Utils>()) getIt.registerSingletonAsync<Utils>(() async => Utils());
  if (!getIt.isRegistered<API>()) getIt.registerSingletonAsync<API>(() async => API(), dependsOn: [Settings]);
  if (!getIt.isRegistered<Auth>()) getIt.registerSingletonAsync<Auth>(() async => Auth.initialization(), dependsOn: [Repositories, API]);
  if (!getIt.isRegistered<Routers>()) getIt.registerSingletonAsync<Routers>(() async => Routers(), dependsOn: [Repositories, Auth]);
  if (!getIt.isRegistered<Crypto>()) getIt.registerSingletonAsync<Crypto>(() async => Crypto(), dependsOn: [Settings, Utils]);

  await getIt.allReady();
}

Future<void> unregisterCommonDependencies() async {
  if (getIt.isRegistered<Logger>()) await getIt.unregister<Logger>();
  if (getIt.isRegistered<Settings>()) await getIt.unregister<Settings>();
  if (getIt.isRegistered<Repositories>()) await getIt.unregister<Repositories>();
  if (getIt.isRegistered<Auth>()) await getIt.unregister<Auth>();
  if (getIt.isRegistered<Routers>()) await getIt.unregister<Routers>();
  if (getIt.isRegistered<Utils>()) await getIt.unregister<Utils>();
  if (getIt.isRegistered<API>()) await getIt.unregister<API>();
  if (getIt.isRegistered<Crypto>()) await getIt.unregister<Crypto>();
}
