import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart';

part 'settings_storage_state.mapper.dart';

/// Строка «Чаты» в «Использовании памяти»: чат из списка или, если его там
/// нет (ветки комментариев, удалённые из списка), — «Другие чаты» сразу за
/// всех ([chat] `null`).
@MappableClass()
class StorageChatItem with StorageChatItemMappable {
  final Chat? chat;
  final List<String> chatIDs;
  final int bytes;

  const StorageChatItem({this.chat, this.chatIDs = const [], this.bytes = 0});
}

@MappableClass()
class SettingsStorageState with SettingsStorageStateMappable {
  final Status status;

  /// Последний подсчёт; `null` — ещё считаем.
  final StorageReport? report;
  final List<StorageChatItem> chats;

  /// Выбранные к очистке типы (все по умолчанию).
  final Set<StorageCategory> selected;

  /// «Хранить медиа», дней (0 — всегда).
  final int keepMediaDays;

  /// Предел размера кэша, МБ (0 — без ограничений).
  final int maxCacheMB;

  /// Идёт очистка (кнопки неактивны).
  final bool clearing;

  const SettingsStorageState({
    this.status = Status.initialization,
    this.report,
    this.chats = const [],
    this.selected = const {...StorageCategory.values},
    this.keepMediaDays = 0,
    this.maxCacheMB = 0,
    this.clearing = false,
  });

  /// Сколько освободит «Очистить кэш» с выбранными типами (без фото профилей).
  int get selectedBytes {
    final report = this.report;
    if (report == null) return 0;
    var bytes = 0;
    for (final category in selected) {
      bytes += report.byCategory[category] ?? 0;
    }
    if (selected.contains(StorageCategory.other)) bytes -= report.protectedBytes;
    return bytes < 0 ? 0 : bytes;
  }
}
