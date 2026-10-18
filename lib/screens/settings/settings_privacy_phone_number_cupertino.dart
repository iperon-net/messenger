import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// Детейл-экран «Номер телефона» (drill-down с «Конфиденциальности»): кто видит
/// мой номер + секция «Исключения» (allow под «Никто», deny под «Мои
/// контакты»), а когда номер виден не всем — «Кто может найти меня по номеру»
/// («Все» / «Мои контакты», как в Telegram). Гейт серверный, при отдаче
/// профиля и поиске по номеру.
class SettingsPrivacyPhoneNumberCupertino extends StatelessWidget {
  const SettingsPrivacyPhoneNumberCupertino({super.key});

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
    final ok = await context.read<SettingsPrivacyAndSecurityCubit>().setPhoneNumberAudience(audience);
    if (ok || !context.mounted) return;
    await _noConnectionDialog(context);
  }

  /// То же для «Кто может найти меня по номеру».
  Future<void> _onSelectFind(BuildContext context, CallsPrivacyAudience audience) async {
    final ok = await context.read<SettingsPrivacyAndSecurityCubit>().setPhoneNumberFind(audience);
    if (ok || !context.mounted) return;
    await _noConnectionDialog(context);
  }

  /// Открывает пикер списка-исключений ([kind]: allow под «Никто» / deny под
  /// «Мои контакты») для канала «номер телефона»; по возврату перечитывает.
  Future<void> _openList(BuildContext context, SettingsPrivacyAndSecurityState state, CallsListKind kind) async {
    final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
    final isAllow = kind == CallsListKind.allow;
    await context.push(
      isAllow ? "/settings/privacy_and_security/phone_number/allow" : "/settings/privacy_and_security/phone_number/deny",
      extra: isAllow ? state.phoneNumberAllow : state.phoneNumberDeny,
    );
    await cubit.reloadPhoneNumber();
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
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.sessionsPrivacyAndSecurity.phoneNumber),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  header: Text(
                    context.t.sessionsPrivacyAndSecurity.whoCanSeePhoneNumber,
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
                                onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadPhoneNumber(),
                                child: const Icon(CupertinoIcons.arrow_clockwise, size: 20),
                              ),
                            ],
                          ),
                        )
                      : (state.callsLoadError
                            ? null
                            : Padding(
                                padding: const EdgeInsets.only(left: 13, right: 13),
                                child: Text(
                                  context.t.sessionsPrivacyAndSecurity.phoneNumberNote,
                                  style: TextStyle(fontSize: AppFontSizes.caption),
                                ),
                              )),
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
                          onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadPhoneNumber(),
                          child: Text(context.t.sessionsPrivacyAndSecurity.retry),
                        ),
                      )
                    else
                      for (final audience in CallsPrivacyAudience.values)
                        CupertinoListTile(
                          title: Text(_audienceLabel(context, audience)),
                          additionalInfo: state.phoneNumberAudience == audience ? check : null,
                          onTap: state.callsReadOnly ? null : () => _onSelect(context, audience),
                        ),
                  ],
                ),
                // Исключения под «Никто»: allow-list «всегда разрешать».
                if (state.phoneNumberAudience == CallsPrivacyAudience.nobody && !state.callsLoadError)
                  _exceptionsSection(
                    context,
                    label: context.t.sessionsPrivacyAndSecurity.callsAlwaysAllow,
                    count: state.phoneNumberAllow.length,
                    onTap: state.callsReadOnly ? null : () => _openList(context, state, CallsListKind.allow),
                  ),
                // Исключения под «Мои контакты»: deny-list «всегда запрещать».
                if (state.phoneNumberAudience == CallsPrivacyAudience.contacts && !state.callsLoadError)
                  _exceptionsSection(
                    context,
                    label: context.t.sessionsPrivacyAndSecurity.callsAlwaysDeny,
                    count: state.phoneNumberDeny.length,
                    onTap: state.callsReadOnly ? null : () => _openList(context, state, CallsListKind.deny),
                  ),
                // Номер виден не всем — кто может найти по номеру.
                if (state.phoneNumberAudience != CallsPrivacyAudience.everybody && !state.callsLoadError)
                  CupertinoListSection.insetGrouped(
                    header: Text(
                      context.t.sessionsPrivacyAndSecurity.whoCanFindByPhone,
                      style: TextStyle(fontSize: AppFontSizes.base, fontWeight: FontWeight.normal),
                    ),
                    footer: Padding(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      child: Text(
                        context.t.sessionsPrivacyAndSecurity.phoneNumberFindNote,
                        style: TextStyle(fontSize: AppFontSizes.caption),
                      ),
                    ),
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    children: [
                      for (final audience in const [CallsPrivacyAudience.everybody, CallsPrivacyAudience.contacts])
                        CupertinoListTile(
                          title: Text(_audienceLabel(context, audience)),
                          additionalInfo: state.phoneNumberFind == audience ? check : null,
                          onTap: state.callsReadOnly ? null : () => _onSelectFind(context, audience),
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
