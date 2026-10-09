import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_create_common.dart';
import 'chat_info_common.dart';
import 'chats_new_material.dart';

/// «Администраторы» (Android) — профиль чата → админ.
Future<void> showChatAdminsMaterial(BuildContext context, ChatCubit cubit) {
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const ChatAdminsMaterial()),
    ),
  );
}

/// «Права админа» / «Новый админ» (Android) для [member].
Future<void> showChatAdminRightsMaterial(BuildContext context, ChatCubit cubit, models.ChatMember member) {
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ChatAdminRightsMaterial(member: member),
      ),
    ),
  );
}

Widget _card(List<Widget> children) => Card(
  margin: const EdgeInsets.symmetric(horizontal: 12),
  clipBehavior: Clip.antiAlias,
  child: Column(children: children),
);

/// Владелец и админы (со «званием»); тап — права (если можно), «Добавить
/// админа» — выбор из участников.
class ChatAdminsMaterial extends StatelessWidget {
  const ChatAdminsMaterial({super.key});

  Future<void> _add(BuildContext context, ChatState state) async {
    final cubit = context.read<ChatCubit>();
    final candidates = [
      for (final m in state.members)
        if (!m.isSelf && m.role != models.ChatRole.admin && m.role != models.ChatRole.owner) m,
    ];
    final member = await Navigator.of(
      context,
    ).push<models.ChatMember>(FullSwipeBackRoute(builder: (_) => _PickMemberMaterial(candidates: candidates)));
    if (member != null && context.mounted) await showChatAdminRightsMaterial(context, cubit, member);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chat = state.chat;
        final admins = [
          for (final m in state.members)
            if (m.role == models.ChatRole.owner || m.role == models.ChatRole.admin) m,
        ];
        return Scaffold(
          backgroundColor: scheme.surfaceContainerLow,
          appBar: AppBar(backgroundColor: scheme.surfaceContainerLow, title: Text(t.screenChatAdmins.admins)),
          body: chat == null
              ? const SizedBox.shrink()
              : SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 8),
                    children: [
                      _card([
                        if (myChatRights(chat, state.members).addAdmins)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: scheme.primaryContainer,
                              child: Icon(Icons.person_add_alt, color: scheme.onPrimaryContainer),
                            ),
                            title: Text(t.screenChatAdmins.addAdmin, style: TextStyle(color: scheme.primary)),
                            onTap: () => _add(context, state),
                          ),
                        for (final admin in admins)
                          ListTile(
                            leading: ContactAvatar(contact: admin),
                            title: Text(admin.isSelf ? t.screenChatInfo.you : admin.name),
                            subtitle: Text(memberRoleLabel(t, admin) ?? ''),
                            onTap: canPromoteMember(chat, state.members, admin)
                                ? () => showChatAdminRightsMaterial(context, context.read<ChatCubit>(), admin)
                                : null,
                          ),
                      ]),
                      createNoteMaterial(context, chatAdminsFooter(t, chat)),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

/// Выбор участника для «Добавить админа».
class _PickMemberMaterial extends StatelessWidget {
  final List<models.ChatMember> candidates;

  const _PickMemberMaterial({required this.candidates});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: AppBar(backgroundColor: scheme.surfaceContainerLow, title: Text(t.screenChatAdmins.pickMember)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 8),
          children: [
            if (candidates.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  t.screenChatAdmins.noCandidates,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              )
            else
              _card([for (final m in candidates) ContactTileMaterial(contact: m, onTap: () => Navigator.of(context).pop(m))]),
          ],
        ),
      ),
    );
  }
}

/// Права админа: переключатели (не шире своих, если мы не владелец),
/// «звание»; у действующего админа — «Снять админа»; владельцу — «Передать
/// владение».
class ChatAdminRightsMaterial extends StatefulWidget {
  final models.ChatMember member;

  const ChatAdminRightsMaterial({super.key, required this.member});

  @override
  State<ChatAdminRightsMaterial> createState() => _ChatAdminRightsMaterial();
}

class _ChatAdminRightsMaterial extends State<ChatAdminRightsMaterial> {
  late models.ChatAdminRights _rights;
  late final _rankController = TextEditingController(text: widget.member.rank);
  bool _saving = false;

