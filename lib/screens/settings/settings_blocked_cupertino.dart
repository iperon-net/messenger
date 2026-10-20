import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

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
class SettingsBlockedCupertino extends StatefulWidget {
  const SettingsBlockedCupertino({super.key});

  @override
  State<SettingsBlockedCupertino> createState() => _SettingsBlockedCupertinoState();
}

class _SettingsBlockedCupertinoState extends State<SettingsBlockedCupertino> {
  String _query = '';

  /// Заблокированные под поиском: каждое слово запроса — начало какого-то
  /// слова имени.
  List<BlockedUser> _found(List<BlockedUser> users) {
    final words = _query.trim().toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return users;
    return [
      for (final u in users)
        if (words.every((q) => u.name.toLowerCase().split(RegExp(r'\s+')).any((w) => w.startsWith(q)))) u,
    ];
  }

  /// Поля уже стандартных (20 / 20+14): список людей во всю ширину экрана.
  static const _sectionMargin = EdgeInsets.fromLTRB(12, 0, 12, 10);
  static const _tilePadding = EdgeInsetsDirectional.only(start: 14, end: 12, top: 8, bottom: 8);

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
                      margin: _sectionMargin,
                      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                      decoration: BoxDecoration(
                        color: ThemesCupertino.groupedCard.resolveFrom(context),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      children: [
                        CupertinoListTile(
                          padding: _tilePadding,
                          leading: HugeIcon(
                            icon: HugeIcons.strokeRoundedUserBlock01,
                            size: 22,
                            color: ThemesCupertino.actionColor(context),
                          ),
                          title: Text(t.blockUser, style: TextStyle(color: ThemesCupertino.actionColor(context))),
                          onTap: () => _blockUser(context),
                        ),
                      ],
                    ),
                    if (state.users.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                        child: CupertinoSearchTextField(
                          placeholder: context.t.screenContacts.search,
                          onChanged: (value) => setState(() => _query = value),
                        ),
                      ),
                    CupertinoListSection.insetGrouped(
                      margin: _sectionMargin,
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
                        if (_found(state.users).isEmpty)
                          CupertinoListTile(
                            padding: _tilePadding,
                            title: Text(state.users.isEmpty ? t.blockedEmpty : t.blockedNotFound, style: TextStyle(color: secondary)),
                          )
                        else
                          for (final user in _found(state.users))
                            // Разблокировали — строка рассыпается в пыль.
                            DustDismiss(
                              key: ValueKey(utils.bytesToHex(user.userID)),
                              builder: (context, dissolve) => CupertinoListTile(
                                padding: _tilePadding,
                                leading: UserAvatar(userID: user.userID, placeholderName: utils.bytesToHex(user.userID)),
                                title: Text(user.name.isEmpty ? t.unknownUser : user.name),
                                trailing: Semantics(
                                  label: t.unblock,
                                  button: true,
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.only(left: 8),
                                    onPressed: () {
                                      final cubit = context.read<SettingsBlockedCubit>();
                                      dissolve(() => cubit.unblock(user));
                                    },
                                    child: HugeIcon(
                                      icon: HugeIcons.strokeRoundedDelete02,
                                      size: 22,
                                      color: ThemesCupertino.actionColor(context),
                                    ),
                                  ),
                                ),
                                onTap: () => context.push('/profile/${utils.bytesToHex(user.userID)}'),
                              ),
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
