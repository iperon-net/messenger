import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import '../api.dart';
import '../di.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../protobuf.dart';
import '../protobuf/protos/chats_v1.pb.dart' as pb;
import 'chats_mapping.dart';
import '../account_scope.dart';

/// «Печатает…» / «отправляет фото…» — эфемерные сигналы `CHAT_TYPING` по
/// стриму (см. `ChatTyping` в chats_v1.proto). Ничего не хранится: всё в
/// памяти, без сети и в фоне сигналов просто нет.
///
/// Входящие: кто что делает в каком чате. Запись живёт [_ttl], если
/// отправитель её не продлил, снимается его отменой и сразу — новым
/// сообщением от него ([clear], зовёт `ChatsSync`). Список чатов и окно чата
/// подмешивают это в `Chat.typing` (`ChatsRemoteDataSource.watchChats`).
///
/// Исходящие: [typing] — на каждый ввод в поле (не чаще [_resend]);
/// [begin] / [end] — долгие действия (запись голосового, сжатие и загрузка
/// вложений), пока идут — повторяются раз в [_resend]; [cancel] — поле
/// очистили или сообщение ушло. Долгое действие главнее набора текста.
class ChatsTyping {
  /// Аккаунт этого сервиса: зависимости берутся из него, а не из «текущего» —
  /// после переключения аккаунта незавершённые операции не уйдут в чужой.
  final AccountScope _scope = AccountScope.current;

  ChatsTyping._() {
    _subscription = _api.on(MessageType.CHAT_TYPING).listen(_onSignal);
  }

  static ChatsTyping get instance => AccountScope.current.resolve(ChatsTyping._);

  /// Отправитель повторяет сигнал, пока действие идёт (чуть меньше 5 с —
  /// таймер и ввод не совпадают по фазе).
  static const _resend = Duration(milliseconds: 4500);

  /// У получателя запись без продления — как в Telegram (6 с).
  static const _ttl = Duration(seconds: 6);

  API get _api => _scope.api;
  Logger get _logger => getIt.get<Logger>();

  // ignore: unused_field
  late final StreamSubscription<Uint8List> _subscription;

  // --- входящие ---

  /// hex chatID → hex userID → действие и срок. Порядок — кто начал раньше.
  final _active = <String, LinkedHashMap<String, ({models.ChatActivity activity, DateTime until})>>{};
  Timer? _expiry;

  final _changed = StreamController<void>.broadcast();

  /// Изменилось, кто что делает (список и окно чата перерисовывают шапку).
  Stream<void> get changed => _changed.stream;

  /// Кто что делает в чате [chatID] (hex), по порядку начала.
  List<({String userID, models.ChatActivity activity})> of(String chatID) => [
    for (final entry in _active[chatID]?.entries ?? const <MapEntry<String, ({models.ChatActivity activity, DateTime until})>>[])
      (userID: entry.key, activity: entry.value.activity),
  ];

  /// Новое сообщение от [userID] в [chatID] — он больше не печатает.
  void clear(List<int> chatID, List<int> userID) {
    if (_remove(idHex(chatID), idHex(userID))) _changed.add(null);
  }

  void _onSignal(Uint8List payload) {
    final pb.ChatTyping signal;
    try {
      signal = pb.ChatTyping.fromBuffer(payload);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
      return;
    }
    final chatID = idHex(signal.chatID);
    final userID = idHex(signal.userID);
    if (chatID.isEmpty || userID.isEmpty) return;
    // В группе сервер рассылает сигнал всем в subject чата — и нам самим.
    if (userID == idHex(_scope.auth.session.userID)) return;
    final activity = _activityOf(signal.action);
    if (activity == null) {
      if (_remove(chatID, userID)) _changed.add(null);
      return;
    }
    final users = _active.putIfAbsent(chatID, LinkedHashMap.new);
    final changed = users[userID]?.activity != activity;
    // Повтор того же — только продление (место в порядке сохраняется).
    users[userID] = (activity: activity, until: DateTime.now().add(_ttl));
    _scheduleExpiry();
    if (changed) _changed.add(null);
  }

  bool _remove(String chatID, String userID) {
    final users = _active[chatID];
    if (users == null || users.remove(userID) == null) return false;
    if (users.isEmpty) _active.remove(chatID);
    return true;
  }

  /// Снять просроченные и завести таймер на ближайший срок.
  void _scheduleExpiry() {
    _expiry?.cancel();
    _expiry = null;
    final now = DateTime.now();
    var removed = false;
    DateTime? next;
    for (final chatID in _active.keys.toList()) {
      final users = _active[chatID]!;
      users.removeWhere((_, entry) {
        final expired = !entry.until.isAfter(now);
        removed |= expired;
        return expired;
      });
      if (users.isEmpty) {
        _active.remove(chatID);
        continue;
      }
      for (final entry in users.values) {
        if (next == null || entry.until.isBefore(next)) next = entry.until;
      }
    }
    if (removed) _changed.add(null);
    if (next != null) _expiry = Timer(next.difference(now), _scheduleExpiry);
  }

