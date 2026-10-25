import 'package:material_ui/material_ui.dart';

import '../../accounts.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import 'settings_accounts_common.dart';

/// «Настройки» → аккаунты: вошедшие (активный — с галочкой, у других —
/// непрочитанные; тап — переключение) и «Добавить аккаунт». Он же — быстрый
/// выбор по долгому тапу на вкладку «Настройки» ([showAccountSwitcherMaterial]).
class SettingsAccountsMaterial extends StatefulWidget {
  /// Перед переключением / добавлением (закрыть шторку быстрого выбора).
  final VoidCallback? onPicked;

  const SettingsAccountsMaterial({super.key, this.onPicked});

  @override
  State<SettingsAccountsMaterial> createState() => _SettingsAccountsMaterial();
}

class _SettingsAccountsMaterial extends State<SettingsAccountsMaterial> with SettingsAccountsState {
  /// Аватар — размером с иконки соседних строк настроек ([MaterialListTileIcon]).
  static const _avatarSize = 28.0;

  @override
  Future<void> notice(String text) async {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _open(AccountEntry account) async {
    if (account.active) return;
    if (!callActive) widget.onPicked?.call();
    await pickAccount(account);
  }

  Future<void> _add() async {
    if (!callActive) widget.onPicked?.call();
    await startAddAccount();
  }

  Widget? _trailing(AccountEntry account) {
    if (account.active) return Icon(Icons.check, color: Theme.of(context).colorScheme.primary);
    if (account.unread <= 0) return null;
    return Badge(
      label: Text(ChatTileContent.badge(account.unread)),
      largeSize: 22,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final account in accounts)
            ListTile(
              leading: CircleAvatar(
                radius: _avatarSize / 2,
                foregroundImage: avatarOf(account),
                child: Text(initialOf(account), style: const TextStyle(fontSize: 13)),
              ),
              title: Text(account.title),
              trailing: _trailing(account),
              onTap: () => _open(account),
            ),
          ListTile(
            leading: const CircleAvatar(radius: _avatarSize / 2, child: Icon(Icons.add, size: 18)),
            title: Text(context.t.screenSettings.addAccount),
            onTap: _add,
          ),
        ],
      ),
    );
  }
}

/// Быстрый выбор аккаунта — долгий тап на вкладку «Настройки» (как в
/// Telegram): шторка со списком аккаунтов.
Future<void> showAccountSwitcherMaterial(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  showDragHandle: true,
  builder: (sheetContext) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: SettingsAccountsMaterial(onPicked: () => Navigator.of(sheetContext).pop()),
    ),
  ),
);
