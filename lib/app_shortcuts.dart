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
/// поиск по чатам, ⌘/Ctrl+N — новое сообщение. Подмешиваются к стандартным
/// клавишам приложения (`MaterialApp.shortcuts` / `actions`); поле ввода
/// перехватывает свои клавиши раньше (см. `ComposeDesktopKeys`).
abstract final class DesktopShortcuts {
  static Map<ShortcutActivator, Intent> shortcuts() => {
    ...WidgetsApp.defaultShortcuts,
    SingleActivator(LogicalKeyboardKey.keyF, meta: _mac, control: !_mac): const _SearchChatsIntent(),
    SingleActivator(LogicalKeyboardKey.keyN, meta: _mac, control: !_mac): const _NewMessageIntent(),
  };

  /// [go] — переход роутера приложения (`GoRouter.go`).
  static Map<Type, Action<Intent>> actions(void Function(String location) go) => {
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
