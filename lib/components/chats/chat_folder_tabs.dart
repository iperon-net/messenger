import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

export 'chat_folder_tabs_cupertino.dart';
export 'chat_folder_tabs_material.dart';

/// Таб папки: название и бейдж непрочитанных ([badge] = 0 — без бейджа).
class ChatFolderTab {
  final String title;
  final int badge;

  /// Все непрочитанные чаты папки заглушены — бейдж серый.
  final bool badgeMuted;

  const ChatFolderTab({required this.title, this.badge = 0, this.badgeMuted = false});
}

/// Платформенное оформление полосы табов (см. `ChatFolderTabsCupertino` /
/// `ChatFolderTabsMaterial`).
class ChatFolderTabsStyle {
  final double height;
  final Color trackColor;
  final BoxBorder? trackBorder;
  final double trackRadius;

  /// Отступ бегунка от края дорожки (у iOS-сегмента 2 pt).
  final double inset;

  final Color thumbColor;
  final double thumbRadius;
  final List<BoxShadow> thumbShadow;
  final TextStyle textStyle;
  final TextStyle selectedTextStyle;
  final Color badgeColor;
  final Color badgeMutedColor;
  final Color badgeTextColor;

  const ChatFolderTabsStyle({
    required this.height,
    required this.trackColor,
    this.trackBorder,
    required this.trackRadius,
    required this.inset,
    required this.thumbColor,
    required this.thumbRadius,
    this.thumbShadow = const [],
    required this.textStyle,
    required this.selectedTextStyle,
    required this.badgeColor,
    required this.badgeMutedColor,
    required this.badgeTextColor,
  });
}

/// Полоса табов-папок в виде сегмент-контрола (как «Все / Пропущенные» на
/// «Звонках»), но:
///  • при переполнении прокручивается по горизонтали, активный таб держится в
///    зоне видимости;
///  • бегунок привязан к [controller] (`PageView` со страницами папок) и плавно
///    едет за пальцем во время свайпа, а не прыгает по его окончании. Без
///    [controller] (простой фильтр без свайпа, как «Все / Пропущенные» на
///    «Звонках») бегунок анимированно переезжает к [selectedIndex].
///
/// Если табы помещаются — растягиваются на всю ширину (как штатный сегмент).
class ChatFolderTabsCore extends StatefulWidget {
  final List<ChatFolderTab> tabs;
  final PageController? controller;

  /// Активный таб, пока у [controller] нет позиции (первый кадр); без
  /// [controller] — всегда.
  final int selectedIndex;

  final ValueChanged<int> onTap;
  final ValueChanged<int>? onLongPress;
  final ChatFolderTabsStyle style;

  /// Обёртка сегмента [index] (iOS — `CupertinoContextMenu`): [tappable] —
  /// сегмент с обработкой тапа, [content] — он же без жестов, ровно по
  /// размеру сегмента (для превью меню).
  final Widget Function(int index, Widget tappable, Widget content)? segmentWrapper;

  const ChatFolderTabsCore({
    super.key,
    required this.tabs,
    this.controller,
    required this.selectedIndex,
    required this.onTap,
    this.onLongPress,
    required this.style,
    this.segmentWrapper,
  });

  @override
  State<ChatFolderTabsCore> createState() => _ChatFolderTabsCoreState();
}

class _ChatFolderTabsCoreState extends State<ChatFolderTabsCore> {
  static const _segmentPadding = 12.0;
  static const _badgeGap = 5.0;

  final _scroll = ScrollController();

