import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// Детейл-экран приватности дня рождения (drill-down с «Конфиденциальности»):
/// выбор аудитории «кто может видеть мой день рождения» + секция «Исключения»
/// (allow-list под «Никто», deny-list под «Мои контакты») + тумблер «скрывать
/// год рождения и возраст». Устройство и семантика — как у экрана звонков; общий
/// [SettingsPrivacyAndSecurityCubit] несёт обе настройки в одном ответе.
class SettingsPrivacyBirthdayCupertino extends StatelessWidget {
  const SettingsPrivacyBirthdayCupertino({super.key});

  String _audienceLabel(BuildContext context, CallsPrivacyAudience audience) {
    switch (audience) {
      case CallsPrivacyAudience.everybody:
        return context.t.sessionsPrivacyAndSecurity.callsEverybody;
      case CallsPrivacyAudience.contacts:
        return context.t.sessionsPrivacyAndSecurity.callsContacts;
      case CallsPrivacyAudience.nobody:
        return context.t.sessionsPrivacyAndSecurity.callsNobody;
    }
  }

  Future<void> _noConnectionDialog(BuildContext context) async {
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(context.t.common.noConnectionTitle),
        content: Text(context.t.common.noConnectionMessage),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.t.common.close),
          ),
        ],
      ),
    );
  }

  /// Пытается применить выбор аудитории; при неудаче (offline/ошибка) — диалог.
  Future<void> _onSelect(BuildContext context, CallsPrivacyAudience audience) async {
    final ok = await context.read<SettingsPrivacyAndSecurityCubit>().setBirthdayAudience(audience);
    if (ok || !context.mounted) return;
    await _noConnectionDialog(context);
  }

  /// Переключает «скрывать год рождения»; при неудаче (offline/ошибка) — диалог.
  Future<void> _onToggleHideYear(BuildContext context, bool value) async {
    final ok = await context.read<SettingsPrivacyAndSecurityCubit>().setHideBirthYear(value);
    if (ok || !context.mounted) return;
    await _noConnectionDialog(context);
  }

  /// Открывает пикер списка-исключений ([kind]: allow под «Никто» / deny под
  /// «Мои контакты») для канала «день рождения»; по возврату перечитывает.
  Future<void> _openList(BuildContext context, SettingsPrivacyAndSecurityState state, CallsListKind kind) async {
    final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
    final isAllow = kind == CallsListKind.allow;
    await context.push(
      isAllow ? "/settings/privacy_and_security/birthday/allow" : "/settings/privacy_and_security/birthday/deny",
      extra: isAllow ? state.birthdayAllow : state.birthdayDeny,
    );
    await cubit.reloadBirthday();
  }

  Widget _exceptionsSection(BuildContext context, {required String label, required int count, required VoidCallback? onTap}) {
    return CupertinoListSection.insetGrouped(
      header: Text(
        context.t.sessionsPrivacyAndSecurity.exceptions,
        style: TextStyle(fontSize: AppFontSizes.base, fontWeight: FontWeight.normal),
      ),
      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
      decoration: BoxDecoration(
        color: ThemesCupertino.groupedCard.resolveFrom(context),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      children: [
        CupertinoListTile(
          title: Text(label),
          additionalInfo: Text("$count", style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context))),
          trailing: const CupertinoListTileChevron(),
          onTap: onTap,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget check = FaIcon(
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

    return BlocBuilder<SettingsPrivacyAndSecurityCubit, SettingsPrivacyAndSecurityState>(
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.sessionsPrivacyAndSecurity.birthday),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  header: Text(
                    context.t.sessionsPrivacyAndSecurity.whoCanSeeBirthday,
                    style: TextStyle(fontSize: AppFontSizes.base, fontWeight: FontWeight.normal),
                  ),
                  footer: state.callsReadOnly
                      ? Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.t.sessionsPrivacyAndSecurity.callsOfflineNote,
                                  style: TextStyle(fontSize: AppFontSizes.caption),
                                ),
                              ),
                              CupertinoButton(
                                sizeStyle: CupertinoButtonSize.small,
                                padding: EdgeInsets.zero,
                                onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadBirthday(),
                                child: const Icon(CupertinoIcons.arrow_clockwise, size: 20),
                              ),
                            ],
                          ),
                        )
                      : null,
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  children: [
                    if (state.callsLoadError)
                      CupertinoListTile(
                        title: Text(context.t.sessionsPrivacyAndSecurity.callsLoadError),
                        trailing: CupertinoButton(
                          sizeStyle: CupertinoButtonSize.small,
                          padding: EdgeInsets.zero,
                          onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadBirthday(),
                          child: Text(context.t.sessionsPrivacyAndSecurity.retry),
                        ),
                      )
                    else
                      for (final audience in CallsPrivacyAudience.values)
                        CupertinoListTile(
                          title: Text(_audienceLabel(context, audience)),
                          additionalInfo: state.birthdayAudience == audience ? check : null,
                          onTap: state.callsReadOnly ? null : () => _onSelect(context, audience),
                        ),
                  ],
                ),
                // Исключения под «Никто»: allow-list «всегда разрешать».
                if (state.birthdayAudience == CallsPrivacyAudience.nobody && !state.callsLoadError)
                  _exceptionsSection(
                    context,
                    label: context.t.sessionsPrivacyAndSecurity.callsAlwaysAllow,
                    count: state.birthdayAllow.length,
                    onTap: state.callsReadOnly ? null : () => _openList(context, state, CallsListKind.allow),
                  ),
                // Исключения под «Мои контакты»: deny-list «всегда запрещать».
                if (state.birthdayAudience == CallsPrivacyAudience.contacts && !state.callsLoadError)
                  _exceptionsSection(
                    context,
                    label: context.t.sessionsPrivacyAndSecurity.callsAlwaysDeny,
                    count: state.birthdayDeny.length,
                    onTap: state.callsReadOnly ? null : () => _openList(context, state, CallsListKind.deny),
                  ),
                // Тумблер «скрывать год рождения и возраст». Скрывает год только у
                // тех, кому дата рождения и так видна (см. аудиторию выше).
                if (!state.callsLoadError)
                  CupertinoListSection.insetGrouped(
                    footer: Padding(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      child: Text(context.t.sessionsPrivacyAndSecurity.hideBirthYearNote, style: TextStyle(fontSize: AppFontSizes.caption)),
                    ),
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.sessionsPrivacyAndSecurity.hideBirthYear),
                        trailing: CupertinoSwitch(
                          value: state.hideBirthYear,
                          onChanged: state.callsReadOnly ? null : (value) => _onToggleHideYear(context, value),
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
