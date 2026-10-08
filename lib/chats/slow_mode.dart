// Медленный режим группы/сообщества (см. docs/plans/chats-groups-channels.md,
// «Медленный режим»): участник без прав админа отправляет не чаще одного
// сообщения за интервал.

/// Интервалы на выбор, в секундах (как в Telegram); 0 — выключен.
const slowModeOptions = [0, 10, 30, 60, 300, 900, 3600];

/// Оставшееся до следующего сообщения: «0:25», «14:59», «1:00:00».
String formatSlowModeLeft(int seconds) {
  final h = seconds ~/ 3600;
  final m = seconds % 3600 ~/ 60;
  final s = (seconds % 60).toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
}
