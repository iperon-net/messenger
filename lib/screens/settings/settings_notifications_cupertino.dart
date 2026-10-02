import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// «Уведомления и звуки»: типы чатов (drill-down на [SettingsNotificationsScopeCupertino]),
/// события («Новые контакты», «Пропущенные звонки») и предупреждение, если
/// системное разрешение не выдано. Настройки общие для всех устройств и
/// применяются сервером, поэтому offline — только просмотр.
class SettingsNotificationsCupertino extends StatefulWidget {
  const SettingsNotificationsCupertino({super.key});

  @override
  State<SettingsNotificationsCupertino> createState() => _SettingsNotificationsCupertino();
}

class _SettingsNotificationsCupertino extends State<SettingsNotificationsCupertino> {
  // Разрешение могли выдать в системных настройках — перепроверяем по возврату.
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: () => context.read<SettingsNotificationsCubit>().checkPermission());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  String _scopeTitle(BuildContext context, NotifyScope scope) => switch (scope) {
    NotifyScope.privateChats => context.t.screenSettingsNotifications.privateChats,
    NotifyScope.groups => context.t.screenSettingsNotifications.groups,
    NotifyScope.channels => context.t.screenSettingsNotifications.channels,
  };

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

  Future<void> _apply(BuildContext context, Future<bool> Function(SettingsNotificationsCubit cubit) change) async {
    final ok = await change(context.read<SettingsNotificationsCubit>());
    if (ok || !context.mounted) return;
    await _noConnectionDialog(context);
  }

  /// Детейл-экран типа чатов; по возврату перечитываем (у него свой cubit).
  Future<void> _openScope(BuildContext context, NotifyScope scope) async {
    final cubit = context.read<SettingsNotificationsCubit>();
    await context.push("/settings/notifications/${scope.name}");
    await cubit.reload();
  }

  CupertinoListSection _section(BuildContext context, {String? header, Widget? footer, required List<Widget> children}) {
    return CupertinoListSection.insetGrouped(
      header: header == null
          ? null
          : Text(
              header,
              style: TextStyle(fontSize: AppFontSizes.base, fontWeight: FontWeight.normal),
            ),
      footer: footer,
      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
      decoration: BoxDecoration(
        color: ThemesCupertino.groupedCard.resolveFrom(context),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      children: children,
    );
  }

  Widget _note(String text) => Padding(
    padding: const EdgeInsets.only(left: 13, right: 13),
    child: Text(text, style: TextStyle(fontSize: AppFontSizes.caption)),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsNotificationsCubit, SettingsNotificationsState>(
      builder: (context, state) {
        final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.screenSettingsNotifications.notifications),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                if (state.permissionMissing)
                  PermissionBannerCupertino(
                    icon: HugeIcons.strokeRoundedNotificationOff03,
                    title: context.t.screenSettingsNotifications.permissionMissingTitle,
                    message: context.t.screenSettingsNotifications.permissionMissingMessage,
                    actionLabel: context.t.screenSettingsNotifications.enable,
                    onAction: () => context.read<SettingsNotificationsCubit>().requestPermission(),
                  ),
                if (state.loadError)
                  _section(
                    context,
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.screenSettingsNotifications.loadError),
                        trailing: CupertinoButton(
                          sizeStyle: CupertinoButtonSize.small,
                          padding: EdgeInsets.zero,
                          onPressed: () => context.read<SettingsNotificationsCubit>().reload(),
                          child: Text(context.t.screenSettingsNotifications.retry),
                        ),
                      ),
                    ],
                  )
                else ...[
                  _section(
                    context,
                    header: context.t.screenSettingsNotifications.messageNotifications,
                    children: [
                      for (final scope in NotifyScope.values)
                        CupertinoListTile(
                          title: Text(_scopeTitle(context, scope)),
                          additionalInfo: Text(
                            state.scope(scope).enabled
                                ? context.t.screenSettingsNotifications.on
                                : context.t.screenSettingsNotifications.off,
                            style: TextStyle(color: secondary),
                          ),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () => _openScope(context, scope),
                        ),
                    ],
                  ),
                  _section(
                    context,
                    header: context.t.screenSettingsNotifications.events,
                    footer: state.readOnly
                        ? Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    context.t.screenSettingsNotifications.offlineNote,
                                    style: TextStyle(fontSize: AppFontSizes.caption),
                                  ),
                                ),
                                CupertinoButton(
                                  sizeStyle: CupertinoButtonSize.small,
                                  padding: EdgeInsets.zero,
                                  onPressed: () => context.read<SettingsNotificationsCubit>().reload(),
                                  child: const Icon(CupertinoIcons.arrow_clockwise, size: 20),
                                ),
                              ],
                            ),
                          )
                        : _note(context.t.screenSettingsNotifications.settingsSyncNote),
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.screenSettingsNotifications.contactJoined),
                        trailing: CupertinoSwitch(
                          value: state.contactJoined,
                          onChanged: state.readOnly ? null : (value) => _apply(context, (cubit) => cubit.setContactJoined(value)),
                        ),
                      ),
                      CupertinoListTile(
                        title: Text(context.t.screenSettingsNotifications.missedCalls),
                        trailing: CupertinoSwitch(
                          value: state.missedCalls,
                          onChanged: state.readOnly ? null : (value) => _apply(context, (cubit) => cubit.setMissedCalls(value)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
