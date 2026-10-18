import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../components/chats/chat_tile.dart';
import '../../components/chats/message_bubble.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_material.dart';
import 'chat_no_forwards.dart';
import 'secret_chat_common.dart';

/// Окно секретного чата (Android): шапка с замком и состоянием (тап — «Ключ
/// шифрования»), лента пузырей, поле ввода. Скриншоты запрещены
/// (FLAG_SECURE). См. docs/plans/secret-chats-e2ee.md.
class SecretChatMaterial extends StatefulWidget {
  const SecretChatMaterial({super.key});

  @override
  State<SecretChatMaterial> createState() => _SecretChatMaterialState();
}

class _SecretChatMaterialState extends State<SecretChatMaterial> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _openInfo(BuildContext context) => context.push('/chats/secret/${context.read<SecretChatCubit>().state.chatID}/info');

  void _notice(BuildContext context, SecretChatState state) {
    if (state.removed) {
      if (context.canPop()) context.pop();
      return;
    }
    final t = context.t;
    final text = switch (state.notice) {
      SecretChatNotice.offline => t.common.noConnectionTitle,
      SecretChatNotice.notReady => t.secretChat.sendFailed,
      SecretChatNotice.none => '',
    };
    if (text.isNotEmpty) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _send() {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    context.read<SecretChatCubit>().send(text);
  }

  Future<void> _messageActions(BuildContext context, models.Message message) async {
    final t = context.t.secretChat;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.copy), title: Text(t.copy), onTap: () => Navigator.of(sheetContext).pop('copy')),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Theme.of(sheetContext).colorScheme.error),
              title: Text(t.deleteMessage, style: TextStyle(color: Theme.of(sheetContext).colorScheme.error)),
              onTap: () => Navigator.of(sheetContext).pop('delete'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'copy':
        await Clipboard.setData(ClipboardData(text: message.text));
      case 'delete':
        await context.read<SecretChatCubit>().deleteMessage(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return BlocConsumer<SecretChatCubit, SecretChatState>(
      listenWhen: (previous, current) => previous.noticeCount != current.noticeCount || previous.removed != current.removed,
      listener: _notice,
      builder: (context, state) {
        final theme = Theme.of(context);
        return ChatScreenProtector(
          enabled: true,
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: InkWell(
                onTap: () => _openInfo(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.lock, size: 14, color: ChatTileContent.secretColor),
                        const SizedBox(width: 6),
                        Flexible(child: Text(state.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    Text(
                      secretChatStatusText(t, state.secretStatus, state.title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              actions: [IconButton(onPressed: () => _openInfo(context), icon: const Icon(Icons.vpn_key_outlined))],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(child: state.messages.isEmpty ? _intro(context) : _list(context, state)),
                  _composer(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _intro(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.lock, size: 28, color: ChatTileContent.secretColor),
                const SizedBox(height: 12),
                Text(
                  context.t.secretChat.intro,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _list(BuildContext context, SecretChatState state) {
    final style = ChatMaterial.bubbleStyle(context);
    final messages = state.messages;
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, reversedIndex) {
        final index = messages.length - 1 - reversedIndex;
        final message = messages[index];
        return Padding(
          key: ValueKey(message.id),
          padding: const EdgeInsets.only(top: 2),
          child: MessageBubble(
            message: message,
            style: style,
            tail: secretBubbleTail(messages, index),
            showSender: false,
            onLongPress: () => _messageActions(context, message),
          ),
        );
      },
    );
  }

  Widget _composer(BuildContext context, SecretChatState state) {
    final t = context.t;
    final theme = Theme.of(context);
    if (!state.canSend) {
      return Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          secretChatStatusText(t, state.secretStatus, state.title),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 4, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _input,
              minLines: 1,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: t.secretChat.inputPlaceholder,
                filled: true,
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _input,
            builder: (context, value, _) => IconButton(
              onPressed: value.text.trim().isEmpty ? null : _send,
              icon: const Icon(Icons.send),
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
