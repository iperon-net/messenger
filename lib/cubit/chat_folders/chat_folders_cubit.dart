import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../repositories/repositories.dart';
import '../../chats/chats_data_source.dart';
import '../../chats/chats_remote_data_source.dart';
import '../../chats/chats_sync.dart';
import '../../models.dart' as models;

import 'chat_folders_state.dart';

/// «Папки» (Настройки → Папки, long-press по табу папки): создать, изменить,
/// удалить, переставить, добавить рекомендованную. В настоящих чатах папки —
/// серверная настройка (см. docs/plans/chats-groups-channels.md, «Папки»):
/// без сети изменения не делаются — методы возвращают false, экран
/// показывает «Нет соединения».
class ChatFoldersCubit extends Cubit<ChatFoldersState> {
  ChatFoldersCubit() : super(const ChatFoldersState());

  ChatsDataSource? _source;
  final _subscriptions = <StreamSubscription<Object?>>[];

  /// Последние папки от источника — вернуть порядок, если перестановка не
  /// ушла на сервер.
  List<models.ChatFolder> _sourceFolders = const [];

  void initialization({required bool demo}) {
    _source = chatsDataSource(demo: demo);
    final source = _source;
    if (source == null) {
      emit(state.copyWith(status: Status.success));
      return;
    }
    _subscriptions.addAll([
      source.watchFolders().listen((folders) {
        _sourceFolders = folders;
        if (!isClosed) emit(state.copyWith(folders: folders, status: Status.success));
      }),
      source.watchChats().listen((chats) {
        if (!isClosed) emit(state.copyWith(chats: chats));
      }),
      getIt.get<Repositories>().hiddenProfiles.changes.listen((_) => _reloadHidden()),
    ]);
    _reloadHidden();
  }

  /// Локально скрытые профили — личные чаты с ними в папках не участвуют.
  Future<void> _reloadHidden() async {
    try {
      final hidden = await getIt.get<Repositories>().hiddenProfiles.hashByHex();
      if (!isClosed) emit(state.copyWith(hiddenPeers: hidden.keys.toSet()));
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    }
  }

  /// id для новой папки (настоящий выдаст сервер).
  static String newFolderID() => 'folder_${DateTime.now().microsecondsSinceEpoch}';

  Future<bool> save(models.ChatFolder folder) => _online(() => _source?.saveFolder(folder.copyWith(title: folder.title.trim())));

  Future<bool> delete(models.ChatFolder folder) => _online(() => _source?.deleteFolder(folder.id));

  Future<bool> addPreset(models.ChatFolderPreset preset, String title) async {
    if (!state.canCreate) return true;
    return _online(() => _source?.saveFolder(preset.folder(id: newFolderID(), title: title)));
  }

  /// Перетаскивание в списке [ChatFoldersState.userFolders] (индексы — как у
  /// `ReorderableList.onReorderItem`). Порядок меняем сразу, не дожидаясь
  /// источника, иначе строка на миг прыгнет обратно, — поэтому сеть
  /// проверяем заранее (без сети строка остаётся на месте).
  Future<bool> reorder(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return true;
    final source = _source;
    if (source == null) return true;
    if (source is ChatsRemoteDataSource && !await ChatsSync.instance.hasNetwork()) return false;
    final folders = state.userFolders;
    folders.insert(newIndex, folders.removeAt(oldIndex));
    emit(state.copyWith(folders: [...state.folders.where((f) => f.isAll), ...folders]));
    final ok = await _online(() => source.reorderFolders(folders.map((f) => f.id).toList()));
    if (!ok && !isClosed) emit(state.copyWith(folders: _sourceFolders));
    return ok;
  }

  /// false — не выполнено: нет сети.
  Future<bool> _online(Future<void>? Function() action) async {
    try {
      await action();
      return true;
    } on ChatsOfflineException {
      return false;
    }
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
