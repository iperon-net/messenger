import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// Детейл-экран «Группы» — кто может добавлять меня в группы (drill-down с
/// «Конфиденциальности»): выбор аудитории + секция «Исключения» (allow под
/// «Никто», deny под «Мои контакты»). Гейт серверный — при создании группы и
/// добавлении участников; кому нельзя, тот меня не добавит.
class SettingsPrivacyGroupInvitesMaterial extends StatelessWidget {
  const SettingsPrivacyGroupInvitesMaterial({super.key});

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

  void _noConnectionSnack(ScaffoldMessengerState messenger, String message) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Пытается применить выбор аудитории; при неудаче (offline/ошибка) — SnackBar.
  Future<void> _onSelect(BuildContext context, CallsPrivacyAudience audience) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = context.t.common.noConnectionMessage;
    final ok = await context.read<SettingsPrivacyAndSecurityCubit>().setGroupInvitesAudience(audience);
    if (ok) return;
    _noConnectionSnack(messenger, message);
  }

  /// Открывает пикер списка-исключений ([kind]) для канала «группы»;
  /// по возврату перечитывает настройку, чтобы счётчик обновился.
  Future<void> _openList(BuildContext context, SettingsPrivacyAndSecurityState state, CallsListKind kind) async {
    final cubit = context.read<SettingsPrivacyAndSecurityCubit>();
    final isAllow = kind == CallsListKind.allow;
    await context.push(
      isAllow ? "/settings/privacy_and_security/group_invites/allow" : "/settings/privacy_and_security/group_invites/deny",
      extra: isAllow ? state.groupInvitesAllow : state.groupInvitesDeny,
    );
    await cubit.reloadGroupInvites();
  }

  Widget _exceptionsSection(BuildContext context, {required String label, required int count, required VoidCallback? onTap}) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            context.t.sessionsPrivacyAndSecurity.exceptions,
            style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: ListTile(
            title: Text(label),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                Text("$count", style: TextStyle(color: muted)),
                Icon(Icons.chevron_right, color: muted),
              ],
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final check = Icon(Icons.check, size: 22, color: Theme.of(context).colorScheme.primary);

    return BlocBuilder<SettingsPrivacyAndSecurityCubit, SettingsPrivacyAndSecurityState>(
      builder: (context, state) {
        final muted = Theme.of(context).colorScheme.onSurfaceVariant;
        return Scaffold(
          appBar: AppBar(title: Text(context.t.sessionsPrivacyAndSecurity.groupInvites)),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Text(
                    context.t.sessionsPrivacyAndSecurity.whoCanAddToGroups,
                    style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      if (state.callsLoadError)
                        ListTile(
                          title: Text(context.t.sessionsPrivacyAndSecurity.callsLoadError),
                          trailing: TextButton(
                            onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadGroupInvites(),
                            child: Text(context.t.sessionsPrivacyAndSecurity.retry),
                          ),
                        )
                      else
                        for (final audience in CallsPrivacyAudience.values)
                          ListTile(
                            title: Text(_audienceLabel(context, audience)),
                            onTap: state.callsReadOnly ? null : () async => _onSelect(context, audience),
                            trailing: state.groupInvitesAudience == audience ? check : null,
                          ),
                    ],
                  ),
                ),
                if (state.callsReadOnly)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.t.sessionsPrivacyAndSecurity.callsOfflineNote,
                            style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadGroupInvites(),
                          icon: const Icon(Icons.refresh, size: 20),
                        ),
                      ],
                    ),
                  )
                else if (!state.callsLoadError)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: Text(
                      context.t.sessionsPrivacyAndSecurity.groupInvitesNote,
                      style: TextStyle(fontSize: AppFontSizes.caption, color: muted),
                    ),
                  ),
                // Исключения под «Никто»: allow-list «всегда разрешать».
                if (state.groupInvitesAudience == CallsPrivacyAudience.nobody && !state.callsLoadError)
                  _exceptionsSection(
                    context,
                    label: context.t.sessionsPrivacyAndSecurity.callsAlwaysAllow,
                    count: state.groupInvitesAllow.length,
                    onTap: state.callsReadOnly ? null : () => _openList(context, state, CallsListKind.allow),
                  ),
                // Исключения под «Мои контакты»: deny-list «всегда запрещать».
                if (state.groupInvitesAudience == CallsPrivacyAudience.contacts && !state.callsLoadError)
                  _exceptionsSection(
                    context,
                    label: context.t.sessionsPrivacyAndSecurity.callsAlwaysDeny,
                    count: state.groupInvitesDeny.length,
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
