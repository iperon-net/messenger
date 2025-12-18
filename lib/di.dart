
import 'package:get_it/get_it.dart';

import 'routers.dart';
import 'logger.dart';

GetIt getIt = GetIt.instance;


Future<void> configureCommonDependencies() async {
  getIt.registerSingletonAsync<Logger>(() async => Logger());
  getIt.registerSingletonAsync<Routers>(() async => Routers(), dependsOn: [Logger]);

  await getIt.allReady();
}
