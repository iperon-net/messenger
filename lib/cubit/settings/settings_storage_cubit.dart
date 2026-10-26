import 'package:bloc/bloc.dart';

import '../../chats/chats_remote_data_source.dart';
import '../../chats/secret/secret_chats_list.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../storage_usage.dart';
import 'settings_storage_state.dart';

/// «Использование памяти»: подсчёт кэша по типам и чатам, очистка, «Хранить
/// медиа» и предел размера. Всё локальное — сеть не нужна.
class SettingsStorageCubit extends Cubit<SettingsStorageState> {
  SettingsStorageCubit() : super(const SettingsStorageState());

  final logger = getIt.get<Logger>();
  final storage = StorageUsage.instance;

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    try {
      final keepMediaDays = await storage.keepMediaDays();
      final maxCacheMB = await storage.maxCacheMB();
      if (isClosed) return;
      emit(state.copyWith(keepMediaDays: keepMediaDays, maxCacheMB: maxCacheMB));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    await refresh();
  }

  /// Пересчитать.
  Future<void> refresh() async {
    try {
      final report = await storage.scan();
      final chats = await _chatItems(report);
      if (isClosed) return;
      emit(state.copyWith(status: Status.success, report: report, chats: chats));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      if (!isClosed) emit(state.copyWith(status: Status.success, report: state.report ?? const models.StorageReport()));
    }
  }

  /// Чаты отчёта с заголовками и аватарами из списка; которых в списке нет —
  /// одной строкой «Другие чаты».
  Future<List<StorageChatItem>> _chatItems(models.StorageReport report) async {
    if (report.chats.isEmpty) return const [];
    final known = <String, models.Chat>{};
    try {
      for (final chat in [...await ChatsRemoteDataSource.instance.loadChats(), ...await loadSecretChats()]) {
        known[chat.id] = chat;
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    final items = <StorageChatItem>[];
    final otherIDs = <String>[];
    var otherBytes = 0;
    for (final usage in report.chats) {
      final chat = known[usage.chatID];
      if (chat == null) {
        otherIDs.add(usage.chatID);
        otherBytes += usage.bytes;
      } else {
        items.add(StorageChatItem(chat: chat, chatIDs: [usage.chatID], bytes: usage.bytes));
      }
    }
    if (otherIDs.isNotEmpty) items.add(StorageChatItem(chatIDs: otherIDs, bytes: otherBytes));
    return items;
  }

  void toggle(models.StorageCategory category) {
    final selected = {...state.selected};
    if (!selected.remove(category)) selected.add(category);
    emit(state.copyWith(selected: selected));
  }

  /// «Очистить кэш» выбранных типов.
  Future<void> clearSelected() => _clear(() => storage.clear(categories: state.selected));

  /// Все файлы чата (строки «Чаты»).
  Future<void> clearChat(StorageChatItem item) =>
      _clear(() => storage.clear(categories: {...models.StorageCategory.values}, chatIDs: item.chatIDs.toSet()));

  Future<void> clearEmoji() => _clear(storage.clearEmoji);

  Future<void> clearTemp() => _clear(storage.clearTemp);

  Future<void> _clear(Future<int> Function() run) async {
    if (state.clearing) return;
    emit(state.copyWith(clearing: true));
    try {
      await run();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    await refresh();
    if (!isClosed) emit(state.copyWith(clearing: false));
  }

  Future<void> setKeepMediaDays(int days) async {
    emit(state.copyWith(keepMediaDays: days));
    await storage.setKeepMediaDays(days);
  }

  Future<void> setMaxCacheMB(int mb) async {
    emit(state.copyWith(maxCacheMB: mb));
    await storage.setMaxCacheMB(mb);
  }
}
