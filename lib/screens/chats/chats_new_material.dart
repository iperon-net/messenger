import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_create_common.dart';

/// «Новое сообщение» (Android) — кнопка-карандаш на вкладке «Чаты», как в
/// Telegram: сверху поиск и «Новая группа / Новый канал / Новое сообщество»,
/// ниже контакты — тап открывает личный чат (существующий или новый).
class ChatsNewMaterial extends StatefulWidget {
  const ChatsNewMaterial({super.key});

  @override
  State<ChatsNewMaterial> createState() => _ChatsNewMaterial();
}

class _ChatsNewMaterial extends State<ChatsNewMaterial> {
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

    Widget action(List<List<dynamic>> icon, String title, String path) => ListTile(
      leading: SizedBox(
        width: 40,
        child: HugeIcon(icon: icon, color: scheme.primary, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w500),
      ),
      onTap: () => context.push(path),
    );

    return BlocListener<ChatCreateCubit, ChatCreateState>(
      listenWhen: (previous, current) => current.openChatID.isNotEmpty && previous.openChatID != current.openChatID,
      // Вместо «Нового сообщения» — сам чат (назад — в список чатов).
      listener: (context, state) => context.go('/chats/chat/${state.openChatID}'),
      child: Scaffold(
        backgroundColor: scheme.surfaceContainerLow,
        appBar: AppBar(backgroundColor: scheme.surfaceContainerLow, title: Text(t.screenNewChat.title)),
        body: SafeArea(
          child: BlocBuilder<ChatCreateCubit, ChatCreateState>(
            builder: (context, state) {
              final contacts = state.filtered;
              return ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                    child: SearchFieldMaterial(
                      controller: _searchController,
                      hintText: t.screenNewChat.search,
                      onChanged: (value) => context.read<ChatCreateCubit>().search(value),
                    ),
                  ),
                  // Группы, каналы и сообщества — пока только в демо (на сервере — личные).
                  if (state.query.trim().isEmpty && context.read<CommonCubit>().state.settingsDevice.chatsDemo)
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          action(HugeIcons.strokeRoundedUserGroup, t.screenNewChat.newGroup, '/chats/new/group'),
                          action(HugeIcons.strokeRoundedMegaphone01, t.screenNewChat.newChannel, '/chats/new/channel'),
                          action(HugeIcons.strokeRoundedBuilding03, t.screenNewChat.newCommunity, '/chats/new/community'),
                        ],
                      ),
                    ),
                  if (contacts.isEmpty && state.status != Status.loading)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        t.screenNewChat.noContacts,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    )
                  else if (contacts.isNotEmpty) ...[
                    createHeaderMaterial(context, t.screenNewChat.contacts),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          for (final contact in contacts)
                            ContactTileMaterial(contact: contact, onTap: () => context.read<ChatCreateCubit>().openPrivateChat(contact)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Подпись над карточкой (как в настройках Android).
Widget createHeaderMaterial(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
  child: Text(
    text,
    style: TextStyle(fontSize: AppFontSizes.caption, color: Theme.of(context).colorScheme.onSurfaceVariant),
  ),
);

/// Подпись под карточкой; [color] — для ошибки / «свободно».
Widget createNoteMaterial(BuildContext context, String text, {Color? color}) => Padding(
  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
  child: Text(
    text,
    style: TextStyle(fontSize: AppFontSizes.caption, color: color ?? Theme.of(context).colorScheme.onSurfaceVariant),
  ),
);

/// Строка контакта: аватар, имя, «в сети» / «был(а) …»; [selected] не `null` —
/// галочка справа (выбор участников группы).
class ContactTileMaterial extends StatelessWidget {
  final models.ChatMember contact;
  final bool? selected;
  final VoidCallback? onTap;

  const ContactTileMaterial({super.key, required this.contact, this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = contactStatus(context.t, contact);
    final isSelected = selected;
    return ListTile(
      leading: ContactAvatar(contact: contact),
      title: Text(contact.name),
      subtitle: Text(status.text, style: TextStyle(color: status.online ? scheme.primary : scheme.onSurfaceVariant)),
      trailing: isSelected == null ? null : Checkbox(value: isSelected, onChanged: (_) => onTap?.call()),
      onTap: onTap,
    );
  }
}
