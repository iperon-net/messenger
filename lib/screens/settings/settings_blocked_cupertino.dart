import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../../utils.dart';
import '../chats/forward_picker.dart';

/// «Конфиденциальность» → «Заблокированные» (iOS): сверху «Заблокировать
/// пользователя» (выбор из чатов и контактов), тап по строке — профиль, справа —
/// «Разблокировать». Блокировать можно и из профиля пользователя.
class SettingsBlockedCupertino extends StatelessWidget {
  const SettingsBlockedCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.sessionsPrivacyAndSecurity;
    final utils = getIt.get<Utils>();
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    return BlocConsumer<SettingsBlockedCubit, SettingsBlockedState>(
      listenWhen: (previous, current) => current.offlineNotice > previous.offlineNotice,
      listener: (context, state) => showNoConnectionAlert(context),
      builder: (context, state) => CupertinoPageScaffold(
        backgroundColor: ThemesCupertino.groupedBackground,
        navigationBar: AppCupertinoNavigationBar(
          child: CupertinoNavigationBar(
            previousPageTitle: '',
            automaticBackgroundVisibility: false,
            backgroundColor: ThemesCupertino.groupedBackground,
            middle: Text(t.blocked),
          ),
        ),
        child: SafeArea(
          child: state.status != Status.success
              ? const Center(child: CupertinoActivityIndicator())
              : ListView(
                  children: [
                    CupertinoListSection.insetGrouped(
                      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                      decoration: BoxDecoration(
                        color: ThemesCupertino.groupedCard.resolveFrom(context),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      children: [
                        CupertinoListTile(
                          leading: FaIcon(FontAwesomeIcons.userSlash, size: 20, color: ThemesCupertino.actionColor(context)),
                          title: Text(t.blockUser, style: TextStyle(color: ThemesCupertino.actionColor(context))),
                          onTap: () => _blockUser(context),
                        ),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                      decoration: BoxDecoration(
                        color: ThemesCupertino.groupedCard.resolveFrom(context),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      footer: Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Text(t.blockedNote, style: TextStyle(fontSize: 13, color: secondary)),
                      ),
                      children: [
                        if (state.users.isEmpty)
                          CupertinoListTile(
                            title: Text(t.blockedEmpty, style: TextStyle(color: secondary)),
                          )
                        else
                          for (final user in state.users)
                            CupertinoListTile(
                              leading: UserAvatar(userID: user.userID, placeholderName: utils.bytesToHex(user.userID)),
                              title: Text(user.name.isEmpty ? t.unknownUser : user.name),
                              trailing: CupertinoButton(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                onPressed: () => context.read<SettingsBlockedCubit>().unblock(user),
                                child: Text(t.unblock),
                              ),
                              onTap: () => context.push('/profile/${utils.bytesToHex(user.userID)}'),
                            ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// «Заблокировать пользователя»: выбор из чатов и контактов → подтверждение
  /// (как в профиле) → блок; без сети — «Нет соединения» (через offlineNotice).
  Future<void> _blockUser(BuildContext context) async {
    final cubit = context.read<SettingsBlockedCubit>();
    final t = context.t;
    final candidates = await cubit.candidates();
    if (!context.mounted) return;
    final user = await showUserPicker(
      context,
      title: t.sessionsPrivacyAndSecurity.blockUserPick,
      emptyText: t.sessionsPrivacyAndSecurity.blockUserEmpty,
      users: [for (final c in candidates) (userID: c.userID, name: c.name)],
    );
    if (user == null || !context.mounted) return;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.screenProfile.blockTitle(name: user.name)),
        content: Text(t.screenProfile.blockMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(t.common.cancel)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.screenProfile.block),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.block(user.userID);
  }
}
