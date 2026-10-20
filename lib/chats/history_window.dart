/// Окно истории «вокруг сообщения» (подэтап 3.6, хвост 2026-10-20): переход к
/// старому сообщению (найденному поиском, цитате, закрепу), которого нет в
/// скачанной ленте, грузит с сервера окно вокруг него (`History.aroundID`), а
/// не докачивает всё от верха. Окно — непрерывный кусок [low]..[high],
/// оторванный от сверенной части ленты (ниже `historyStaleBelow`): в кэше он
/// лежит скрытым из обычной ленты (`searchHit`), лента чата показывает
/// только его, прокрутка догружает старше ([older]) и новее ([newer]).
/// Дошли новее до сверенной части (или до самого нового) — окно сливается с
/// лентой ([windowJoins]) и всё снова как обычно.
class HistoryWindow {
  final int low;
  final int high;

  /// На сервере есть старше [low] / новее [high].
  final bool older;
  final bool newer;

  const HistoryWindow({required this.low, required this.high, required this.older, required this.newer});

  bool contains(int messageID) => messageID >= low && messageID <= high;

  HistoryWindow copyWith({int? low, int? high, bool? older, bool? newer}) =>
      HistoryWindow(low: low ?? this.low, high: high ?? this.high, older: older ?? this.older, newer: newer ?? this.newer);

  @override
  String toString() => 'HistoryWindow($low..$high, older: $older, newer: $newer)';
}

/// Окно (новее — до [high], [newer] — есть ещё новее) стыкуется с обычной
/// лентой: дошло до самого нового или до сверенной части, которая
/// начинается с [floor] (0 — кэш пуст: стыковаться не с чем, пока не дошли
/// до самого нового).
bool windowJoins({required int high, required bool newer, required int floor}) => !newer || (floor > 0 && high + 1 >= floor);

/// Диапазон, который покрывает страница истории [ids] (по убыванию, как
/// отдаёт сервер): от самого старого (старше нет — от №1) до [upper] (верх
/// запроса), а у страницы без верхней границы — до самого нового в ней.
/// `null` — страница ничего не покрывает (пустая, а старше есть).
({int from, int to})? pageRange(List<int> ids, {required bool hasOlder, int? upper}) {
  if (ids.isEmpty && hasOlder) return null;
  final from = hasOlder ? ids.last : 1;
  final to = upper ?? (ids.isEmpty ? 0 : ids.first);
  if (to < from) return null;
  return (from: from, to: to);
}
