import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// Настройка уведомлений одного типа чатов (drill-down с «Уведомлений и
/// звуков»): показывать / предпросмотр / звук. Пока уведомления выключены,
/// предпросмотр и звук не редактируются — как у Telegram.
class SettingsNotificationsScopeCupertino extends StatelessWidget {
  final NotifyScope scope;

  const SettingsNotificationsScopeCupertino({required this.scope, super.key});

  String _title(BuildContext context) => switch (scope) {
    NotifyScope.privateChats => context.t.screenSettingsNotifications.privateChats,
    NotifyScope.groups => context.t.screenSettingsNotifications.groups,
    NotifyScope.channels => context.t.screenSettingsNotifications.channels,
  };

  Future<void> _set(BuildContext context, NotifyScopeSettings settings) async {
    final ok = await context.read<SettingsNotificationsCubit>().setScope(scope, settings);
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsNotificationsCubit, SettingsNotificationsState>(
      builder: (context, state) {
        final settings = state.scope(scope);
        final locked = state.readOnly;
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(_title(context)),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  footer: Padding(
                    padding: const EdgeInsets.only(left: 13, right: 13),
                    child: Text(
                      state.readOnly
                          ? context.t.screenSettingsNotifications.offlineNote
                          : context.t.screenSettingsNotifications.messagePreviewNote,
                      style: TextStyle(fontSize: AppFontSizes.caption),
                    ),
                  ),
                  backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                  decoration: BoxDecoration(
                    color: ThemesCupertino.groupedCard.resolveFrom(context),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  children: state.loadError
                      ? [
                          CupertinoListTile(
                            title: Text(context.t.screenSettingsNotifications.loadError),
                            trailing: CupertinoButton(
                              sizeStyle: CupertinoButtonSize.small,
                              padding: EdgeInsets.zero,
                              onPressed: () => context.read<SettingsNotificationsCubit>().reload(),
                              child: Text(context.t.screenSettingsNotifications.retry),
                            ),
                          ),
                        ]
                      : [
                          CupertinoListTile(
                            title: Text(context.t.screenSettingsNotifications.showNotifications),
                            trailing: CupertinoSwitch(
                              value: settings.enabled,
                              onChanged: locked ? null : (value) => _set(context, settings.copyWith(enabled: value)),
                            ),
                          ),
                          CupertinoListTile(
                            title: Text(context.t.screenSettingsNotifications.messagePreview),
                            trailing: CupertinoSwitch(
                              value: settings.showPreviews,
                              onChanged: locked || !settings.enabled
                                  ? null
                                  : (value) => _set(context, settings.copyWith(showPreviews: value)),
                            ),
                          ),
                          CupertinoListTile(
                            title: Text(context.t.screenSettingsNotifications.sound),
                            trailing: CupertinoSwitch(
                              value: settings.sound,
                              onChanged: locked || !settings.enabled ? null : (value) => _set(context, settings.copyWith(sound: value)),
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
