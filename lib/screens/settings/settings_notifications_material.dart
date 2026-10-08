import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// «Уведомления и звуки»: типы чатов (drill-down на [SettingsNotificationsScopeMaterial]),
/// события («Новые контакты», «Пропущенные звонки») и предупреждение, если
/// системное разрешение не выдано. Настройки общие для всех устройств и
/// применяются сервером, поэтому offline — только просмотр.
class SettingsNotificationsMaterial extends StatefulWidget {
  const SettingsNotificationsMaterial({super.key});

  @override
  State<SettingsNotificationsMaterial> createState() => _SettingsNotificationsMaterial();
}

class _SettingsNotificationsMaterial extends State<SettingsNotificationsMaterial> {
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

  Future<void> _apply(BuildContext context, Future<bool> Function(SettingsNotificationsCubit cubit) change) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = context.t.common.noConnectionMessage;
    final ok = await change(context.read<SettingsNotificationsCubit>());
    if (ok) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Детейл-экран типа чатов; по возврату перечитываем (у него свой cubit).
  Future<void> _openScope(BuildContext context, NotifyScope scope) async {
    final cubit = context.read<SettingsNotificationsCubit>();
    await context.push("/settings/notifications/${scope.name}");
    await cubit.reload();
  }

  Widget _header(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
    child: Text(
      text,
      style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
    ),
  );

  Widget _note(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
    child: Text(
      text,
      style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
    ),
  );

  Widget _card(List<Widget> children) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(children: children),
  );

  /// «Реакции»: в личных / в группах и (если хоть что-то включено) «От кого»:
  /// всех / моих контактов.
  Widget _reactionsCard(BuildContext context, SettingsNotificationsState state) {
    final t = context.t.screenSettingsNotifications;
    final reactions = state.reactions;
    void set(NotifyReactionsSettings value) => _apply(context, (cubit) => cubit.setReactions(value));
    return _card([
      SwitchListTile(
        title: Text(t.reactionsPrivate),
        value: reactions.privateChats,
        onChanged: state.readOnly ? null : (value) => set(reactions.copyWith(privateChats: value)),
      ),
      SwitchListTile(
        title: Text(t.reactionsGroups),
        value: reactions.groups,
        onChanged: state.readOnly ? null : (value) => set(reactions.copyWith(groups: value)),
      ),
      if (reactions.privateChats || reactions.groups)
        ListTile(
          title: Text(t.reactionsFromShort),
          enabled: !state.readOnly,
          trailing: IgnorePointer(
            ignoring: state.readOnly,
            child: MaterialInlineDropdown<bool>(
              value: reactions.fromContacts,
              items: const [false, true],
              labelBuilder: (contacts) => contacts ? t.reactionsFromContacts : t.reactionsFromAll,
              onSelected: (contacts) => set(reactions.copyWith(fromContacts: contacts)),
            ),
          ),
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsNotificationsCubit, SettingsNotificationsState>(
      builder: (context, state) {
        final muted = Theme.of(context).colorScheme.onSurfaceVariant;
        return Scaffold(
          appBar: AppBar(title: Text(context.t.screenSettingsNotifications.notifications)),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          body: SafeArea(
            child: ListView(
              children: [
                if (state.permissionMissing)
                  PermissionBannerMaterial(
                    icon: HugeIcons.strokeRoundedNotificationOff03,
                    title: context.t.screenSettingsNotifications.permissionMissingTitle,
                    message: context.t.screenSettingsNotifications.permissionMissingMessage,
                    actionLabel: context.t.screenSettingsNotifications.enable,
                    onAction: () => context.read<SettingsNotificationsCubit>().requestPermission(),
                  ),
                if (state.loadError) ...[
                  const SizedBox(height: 16),
                  _card([
                    ListTile(
                      title: Text(context.t.screenSettingsNotifications.loadError),
                      trailing: TextButton(
                        onPressed: () => context.read<SettingsNotificationsCubit>().reload(),
                        child: Text(context.t.screenSettingsNotifications.retry),
                      ),
                    ),
                  ]),
                ] else ...[
                  _header(context, context.t.screenSettingsNotifications.messageNotifications),
                  _card([
                    for (final scope in NotifyScope.values)
                      ListTile(
                        title: Text(_scopeTitle(context, scope)),
                        subtitle: Text(
                          state.scope(scope).enabled ? context.t.screenSettingsNotifications.on : context.t.screenSettingsNotifications.off,
                        ),
                        trailing: Icon(Icons.chevron_right, color: muted),
                        onTap: () => _openScope(context, scope),
                      ),
                  ]),
                  // Реакции — пока только с демо чатов (настоящих чатов ещё нет).
                  if (context.read<CommonCubit>().state.settingsDevice.chatsDemo) ...[
                    _header(context, context.t.screenSettingsNotifications.reactions),
                    _reactionsCard(context, state),
                    _note(context, context.t.screenSettingsNotifications.reactionsNote),
                  ],
                  _header(context, context.t.screenSettingsNotifications.events),
                  _card([
                    SwitchListTile(
                      title: Text(context.t.screenSettingsNotifications.contactJoined),
                      value: state.contactJoined,
                      onChanged: state.readOnly ? null : (value) => _apply(context, (cubit) => cubit.setContactJoined(value)),
                    ),
                    SwitchListTile(
                      title: Text(context.t.screenSettingsNotifications.missedCalls),
                      value: state.missedCalls,
                      onChanged: state.readOnly ? null : (value) => _apply(context, (cubit) => cubit.setMissedCalls(value)),
                    ),
                  ]),
                  if (state.readOnly)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.t.screenSettingsNotifications.offlineNote,
                              style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.read<SettingsNotificationsCubit>().reload(),
                            icon: const Icon(Icons.refresh, size: 20),
                          ),
                        ],
                      ),
                    )
                  else
                    _note(context, context.t.screenSettingsNotifications.settingsSyncNote),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
