import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'di.dart';
import 'logger.dart';
import 'platform.dart';
import 'protobuf.dart';

/// Настройки приложения. Флаги поведения (секретные чаты, звонки, эмодзи,
/// Яндекс, минимальная версия) берутся по цепочке: `.env` (debug) → настройки
/// с сервера ([serverConfig], `ClientConfig` из админки, этап 5б
/// docs/plans/admin-panel.md) → Remote Config (переходный период) →
/// [_defaults]. Новый [serverConfig] — [notifyListeners].
class Settings extends ChangeNotifier {
  /// Remote Config — только где есть Firebase ([AppPlatform.hasFirebase]); на
  /// десктопе значения берутся из [_defaults] (и `.env`).
  FirebaseRemoteConfig get remoteConfig => FirebaseRemoteConfig.instance;
  final logger = getIt.get<Logger>();

  ClientConfig_Response? _serverConfig;

  /// Последние настройки с сервера (null — ещё не было ни ответа, ни кэша).
  /// Ставит [ClientConfigSync].
  ClientConfig_Response? get serverConfig => _serverConfig;

  set serverConfig(ClientConfig_Response? config) {
    _serverConfig = config;
    notifyListeners();
  }

  static const _defaults = <String, Object>{
    "PUBLIC_KEY_EDDSA_FINGERPRINT": "7abfc2a7e8ea09ae384bdeb855cfeae24d60bfac3646046e754fddc8d5ab604d",
    "YANDEX_OAUTH_CLIENT_ID": "c3ae9f778e734f70ad8b5bc96b419169",
    "API_HOST": "staging.iperon.net",
    "API_PORT": 443,
    "API_SECURE": true,
    "PHONE_NUMBER_MODERATION_APPLICATION_STORE_ENABLE": false,
    "CALL_CONNECT_MAX_ATTEMPTS": 3,
    "CALL_PEER_CONNECTION_TIMEOUT_SECONDS": 7,
    "CALL_RING_TIMEOUT_SECONDS": 45,
    // Анимированные эмодзи (Noto, Lottie JSON): `<url><имя>.json`.
    "ANIMATED_EMOJI_URL": "https://staging-cdn.iperon.net/emoji/noto/",
    // Секретные чаты (E2EE): показывать «Начать секретный чат»; создавать —
    // только Premium. Принимать запросы клиент умеет всегда, флаги — только
    // о создании (то же правило дублирует сервер, secretChats.*).
    "SECRET_CHATS_ENABLED": false,
    "SECRET_CHATS_PREMIUM_ONLY": false,
    // Групповые звонки: «Добавить участника» и «Позвонить нескольким». На
    // старте выключены (только 1-на-1); сервер дублирует — calls.groupEnabled.
    "GROUP_CALLS_ENABLED": false,
  };

  String _getString(String key) => AppPlatform.hasFirebase ? remoteConfig.getString(key) : (_defaults[key] as String? ?? '');
  int _getInt(String key) => AppPlatform.hasFirebase ? remoteConfig.getInt(key) : (_defaults[key] as int? ?? 0);
  bool _getBool(String key) => AppPlatform.hasFirebase ? remoteConfig.getBool(key) : (_defaults[key] as bool? ?? false);

  static Future<Settings> initialization() async {
    final settings = Settings._();
    await settings._initialization();
    return settings;
  }

  Settings._();

  Future<void> _initialization() async {
    // dotenv нужно грузить в ОБОИХ режимах: flutter_dotenv 6.x бросает
    // NotInitializedError на любой dotenv.get(...) даже с fallback, если load()
    // не вызывали. Раньше (до fd0770e) загрузка была безусловной; ограничение
    // её дебагом ломало release-старт (крэш в Repositories на settings.databaseName).
    // isOptional: true — если ассета .env нет, load всё равно инициализирует dotenv,
    // а геттеры откатятся к Remote Config.
    await dotenv.load(isOptional: true);

    if (!AppPlatform.hasFirebase) return;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(fetchTimeout: const Duration(seconds: 30), minimumFetchInterval: const Duration(hours: 24)),
    );

    // Default config
    await remoteConfig.setDefaults(_defaults);

