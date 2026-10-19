import 'package:flutter/widgets.dart';

import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models/constants.dart';

/// Общее для «Цветовой темы» в «Оформлении» (`settings_appearance_{cupertino,material}.dart`):
/// лента миниатюр — обои чата и пара пузырей в цветах каждой темы.

String colorThemeTitle(Translations t, ColorThemeModel colorTheme) => switch (colorTheme) {
  ColorThemeModel.blue => t.screenSettingsAppearance.colorThemeDefault,
  ColorThemeModel.green => t.screenSettingsAppearance.colorThemeGreen,
  ColorThemeModel.purple => t.screenSettingsAppearance.colorThemePurple,
  ColorThemeModel.orange => t.screenSettingsAppearance.colorThemeOrange,
};

/// Цвета одной темы для миниатюры — платформа считает их так же, как для
/// своего окна чата (см. `bubbleStyle`).
class ColorThemeSwatch {
  /// Рамка выбранной миниатюры и подпись.
  final Color accent;
  final Color outgoing;
  final Color incoming;

  const ColorThemeSwatch({required this.accent, required this.outgoing, required this.incoming});
}

/// Лента цветовых тем: миниатюра чата в цветах темы, выбранная — в рамке её
/// акцента. Обои — текущие обои чатов пользователя.
class ColorThemeStrip extends StatelessWidget {
  final ColorThemeModel selected;
  final ColorThemeSwatch Function(ColorThemeModel colorTheme) swatchOf;
  final String pattern;
  final int colorIndex;
  final int intensity;
  final bool dark;
  final TextStyle labelStyle;
  final ValueChanged<ColorThemeModel> onSelected;

  const ColorThemeStrip({
    super.key,
    required this.selected,
    required this.swatchOf,
    required this.pattern,
    required this.colorIndex,
    required this.intensity,
    required this.dark,
    required this.labelStyle,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    const themes = ColorThemeModel.values;
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: themes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final colorTheme = themes[index];
          final swatch = swatchOf(colorTheme);
          final isSelected = colorTheme == selected;
          return GestureDetector(
            onTap: () => onSelected(colorTheme),
            child: SizedBox(
              width: 84,
              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 120,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: isSelected ? swatch.accent : const Color(0x00000000), width: 2.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ChatWallpaper(
                              pattern: pattern,
                              colorIndex: colorIndex,
                              intensity: intensity,
                              dark: dark,
                              tileScale: 0.5,
                            ),
                          ),
                          Positioned(
                            left: 6,
                            right: 6,
                            bottom: 8,
                            child: Column(
                              children: [
                                _bubble(swatch.incoming, width: 46, alignment: Alignment.centerLeft),
                                const SizedBox(height: 5),
                                _bubble(swatch.outgoing, width: 52, alignment: Alignment.centerRight),
                                const SizedBox(height: 5),
                                _bubble(swatch.incoming, width: 36, alignment: Alignment.centerLeft),
                                const SizedBox(height: 5),
                                _bubble(swatch.outgoing, width: 30, alignment: Alignment.centerRight),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    colorThemeTitle(t, colorTheme),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected ? labelStyle.copyWith(color: swatch.accent, fontWeight: FontWeight.w600) : labelStyle,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bubble(Color color, {required double width, required Alignment alignment}) => Align(
    alignment: alignment,
    child: Container(
      width: width,
      height: 14,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(7)),
    ),
  );
}
