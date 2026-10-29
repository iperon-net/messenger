import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Быстрые действия долгого тапа по иконке приложения (как в Telegram):
/// «Новое сообщение», «Поиск», «Избранное». Объявлены нативно — Android
/// `res/xml/shortcuts.xml`, iOS `UIApplicationShortcutItems` в `Info.plist` — и
/// приходят в Dart тем же путём, что тап по уведомлению (`shortcut` в данных
/// тапа, [PushManager]): так же ждут готовности Dart и роутера.
abstract final class AppShortcuts {
  static const newMessage = 'new_message';
  static const search = 'search';
  static const savedMessages = 'saved_messages';

  /// «Поиск» ждёт вкладку «Чаты»: она поднимает строку поиска и ставит в неё
  /// фокус (не под экраном код-пароля), затем сбрасывает флаг.
  static final searchRequested = ValueNotifier<bool>(false);
}

/// Горячие клавиши окна на десктопе (как в Telegram Desktop): ⌘/Ctrl+F —
/// поиск по чатам, ⌘/Ctrl+N — новое сообщение, Esc — закрыть верхнее
/// (см. [_EscapeAction]). Подмешиваются к стандартным
/// клавишам приложения (`MaterialApp.shortcuts` / `actions`); поле ввода
/// перехватывает свои клавиши раньше (см. `ComposeDesktopKeys`).
abstract final class DesktopShortcuts {
  static Map<ShortcutActivator, Intent> shortcuts() => {
    ...WidgetsApp.defaultShortcuts,
    SingleActivator(LogicalKeyboardKey.keyF, meta: _mac, control: !_mac): const _SearchChatsIntent(),
    SingleActivator(LogicalKeyboardKey.keyN, meta: _mac, control: !_mac): const _NewMessageIntent(),
    // Вместо стандартного DismissIntent: тот закрывает только диалоги и меню.
    const SingleActivator(LogicalKeyboardKey.escape): const _EscapeIntent(),
  };

  /// [go] — переход роутера приложения (`GoRouter.go`), [location] — его
  /// текущий путь.
  static Map<Type, Action<Intent>> actions(void Function(String location) go, String Function() location) => {
    ...WidgetsApp.defaultActions,
    _SearchChatsIntent: CallbackAction<_SearchChatsIntent>(
      onInvoke: (_) {
        AppShortcuts.searchRequested.value = true;
        go('/chats');
        return null;
      },
    ),
    _NewMessageIntent: CallbackAction<_NewMessageIntent>(
      onInvoke: (_) {
        go('/chats/new');
        return null;
      },
    ),
    _EscapeIntent: _EscapeAction(location),
  };

  // ⌘ на macOS, Ctrl на Windows / Linux.
  static bool get _mac => Platform.isMacOS;
}

class _SearchChatsIntent extends Intent {
  const _SearchChatsIntent();
}

class _NewMessageIntent extends Intent {
  const _NewMessageIntent();
}

class _EscapeIntent extends Intent {
  const _EscapeIntent();
}

/// Esc: открыт диалог, меню или лист — закрывает его (как стандартный
/// DismissIntent); иначе «назад» на экране с фокусом — снимает выделение и
/// поиск в чате (их `PopScope`), закрывает экран, а чат в правой панели — до
/// заглушки «Выберите чат». Отмену ответа / правки ловит поле ввода раньше
/// (`ComposeDesktopKeys`), очистку поиска — `SearchFieldMaterial`. Экран
/// звонка Esc не закрывает.
class _EscapeAction extends Action<_EscapeIntent> {
  _EscapeAction(this.location);

  final String Function() location;

  @override
  Object? invoke(_EscapeIntent intent) {
    final context = primaryFocus?.context;
    if (context == null) return null;
    const dismiss = DismissIntent();
    // У экрана (не диалога) DismissIntent тоже есть, но выключен.
    final action = Actions.maybeFind<DismissIntent>(context, intent: dismiss);
    if (action != null && action.isEnabled(dismiss)) return Actions.invoke(context, dismiss);
    if (location() == '/call') return null;
    return Navigator.maybeOf(context)?.maybePop();
  }
}
