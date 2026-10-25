import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../accounts.dart';
import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'settings_accounts_common.dart';

/// «Настройки» → аккаунты: вошедшие (активный — с галочкой, у других —
/// непрочитанные; тап — переключение) и «Добавить аккаунт».
class SettingsAccountsCupertino extends StatefulWidget {
  const SettingsAccountsCupertino({super.key});

  @override
  State<SettingsAccountsCupertino> createState() => _SettingsAccountsCupertino();
}

class _SettingsAccountsCupertino extends State<SettingsAccountsCupertino> with SettingsAccountsState, _AccountsCupertino {
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
            // Отступы — как у строк с иконками ([CupertinoListTileIcon]).
            padding: const EdgeInsets.all(10),
            leading: avatar(account),
            title: Text(account.title),
            trailing: trailing(account),
            onTap: () => pickAccount(account),
          ),
        CupertinoListTile(
          padding: const EdgeInsets.all(10),
          leading: Icon(CupertinoIcons.add_circled, color: CupertinoTheme.of(context).primaryColor),
          title: Text(context.t.screenSettings.addAccount),
          onTap: startAddAccount,
        ),
      ],
    );
  }
}

/// Быстрый выбор аккаунта — долгий тап на вкладку «Настройки» (как в
/// Telegram): выпадающее меню аккаунтов над вкладкой. Прозрачная зона поверх
/// вкладки: обычный тап проходит к таб-бару, долгий — открывает меню.
class AccountSwitcherCupertino extends StatefulWidget {
  const AccountSwitcherCupertino({super.key});

  @override
  State<AccountSwitcherCupertino> createState() => _AccountSwitcherCupertino();
}

class _AccountSwitcherCupertino extends State<AccountSwitcherCupertino> with SettingsAccountsState, _AccountsCupertino {
  @override
  Widget build(BuildContext context) {
    return CupertinoMenuAnchor(
      useRootOverlay: true,
      onOpen: () => load(),
      menuChildren: [
        for (final account in accounts)
          CupertinoMenuItem(
            // Место под аватар шире стандартного (там — под иконку высотой со
            // строку текста): иначе круг сжимается по высоте и прилипает к
            // имени. Вертикальный отступ меньше, чтобы аватар вошёл по высоте.
            padding: const EdgeInsets.symmetric(vertical: 8),
            leadingWidth: 48,
            leadingMidpointAlignment: const AlignmentDirectional(-0.08, 0),
            leading: avatar(account, size: 28),
            trailing: trailing(account),
            onPressed: () => pickAccount(account),
            child: Text(account.title),
          ),
        CupertinoMenuItem(
          trailing: const Icon(CupertinoIcons.add_circled),
          onPressed: startAddAccount,
          child: Text(context.t.screenSettings.addAccount),
        ),
      ],
      builder: (context, controller, child) =>
          GestureDetector(behavior: HitTestBehavior.translucent, onLongPress: controller.open, child: const SizedBox.expand()),
    );
  }
}

/// Общее оформление строк аккаунта (Cupertino): аватар, галочка активного,
/// счётчик непрочитанных у остальных, диалог-сообщение.
mixin _AccountsCupertino<T extends StatefulWidget> on SettingsAccountsState<T> {
  @override
  Future<void> notice(String text) => showCupertinoDialog<void>(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(text),
      actions: [CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok))],
    ),
  );

  Widget avatar(AccountEntry account, {double size = 28}) {
    final image = avatarOf(account);
    return SizedBox(
      width: size,
      height: size,
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

  Widget? trailing(AccountEntry account) {
    if (account.active) return FaIcon(FontAwesomeIcons.solidCircleCheck, size: 18, color: CupertinoTheme.of(context).primaryColor);
    if (account.unread <= 0) return null;
    return Container(
      height: 20,
      constraints: const BoxConstraints(minWidth: 20),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: CupertinoColors.systemRed.resolveFrom(context), borderRadius: BorderRadius.circular(10)),
      child: Text(
        ChatTileContent.badge(account.unread),
        style: const TextStyle(color: CupertinoColors.white, fontSize: 13, fontWeight: FontWeight.w600, height: 1.1),
      ),
    );
  }
}
