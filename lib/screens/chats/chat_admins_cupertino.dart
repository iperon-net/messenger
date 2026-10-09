import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_create_common.dart';
import 'chat_info_common.dart';
import 'chats_new_cupertino.dart';

/// «Администраторы» (iOS) — профиль чата → админ.
Future<void> showChatAdminsCupertino(BuildContext context, ChatCubit cubit) {
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(value: cubit, child: const ChatAdminsCupertino()),
    ),
  );
}

/// «Права админа» / «Новый админ» (iOS) для [member].
Future<void> showChatAdminRightsCupertino(BuildContext context, ChatCubit cubit, models.ChatMember member) {
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ChatAdminRightsCupertino(member: member),
      ),
    ),
  );
}

Widget _section(BuildContext context, {String? header, String? footer, required List<Widget> children}) =>
    CupertinoListSection.insetGrouped(
      header: header == null ? null : createHeaderCupertino(header),
      footer: footer == null ? null : createNoteCupertino(footer),
      backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
      decoration: BoxDecoration(
        color: ThemesCupertino.groupedCard.resolveFrom(context),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      children: children,
    );

/// Владелец и админы (со «званием»); тап — права (если можно), «Добавить
/// админа» — выбор из участников.
class ChatAdminsCupertino extends StatelessWidget {
  const ChatAdminsCupertino({super.key});

  Future<void> _add(BuildContext context, ChatState state) async {
    final chat = state.chat;
    if (chat == null) return;
    final cubit = context.read<ChatCubit>();
    final candidates = pickableMembers(state.members);
    final member = await Navigator.of(context).push<models.ChatMember>(
      FullSwipeBackRoute(
        builder: (_) => _PickMemberCupertino(candidates: candidates, search: cubit.findMembers),
      ),
    );
    if (member != null && context.mounted) await showChatAdminRightsCupertino(context, cubit, member);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final action = ThemesCupertino.actionColor(context);
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chat = state.chat;
        final admins = [
          for (final m in state.members)
            if (m.role == models.ChatRole.owner || m.role == models.ChatRole.admin) m,
        ];
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(t.screenChatAdmins.admins),
            ),
          ),
          child: chat == null
              ? const SizedBox.shrink()
              : SafeArea(
                  child: ListView(
                    children: [
                      _section(
                        context,
                        footer: chatAdminsFooter(t, chat),
                        children: [
                          if (myChatRights(chat, state.members).addAdmins)
                            CupertinoListTile(
                              // Как у строк админов — значок ровно под аватарами.
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              leadingSize: 40,
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(color: action.withValues(alpha: 0.12), shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Icon(CupertinoIcons.person_badge_plus, color: action, size: 20),
                              ),
                              title: Text(
                                chat.inCommunity ? t.screenChatAdmins.addModerator : t.screenChatAdmins.addAdmin,
                                style: TextStyle(color: action),
                              ),
                              onTap: () => _add(context, state),
                            ),
                          for (final admin in admins)
                            CupertinoListTile(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              leadingSize: 40,
                              leading: ContactAvatar(contact: admin),
                              title: Text(admin.isSelf ? t.screenChatInfo.you : admin.name),
                              subtitle: Text(memberRoleLabel(t, admin, chat) ?? ''),
                              trailing: canPromoteMember(chat, state.members, admin) ? const CupertinoListTileChevron() : null,
                              onTap: canPromoteMember(chat, state.members, admin)
                                  ? () => showChatAdminRightsCupertino(context, context.read<ChatCubit>(), admin)
                                  : null,
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

/// Выбор участника для «Добавить админа / модератора»: недавно активные, а
/// поиском — любой участник (в большом чате всех не перечислить).
class _PickMemberCupertino extends StatefulWidget {
  final List<models.ChatMember> candidates;
  final Future<List<models.ChatMember>> Function(String query) search;

  const _PickMemberCupertino({required this.candidates, required this.search});

  @override
  State<_PickMemberCupertino> createState() => _PickMemberCupertinoState();
}

class _PickMemberCupertinoState extends State<_PickMemberCupertino> {
  final _query = TextEditingController();
  List<models.ChatMember>? _found;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) return setState(() => _found = null);
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final found = await widget.search(value);
      if (mounted && _query.text == value) setState(() => _found = pickableMembers(found));
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final list = _found ?? widget.candidates;
    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(t.screenChatAdmins.pickMember),
        ),
      ),
      child: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: SearchFieldCupertino(controller: _query, placeholder: t.screenChatInfo.membersSearch, onChanged: _onChanged),
            ),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  _found == null ? t.screenChatAdmins.noCandidates : t.screenChatInfo.membersNotFound,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                ),
              )
            else
              _section(
                context,
                footer: _found == null ? null : t.screenChatInfo.membersSearchNote,
                children: [for (final m in list) ContactTileCupertino(contact: m, onTap: () => Navigator.of(context).pop(m))],
              ),
          ],
        ),
      ),
    );
  }
}

