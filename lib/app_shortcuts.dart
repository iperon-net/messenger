import 'package:flutter/foundation.dart';

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
