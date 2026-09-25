import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// Детейл-экран приватности звонков (drill-down с «Конфиденциальности»):
/// выбор аудитории «кто может звонить» + секция «Исключения» (allow-list под
/// «Никто», deny-list под «Мои контакты»).
class SettingsPrivacyCallsMaterial extends StatelessWidget {
  const SettingsPrivacyCallsMaterial({super.key});

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

  /// Пытается применить выбор; при неудаче (offline/ошибка) — SnackBar «нет сети».
  Future<void> _onSelect(BuildContext context, CallsPrivacyAudience audience) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = context.t.common.noConnectionMessage;
    final ok = await context.read<SettingsPrivacyAndSecurityCubit>().setCallsAudience(audience);
    if (ok) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
        return Scaffold(
          appBar: AppBar(title: Text(context.t.sessionsPrivacyAndSecurity.calls)),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Text(
                    context.t.sessionsPrivacyAndSecurity.whoCanCall,
                    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      // Настройка не загрузилась (offline/ошибка) — не показываем
                      // дефолт как реальное значение, а даём повтор.
                      if (state.callsLoadError)
                        ListTile(
                          title: Text(context.t.sessionsPrivacyAndSecurity.callsLoadError),
                          trailing: TextButton(
                            onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadCalls(),
                            child: Text(context.t.sessionsPrivacyAndSecurity.retry),
                          ),
                        )
                      else
                        for (final audience in CallsPrivacyAudience.values)
                          ListTile(
                            title: Text(_audienceLabel(context, audience)),
                            onTap: state.callsReadOnly ? null : () async => _onSelect(context, audience),
                            trailing: state.callsAudience == audience ? check : null,
                          ),
                    ],
                  ),
                ),
                // Показываем значение из кэша, но менять нельзя — нет сети.
                // Даём повтор, чтобы перепроверить сеть не выходя с экрана.
                if (state.callsReadOnly)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 12, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.t.sessionsPrivacyAndSecurity.callsOfflineNote,
                            style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadCalls(),
                          icon: const Icon(Icons.refresh, size: 20),
                        ),
                      ],
                    ),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
