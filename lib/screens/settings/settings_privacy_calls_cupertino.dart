import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// Детейл-экран приватности звонков (drill-down с «Конфиденциальности»):
/// выбор аудитории «кто может звонить» + секция «Исключения» (allow-list под
/// «Никто», deny-list под «Мои контакты»).
class SettingsPrivacyCallsCupertino extends StatelessWidget {
  const SettingsPrivacyCallsCupertino({super.key});

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

  /// Пытается применить выбор; при неудаче (offline/ошибка) — диалог «нет сети».
  Future<void> _onSelect(BuildContext context, CallsPrivacyAudience audience) async {
    final ok = await context.read<SettingsPrivacyAndSecurityCubit>().setCallsAudience(audience);
    if (ok || !context.mounted) return;
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

  /// Открывает пикер списка-исключений ([kind]: allow «всегда разрешать» под
  /// «Никто» / deny «всегда запрещать» под «Мои контакты»), передав текущий
  /// выбор; по возврату перечитывает настройку, чтобы счётчик обновился.
  Future<void> _openList(BuildContext context, SettingsPrivacyAndSecurityState state, CallsListKind kind) async {
    final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
    final isAllow = kind == CallsListKind.allow;
    await context.push(
      isAllow ? "/settings/privacy_and_security/calls/allow" : "/settings/privacy_and_security/calls/deny",
      extra: isAllow ? state.callsAllow : state.callsDeny,
    );
    await cubit.reloadCalls();
  }

  /// Секция «Исключения» с одной строкой-пунктом (allow/deny), показывающей
  /// счётчик и открывающей пикер. Общая для обеих аудиторий — различается
  /// только подписью, счётчиком и [kind].
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
              middle: Text(context.t.sessionsPrivacyAndSecurity.calls),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  header: Text(
                    context.t.sessionsPrivacyAndSecurity.whoCanCall,
                    style: TextStyle(fontSize: AppFontSizes.base, fontWeight: FontWeight.normal),
                  ),
                  // Показываем значение из кэша, но менять нельзя — нет сети.
                  // Даём повтор (иконкой), чтобы перепроверить сеть не выходя с экрана.
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
                                onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadCalls(),
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
                    // Настройка не загрузилась (offline/ошибка) — не показываем
                    // дефолт как реальное значение, а даём повтор.
                    if (state.callsLoadError)
                      CupertinoListTile(
                        title: Text(context.t.sessionsPrivacyAndSecurity.callsLoadError),
                        trailing: CupertinoButton(
                          sizeStyle: CupertinoButtonSize.small,
                          padding: EdgeInsets.zero,
                          onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadCalls(),
                          child: Text(context.t.sessionsPrivacyAndSecurity.retry),
                        ),
                      )
                    else
                      for (final audience in CallsPrivacyAudience.values)
                        CupertinoListTile(
                          title: Text(_audienceLabel(context, audience)),
                          additionalInfo: state.callsAudience == audience ? check : null,
                          onTap: state.callsReadOnly ? null : () => _onSelect(context, audience),
                        ),
                  ],
                ),
                // Исключения под «Никто»: allow-list «всегда разрешать»
                // перекрывает запрет для выбранных контактов.
                if (state.callsAudience == CallsPrivacyAudience.nobody && !state.callsLoadError)
                  _exceptionsSection(
                    context,
                    label: context.t.sessionsPrivacyAndSecurity.callsAlwaysAllow,
                    count: state.callsAllow.length,
                    onTap: state.callsReadOnly ? null : () => _openList(context, state, CallsListKind.allow),
                  ),
                // Исключения под «Мои контакты»: deny-list «всегда запрещать»
                // блокирует звонки от выбранных контактов.
                if (state.callsAudience == CallsPrivacyAudience.contacts && !state.callsLoadError)
                  _exceptionsSection(
                    context,
                    label: context.t.sessionsPrivacyAndSecurity.callsAlwaysDeny,
                    count: state.callsDeny.length,
                    onTap: state.callsReadOnly ? null : () => _openList(context, state, CallsListKind.deny),
                  ),
                // Локальный тумблер сквозного шифрования звонков (per-device,
                // хранится в settingsDevice через CommonCubit — не серверная
                // настройка, поэтому отдельный BlocSelector).
                CupertinoListSection.insetGrouped(
                  footer: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Text(
                      context.t.sessionsPrivacyAndSecurity.callsEncryptionNote,
                      style: TextStyle(fontSize: AppFontSizes.caption, fontWeight: FontWeight.normal),
                    ),
                  ),
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  children: [
                    CupertinoListTile(
                      title: Text(context.t.sessionsPrivacyAndSecurity.callsEncryption),
                      trailing: BlocSelector<CommonCubit, CommonState, bool>(
                        selector: (commonState) => commonState.settingsDevice.callsE2ee,
                        builder: (context, callsE2ee) => CupertinoSwitch(
                          value: callsE2ee,
                          onChanged: (value) => context.read<CommonCubit>().setCallsE2ee(callsE2ee: value),
                        ),
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
