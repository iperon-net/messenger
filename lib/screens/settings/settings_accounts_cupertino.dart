import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../accounts.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'settings_accounts_common.dart';

/// «Настройки» → аккаунты: вошедшие (активный — с галочкой, тап по другому —
/// переключение) и «Добавить аккаунт».
class SettingsAccountsCupertino extends StatefulWidget {
  const SettingsAccountsCupertino({super.key});

  @override
  State<SettingsAccountsCupertino> createState() => _SettingsAccountsCupertino();
}

class _SettingsAccountsCupertino extends State<SettingsAccountsCupertino> with SettingsAccountsState {
  Future<void> _notice(String text) => showCupertinoDialog<void>(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(text),
      actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok))],
    ),
  );

  Future<void> _open(AccountEntry account) async {
    if (account.active) return;
    if (callActive) return _notice(context.t.screenSettings.accountSwitchCallActive);
    await switchAccount(account.accountID);
  }

  Future<void> _add() async {
    if (callActive) return _notice(context.t.screenSettings.accountSwitchCallActive);
    if (!await canAddAccount()) {
      if (mounted) await _notice(context.t.screenSettings.accountsLimit(count: maxAccounts));
      return;
    }
    await addAccount();
  }

  Widget _avatar(AccountEntry account) {
    final image = avatarOf(account);
    return SizedBox(
      width: 32,
      height: 32,
      child: ClipOval(
        child: image != null
            ? Image(image: image, fit: BoxFit.cover)
            : ColoredBox(
                color: CupertinoColors.systemGrey4.resolveFrom(context),
                child: Center(child: Text(initialOf(account))),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
      decoration: BoxDecoration(
        color: ThemesCupertino.groupedCard.resolveFrom(context),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      children: [
        for (final account in accounts)
          CupertinoListTile(
            leading: _avatar(account),
            title: Text(account.title),
            trailing: account.active
                ? FaIcon(FontAwesomeIcons.solidCircleCheck, size: 18, color: CupertinoTheme.of(context).primaryColor)
                : null,
            onTap: () => _open(account),
          ),
        CupertinoListTile(
          leading: Icon(CupertinoIcons.add_circled, color: CupertinoTheme.of(context).primaryColor),
          title: Text(context.t.screenSettings.addAccount),
          onTap: _add,
        ),
      ],
    );
  }
}
