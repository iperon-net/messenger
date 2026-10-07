import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_create_common.dart';
import 'chats_new_material.dart';

/// «Изменить» в профиле чата (админ): форма с полями [chat]; после
/// «Сохранить» возвращается в профиль.
Future<void> showChatEditMaterial(BuildContext context, models.Chat chat) {
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider<ChatCreateCubit>(
        create: (_) => ChatCreateCubit()..edit(demo: demo, chat: chat),
        child: const ChatCreateFormMaterial(),
      ),
    ),
  );
}

/// Форма создания (Android): фото и название; у канала и сообщества —
/// описание, «Публичный / Частный» и ссылка (публичное имя с проверкой или
/// ссылка-приглашение), у группы — выбранные на прошлом шаге участники.
/// Кнопка ✓ — создать и перейти в новый чат. Та же форма — «Изменить» в
/// профиле группы / канала / сообщества (админ, ✓ в шапке): у группы и
/// сообщества там все четыре способа вступления и права новых участников.
class ChatCreateFormMaterial extends StatefulWidget {
  const ChatCreateFormMaterial({super.key});

  @override
  State<ChatCreateFormMaterial> createState() => _ChatCreateFormMaterial();
}

class _ChatCreateFormMaterial extends State<ChatCreateFormMaterial> {
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
    // Кнопка ✓ доступна только с названием.
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
      final action = await showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const HugeIcon(icon: HugeIcons.strokeRoundedImage01),
                title: Text(t.changePhoto),
                onTap: () => Navigator.of(sheetContext).pop('change'),
              ),
              ListTile(
                leading: HugeIcon(icon: HugeIcons.strokeRoundedDelete02, color: Theme.of(sheetContext).colorScheme.error),
                title: Text(t.removePhoto, style: TextStyle(color: Theme.of(sheetContext).colorScheme.error)),
                onTap: () => Navigator.of(sheetContext).pop('remove'),
              ),
            ],
          ),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t.screenNewChat.copied)));
  }

  /// Поле без рамки внутри карточки, лейбл всегда сверху (см. CLAUDE.md).
  InputDecoration _decoration({required String label, String? hint, Widget? prefix}) => InputDecoration(
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    hintText: hint,
    prefix: prefix,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
  );

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;

    Widget card(List<Widget> children) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
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
        // Четыре способа вступления — списком, два («Публичный / Частный») —
        // переключателем.
        final joinList = state.isEdit && type != models.ChatType.channel;
        final canCreate = _nameController.text.trim().isNotEmpty && state.linkReady && !state.creating;
        final hint = usernameHint(t, state);

        return Scaffold(
          backgroundColor: scheme.surfaceContainerLow,
          appBar: AppBar(
            backgroundColor: scheme.surfaceContainerLow,
            title: Text(state.isEdit ? t.common.edit : createTitle(t, type)),
            actions: [
              if (state.isEdit)
                state.creating
                    ? const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                      )
                    : IconButton(
                        tooltip: t.common.save,
                        onPressed: canCreate
                            ? () => context.read<ChatCreateCubit>().save(title: _nameController.text, about: _aboutController.text)
                            : null,
                        icon: const Icon(Icons.check),
                      ),
            ],
          ),
          floatingActionButton: state.isEdit
              ? null
              : FloatingActionButton(
                  tooltip: t.screenNewChat.create,
                  backgroundColor: canCreate || state.creating ? null : scheme.surfaceContainerHighest,
                  foregroundColor: canCreate || state.creating ? null : scheme.onSurfaceVariant,
                  onPressed: canCreate
                      ? () => context.read<ChatCreateCubit>().create(title: _nameController.text, about: _aboutController.text)
                      : null,
                  child: state.creating
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                      : const Icon(Icons.check),
                ),
          body: SafeArea(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(top: 8, bottom: 88),
              children: [
                // Фото + название.
                card([
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                    child: Row(
                      children: [
                        InkWell(
                          customBorder: type == models.ChatType.community
                              ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))
                              : const CircleBorder(),
                          onTap: () => _photo(context, state),
                          child: state.avatarPath.isNotEmpty
                              ? ChatPhotoPreview(path: state.avatarPath, type: type, size: 64)
                              : Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: scheme.primaryContainer,
                                    shape: type == models.ChatType.community ? BoxShape.rectangle : BoxShape.circle,
                                    borderRadius: type == models.ChatType.community ? BorderRadius.circular(18) : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: HugeIcon(icon: HugeIcons.strokeRoundedCameraAdd01, color: scheme.onPrimaryContainer, size: 28),
                                ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            autofocus: !state.isEdit,
                            maxLength: ChatCreateCubit.titleMaxLength,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: _decoration(label: createNameHint(t, type)).copyWith(counterText: ''),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),

                if (withLink) ...[
                  const SizedBox(height: 16),
                  card([
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: _aboutController,
                        minLines: 1,
                        maxLines: 5,
                        maxLength: ChatCreateCubit.aboutMaxLength,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: _decoration(label: t.screenNewChat.description, hint: t.screenNewChat.descriptionHint),
                      ),
                    ),
                  ]),
                  if (!state.isEdit) createNoteMaterial(context, createDescriptionFooter(t, type)),

                  createHeaderMaterial(context, joinList ? t.screenNewChat.joinHeader : t.screenNewChat.type),
                  if (joinList)
                    card([
                      for (final mode in joinModesOf(type))
                        ListTile(
                          title: Text(joinModeLabel(t, type, mode)),
                          trailing: state.joinMode == mode ? Icon(Icons.check, color: scheme.primary) : null,
                          onTap: () => context.read<ChatCreateCubit>().setJoinMode(mode),
                        ),
                    ])
                  else
                    card([
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<bool>(
                            showSelectedIcon: false,
                            segments: [
                              ButtonSegment(value: true, label: Text(t.screenNewChat.typePublic)),
                              ButtonSegment(value: false, label: Text(t.screenNewChat.typePrivate)),
                            ],
                            selected: {state.isPublic},
                            onSelectionChanged: (value) => context.read<ChatCreateCubit>().setPublic(value.first),
                          ),
                        ),
                      ),
                    ]),
                  createNoteMaterial(context, joinModeFooter(t, state)),

                  if (state.isPublic) ...[
                    createHeaderMaterial(context, t.screenNewChat.link),
                    card([
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          controller: _usernameController,
                          autocorrect: false,
                          enableSuggestions: false,
                          keyboardType: TextInputType.url,
                          decoration: _decoration(
                            label: t.screenNewChat.link,
                            hint: t.screenNewChat.usernameHint,
                            prefix: Text('iperon.net/', style: TextStyle(color: scheme.onSurfaceVariant)),
                          ),
                          onChanged: (value) => context.read<ChatCreateCubit>().setUsername(value),
                        ),
                      ),
                    ]),
                    createNoteMaterial(context, hint.text, color: hint.error ? scheme.error : (hint.ok ? const Color(0xFF2E7D32) : null)),
                  ] else if (state.joinMode != models.ChatJoinMode.admins) ...[
                    createHeaderMaterial(context, t.screenNewChat.inviteLink),
                    card([
                      ListTile(
                        leading: HugeIcon(icon: HugeIcons.strokeRoundedLink01, color: scheme.onSurfaceVariant),
                        title: Text('iperon.net/${state.inviteLink}'),
                        trailing: HugeIcon(icon: HugeIcons.strokeRoundedCopy01, color: scheme.primary, size: 20),
                        onTap: () => _copyLink(context, state.inviteLink),
                      ),
                    ]),
                    createNoteMaterial(context, t.screenNewChat.inviteLinkFooter),
                  ],
                  if (state.isEdit && type == models.ChatType.channel) ...[
                    const SizedBox(height: 8),
                    card([
                      SwitchListTile(
                        title: Text(t.screenNewChat.commentsSwitch),
                        value: state.commentsEnabled,
                        onChanged: context.read<ChatCreateCubit>().setCommentsEnabled,
                      ),
                      SwitchListTile(
                        title: Text(t.screenNewChat.signSwitch),
                        value: state.signMessages,
                        onChanged: context.read<ChatCreateCubit>().setSignMessages,
                      ),
                    ]),
                    createNoteMaterial(context, '${t.screenNewChat.commentsFooter} ${t.screenNewChat.signFooter}'),
                  ],
                  if (state.isEdit && type != models.ChatType.channel) ...[
                    createHeaderMaterial(context, t.screenNewChat.defaultRoleHeader),
                    card([
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<models.ChatRole>(
                            showSelectedIcon: false,
                            segments: [
                              for (final role in const [models.ChatRole.reader, models.ChatRole.writer])
                                ButtonSegment(value: role, label: Text(defaultRoleLabel(t, role))),
                            ],
                            selected: {state.defaultRole},
                            onSelectionChanged: (value) => context.read<ChatCreateCubit>().setDefaultRole(value.first),
                          ),
                        ),
                      ),
                    ]),
                    createNoteMaterial(context, defaultRoleFooter(t, state.defaultRole)),
                  ],
                ],

                if (type == models.ChatType.group && !state.isEdit)
                  if (state.selected.isEmpty)
                    createNoteMaterial(context, t.screenNewChat.noMembersHint)
                  else ...[
                    createHeaderMaterial(context, t.screenChat.members(n: state.selected.length, count: state.selected.length.grouped)),
                    card([for (final member in state.selected) ContactTileMaterial(contact: member)]),
                  ],
              ],
            ),
          ),
        );
      },
    );
  }
}
