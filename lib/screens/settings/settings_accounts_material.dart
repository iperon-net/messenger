import 'package:material_ui/material_ui.dart';

import '../../accounts.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import 'settings_accounts_common.dart';

/// «Настройки» → аккаунты: вошедшие (активный — с галочкой, тап по другому —
/// переключение) и «Добавить аккаунт».
class SettingsAccountsMaterial extends StatefulWidget {
  const SettingsAccountsMaterial({super.key});

  @override
  State<SettingsAccountsMaterial> createState() => _SettingsAccountsMaterial();
}

class _SettingsAccountsMaterial extends State<SettingsAccountsMaterial> with SettingsAccountsState {
  void _notice(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _open(AccountEntry account) async {
    if (account.active) return;
    if (callActive) return _notice(context.t.screenSettings.accountSwitchCallActive);
    await switchAccount(account.accountID);
  }

  Future<void> _add() async {
    if (callActive) return _notice(context.t.screenSettings.accountSwitchCallActive);
    if (!await canAddAccount()) {
      if (mounted) _notice(context.t.screenSettings.accountsLimit(count: maxAccounts));
      return;
    }
    await addAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (final account in accounts)
            ListTile(
              leading: CircleAvatar(foregroundImage: avatarOf(account), child: Text(initialOf(account))),
              title: Text(account.title),
              trailing: account.active ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
              onTap: () => _open(account),
            ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.add)),
            title: Text(context.t.screenSettings.addAccount),
            onTap: _add,
          ),
        ],
      ),
    );
  }
}
