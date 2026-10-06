import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_invites_common.dart';
import 'chats_new_cupertino.dart';

/// Новая / изменить дополнительную ссылку (iOS).
Future<void> showChatInviteLinkEditCupertino(BuildContext context, ChatInvitesCubit cubit, {models.ChatInviteLink? link}) {
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ChatInviteLinkEditCupertino(link: link),
      ),
    ),
  );
}

/// Название (видно только админам), «Одобрение админом», срок действия и
/// лимит вступлений (с одобрением лимита нет — как в Telegram). У
/// существующей — ещё «Отозвать».
class ChatInviteLinkEditCupertino extends StatefulWidget {
  /// `null` — новая ссылка.
  final models.ChatInviteLink? link;

  const ChatInviteLinkEditCupertino({super.key, this.link});

  @override
  State<ChatInviteLinkEditCupertino> createState() => _ChatInviteLinkEditCupertino();
}

class _ChatInviteLinkEditCupertino extends State<ChatInviteLinkEditCupertino> {
  late final _titleController = TextEditingController(text: widget.link?.title ?? '');
  late bool _approval = widget.link?.requestApproval ?? false;

  /// Выбранный пресет срока; `-1` — оставить текущий срок ссылки.
  late int _preset = widget.link?.expireDate != null ? -1 : 0;
  late int _limit = widget.link?.usageLimit ?? 0;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final cubit = context.read<ChatInvitesCubit>();
    final duration = _preset < 0 ? null : invitePresetDurations[_preset];
    final expireDate = _preset < 0 ? widget.link?.expireDate : (duration == null ? null : DateTime.now().add(duration));
    final link = widget.link;
    if (link == null) {
      await cubit.createLink(title: _titleController.text, expireDate: expireDate, usageLimit: _limit, requestApproval: _approval);
    } else {
      await cubit.editLink(link, title: _titleController.text, expireDate: expireDate, usageLimit: _limit, requestApproval: _approval);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _revoke() async {
    final link = widget.link;
    if (link == null) return;
    final t = context.t.screenChatInvites;
    final cubit = context.read<ChatInvitesCubit>();
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.revokeTitle),
        content: Text(t.revokeMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.revoke)),
        ],
      ),
    );
    if (!(confirmed ?? false)) return;
    await cubit.revokeLink(link);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final tc = t.screenChatInvites;
    final primary = CupertinoTheme.of(context).primaryColor;
    final background = ThemesCupertino.groupedBackground.resolveFrom(context);
    final card = ThemesCupertino.groupedCard.resolveFrom(context);
    final link = widget.link;
    final limits = [...inviteLimits, if (!inviteLimits.contains(_limit)) _limit];

    Widget section({String? header, String? footer, required List<Widget> children}) => CupertinoListSection.insetGrouped(
      header: header == null ? null : createHeaderCupertino(header),
      footer: footer == null ? null : createNoteCupertino(footer),
      backgroundColor: background,
      decoration: BoxDecoration(color: card, borderRadius: const BorderRadius.all(Radius.circular(10))),
      children: children,
    );

    Widget option(String title, bool selected, VoidCallback onTap) => CupertinoListTile(
      title: Text(title, style: const TextStyle(fontSize: AppFontSizes.body)),
      trailing: selected ? Icon(CupertinoIcons.checkmark_alt, color: primary) : null,
      onTap: onTap,
    );

    return CupertinoPageScaffold(
      backgroundColor: ThemesCupertino.groupedBackground,
      navigationBar: AppCupertinoNavigationBar(
        child: CupertinoNavigationBar(
          previousPageTitle: '',
          automaticBackgroundVisibility: false,
          backgroundColor: ThemesCupertino.groupedBackground,
          middle: Text(link == null ? tc.newLink : tc.editLink),
          trailing: _saving
              ? const CupertinoActivityIndicator()
              : CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _save,
                  child: Text(
                    link == null ? tc.create : t.common.save,
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
            section(
              footer: tc.nameFooter,
              children: [
                CupertinoTextField.borderless(
                  controller: _titleController,
                  placeholder: '${tc.name} (${tc.nameHint.toLowerCase()})',
                  maxLength: 32,
                  style: const TextStyle(fontSize: AppFontSizes.body),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ],
            ),
            section(
              footer: tc.approvalFooter,
              children: [
                CupertinoListTile(
                  title: Text(tc.approvalTitle, style: const TextStyle(fontSize: AppFontSizes.body)),
                  trailing: CupertinoSwitch(value: _approval, onChanged: (value) => setState(() => _approval = value)),
                ),
              ],
            ),
            section(
              header: tc.expireHeader,
              children: [
                if (link?.expireDate != null)
                  option(tc.expireCurrent(date: inviteDate(link!.expireDate!)), _preset < 0, () => setState(() => _preset = -1)),
                for (final (i, duration) in invitePresetDurations.indexed)
                  option(inviteDurationLabel(t, duration), _preset == i, () => setState(() => _preset = i)),
              ],
            ),
            if (!_approval)
              section(
                header: tc.limitHeader,
                footer: tc.limitFooter,
                children: [
                  for (final limit in limits)
                    option(limit == 0 ? tc.limitNone : '$limit', _limit == limit, () => setState(() => _limit = limit)),
                ],
              ),
            if (link != null)
              section(
                children: [
                  CupertinoListTile(
                    title: Text(tc.revoke, style: TextStyle(color: CupertinoColors.destructiveRed.resolveFrom(context))),
                    onTap: _revoke,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
