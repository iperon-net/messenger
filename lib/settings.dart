import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'bootstrap/bootstrap_config.dart';
import 'bootstrap/bootstrap_file.dart';
import 'di.dart';
import 'logger.dart';
import 'protobuf.dart';

/// Настройки приложения. Флаги поведения (секретные чаты, звонки, эмодзи,
/// Яндекс, минимальная версия) берутся по цепочке: `.env` (debug) → настройки
/// с сервера ([serverConfig], `ClientConfig` из админки, этап 5б
/// docs/plans/admin-panel.md) → [_defaults] (сборка). Новый [serverConfig] — [notifyListeners]. Адрес сервера —
/// окружения активного аккаунта ([environment]) из bootstrap-файла
/// ([BootstrapConfig]).
class Settings extends ChangeNotifier {
  final logger = getIt.get<Logger>();

  ClientConfig_Response? _serverConfig;

  /// Последние настройки с сервера (null — ещё не было ни ответа, ни кэша).
  /// Ставит [ClientConfigSync].
  ClientConfig_Response? get serverConfig => _serverConfig;

  set serverConfig(ClientConfig_Response? config) {
    _serverConfig = config;
    notifyListeners();
  }

  /// Окружение (сервер) активного аккаунта: `production` / `staging`. Ставит
  /// `openAccount` до создания `API` аккаунта.
  String environment = BootstrapConfig.builtIn.defaultEnvironment;

  /// Основной адрес окружения [environment].
  BootstrapApi get _api => BootstrapConfig.environment(environment).api.first;

  static const _defaults = <String, Object>{
    "YANDEX_OAUTH_CLIENT_ID": "c3ae9f778e734f70ad8b5bc96b419169",
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

  String _getString(String key) => _defaults[key] as String? ?? '';
  int _getInt(String key) => _defaults[key] as int? ?? 0;
  bool _getBool(String key) => _defaults[key] as bool? ?? false;

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
    // isOptional: true — если ассета .env нет, load всё равно инициализирует dotenv.
    await dotenv.load(isOptional: true);
  }

  String get databaseName => dotenv.get('DATABASE_NAME', fallback: "iperon.db");
  bool get isDeleteDatabase => dotenv.getBool('IS_DELETE_DATABASE', fallback: false);
  int get databaseVersion => dotenv.getInt('DATABASE_VERSION', fallback: 1);
  String get publicKeyEDDSAFingerprint => BootstrapConfig.environment(environment).serverKeyFingerprint;

  /// Флаг: `.env` (только debug) → сервер → [_defaults].
  bool _flag(String key, bool Function(ClientConfig_Response config) server) {
    if (kDebugMode && (dotenv.maybeGet(key) ?? '').isNotEmpty) return dotenv.getBool(key);
    final config = _serverConfig;
    if (config != null) return server(config);
    return _getBool(key);
  }

  /// Число: `.env` → сервер → [_defaults] → [fallback]; ноль
  /// и меньше — «не задано».
  int _number(String key, int server, int fallback) {
    final env = dotenv.getInt(key, fallback: 0);
    if (env > 0) return env;
    if (server > 0) return server;
    final built = _getInt(key);
    return built > 0 ? built : fallback;
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

  /// Адрес сервера: `.env` (`API_HOST` / `API_PORT` / `API_SECURE` — для
  /// любого окружения) → окружение активного аккаунта.
  String get apiHost {
    final res = dotenv.get('API_HOST', fallback: "");
    if (res.isNotEmpty) return res;
    return _api.host;
  }

  int get apiPort {
    final res = dotenv.getInt('API_PORT', fallback: 0);
    if (res > 0) return res;
    return _api.port;
  }

  bool get apiSecure {
    if (kDebugMode && (dotenv.maybeGet('API_SECURE') ?? '').isNotEmpty) return dotenv.getBool('API_SECURE');
    return _api.secure;
  }

  /// Номер для кнопки «вставить номер» на экране входа в debug (`.env`,
  /// первый через запятую): тестовый аккаунт стенда (`testAccounts` сервера,
  /// вход без звонка — сервер сам отвечает `fixedCode`).
  String get debugPhoneNumber {
    final res = dotenv.get('PHONE_NUMBER_MODERATION_APPLICATION_STORE', fallback: "");
    return res.split(',').first.trim();
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
