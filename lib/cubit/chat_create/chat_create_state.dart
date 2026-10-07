import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart' as models;

part 'chat_create_state.mapper.dart';

/// Проверка публичного имени (ссылки) в форме создания канала/сообщества.
@MappableEnum()
enum ChatUsernameStatus { empty, invalid, checking, available, taken }

/// Состояние экранов «Новое»: «Новое сообщение» (контакты), выбор участников
/// группы и форма создания группы/канала/сообщества — она же форма «Изменить»
/// в профиле чата ([chatID] не пуст).
@MappableClass()
class ChatCreateState with ChatCreateStateMappable {
  final Status status;

  /// Что создаём (на «Новом сообщении» — [models.ChatType.private]).
  final models.ChatType type;

  /// Редактируемый чат («Изменить»); пусто — создание.
  final String chatID;

  /// Исходные название и описание — для полей формы «Изменить».
  final String title;
  final String about;

  /// Контакты по алфавиту (фильтр по [query] — в [filtered]).
  final List<models.ChatMember> contacts;
  final String query;

  /// Выбранные участники группы — в порядке выбора (чипы сверху).
  final List<models.ChatMember> selected;

  /// Фото чата — локальный файл (пусто — без фото).
  final String avatarPath;

  /// Как вступить: [models.ChatJoinMode.open] — публичный (по ссылке
  /// [username]), иначе — по [inviteLink] (у `admins` ссылки нет). При
  /// создании и у канала — только open / link («Публичный / Частный»).
  final models.ChatJoinMode joinMode;
  final String username;

  /// Текущее публичное имя редактируемого чата — оно «свободно» без проверки.
  final String originalUsername;

  /// Роль вступивших (группа/сообщество, «Изменить»).
  final models.ChatRole defaultRole;

  /// Канал: комментарии под постами и подписи авторов («Изменить»).
  final bool commentsEnabled;
  final bool signMessages;

  /// Список участников / подписчиков — только админам («Изменить»).
  final bool membersHidden;
  final ChatUsernameStatus usernameStatus;

  /// Ссылка-приглашение частного чата (`+код`) — выдаётся сразу, при создании.
  final String inviteLink;

  /// Идёт создание (кнопка «Создать» — индикатор).
  final bool creating;

  /// id созданного / открытого чата — экран переходит в него.
  final String openChatID;

  /// «Изменить» сохранено — экран закрывается.
  final bool saved;

  const ChatCreateState({
    this.status = Status.initialization,
    this.type = models.ChatType.private,
    this.chatID = '',
    this.title = '',
    this.about = '',
    this.contacts = const [],
    this.query = '',
    this.selected = const [],
    this.avatarPath = '',
    this.joinMode = models.ChatJoinMode.link,
    this.username = '',
    this.originalUsername = '',
    this.defaultRole = models.ChatRole.reader,
    this.commentsEnabled = false,
    this.signMessages = false,
    this.membersHidden = false,
    this.usernameStatus = ChatUsernameStatus.empty,
    this.inviteLink = '',
    this.creating = false,
    this.openChatID = '',
    this.saved = false,
  });

  bool get isEdit => chatID.isNotEmpty;

  /// Публичный — по ссылке [username].
  bool get isPublic => joinMode == models.ChatJoinMode.open;

  List<models.ChatMember> get filtered {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return contacts;
    return contacts.where((m) => m.name.toLowerCase().contains(q)).toList();
  }

  bool isSelected(models.ChatMember member) => selected.any((m) => m.id == member.id);

  /// Ссылку можно использовать: частный чат или свободное публичное имя.
  bool get linkReady => !isPublic || usernameStatus == ChatUsernameStatus.available;
}
