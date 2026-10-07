import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:material_ui/material_ui.dart';

import '../../chats/message_formatting.dart';
import '../../chats/reactions.dart';
import '../../chats/voice_player.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'compose_format_menu.dart';
import 'forward_picker.dart';
import 'chat_info_material.dart';
import 'pinned_messages_material.dart';
import 'scheduled_messages_material.dart';
import 'voice_recorder.dart';

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
  late final _formatMenu = ComposeFormatMenu(_input);
  late final _recorder = VoiceRecorder(
    onSend: (path, seconds, waveform) => _cubit.sendVoice(localPath: path, duration: seconds, waveform: waveform),
    onDenied: _micDenied,
  );
  final _focus = FocusNode();
  final _scroll = ScrollController();
  final _searchInput = TextEditingController();

  /// Ключи строк ленты — для прокрутки к найденному (поиск по чату).
  final _messageKeys = <String, GlobalKey>{};
  late final ChatCubit _cubit;
  late final _tracker = ChatScrollTracker(_scroll, _keyFor);
  String? _flashID;

  /// Какое закреплённое показано в плашке (по кругу от новых к старым).
  int _pinIndex = 0;
  bool _draftLoaded = false;
  String? _editingID;

  @override
  void initState() {
    super.initState();
    // Ссылки iperon.net в сообщениях — открываются в приложении.
    MessageText.linkHandler = openIperonLink;
    _cubit = context.read<ChatCubit>();
    // Подсветка после перехода по цитате — перестроить ленту.
    _tracker.addListener(() {
      if (_flashID != _tracker.flashID && mounted) setState(() => _flashID = _tracker.flashID);
    });
    // Сообщения могли прийти до подписки слушателя.
    _tracker.update(_cubit.state.messages, _cubit.state.unreadFromID);
  }

  @override
  void dispose() {
    _cubit.saveDraft(_input.text);
    _formatMenu.dispose();
    _recorder.dispose();
    VoicePlayer.instance.stop();
    _input.dispose();
    _focus.dispose();
    _tracker.dispose();
    _scroll.dispose();
    _searchInput.dispose();
    super.dispose();
  }

  /// Тап по шапке — профиль чата; оттуда «Поиск» или переход к сообщению.
  /// «N комментариев» под постом — ветка обсуждения (тот же экран чата).
  Future<void> _openComments(models.Message post) async {
    _focus.unfocus();
    final threadID = await _cubit.openComments(post);
    if (threadID.isNotEmpty && mounted) await context.push('/chats/chat/$threadID');
  }

  Future<void> _openInfo(BuildContext context) async {
    // У комментариев к посту своего профиля нет.
    if (_cubit.state.chat?.isThread ?? false) return;
    _focus.unfocus();
    final result = await showChatInfoMaterial(context, _cubit);
    if (result == null || !mounted) return;
    if (result.search) {
      _startSearch();
    } else if (result.messageID case final id?) {
      await _tracker.jumpTo(id);
    }
  }

  /// Удержание шапки — поиск по чату (как в Telegram).
  void _startSearch() {
    HapticFeedback.mediumImpact();
    _focus.unfocus();
    _searchInput.clear();
    _cubit.startSearch();
  }

  /// Свайп сообщения влево — ответить.
  void _swipeReply(models.Message message) {
    _cubit.startReply(message);
    _focus.requestFocus();
  }

  /// Шапка режима выделения: «×», «Выбрано: N», копировать / удалить /
  /// переслать.
  PreferredSizeWidget _selectionAppBar(BuildContext context, ChatState state, Color color) {
    final selected = state.selectedMessages;
    final canDelete = selected.isNotEmpty && selected.every(_cubit.canDelete);
    final canCopy = selected.any((m) => m.text.isNotEmpty);
    return AppBar(
      backgroundColor: color,
      leading: IconButton(icon: const Icon(Icons.close), onPressed: _cubit.clearSelection),
      title: Text(context.t.screenChat.selected(n: state.selectedIDs.length)),
      actions: [
        IconButton(icon: const Icon(Icons.copy), onPressed: canCopy ? () => _copySelected(context) : null),
        IconButton(icon: const Icon(Icons.delete_outline), onPressed: canDelete ? () => _deleteSelected(context) : null),
        IconButton(icon: const Icon(Icons.forward), onPressed: selected.isEmpty ? null : () => _forward(context)),
      ],
    );
  }

  /// «Переслать»: выбор чата → в этот же чат — плашка над полем ввода, в
  /// другой — переход в него (как в Telegram), там плашка и «Отправить».
  /// [single] — из меню одного сообщения: отмена выбора чата снимает и
  /// выделение.
  Future<void> _forward(BuildContext context, {bool single = false}) async {
    final targets = await _cubit.forwardTargets();
    if (!context.mounted) return;
    final target = await showForwardPicker(context, targets);
    if (!context.mounted) return;
    if (target == null) {
      if (single) _cubit.clearSelection();
      return;
    }
    _cubit.forwardSelected(target.id);
    if (target.id == _cubit.state.chat?.id) {
      _focus.requestFocus();
    } else {
      context.pushReplacement('/chats/chat/${target.id}');
    }
  }

  /// Текст отмеченных — по порядку, через пустую строку.
  void _copySelected(BuildContext context) {
    final text = _cubit.state.selectedMessages.map((m) => m.text).where((t) => t.isNotEmpty).join('\n\n');
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    _cubit.clearSelection();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.t.screenChat.copied)));
  }

  Future<void> _deleteSelected(BuildContext context) async {
    final chat = _cubit.state.chat;
    if (chat == null) return;
    final forEveryone = await _askDelete(context, chat, _cubit.state.selectedIDs.length);
    if (forEveryone != null) await _cubit.deleteSelected(forEveryone: forEveryone);
  }

  /// Подтверждение удаления [count] сообщений. Личный чат — как в Telegram,
  /// галочка «Также удалить для …» (по умолчанию снята); группа — у всех;
  /// «Избранное» — только у себя. Результат — «у всех?», `null` — отмена.
  Future<bool?> _askDelete(BuildContext context, models.Chat chat, int count) {
    final t = context.t.screenChat;
    final private = chat.type == models.ChatType.private && !chat.isSelf;
    var forBoth = false;
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(count == 1 ? t.deleteTitle : t.deleteSelectedTitle(n: count)),
          content: private
              ? CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: forBoth,
                  onChanged: (value) => setDialogState(() => forBoth = value ?? false),
                  title: Text(t.deleteAlsoFor(name: chat.title)),
                )
              : Text(
                  chat.isSelf
                      ? (count == 1 ? t.deleteMessageSelf : t.deleteSelectedMessageSelf)
                      : (count == 1 ? t.deleteMessage : t.deleteSelectedMessage),
                ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.cancel)),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
              onPressed: () => Navigator.of(dialogContext).pop(private ? forBoth : !chat.isSelf),
              child: Text(t.delete),
            ),
          ],
        ),
      ),
    );
  }

  /// Плашка закреплённого над лентой (если есть закреплённые).
  Widget _pinnedBar(BuildContext context, models.Chat chat, ChatState state) {
    final pinned = state.pinnedMessages;
    if (pinned.isEmpty) return const SizedBox.shrink();
    final index = _pinIndex % pinned.length;
    return PinnedMessageBar(
      pinned: pinned,
      index: index,
      style: PinnedBarStyle(
        background: Theme.of(context).brightness == Brightness.dark
            ? ThemesCupertino.groupedCard.darkColor
            : ThemesCupertino.groupedCard.color,
        accent: Theme.of(context).colorScheme.primary,
        text: Theme.of(context).colorScheme.onSurface,
        secondary: Theme.of(context).colorScheme.onSurfaceVariant,
        separator: Theme.of(context).colorScheme.outlineVariant,
      ),
      // Тап — к показанному, затем плашка показывает следующее (старее).
      onTap: () {
        _tracker.jumpTo(pinned[index].id);
        setState(() => _pinIndex = (index + 1) % pinned.length);
      },
      onUnpin: chat.type == models.ChatType.channel ? null : () => _confirmUnpin(context, pinned[index]),
      onList: () => _openPinned(context),
    );
  }

  /// «Закреплённые сообщения» — оттуда тап по сообщению ведёт к нему в ленте.
  Future<void> _openPinned(BuildContext context) async {
    final id = await showPinnedMessagesMaterial(context, _cubit);
    if (id != null && mounted) await _tracker.jumpTo(id);
  }

  /// «Закрепить» — сразу, без диалога: в «Избранном» только у себя, иначе
  /// у всех (с сервисным «Вы закрепили «…»»). «Открепить» — тоже сразу.
  Future<void> _pin(models.Chat chat, models.Message message) => _cubit.setPinned(message, !message.pinned, forEveryone: !chat.isSelf);

  Future<void> _confirmUnpin(BuildContext context, models.Message message) async {
    final t = context.t.screenChat;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.unpinTitle),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.unpin)),
        ],
      ),
    );
    if (confirmed ?? false) await _cubit.setPinned(message, false);
  }

  /// Нет доступа к микрофону (запись голосового).
  Future<void> _micDenied(bool permanently) async {
    final t = context.t;
    final open = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.screenChat.micDeniedTitle),
        content: Text(t.screenChat.micDeniedMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(t.common.cancel)),
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.screenChat.openSettings)),
        ],
      ),
    );
    if (open ?? false) await openAppSettings();
  }

  GlobalKey _keyFor(String messageID) => _messageKeys.putIfAbsent(messageID, GlobalKey.new);

  void _send({bool silent = false, DateTime? scheduleDate}) {
    final text = _input.text;
    // Пересылка уходит и без текста.
    if (text.trim().isEmpty && _cubit.state.forwarding.isEmpty) return;
    _input.clear();
    _cubit.send(text, silent: silent, scheduleDate: scheduleDate);
  }

  /// «Отправить позже»: время → текст уходит в отложенные.
  Future<void> _sendLater(BuildContext context) async {
    final date = await showScheduleDateMaterial(context);
    if (date != null && mounted) _send(scheduleDate: date);
  }

  /// Удержание «Отправить» (как в Telegram): без звука / позже. Позже — только
  /// текст, без пересылаемых.
  Future<void> _sendOptions(BuildContext context) async {
    final t = context.t.screenChat;
    final canSchedule = _input.text.trim().isNotEmpty && _cubit.state.forwarding.isEmpty;
    HapticFeedback.mediumImpact();
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.notifications_off_outlined),
              title: Text(t.sendSilent),
              onTap: () => Navigator.of(sheetContext).pop('silent'),
            ),
            if (canSchedule)
              ListTile(
                leading: const Icon(Icons.schedule_send_outlined),
                title: Text(t.sendLater),
                onTap: () => Navigator.of(sheetContext).pop('later'),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'silent':
        _send(silent: true);
      case 'later':
        await _sendLater(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final barColor = dark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;
    return BlocListener<ChatCubit, ChatState>(
      // Новые сообщения / разделитель непрочитанных — в навигацию по ленте.
      listenWhen: (previous, current) => previous.messages != current.messages || previous.unreadFromID != current.unreadFromID,
      listener: (context, state) => _tracker.update(state.messages, state.unreadFromID),
      child: BlocConsumer<ChatCubit, ChatState>(
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
            canPop: !state.searching && !state.selecting,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              if (state.selecting) {
                _cubit.clearSelection();
              } else {
                _cubit.closeSearch();
              }
            },
            child: Scaffold(
              backgroundColor: dark ? const Color(0xFF000000) : Theme.of(context).colorScheme.surfaceContainerLow,
              appBar: state.selecting
                  ? _selectionAppBar(context, state, barColor)
                  : state.searching
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
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _openInfo(context),
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
                                      // Комментарии к постам — только в канале, где они включены.
                                      onCommentsTap: chat.type == models.ChatType.channel && chat.commentsEnabled ? _openComments : null,
                                      style: ChatMaterial.bubbleStyle(context),
                                      padding: EdgeInsets.only(
                                        top: 8 + (state.pinnedMessages.isEmpty ? 0 : PinnedMessageBar.height),
                                        bottom: 8,
                                      ),
                                      onLongPress: (message) => _actions(context, chat, message),
                                      controller: _scroll,
                                      keyFor: _keyFor,
                                      onCancelUpload: _cubit.cancelUpload,
                                      onReaction: _cubit.toggleReaction,
                                      onDoubleTap: (message) => _cubit.quickReact(
                                        message,
                                        preferred: context.read<CommonCubit>().state.settingsDevice.quickReaction,
                                      ),
                                      onReplyTap: _tracker.jumpToReply,
                                      onPinnedServiceTap: _tracker.jumpTo,
                                      unreadFromID: state.unreadFromID,
                                      flashID: _flashID,
                                      onReply: chat.type == models.ChatType.channel || state.searching || state.selecting
                                          ? null
                                          : _swipeReply,
                                      selecting: state.selecting,
                                      selectedIDs: state.selectedIDs,
                                      onSelect: _cubit.toggleSelected,
                                      selectionColor: Theme.of(context).colorScheme.primary,
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
                              Positioned(top: 0, left: 0, right: 0, child: _pinnedBar(context, chat, state)),
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: ChatScrollDownButton(
                                  tracker: _tracker,
                                  background: barColor,
                                  iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                  badgeColor: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Режим выделения — действия в шапке, поля ввода нет.
                        if (state.selecting)
                          const SizedBox.shrink()
                        else if (state.searching)
                          _SearchBar(state: state, color: barColor)
                        // Не подписаны — «Подписаться»; подписчик канала — «Звук»;
                        // админ канала публикует посты обычным полем ввода.
                        else if (!chat.canPost)
                          _ChannelBar(chat: chat, color: barColor)
                        else
                          _ComposeBar(
                            input: _input,
                            formatMenu: _formatMenu,
                            recorder: _recorder,
                            focus: _focus,
                            state: state,
                            onSend: _send,
                            onSendOptions: () => _sendOptions(context),
                            onScheduled: () => showScheduledMessagesMaterial(context, _cubit),
                            color: barColor,
                          ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _actions(BuildContext context, models.Chat chat, models.Message message) async {
    HapticFeedback.mediumImpact();
    final t = context.t.screenChat;
    final canWrite = chat.canPost;
    final error = Theme.of(context).colorScheme.error;
    final reactions = availableReactions(chat);
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Сверху — полоса реакций (если в чате они разрешены).
            if (reactions.isNotEmpty) ...[
              ReactionPicker(
                emojis: reactions,
                selected: message.myReactions,
                selectedBackground: Theme.of(sheetContext).colorScheme.secondaryContainer,
                onSelected: (emoji) => Navigator.of(sheetContext).pop('react:$emoji'),
              ),
              const Divider(),
            ],
            if (canWrite)
              ListTile(leading: const Icon(Icons.reply), title: Text(t.reply), onTap: () => Navigator.of(sheetContext).pop('reply')),
            if (message.text.isNotEmpty)
              ListTile(leading: const Icon(Icons.copy), title: Text(t.copy), onTap: () => Navigator.of(sheetContext).pop('copy')),
            if (canWrite)
              ListTile(
                leading: Icon(message.pinned ? Icons.push_pin : Icons.push_pin_outlined),
                title: Text(message.pinned ? t.unpin : t.pin),
                onTap: () => Navigator.of(sheetContext).pop('pin'),
              ),
            ListTile(leading: const Icon(Icons.forward), title: Text(t.forward), onTap: () => Navigator.of(sheetContext).pop('forward')),
            if (message.outgoing && message.kind == models.MessageKind.text)
              ListTile(leading: const Icon(Icons.edit_outlined), title: Text(t.edit), onTap: () => Navigator.of(sheetContext).pop('edit')),
            if (message.outgoing || chat.type == models.ChatType.private)
              ListTile(
                leading: Icon(Icons.delete_outline, color: error),
                title: Text(t.delete, style: TextStyle(color: error)),
                onTap: () => Navigator.of(sheetContext).pop('delete'),
              ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(t.select),
              onTap: () => Navigator.of(sheetContext).pop('select'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    if (action != null && action.startsWith('react:')) {
      await _cubit.toggleReaction(message, action.substring('react:'.length));
      return;
    }
    switch (action) {
      case 'reply':
        _cubit.startReply(message);
        _focus.requestFocus();
      case 'copy':
        await Clipboard.setData(ClipboardData(text: message.text));
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.copied)));
      case 'edit':
        _cubit.startEdit(message);
      case 'pin':
        await _pin(chat, message);
      case 'forward':
        _cubit.startSelection(message);
        await _forward(context, single: true);
      case 'select':
        _cubit.startSelection(message);
      case 'delete':
        final forEveryone = await _askDelete(context, chat, 1);
        if (forEveryone != null) await _cubit.delete(message, forEveryone: forEveryone);
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
  final ComposeFormatMenu formatMenu;
  final VoiceRecorder recorder;
  final FocusNode focus;
  final ChatState state;
  final VoidCallback onSend;

  /// Удержание «Отправить» — без звука / позже.
  final VoidCallback onSendOptions;

  /// Значок календаря (есть отложенные) — экран «Отложенные сообщения».
  final VoidCallback onScheduled;
  final Color color;

  const _ComposeBar({
    required this.input,
    required this.formatMenu,
    required this.recorder,
    required this.focus,
    required this.state,
    required this.onSend,
    required this.onSendOptions,
    required this.onScheduled,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    final banner = composeBanner(t, state);
    final editing = state.editing != null;
    final voiceStyle = VoiceRecorderStyle(
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      text: scheme.onSurface,
      secondary: scheme.onSurfaceVariant,
      danger: scheme.error,
      surface: scheme.surfaceContainerHigh,
    );

    return Material(
      color: color,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ссылка в тексте — превью уйдёт с сообщением; × — без превью.
            if (!editing && !state.linkPreviewDisabled)
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: input,
                builder: (context, value, _) {
                  final url = composeLinkUrl(value.text);
                  if (url == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 4, 0),
                    child: Row(
                      children: [
                        Icon(Icons.link, color: scheme.primary, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.screenChat.linkPreview,
                                maxLines: 1,
                                style: TextStyle(fontWeight: FontWeight.w600, color: scheme.primary),
                              ),
                              Text(
                                url,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: scheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.close), onPressed: context.read<ChatCubit>().disableLinkPreview),
                      ],
                    ),
                  );
                },
              ),
            if (banner != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 4, 0),
                child: Row(
                  children: [
                    Icon(
                      editing
                          ? Icons.edit_outlined
                          : state.forwarding.isNotEmpty
                          ? Icons.forward
                          : Icons.reply,
                      color: scheme.primary,
                      size: 22,
                    ),
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
              // Пока пишется голосовое — вместо скрепки и поля панель записи.
              child: ListenableBuilder(
                listenable: recorder,
                builder: (context, _) => Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!recorder.active)
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        color: scheme.onSurfaceVariant,
                        onPressed: editing ? null : () => pickAndSendAttachments(context, input: input),
                      ),
                    Expanded(
                      child: recorder.active
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: VoiceRecordingPanel(recorder: recorder, style: voiceStyle),
                            )
                          : TextField(
                              controller: input,
                              focusNode: focus,
                              contextMenuBuilder: formatMenu.builder,
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
                    if (!recorder.active && !editing && state.scheduled.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.event_note_outlined),
                        color: scheme.primary,
                        tooltip: t.screenChat.scheduledHint,
                        onPressed: onScheduled,
                      ),
                    // Ключ: кнопка не пересоздаётся, когда скрепка исчезает
                    // (иначе палец, держащий микрофон, «потеряется»).
                    KeyedSubtree(
                      key: const ValueKey('compose-action'),
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: input,
                        builder: (context, value, _) {
                          final canSend = value.text.trim().isNotEmpty || state.forwarding.isNotEmpty;
                          // Пусто — микрофон (голосовое), как в Telegram.
                          // Слот фиксированный (как у скрепки слева): поле ввода не
                          // дёргается при смене кнопки.
                          return ComposeActionSlot(
                            size: const Size(48, 48),
                            child: !canSend && !editing
                                ? VoiceRecordButton(key: const ValueKey('mic'), recorder: recorder, style: voiceStyle)
                                : GestureDetector(
                                    key: ValueKey(editing ? 'edit' : 'send'),
                                    onLongPress: canSend && !editing ? onSendOptions : null,
                                    child: IconButton(
                                      icon: Icon(editing ? Icons.check : Icons.send),
                                      color: scheme.primary,
                                      onPressed: canSend ? onSend : null,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Писать нельзя: не подписаны — «Подписаться» / «Вступить» / «Подать заявку»
/// («Заявка отправлена» — неактивна); подписчик канала — только звук.
class _ChannelBar extends StatelessWidget {
  final models.Chat chat;
  final Color color;

  const _ChannelBar({required this.chat, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final (label, action) = channelBarAction(context, chat);
    return Material(
      color: color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: TextButton(onPressed: action, child: Text(label ?? (chat.muted ? t.unmute : t.mute))),
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