    try {
      await remoteConfig.fetchAndActivate();
    } catch (err) {
      logger.handle(err);
    }
  }

  /// Принудительная загрузка Remote Config мимо интервала 24 ч (меню
  /// «Разработчик»): обычный `fetchAndActivate` на старте берёт кэш, пока он
  /// моложе `minimumFetchInterval`. Возвращает true, если активированы новые
  /// значения. Бросает при ошибке (нет сети, throttling Firebase).
  Future<bool> forceFetchRemoteConfig() async {
    final current = remoteConfig.settings;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: current.fetchTimeout, minimumFetchInterval: Duration.zero));
    try {
      return await remoteConfig.fetchAndActivate();
    } finally {
      await remoteConfig.setConfigSettings(current);
    }
  }

  String get databaseName => dotenv.get('DATABASE_NAME', fallback: "iperon.db");
  bool get isDeleteDatabase => dotenv.getBool('IS_DELETE_DATABASE', fallback: false);
  int get databaseVersion => dotenv.getInt('DATABASE_VERSION', fallback: 1);
  String get publicKeyEDDSAFingerprint => _getString("PUBLIC_KEY_EDDSA_FINGERPRINT");

  /// Флаг: `.env` (только debug) → сервер → Remote Config / [_defaults].
  bool _flag(String key, bool Function(ClientConfig_Response config) server) {
    if (kDebugMode && (dotenv.maybeGet(key) ?? '').isNotEmpty) return dotenv.getBool(key);
    final config = _serverConfig;
    if (config != null) return server(config);
    return _getBool(key);
  }

  /// Число: `.env` → сервер → Remote Config / [_defaults] → [fallback]; ноль
  /// и меньше — «не задано».
  int _number(String key, int server, int fallback) {
    final env = dotenv.getInt(key, fallback: 0);
    if (env > 0) return env;
    if (server > 0) return server;
    final rc = _getInt(key);
    return rc > 0 ? rc : fallback;
  }

  /// Яндекс ID: client_id с сервера (по нему он и сверяет токен), иначе из
  /// сборки. Нативная часть (URL-схема `yx<id>`, manifestPlaceholders) — в
  /// сборке, поэтому id должен совпадать.
  String get yandexOauthClientID {
    final server = _serverConfig?.yandexClientId ?? '';
    if (server.isNotEmpty) return server;
    return _getString("YANDEX_OAUTH_CLIENT_ID");
  }

  /// Сборка старше этой версии («0.0.570») должна обновиться; '' — без
  /// ограничения. Только с сервера.
  String get minimalVersion => _serverConfig?.minimalVersion ?? '';

  /// Откуда докачивать анимированные эмодзи, которых нет в приложении
  /// (`<url><имя>.json`, имена — как в пакете animated_emoji).
  String get animatedEmojiUrl {
    final res = dotenv.get('ANIMATED_EMOJI_URL', fallback: "");
    if (res.isNotEmpty) return res;
    final server = _serverConfig?.animatedEmojiUrl ?? '';
    if (server.isNotEmpty) return server;
    return _getString("ANIMATED_EMOJI_URL");
  }

  String get apiHost {
    final res = dotenv.get('API_HOST', fallback: "");
    if (res.isNotEmpty) return res;
    return _getString("API_HOST");
  }

  int get apiPort {
    final res = dotenv.getInt('API_PORT', fallback: 0);
    if (res > 0) return res;
    return _getInt("API_PORT");
  }

  bool get apiSecure {
    if (kDebugMode) return dotenv.getBool('API_SECURE', fallback: true);
    return _getBool("API_SECURE");
  }

  /// Номера с постоянным кодом (ревьюер стора и тестовые аккаунты стенда,
  /// `testAccounts` сервера): вход без звонка. Через запятую; первый — номер
  /// ревьюера (кнопка «вставить номер» в debug).
  List<String> get phoneNumbersModerationApplicationStore {
    var res = dotenv.get('PHONE_NUMBER_MODERATION_APPLICATION_STORE', fallback: "");
    if (res.isEmpty) res = _getString("PHONE_NUMBER_MODERATION_APPLICATION_STORE");
    return [
      for (final number in res.split(','))
        if (number.trim().isNotEmpty) number.trim(),
    ];
  }

  String get phoneNumberModerationApplicationStore => phoneNumbersModerationApplicationStore.firstOrNull ?? '';

  bool get phoneNumberModerationApplicationStoreEnable {
    if (kDebugMode) {
      return dotenv.getBool('PHONE_NUMBER_MODERATION_APPLICATION_STORE_ENABLE', fallback: false);
    }
    return _getBool("PHONE_NUMBER_MODERATION_APPLICATION_STORE_ENABLE");
  }

  /// Показывать «Начать секретный чат».
  bool get secretChatsEnabled => _flag('SECRET_CHATS_ENABLED', (config) => config.secretChatsEnabled);

  /// Групповые звонки. Выключены — нет «Добавить участника» и «Позвонить
  /// нескольким»; приглашения в чужой групповой звонок по-прежнему принимаются.
  bool get groupCallsEnabled => _flag('GROUP_CALLS_ENABLED', (config) => config.groupCallsEnabled);

  /// Создавать секретные чаты может только Premium (принять — любой).
  bool get secretChatsPremiumOnly => _flag('SECRET_CHATS_PREMIUM_ONLY', (config) => config.secretChatsPremiumOnly);

  /// Сколько раз пробовать начальный connect к комнате LiveKit перед провалом
  /// звонка (см. `Calls._connectRoom`).
  int get callConnectMaxAttempts => _number('CALL_CONNECT_MAX_ATTEMPTS', _serverConfig?.callConnectMaxAttempts ?? 0, 3);

  /// Таймаут установления PeerConnection (ICE) для connect к комнате LiveKit, в
  /// секундах. Укорочен относительно дефолтных 10 с SDK ради живых повторов.
  int get callPeerConnectionTimeoutSeconds =>
      _number('CALL_PEER_CONNECTION_TIMEOUT_SECONDS', _serverConfig?.callPeerConnectionTimeoutSeconds ?? 0, 7);

  /// Сколько секунд звоним абоненту, прежде чем автоматически отменить исходящий
  /// недозвон (звонящий шлёт `CALL_HANGUP` → сервер снимает у абонента баннер
  /// входящего cancel-пушем). Без этого баннер у абонента висит, пока звонящий
  /// не нажмёт отбой вручную.
  int get callRingTimeoutSeconds => _number('CALL_RING_TIMEOUT_SECONDS', _serverConfig?.callRingTimeoutSeconds ?? 0, 45);
}
