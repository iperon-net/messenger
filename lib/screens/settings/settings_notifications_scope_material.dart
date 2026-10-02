import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// Настройка уведомлений одного типа чатов (drill-down с «Уведомлений и
/// звуков»): показывать / предпросмотр / звук. Пока уведомления выключены,
/// предпросмотр и звук не редактируются — как у Telegram.
class SettingsNotificationsScopeMaterial extends StatelessWidget {
  final NotifyScope scope;

  const SettingsNotificationsScopeMaterial({required this.scope, super.key});

  String _title(BuildContext context) => switch (scope) {
    NotifyScope.privateChats => context.t.screenSettingsNotifications.privateChats,
    NotifyScope.groups => context.t.screenSettingsNotifications.groups,
    NotifyScope.channels => context.t.screenSettingsNotifications.channels,
  };

  Future<void> _set(BuildContext context, NotifyScopeSettings settings) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = context.t.common.noConnectionMessage;
    final ok = await context.read<SettingsNotificationsCubit>().setScope(scope, settings);
    if (ok) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsNotificationsCubit, SettingsNotificationsState>(
      builder: (context, state) {
        final settings = state.scope(scope);
        final locked = state.readOnly;
        final muted = Theme.of(context).colorScheme.onSurfaceVariant;
        return Scaffold(
          appBar: AppBar(title: Text(_title(context))),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          body: SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 16),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: state.loadError
                        ? [
                            ListTile(
                              title: Text(context.t.screenSettingsNotifications.loadError),
                              trailing: TextButton(
                                onPressed: () => context.read<SettingsNotificationsCubit>().reload(),
                                child: Text(context.t.screenSettingsNotifications.retry),
                              ),
                            ),
                          ]
                        : [
                            SwitchListTile(
                              title: Text(context.t.screenSettingsNotifications.showNotifications),
                              value: settings.enabled,
                              onChanged: locked ? null : (value) => _set(context, settings.copyWith(enabled: value)),
                            ),
                            SwitchListTile(
                              title: Text(context.t.screenSettingsNotifications.messagePreview),
                              value: settings.showPreviews,
                              onChanged: locked || !settings.enabled
                                  ? null
                                  : (value) => _set(context, settings.copyWith(showPreviews: value)),
                            ),
                            SwitchListTile(
                              title: Text(context.t.screenSettingsNotifications.sound),
                              value: settings.sound,
                              onChanged: locked || !settings.enabled ? null : (value) => _set(context, settings.copyWith(sound: value)),
                            ),
                          ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Text(
                    state.readOnly
                        ? context.t.screenSettingsNotifications.offlineNote
                        : context.t.screenSettingsNotifications.messagePreviewNote,
                    style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
