import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'api.dart';
import 'di.dart';
import 'i18n/translations.g.dart';
import 'logger.dart';
import 'platform.dart';

/// Связь с окном и системой на десктопе (docs/plans/desktop-client.md, этап 3)
/// через канал `net.iperon.messenger/desktop` (macOS — `MainFlutterWindow.swift`):
/// счётчик на значке, значок в строке меню, системные уведомления, бездействие
/// пользователя, запуск при входе в систему. На мобильных вызовы ничего не делают.
abstract final class Desktop {
  static const _channel = MethodChannel('net.iperon.messenger/desktop');

  static Logger get _logger => getIt.get<Logger>();

  static void Function(String route)? _routeHandler;
  static String? _pendingRoute;

  /// Переход по тапу на уведомление (корень приложения ставит `goRouter.go`).
  /// Тап, пришедший раньше обработчика, отдаётся при установке.
  static set onRoute(void Function(String route)? handler) {
    _routeHandler = handler;
    final pending = _pendingRoute;
    if (handler != null && pending != null) {
      _pendingRoute = null;
      handler(pending);
    }
  }

  /// Старт (main.dart): тапы по уведомлениям и разрешение на них — системный
  /// вопрос один раз, при первом запуске.
  static Future<void> start() async {
    if (!AppPlatform.isDesktop) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'notificationTap') return;
      final route = (call.arguments as Map?)?['route'] as String?;
      if (route == null) return;
      final handler = _routeHandler;
      if (handler == null) {
        _pendingRoute = route;
      } else {
        handler(route);
      }
    });
    // Значок в строке меню: подписи пунктов — на языке приложения.
    unawaited(_setTrayMenu());
    LocaleSettings.getLocaleStream().listen((_) => unawaited(_setTrayMenu()));
    await _invoke<bool>('requestNotifications');
    DesktopPresence.instance.start();
  }

  static Future<void> _setTrayMenu() {
    final t = LocaleSettings.instance.currentTranslations.screenSettings;
    return _invoke<void>('setTrayMenu', {'open': t.trayOpen, 'quit': t.trayQuit, 'updates': t.trayUpdates});
  }

  /// Число непрочитанных чатов на значке в Dock и в строке меню; 0 — убрать.
  static Future<void> setBadge(int count) => _invoke<void>('setBadge', {'count': count});

  /// Системное уведомление о сообщении; тап открывает [route] (без него — просто
  /// окно вперёд). [thread] — группировка в Центре уведомлений (чат), [id] —
  /// повтор с тем же заменяет.
  static Future<void> showNotification({
    required String id,
    required String title,
    required String body,
    String? route,
    String? thread,
  }) async {
    await _invoke<bool>('showNotification', {'id': id, 'title': title, 'body': body, 'route': ?route, 'thread': ?thread});
    // Значок в Dock подпрыгнет один раз (как у Telegram).
    await _invoke<void>('requestAttention');
  }

  /// Убрать уведомление [id] из Центра уведомлений.
  static Future<void> removeNotification(String id) => _invoke<void>('removeNotification', {'id': id});

  /// Окно вперёд; [attention] — значок в Dock прыгает, пока приложение не
  /// откроют ([cancelAttention]).
  static Future<void> showWindow({bool attention = false}) => _invoke<void>('showWindow', {'attention': attention});

  static Future<void> cancelAttention() => _invoke<void>('cancelAttention');

  /// Секунд без ввода (клавиатура, мышь) во всей системе; `null` — неизвестно.
  static Future<double?> idleSeconds() => _invoke<double>('idleSeconds');

  /// Ширина списка чатов (левой панели), выбранная перетаскиванием; `null` —
  /// по умолчанию.
  static Future<double?> listWidth() => _invoke<double>('listWidth');

  static Future<void> setListWidth(double? width) => _invoke<void>('setListWidth', {'width': width});

  /// Проверить обновления (Sparkle; в debug и без ключа — ничего).
  static Future<void> checkForUpdates() => _invoke<void>('checkForUpdates');

  /// Тихая проверка обновления (Sparkle, без окна): версия новой сборки, `''` —
  /// новее нет (или проверка не удалась), `null` — автообновление в этой
  /// сборке выключено (debug, нет ключа Sparkle).
  static Future<String?> latestVersion() => _invoke<String>('latestVersion');

  static Future<bool> launchAtLogin() async => await _invoke<bool>('launchAtLogin') ?? false;

  /// Включить / выключить запуск при входе в систему: `enabled` / `disabled`
  /// или `requiresApproval` — macOS ждёт разрешения в «Объектах входа» (настройки
  /// уже открыты). Бросает, если система отказала.
  static Future<String> setLaunchAtLogin(bool enabled) async =>
      await _channel.invokeMethod<String>('setLaunchAtLogin', {'enabled': enabled}) ?? 'disabled';

  /// Доступ к камере / микрофону (`camera` | `microphone`); не десктоп или
  /// ошибка — [MediaAccess.denied].
  static Future<MediaAccess> mediaAccess(MediaKind kind) async => switch (await _invoke<String>('mediaAccess', {'kind': kind.name})) {
    'granted' => MediaAccess.granted,
    'notDetermined' => MediaAccess.notDetermined,
    _ => MediaAccess.denied,
  };

  /// Системный запрос доступа (покажется, только если ещё не спрашивали).
  static Future<bool> requestMediaAccess(MediaKind kind) async => await _invoke<bool>('requestMediaAccess', {'kind': kind.name}) ?? false;

  /// Устройства вывода звука (UID CoreAudio и имя).
  static Future<List<({String id, String name})>> audioOutputs() async {
    final list = await _invoke<List<Object?>>('audioOutputs') ?? const [];
    return [
      for (final item in list.whereType<Map<Object?, Object?>>()) (id: item['id'] as String? ?? '', name: item['name'] as String? ?? ''),
    ];
  }

  /// Проиграть файл [path] через устройство [device] (UID; пусто — системное).
  static Future<void> playTestSound(String path, {String device = ''}) => _invoke<void>('playTestSound', {'path': path, 'device': device});

  /// Системные настройки конфиденциальности для [kind] — включить доступ после
  /// отказа можно только там.
  static Future<void> openPrivacySettings(MediaKind kind) => _invoke<void>('openPrivacySettings', {'kind': kind.name});

  static Future<T?> _invoke<T>(String method, [Map<String, Object?>? arguments]) async {
    if (!AppPlatform.isDesktop) return null;
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace, 'desktop: $method');
      return null;
    }
  }
}

