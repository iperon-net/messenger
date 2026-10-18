import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../../utils.dart';

/// «Конфиденциальность» → «Заблокированные» (iOS): тап — профиль, справа —
/// «Разблокировать». Блокируют из профиля пользователя.
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
}
