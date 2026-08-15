
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'di.dart';
import 'logger.dart';

class Settings {
  final remoteConfig = FirebaseRemoteConfig.instance;
  final logger = getIt.get<Logger>();

  static Future<Settings> initialization() async {
    final settings = Settings._();
    await settings._initialization();
    return settings;
  }

  Settings._();

  Future<void> _initialization() async {
    await dotenv.load(
        isOptional: true,
        overrideWithFiles: kDebugMode ? [".env.development"] : [],
    );

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    // Default config
    await remoteConfig.setDefaults(const {
      "PUBLIC_KEY_EDDSA_FINGERPRINT": "7abfc2a7e8ea09ae384bdeb855cfeae24d60bfac3646046e754fddc8d5ab604d",
      "YANDEX_OAUTH_CLIENT_ID": "a001e23bf51b4743a3f408473d5f85cd",
      "API_HOST": "staging.iperon.net",
      "API_PORT": 443,
      "API_SECURE": true,
      "PHONE_NUMBER_MODERATION_APPLICATION_STORE_ENABLE": false,
    });

    try {
      await remoteConfig.fetchAndActivate();
    } catch (err) {
      logger.handle(err);
    }

  }

  String get databaseName => dotenv.get('DATABASE_NAME', fallback: "iperon.db");
  bool get isDeleteDatabase => dotenv.getBool('IS_DELETE_DATABASE', fallback: false);
  int get databaseVersion => dotenv.getInt('DATABASE_VERSION', fallback: 1);
  String get publicKeyEDDSAFingerprint => remoteConfig.getString("PUBLIC_KEY_EDDSA_FINGERPRINT");
  String get yandexOauthClientID => remoteConfig.getString("YANDEX_OAUTH_CLIENT_ID");

  String get apiHost {
    final res = dotenv.get('API_HOST', fallback: "");
    if (res.isNotEmpty) return res;
    return remoteConfig.getString("API_HOST");
  }

  int get apiPort {
    final res = dotenv.getInt('API_PORT', fallback: 0);
    if (res > 0) return res;
    return remoteConfig.getInt("API_PORT");
  }

  bool get apiSecure {
    if(kDebugMode) return dotenv.getBool('API_SECURE', fallback: true);
    return remoteConfig.getBool("API_SECURE");
  }

  String get phoneNumberModerationApplicationStore {
    final res = dotenv.get('PHONE_NUMBER_MODERATION_APPLICATION_STORE', fallback: "");
    if (res.isNotEmpty) return res;
    return remoteConfig.getString("PHONE_NUMBER_MODERATION_APPLICATION_STORE");
  }

  bool get phoneNumberModerationApplicationStoreEnable {
    if(kDebugMode) return dotenv.getBool('PHONE_NUMBER_MODERATION_APPLICATION_STORE_ENABLE', fallback: false);
    return remoteConfig.getBool("PHONE_NUMBER_MODERATION_APPLICATION_STORE_ENABLE");
  }

}
