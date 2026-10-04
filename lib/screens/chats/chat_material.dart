import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../chats/message_formatting.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';

/// Окно чата (Android): шапка с аватаром и «печатает…», лента пузырей, поле
/// ввода с markdown-ярлыками и скрепкой; в канале вместо поля — «Выключить
/// звук». Действия над сообщением — по long-press. Пока только UX-демо, см.
/// docs/plans/chats-groups-channels.md, «Этап 0».
class ChatMaterial extends StatefulWidget {
  const ChatMaterial({super.key});

  /// Оформление пузырей — и для окна чата, и для превью «Тем для чатов».
  static MessageBubbleStyle bubbleStyle(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return MessageBubbleStyle(
      incoming: dark ? scheme.surfaceContainerHigh : const Color(0xFFFFFFFF),
      outgoing: scheme.primaryContainer,
      incomingText: MessageTextColors(
        text: scheme.onSurface,
        link: scheme.primary,
        codeBackground: scheme.surfaceContainerHighest,
        spoiler: scheme.outlineVariant,
        quote: scheme.onSurfaceVariant,
      ),
      outgoingText: MessageTextColors(
        text: scheme.onPrimaryContainer,
        link: scheme.primary,
        codeBackground: scheme.onPrimaryContainer.withValues(alpha: 0.1),
        spoiler: scheme.onPrimaryContainer.withValues(alpha: 0.3),
        quote: scheme.onPrimaryContainer.withValues(alpha: 0.8),
      ),
      incomingMeta: scheme.onSurfaceVariant,
      outgoingMeta: scheme.onPrimaryContainer.withValues(alpha: 0.7),
      pill: dark ? const Color(0x66000000) : const Color(0x22000000),
      pillText: dark ? const Color(0xFFFFFFFF) : const Color(0xFF3C3C43),
      textStyle: (Theme.of(context).textTheme.bodyLarge ?? const TextStyle()).copyWith(fontSize: 16, height: 1.25),
    );
  }

  @override
  State<ChatMaterial> createState() => _ChatMaterialState();
}

class _ChatMaterialState extends State<ChatMaterial> {
  final _input = TextEditingController();
  final _focus = FocusNode();
  final _scroll = ScrollController();
  final _searchInput = TextEditingController();

