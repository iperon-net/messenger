import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import '../api.dart';
import '../di.dart';
import '../logger.dart';
import '../protobuf.dart';
import '../repositories.dart';
import 'chats_mapping.dart';

/// «В сети» собеседников личных чатов. Сервер шлёт PRESENCE-push только тем,
/// у кого человек в контактах, поэтому для открытого окна чата (собеседник
/// может быть и не в контактах) присутствие спрашиваем сами: при открытии,
/// после переподключения и раз в [_pollInterval], пока окно открыто. То же —
/// для собеседников всех личных чатов, пока открыт список ([setListPeers]):
/// зелёная точка у аватара. Push'и (контакты) тоже ловим. Видимость гейтит сервер («Время захода»): скрыто —
/// item не приходит, показываем «был(а) недавно».
///
/// `online` эфемерный — только в памяти; время захода пишем в кэш профилей
/// (`profiles.lastSeenAt`), оттуда его берёт список чатов (и без сети).
class ChatsPresence {
  ChatsPresence._();

  static final ChatsPresence instance = ChatsPresence._();

  static const _pollInterval = Duration(seconds: 30);

  /// Сервер принимает до 1024 userID за запрос.
  static const _batchLimit = 1000;

  API get _api => getIt.get<API>();
  Logger get _logger => getIt.get<Logger>();

  /// Кто сейчас в сети (hex userID). Нет записи — не в сети / неизвестно.
  final _online = <String>{};

  /// Открытые окна: hex userID → (байты, сколько окон смотрят).
  final _watched = <String, ({Uint8List userID, int count})>{};

  /// Собеседники личных чатов из списка чатов (hex userID → байты).
  var _listPeers = <String, Uint8List>{};

  final _changed = StreamController<void>.broadcast();
  StreamSubscription<Uint8List>? _pushSubscription;
  StreamSubscription<ApiConnectionStatus>? _connectionSubscription;
  Timer? _poll;

  /// Изменилось «в сети» у кого-то — список чатов / окно перечитывают.
  Stream<void> get changed => _changed.stream;

  bool isOnline(String userID) => _online.contains(userID);

  /// Окно чата с [userID] открыто — держим его присутствие свежим. Парный
  /// вызов — [unwatch].
  void watch(Uint8List userID) {
    _start();
    final key = idHex(userID);
    final current = _watched[key];
    _watched[key] = (userID: userID, count: (current?.count ?? 0) + 1);
    if (current == null) unawaited(_refresh([userID]));
    _ensurePoll();
  }

  /// Список чатов показан с собеседниками [userIDs] — держим их «в сети»
  /// свежим; новые в списке спрашиваем сразу. Пустой список — перестать.
  void setListPeers(Iterable<Uint8List> userIDs) {
    final next = {for (final userID in userIDs) idHex(userID): userID};
    final added = [
      for (final entry in next.entries)
        if (!_listPeers.containsKey(entry.key) && !_watched.containsKey(entry.key)) entry.value,
    ];
    _listPeers = next;
    if (next.isNotEmpty) {
      _start();
      _ensurePoll();
    } else {
      _stopPollIfIdle();
    }
    if (added.isNotEmpty) unawaited(_refresh(added));
  }

  void _ensurePoll() => _poll ??= Timer.periodic(_pollInterval, (_) => _refreshWatched());

  void _stopPollIfIdle() {
    if (_watched.isNotEmpty || _listPeers.isNotEmpty) return;
    _poll?.cancel();
    _poll = null;
  }

  void unwatch(Uint8List userID) {
    final key = idHex(userID);
    final current = _watched[key];
    if (current == null) return;
    if (current.count > 1) {
      _watched[key] = (userID: current.userID, count: current.count - 1);
      return;
    }
    _watched.remove(key);
    _stopPollIfIdle();
  }

  void _start() {
    _pushSubscription ??= _api.on(MessageType.PRESENCE).listen((payload) {
      _apply(Presence_Response.fromBuffer(payload).items);
    });
    // Стрим переподключился (в т.ч. вернулись из фона) — онлайн мог устареть.
    _connectionSubscription ??= _api.connectionStatusStream.listen((status) {
      if (status == ApiConnectionStatus.connected) _refreshWatched();
    });
  }

  void _refreshWatched() {
    // Стрима нет (фон, нет сети) — не дёргаем сервер впустую; после
    // переподключения освежит connectionStatusStream.
    if (_api.connectionStatus != ApiConnectionStatus.connected) return;
    final userIDs = {for (final w in _watched.values) idHex(w.userID): w.userID, ..._listPeers};
    if (userIDs.isEmpty) return;
    unawaited(_refresh(userIDs.values.toList()));
  }

  Future<void> _refresh(List<Uint8List> userIDs) async {
    if (userIDs.isEmpty) return;
    if (userIDs.length > _batchLimit) {
      for (var i = 0; i < userIDs.length; i += _batchLimit) {
        await _refresh(userIDs.sublist(i, min(i + _batchLimit, userIDs.length)));
      }
      return;
    }
    final (status, payload) = await _api.unaryEncodedWithResponse(MessageType.PRESENCE, Presence_Request(userIDs: userIDs).writeToBuffer());
    // Нет сети — остаёмся на прошлом (онлайн снимет следующий удачный опрос).
    if (status.status != APIStatus.success || payload == null) return;
    final items = Presence_Response.fromBuffer(payload).items;
    // Не пришёл — скрыт от нас: не «в сети».
    final returned = {for (final item in items) idHex(item.userID)};
    var changed = false;
    for (final userID in userIDs) {
      final key = idHex(userID);
      if (!returned.contains(key) && _online.remove(key)) changed = true;
    }
    _apply(items, changed: changed);
  }

  void _apply(List<Presence_Item> items, {bool changed = false}) {
    for (final item in items) {
      final key = idHex(item.userID);
      changed = (item.online ? _online.add(key) : _online.remove(key)) || changed;
      // В сети — lastSeen это срок онлайн-метки (в будущем), не время захода.
      final seconds = item.lastSeen.toInt();
      if (!item.online && seconds > 0) {
        unawaited(
          getIt
              .get<Repositories>()
              .profiles
              .updateLastSeen(userID: item.userID, lastSeen: DateTime.fromMillisecondsSinceEpoch(seconds * 1000))
              .catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace)),
        );
      }
    }
    if (changed) _changed.add(null);
  }
}
