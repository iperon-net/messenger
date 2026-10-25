import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:screen_protector/screen_protector.dart';

import '../../split_layout.dart';
import '../../chats/secret/secret_chats_list.dart' show secretChatIDPrefix;
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_actions_cupertino.dart';
import 'chat_common.dart';
import 'chat_cupertino.dart';
import 'chat_no_forwards.dart';
import 'message_context_menu_cupertino.dart';
import 'secret_chat_common.dart';

/// Окно секретного чата (iOS): обои и лента как в обычных чатах, шапка с
/// замком и состоянием, справа — «Ключ шифрования». Скриншоты защищены, а о
/// сделанном снимке узнаёт собеседник. См. docs/plans/secret-chats-e2ee.md.
class SecretChatCupertino extends StatefulWidget {
  const SecretChatCupertino({super.key});

  @override
  State<SecretChatCupertino> createState() => _SecretChatCupertinoState();
}

class _SecretChatCupertinoState extends State<SecretChatCupertino> with UnreadBackCount {
  @override
  String get unreadChatID => '$secretChatIDPrefix${context.read<SecretChatCubit>().state.chatID}';

  final _input = TextEditingController();

  /// Ключи строк ленты — снимки для «пыли» при удалении.
  final _messageKeys = <String, GlobalKey>{};
  StreamSubscription<List<String>>? _dustSubscription;

  GlobalKey _keyFor(String messageID) => _messageKeys.putIfAbsent(messageID, GlobalKey.new);

  @override
  void initState() {
    super.initState();
    // Снимок экрана (iOS сообщает о нём) — служебное «сделал скриншот» у обоих.
    final cubit = context.read<SecretChatCubit>();
    ScreenProtector.addListener(cubit.screenshotTaken, null);
    // Удалил собеседник / истёк таймер — тоже пылью.
    _dustSubscription = cubit.dustRequests.listen((ids) {
      if (mounted) dissolveRemoved(context, cubit, ids, _keyFor);
    });
  }

  @override
  void dispose() {
    _dustSubscription?.cancel();
    ScreenProtector.removeListener();
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
        final dark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
        final background = dark ? const Color(0xFF000000) : CupertinoColors.systemGroupedBackground.resolveFrom(context);
        final barColor = ThemesCupertino.appBackground.resolveFrom(context).withValues(alpha: 0.92);
        return ChatScreenProtector(
          enabled: true,
          child: CupertinoPageScaffold(
            backgroundColor: background,
            navigationBar: AppCupertinoNavigationBar(
              child: CupertinoNavigationBar(
                automaticallyImplyLeading: !context.isSplitPaneRoot,
                previousPageTitle: unreadBack > 0 ? ChatTileContent.badge(unreadBack) : '',
                automaticBackgroundVisibility: false,
                backgroundColor: barColor,
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
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedSecurityLock,
                    color: ThemesCupertino.navActionColor(context),
                    size: 24,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
            // Обои — на весь экран, в том числе под полупрозрачной панелью.
            child: Stack(
              children: [
                Positioned.fill(child: SecretChatWallpaper(dark: dark)),
                // Панель снизу — до самого края экрана (под полосой «домой» тот же
                // фон), как поле ввода в обычных чатах.
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Expanded(child: state.messages.isEmpty ? _intro(context) : _list(context, state)),
                      ColoredBox(
                        color: barColor,
                        child: SafeArea(top: false, child: _composer(context, state)),
                      ),
                    ],
                  ),
                ),
              ],
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
          decoration: BoxDecoration(color: const Color(0x66000000), borderRadius: BorderRadius.circular(18)),
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
                  style: const TextStyle(fontSize: 14, color: Color(0xFFFFFFFF)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _list(BuildContext context, SecretChatState state) {
    final cubit = context.read<SecretChatCubit>();
    return ChatMessagesView(
      messages: state.messages,
      chatType: models.ChatType.private,
      style: ChatCupertino.bubbleStyle(context),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      keyFor: _keyFor,
      vanishingIDs: state.vanishingIDs,
      onLongPress: (_) {},
      menuWrapper: (message, bubble, preview) =>
          MessageContextMenuCupertino(actions: _actions(context, message), bubble: bubble, preview: (maxWidth) => preview(maxWidth)),
      onMediaTap: (message, index) => openSecretMedia(context, state, message, index),
      // Крестик на кольце загрузки — не отправлять.
      onCancelUpload: cubit.deleteMessage,
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
        onPressed: () async {
          close();
          final cubit = context.read<SecretChatCubit>();
          // Снимок — когда меню закрылось и пузырь снова на месте.
          await Future<void>.delayed(contextMenuCloseDuration);
          if (context.mounted) await deleteWithDust(context, cubit, [message.id], _keyFor, () => cubit.deleteMessage(message));
        },
        child: Text(t.deleteMessage),
      ),
    ];
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final t = context.t.secretChat;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.deleteChatShort),
        content: Text(t.deleteClosedConfirm),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.deleteChatShort),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) await context.read<SecretChatCubit>().deleteChat();
  }

  /// Вместо поля ввода, пока писать нельзя: ждём собеседника (индикатор) или
  /// чат закрыт (замок, пояснение и «Удалить чат»).
  Widget _statusBar(BuildContext context, SecretChatState state) {
    final t = context.t;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final closed = state.secretStatus == models.SecretChatStatus.closed;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 2),
        child: closed
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(icon: HugeIcons.strokeRoundedSquareLock02, size: 18, color: secondary, strokeWidth: 2),
                      const SizedBox(width: 6),
                      Text(
                        t.secretChat.closed,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: CupertinoColors.label.resolveFrom(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.secretChat.closedHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: secondary),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    minimumSize: const Size(44, 36),
                    onPressed: () => _confirmDelete(context),
                    child: Text(t.secretChat.deleteChatShort, style: const TextStyle(fontSize: 15, color: CupertinoColors.destructiveRed)),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(radius: 8),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      secretChatStatusText(t, state.secretStatus, state.title),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: secondary),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _composer(BuildContext context, SecretChatState state) {
    final t = context.t;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    if (!state.canSend) return _statusBar(context, state);
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
