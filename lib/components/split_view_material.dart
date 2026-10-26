import 'package:material_ui/material_ui.dart';

import '../platform.dart';
import '../split_layout.dart';

/// Вкладка на Android-планшете — как [SplitViewCupertino]: на широком окне
/// слева [list] (под ним панель вкладок `HomeMaterial` — отсюда нижний отступ),
/// справа [child] — навигатор правой панели; на узком — только [child].
class SplitViewMaterial extends StatelessWidget {
  final Widget list;
  final Widget child;
  final String selected;

  const SplitViewMaterial({super.key, required this.list, required this.child, this.selected = ''});

  @override
  Widget build(BuildContext context) {
    if (!SplitLayout.isWide(context)) return SplitPaneScope(child: child);
    final media = MediaQuery.of(context);
    return ValueListenableBuilder(
      valueListenable: SplitLayout.listWidthOverride,
      builder: (context, _, _) {
        final listWidth = SplitLayout.listWidth(media.size.width);
        return Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: listWidth,
                  child: MediaQuery(
                    data: media.copyWith(
                      padding: media.padding.copyWith(bottom: media.padding.bottom + SplitLayout.navigationBarHeightMaterial),
                    ),
                    child: SplitSelection(id: selected, child: list),
                  ),
                ),
                VerticalDivider(width: 1, thickness: 1, color: Theme.of(context).colorScheme.outlineVariant),
                Expanded(child: SplitPaneScope(child: child)),
              ],
            ),
            // Десктоп: разделитель тянется мышью вправо от самой узкой ширины
            // (двойной клик — снова узкий), как в Telegram Desktop.
            if (AppPlatform.isDesktop)
              Positioned(
                left: listWidth - 4,
                width: 9,
                top: 0,
                bottom: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragUpdate: (details) =>
                        SplitLayout.setListWidth(SplitLayout.listWidth(media.size.width) + details.delta.dx),
                    onHorizontalDragEnd: (_) => SplitLayout.saveListWidth(),
                    onDoubleTap: () {
                      SplitLayout.setListWidth(null);
                      SplitLayout.saveListWidth();
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Корень правой панели, пока справа ничего не открыто: «Выберите чат» и т.п.
class SplitEmptyMaterial extends StatelessWidget {
  final String text;

  const SplitEmptyMaterial({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
