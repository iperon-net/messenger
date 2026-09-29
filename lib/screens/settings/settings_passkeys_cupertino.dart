import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
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

  Future<void> _confirmDelete(BuildContext context, PasskeyItem item) async {
    final cubit = context.read<SettingsPasskeysCubit>();
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(context.t.passkey.deleteConfirmTitle),
        content: Text(context.t.passkey.deleteConfirmMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.deletePasskey(item.credentialId);
            },
            child: Text(context.t.passkey.delete),
          ),
        ],
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
            child: state.status == Status.loading
                ? const Center(child: CupertinoActivityIndicator())
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                        child: Text(
                          context.t.passkey.description,
                          style: TextStyle(fontSize: AppFontSizes.base, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                      ),
                      if (state.loadError)
                        CupertinoListSection.insetGrouped(
                          backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                          children: [
                            CupertinoListTile(
                              title: Text(context.t.passkey.loadError),
                              trailing: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => context.read<SettingsPasskeysCubit>().initialization(),
                                child: Text(context.t.passkey.retry),
                              ),
                            ),
                          ],
                        )
                      else if (state.items.isNotEmpty)
                        CupertinoListSection.insetGrouped(
                          backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                          decoration: BoxDecoration(
                            color: ThemesCupertino.groupedCard.resolveFrom(context),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          children: [
                            for (final item in state.items)
                              CupertinoListTile(
                                leading: FaIcon(passkeyProviderIcon(item.aaguid), color: CupertinoColors.systemBlue.resolveFrom(context)),
                                title: Text(_title(context, item)),
                                trailing: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: busy ? null : () => _confirmDelete(context, item),
                                  child: Icon(CupertinoIcons.delete, color: CupertinoColors.systemRed.resolveFrom(context)),
                                ),
                              ),
                          ],
                        ),
                      CupertinoListSection.insetGrouped(
                        backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                        decoration: BoxDecoration(
                          color: ThemesCupertino.groupedCard.resolveFrom(context),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        children: [
                          CupertinoListTile(
                            leading: const FaIcon(FontAwesomeIcons.plus, color: CupertinoColors.activeBlue),
                            title: Text(context.t.passkey.add, style: const TextStyle(color: CupertinoColors.activeBlue)),
                            trailing: busy ? const CupertinoActivityIndicator() : null,
                            onTap: busy ? null : () => context.read<SettingsPasskeysCubit>().addPasskey(),
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
