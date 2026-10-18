import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../components/chats/chat_tile.dart';
import '../../components/chats/message_bubble.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_cupertino.dart';
import 'chat_no_forwards.dart';
import 'message_context_menu_cupertino.dart';
import 'secret_chat_common.dart';

/// Окно секретного чата (iOS): шапка с замком и состоянием (тап — «Ключ
/// шифрования»), лента пузырей, поле ввода. Скриншоты запрещены, как в чате с
/// защитой содержимого. См. docs/plans/secret-chats-e2ee.md.
class SecretChatCupertino extends StatefulWidget {
  const SecretChatCupertino({super.key});

  @override
  State<SecretChatCupertino> createState() => _SecretChatCupertinoState();
}

class _SecretChatCupertinoState extends State<SecretChatCupertino> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _openInfo(BuildContext context) => context.push('/chats/secret/${context.read<SecretChatCubit>().state.chatID}/info');

  Future<void> _notice(BuildContext context, SecretChatState state) async {
    if (state.removed) {
      if (context.canPop()) context.pop();
      return;
    }
    final t = context.t;
    final (title, message) = switch (state.notice) {
      SecretChatNotice.offline => (t.common.noConnectionTitle, t.common.noConnectionMessage),
      SecretChatNotice.notReady => (t.common.error, t.secretChat.sendFailed),
      SecretChatNotice.none => ('', ''),
    };
    if (title.isEmpty) return;
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.of(dialogContext).pop(), child: Text(t.common.close)),
        ],
      ),
    );
  }

  void _send() {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    context.read<SecretChatCubit>().send(text);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return BlocConsumer<SecretChatCubit, SecretChatState>(
      listenWhen: (previous, current) => previous.noticeCount != current.noticeCount || previous.removed != current.removed,
      listener: _notice,
      builder: (context, state) {
        final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
        return ChatScreenProtector(
          enabled: true,
          child: CupertinoPageScaffold(
            backgroundColor: ThemesCupertino.appBackground.resolveFrom(context),
            navigationBar: CupertinoNavigationBar(
              previousPageTitle: '',
              middle: GestureDetector(
                onTap: () => _openInfo(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(FontAwesomeIcons.lock, size: 12, color: ChatTileContent.secretColor),
                        const SizedBox(width: 5),
                        Flexible(child: Text(state.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    Text(
                      secretChatStatusText(t, state.secretStatus, state.title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: secondary),
                    ),
                  ],
                ),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(44, 44),
                onPressed: () => _openInfo(context),
                child: Icon(CupertinoIcons.lock_shield, color: ThemesCupertino.navActionColor(context)),
              ),
            ),
            child: SafeArea(
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: DecoratedBox(
          decoration: BoxDecoration(color: const Color(0x22000000), borderRadius: BorderRadius.circular(18)),
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
                  style: TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _list(BuildContext context, SecretChatState state) {
    final style = ChatCupertino.bubbleStyle(context);
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
            onLongPress: () {},
            onMediaTap: (index) => openSecretMedia(context, state, message, index),
            // Крестик на кольце загрузки — не отправлять.
            onCancelUpload: () => context.read<SecretChatCubit>().deleteMessage(message),
            menuWrapper: (bubble, preview) =>
                MessageContextMenuCupertino(actions: _actions(context, message), bubble: bubble, preview: (maxWidth) => preview(maxWidth)),
          ),
        );
      },
    );
  }

  List<Widget> _actions(BuildContext context, models.Message message) {
    final t = context.t.secretChat;
    void close() => Navigator.of(context, rootNavigator: true).pop();
    return [
      if (message.text.isNotEmpty)
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.doc_on_doc,
          onPressed: () {
            close();
            Clipboard.setData(ClipboardData(text: message.text));
          },
          child: Text(t.copy),
        ),
      CupertinoContextMenuAction(
        trailingIcon: CupertinoIcons.delete,
        isDestructiveAction: true,
        onPressed: () {
          close();
          context.read<SecretChatCubit>().deleteMessage(message);
        },
        child: Text(t.deleteMessage),
      ),
    ];
  }

  Widget _composer(BuildContext context, SecretChatState state) {
    final t = context.t;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    if (!state.canSend) {
      return Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          secretChatStatusText(t, state.secretStatus, state.title),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: secondary),
        ),
      );
    }
    final primary = CupertinoTheme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 4, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            minimumSize: Size.zero,
            onPressed: () => pickSecretAttachments(context, input: _input),
            child: FaIcon(FontAwesomeIcons.paperclip, size: 22, color: secondary),
          ),
          Expanded(
            child: CupertinoTextField(
              controller: _input,
              placeholder: t.secretChat.inputPlaceholder,
              minLines: 1,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              style: TextStyle(fontSize: 16, color: CupertinoColors.label.resolveFrom(context)),
              decoration: BoxDecoration(
                color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _input,
            builder: (context, value, _) => CupertinoButton(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              minimumSize: Size.zero,
              onPressed: value.text.trim().isEmpty ? null : _send,
              child: Icon(CupertinoIcons.arrow_up_circle_fill, size: 32, color: value.text.trim().isEmpty ? secondary : primary),
            ),
          ),
        ],
      ),
    );
  }
}
