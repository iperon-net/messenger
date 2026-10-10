import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../chats/chats_data_source.dart';
import '../../chats/chats_remote_data_source.dart';
import '../../models.dart' as models;

import 'chat_folders_state.dart';

/// «Папки» (Настройки → Папки, long-press по табу папки): создать, изменить,
/// удалить, переставить, добавить рекомендованную. Пока только UX-демо (см.
/// docs/plans/chats-groups-channels.md, «Папки»); на сервере папки —
/// синхронизируемая настройка (как приватность), записям понадобится гард
/// `hasNetwork()`.
class ChatFoldersCubit extends Cubit<ChatFoldersState> {
  ChatFoldersCubit() : super(const ChatFoldersState());

  ChatsDataSource? _source;
  final _subscriptions = <StreamSubscription<Object?>>[];

  void initialization({required bool demo}) {
    _source = chatsDataSource(demo: demo);
    final source = _source;
    if (source == null) {
      emit(state.copyWith(status: Status.success));
      return;
    }
    _subscriptions.addAll([
      source.watchFolders().listen((folders) {
        if (!isClosed) emit(state.copyWith(folders: folders, status: Status.success));
      }),
      source.watchChats().listen((chats) {
        if (!isClosed) emit(state.copyWith(chats: chats));
      }),
    ]);
  }

  /// id для новой папки.
  static String newFolderID() => 'folder_${DateTime.now().microsecondsSinceEpoch}';

  Future<void> save(models.ChatFolder folder) async => _source?.saveFolder(folder.copyWith(title: folder.title.trim()));

  Future<void> delete(models.ChatFolder folder) async => _source?.deleteFolder(folder.id);

  Future<void> addPreset(models.ChatFolderPreset preset, String title) async {
    if (!state.canCreate) return;
    await _source?.saveFolder(preset.folder(id: newFolderID(), title: title));
  }

  /// Перетаскивание в списке [ChatFoldersState.userFolders] (индексы — как у
  /// `ReorderableList.onReorderItem`). Порядок меняем сразу, не дожидаясь
  /// источника, иначе строка на миг прыгнет обратно.
  Future<void> reorder(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;
    final folders = state.userFolders;
    folders.insert(newIndex, folders.removeAt(oldIndex));
    emit(state.copyWith(folders: [...state.folders.where((f) => f.isAll), ...folders]));
    await _source?.reorderFolders(folders.map((f) => f.id).toList());
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
