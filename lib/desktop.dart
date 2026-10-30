import 'dart:async';
import 'dart:io';

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

  /// Контекстное меню поля ввода — системное `NSMenu`, как у `NSTextView`
  /// (macOS). [items] — пункты приложения (вырезать / скопировать / вставить,
  /// «Форматирование»), [extra] — после «Правописания»; «Найти», «Искать в
  /// Google», «Поделиться», «Речь» и правописание натив собирает сам по
  /// выделенному [selected] и всему тексту [text] (выделение — [selection]).
  /// Ответ: выбранный пункт приложения, замена выделения (вариант исправления)
  /// или что выделить (найденная ошибка); `null` — закрыли / сделал натив.
  static Future<DesktopTextMenuChoice?> showTextMenu({
    required List<DesktopMenuItem> items,
    List<DesktopMenuItem> extra = const [],
    required String selected,
    required String text,
    required TextSelection selection,
  }) async {
    final t = LocaleSettings.instance.currentTranslations.screenChat.textMenu;
    final answer = await _invoke<Map<Object?, Object?>>('showTextMenu', {
      'items': [for (final item in items) item.toMap()],
      'extra': [for (final item in extra) item.toMap()],
      'selected': selected,
      'text': text,
      'selection': [selection.start, selection.end],
      'titles': {
        'lookUp': t.lookUp(text: '{text}'),
        'searchGoogle': t.searchGoogle,
        'share': t.share,
        'spelling': t.spelling,
        'checkNow': t.checkNow,
        'learnSpelling': t.learnSpelling,
        'ignoreSpelling': t.ignoreSpelling,
        'noGuesses': t.noGuesses,
        'speech': t.speech,
        'startSpeaking': t.startSpeaking,
        'stopSpeaking': t.stopSpeaking,
      },
    });
    if (answer == null) return null;
    final select = answer['select'];
    return (
      id: answer['id'] as String?,
      replace: answer['replace'] as String?,
      select: select is List && select.length == 2 ? TextSelection(baseOffset: select[0] as int, extentOffset: select[1] as int) : null,
    );
  }

  /// Показать файл [path] выделенным в Finder / Проводнике. `false` — не вышло.
  static Future<bool> revealFile(String path) async {
    if (Platform.isWindows) {
      // `explorer` выходит с кодом 1 и при успехе — его не проверяем.
      try {
        await Process.run('explorer', ['/select,', path]);
        return true;
      } catch (error, stackTrace) {
        _logger.handle(error, stackTrace, 'desktop: revealFile');
        return false;
      }
    }
    return await _invoke<bool>('revealFile', {'path': path}) ?? false;
  }

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

/// Выбор в [Desktop.showTextMenu]: пункт приложения [id], замена выделения
/// [replace] или новое выделение [select].
typedef DesktopTextMenuChoice = ({String? id, String? replace, TextSelection? select});

/// Пункт приложения в системном меню [Desktop.showTextMenu]: [icon] — SF Symbol
/// (видно с macOS 26), [key] — ⌘-сочетание (только подпись), [children] —
/// подменю.
class DesktopMenuItem {
  final String id;
  final String title;
  final bool enabled;
  final bool checked;
  final String icon;
  final String key;
  final List<DesktopMenuItem>? children;
  final bool _separator;

  const DesktopMenuItem(this.id, this.title, {this.enabled = true, this.checked = false, this.icon = '', this.key = '', this.children})
    : _separator = false;

  const DesktopMenuItem.separator()
    : id = '',
      title = '',
      enabled = false,
      checked = false,
      icon = '',
      key = '',
      children = null,
      _separator = true;

  Map<String, Object?> toMap() => _separator
      ? {'separator': true}
      : {
          'id': id,
          'title': title,
          'enabled': enabled,
          'checked': checked,
          if (icon.isNotEmpty) 'icon': icon,
          'key': key,
          if (children case final children?) 'children': [for (final child in children) child.toMap()],
        };
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
