import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../passkey_providers.dart';
import '../../themes.dart';

class SettingsPasskeysCupertino extends StatefulWidget {
  const SettingsPasskeysCupertino({super.key});

  @override
  State<SettingsPasskeysCupertino> createState() => _SettingsPasskeysCupertino();
}

class _SettingsPasskeysCupertino extends State<SettingsPasskeysCupertino> {
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

  void _showError(BuildContext context, String errorKey) {
    String message;
    try {
      message = context.t[errorKey];
    } catch (_) {
      message = context.t.grpcError.unknownError;
    }
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        content: Text(message),
        actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok))],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(context.t.passkey.deleteConfirmTitle),
        content: Text(context.t.passkey.deleteConfirmMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.t.passkey.delete),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Отдельная страница «нет сети» (загрузка списка не прошла из-за отсутствия
  /// связи) — иконка, заголовок/пояснение из общих строк, кнопка «Повторить».
  Widget _offline(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.wifi_slash, size: 48, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
            const SizedBox(height: 16),
            Text(
              context.t.common.noConnectionTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              context.t.common.noConnectionMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: () => context.read<SettingsPasskeysCubit>().initialization(),
              child: Text(context.t.passkey.retry),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsPasskeysCubit, SettingsPasskeysState>(
      listenWhen: (previous, current) => previous.error != current.error && current.error.isNotEmpty,
      listener: (context, state) => _showError(context, state.error),
      builder: (context, state) {
        final busy = state.networkStatus == Status.loading;
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(context.t.passkey.title),
            ),
          ),
          child: SafeArea(
            child: state.offline
                ? _offline(context)
                : state.status == Status.loading
                ? const Center(child: CupertinoActivityIndicator())
                : ListView(
                    children: [
                      const SizedBox(height: 20),
                      CupertinoListSection.insetGrouped(
                        backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                        decoration: BoxDecoration(
                          color: ThemesCupertino.groupedCard.resolveFrom(context),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        footer: Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Text(context.t.passkey.description, style: TextStyle(fontSize: AppFontSizes.caption)),
                        ),
                        children: [
                          if (state.loadError)
                            CupertinoListTile(
                              title: Text(context.t.passkey.loadError),
                              trailing: CupertinoButton(
                                padding: EdgeInsets.zero,
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
                                  color: CupertinoColors.systemRed.resolveFrom(context),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: const Icon(CupertinoIcons.delete, color: CupertinoColors.white),
                                ),
                                child: CupertinoListTileIcon(
                                  title: Text(_title(context, item)),
                                  subtitle: Text(_subtitle(context, item)),
                                  color: passkeyProviderColor(item.aaguid),
                                  iconAsset: passkeyProviderIconAsset(item.aaguid),
                                  icon: passkeyProviderIconAsset(item.aaguid) == null ? passkeyProviderIcon(item.aaguid) : null,
                                  onTab: null,
                                ),
                              ),
                          CupertinoListTileIcon(
                            title: Text(context.t.passkey.add),
                            color: const Color(0xFFFF9500),
                            hugeIcon: HugeIcons.strokeRoundedPlus,
                            trailing: busy ? const CupertinoActivityIndicator() : null,
                            onTab: busy ? null : () => context.read<SettingsPasskeysCubit>().addPasskey(),
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
