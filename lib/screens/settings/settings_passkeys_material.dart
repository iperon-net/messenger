import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';
import '../../cubit.dart';
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

  Future<void> _confirmDelete(BuildContext context, PasskeyItem item) async {
    final cubit = context.read<SettingsPasskeysCubit>();
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
    if (confirmed == true) {
      await cubit.deletePasskey(item.credentialId);
    }
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
          body: state.status == Status.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        context.t.passkey.description,
                        style: TextStyle(fontSize: AppFontSizes.base, color: Theme.of(context).hintColor),
                      ),
                    ),
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
                        ListTile(
                          leading: FaIcon(passkeyProviderIcon(item.aaguid)),
                          title: Text(_title(context, item)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: busy ? null : () => _confirmDelete(context, item),
                          ),
                        ),
                    const Divider(),
                    ListTile(
                      leading: busy
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                          : const FaIcon(FontAwesomeIcons.plus),
                      title: Text(context.t.passkey.add),
                      onTap: busy ? null : () => context.read<SettingsPasskeysCubit>().addPasskey(),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
