import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../chats/message_formatting.dart';
import '../../chats/reactions.dart';
import '../../chats/voice_player.dart';
import '../../constants.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';
import 'comments_limit.dart';
import 'compose_format_menu.dart';
import 'forward_picker.dart';
import 'chat_info_cupertino.dart';
import 'message_context_menu_cupertino.dart';
import 'pinned_messages_cupertino.dart';
import 'scheduled_messages_cupertino.dart';
import 'voice_recorder.dart';

/// Окно чата (iOS): шапка с аватаром и «печатает…», лента пузырей, поле ввода
/// с markdown-ярлыками и скрепкой; в канале вместо поля — «Выключить звук».
/// Действия над сообщением — по long-press. Пока только UX-демо, см.
/// docs/plans/chats-groups-channels.md, «Этап 0».
class ChatCupertino extends StatefulWidget {
  const ChatCupertino({super.key});

  /// Оформление пузырей — и для окна чата, и для превью «Тем для чатов».
  static MessageBubbleStyle bubbleStyle(BuildContext context) {
    final dark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final label = CupertinoColors.label.resolveFrom(context);
    final onOutgoing = ThemesCupertino.chatOnOutgoing(context);
    // В тёмной теме — тона Android: ссылки и мета мягкие (см. chatAccent),
    // исходящие — `primaryContainer` со светлым текстом (см. chatOutgoing).
    return MessageBubbleStyle(
      incoming: dark ? const Color(0xFF262628) : const Color(0xFFFFFFFF),
      outgoing: ThemesCupertino.chatOutgoing(context),
      incomingText: MessageTextColors(
        text: label,
        link: ThemesCupertino.chatAccent(context),
        codeBackground: CupertinoColors.systemGrey5.resolveFrom(context),
        spoiler: CupertinoColors.systemGrey3.resolveFrom(context),
        quote: CupertinoColors.secondaryLabel.resolveFrom(context),
      ),
      outgoingText: MessageTextColors(
        text: onOutgoing,
        link: ThemesCupertino.chatOutgoingLink(context),
        codeBackground: onOutgoing.withValues(alpha: 0.2),
        spoiler: onOutgoing.withValues(alpha: 0.4),
        quote: onOutgoing.withValues(alpha: 0.9),
      ),
      incomingMeta: ThemesCupertino.chatMeta(context),
      outgoingMeta: onOutgoing.withValues(alpha: 0.8),
      incomingOnLink: ThemesCupertino.onAccent(context),
      pill: dark ? const Color(0x66000000) : const Color(0x22000000),
      pillText: dark ? const Color(0xFFFFFFFF) : const Color(0xFF3C3C43),
      textStyle: TextStyle(fontSize: 16, height: 1.25, color: label, fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily),
    );
  }

  @override
  State<ChatCupertino> createState() => _ChatCupertinoState();
}