enum MediaKind { camera, microphone }

enum MediaAccess { granted, denied, notDetermined }

/// «В сети» на десктопе (как в Telegram Desktop). Стрим держится, пока
/// приложение запущено (уведомления только по нему), но онлайн сессия — лишь
/// пока человек за компьютером: окно в фокусе (или потеряло его меньше
/// [_unfocusedGrace] назад) и в системе был ввод за последние [_idleLimit].
/// Иначе сервер снимает presence (APP_STATE), и на телефон снова идут пуши.
class DesktopPresence {
  DesktopPresence._();

  static final instance = DesktopPresence._();

  static const _idleLimit = Duration(minutes: 5);
  static const _unfocusedGrace = Duration(minutes: 1);
  static const _poll = Duration(seconds: 30);

  Timer? _timer;
  bool _focused = true;
  DateTime? _unfocusedAt;

  void start() {
    if (_timer != null) return;
    // Слушатель живёт всё время работы приложения, как и сам сервис.
    AppLifecycleListener(onStateChange: _onState);
    _timer = Timer.periodic(_poll, (_) => unawaited(_update()));
  }

  void _onState(AppLifecycleState state) {
    final focused = state == AppLifecycleState.resumed;
    if (focused == _focused) return;
    _focused = focused;
    _unfocusedAt = focused ? null : DateTime.now();
    unawaited(_update());
  }

  Future<void> _update() async {
    if (!getIt.isRegistered<API>()) return;
    final unfocusedAt = _unfocusedAt;
    final atWindow = _focused || (unfocusedAt != null && DateTime.now().difference(unfocusedAt) < _unfocusedGrace);
    final idle = await Desktop.idleSeconds();
    final active = atWindow && (idle == null || idle < _idleLimit.inSeconds);
    if (getIt.isRegistered<API>()) getIt.get<API>().setPresenceActive(active);
  }
}
