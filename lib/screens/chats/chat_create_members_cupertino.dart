import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';
import 'chat_create_common.dart';
import 'chats_new_cupertino.dart';

/// «Новая группа», шаг 1 (iOS): выбор участников из контактов. Выбранные —
/// чипами сверху (тап — убрать), «Далее» — к названию и фото
/// (`/chats/new/group/info`). Можно никого не выбирать.
class ChatCreateMembersCupertino extends StatefulWidget {
  const ChatCreateMembersCupertino({super.key});

  @override
  State<ChatCreateMembersCupertino> createState() => _ChatCreateMembersCupertino();
}

class _ChatCreateMembersCupertino extends State<ChatCreateMembersCupertino> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final primary = CupertinoTheme.of(context).primaryColor;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);

    return BlocBuilder<ChatCreateCubit, ChatCreateState>(
      builder: (context, state) {
        final contacts = state.filtered;
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(t.screenNewChat.addMembers),
                  if (state.selected.isNotEmpty)
                    Text(
                      t.screenNewChat.selected(n: state.selected.length),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: secondary),
                    ),
                ],
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.push('/chats/new/group/info', extra: state.selected),
                child: Text(t.screenNewChat.next, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
              ),
            ),
          ),
          child: SafeArea(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                if (state.selected.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final member in state.selected)
                          GestureDetector(
                            onTap: () => context.read<ChatCreateCubit>().toggle(member),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(3, 3, 10, 3),
                              decoration: BoxDecoration(color: primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ContactAvatar(contact: member, size: 26),
                                  const SizedBox(width: 6),
                                  Text(member.name.split(' ').first, style: TextStyle(fontSize: 15, color: primary)),
                                  const SizedBox(width: 4),
                                  Icon(CupertinoIcons.xmark, size: 13, color: primary),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SearchFieldCupertino(
                    controller: _searchController,
                    placeholder: t.screenNewChat.search,
                    onChanged: (value) => context.read<ChatCreateCubit>().search(value),
                  ),
                ),
                if (contacts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      t.screenNewChat.noContacts,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: secondary),
                    ),
                  )
                else
                  CupertinoListSection.insetGrouped(
                    backgroundColor: background,
                    decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
                    footer: state.selected.isEmpty ? createNoteCupertino(t.screenNewChat.noMembersHint) : null,
                    children: [
                      for (final contact in contacts)
                        ContactTileCupertino(
                          contact: contact,
                          selected: state.isSelected(contact),
                          onTap: () => context.read<ChatCreateCubit>().toggle(contact),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
