import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../chats/chat_cupertino.dart';
import 'settings_chat_themes_common.dart';

/// «Темы для чатов» (Настройки → Оформление, iOS): узор и цвет обоев окна
/// чата с живым превью. Сохраняется сразу (локальная настройка устройства).
class SettingsChatThemesCupertino extends StatelessWidget {
  const SettingsChatThemesCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChatThemes;
    final dark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final accent = CupertinoDynamicColor.resolve(CupertinoTheme.of(context).primaryColor, context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);

    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(fontSize: AppFontSizes.caption, color: secondary),
      ),
    );

    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(t.title),
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<CommonCubit, CommonState>(
          buildWhen: (previous, current) =>
              previous.settingsDevice.chatWallpaper != current.settingsDevice.chatWallpaper ||
              previous.settingsDevice.chatWallpaperColor != current.settingsDevice.chatWallpaperColor,
          builder: (context, common) {
            final pattern = common.settingsDevice.chatWallpaper;
            final color = common.settingsDevice.chatWallpaperColor;
            final cubit = context.read<CommonCubit>();
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ChatThemePreview(pattern: pattern, colorIndex: color, dark: dark, style: ChatCupertino.bubbleStyle(context)),
                ),
                header(t.pattern),
                ChatPatternStrip(
                  selected: pattern,
                  colorIndex: color,
                  dark: dark,
                  accent: accent,
                  labelStyle: TextStyle(fontSize: 12, color: secondary),
                  onSelected: (value) => cubit.setChatWallpaper(pattern: value, color: color),
                ),
                header(t.color),
                ChatColorPalette(
                  selected: color,
                  dark: dark,
                  accent: accent,
                  onSelected: (value) => cubit.setChatWallpaper(pattern: pattern, color: value),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Text(
                    t.footer,
                    style: TextStyle(fontSize: AppFontSizes.caption, color: secondary),
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