/// Права админа: галочки (не шире своих, если мы не владелец), «звание»;
/// у действующего админа — «Снять админа»; владельцу — «Передать владение».
class ChatAdminRightsCupertino extends StatefulWidget {
  final models.ChatMember member;

  const ChatAdminRightsCupertino({super.key, required this.member});

  @override
  State<ChatAdminRightsCupertino> createState() => _ChatAdminRightsCupertino();
}

class _ChatAdminRightsCupertino extends State<ChatAdminRightsCupertino> {
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
      await showCupertinoDialog<bool>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
            CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(label)),
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
    final moderator = cubit.state.chat?.inCommunity ?? false;
    final name = widget.member.name;
    final confirmed = moderator
        ? await _confirm(t.dismissModeratorTitle(name: name), t.dismissModeratorMessage, t.dismissModerator)
        : await _confirm(t.dismissTitle(name: name), t.dismissMessage, t.dismiss);
    if (!confirmed) return;
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
    final destructive = CupertinoColors.destructiveRed.resolveFrom(context);
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chat = state.chat;
        if (chat == null) return const SizedBox.shrink();
        final mine = myChatRights(chat, state.members);
        final owner = chat.myRole == models.ChatRole.owner;
        // Владелец чата сообщества — всегда владелец сообщества: владение
        // передаётся только у всего сообщества.
        final canTransfer = owner && !chat.inCommunity;
        final rights = adminRightsFor(chat);
        final status = contactStatus(t, widget.member);
        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              previousPageTitle: '',
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: Text(
                chat.inCommunity ? (_isAdmin ? tc.moderatorRights : tc.newModerator) : (_isAdmin ? tc.adminRights : tc.newAdmin),
              ),
              trailing: _saving
                  ? const CupertinoActivityIndicator()
                  : CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _save,
                      child: Text(
                        t.common.save,
                        style: TextStyle(fontWeight: FontWeight.w600, color: ThemesCupertino.navActionColor(context)),
                      ),
                    ),
            ),
          ),
          child: SafeArea(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _section(
                  context,
                  children: [
                    CupertinoListTile(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leadingSize: 44,
                      leading: ContactAvatar(contact: widget.member, size: 44),
                      title: Text(widget.member.name),
                      subtitle: Text(status.text),
                    ),
                  ],
                ),
                _section(
                  context,
                  header: tc.rightsHeader,
                  footer: chat.inCommunity
                      ? tc.moderatorRightsFooter
                      : (owner ? (chat.type == models.ChatType.channel ? null : tc.anonymousFooter) : tc.rightsFooterLimited),
                  children: [
                    for (final right in rights)
                      CupertinoListTile(
                        title: Text(
                          adminRightLabel(t, right),
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            color: adminRightOf(mine, right) ? null : CupertinoColors.inactiveGray.resolveFrom(context),
                          ),
                        ),
                        trailing: CupertinoSwitch(
                          value: adminRightOf(_rights, right),
                          // Своего права нет — выдать его нельзя.
                          onChanged: adminRightOf(mine, right)
                              ? (value) => setState(() => _rights = withAdminRight(_rights, right, value))
                              : null,
                        ),
                      ),
                  ],
                ),
                _section(
                  context,
                  header: tc.rankHeader,
                  footer: tc.rankFooter,
                  children: [
                    CupertinoTextField.borderless(
                      controller: _rankController,
                      placeholder: chat.inCommunity ? tc.moderatorRankHint : tc.rankHint,
                      maxLength: 16,
                      style: const TextStyle(fontSize: AppFontSizes.body),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ],
                ),
                if (_isAdmin || canTransfer)
                  _section(
                    context,
                    children: [
                      if (canTransfer)
                        CupertinoListTile(
                          title: Text(tc.transfer, style: TextStyle(color: destructive)),
                          onTap: _transfer,
                        ),
                      if (_isAdmin)
                        CupertinoListTile(
                          title: Text(chat.inCommunity ? tc.dismissModerator : tc.dismiss, style: TextStyle(color: destructive)),
                          onTap: _dismiss,
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