  static models.ChatActivity? _activityOf(pb.ChatTyping_Action action) => switch (action) {
    pb.ChatTyping_Action.TYPING => models.ChatActivity.typing,
    pb.ChatTyping_Action.RECORD_VOICE => models.ChatActivity.recordVoice,
    pb.ChatTyping_Action.UPLOAD_PHOTO => models.ChatActivity.uploadPhoto,
    pb.ChatTyping_Action.UPLOAD_VIDEO => models.ChatActivity.uploadVideo,
    pb.ChatTyping_Action.UPLOAD_FILE => models.ChatActivity.uploadFile,
    _ => null,
  };

  static pb.ChatTyping_Action _actionOf(models.ChatActivity activity) => switch (activity) {
    models.ChatActivity.typing => pb.ChatTyping_Action.TYPING,
    models.ChatActivity.recordVoice => pb.ChatTyping_Action.RECORD_VOICE,
    models.ChatActivity.uploadPhoto => pb.ChatTyping_Action.UPLOAD_PHOTO,
    models.ChatActivity.uploadVideo => pb.ChatTyping_Action.UPLOAD_VIDEO,
    models.ChatActivity.uploadFile => pb.ChatTyping_Action.UPLOAD_FILE,
  };

  // --- исходящие ---

  /// Последнее отправленное в чат (hex chatID): что и когда.
  final _sent = <String, ({models.ChatActivity activity, DateTime at})>{};

  /// Идущие долгие действия по чатам; показываем последнее начатое.
  final _ongoing = <String, List<ChatTypingHandle>>{};
  Timer? _resendTimer;

  /// Отмена после конца долгого действия — с задержкой: следом обычно
  /// начинается следующее (сжатие видео → загрузка), и индикатор у
  /// собеседника не должен мигать.
  final _endCancels = <String, Timer>{};
  static const _endCancelDelay = Duration(seconds: 1);

  /// Ввод в поле чата [chatID] (hex).
  void typing(String chatID) {
    if (_ongoing[chatID]?.isNotEmpty ?? false) return;
    // Загрузка только что кончилась, а уже печатают — её отмена не нужна.
    _endCancels.remove(chatID)?.cancel();
    _send(chatID, models.ChatActivity.typing);
  }

  /// Началось долгое действие в чате [chatID] (hex); парный вызов — [end].
  ChatTypingHandle begin(String chatID, models.ChatActivity activity) {
    _endCancels.remove(chatID)?.cancel();
    final handle = ChatTypingHandle._(chatID, activity);
    _ongoing.putIfAbsent(chatID, () => []).add(handle);
    _send(chatID, activity);
    _resendTimer ??= Timer.periodic(_resend, (_) => _resendOngoing());
    return handle;
  }

  /// Долгое действие закончилось: осталось другое — показываем его, нет —
  /// отмена.
  void end(ChatTypingHandle handle) {
    final list = _ongoing[handle.chatID];
    if (list == null || !list.remove(handle)) return;
    if (list.isEmpty) {
      _ongoing.remove(handle.chatID);
      if (_ongoing.isEmpty) {
        _resendTimer?.cancel();
        _resendTimer = null;
      }
      _endCancels.remove(handle.chatID)?.cancel();
      _endCancels[handle.chatID] = Timer(_endCancelDelay, () {
        _endCancels.remove(handle.chatID);
        cancel(handle.chatID);
      });
    } else {
      _send(handle.chatID, list.last.activity);
    }
  }

  /// Поле очистили / сообщение ушло: снять «печатает…» (долгие действия —
  /// загрузка, запись — продолжаются и остаются).
  void cancel(String chatID) {
    _endCancels.remove(chatID)?.cancel();
    final ongoing = _ongoing[chatID];
    if (ongoing != null && ongoing.isNotEmpty) {
      if (_sent[chatID]?.activity != ongoing.last.activity) _send(chatID, ongoing.last.activity);
      return;
    }
    final sent = _sent.remove(chatID);
    // Ничего не слали или у получателя уже истекло — отменять нечего.
    if (sent == null || DateTime.now().difference(sent.at) >= _ttl) return;
    _post(chatID, pb.ChatTyping_Action.CANCEL);
  }

  void _resendOngoing() {
    for (final MapEntry(key: chatID, value: list) in _ongoing.entries) {
      if (list.isNotEmpty) _send(chatID, list.last.activity);
    }
  }

  /// Не чаще [_resend] для того же действия; другое — сразу.
  void _send(String chatID, models.ChatActivity activity) {
    final last = _sent[chatID];
    final now = DateTime.now();
    if (last != null && last.activity == activity && now.difference(last.at) < _resend) return;
    if (!_post(chatID, _actionOf(activity))) return;
    _sent[chatID] = (activity: activity, at: now);
  }

  /// Отправить сигнал; false — стрима нет (фон / нет сети), не ушло.
  bool _post(String chatID, pb.ChatTyping_Action action) {
    final chat = idBytes(chatID);
    if (chat.length != 12 || _api.connectionStatus != ApiConnectionStatus.connected) return false;
    unawaited(
      _api
          .sendEncoded(MessageType.CHAT_TYPING, pb.ChatTyping(chatID: chat, action: action).writeToBuffer())
          .catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace)),
    );
    return true;
  }
}

/// Идущее долгое действие ([ChatsTyping.begin] → [ChatsTyping.end]).
final class ChatTypingHandle {
  final String chatID;
  final models.ChatActivity activity;

  ChatTypingHandle._(this.chatID, this.activity);
}
