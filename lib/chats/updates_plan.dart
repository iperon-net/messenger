/// Решение по журналу обновлений (pts), как в Telegram: у каждого
/// пользователя свой журнал без дыр, клиент помнит последний применённый pts.
/// Чистая логика без БД и сети — её проверяют тесты (`test/chats/`), а
/// применяет `ChatsSync`.
library;

/// Что делать с одним обновлением при локальном pts.
enum PtsAction {
  /// Уже применено (повтор: ответ на запрос + тот же push по стриму).
  skip,

  /// Следующее по порядку — применить и сдвинуть pts.
  apply,

  /// Пропущены обновления между — догнать через GET_DIFFERENCE.
  gap,
}

/// [updatePts] == 0 — обновление вне журнала (сервер не присвоил номер):
/// применяем без сдвига pts (применение идемпотентно).
PtsAction ptsAction(int localPts, int updatePts) {
  if (updatePts <= 0) return PtsAction.apply;
  if (updatePts <= localPts) return PtsAction.skip;
  if (updatePts == localPts + 1) return PtsAction.apply;
  return PtsAction.gap;
}

/// План применения пачки обновлений ([Updates] из ответа или push).
class UpdatesPlan {
  /// Индексы обновлений пачки, которые применить (по порядку pts).
  final List<int> apply;

  /// pts после применения [apply].
  final int pts;

  /// Есть дыра — после применения [apply] догнать через GET_DIFFERENCE.
  final bool gap;

  const UpdatesPlan({required this.apply, required this.pts, required this.gap});
}

/// [updatesPts] — pts обновлений пачки (в любом порядке), [statePts] — `state.pts`
/// пачки (0 — не задан). Применяем подряд идущие за [localPts]; первое с
/// дырой и всё после него — уже через GET_DIFFERENCE (он вернёт их снова).
/// `state.pts` больше применённого — между нами и сервером есть ещё
/// обновления, которых в пачке нет (пришли другим путём или потерялись), —
/// тоже дыра.
UpdatesPlan planUpdates(int localPts, List<int> updatesPts, {int statePts = 0}) {
  final order = List<int>.generate(updatesPts.length, (i) => i)..sort((a, b) => updatesPts[a].compareTo(updatesPts[b]));
  final apply = <int>[];
  var pts = localPts;
  var gap = false;
  for (final i in order) {
    final action = ptsAction(pts, updatesPts[i]);
    if (action == PtsAction.skip) continue;
    if (action == PtsAction.gap) {
      gap = true;
      break;
    }
    apply.add(i);
    if (updatesPts[i] > 0) pts = updatesPts[i];
  }
  if (!gap && statePts > pts) gap = true;
  return UpdatesPlan(apply: apply, pts: pts, gap: gap);
}
