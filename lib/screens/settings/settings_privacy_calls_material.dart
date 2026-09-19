import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

/// Детейл-экран приватности звонков (drill-down с «Конфиденциальности»).
/// Пока держит только выбор аудитории «кто может звонить»; секции ниже
/// (исключения, favorites) добавятся следующими этапами.
class SettingsPrivacyCallsMaterial extends StatelessWidget {
  const SettingsPrivacyCallsMaterial({super.key});

  String _audienceLabel(BuildContext context, CallsPrivacyAudience audience) {
    return audience == CallsPrivacyAudience.everybody
        ? context.t.sessionsPrivacyAndSecurity.callsEverybody
        : context.t.sessionsPrivacyAndSecurity.callsContacts;
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
                        TextButton(
                          onPressed: () => context.read<SettingsPrivacyAndSecurityCubit>().reloadCalls(),
                          child: Text(context.t.sessionsPrivacyAndSecurity.retry),
                        ),
                      ],
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
