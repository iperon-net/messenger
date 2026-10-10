import 'package:dart_mappable/dart_mappable.dart';

import '../../chats/coordinates.dart';
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

  /// Группа / канал внутри этого сообщества: своих ссылок нет, вступление —
  /// одним нажатием ([models.ChatJoinMode.open]) или по заявке.
  final String communityID;

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

  /// Обложка сообщества — локальный файл (пусто — генеративный фон).
  final String coverPath;

  /// Контакты заведения сообщества; [latitude] / [longitude] — как в полях
  /// ввода, разбираются при сохранении.
  final String phone;
  final String address;
  final String latitude;
  final String longitude;

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

  /// Канал: «Срок комментирования» новых постов, секунд (0 — без ограничения).
  final int commentsTimeLimit;

  /// Канал: кто может комментировать и (только подписчики) минимальный срок
  /// подписки, секунд (0 — без ограничения).
  final models.ChatCommentsWho commentsWho;
  final int commentsMinSubscription;

  /// «Новичкам — без ссылок и медиа»: срок, секунд (0 — выключено).
  final int newcomerMediaDelay;

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

  /// Растёт, когда действие не выполнено из-за отсутствия сети
  /// (`ChatsOfflineException`): экран показывает «Нет соединения».
  final int offlineNotice;

  /// Сервер отказал по лимиту частоты новых чатов: растёт на каждый отказ,
  /// [floodSeconds] — через сколько можно снова (экран показывает пояснение).
  final int floodNotice;
  final int floodSeconds;

  const ChatCreateState({
    this.status = Status.initialization,
    this.offlineNotice = 0,
    this.floodNotice = 0,
    this.floodSeconds = 0,
    this.type = models.ChatType.private,
    this.chatID = '',
    this.communityID = '',
    this.title = '',
    this.about = '',
    this.contacts = const [],
    this.query = '',
    this.selected = const [],
    this.avatarPath = '',
    this.coverPath = '',
    this.phone = '',
    this.address = '',
    this.latitude = '',
    this.longitude = '',
    this.joinMode = models.ChatJoinMode.link,
    this.username = '',
    this.originalUsername = '',
    this.defaultRole = models.ChatRole.reader,
    this.commentsEnabled = false,
    this.signMessages = false,
    this.commentsTimeLimit = 0,
    this.commentsWho = models.ChatCommentsWho.all,
    this.commentsMinSubscription = 0,
    this.newcomerMediaDelay = 0,
    this.membersHidden = false,
    this.usernameStatus = ChatUsernameStatus.empty,
    this.inviteLink = '',
    this.creating = false,
    this.openChatID = '',
    this.saved = false,
  });

  bool get isEdit => chatID.isNotEmpty;

  bool get inCommunity => communityID.isNotEmpty;

  /// Публичный — по ссылке [username] (у чата сообщества ссылок нет).
  bool get isPublic => joinMode == models.ChatJoinMode.open && !inCommunity;

  List<models.ChatMember> get filtered {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return contacts;
    return contacts.where((m) => m.name.toLowerCase().contains(q)).toList();
  }

  bool isSelected(models.ChatMember member) => selected.any((m) => m.id == member.id);

  /// Ссылку можно использовать: частный чат или свободное публичное имя.
  bool get linkReady => !isPublic || usernameStatus == ChatUsernameStatus.available;

  double? get latitudeValue => parseCoordinate(latitude, limit: 90);
  double? get longitudeValue => parseCoordinate(longitude, limit: 180);

  /// Координаты не заданы вовсе или заданы обе и верно.
  bool get coordinatesValid => (latitude.trim().isEmpty && longitude.trim().isEmpty) || (latitudeValue != null && longitudeValue != null);
}
