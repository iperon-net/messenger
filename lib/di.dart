import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'crypto/crypto.dart';
import 'firebase_options.dart';
import 'logger.dart';
import 'notifications.dart';
import 'repositories/repositories.dart';
import 'routers.dart';
import 'secure_storage.dart';

GetIt getIt = GetIt.instance;

Future<void> configureGlobalDI() async {

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Crashlytics
  FlutterError.onError = (errorDetails) => FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kReleaseMode){
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      throw error;
    }
    return true;
  };

  // final remoteConfig = FirebaseRemoteConfig.instance;
  //
  // await remoteConfig.setConfigSettings(RemoteConfigSettings(
  //   fetchTimeout: Duration(minutes: 1),
  //   minimumFetchInterval: kDebugMode ? Duration(hours: 1): Duration(hours: 12),
  // ));
  //
  // await remoteConfig.setDefaults(const {});
  // await remoteConfig.fetchAndActivate();

  getIt.registerSingletonAsync<Logger>(() async => Logger());
  getIt.registerSingletonAsync<Crypto>(() async => Crypto(), dependsOn: [Logger]);
  getIt.registerSingletonAsync<Routers>(() async => Routers(), dependsOn: [Logger]);
  getIt.registerSingletonAsync<Notifications>(() async => Notifications()..initialization(), dependsOn: [Logger]);
  getIt.registerSingletonAsync<SecureStorage>(() async => SecureStorage(), dependsOn: [Logger]);
  getIt.registerSingletonAsync<Repositories>(() async => Repositories(), dependsOn: [Logger, SecureStorage]);

  await getIt.allReady();

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();
  await repositories.initialization();

  logger.info("Configure global di initialization");
}
