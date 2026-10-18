import 'dart:async';

import '../di.dart';
import '../models.dart' as models;
import '../utils.dart';
import 'chats_data_source.dart';
import 'chats_sync.dart';

/// Состояние глобального поиска людей под строкой поиска.
enum UsersSearchStatus {
  /// Запрос не похож ни на номер, ни на username — секции нет.
  idle,
  loading,
  done,

  /// Нет сети — секция объясняет, что глобальный поиск недоступен.
  offline,

  /// Лимит частоты сервера — «попробуйте позже».
  flood,
}

/// Глобальный поиск людей (`Chats.SearchUsers`) по мере ввода: с паузой
/// [delay], устаревшие ответы отбрасываются. Результат — в [onChanged]. Общий
/// для «Новое сообщение» и поиска на вкладке «Чаты».
class UsersSearch {
  UsersSearch(this.onChanged);

  final void Function(UsersSearchStatus status, List<models.ChatMember> results) onChanged;

  static const delay = Duration(milliseconds: 450);

  /// Как у сервера: username — латиница/цифры/«_» от 3 символов (ведущий «@»
  /// не важен), номер — целиком (валидный).
  static final _username = RegExp(r'^@?[a-zA-Z0-9_]{3,24}$');

  Timer? _timer;
  int _generation = 0;

  /// Номер телефона целиком или username — иначе на сервер не ходим.
  static bool qualifies(String query) {
    final trimmed = query.trim();
    if (_username.hasMatch(trimmed) && !RegExp(r'^\+?\d+$').hasMatch(trimmed)) return true;
    if (!RegExp(r'^[\d\s()+\-.]+$').hasMatch(trimmed)) return false;
    return getIt.get<Utils>().phoneNormalization(phoneNumber: trimmed).e164.isNotEmpty;
  }

  void search(ChatsDataSource? source, String query) {
    _timer?.cancel();
    final generation = ++_generation;
    final trimmed = query.trim();
    if (source == null || !qualifies(trimmed)) {
      onChanged(UsersSearchStatus.idle, const []);
      return;
    }
    onChanged(UsersSearchStatus.loading, const []);
    _timer = Timer(delay, () async {
      UsersSearchStatus status;
      var results = const <models.ChatMember>[];
      try {
        results = await source.searchUsers(trimmed);
        status = UsersSearchStatus.done;
      } on ChatsOfflineException {
        status = UsersSearchStatus.offline;
      } on ChatsFloodException {
        status = UsersSearchStatus.flood;
      } on ChatsRequestException {
        status = UsersSearchStatus.done;
      }
      if (generation == _generation) onChanged(status, results);
    });
  }

  void cancel() {
    _timer?.cancel();
    _generation++;
  }
}
