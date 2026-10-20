import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import '../../chats/member_search.dart';
import 'chats_new_cupertino.dart';

/// «Заблокированные» (iOS) — профиль группы → админ.
Future<void> showChatBannedCupertino(BuildContext context, ChatCubit cubit) {
  // Список — только с сервера: освежаем при открытии (без сети — пометка).
  unawaited(cubit.loadMembers());
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const ChatBannedCupertino()),
    ),
  );
}

/// Заблокированные участники: поиск по имени / @username, справа —
/// «Разблокировать» (строка рассыпается в пыль).
class ChatBannedCupertino extends StatefulWidget {
  const ChatBannedCupertino({super.key});

  @override
  State<ChatBannedCupertino> createState() => _ChatBannedCupertinoState();
}

class _ChatBannedCupertinoState extends State<ChatBannedCupertino> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final found = filterMembers(state.banned, _query);
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(t.screenChatInfo.banned),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                if (state.banned.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: CupertinoSearchTextField(
                      placeholder: t.screenChatInfo.membersSearch,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                if (found.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 40, 32, 8),
                    child: Text(
                      state.banned.isNotEmpty
                          ? t.screenChatInfo.membersNotFound
                          : (state.bannedLoadFailed ? t.screenChatInfo.bannedLoadFailed : t.screenChatInfo.bannedEmpty),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: AppFontSizes.body, color: secondary),
                    ),
                  )
                else
                  CupertinoListSection.insetGrouped(
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    children: [
                      for (final member in found)
                        DustDismiss(
                          key: ValueKey(member.id),
                          builder: (context, dissolve) => Row(
                            children: [
                              Expanded(child: ContactTileCupertino(contact: member)),
                              Semantics(
                                label: t.screenChatInfo.unban,
                                button: true,
                                child: CupertinoButton(
                                  padding: const EdgeInsets.only(left: 8, right: 16),
                                  onPressed: () {
                                    final cubit = context.read<ChatCubit>();
                                    dissolve(() => cubit.unbanMember(member));
                                  },
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedDelete02,
                                    size: 22,
                                    color: ThemesCupertino.actionColor(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: createNoteCupertino(t.screenChatInfo.bannedFooter),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
