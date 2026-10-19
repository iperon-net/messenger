import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../chats/chat_cupertino.dart';
import 'settings_privacy_forwards_common.dart';

/// Детейл-экран «Пересылка сообщений» — кто может добавить ссылку на мой
/// аккаунт при пересылке моих сообщений (drill-down с «Конфиденциальности»):
/// выбор аудитории + секция «Исключения» (allow под «Никто», deny под «Мои
/// контакты»). Гейт серверный, при пересылке; что значит «без ссылки» —
/// поясняем в футере.
class SettingsPrivacyForwardsCupertino extends StatelessWidget {
  const SettingsPrivacyForwardsCupertino({super.key});

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
    final ok = await context.read<SettingsPrivacyAndSecurityCubit>().setForwardsAudience(audience);
    if (ok || !context.mounted) return;
    await _noConnectionDialog(context);
  }

  /// Открывает пикер списка-исключений ([kind]: allow под «Никто» / deny под
  /// «Мои контакты») для канала «пересылка»; по возврату перечитывает.
  Future<void> _openList(BuildContext context, SettingsPrivacyAndSecurityState state, CallsListKind kind) async {
    final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
    final isAllow = kind == CallsListKind.allow;
    await context.push(
      isAllow ? "/settings/privacy_and_security/forwards/allow" : "/settings/privacy_and_security/forwards/deny",
      extra: isAllow ? state.forwardsAllow : state.forwardsDeny,
    );
    await cubit.reloadForwards();
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
              middle: Text(context.t.sessionsPrivacyAndSecurity.forwards),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                // Как получатель увидит моё пересланное сообщение. Пока
                // настройка не загружена — без превью (не показываем дефолт).
                if (!state.callsLoadError)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: ForwardsPrivacyPreview(
                      hidden: state.forwardsAudience == CallsPrivacyAudience.nobody,
                      dark: CupertinoTheme.brightnessOf(context) == Brightness.dark,
                      style: ChatCupertino.bubbleStyle(context),
                    ),
                  ),
                CupertinoListSection.insetGrouped(
                  header: Text(
                    context.t.sessionsPrivacyAndSecurity.whoCanLinkForwards,
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
                                onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadForwards(),
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
                                  context.t.sessionsPrivacyAndSecurity.forwardsNote,
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
                          onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadForwards(),
                          child: Text(context.t.sessionsPrivacyAndSecurity.retry),
                        ),
                      )
                    else
                      for (final audience in CallsPrivacyAudience.values)
                        CupertinoListTile(
                          title: Text(_audienceLabel(context, audience)),
                          additionalInfo: state.forwardsAudience == audience ? check : null,
                          onTap: state.callsReadOnly ? null : () => _onSelect(context, audience),
                        ),
                  ],
                ),
                // Исключения под «Никто»: allow-list «всегда разрешать».
                if (state.forwardsAudience == CallsPrivacyAudience.nobody && !state.callsLoadError)
                  _exceptionsSection(
                    context,
                    label: context.t.sessionsPrivacyAndSecurity.callsAlwaysAllow,
                    count: state.forwardsAllow.length,
                    onTap: state.callsReadOnly ? null : () => _openList(context, state, CallsListKind.allow),
                  ),
                // Исключения под «Мои контакты»: deny-list «всегда запрещать».
                if (state.forwardsAudience == CallsPrivacyAudience.contacts && !state.callsLoadError)
                  _exceptionsSection(
                    context,
                    label: context.t.sessionsPrivacyAndSecurity.callsAlwaysDeny,
                    count: state.forwardsDeny.length,
                    onTap: state.callsReadOnly ? null : () => _openList(context, state, CallsListKind.deny),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