  // Раскладка последнего build — нужна слушателю страницы для автопрокрутки.
  List<double> _offsets = const [];
  List<double> _widths = const [];

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_followPage);
  }

  @override
  void didUpdateWidget(ChatFolderTabsCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_followPage);
      widget.controller?.addListener(_followPage);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_followPage);
    _scroll.dispose();
    super.dispose();
  }

  double get _page {
    final c = widget.controller;
    if (c != null && c.hasClients && c.position.haveDimensions && c.page != null) return c.page!;
    return widget.selectedIndex.toDouble();
  }

  /// Держит бегунок по центру видимой области (в пределах прокрутки).
  void _followPage() {
    if (!_scroll.hasClients || _offsets.isEmpty) return;
    final (left, width) = _thumb(_page);
    final position = _scroll.position;
    final target = (left + width / 2 - position.viewportDimension / 2).clamp(0.0, position.maxScrollExtent);
    if ((target - position.pixels).abs() > 0.5) _scroll.jumpTo(target);
  }

  (double, double) _thumb(double page) {
    final last = _offsets.length - 1;
    final p = page.clamp(0.0, last.toDouble());
    final i = p.floor();
    final j = math.min(i + 1, last);
    final f = p - i;
    return (lerpDouble(_offsets[i], _offsets[j], f)!, lerpDouble(_widths[i], _widths[j], f)!);
  }

  double _textWidth(String text, TextStyle style, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
      maxLines: 1,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  String _badgeText(int count) => count > 99 ? '99+' : '$count';

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final scaler = MediaQuery.textScalerOf(context);
    final badgeStyle = style.textStyle.copyWith(fontSize: 12, color: style.badgeTextColor, fontWeight: FontWeight.w600);
    final badgeHeight = scaler.scale(18);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Ширины сегментов меряем жирным (выбранным) стилем — чтобы ширина не
        // «дышала» при смене выбора.
        final intrinsic = [
          for (final tab in widget.tabs)
            _textWidth(tab.title, style.selectedTextStyle, scaler) +
                (tab.badge > 0 ? _badgeGap + math.max(badgeHeight, _textWidth(_badgeText(tab.badge), badgeStyle, scaler) + 12) : 0) +
                _segmentPadding * 2,
        ];
        final available = constraints.maxWidth - style.inset * 2;
        final total = intrinsic.fold<double>(0, (a, b) => a + b);
        final fits = total <= available;

        final List<double> widths;
        if (!fits) {
          widths = intrinsic;
        } else if (intrinsic.reduce(math.max) * intrinsic.length <= available) {
          widths = List.filled(intrinsic.length, available / intrinsic.length);
        } else {
          final extra = (available - total) / intrinsic.length;
          widths = [for (final w in intrinsic) w + extra];
        }
        final offsets = <double>[];
        var x = 0.0;
        for (final w in widths) {
          offsets.add(x);
          x += w;
        }
        _offsets = offsets;
        _widths = widths;

        Widget trackAt(double page) {
          final (thumbLeft, thumbWidth) = _thumb(page);
          final selected = page.round();
          return Container(
            height: style.height,
            width: x + style.inset * 2,
            padding: EdgeInsets.all(style.inset),
            decoration: BoxDecoration(color: style.trackColor, borderRadius: BorderRadius.circular(style.trackRadius)),
            // Контур — поверх (foreground), чтобы не съедать ширину сегментов.
            foregroundDecoration: style.trackBorder == null
                ? null
                : BoxDecoration(border: style.trackBorder, borderRadius: BorderRadius.circular(style.trackRadius)),
            child: Stack(
              children: [
                Positioned(
                  left: thumbLeft,
                  width: thumbWidth,
                  top: 0,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: style.thumbColor,
                      borderRadius: BorderRadius.circular(style.thumbRadius),
                      boxShadow: style.thumbShadow,
                    ),
                  ),
                ),
                for (var i = 0; i < widget.tabs.length; i++)
                  Positioned(
                    left: offsets[i],
                    width: widths[i],
                    top: 0,
                    bottom: 0,
                    child: _wrap(i, widths[i], i == selected, badgeStyle, badgeHeight),
                  ),
              ],
            ),
          );
        }

        final controller = widget.controller;
        final track = controller != null
            ? AnimatedBuilder(animation: controller, builder: (context, _) => trackAt(_page))
            : TweenAnimationBuilder<double>(
                tween: Tween(end: widget.selectedIndex.toDouble()),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                builder: (context, page, _) => trackAt(page),
              );

        if (fits) return track;
        return SingleChildScrollView(scrollDirection: Axis.horizontal, controller: _scroll, child: track);
      },
    );
  }

  Widget _wrap(int i, double width, bool selected, TextStyle badgeStyle, double badgeHeight) {
    final segment = _segment(widget.tabs[i], selected, badgeStyle, badgeHeight);
    final tappable = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onTap(i),
      onLongPress: widget.onLongPress == null ? null : () => widget.onLongPress!(i),
      child: segment,
    );
    final wrapper = widget.segmentWrapper;
    if (wrapper == null) return tappable;
    final style = widget.style;
    return wrapper(i, tappable, SizedBox(width: width, height: style.height - style.inset * 2, child: segment));
  }

  Widget _segment(ChatFolderTab tab, bool selected, TextStyle badgeStyle, double badgeHeight) {
    final style = widget.style;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(tab.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: selected ? style.selectedTextStyle : style.textStyle),
        ),
        if (tab.badge > 0) ...[
          const SizedBox(width: _badgeGap),
          Container(
            height: badgeHeight,
            constraints: BoxConstraints(minWidth: badgeHeight),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tab.badgeMuted ? style.badgeMutedColor : style.badgeColor,
              borderRadius: BorderRadius.circular(badgeHeight / 2),
            ),
            child: Text(_badgeText(tab.badge), style: badgeStyle),
          ),
        ],
      ],
    );
  }
}
