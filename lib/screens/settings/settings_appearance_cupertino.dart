import 'package:go_router/go_router.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import '../../themes.dart';

import '../../components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../chats/reactions.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models/constants.dart';

class SettingsAppearanceCupertino extends StatefulWidget {
  const SettingsAppearanceCupertino({super.key});

  @override
  State<SettingsAppearanceCupertino> createState() => _SettingsAppearanceCupertino();
}

class _SettingsAppearanceCupertino extends State<SettingsAppearanceCupertino> {
  /// «Быстрая реакция»: сетка всех реакций, выбранная — в кружке.
  Future<void> _pickQuickReaction(BuildContext context, String current) async {
    final cubit = context.read<CommonCubit>();
    final primary = CupertinoTheme.of(context).primaryColor;
    final emoji = await showCupertinoModalPopup<String>(
      context: context,
      builder: (popupContext) => CupertinoActionSheet(
        title: Text(context.t.screenSettingsAppearance.quickReaction),
        message: Text(context.t.screenSettingsAppearance.quickReactionDescription),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final emoji in allChatReactions)
                  GestureDetector(
                    onTap: () => Navigator.of(popupContext).pop(emoji),
                    child: Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: emoji == current ? primary.withValues(alpha: 0.2) : null,
                        border: emoji == current ? Border.all(color: primary, width: 1.5) : null,
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 26)),
                    ),
                  ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.of(popupContext).pop(), child: Text(context.t.common.cancel)),
      ),
    );
    if (emoji != null && emoji != current) await cubit.setQuickReaction(emoji);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget additionalInfo = FaIcon(
      FontAwesomeIcons.solidCircleCheck,
      size: 18,
      color: CupertinoDynamicColor.resolve(
        CupertinoDynamicColor.withBrightness(
          color: CupertinoTheme.of(context).primaryColor,
          darkColor: CupertinoTheme.of(context).primaryColor,
        ),
        context,
      ),
    );

    return BlocConsumer<SettingsAppearanceCubit, SettingsAppearanceState>(
      listenWhen: (previousState, currentState) =>
          previousState.colorTheme != currentState.colorTheme ||
          previousState.darkMode != currentState.darkMode ||
          previousState.isBlurOnInactive != currentState.isBlurOnInactive,
      listener: (context, state) async {
        final commonCubit = context.read<CommonCubit>();
        await commonCubit.setColorTheme(colorTheme: state.colorTheme);
        await commonCubit.setDarkMode(darkMode: state.darkMode);
        await commonCubit.setIsBlurOnInactive(isBlurOnInactive: state.isBlurOnInactive);
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenSettingsAppearance.appearance),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  header: Text(
                    context.t.screenSettingsAppearance.colorTheme.toUpperCase(),
                    style: TextStyle(fontSize: AppFontSizes.caption, fontWeight: FontWeight.normal),
                  ),
                  children: [
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.colorThemeDefault),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.blue),
                      additionalInfo: state.colorTheme == ColorThemeModel.blue ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.colorThemeGreen),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.green),
                      additionalInfo: state.colorTheme == ColorThemeModel.green ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.colorThemePurple),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.purple),
                      additionalInfo: state.colorTheme == ColorThemeModel.purple ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.colorThemeOrange),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setColorTheme(colorTheme: ColorThemeModel.orange),
                      additionalInfo: state.colorTheme == ColorThemeModel.orange ? additionalInfo : null,
                    ),
                  ],
                ),

                CupertinoListSection.insetGrouped(
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  header: Text(
                    context.t.screenSettingsAppearance.darkMode.toUpperCase(),
                    style: TextStyle(fontSize: AppFontSizes.caption, fontWeight: FontWeight.normal),
                  ),
                  children: [
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.darkModeSystem),
                      subtitle: Text(context.t.screenSettingsAppearance.darkModeSystemDescription),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.system),
                      additionalInfo: state.darkMode == DarkModeModel.system ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.darkModeAlwaysOn),
                      subtitle: Text(context.t.screenSettingsAppearance.darkModeAlwaysOnDescription),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.alwaysOn),
                      additionalInfo: state.darkMode == DarkModeModel.alwaysOn ? additionalInfo : null,
                    ),
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.darkModeDisabled),
                      subtitle: Text(context.t.screenSettingsAppearance.darkModeDisabledDescription),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.disabled),
                      additionalInfo: state.darkMode == DarkModeModel.disabled ? additionalInfo : null,
                    ),
                  ],
                ),
                // Обои окна чата — отдельный экран с превью.
                CupertinoListSection.insetGrouped(
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  children: [
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.chatThemes),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => context.push('/settings/appearance/chat_themes'),
                    ),
                    BlocBuilder<CommonCubit, CommonState>(
                      buildWhen: (previous, current) => previous.settingsDevice.quickReaction != current.settingsDevice.quickReaction,
                      builder: (context, common) => CupertinoListTile(
                        title: Text(context.t.screenSettingsAppearance.quickReaction),
                        additionalInfo: Text(common.settingsDevice.quickReaction, style: const TextStyle(fontSize: 20)),
                        trailing: const CupertinoListTileChevron(),
                        onTap: () => _pickQuickReaction(context, common.settingsDevice.quickReaction),
                      ),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Text(
                      context.t.screenSettingsAppearance.blurOnInactiveDescription,
                      style: TextStyle(fontSize: AppFontSizes.caption, fontWeight: FontWeight.normal),
                    ),
                  ),
                  children: [
                    CupertinoListTile(
                      title: Text(context.t.screenSettingsAppearance.blurOnInactive),
                      onTap: () async => await context.read<SettingsAppearanceCubit>().setDarkMode(darkMode: DarkModeModel.disabled),
                      trailing: CupertinoSwitch(
                        value: state.isBlurOnInactive,
                        onChanged: (bool value) async =>
                            await context.read<SettingsAppearanceCubit>().setIsBlurOnInactive(isBlurOnInactive: value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