  bool get _isAdmin => widget.member.role == models.ChatRole.admin;

  @override
  void initState() {
    super.initState();
    final state = context.read<ChatCubit>().state;
    final mine = state.chat == null ? const models.ChatAdminRights() : myChatRights(state.chat!, state.members);
    // Новому — стандартный набор, но не шире наших прав.
    _rights = _isAdmin ? widget.member.rights : _intersect(models.ChatAdminRights.standard, mine);
  }

  @override
  void dispose() {
    _rankController.dispose();
    super.dispose();
  }

  models.ChatAdminRights _intersect(models.ChatAdminRights a, models.ChatAdminRights b) {
    var result = const models.ChatAdminRights();
    for (final right in ChatAdminRight.values) {
      result = withAdminRight(result, right, adminRightOf(a, right) && adminRightOf(b, right));
    }
    return result;
  }

  Future<bool> _confirm(String title, String message, String label) async =>
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(label),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    await context.read<ChatCubit>().setAdmin(widget.member, _rights, _rankController.text);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _dismiss() async {
    final t = context.t.screenChatAdmins;
    final cubit = context.read<ChatCubit>();
    if (!await _confirm(t.dismissTitle(name: widget.member.name), t.dismissMessage, t.dismiss)) return;
    await cubit.removeAdmin(widget.member);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _transfer() async {
    final t = context.t.screenChatAdmins;
    final cubit = context.read<ChatCubit>();
    final name = widget.member.name;
    if (!await _confirm(t.transferTitle(name: name), t.transferMessage(name: name), t.transfer)) return;
    await cubit.transferOwnership(widget.member);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final tc = t.screenChatAdmins;
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chat = state.chat;
        if (chat == null) return const SizedBox.shrink();
        final mine = myChatRights(chat, state.members);
        final owner = chat.myRole == models.ChatRole.owner;
        // Владелец чата сообщества — всегда владелец сообщества: владение
        // передаётся только у всего сообщества.
        final canTransfer = owner && !chat.inCommunity;
        final status = contactStatus(t, widget.member);
        return Scaffold(
          backgroundColor: scheme.surfaceContainerLow,
          appBar: AppBar(
            backgroundColor: scheme.surfaceContainerLow,
            title: Text(_isAdmin ? tc.adminRights : tc.newAdmin),
            actions: [
              _saving
                  ? const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                    )
                  : IconButton(tooltip: t.common.save, onPressed: _save, icon: const Icon(Icons.check)),
            ],
          ),
          body: SafeArea(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              children: [
                _card([
                  ListTile(
                    leading: ContactAvatar(contact: widget.member, size: 44),
                    title: Text(widget.member.name),
                    subtitle: Text(status.text),
                  ),
                ]),
                createHeaderMaterial(context, tc.rightsHeader),
                _card([
                  for (final right in adminRightsFor(chat.type))
                    SwitchListTile(
                      title: Text(adminRightLabel(t, right)),
                      value: adminRightOf(_rights, right),
                      // Своего права нет — выдать его нельзя.
                      onChanged: adminRightOf(mine, right)
                          ? (value) => setState(() => _rights = withAdminRight(_rights, right, value))
                          : null,
                    ),
                ]),
                if (!owner)
                  createNoteMaterial(context, tc.rightsFooterLimited)
                else if (chat.type != models.ChatType.channel)
                  createNoteMaterial(context, tc.anonymousFooter),
                createHeaderMaterial(context, tc.rankHeader),
                _card([
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _rankController,
                      maxLength: 16,
                      decoration: InputDecoration(
                        labelText: tc.rankHeader,
                        hintText: tc.rankHint,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      ),
                    ),
                  ),
                ]),
                createNoteMaterial(context, tc.rankFooter),
                if (_isAdmin || canTransfer) ...[
                  const SizedBox(height: 8),
                  _card([
                    if (canTransfer)
                      ListTile(
                        title: Text(tc.transfer, style: TextStyle(color: scheme.error)),
                        onTap: _transfer,
                      ),
                    if (_isAdmin)
                      ListTile(
                        title: Text(tc.dismiss, style: TextStyle(color: scheme.error)),
                        onTap: _dismiss,
                      ),
                  ]),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
