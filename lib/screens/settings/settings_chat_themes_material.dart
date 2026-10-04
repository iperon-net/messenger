import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../chats/chat_material.dart';
import 'settings_chat_themes_common.dart';

/// «Темы для чатов» (Настройки → Оформление, Android): узор и цвет обоев
/// окна чата с живым превью. Сохраняется сразу (локальная настройка устройства).
class SettingsChatThemesMaterial extends StatelessWidget {
  const SettingsChatThemesMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChatThemes;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: scheme.primary)),
    );

    return Scaffold(
      appBar: AppBar(title: Text(t.title)),
      body: SafeArea(
        child: BlocBuilder<CommonCubit, CommonState>(
          buildWhen: (previous, current) =>
              previous.settingsDevice.chatWallpaper != current.settingsDevice.chatWallpaper ||
              previous.settingsDevice.chatWallpaperColor != current.settingsDevice.chatWallpaperColor ||
              previous.settingsDevice.chatWallpaperIntensity != current.settingsDevice.chatWallpaperIntensity,
          builder: (context, common) {
            final pattern = chatWallpaperPatternOf(common.settingsDevice.chatWallpaper);
            final color = common.settingsDevice.chatWallpaperColor;
            final intensity = common.settingsDevice.chatWallpaperIntensity;
            final cubit = context.read<CommonCubit>();
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ChatThemePreview(
                    pattern: pattern,
                    colorIndex: color,
                    intensity: intensity,
                    dark: dark,
                    style: ChatMaterial.bubbleStyle(context),
                  ),
                ),
                header(t.pattern),
                ChatPatternStrip(
                  selected: pattern,
                  colorIndex: color,
                  intensity: intensity,
                  dark: dark,
                  accent: scheme.primary,
                  labelStyle: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                  onSelected: (value) => cubit.setChatWallpaper(pattern: value, color: color),
                ),
                header(t.intensity),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: intensity.clamp(chatWallpaperIntensityMin, chatWallpaperIntensityMax).toDouble(),
                          min: chatWallpaperIntensityMin.toDouble(),
                          max: chatWallpaperIntensityMax.toDouble(),
                          divisions: (chatWallpaperIntensityMax - chatWallpaperIntensityMin) ~/ 5,
                          onChanged: (value) => cubit.setChatWallpaperIntensity(value.round(), persist: false),
                          onChangeEnd: (value) => cubit.setChatWallpaperIntensity(value.round()),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$intensity%',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: scheme.onSurfaceVariant, fontFeatures: const [FontFeature.tabularFigures()]),
                        ),
                      ),
                    ],
                  ),
                ),
                header(t.color),
                ChatColorPalette(
                  selected: color,
                  dark: dark,
                  accent: scheme.primary,
                  onSelected: (value) => cubit.setChatWallpaper(pattern: pattern, color: value),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                  child: Text(
                    t.footer,
                    style: TextStyle(fontSize: AppFontSizes.caption, color: scheme.onSurfaceVariant),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
