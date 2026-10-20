import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../utils.dart';
import '../chats/forward_picker.dart';

/// «Конфиденциальность» → «Заблокированные» (Android): сверху «Заблокировать
/// пользователя» (выбор из чатов и контактов), тап по строке — профиль, справа —
/// «Разблокировать». Блокировать можно и из профиля пользователя.
class SettingsBlockedMaterial extends StatefulWidget {
  const SettingsBlockedMaterial({super.key});

  @override
  State<SettingsBlockedMaterial> createState() => _SettingsBlockedMaterialState();
}

class _SettingsBlockedMaterialState extends State<SettingsBlockedMaterial> {
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

  @override
  Widget build(BuildContext context) {
    final t = context.t.sessionsPrivacyAndSecurity;
    final utils = getIt.get<Utils>();
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    return BlocConsumer<SettingsBlockedCubit, SettingsBlockedState>(
      listenWhen: (previous, current) => current.offlineNotice > previous.offlineNotice,
      listener: (context, state) => showNoConnectionAlert(context),
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text(t.blocked)),
        body: SafeArea(
          child: state.status != Status.success
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        leading: HugeIcon(icon: HugeIcons.strokeRoundedUserBlock01, color: Theme.of(context).colorScheme.primary),
                        title: Text(t.blockUser, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                        onTap: () => _blockUser(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (state.users.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: context.t.screenContacts.search,
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (value) => setState(() => _query = value),
                        ),
                      ),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          if (_found(state.users).isEmpty)
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              title: Text(state.users.isEmpty ? t.blockedEmpty : t.blockedNotFound, style: TextStyle(color: secondary)),
                            )
                          else
                            for (final user in _found(state.users))
                              // Разблокировали — строка рассыпается в пыль.
                              DustDismiss(
                                key: ValueKey(utils.bytesToHex(user.userID)),
                                builder: (context, dissolve) => ListTile(
                                  contentPadding: const EdgeInsets.only(left: 12, right: 4),
                                  leading: UserAvatar(userID: user.userID, placeholderName: utils.bytesToHex(user.userID)),
                                  title: Text(user.name.isEmpty ? t.unknownUser : user.name),
                                  trailing: IconButton(
                                    tooltip: t.unblock,
                                    onPressed: () {
                                      final cubit = context.read<SettingsBlockedCubit>();
                                      dissolve(() => cubit.unblock(user));
                                    },
                                    icon: HugeIcon(icon: HugeIcons.strokeRoundedDelete02, color: Theme.of(context).colorScheme.primary),
                                  ),
                                  onTap: () => context.push('/profile/${utils.bytesToHex(user.userID)}'),
                                ),
                              ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: Text(t.blockedNote, style: TextStyle(fontSize: 13, color: secondary)),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.screenProfile.blockTitle(name: user.name)),
        content: Text(t.screenProfile.blockMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(t.common.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.screenProfile.block),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.block(user.userID);
  }
}