class _ChatCupertinoState extends State<ChatCupertino> {
  final _input = TextEditingController();
  late final _mentions = ComposeMentions(_input);
  late final _formatMenu = ComposeFormatMenu(_input, members: () => _mentions.enabled ? _mentions.members : const []);
  late final _recorder = VoiceRecorder(
    onSend: (path, seconds, waveform) => _cubit.sendVoice(localPath: path, duration: seconds, waveform: waveform),
    canStart: () => checkNewcomer(context, media: true),
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
    MessageText.mentionNameHandler = openMentionName;
    _cubit = context.read<ChatCubit>();
    // Участники — для подсказки «@» (у личного чата список пустой).
    _cubit.loadMembers();
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
    _mentions.dispose();
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
    final result = await showChatInfoCupertino(context, _cubit);
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
  void _copySelected() {
    final text = _cubit.state.selectedMessages.map((m) => m.text).where((t) => t.isNotEmpty).join('\n\n');
    if (text.isNotEmpty) Clipboard.setData(ClipboardData(text: text));
    _cubit.clearSelection();
  }

  Future<void> _deleteSelected(BuildContext context) async {
    final chat = _cubit.state.chat;
    if (chat == null) return;
    final forEveryone = await _askDelete(context, chat, _cubit.state.selectedIDs.length);
    if (forEveryone != null) await _cubit.deleteSelected(forEveryone: forEveryone);
  }

  /// Подтверждение удаления [count] сообщений. Личный чат — как в Telegram,
  /// лист «Удалить у меня и у …» / «Удалить только у меня»; группа — у всех;
  /// «Избранное» — только у себя. Результат — «у всех?», `null` — отмена.
  Future<bool?> _askDelete(BuildContext context, models.Chat chat, int count) {
    final t = context.t.screenChat;
    final title = count == 1 ? t.deleteTitle : t.deleteSelectedTitle(n: count);
    if (chat.type == models.ChatType.private && !chat.isSelf) {
      return showCupertinoModalPopup<bool>(
        context: context,
        builder: (sheetContext) => CupertinoActionSheet(
          title: Text(title),
          actions: [
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(sheetContext).pop(true),
              child: Text(t.deleteForBoth(name: chat.title)),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(sheetContext).pop(false),
              child: Text(t.deleteForMe),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(context.t.common.cancel)),
        ),
      );
    }
    final self = chat.isSelf;
    return showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(
          self
              ? (count == 1 ? t.deleteMessageSelf : t.deleteSelectedMessageSelf)
              : (count == 1 ? t.deleteMessage : t.deleteSelectedMessage),
        ),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(!self), child: Text(t.delete)),
        ],
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
        background: ThemesCupertino.appBackground.resolveFrom(context).withValues(alpha: 0.92),
        accent: CupertinoTheme.of(context).primaryColor,
        text: CupertinoColors.label.resolveFrom(context),
        secondary: CupertinoColors.secondaryLabel.resolveFrom(context),
        separator: CupertinoColors.separator.resolveFrom(context),
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
    final id = await showPinnedMessagesCupertino(context, _cubit);
    if (id != null && mounted) await _tracker.jumpTo(id);
  }

  /// «Закрепить» — сразу, без диалога: в «Избранном» только у себя, иначе
  /// у всех (с сервисным «Вы закрепили «…»»). «Открепить» — тоже сразу.
  Future<void> _pin(models.Chat chat, models.Message message) => _cubit.setPinned(message, !message.pinned, forEveryone: !chat.isSelf);

  Future<void> _confirmUnpin(BuildContext context, models.Message message) async {
    final t = context.t.screenChat;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.unpinTitle),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.unpin)),
        ],
      ),
    );
    if (confirmed ?? false) await _cubit.setPinned(message, false);
  }

  /// Нет доступа к микрофону (запись голосового).
  Future<void> _micDenied(bool permanently) async {
    final t = context.t;
    final open = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.screenChat.micDeniedTitle),
        content: Text(t.screenChat.micDeniedMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(t.common.cancel)),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.screenChat.openSettings),
          ),
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
    // Медленный режим: правка — можно; иначе текст и пересылаемые — отдельные
    // сообщения, а разрешено одно.
    if (_cubit.state.editing == null && !checkSlowMode(context, count: (text.trim().isEmpty ? 0 : 1) + _cubit.state.forwarding.length)) {
      return;
    }
    // Новичку — только текст без ссылок (и пересылать — тоже).
    if (!checkNewcomer(context, raw: text, forwarding: _cubit.state.forwarding)) return;
    _input.clear();
    _cubit.send(text, silent: silent, scheduleDate: scheduleDate, mentions: _mentions.take());
  }

  /// «Отправить позже»: время → текст уходит в отложенные.
  Future<void> _sendLater(BuildContext context) async {
    // Выбор даты убирает клавиатуру; передумали — возвращаем её.
    final hadFocus = _focus.hasFocus;
    final date = await showScheduleDateCupertino(context);
    if (!mounted) return;
    if (date != null) {
      _send(scheduleDate: date);
    } else if (hadFocus) {
      _focus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
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
          // Подсказка «@» — в группах, сообществах и комментариях.
          _mentions
            ..enabled = chat != null && (chat.type == models.ChatType.group || chat.type == models.ChatType.community)
            ..members = state.members;
          final background = CupertinoTheme.brightnessOf(context) == Brightness.dark
              ? const Color(0xFF000000)
              : CupertinoColors.systemGroupedBackground.resolveFrom(context);
          final barColor = ThemesCupertino.appBackground.resolveFrom(context).withValues(alpha: 0.92);
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
            child: CupertinoPageScaffold(
              backgroundColor: background,
              navigationBar: state.selecting
                  ? AppCupertinoNavigationBar(
                      child: CupertinoNavigationBar(
                        automaticallyImplyLeading: false,
                        automaticBackgroundVisibility: false,
                        backgroundColor: barColor,
                        middle: Text(t.screenChat.selected(n: state.selectedIDs.length)),
                        trailing: CupertinoButton(
                          padding: const EdgeInsets.only(left: 8),
                          minimumSize: Size.zero,
                          onPressed: _cubit.clearSelection,
                          child: Text(t.common.cancel, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
                        ),
                      ),
                    )
                  : state.searching
                  ? AppCupertinoNavigationBar(
                      child: CupertinoNavigationBar(
                        automaticallyImplyLeading: false,
                        automaticBackgroundVisibility: false,
                        backgroundColor: barColor,
                        middle: CupertinoSearchTextField(
                          controller: _searchInput,
                          autofocus: true,
                          placeholder: t.screenChat.search,
                          onChanged: _cubit.setSearchQuery,
                        ),
                        trailing: CupertinoButton(
                          padding: const EdgeInsets.only(left: 8),
                          minimumSize: Size.zero,
                          onPressed: _cubit.closeSearch,
                          child: Text(t.common.cancel, style: TextStyle(color: ThemesCupertino.navActionColor(context))),
                        ),
                      ),
                    )
                  : AppCupertinoNavigationBar(
                      child: CupertinoNavigationBar(
                        previousPageTitle: '',
                        // Фон панели всегда (без автоскрытия у края ленты): иначе у верха
                        // истории панель становилась прозрачной и под ней была чёрная полоса.
                        automaticBackgroundVisibility: false,
                        backgroundColor: barColor,
                        middle: chat == null
                            ? null
                            : GestureDetector(
                                onTap: () => _openInfo(context),
                                onLongPress: _startSearch,
                                child: _Header(chat: chat),
                              ),
                        trailing: chat == null
                            ? null
                            : GestureDetector(
                                onTap: () => _openInfo(context),
                                onLongPress: _startSearch,
                                child: ChatAvatar(
                                  chat: chat,
                                  size: 36,
                                  accentColor: CupertinoTheme.of(context).primaryColor,
                                  accentForeground: ThemesCupertino.onAccent(context),
                                ),
                              ),
                      ),
                    ),
              // Обои из «Тем для чатов» (Настройки → Оформление) — на весь экран,
              // в том числе под полупрозрачной панелью навигации (как в Telegram).
              child: Stack(
                children: [
                  if (chat != null)
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
                          dark: CupertinoTheme.brightnessOf(context) == Brightness.dark,
                        ),
                      ),
                    ),
                  SafeArea(
                    bottom: false,
                    child: chat == null
                        ? Center(
                            child: Text(
                              state.status == Status.success ? t.screenChat.notFound : '',
                              style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                            ),
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    state.messages.isEmpty
                                        ? Center(
                                            child: Text(
                                              t.screenChat.empty,
                                              style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                                            ),
                                          )
                                        : ChatMessagesView(
                                            messages: state.messages,
                                            chatType: chat.type,
                                            // Комментарии к постам — только в канале, где они включены.
                                            onCommentsTap: chat.type == models.ChatType.channel && chat.commentsEnabled
                                                ? _openComments
                                                : null,
                                            commentsClosedIDs: state.commentsClosedIDs,
                                            // Опрос: голосовать — участникам (не подписавшимся — нет).
                                            onPollVote: chat.isMember ? (message, options) => _cubit.votePoll(message, options) : null,
                                            onPollVoters: (message) => showPollVoters(context, message.poll!),
                                            style: ChatCupertino.bubbleStyle(context),
                                            padding: EdgeInsets.only(
                                              top: 8 + (state.pinnedMessages.isEmpty ? 0 : PinnedMessageBar.height),
                                              bottom: 8,
                                            ),
                                            // Удержание — CupertinoContextMenu (menuWrapper), не action sheet.
                                            onLongPress: (_) {},
                                            menuWrapper: (message, bubble, preview) => _menu(context, chat, message, bubble, preview),
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
                                            flashRange: _tracker.flashRange,
                                            onReply:
                                                chat.type == models.ChatType.channel ||
                                                    state.commentsBlocked ||
                                                    state.searching ||
                                                    state.selecting
                                                ? null
                                                : _swipeReply,
                                            selecting: state.selecting,
                                            selectedIDs: state.selectedIDs,
                                            onSelect: _cubit.toggleSelected,
                                            selectionColor: CupertinoTheme.of(context).primaryColor,
                                            selectionCheckColor: ThemesCupertino.onAccent(context),
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
                                        background: ThemesCupertino.appBackground.resolveFrom(context).withValues(alpha: 0.92),
                                        iconColor: CupertinoColors.secondaryLabel.resolveFrom(context),
                                        badgeColor: CupertinoTheme.of(context).primaryColor,
                                        badgeTextColor: ThemesCupertino.onAccent(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (state.selecting)
                                _SelectionBar(
                                  state: state,
                                  onDelete: () => _deleteSelected(context),
                                  onCopy: _copySelected,
                                  onForward: () => _forward(context),
                                )
                              else if (state.searching)
                                _SearchBar(state: state)
                              // Не подписаны — «Подписаться»; подписчик канала — «Звук»;
                              // админ канала публикует посты обычным полем ввода.
                              else if (!chat.canPost)
                                _ChannelBar(chat: chat)
                              // Комментарии закрыты / только подписчикам / мало подписаны.
                              else if (state.commentsBlocked)
                                _CommentsBlockedBar(state: state)
                              else ...[
                                // Подсказка «@» — над полем ввода.
                                MentionSuggestions(
                                  mentions: _mentions,
                                  background: ThemesCupertino.appBackground.resolveFrom(context),
                                  text: CupertinoColors.label.resolveFrom(context),
                                  secondary: CupertinoColors.secondaryLabel.resolveFrom(context),
                                  separator: CupertinoColors.separator.resolveFrom(context),
                                ),
                                // ⌘B / ⌘I / ⌘U / ⌘K — форматирование с клавиатуры.
                                _formatMenu.shortcuts(
                                  context,
                                  child: _ComposeBar(
                                    input: _input,
                                    formatMenu: _formatMenu,
                                    recorder: _recorder,
                                    focus: _focus,
                                    state: state,
                                    onSend: _send,
                                    onSendSilent: () => _send(silent: true),
                                    onSendLater: () => _sendLater(context),
                                    onScheduled: () => showScheduledMessagesCupertino(context, _cubit),
                                  ),
                                ),
                              ],
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Пузырь в нативном контекстном меню iOS (удержание): пузырь
  /// «приподнимается», фон размывается, под ним — полоса реакций и действия.
  ///
  /// Текст в приподнятом пузыре можно выделить: «Копировать | Цитировать»
  /// (ответ на фрагмент, как в Telegram).
  Widget _menu(BuildContext context, models.Chat chat, models.Message message, Widget bubble, MessageBubblePreview preview) {
    Widget quotable(Widget text) => QuotableText(
      text: message.text,
      entities: message.entities,
      selectionControls: cupertinoTextSelectionHandleControls,
      toolbarBuilder: (context, anchors, items) => CupertinoAdaptiveTextSelectionToolbar.buttonItems(anchors: anchors, buttonItems: items),
      onQuote: (quote) {
        Navigator.of(context, rootNavigator: true).pop();
        _cubit.startReply(message, quote: quote);
        _focus.requestFocus();
      },
      child: text,
    );
    return MessageContextMenuCupertino(
      actions: _menuActions(context, chat, message),
      bubble: bubble,
      preview: (maxWidth) => preview(maxWidth, selectableText: chat.canPost && !_cubit.state.commentsBlocked ? quotable : null),
    );
  }

  List<Widget> _menuActions(BuildContext context, models.Chat chat, models.Message message) {
    final t = context.t.screenChat;
    final canWrite = chat.canPost && !_cubit.state.commentsBlocked;
    final commentsClosed = _cubit.state.commentsClosedIDs.contains(message.id);
    final reactions = availableReactions(chat, message: message);

    // Меню — маршрут корневого навигатора: сначала закрываем его, потом
    // действие (иначе превью «мигнёт» уже изменённым пузырём).
    void close() => Navigator.of(context, rootNavigator: true).pop();
    CupertinoContextMenuAction action(String label, IconData icon, VoidCallback run, {bool destructive = false}) {
      return CupertinoContextMenuAction(
        trailingIcon: icon,
        isDestructiveAction: destructive,
        onPressed: () {
          close();
          run();
        },
        child: Text(label),
      );
    }

    return [
      if (reactions.isNotEmpty)
        ReactionPicker(
          emojis: reactions,
          selected: message.myReactions,
          selectedBackground: CupertinoColors.systemGrey4.resolveFrom(context),
          onSelected: (emoji) {
            close();
            _cubit.toggleReaction(message, emoji);
          },
        ),
      if (canWrite)
        action(t.reply, CupertinoIcons.reply, () {
          _cubit.startReply(message);
          _focus.requestFocus();
        }),
      if (message.text.isNotEmpty) action(t.copy, CupertinoIcons.doc_on_doc, () => Clipboard.setData(ClipboardData(text: message.text))),
      if (canWrite)
        action(message.pinned ? t.unpin : t.pin, message.pinned ? CupertinoIcons.pin_slash : CupertinoIcons.pin, () => _pin(chat, message)),
      action(t.forward, CupertinoIcons.arrowshape_turn_up_right, () {
        _cubit.startSelection(message);
        _forward(context, single: true);
      }),
      if (message.outgoing && message.kind == models.MessageKind.text)
        action(t.edit, CupertinoIcons.pencil, () => _cubit.startEdit(message)),
      if (message.outgoing || chat.type == models.ChatType.private)
        action(t.delete, CupertinoIcons.delete, () => _confirmDelete(context, chat, message), destructive: true),
      if (canRetractVote(message)) action(t.retractVote, CupertinoIcons.arrow_uturn_left, () => _cubit.votePoll(message, const [])),
      if (canClosePoll(chat, message))
        action(t.closePoll, CupertinoIcons.stop_circle, () async {
          if (await confirmClosePoll(context)) await _cubit.closePoll(message);
        }, destructive: true),
      if (canToggleComments(chat, message))
        commentsClosed
            ? action(t.openComments, CupertinoIcons.chat_bubble, () => _cubit.setCommentsClosed(message, false))
            : action(t.closeComments, CupertinoIcons.lock, () async {
                if (await confirmCloseComments(context)) await _cubit.setCommentsClosed(message, true);
              }, destructive: true),
      action(t.select, CupertinoIcons.checkmark_circle, () => _cubit.startSelection(message)),
    ];
  }

  Future<void> _confirmDelete(BuildContext context, models.Chat chat, models.Message message) async {
    final forEveryone = await _askDelete(context, chat, 1);
    if (forEveryone != null) await _cubit.delete(message, forEveryone: forEveryone);
  }
}

class _Header extends StatelessWidget {
  final models.Chat chat;

  const _Header({required this.chat});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final subtitle = chatSubtitle(t, chat);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(ChatTileContent.title(t, chat), maxLines: 1, overflow: TextOverflow.ellipsis),
        if (subtitle.text.isNotEmpty)
          Text(
            subtitle.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: subtitle.active ? CupertinoTheme.of(context).primaryColor : CupertinoColors.secondaryLabel.resolveFrom(context),
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

  /// Удержание «Отправить» (как в Telegram) — выпадающее меню: без звука /
  /// позже (позже — только текст, без пересылаемых).
  final VoidCallback onSendSilent;
  final VoidCallback onSendLater;

  /// Значок календаря (есть отложенные) — экран «Отложенные сообщения».
  final VoidCallback onScheduled;

  const _ComposeBar({
    required this.input,
    required this.formatMenu,
    required this.recorder,
    required this.focus,
    required this.state,
    required this.onSend,
    required this.onSendSilent,
    required this.onSendLater,
    required this.onScheduled,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final primary = CupertinoTheme.of(context).primaryColor;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final banner = composeBanner(t, state);
    final editing = state.editing != null;
    final voiceStyle = VoiceRecorderStyle(
      primary: primary,
      onPrimary: const Color(0xFFFFFFFF),
      text: CupertinoColors.label.resolveFrom(context),
      secondary: secondary,
      danger: CupertinoColors.systemRed.resolveFrom(context),
      surface: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ThemesCupertino.appBackground.resolveFrom(context),
        border: Border(top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
      ),
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
                    padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                    child: Row(
                      children: [
                        FaIcon(FontAwesomeIcons.link, size: 16, color: primary),
                        const SizedBox(width: 10),
                        Container(width: 2, height: 32, color: primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.screenChat.linkPreview,
                                maxLines: 1,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
                              ),
                              Text(
                                url,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, color: secondary),
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.all(8),
                          minimumSize: Size.zero,
                          onPressed: context.read<ChatCubit>().disableLinkPreview,
                          child: Icon(CupertinoIcons.xmark_circle_fill, color: secondary, size: 22),
                        ),
                      ],
                    ),
                  );
                },
              ),
            if (banner != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                child: Row(
                  children: [
                    FaIcon(
                      editing
                          ? FontAwesomeIcons.pen
                          : state.forwarding.isNotEmpty
                          ? FontAwesomeIcons.share
                          : banner.quote
                          ? FontAwesomeIcons.quoteLeft
                          : FontAwesomeIcons.reply,
                      size: 16,
                      color: primary,
                    ),
                    const SizedBox(width: 10),
                    Container(width: 2, height: 32, color: primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
                          ),
                          composeBannerText(banner, const TextStyle(fontSize: 14), secondary, primary),
                        ],
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size.zero,
                      onPressed: () {
                        if (editing) input.clear();
                        context.read<ChatCubit>().cancelCompose();
                      },
                      child: Icon(CupertinoIcons.xmark_circle_fill, color: secondary, size: 22),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 6, 8, 6),
              // Пока пишется голосовое — вместо скрепки и поля панель записи.
              child: ListenableBuilder(
                listenable: recorder,
                builder: (context, _) => Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!recorder.active)
                      CupertinoButton(
                        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                        minimumSize: Size.zero,
                        onPressed: editing ? null : () => pickAndSendAttachments(context, input: input),
                        child: FaIcon(FontAwesomeIcons.paperclip, size: 22, color: secondary),
                      ),
                    Expanded(
                      child: recorder.active
                          ? VoiceRecordingPanel(recorder: recorder, style: voiceStyle)
                          : CupertinoTextField(
                              controller: input,
                              focusNode: focus,
                              contextMenuBuilder: formatMenu.builder,
                              placeholder: t.screenChat.message,
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
                    if (!recorder.active && !editing && state.scheduled.isNotEmpty)
                      CupertinoButton(
                        padding: const EdgeInsets.fromLTRB(8, 6, 4, 6),
                        minimumSize: Size.zero,
                        onPressed: onScheduled,
                        child: FaIcon(FontAwesomeIcons.calendarDays, size: 21, color: primary),
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
                          // Слот фиксированный: поле ввода не дёргается при смене кнопки.
                          return ComposeActionSlot(
                            size: const Size(44, 34),
                            child: state.slowModeLeft > 0 && !editing
                                ? SlowModeCountdown(key: const ValueKey('slow'), seconds: state.slowModeLeft, color: secondary)
                                : !canSend && !editing
                                ? VoiceRecordButton(key: const ValueKey('mic'), recorder: recorder, style: voiceStyle)
                                : CupertinoMenuAnchor(
                                    key: ValueKey(editing ? 'edit' : 'send'),
                                    menuChildren: [
                                      CupertinoMenuItem(
                                        trailing: const Icon(CupertinoIcons.bell_slash),
                                        onPressed: onSendSilent,
                                        child: Text(t.screenChat.sendSilent),
                                      ),
                                      if (value.text.trim().isNotEmpty && state.forwarding.isEmpty)
                                        CupertinoMenuItem(
                                          trailing: const Icon(CupertinoIcons.calendar),
                                          onPressed: onSendLater,
                                          child: Text(t.screenChat.sendLater),
                                        ),
                                    ],
                                    builder: (context, controller, _) => GestureDetector(
                                      onLongPress: canSend && !editing
                                          ? () {
                                              HapticFeedback.mediumImpact();
                                              controller.open();
                                            }
                                          : null,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        onPressed: canSend ? onSend : null,
                                        child: Icon(
                                          editing ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.arrow_up_circle_fill,
                                          size: 32,
                                          color: canSend ? primary : CupertinoColors.systemGrey3.resolveFrom(context),
                                        ),
                                      ),
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

/// Режим выделения — вместо поля ввода: «Удалить» (если все отмеченные можно
/// удалить), «Копировать» (если есть текст), «Переслать».
class _SelectionBar extends StatelessWidget {
  final ChatState state;
  final VoidCallback onDelete;
  final VoidCallback onCopy;
  final VoidCallback onForward;

  const _SelectionBar({required this.state, required this.onDelete, required this.onCopy, required this.onForward});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatCubit>();
    final selected = state.selectedMessages;
    final canDelete = selected.isNotEmpty && selected.every(cubit.canDelete);
    final canCopy = selected.any((m) => m.text.isNotEmpty);
    Widget button(IconData icon, VoidCallback? onPressed, {bool destructive = false}) => CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 26,
        color: onPressed == null
            ? CupertinoColors.systemGrey3.resolveFrom(context)
            : destructive
            ? CupertinoColors.systemRed.resolveFrom(context)
            : CupertinoTheme.of(context).primaryColor,
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ThemesCupertino.appBackground.resolveFrom(context),
        border: Border(top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            button(CupertinoIcons.delete, canDelete ? onDelete : null, destructive: true),
            button(CupertinoIcons.doc_on_doc, canCopy ? onCopy : null),
            button(CupertinoIcons.arrowshape_turn_up_right, selected.isEmpty ? null : onForward),
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

  const _ChannelBar({required this.chat});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final (label, action) = channelBarAction(context, chat);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ThemesCupertino.appBackground.resolveFrom(context),
        border: Border(top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: CupertinoButton(onPressed: action, child: Text(label ?? (chat.muted ? t.unmute : t.mute))),
        ),
      ),
    );
  }
}

/// Писать в ветку комментариев нельзя — вместо поля ввода: «Комментарии
/// закрыты» (срок вышел / админ закрыл), «Подписаться, чтобы комментировать»
/// (канал «только подписчики») или «Комментировать можно с …» (подписаны
/// меньше «Подписки не менее»).
class _CommentsBlockedBar extends StatelessWidget {
  final ChatState state;

  const _CommentsBlockedBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    Widget note(IconData icon, String text) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 17, color: secondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, color: secondary),
          ),
        ),
      ],
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ThemesCupertino.appBackground.resolveFrom(context),
        border: Border(top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: switch (state.commentsBlock) {
            ChatCommentsBlock.subscribe => CupertinoButton(
              onPressed: context.read<ChatCubit>().subscribeToChannel,
              child: Text(t.screenChat.commentsSubscribe),
            ),
            ChatCommentsBlock.wait when state.commentsWaitUntil != null => note(
              CupertinoIcons.clock,
              commentsWaitLabel(t, state.commentsWaitUntil!),
            ),
            _ => note(CupertinoIcons.lock, t.screenChat.commentsClosed),
          },
        ),
      ),
    );
  }
}

/// Низ экрана в режиме поиска: «3 из 12» / «Нет результатов» и стрелки
/// «к старым» / «к новым».
class _SearchBar extends StatelessWidget {
  final ChatState state;

  const _SearchBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final cubit = context.read<ChatCubit>();
    final total = state.searchResults.length;
    final label = total > 0
        ? t.mediaCounter(current: state.searchIndex + 1, total: total)
        : (state.searchQuery.trim().isEmpty ? '' : t.searchNoResults);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ThemesCupertino.appBackground.resolveFrom(context),
        border: Border(top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Text(label, style: TextStyle(fontSize: 15, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
              ),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                onPressed: state.searchIndex + 1 < total ? cubit.searchOlder : null,
                child: const Icon(CupertinoIcons.chevron_up, size: 22),
              ),
              CupertinoButton(
                padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
                onPressed: state.searchIndex > 0 ? cubit.searchNewer : null,
                child: const Icon(CupertinoIcons.chevron_down, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
