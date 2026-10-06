import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_invites_common.dart';
import 'chats_new_material.dart';

/// Новая / изменить дополнительную ссылку (Android).
Future<void> showChatInviteLinkEditMaterial(BuildContext context, ChatInvitesCubit cubit, {models.ChatInviteLink? link}) {
  return Navigator.of(context).push<void>(
    FullSwipeBackRoute(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ChatInviteLinkEditMaterial(link: link),
      ),
    ),
  );
}

/// Название (видно только админам), «Одобрение админом», срок действия и
/// лимит вступлений (с одобрением лимита нет — как в Telegram). У
/// существующей — ещё «Отозвать».
class ChatInviteLinkEditMaterial extends StatefulWidget {
  /// `null` — новая ссылка.
  final models.ChatInviteLink? link;

  const ChatInviteLinkEditMaterial({super.key, this.link});

  @override
  State<ChatInviteLinkEditMaterial> createState() => _ChatInviteLinkEditMaterial();
}

class _ChatInviteLinkEditMaterial extends State<ChatInviteLinkEditMaterial> {
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.revokeTitle),
        content: Text(t.revokeMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.revoke),
          ),
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
    final scheme = Theme.of(context).colorScheme;
    final link = widget.link;
    final limits = [...inviteLimits, if (!inviteLimits.contains(_limit)) _limit];

    Widget card(List<Widget> children) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );

    Widget option(String title, bool selected, VoidCallback onTap) => ListTile(
      title: Text(title),
      trailing: selected ? Icon(Icons.check, color: scheme.primary) : null,
      onTap: onTap,
    );

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: scheme.surfaceContainerLow,
        title: Text(link == null ? tc.newLink : tc.editLink),
        actions: [
          _saving
              ? const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                )
              : IconButton(tooltip: link == null ? tc.create : t.common.save, onPressed: _save, icon: const Icon(Icons.check)),
        ],
      ),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          children: [
            card([
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _titleController,
                  maxLength: 32,
                  decoration: InputDecoration(
                    labelText: tc.name,
                    hintText: tc.nameHint,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  ),
                ),
              ),
            ]),
            createNoteMaterial(context, tc.nameFooter),
            const SizedBox(height: 8),
            card([
              SwitchListTile(title: Text(tc.approvalTitle), value: _approval, onChanged: (value) => setState(() => _approval = value)),
            ]),
            createNoteMaterial(context, tc.approvalFooter),
            createHeaderMaterial(context, tc.expireHeader),
            card([
              if (link?.expireDate != null)
                option(tc.expireCurrent(date: inviteDate(link!.expireDate!)), _preset < 0, () => setState(() => _preset = -1)),
              for (final (i, duration) in invitePresetDurations.indexed)
                option(inviteDurationLabel(t, duration), _preset == i, () => setState(() => _preset = i)),
            ]),
            if (!_approval) ...[
              createHeaderMaterial(context, tc.limitHeader),
              card([
                for (final limit in limits)
                  option(limit == 0 ? tc.limitNone : '$limit', _limit == limit, () => setState(() => _limit = limit)),
              ]),
              createNoteMaterial(context, tc.limitFooter),
            ],
            if (link != null) ...[
              const SizedBox(height: 16),
              card([
                ListTile(
                  title: Text(tc.revoke, style: TextStyle(color: scheme.error)),
                  onTap: _revoke,
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}
