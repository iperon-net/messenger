import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import 'chat_create_common.dart';
import 'chats_new_material.dart';

/// «Новая группа», шаг 1 (Android): выбор участников из контактов. Выбранные —
/// чипами сверху (× — убрать), кнопка «→» — к названию и фото
/// (`/chats/new/group/info`). Можно никого не выбирать.
class ChatCreateMembersMaterial extends StatefulWidget {
  const ChatCreateMembersMaterial({super.key});

  @override
  State<ChatCreateMembersMaterial> createState() => _ChatCreateMembersMaterial();
}

class _ChatCreateMembersMaterial extends State<ChatCreateMembersMaterial> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<ChatCreateCubit, ChatCreateState>(
      builder: (context, state) {
        final contacts = state.filtered;
        return Scaffold(
          backgroundColor: scheme.surfaceContainerLow,
          appBar: AppBar(
            backgroundColor: scheme.surfaceContainerLow,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.screenNewChat.addMembers),
                if (state.selected.isNotEmpty)
                  Text(
                    t.screenNewChat.selected(n: state.selected.length),
                    style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: t.screenNewChat.next,
            onPressed: () => context.push('/chats/new/group/info', extra: state.selected),
            child: const Icon(Icons.arrow_forward),
          ),
          body: SafeArea(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(bottom: 88),
              children: [
                if (state.selected.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final member in state.selected)
                          InputChip(
                            avatar: ContactAvatar(contact: member, size: 24),
                            label: Text(member.name.split(' ').first),
                            onDeleted: () => context.read<ChatCreateCubit>().toggle(member),
                            onPressed: () => context.read<ChatCreateCubit>().toggle(member),
                          ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                  child: SearchFieldMaterial(
                    controller: _searchController,
                    hintText: t.screenNewChat.search,
                    onChanged: (value) => context.read<ChatCreateCubit>().search(value),
                  ),
                ),
                if (contacts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      t.screenNewChat.noContacts,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  )
                else ...[
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (final contact in contacts)
                          ContactTileMaterial(
                            contact: contact,
                            selected: state.isSelected(contact),
                            onTap: () => context.read<ChatCreateCubit>().toggle(contact),
                          ),
                      ],
                    ),
                  ),
                  if (state.selected.isEmpty) createNoteMaterial(context, t.screenNewChat.noMembersHint),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
