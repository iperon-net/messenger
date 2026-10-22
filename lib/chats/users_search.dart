import 'dart:async';

import '../di.dart';
import '../models.dart' as models;
import '../utils.dart';
import 'chats_data_source.dart';
import 'chats_sync.dart';

/// Состояние глобального поиска под строкой поиска.
enum UsersSearchStatus {
  /// Запрос не похож ни на номер, ни на username (и группы не ищем / не
  /// нашли) — секции нет.
  idle,
  loading,
  done,

  /// Нет сети — секция объясняет, что глобальный поиск недоступен.
  offline,

  /// Лимит частоты сервера — «попробуйте позже».
  flood,
}

/// Итог одного запроса к серверу: статус и найденное.
typedef UsersSearchPart<T> = ({UsersSearchStatus status, List<T> results});

/// Глобальный поиск по мере ввода: люди (`Chats.SearchUsers`) и, если
/// [chats], публичные группы (`Chats.SearchChats`, как «Глобальный поиск» в
/// Telegram — группы рядом с людьми). С паузой [delay], устаревшие ответы
/// отбрасываются. Результат — в [onChanged]. Общий для «Новое сообщение»,
/// поиска на вкладке «Чаты» (с группами) и «Контакты» (только люди).
class UsersSearch {
  UsersSearch(this.onChanged, {this.chats = false});

  final void Function(UsersSearchStatus status, List<models.ChatMember> people, List<models.Chat> chats) onChanged;

  /// Искать и публичные группы.
  final bool chats;

  static const delay = Duration(milliseconds: 450);

  /// Как у сервера: username — латиница/цифры/«_» от 3 символов (ведущий «@»
  /// не важен), номер — целиком (валидный).
  static final _username = RegExp(r'^@?[a-zA-Z0-9_]{3,24}$');

  /// Похоже на номер телефона (цифры и то, что пишут в номере).
  static final _phoneLike = RegExp(r'^[\d\s()+\-.]+$');

  /// Группы по «@имени»: как у сервера — префикс от 2 символов.
  static final _chatUsername = RegExp(r'^@[a-zA-Z0-9_]{2,32}$');

  /// Разделители слов (как на сервере: всё, что не буква и не цифра).
  static final _wordSeparator = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

  /// Самое длинное слово запроса групп — не короче (как на сервере).
  static const chatsMinWord = 2;

  Timer? _timer;
  int _generation = 0;

  /// Людей ищем только по номеру телефона целиком или username.
  static bool qualifies(String query) {
    final trimmed = query.trim();
    if (_username.hasMatch(trimmed) && !RegExp(r'^\+?\d+$').hasMatch(trimmed)) return true;
    if (!_phoneLike.hasMatch(trimmed)) return false;
    return getIt.get<Utils>().phoneNormalization(phoneNumber: trimmed).e164.isNotEmpty;
  }

  /// Слова запроса так же, как сервер режет название группы: нижний регистр,
  /// ё → е, только буквы и цифры.
  static List<String> words(String text) =>
      text.toLowerCase().replaceAll('ё', 'е').split(_wordSeparator).where((w) => w.isNotEmpty).toList();

  /// Группы ищем по обычным словам (хотя бы одно от [chatsMinWord] символов)
  /// или «@имени»; номер телефона и «/код-фраза» — нет.
  static bool chatsQualify(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty || trimmed.startsWith('/') || _phoneLike.hasMatch(trimmed)) return false;
    if (trimmed.startsWith('@')) return _chatUsername.hasMatch(trimmed);
    return words(trimmed).any((w) => w.runes.length >= chatsMinWord);
  }

  /// Общий статус секции из двух запросов. Люди искались — их статус главный
  /// (как раньше: «нет сети» / «никого не найдено»). Искались только группы —
  /// без сети и без находок секции нет (обычное слово в поиске по чатам не
  /// должно каждый раз показывать «ничего не найдено»), лимит — пояснение.
  static UsersSearchStatus combine(UsersSearchPart<models.ChatMember>? people, UsersSearchPart<models.Chat>? chats) {
    if (people != null) return people.status;
    if (chats == null) return UsersSearchStatus.idle;
    return switch (chats.status) {
      UsersSearchStatus.flood => UsersSearchStatus.flood,
      UsersSearchStatus.done when chats.results.isNotEmpty => UsersSearchStatus.done,
      _ => UsersSearchStatus.idle,
    };
  }

  /// Один запрос к серверу: ошибки — в статус.
  static Future<UsersSearchPart<T>> _run<T>(Future<List<T>> Function() request) async {
    try {
      return (status: UsersSearchStatus.done, results: await request());
    } on ChatsOfflineException {
      return (status: UsersSearchStatus.offline, results: <T>[]);
    } on ChatsFloodException {
      return (status: UsersSearchStatus.flood, results: <T>[]);
    } on ChatsRequestException {
      return (status: UsersSearchStatus.done, results: <T>[]);
    }
  }

  void search(ChatsDataSource? source, String query) {
    _timer?.cancel();
    final generation = ++_generation;
    final trimmed = query.trim();
    final people = source != null && qualifies(trimmed);
    final groups = source != null && chats && chatsQualify(trimmed);
    if (!people && !groups) {
      onChanged(UsersSearchStatus.idle, const [], const []);
      return;
    }
    // Только группы — без «ищем…» (прежняя выдача убирается): обычное слово
    // чаще всего находит свои чаты, секция появляется, лишь когда группы
    // нашлись.
    onChanged(people ? UsersSearchStatus.loading : UsersSearchStatus.idle, const [], const []);
    _timer = Timer(delay, () async {
      final results = await Future.wait<Object?>([
        people ? _run(() => source.searchUsers(trimmed)) : Future.value(),
        groups ? _run(() => source.searchChats(trimmed)) : Future.value(),
      ]);
      if (generation != _generation) return;
      final foundPeople = results[0] as UsersSearchPart<models.ChatMember>?;
      final foundChats = results[1] as UsersSearchPart<models.Chat>?;
      final status = combine(foundPeople, foundChats);
      final done = status == UsersSearchStatus.done;
      onChanged(status, done ? foundPeople?.results ?? const [] : const [], done ? foundChats?.results ?? const [] : const []);
    });
  }

  void cancel() {
    _timer?.cancel();
    _generation++;
  }
}

/// Тап по найденной группе: я участник — её чат (id), иначе — предпросмотр
/// по публичному имени (`resolveLink` → экран чата с «Вступить»); публичный
/// канал — сразу лента без подписки (4.4) с «Подписаться» внизу. Ошибки
/// (`ChatsOfflineException` и т. п.) — вызывающему.
Future<String> resolveFoundChat(ChatsDataSource source, models.Chat chat) async {
  if (chat.isMember) return chat.id;
  if (chat.username.isEmpty) return '';
  return source.resolveLink(chat.username);
}