  /// Ключи строк ленты — для прокрутки к найденному (поиск по чату).
  final _messageKeys = <String, GlobalKey>{};
  late final ChatCubit _cubit;
  bool _draftLoaded = false;
  String? _editingID;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ChatCubit>();
  }

  @override
  void dispose() {
    _cubit.saveDraft(_input.text);
    _input.dispose();
    _focus.dispose();
    _scroll.dispose();
    _searchInput.dispose();
    super.dispose();
  }

  /// Удержание шапки — поиск по чату (как в Telegram).
  void _startSearch() {
    HapticFeedback.mediumImpact();
    _focus.unfocus();
    _searchInput.clear();
    _cubit.startSearch();
  }

  GlobalKey _keyFor(String messageID) => _messageKeys.putIfAbsent(messageID, GlobalKey.new);

  void _send() {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    _cubit.send(text);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final barColor = dark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (previous, current) =>
          previous.editing != current.editing ||
          previous.chat == null && current.chat != null ||
          previous.searchCurrentID != current.searchCurrentID,
      listener: (context, state) {
        if (state.editing == null) _editingID = null;
        // Поиск: к текущему найденному.
        final found = state.searchCurrentID;
        if (found != null) scrollToMessage(_scroll, _keyFor(found));
        // Черновик из списка — один раз при открытии.
        if (!_draftLoaded && state.chat != null) {
          _draftLoaded = true;
          if (_input.text.isEmpty && state.chat!.draft.isNotEmpty) _input.text = state.chat!.draft;
        }
        final editing = state.editing;
        // Только при смене редактируемого (слушатель срабатывает и на поиск).
        if (editing != null && editing.id != _editingID) {
          _editingID = editing.id;
          _input.text = toMarkdownShortcuts(editing.text, editing.entities);
          _focus.requestFocus();
        }
      },
      builder: (context, state) {
        final chat = state.chat;
        return PopScope(
          // «Назад» в режиме поиска закрывает поиск, а не чат.
          canPop: !state.searching,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _cubit.closeSearch();
          },
          child: Scaffold(
            backgroundColor: dark ? const Color(0xFF000000) : Theme.of(context).colorScheme.surfaceContainerLow,
            appBar: state.searching
                ? AppBar(
                    backgroundColor: barColor,
                    titleSpacing: 0,
                    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _cubit.closeSearch),
                    title: TextField(
                      controller: _searchInput,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: _cubit.setSearchQuery,
                      decoration: InputDecoration(hintText: t.screenChat.search, border: InputBorder.none),
                    ),
                  )
                : AppBar(
                    backgroundColor: barColor,
                    titleSpacing: 0,
                    // Удержание шапки — поиск по чату (как в Telegram).
                    title: chat == null
                        ? null
                        : GestureDetector(
                            onLongPress: _startSearch,
                            child: _Header(chat: chat),
                          ),
                  ),
            body: chat == null
                ? Center(child: Text(state.status == Status.success ? t.screenChat.notFound : ''))
                : Column(
                    children: [
                      Expanded(
                        // Обои из «Тем для чатов» (Настройки → Оформление) — под лентой.
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: BlocBuilder<CommonCubit, CommonState>(
                                buildWhen: (previous, current) =>
                                    previous.settingsDevice.chatWallpaper != current.settingsDevice.chatWallpaper ||
                                    previous.settingsDevice.chatWallpaperColor != current.settingsDevice.chatWallpaperColor ||
                                    previous.settingsDevice.chatWallpaperIntensity != current.settingsDevice.chatWallpaperIntensity,
                                builder: (context, common) => ChatWallpaper(
                                  pattern: common.settingsDevice.chatWallpaper,
                                  colorIndex: common.settingsDevice.chatWallpaperColor,
                                  intensity: common.settingsDevice.chatWallpaperIntensity,
                                  dark: Theme.of(context).brightness == Brightness.dark,
                                ),
                              ),
                            ),
                            state.messages.isEmpty
                                ? Center(child: Text(t.screenChat.empty))
                                : ChatMessagesView(
                                    messages: state.messages,
                                    chatType: chat.type,
                                    style: ChatMaterial.bubbleStyle(context),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    onLongPress: (message) => _actions(context, chat, message),
                                    controller: _scroll,
                                    keyFor: _keyFor,
                                    onCancelUpload: _cubit.cancelUpload,
                                    highlight: state.searching ? state.searchQuery : '',
                                    focusedID: state.searchCurrentID,
                                    onMediaTap: (message, index) => showChatMediaViewer(
                                      context,
                                      messages: state.messages,
                                      message: message,
                                      index: index,
                                      chatTitle: chat.title,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      if (state.searching)
                        _SearchBar(state: state, color: barColor)
                      else if (chat.type == models.ChatType.channel)
                        _ChannelBar(chat: chat, color: barColor)
                      else
                        _ComposeBar(input: _input, focus: _focus, state: state, onSend: _send, color: barColor),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Future<void> _actions(BuildContext context, models.Chat chat, models.Message message) async {
    HapticFeedback.mediumImpact();
    final t = context.t.screenChat;
    final canWrite = chat.type != models.ChatType.channel;
    final error = Theme.of(context).colorScheme.error;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canWrite)
              ListTile(leading: const Icon(Icons.reply), title: Text(t.reply), onTap: () => Navigator.of(sheetContext).pop('reply')),
            if (message.text.isNotEmpty)
              ListTile(leading: const Icon(Icons.copy), title: Text(t.copy), onTap: () => Navigator.of(sheetContext).pop('copy')),
            if (message.outgoing && message.kind == models.MessageKind.text)
              ListTile(leading: const Icon(Icons.edit_outlined), title: Text(t.edit), onTap: () => Navigator.of(sheetContext).pop('edit')),
            if (message.outgoing || chat.type == models.ChatType.private)
              ListTile(
                leading: Icon(Icons.delete_outline, color: error),
                title: Text(t.delete, style: TextStyle(color: error)),
                onTap: () => Navigator.of(sheetContext).pop('delete'),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'reply':
        _cubit.startReply(message);
        _focus.requestFocus();
      case 'copy':
        await Clipboard.setData(ClipboardData(text: message.text));
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.copied)));
      case 'edit':
        _cubit.startEdit(message);
      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(t.deleteTitle),
            content: Text(t.deleteMessage),
            actions: [
              TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
              TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
            ],
          ),
        );
        if (confirmed ?? false) await _cubit.delete(message);
    }
  }
}

