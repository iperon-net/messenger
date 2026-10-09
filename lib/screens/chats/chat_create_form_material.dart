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
import 'comments_limit.dart';
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
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // «Изменить» — поля из чата (cubit уже заполнен в `edit`).
    final state = context.read<ChatCreateCubit>().state;
    _nameController.text = state.title;
    _aboutController.text = state.about;
    _usernameController.text = state.username;
    _phoneController.text = state.phone;
    _addressController.text = state.address;
    _latitudeController.text = state.latitude;
    _longitudeController.text = state.longitude;
    // Кнопка ✓ доступна только с названием.
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
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
        // Чат сообщества — вместо формы (назад — на страницу сообщества);
        // иначе новый чат вместо всей цепочки «Новое» (назад — в список чатов).
        if (state.inCommunity) return context.pushReplacement('/chats/chat/${state.openChatID}');
        context.go('/chats/chat/${state.openChatID}');
      },
      builder: (context, state) {
        final type = state.type;
        // Описание и вступление — у канала и сообщества, а в «Изменить» и
        // внутри сообщества — и у группы.
        final withLink = type == models.ChatType.channel || type == models.ChatType.community || state.isEdit || state.inCommunity;
        // Способы вступления — списком (в сообществе — одним нажатием / по
        // заявке), «Публичный / Частный» — переключателем.
        final joinList = (state.isEdit && type != models.ChatType.channel) || state.inCommunity;
        final canCreate = _nameController.text.trim().isNotEmpty && state.linkReady && state.coordinatesValid && !state.creating;
        final hint = usernameHint(t, state);

        // «Новичкам — без ссылок и медиа» (группа / комментарии канала).
        Widget newcomerTile() => ListTile(
          title: Text(t.screenNewChat.newcomerMedia),
          subtitle: Text(newcomerMediaLabel(t, state.newcomerMediaDelay)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final cubit = context.read<ChatCreateCubit>();
            final seconds = await pickCommentsLimit(
              context,
              state.newcomerMediaDelay,
              title: t.screenNewChat.newcomerMedia,
              label: (value) => newcomerMediaLabel(t, value),
            );
            if (seconds != null) cubit.setNewcomerMediaDelay(seconds);
          },
        );

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

                // Обложка страницы сообщества (в «Изменить»).
                if (type == models.ChatType.community && state.isEdit) ...[
                  const SizedBox(height: 16),
                  card([
                    ListTile(
                      leading: HugeIcon(icon: HugeIcons.strokeRoundedImage02, color: scheme.onSurfaceVariant),
                      title: Text(state.coverPath.isEmpty ? t.screenNewChat.setCover : t.screenNewChat.changeCover),
                      trailing: state.coverPath.isEmpty ? null : CommunityCoverPreview(path: state.coverPath),
                      onTap: () async {
                        final cubit = context.read<ChatCreateCubit>();
                        final path = await pickCommunityCover(context);
                        if (path != null) cubit.setCover(path);
                      },
                    ),
                    if (state.coverPath.isNotEmpty)
                      ListTile(
                        leading: HugeIcon(icon: HugeIcons.strokeRoundedDelete02, color: scheme.error),
                        title: Text(t.screenNewChat.removeCover, style: TextStyle(color: scheme.error)),
                        onTap: () => context.read<ChatCreateCubit>().setCover(''),
                      ),
                  ]),
                  createNoteMaterial(context, t.screenNewChat.coverFooter),
                ],

                // Контакты заведения (в «Изменить» сообщества): телефон, адрес,
                // координаты для маршрута.
                if (type == models.ChatType.community && state.isEdit) ...[
                  createHeaderMaterial(context, t.screenNewChat.contactsHeader),
                  card([
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      decoration: _decoration(label: t.screenNewChat.phone),
                      onChanged: context.read<ChatCreateCubit>().setPhone,
                    ),
                    TextField(
                      controller: _addressController,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 3,
                      decoration: _decoration(label: t.screenNewChat.address),
                      onChanged: context.read<ChatCreateCubit>().setAddress,
                    ),
                    TextField(
                      controller: _latitudeController,
                      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                      decoration: _decoration(label: t.screenNewChat.latitude, hint: t.screenNewChat.latitudeHint),
                      onChanged: context.read<ChatCreateCubit>().setLatitude,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: _longitudeController,
                        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                        decoration: _decoration(label: t.screenNewChat.longitude, hint: t.screenNewChat.longitudeHint),
                        onChanged: context.read<ChatCreateCubit>().setLongitude,
                      ),
                    ),
                  ]),
                  createNoteMaterial(
                    context,
                    state.coordinatesValid ? t.screenNewChat.coordinatesFooter : t.screenNewChat.coordinatesInvalid,
                    color: state.coordinatesValid ? null : scheme.error,
                  ),
                ],

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
                      for (final mode in joinModesFor(state))
                        ListTile(
                          title: Text(joinModeTitle(t, state, mode)),
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
                  ] else if (state.joinMode != models.ChatJoinMode.admins && !state.inCommunity) ...[
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
                      if (state.commentsEnabled) ...[
                        ListTile(
                          title: Text(t.screenNewChat.commentsLimit),
                          subtitle: Text(commentsLimitLabel(t, state.commentsTimeLimit)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final cubit = context.read<ChatCreateCubit>();
                            final seconds = await pickCommentsLimit(context, state.commentsTimeLimit, title: t.screenNewChat.commentsLimit);
                            if (seconds != null) cubit.setCommentsTimeLimit(seconds);
                          },
                        ),
                        ListTile(
                          title: Text(t.screenNewChat.commentsWho),
                          subtitle: Text(commentsWhoLabel(t, state.commentsWho)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final cubit = context.read<ChatCreateCubit>();
                            final who = await pickCommentsWho(context, state.commentsWho);
                            if (who != null) cubit.setCommentsWho(who);
                          },
                        ),
                        if (state.commentsWho == models.ChatCommentsWho.subscribers)
                          ListTile(
                            title: Text(t.screenNewChat.commentsMinSubscription),
                            subtitle: Text(commentsLimitLabel(t, state.commentsMinSubscription)),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              final cubit = context.read<ChatCreateCubit>();
                              final seconds = await pickCommentsLimit(
                                context,
                                state.commentsMinSubscription,
                                title: t.screenNewChat.commentsMinSubscription,
                              );
                              if (seconds != null) cubit.setCommentsMinSubscription(seconds);
                            },
                          ),
                        newcomerTile(),
                      ],
                      SwitchListTile(
                        title: Text(t.screenNewChat.signSwitch),
                        value: state.signMessages,
                        onChanged: context.read<ChatCreateCubit>().setSignMessages,
                      ),
                    ]),
                    createNoteMaterial(
                      context,
                      [
                        t.screenNewChat.commentsFooter,
                        if (state.commentsEnabled) t.screenNewChat.commentsLimitFooter,
                        if (state.commentsEnabled && state.commentsWho == models.ChatCommentsWho.subscribers)
                          t.screenNewChat.commentsWhoFooter,
                        if (state.commentsEnabled) t.screenNewChat.newcomerMediaFooterChannel,
                        t.screenNewChat.signFooter,
                      ].join(' '),
                    ),
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
                    const SizedBox(height: 8),
                    card([newcomerTile()]),
                    createNoteMaterial(context, t.screenNewChat.newcomerMediaFooterGroup),
                  ],
                ],

                // Видимость участников — настройка сообщества, у его чатов своей нет.
                if (state.isEdit && !state.inCommunity) ...[
                  const SizedBox(height: 16),
                  card([
                    SwitchListTile(
                      title: Text(type == models.ChatType.channel ? t.screenNewChat.hideSubscribers : t.screenNewChat.hideMembers),
                      value: state.membersHidden,
                      onChanged: context.read<ChatCreateCubit>().setMembersHidden,
                    ),
                  ]),
                  createNoteMaterial(context, t.screenNewChat.hideMembersFooter),
                ],

                if (type == models.ChatType.group && !state.isEdit && !state.inCommunity)
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
