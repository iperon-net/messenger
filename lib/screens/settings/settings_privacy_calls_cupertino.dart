import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// Детейл-экран приватности звонков (drill-down с «Конфиденциальности»).
/// Пока держит только выбор аудитории «кто может звонить»; секции ниже
/// (исключения, favorites) добавятся следующими этапами.
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

  /// Открывает пикер allow-list «Всегда разрешать», передав текущий выбор; по
  /// возврату перечитывает настройку, чтобы счётчик обновился.
  Future<void> _openAllow(BuildContext context, SettingsPrivacyAndSecurityState state) async {
    final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
    await context.push("/settings/privacy_and_security/calls/allow", extra: state.callsAllow);
    await cubit.reloadCalls();
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
                // Исключения показываем только при «Никто»: allow-list «всегда
                // разрешать» перекрывает запрет для выбранных контактов.
                if (state.callsAudience == CallsPrivacyAudience.nobody && !state.callsLoadError)
                  CupertinoListSection.insetGrouped(
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
                        title: Text(context.t.sessionsPrivacyAndSecurity.callsAlwaysAllow),
                        additionalInfo: Text(
                          "${state.callsAllow.length}",
                          style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                        trailing: const CupertinoListTileChevron(),
                        onTap: state.callsReadOnly ? null : () => _openAllow(context, state),
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
