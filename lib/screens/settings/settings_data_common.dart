import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../components.dart' show formatBytes;
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

// Общее для «Данных и памяти» (Cupertino и Material): подписи, цвета
// категорий и кольцевая диаграмма.

/// Цвета категорий памяти (системная палитра iOS — одинаково на обеих
/// платформах, как в Telegram).
Color storageCategoryColor(models.StorageCategory category) => switch (category) {
  models.StorageCategory.photos => const Color(0xFF007AFF),
  models.StorageCategory.videos => const Color(0xFFAF52DE),
  models.StorageCategory.files => const Color(0xFF34C759),
  models.StorageCategory.audio => const Color(0xFFFF9500),
  models.StorageCategory.other => const Color(0xFF5AC8FA),
};

/// Цвет «Прочего» на диаграмме памяти (база, эмодзи, временные).
const storageServiceColor = Color(0xFF8E8E93);

String storageCategoryTitle(Translations t, models.StorageCategory category) => switch (category) {
  models.StorageCategory.photos => t.screenSettingsData.photos,
  models.StorageCategory.videos => t.screenSettingsData.videos,
  models.StorageCategory.files => t.screenSettingsData.files,
  models.StorageCategory.audio => t.screenSettingsData.audio,
  models.StorageCategory.other => t.screenSettingsData.other,
};

Color trafficCategoryColor(models.TrafficCategory category) => switch (category) {
  models.TrafficCategory.messages => const Color(0xFF007AFF),
  models.TrafficCategory.photos => const Color(0xFF5AC8FA),
  models.TrafficCategory.videos => const Color(0xFFAF52DE),
  models.TrafficCategory.files => const Color(0xFF34C759),
  models.TrafficCategory.audio => const Color(0xFFFF9500),
  models.TrafficCategory.calls => const Color(0xFFFF2D55),
  models.TrafficCategory.other => const Color(0xFF8E8E93),
};

String trafficCategoryTitle(Translations t, models.TrafficCategory category) => switch (category) {
  models.TrafficCategory.messages => t.screenSettingsData.messages,
  models.TrafficCategory.photos => t.screenSettingsData.photos,
  models.TrafficCategory.videos => t.screenSettingsData.videos,
  models.TrafficCategory.files => t.screenSettingsData.files,
  models.TrafficCategory.audio => t.screenSettingsData.audio,
  models.TrafficCategory.calls => t.screenSettingsData.calls,
  models.TrafficCategory.other => t.screenSettingsData.service,
};

String networkTitle(Translations t, models.NetworkKind network) => switch (network) {
  models.NetworkKind.mobile => t.screenSettingsData.mobile,
  models.NetworkKind.wifi => t.screenSettingsData.wifi,
};

/// «Хранить медиа»: 3 дня / 1 неделя / 1 месяц / всегда.
String keepMediaLabel(Translations t, int days) => switch (days) {
  3 => t.screenSettingsData.days3,
  7 => t.screenSettingsData.week,
  30 => t.screenSettingsData.month,
  _ => t.screenSettingsData.forever,
};

/// Предел кэша: «5 ГБ» / «Без ограничений» (варианты — целые гигабайты).
String maxCacheLabel(BuildContext context, int mb) =>
    mb == 0 ? context.t.screenSettingsData.unlimited : '${mb ~/ 1024} ${context.t.screenChat.gb}';

/// «↑ 1,2 МБ · ↓ 34 МБ».
String trafficCounterText(BuildContext context, models.TrafficCounter counter) =>
    '↑ ${formatBytes(context, counter.sent)}  ·  ↓ ${formatBytes(context, counter.received)}';

/// «Статистика с 26 октября 2026 г.».
String trafficSinceText(BuildContext context, DateTime since) {
  final locale = Localizations.maybeLocaleOf(context)?.toLanguageTag();
  return context.t.screenSettingsData.since(date: DateFormat.yMMMMd(locale).format(since.toLocal()));
}

/// Сегмент [UsageDonut].
typedef UsageSegment = ({int value, Color color});

/// Кольцевая диаграмма с подписью в центре (как в «Использовании памяти»
/// Telegram). Нет данных — серое кольцо.
class UsageDonut extends StatelessWidget {
  final List<UsageSegment> segments;
  final Widget center;
  final Color emptyColor;
  final double size;

  const UsageDonut({super.key, required this.segments, required this.center, required this.emptyColor, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutPainter(segments: segments, emptyColor: emptyColor),
        child: Center(
          child: Padding(padding: EdgeInsets.all(size * 0.16), child: center),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<UsageSegment> segments;
  final Color emptyColor;

  _DonutPainter({required this.segments, required this.emptyColor});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.11;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, size.height - stroke);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;
    final total = segments.fold(0, (sum, s) => sum + s.value);
    if (total <= 0) {
      canvas.drawArc(rect, 0, 2 * math.pi, false, paint..color = emptyColor);
      return;
    }
    // Крошечные доли всё равно видны (не меньше [minSweep]), зазор между
    // сегментами — [gap].
    final visible = [
      for (final s in segments)
        if (s.value > 0) s,
    ];
    const gap = 0.035;
    const minSweep = 0.04;
    final available = 2 * math.pi - (visible.length > 1 ? gap * visible.length : 0);
    final sweeps = [for (final s in visible) math.max(minSweep, available * s.value / total)];
    final scale = available / sweeps.fold(0.0, (a, b) => a + b);
    var start = -math.pi / 2;
    for (final (i, s) in visible.indexed) {
      final sweep = sweeps[i] * scale;
      canvas.drawArc(rect, start, sweep, false, paint..color = s.color);
      start += sweep + (visible.length > 1 ? gap : 0);
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.segments != segments || old.emptyColor != emptyColor;
}

/// Цветная точка категории в строке списка.
class UsageDot extends StatelessWidget {
  final Color color;

  const UsageDot(this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// Сегменты диаграммы памяти: типы кэша и «Прочее» (база, эмодзи, временные).
List<UsageSegment> storageSegments(models.StorageReport report) => [
  for (final category in models.StorageCategory.values) (value: report.byCategory[category] ?? 0, color: storageCategoryColor(category)),
  (value: report.database + report.emoji + report.temp, color: storageServiceColor),
];

/// Сегменты диаграммы трафика.
List<UsageSegment> trafficSegments(Map<models.TrafficCategory, models.TrafficCounter> usage) => [
  for (final category in models.TrafficCategory.values) (value: usage[category]?.total ?? 0, color: trafficCategoryColor(category)),
];
