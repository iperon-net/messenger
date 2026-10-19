import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'chat_material.dart';
import 'chat_no_forwards.dart';
import 'secret_chat_common.dart';

/// Окно секретного чата (Android): обои и лента как в обычных чатах, шапка с
/// аватаром, замком и состоянием, справа — «Ключ шифрования». Скриншоты
/// запрещены (FLAG_SECURE). См. docs/plans/secret-chats-e2ee.md.
class SecretChatMaterial extends StatefulWidget {
  const SecretChatMaterial({super.key});

  @override
  State<SecretChatMaterial> createState() => _SecretChatMaterialState();
}

class _SecretChatMaterialState extends State<SecretChatMaterial> {
  final _input = TextEditingController();

  /// Ключи строк ленты — снимки для «пыли» при удалении.
  final _messageKeys = <String, GlobalKey>{};
  StreamSubscription<List<String>>? _dustSubscription;

  GlobalKey _keyFor(String messageID) => _messageKeys.putIfAbsent(messageID, GlobalKey.new);

  @override
  void initState() {
    super.initState();
    // Удалил собеседник / истёк таймер — тоже пылью.
    final cubit = context.read<SecretChatCubit>();
    _dustSubscription = cubit.dustRequests.listen((ids) {
      if (mounted) dissolveRemoved(context, cubit, ids, _keyFor);
    });
  }

  @override
  void dispose() {
    _dustSubscription?.cancel();
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
            if (message.text.isNotEmpty)
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
        final cubit = context.read<SecretChatCubit>();
        await deleteWithDust(context, cubit, [message.id], _keyFor, () => cubit.deleteMessage(message));
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
        final scheme = theme.colorScheme;
        final dark = theme.brightness == Brightness.dark;
        return ChatScreenProtector(
          enabled: true,
          child: Scaffold(
            backgroundColor: dark ? const Color(0xFF000000) : scheme.surfaceContainerLow,
            appBar: AppBar(
              titleSpacing: 0,
              title: InkWell(
                onTap: () => _openInfo(context),
                child: Row(
                  children: [
                    // Таймер самоуничтожения — значок на аватаре (как в обычных чатах).
                    ChatAvatar(
                      chat: state.chat,
                      size: 40,
                      accentColor: scheme.primary,
                      accentForeground: scheme.onPrimary,
                      ttlBadgeColor: scheme.outline,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.lock, size: 14, color: ChatTileContent.secretColor),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  state.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            secretChatStatusText(t, state.secretStatus, state.title),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => _openInfo(context),
                  icon: HugeIcon(icon: HugeIcons.strokeRoundedSecurityLock, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(child: SecretChatWallpaper(dark: dark)),
                        state.messages.isEmpty ? _intro(context) : _list(context, state),
                      ],
                    ),
                  ),
                  // Панель снизу — до самого края экрана, как поле ввода в обычных чатах.
                  ColoredBox(
                    // Цвет поля ввода обычных чатов.
                    color: dark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color,
                    child: SafeArea(top: false, child: _composer(context, state)),
                  ),
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
    final cubit = context.read<SecretChatCubit>();
    return ChatMessagesView(
      messages: state.messages,
      chatType: models.ChatType.private,
      style: ChatMaterial.bubbleStyle(context),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      keyFor: _keyFor,
      vanishingIDs: state.vanishingIDs,
      onLongPress: (message) => _messageActions(context, message),
      onMediaTap: (message, index) => openSecretMedia(context, state, message, index),
      // Крестик на кольце загрузки — не отправлять.
      onCancelUpload: cubit.deleteMessage,
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final t = context.t.secretChat;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.deleteChatShort),
        content: Text(t.deleteClosedConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.deleteChatShort)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) await context.read<SecretChatCubit>().deleteChat();
  }

  /// Вместо поля ввода, пока писать нельзя: ждём собеседника (индикатор) или
  /// чат закрыт (замок, пояснение и «Удалить чат»).
  Widget _statusBar(BuildContext context, SecretChatState state) {
    final t = context.t;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    if (state.secretStatus != models.SecretChatStatus.closed) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                secretChatStatusText(t, state.secretStatus, state.title),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedSquareLock02, size: 18, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(t.secretChat.closed, style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            t.secretChat.closedHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            onPressed: () => _confirmDelete(context),
            child: Text(t.secretChat.deleteChatShort),
          ),
        ],
      ),
    );
  }

  Widget _composer(BuildContext context, SecretChatState state) {
    final t = context.t;
    final theme = Theme.of(context);
    if (!state.canSend) return _statusBar(context, state);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 4, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            color: theme.colorScheme.onSurfaceVariant,
            onPressed: () => pickSecretAttachments(context, input: _input),
          ),
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
