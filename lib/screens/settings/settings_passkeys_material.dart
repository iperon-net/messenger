import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../passkey_providers.dart';
import '../../themes.dart';

class SettingsPasskeysMaterial extends StatefulWidget {
  const SettingsPasskeysMaterial({super.key});

  @override
  State<SettingsPasskeysMaterial> createState() => _SettingsPasskeysMaterial();
}

class _SettingsPasskeysMaterial extends State<SettingsPasskeysMaterial> {
  String _title(BuildContext context, PasskeyItem item) {
    if (item.label.isNotEmpty) return item.label;
    final provider = passkeyProviderName(item.aaguid);
    return provider.isNotEmpty ? provider : context.t.passkey.genericName;
  }

  /// Подзаголовок: когда добавлен и когда был последний вход.
  String _subtitle(BuildContext context, PasskeyItem item) {
    final created = context.t.passkey.created(date: DateTime.fromMillisecondsSinceEpoch(item.createdAt * 1000).relativeFormat(context.t));
    if (item.lastUsedAt <= 0) return created;
    final used = context.t.passkey.lastUsed(date: DateTime.fromMillisecondsSinceEpoch(item.lastUsedAt * 1000).relativeFormat(context.t));
    return "$created · $used";
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.t.passkey.deleteConfirmTitle),
        content: Text(context.t.passkey.deleteConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(context.t.passkey.delete)),
        ],
      ),
    );
    return confirmed ?? false;
  }

  /// Отдельная страница «нет сети» (загрузка списка не прошла из-за отсутствия
  /// связи) — иконка, заголовок/пояснение из общих строк, кнопка «Повторить».
  Widget _offline(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: scheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(context.t.common.noConnectionTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              context.t.common.noConnectionMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: () => context.read<SettingsPasskeysCubit>().initialization(), child: Text(context.t.passkey.retry)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsPasskeysCubit, SettingsPasskeysState>(
      listenWhen: (previous, current) => previous.error != current.error && current.error.isNotEmpty,
      listener: (context, state) {
        String message;
        try {
          message = context.t[state.error];
        } catch (_) {
          message = context.t.grpcError.unknownError;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      },
      builder: (context, state) {
        final busy = state.networkStatus == Status.loading;
        return Scaffold(
          appBar: AppBar(title: Text(context.t.passkey.title)),
          body: state.offline
              ? _offline(context)
              : state.status == Status.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          if (state.loadError)
                            ListTile(
                              title: Text(context.t.passkey.loadError),
                              trailing: TextButton(
                                onPressed: () => context.read<SettingsPasskeysCubit>().initialization(),
                                child: Text(context.t.passkey.retry),
                              ),
                            )
                          else
                            for (final item in state.items)
                              Dismissible(
                                key: ValueKey('pk_${item.credentialId.join("-")}'),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (_) async {
                                  final ok = await _confirmDelete(context);
                                  // Удаляем сами (со сбросом списка), Dismissible не «схлопываем»,
                                  // чтобы не оставить в дереве уже удалённый виджет.
                                  if (ok && context.mounted) context.read<SettingsPasskeysCubit>().deletePasskey(item.credentialId);
                                  return false;
                                },
                                background: Container(
                                  color: Theme.of(context).colorScheme.error,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onError),
                                ),
                                child: MaterialListTileIcon(
                                  title: Text(_title(context, item)),
                                  subtitle: Text(_subtitle(context, item)),
                                  color: passkeyProviderColor(item.aaguid),
                                  iconAsset: passkeyProviderIconAsset(item.aaguid),
                                  icon: passkeyProviderIconAsset(item.aaguid) == null ? passkeyProviderIcon(item.aaguid) : null,
                                  onTab: null,
                                ),
                              ),
                          MaterialListTileIcon(
                            title: Text(context.t.passkey.add),
                            color: const Color(0xFFFF9500),
                            hugeIcon: HugeIcons.strokeRoundedPlus,
                            additionalInfo: busy
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : null,
                            onTab: busy ? null : () async => context.read<SettingsPasskeysCubit>().addPasskey(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                      child: Text(
                        context.t.passkey.description,
                        style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
