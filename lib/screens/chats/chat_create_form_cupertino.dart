import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_create_common.dart';
import 'chats_new_cupertino.dart';

/// «Изменить» в профиле чата (админ): форма с полями [chat]; после
/// «Сохранить» возвращается в профиль.
Future<void> showChatEditCupertino(BuildContext context, models.Chat chat) {
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider<ChatCreateCubit>(
        create: (_) => ChatCreateCubit()..edit(demo: demo, chat: chat),
        child: const ChatCreateFormCupertino(),
      ),
    ),
  );
}

/// Форма создания (iOS): фото и название; у канала и сообщества — описание,
/// «Публичный / Частный» и ссылка (публичное имя с проверкой или
/// ссылка-приглашение), у группы — выбранные на прошлом шаге участники.
/// «Создать» — в новый чат. Та же форма — «Изменить» в профиле группы /
/// канала / сообщества (админ): у группы и сообщества там все четыре способа
/// вступления и права новых участников.
class ChatCreateFormCupertino extends StatefulWidget {
  const ChatCreateFormCupertino({super.key});

  @override
  State<ChatCreateFormCupertino> createState() => _ChatCreateFormCupertino();
}

class _ChatCreateFormCupertino extends State<ChatCreateFormCupertino> {
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // «Изменить» — поля из чата (cubit уже заполнен в `edit`).
    final state = context.read<ChatCreateCubit>().state;
    _nameController.text = state.title;
    _aboutController.text = state.about;
    _usernameController.text = state.username;
    // «Создать» доступна только с названием.
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _photo(BuildContext context, ChatCreateState state) async {
    final cubit = context.read<ChatCreateCubit>();
    if (state.avatarPath.isNotEmpty) {
      final t = context.t.screenNewChat;
      final action = await showCupertinoModalPopup<String>(
        context: context,
        builder: (sheetContext) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop('change'), child: Text(t.changePhoto)),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(sheetContext).pop('remove'),
              child: Text(t.removePhoto),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(context.t.common.cancel)),
        ),
      );
      if (action == 'remove') cubit.setAvatar('');
      if (action != 'change' || !context.mounted) return;
    }
    final path = await pickChatPhoto(context, state.type);
    if (path != null) cubit.setAvatar(path);
  }

  void _copyLink(BuildContext context, String link) {
    Clipboard.setData(ClipboardData(text: 'https://iperon.net/$link'));
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final primary = CupertinoTheme.of(context).primaryColor;
    final action = ThemesCupertino.actionColor(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);

    Widget section({Widget? header, Widget? footer, required List<Widget> children}) => CupertinoListSection.insetGrouped(
      header: header,
      footer: footer,
      backgroundColor: background,
      decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
      children: children,
    );

    return BlocConsumer<ChatCreateCubit, ChatCreateState>(
      listenWhen: (previous, current) =>
          (current.openChatID.isNotEmpty && previous.openChatID != current.openChatID) || (current.saved && !previous.saved),
      listener: (context, state) {
        // «Изменить» сохранено — обратно в профиль чата.
        if (state.saved) return Navigator.of(context).pop();
        // Новый чат вместо всей цепочки «Новое» (назад — в список чатов).
        context.go('/chats/chat/${state.openChatID}');
      },
      builder: (context, state) {
        final type = state.type;
        // Описание и вступление — у канала и сообщества, а в «Изменить» — и у
        // группы.
        final withLink = type == models.ChatType.channel || type == models.ChatType.community || state.isEdit;
        final joinModes = state.isEdit ? joinModesOf(type) : const [models.ChatJoinMode.open, models.ChatJoinMode.link];
        final canCreate = _nameController.text.trim().isNotEmpty && state.linkReady && !state.creating;
        final hint = usernameHint(t, state);

        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(state.isEdit ? t.common.edit : createTitle(t, type)),
              trailing: state.creating
                  ? const CupertinoActivityIndicator()
                  : CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: canCreate
                          ? () => state.isEdit
                                ? context.read<ChatCreateCubit>().save(title: _nameController.text, about: _aboutController.text)
                                : context.read<ChatCreateCubit>().create(title: _nameController.text, about: _aboutController.text)
                          : null,
                      child: Text(
                        state.isEdit ? t.common.save : t.screenNewChat.create,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: canCreate ? ThemesCupertino.navActionColor(context) : CupertinoColors.inactiveGray.resolveFrom(context),
                        ),
                      ),
                    ),
            ),
          ),
          child: SafeArea(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                // Фото + название.
                section(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _photo(context, state),
                            child: state.avatarPath.isNotEmpty
                                ? ChatPhotoPreview(path: state.avatarPath, type: type, size: 64)
                                : Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: action.withValues(alpha: 0.12),
                                      shape: type == models.ChatType.community ? BoxShape.rectangle : BoxShape.circle,
                                      borderRadius: type == models.ChatType.community ? BorderRadius.circular(18) : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: HugeIcon(icon: HugeIcons.strokeRoundedCameraAdd01, color: action, size: 28),
                                  ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: CupertinoTextField.borderless(
                              controller: _nameController,
                              autofocus: !state.isEdit,
                              placeholder: createNameHint(t, type),
                              maxLength: ChatCreateCubit.titleMaxLength,
                              textCapitalization: TextCapitalization.sentences,
                              style: const TextStyle(fontSize: AppFontSizes.body),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (withLink) ...[
                  section(
                    footer: state.isEdit ? null : createNoteCupertino(createDescriptionFooter(t, type)),
                    children: [
                      CupertinoTextField.borderless(
                        controller: _aboutController,
                        placeholder: '${t.screenNewChat.description} (${t.screenNewChat.descriptionHint.toLowerCase()})',
                        maxLength: ChatCreateCubit.aboutMaxLength,
                        style: const TextStyle(fontSize: AppFontSizes.body),
                        minLines: 1,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ],
                  ),
                  section(
                    header: createHeaderCupertino(
                      state.isEdit && type != models.ChatType.channel ? t.screenNewChat.joinHeader : t.screenNewChat.type,
                    ),
                    footer: createNoteCupertino(joinModeFooter(t, state)),
                    children: [
                      for (final mode in joinModes)
                        CupertinoListTile(
                          title: Text(
                            state.isEdit
                                ? joinModeLabel(t, type, mode)
                                : (mode == models.ChatJoinMode.open ? t.screenNewChat.typePublic : t.screenNewChat.typePrivate),
                            style: const TextStyle(fontSize: AppFontSizes.body),
                          ),
                          trailing: state.joinMode == mode ? Icon(CupertinoIcons.checkmark_alt, color: primary) : null,
                          onTap: () => context.read<ChatCreateCubit>().setJoinMode(mode),
                        ),
                    ],
                  ),
                  if (state.isPublic)
                    section(
                      header: createHeaderCupertino(t.screenNewChat.link),
                      footer: createNoteCupertino(
                        hint.text,
                        color: hint.error
                            ? CupertinoColors.destructiveRed.resolveFrom(context)
                            : (hint.ok ? CupertinoColors.systemGreen.resolveFrom(context) : null),
                      ),
                      children: [
                        CupertinoTextField.borderless(
                          controller: _usernameController,
                          prefix: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              'iperon.net/',
                              style: TextStyle(fontSize: AppFontSizes.body, color: secondary),
                            ),
                          ),
                          placeholder: t.screenNewChat.usernameHint,
                          autocorrect: false,
                          enableSuggestions: false,
                          keyboardType: TextInputType.url,
                          style: const TextStyle(fontSize: AppFontSizes.body),
                          padding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
                          onChanged: (value) => context.read<ChatCreateCubit>().setUsername(value),
                        ),
                      ],
                    )
                  else if (state.joinMode != models.ChatJoinMode.admins)
                    section(
                      header: createHeaderCupertino(t.screenNewChat.inviteLink),
                      footer: createNoteCupertino(t.screenNewChat.inviteLinkFooter),
                      children: [
                        CupertinoListTile(
                          title: Text(
                            'iperon.net/${state.inviteLink}',
                            style: TextStyle(fontSize: AppFontSizes.body, color: action),
                          ),
                          trailing: HugeIcon(icon: HugeIcons.strokeRoundedCopy01, color: action, size: 20),
                          onTap: () => _copyLink(context, state.inviteLink),
                        ),
                      ],
                    ),
                  if (state.isEdit && type == models.ChatType.channel)
                    section(
                      footer: createNoteCupertino('${t.screenNewChat.commentsFooter} ${t.screenNewChat.signFooter}'),
                      children: [
                        CupertinoListTile(
                          title: Text(t.screenNewChat.commentsSwitch, style: const TextStyle(fontSize: AppFontSizes.body)),
                          trailing: CupertinoSwitch(
                            value: state.commentsEnabled,
                            onChanged: context.read<ChatCreateCubit>().setCommentsEnabled,
                          ),
                        ),
                        CupertinoListTile(
                          title: Text(t.screenNewChat.signSwitch, style: const TextStyle(fontSize: AppFontSizes.body)),
                          trailing: CupertinoSwitch(value: state.signMessages, onChanged: context.read<ChatCreateCubit>().setSignMessages),
                        ),
                      ],
                    ),
                  if (state.isEdit && type != models.ChatType.channel)
                    section(
                      header: createHeaderCupertino(t.screenNewChat.defaultRoleHeader),
                      footer: createNoteCupertino(defaultRoleFooter(t, state.defaultRole)),
                      children: [
                        for (final role in const [models.ChatRole.reader, models.ChatRole.writer])
                          CupertinoListTile(
                            title: Text(defaultRoleLabel(t, role), style: const TextStyle(fontSize: AppFontSizes.body)),
                            trailing: state.defaultRole == role ? Icon(CupertinoIcons.checkmark_alt, color: primary) : null,
                            onTap: () => context.read<ChatCreateCubit>().setDefaultRole(role),
                          ),
                      ],
                    ),
                ],

                if (state.isEdit)
                  section(
                    footer: createNoteCupertino(t.screenNewChat.hideMembersFooter),
                    children: [
                      CupertinoListTile(
                        title: Text(
                          type == models.ChatType.channel ? t.screenNewChat.hideSubscribers : t.screenNewChat.hideMembers,
                          style: const TextStyle(fontSize: AppFontSizes.body),
                        ),
                        trailing: CupertinoSwitch(value: state.membersHidden, onChanged: context.read<ChatCreateCubit>().setMembersHidden),
                      ),
                    ],
                  ),

                if (type == models.ChatType.group && !state.isEdit)
                  state.selected.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                          child: Text(
                            t.screenNewChat.noMembersHint,
                            style: TextStyle(fontSize: AppFontSizes.caption, color: secondary),
                          ),
                        )
                      : section(
                          header: createHeaderCupertino(
                            t.screenChat.members(n: state.selected.length, count: state.selected.length.grouped),
                          ),
                          children: [for (final member in state.selected) ContactTileCupertino(contact: member)],
                        ),
              ],
            ),
          ),
        );
      },
    );
  }
}
