import 'package:cupertino_ui/cupertino_ui.dart';
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

/// «Новое сообщение» (iOS) — кнопка «Новое» на вкладке «Чаты», как в Telegram:
/// сверху поиск и «Новая группа / Новый канал / Новое сообщество», ниже
/// контакты — тап открывает личный чат (существующий или новый).
class ChatsNewCupertino extends StatefulWidget {
  const ChatsNewCupertino({super.key});

  @override
  State<ChatsNewCupertino> createState() => _ChatsNewCupertino();
}

class _ChatsNewCupertino extends State<ChatsNewCupertino> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final actionColor = ThemesCupertino.actionColor(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);

    Widget section({Widget? header, required List<Widget> children}) => CupertinoListSection.insetGrouped(
      header: header,
      backgroundColor: background,
      decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
      children: children,
    );

    Widget action(List<List<dynamic>> icon, String title, String path) => CupertinoListTile(
      leading: HugeIcon(icon: icon, color: actionColor, size: 24),
      title: Text(title, style: TextStyle(color: actionColor)),
      onTap: () => context.push(path),
    );

    return BlocListener<ChatCreateCubit, ChatCreateState>(
      listenWhen: (previous, current) => current.openChatID.isNotEmpty && previous.openChatID != current.openChatID,
      // Вместо «Нового сообщения» — сам чат (назад — в список чатов).
      listener: (context, state) => context.go('/chats/chat/${state.openChatID}'),
      child: CupertinoPageScaffold(
        backgroundColor: ThemesCupertino.groupedBackground,
        navigationBar: AppCupertinoNavigationBar(
          child: CupertinoNavigationBar(
            previousPageTitle: '',
            automaticBackgroundVisibility: false,
            backgroundColor: ThemesCupertino.groupedBackground,
            middle: Text(t.screenNewChat.title),
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<ChatCreateCubit, ChatCreateState>(
            builder: (context, state) {
              final contacts = state.filtered;
              return ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: SearchFieldCupertino(
                      controller: _searchController,
                      placeholder: t.screenNewChat.search,
                      onChanged: (value) => context.read<ChatCreateCubit>().search(value),
                    ),
                  ),
                  if (state.query.trim().isEmpty)
                    section(
                      children: [
                        action(HugeIcons.strokeRoundedUserGroup, t.screenNewChat.newGroup, '/chats/new/group'),
                        action(HugeIcons.strokeRoundedMegaphone01, t.screenNewChat.newChannel, '/chats/new/channel'),
                        action(HugeIcons.strokeRoundedBuilding03, t.screenNewChat.newCommunity, '/chats/new/community'),
                      ],
                    ),
                  if (contacts.isEmpty && state.status != Status.loading)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        t.screenNewChat.noContacts,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: secondary),
                      ),
                    )
                  else if (contacts.isNotEmpty)
                    section(
                      header: createHeaderCupertino(t.screenNewChat.contacts),
                      children: [
                        for (final contact in contacts)
                          ContactTileCupertino(contact: contact, onTap: () => context.read<ChatCreateCubit>().openPrivateChat(contact)),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Заголовок секции — как в настройках (у insetGrouped по умолчанию 20 bold).
Widget createHeaderCupertino(String text) => Text(
  text,
  style: const TextStyle(fontSize: AppFontSizes.base, fontWeight: FontWeight.normal),
);

/// Подпись под секцией — как в настройках (по умолчанию 17); [color] — для
/// ошибки / «свободно».
Widget createNoteCupertino(String text, {Color? color}) => Padding(
  padding: const EdgeInsets.only(left: 13, right: 13),
  child: Text(
    text,
    style: TextStyle(fontSize: AppFontSizes.caption, color: color),
  ),
);

/// Строка контакта: аватар, имя, «в сети» / «был(а) …»; [selected] не `null` —
/// кружок выбора справа (выбор участников группы).
class ContactTileCupertino extends StatelessWidget {
  final models.ChatMember contact;
  final bool? selected;
  final VoidCallback? onTap;

  const ContactTileCupertino({super.key, required this.contact, this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final primary = CupertinoTheme.of(context).primaryColor;
    final status = contactStatus(t, contact);
    final isSelected = selected;
    return CupertinoListTile(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leadingSize: 40,
      leading: ContactAvatar(contact: contact),
      title: Text(contact.name),
      subtitle: Text(status.text, style: TextStyle(color: status.online ? primary : CupertinoColors.secondaryLabel.resolveFrom(context))),
      trailing: isSelected == null
          ? null
          : Icon(
              isSelected ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
              color: isSelected ? primary : CupertinoColors.systemGrey3.resolveFrom(context),
              size: 26,
            ),
      onTap: onTap,
    );
  }
}
