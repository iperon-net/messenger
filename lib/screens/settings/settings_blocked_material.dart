import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../utils.dart';

/// «Конфиденциальность» → «Заблокированные» (Android): тап — профиль, справа —
/// «Разблокировать». Блокируют из профиля пользователя.
class SettingsBlockedMaterial extends StatelessWidget {
  const SettingsBlockedMaterial({super.key});

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
                  padding: const EdgeInsets.all(10),
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          if (state.users.isEmpty)
                            ListTile(
                              title: Text(t.blockedEmpty, style: TextStyle(color: secondary)),
                            )
                          else
                            for (final user in state.users)
                              ListTile(
                                leading: UserAvatar(userID: user.userID, placeholderName: utils.bytesToHex(user.userID)),
                                title: Text(user.name.isEmpty ? t.unknownUser : user.name),
                                trailing: TextButton(
                                  onPressed: () => context.read<SettingsBlockedCubit>().unblock(user),
                                  child: Text(t.unblock),
                                ),
                                onTap: () => context.push('/profile/${utils.bytesToHex(user.userID)}'),
                              ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(t.blockedNote, style: TextStyle(fontSize: 13, color: secondary)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
