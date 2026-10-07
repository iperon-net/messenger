import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart' as models;

part 'chat_folders_state.mapper.dart';

/// Экран «Папки» и редактор папки: папки пользователя и чаты (для счётчиков и
/// выбора чатов в папку).
@MappableClass()
class ChatFoldersState with ChatFoldersStateMappable {
  final Status status;

  /// Первая — «Все чаты».
  final List<models.ChatFolder> folders;

  /// Все чаты, включая архивные.
  final List<models.Chat> chats;

  const ChatFoldersState({this.status = Status.initialization, this.folders = const [], this.chats = const []});

  /// Папки пользователя — без «Все чаты» (её нельзя менять и двигать).
  List<models.ChatFolder> get userFolders => folders.where((f) => !f.isAll).toList();

  /// Лимит [models.chatFoldersLimit] считается вместе с «Все чаты».
  bool get canCreate => folders.length < models.chatFoldersLimit;

  /// Рекомендованные, которых ещё нет среди папок.
  List<models.ChatFolderPreset> get presets => [
    for (final preset in models.ChatFolderPreset.values)
      if (!folders.any((f) => f.sameRules(preset.folder(id: '', title: '')))) preset,
  ];

  /// Чаты, которые можно включить в папку или исключить из неё: видимые в
  /// списке и не архивные (архивные в папки не попадают) — по дате.
  List<models.Chat> get pickable {
    final list = chats.where((c) => !c.hiddenInList && !c.archived).toList();
    list.sort((a, b) => b.sortDate.compareTo(a.sortDate));
    return list;
  }

  int chatsCount(models.ChatFolder folder) => chats.where((c) => !c.hiddenInList && folder.matches(c)).length;

  models.Chat? chat(String id) => chats.where((c) => c.id == id).firstOrNull;
}