class _Header extends StatelessWidget {
  final models.Chat chat;

  const _Header({required this.chat});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    final subtitle = chatSubtitle(t, chat);
    return Row(
      children: [
        ChatAvatar(chat: chat, size: 40, accentColor: scheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ChatTileContent.title(t, chat), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18)),
              if (subtitle.text.isNotEmpty)
                Text(
                  subtitle.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: subtitle.active ? scheme.primary : scheme.onSurfaceVariant),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ComposeBar extends StatelessWidget {
  final TextEditingController input;
  final FocusNode focus;
  final ChatState state;
  final VoidCallback onSend;
  final Color color;

  const _ComposeBar({required this.input, required this.focus, required this.state, required this.onSend, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    final banner = composeBanner(t, state);
    final editing = state.editing != null;

    return Material(
      color: color,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (banner != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 4, 0),
                child: Row(
                  children: [
                    Icon(editing ? Icons.edit_outlined : Icons.reply, color: scheme.primary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w600, color: scheme.primary),
                          ),
                          Text(
                            banner.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        if (editing) input.clear();
                        context.read<ChatCubit>().cancelCompose();
                      },
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    color: scheme.onSurfaceVariant,
                    onPressed: editing ? null : () => pickAndSendAttachments(context, input: input),
                  ),
                  Expanded(
                    child: TextField(
                      controller: input,
                      focusNode: focus,
                      minLines: 1,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: t.screenChat.message,
                        filled: true,
                        fillColor: scheme.surfaceContainerHighest,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: input,
                    builder: (context, value, _) => IconButton(
                      icon: Icon(editing ? Icons.check : Icons.send),
                      color: scheme.primary,
                      onPressed: value.text.trim().isNotEmpty ? onSend : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Канал для подписчика: писать нельзя — только звук.
class _ChannelBar extends StatelessWidget {
  final models.Chat chat;
  final Color color;

  const _ChannelBar({required this.chat, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    return Material(
      color: color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: TextButton(onPressed: () => context.read<ChatCubit>().setMuted(!chat.muted), child: Text(chat.muted ? t.unmute : t.mute)),
        ),
      ),
    );
  }
}

/// Низ экрана в режиме поиска: «3 из 12» / «Нет результатов» и стрелки
/// «к старым» / «к новым».
class _SearchBar extends StatelessWidget {
  final ChatState state;
  final Color color;

  const _SearchBar({required this.state, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final cubit = context.read<ChatCubit>();
    final total = state.searchResults.length;
    final label = total > 0
        ? t.mediaCounter(current: state.searchIndex + 1, total: total)
        : (state.searchQuery.trim().isEmpty ? '' : t.searchNoResults);
    return Material(
      color: color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              const SizedBox(width: 20),
              Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
              IconButton(icon: const Icon(Icons.keyboard_arrow_up), onPressed: state.searchIndex + 1 < total ? cubit.searchOlder : null),
              IconButton(icon: const Icon(Icons.keyboard_arrow_down), onPressed: state.searchIndex > 0 ? cubit.searchNewer : null),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
