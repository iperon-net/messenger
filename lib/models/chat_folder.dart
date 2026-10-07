import 'package:dart_mappable/dart_mappable.dart';

import 'chat.dart';

part 'chat_folder.mapper.dart';

/// Максимум папок у пользователя (вместе с «Все чаты»).
const chatFoldersLimit = 10;

/// Папка (таб) списка чатов, по модели Telegram: включённые типы чатов, явно
/// добавленные/исключённые чаты и флаги исключения. Первая папка всегда
/// «Все чаты» ([isAll]).
@MappableClass()
class ChatFolder with ChatFolderMappable {
  final String id;

  /// Название. Для [isAll] не используется — берётся локализованное.
  final String title;

  final bool isAll;

  final bool includeContacts;
  final bool includeNonContacts;
  final bool includeGroups;
  final bool includeChannels;
  final bool includeCommunities;

  final List<String> includeChatIDs;
  final List<String> excludeChatIDs;

  final bool excludeMuted;
  final bool excludeRead;

  const ChatFolder({
    required this.id,
    this.title = '',
    this.isAll = false,
    this.includeContacts = false,
    this.includeNonContacts = false,
    this.includeGroups = false,
    this.includeChannels = false,
    this.includeCommunities = false,
    this.includeChatIDs = const [],
    this.excludeChatIDs = const [],
    this.excludeMuted = false,
    this.excludeRead = false,
  });

  /// В папку что-то включено (типы или чаты) — без этого папку не сохранить.
  bool get hasIncludes =>
      includeContacts || includeNonContacts || includeGroups || includeChannels || includeCommunities || includeChatIDs.isNotEmpty;

  /// Те же правила отбора, без учёта id и названия: рекомендованная папка уже
  /// добавлена.
  bool sameRules(ChatFolder other) => copyWith(id: '', title: '') == other.copyWith(id: '', title: '');

  /// Попадает ли чат в папку. Архивные чаты в папки не попадают — они живут в
  /// «Архиве».
  bool matches(Chat chat) {
    if (chat.archived) return false;
    if (isAll) return true;
    if (excludeChatIDs.contains(chat.id)) return false;
    if (includeChatIDs.contains(chat.id)) return true;
    if (excludeMuted && chat.muted) return false;
    if (excludeRead && !chat.hasUnread) return false;
    return switch (chat.type) {
      ChatType.private => chat.isContact ? includeContacts : includeNonContacts,
      ChatType.group => includeGroups,
      ChatType.channel => includeChannels,
      ChatType.community => includeCommunities,
    };
  }
}

/// Рекомендованные папки экрана «Папки» (как в Telegram): добавляются одной
/// кнопкой и пропадают из рекомендаций, пока такая папка уже есть.
enum ChatFolderPreset {
  unread,
  personal,
  groups,
  channels;

  ChatFolder folder({required String id, required String title}) => switch (this) {
    unread => ChatFolder(
      id: id,
      title: title,
      includeContacts: true,
      includeNonContacts: true,
      includeGroups: true,
      includeChannels: true,
      includeCommunities: true,
      excludeRead: true,
    ),
    personal => ChatFolder(id: id, title: title, includeContacts: true, includeNonContacts: true),
    groups => ChatFolder(id: id, title: title, includeGroups: true),
    channels => ChatFolder(id: id, title: title, includeChannels: true),
  };
}
