import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:material_ui/material_ui.dart';

import '../../chats/message_formatting.dart';
import '../../components/chats/emoji_panel.dart';
import '../../chats/reactions.dart';
import '../../chats/read_receipts.dart';
import '../../chats/voice_player.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_actions_material.dart';
import 'chat_common.dart';
import 'chat_no_forwards.dart';
import 'chat_info_common.dart';
import 'comments_limit.dart';
import 'compose_format_menu.dart';
import 'forward_picker.dart';
import 'chat_info_material.dart';
import 'pinned_messages_material.dart';
import 'pin_scope_material.dart';
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
      incomingOnLink: scheme.onPrimary,
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
  late final _mentions = ComposeMentions(_input);
  late final _formatMenu = ComposeFormatMenu(
    _input,
    members: () => _mentions.enabled ? _mentions.members : const [],
    onPasteMedia: (context) => pasteClipboardMedia(context, input: _input),
    focus: _focus,
  );
  late final _recorder = VoiceRecorder(
    onSend: (path, seconds, waveform) => _cubit.sendVoice(localPath: path, duration: seconds, waveform: waveform),
    canStart: () => checkNewcomer(context, media: true),
    onDenied: _micDenied,
  );
  final _focus = FocusNode();
  late final _emoji = EmojiPanelController(focus: _focus);
  final _scroll = ScrollController();
  final _searchInput = TextEditingController();

  /// Ключи строк ленты — для прокрутки к найденному (поиск по чату).
  final _messageKeys = <String, GlobalKey>{};
  late final ChatCubit _cubit;
  StreamSubscription<List<String>>? _dustSubscription;
  late final _tracker = ChatScrollTracker(_scroll, _keyFor);
  String? _flashID;

  /// Какое закреплённое показано в плашке (по кругу от новых к старым).
  int _pinIndex = 0;

  /// Черновик, подставленный в поле (из списка / с другого устройства).
  /// Пока поле с ним совпадает (не трогали), новый черновик с другого
  /// устройства подставляется сам, а при уходе ничего не сохраняем — иначе
  /// нетронутое поле затёрло бы черновик, пришедший позже.
  String _shownDraft = '';
  String? _editingID;

  @override
  void initState() {
    super.initState();
    // Ссылки iperon.net в сообщениях — открываются в приложении.
    MessageText.linkHandler = openIperonLink;
    MessageText.mentionNameHandler = openMentionName;
    _cubit = context.read<ChatCubit>();
    // Удалили не здесь (собеседник, другое устройство) — тоже пылью.
    _dustSubscription = _cubit.dustRequests.listen((ids) {
      if (mounted) dissolveRemoved(context, _cubit, ids, _keyFor);
    });
    // Прокрутили к началу ленты (список перевёрнут — это конец прокрутки) —
    // подгрузить более старые сообщения.
    _scroll.addListener(_maybeLoadOlder);
    // Участники — для подсказки «@» (у личного чата список пустой).
    _cubit.loadMembers();
    // Подсветка после перехода по цитате — перестроить ленту.
    _tracker.addListener(() {
      if (_flashID != _tracker.flashID && mounted) setState(() => _flashID = _tracker.flashID);
    });
    // Сообщения могли прийти до подписки слушателя.
    _tracker.update(_cubit.state.messages, _cubit.state.unreadFromID);
    // Чат (с черновиком) — тоже: переход «нет чата → есть» слушатель не увидит.
    _applyDraft(_cubit.state.chat?.draft ?? '');
    // «Печатает…» / «записывает аудио…» собеседнику.
    _typedText = _input.text;
    _input.addListener(_onInputChanged);
    _recorder.addListener(() => _cubit.setRecording(_recorder.active));
  }

  /// Последний текст поля — отличить ввод от смены выделения.
  String _typedText = '';

  void _onInputChanged() {
    final text = _input.text;
    if (text == _typedText) return;
    _typedText = text;
    // Подставленный черновик — не набор.
    if (text.isNotEmpty && text == _shownDraft) return;
    _cubit.composeChanged(text);
  }

  /// Подставить черновик [draft], если поле не трогали и не правим сообщение.
  void _applyDraft(String draft) {
    if (_cubit.state.editing != null || _input.text != _shownDraft || draft == _shownDraft) return;
    _shownDraft = draft;
    _input.value = TextEditingValue(
      text: draft,
      selection: TextSelection.collapsed(offset: draft.length),
    );
  }

  @override
  void dispose() {
    _dustSubscription?.cancel();
    // Поле не трогали — черновик прежний (или пришёл с другого устройства).
    if (_input.text != _shownDraft) _cubit.saveDraft(_input.text);
    _formatMenu.dispose();
    _recorder.dispose();
    VoicePlayer.instance.stop();
    _mentions.dispose();
    _input.dispose();
    _emoji.dispose();
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
    // Защита содержимого — ни копирования, ни пересылки.
    final noForwards = state.chat?.noForwards ?? false;
    final canCopy = !noForwards && selected.any((m) => m.text.isNotEmpty);
    return AppBar(
      backgroundColor: color,
      leading: IconButton(icon: const Icon(Icons.close), onPressed: _cubit.clearSelection),
      title: Text(context.t.screenChat.selected(n: state.selectedIDs.length)),
      actions: [
        IconButton(icon: const Icon(Icons.copy), onPressed: canCopy ? () => _copySelected(context) : null),
        IconButton(icon: const Icon(Icons.delete_outline), onPressed: canDelete ? () => _deleteSelected(context) : null),
        if (_cubit.features.forward)
          IconButton(icon: const Icon(Icons.forward), onPressed: selected.isEmpty || noForwards ? null : () => _forward(context)),
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
    // «Избранное» из другого чата — сразу туда, остаёмся здесь (как в Telegram).
    if (target.isSelf && target.id != _cubit.state.chat?.id) {
      final saved = await _cubit.saveSelected(target.id);
      if (saved > 0 && context.mounted) showChatToast(context, context.t.screenChat.savedToFavorites(n: saved));
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

  /// Отмеченные — с «пылью» (см. [deleteWithDust]).
  Future<void> _deleteSelectedScoped(BuildContext context, bool forEveryone) => deleteWithDust(
    context,
    _cubit,
    [
      for (final m in _cubit.state.selectedMessages)
        if (_cubit.canDelete(m)) m.id,
    ],
    _keyFor,
    () => _cubit.deleteSelected(forEveryone: forEveryone),
  );

  Future<void> _deleteSelected(BuildContext context) async {
    final chat = _cubit.state.chat;
    if (chat == null) return;
    final forEveryone = await _askDelete(context, chat, _cubit.state.selectedIDs.length);
    if (forEveryone != null && context.mounted) await _deleteSelectedScoped(context, forEveryone);
  }

  /// Подтверждение удаления [count] сообщений. Личный чат — шторка «У меня» /
  /// «У меня и собеседника» ([pickScopeMaterial]); группа — у всех;
  /// «Избранное» — только у себя. Результат — «у всех?», `null` — отмена.
  Future<bool?> _askDelete(BuildContext context, models.Chat chat, int count) {
    final t = context.t.screenChat;
    final title = count == 1 ? t.deleteTitle : t.deleteSelectedTitle(n: count);
    if (chatDeleteScoped(chat)) return pickScopeMaterial(context, title: title);
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(
          chat.isSelf
              ? (count == 1 ? t.deleteMessageSelf : t.deleteSelectedMessageSelf)
              : (count == 1 ? t.deleteMessage : t.deleteSelectedMessage),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
            onPressed: () => Navigator.of(dialogContext).pop(!chat.isSelf),
            child: Text(t.delete),
          ),
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
        unawaited(_jumpTo(pinned[index].id));
        setState(() => _pinIndex = (index + 1) % pinned.length);
      },
      onUnpin: chat.type == models.ChatType.channel || !_cubit.canTogglePin(pinned[index]) ? null : () => _pin(chat, pinned[index]),
      onList: () => _openPinned(context),
    );
  }

  /// «Закреплённые сообщения» — оттуда тап по сообщению ведёт к нему в ленте.
  Future<void> _openPinned(BuildContext context) async {
    final id = await showPinnedMessagesMaterial(context, _cubit);
    if (id != null && mounted) await _jumpTo(id);
  }

  /// Закрепить можно отправленное (не ⏱ / «!») и не звонок.
  bool _pinnable(models.Message message) =>
      message.kind != models.MessageKind.call &&
      message.status != models.MessageStatus.pending &&
      message.status != models.MessageStatus.failed;

  /// К сообщению [id]: старое, за окном ленты, — сначала подгрузить до него.
  Future<void> _jumpTo(String id) async {
    await _cubit.reveal(id);
    if (mounted) await _tracker.jumpTo(id);
  }

  /// Кнопка ❤️ — к самому старому нашему сообщению с непрочитанными реакциями.
  Future<void> _nextReaction() async {
    final id = await _cubit.nextUnreadReaction();
    if (id != null && mounted) await _tracker.jumpTo(id);
  }

  /// Кнопка «@» — к самому старому непрочитанному упоминанию нас.
  Future<void> _nextMention() async {
    final id = await _cubit.nextUnreadMention();
    if (id != null && mounted) await _tracker.jumpTo(id);
  }

  /// «Кто за что» — сервер отдаёт по запросу (без сети — «Нет соединения»).
  Future<void> _pollVoters(models.Message message) async {
    final poll = await _cubit.pollVoters(message);
    if (poll != null && mounted) await showPollVoters(context, poll);
  }

  /// «Закрепить» / «Открепить»: в личном чате — у меня и у собеседника или
  /// только у меня (см. [askPinScopeMaterial]).
  Future<void> _pin(models.Chat chat, models.Message message) async {
    final pinned = !message.pinned;
    final forEveryone = await askPinScopeMaterial(
      context,
      chat,
      pin: pinned,
      shared: !message.pinnedOnlyMe,
      canForAll: _cubit.canPinForEveryone,
    );
    if (forEveryone != null) await _cubit.setPinned(message, pinned, forEveryone: forEveryone);
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

  void _maybeLoadOlder() {
    if (_scroll.hasClients && _scroll.position.extentAfter < 800) _cubit.loadOlder();
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
    final date = await showScheduleDateMaterial(context);
    if (!mounted) return;
    if (date != null) {
      _send(scheduleDate: date);
    } else if (hadFocus) {
      _focus.requestFocus();
    }
  }

  /// Удержание «Отправить» (как в Telegram): без звука / позже. Позже — только
  /// текст, без пересылаемых.
  Future<void> _sendOptions(BuildContext context) async {
    final t = context.t.screenChat;
    final canSchedule = _input.text.trim().isNotEmpty && _cubit.state.forwarding.isEmpty && _cubit.features.scheduled;
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
    // Защита содержимого — экран не попадает на скриншоты и запись.
    return BlocSelector<ChatCubit, ChatState, bool>(
      selector: (state) => state.chat?.noForwards ?? false,
      builder: (context, noForwards) => ChatScreenProtector(enabled: noForwards, child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    final t = context.t;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final barColor = dark ? ThemesCupertino.groupedCard.darkColor : ThemesCupertino.groupedCard.color;
    return ChatsOfflineListener<ChatCubit, ChatState>(
      notice: (state) => state.offlineNotice,
      child: ChatsGroupNoticeListener<ChatCubit, ChatState>(
        restricted: (state) => state.restrictedNotice,
        count: (state) => state.restrictedCount,
        failed: (state) => state.failNotice,
        error: (state) => state.failError,
        child: BlocListener<ChatCubit, ChatState>(
          // Новые сообщения / разделитель непрочитанных — в навигацию по ленте.
          listenWhen: (previous, current) => previous.messages != current.messages || previous.unreadFromID != current.unreadFromID,
          listener: (context, state) => _tracker.update(state.messages, state.unreadFromID),
          child: BlocConsumer<ChatCubit, ChatState>(
            listenWhen: (previous, current) =>
                previous.editing != current.editing ||
                previous.chat?.draft != current.chat?.draft ||
                previous.searchCurrentID != current.searchCurrentID,
            listener: (context, state) {
              if (state.editing == null) _editingID = null;
              // Поиск: к текущему найденному.
              final found = state.searchCurrentID;
              if (found != null) scrollToMessage(_scroll, _keyFor(found));
              // Черновик из списка / с другого устройства — в поле, если его не трогали.
              _applyDraft(state.chat?.draft ?? '');
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
                ..enabled =
                    chat != null &&
                    (chat.type == models.ChatType.group || chat.type == models.ChatType.community) &&
                    // Упоминания в группах на сервере — подэтап 3.4.
                    _cubit.features.groupExtras
                ..members = state.members;
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
                  // «Чат не найден» — на тех же обоях (иначе в тёмной теме чёрный фон).
                  body: chat == null
                      ? Stack(
                          children: [
                            Positioned.fill(
                              child: BlocBuilder<CommonCubit, CommonState>(
                                builder: (context, common) => ChatWallpaper(
                                  pattern: common.settingsDevice.chatWallpaper,
                                  colorIndex: common.settingsDevice.chatWallpaperColor,
                                  intensity: common.settingsDevice.chatWallpaperIntensity,
                                  dark: Theme.of(context).brightness == Brightness.dark,
                                ),
                              ),
                            ),
                            Center(child: Text(state.status == Status.success ? t.screenChat.notFound : '')),
                          ],
                        )
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
                                          onCommentsTap: chat.type == models.ChatType.channel && chat.commentsEnabled
                                              ? _openComments
                                              : null,
                                          commentsClosedIDs: state.commentsClosedIDs,
                                          // Опрос: голосовать — участникам (не подписавшимся — нет).
                                          onPollVote: chat.isMember ? (message, options) => _cubit.votePoll(message, options) : null,
                                          onPollVoters: _pollVoters,
                                          // Звонок в ленте — перезвонить тем же видом.
                                          onCallTap: chat.type == models.ChatType.private && !chat.isSelf
                                              ? (message) => chatInfoCall(chat, video: message.phoneCall?.video ?? false)
                                              : null,
                                          style: ChatMaterial.bubbleStyle(context),
                                          padding: EdgeInsets.only(
                                            top: 8 + (state.pinnedMessages.isEmpty ? 0 : PinnedMessageBar.height),
                                            bottom: 8,
                                          ),
                                          onLongPress: (message) => _actions(context, chat, message),
                                          controller: _scroll,
                                          keyFor: _keyFor,
                                          onCancelUpload: _cubit.cancelUpload,
                                          onReaction: _cubit.features.reactions ? _cubit.toggleReaction : null,
                                          onDoubleTap: _cubit.features.reactions
                                              ? (message) => _cubit.quickReact(
                                                  message,
                                                  preferred: context.read<CommonCubit>().state.settingsDevice.quickReaction,
                                                )
                                              : null,
                                          onReplyTap: _tracker.jumpToReply,
                                          onForwardTap: (message) => openForwardAuthor(context, message),
                                          onPinnedServiceTap: _jumpTo,
                                          onReactionsShown: _cubit.unreadShown,
                                          pinned: state.pinnedMessages,
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
                                          vanishingIDs: state.vanishingIDs,
                                          onSelect: _cubit.toggleSelected,
                                          selectionColor: Theme.of(context).colorScheme.primary,
                                          selectionCheckColor: Theme.of(context).colorScheme.onPrimary,
                                          highlight: state.searching ? state.searchQuery : '',
                                          focusedID: state.searchCurrentID,
                                          // Защита содержимого: файл не открыть в другом приложении,
                                          // в просмотре — без сохранения.
                                          onMediaTap: (message, index) => message.kind == models.MessageKind.file
                                              ? (chat.noForwards ? showChatNoForwardsRestricted(context) : openChatFile(context, message))
                                              : showChatMediaViewer(
                                                  context,
                                                  messages: state.messages,
                                                  message: message,
                                                  index: index,
                                                  chatTitle: chat.title,
                                                  noForwards: chat.noForwards,
                                                ),
                                          onNoForwardsAnswer: (request, accept) =>
                                              setChatNoForwards(context, _cubit, !accept, requestID: request.id),
                                        ),
                                  Positioned(top: 0, left: 0, right: 0, child: _pinnedBar(context, chat, state)),
                                  ChatReactionsButton(
                                    tracker: _tracker,
                                    count: chat.unreadReactions,
                                    onTap: _nextReaction,
                                    background: barColor,
                                    iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                    badgeColor: Theme.of(context).colorScheme.primary,
                                    badgeTextColor: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  // «@» — над ❤️ (как в Telegram).
                                  ChatReactionsButton(
                                    tracker: _tracker,
                                    icon: FontAwesomeIcons.at,
                                    above: chat.unreadReactions > 0 ? 1 : 0,
                                    count: chat.unreadMentions,
                                    onTap: _nextMention,
                                    background: barColor,
                                    iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                    badgeColor: Theme.of(context).colorScheme.primary,
                                    badgeTextColor: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: ChatScrollDownButton(
                                      tracker: _tracker,
                                      background: barColor,
                                      iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                      badgeColor: Theme.of(context).colorScheme.primary,
                                      badgeTextColor: Theme.of(context).colorScheme.onPrimary,
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
                            // Комментарии закрыты / только подписчикам / мало подписаны.
                            else if (state.commentsBlocked)
                              _CommentsBlockedBar(state: state, color: barColor)
                            else ...[
                              // Подсказка «@» — над полем ввода.
                              MentionSuggestions(
                                mentions: _mentions,
                                background: barColor,
                                text: Theme.of(context).colorScheme.onSurface,
                                secondary: Theme.of(context).colorScheme.onSurfaceVariant,
                                separator: Theme.of(context).colorScheme.outlineVariant,
                              ),
                              // Ctrl+B / I / U / K — форматирование с клавиатуры.
                              _formatMenu.shortcuts(
                                context,
                                child: _ComposeBar(
                                  input: _input,
                                  formatMenu: _formatMenu,
                                  recorder: _recorder,
                                  focus: _focus,
                                  emoji: _emoji,
                                  state: state,
                                  onSend: _send,
                                  onSendOptions: () => _sendOptions(context),
                                  onScheduled: () => showScheduledMessagesMaterial(context, _cubit),
                                  color: barColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _actions(BuildContext context, models.Chat chat, models.Message message) async {
    HapticFeedback.mediumImpact();
    final t = context.t.screenChat;
    final canWrite = chat.canPost && !_cubit.state.commentsBlocked;
    final commentsClosed = _cubit.state.commentsClosedIDs.contains(message.id);
    final error = Theme.of(context).colorScheme.error;
    final features = _cubit.features;
    final reactions = features.reactions ? availableReactions(chat, message: message) : const <String>[];
    // Сверху — текст сообщения, его можно выделить: «Копировать | Цитировать»
    // (ответ на фрагмент, как в Telegram).
    // Защита содержимого — ни выделения текста, ни копирования, сохранения и пересылки.
    final protected = chat.noForwards;
    final quotable = canWrite && message.text.isNotEmpty && message.kind != models.MessageKind.poll && !protected;
    final mediaCopyable = chatMediaActionable(message) && message.kind != models.MessageKind.file && !protected;
    final quoteText = GlobalKey<QuotableTextState>();
    models.MessageQuote? quote;
    var readers = const <MessageReader>[];
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (quotable) ...[
                _QuotePreview(
                  quoteKey: quoteText,
                  message: message,
                  onQuote: (picked) {
                    quote = picked;
                    Navigator.of(sheetContext).pop('quote');
                  },
                ),
                const SizedBox(height: 8),
              ],
              // Полоса реакций (если в чате они разрешены).
              if (reactions.isNotEmpty) ...[
                ReactionPicker(
                  emojis: reactions,
                  selected: message.myReactions,
                  selectedBackground: Theme.of(sheetContext).colorScheme.secondaryContainer,
                  onSelected: (emoji) => Navigator.of(sheetContext).pop('react:$emoji'),
                ),
                const Divider(),
              ],
              // Кто / когда прочитал (как в Telegram): в группе — тап открывает список.
              if (readReceiptsApply(chat, message))
                MessageReadInfoBuilder(
                  load: () => _cubit.readInfo(message),
                  builder: (context, info) => ListTile(
                    leading: Icon(chat.type == models.ChatType.private ? Icons.done_all : Icons.visibility_outlined),
                    title: Text(readInfoLabel(context.t, chat, info)),
                    onTap: info != null && info.readers.isNotEmpty
                        ? () {
                            readers = info.readers;
                            Navigator.of(sheetContext).pop('readers');
                          }
                        : null,
                  ),
                ),
              if (message.status == models.MessageStatus.failed)
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: Text(t.retrySend),
                  onTap: () => Navigator.of(sheetContext).pop('retry'),
                ),
              if (canWrite)
                ListTile(leading: const Icon(Icons.reply), title: Text(t.reply), onTap: () => Navigator.of(sheetContext).pop('reply')),
              if (quotable)
                ListTile(leading: const Icon(Icons.format_quote), title: Text(t.quote), onTap: () => quoteText.currentState?.selectAll()),
              // Фото / видео — копируются сами (вставить в другой мессенджер), подпись — отдельно.
              if (mediaCopyable || (message.text.isNotEmpty && !protected))
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: Text(t.copy),
                  onTap: () => Navigator.of(sheetContext).pop(mediaCopyable ? 'copyMedia' : 'copy'),
                ),
              if (mediaCopyable && message.text.isNotEmpty)
                ListTile(leading: const Icon(Icons.notes), title: Text(t.copyText), onTap: () => Navigator.of(sheetContext).pop('copy')),
              if (chatMediaActionable(message) && !protected) ...[
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: Text(chatMediaSaveLabel(context.t, message)),
                  onTap: () => Navigator.of(sheetContext).pop('saveMedia'),
                ),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: Text(t.shareMedia),
                  onTap: () => Navigator.of(sheetContext).pop('shareMedia'),
                ),
              ],
              if (canWrite && features.pinnedMessages && _pinnable(message) && _cubit.canTogglePin(message))
                ListTile(
                  leading: Icon(message.pinned ? Icons.push_pin : Icons.push_pin_outlined),
                  title: Text(message.pinned ? t.unpin : t.pin),
                  onTap: () => Navigator.of(sheetContext).pop('pin'),
                ),
              if (features.forward && _cubit.canForward(message) && !protected)
                ListTile(
                  leading: const Icon(Icons.forward),
                  title: Text(t.forward),
                  onTap: () => Navigator.of(sheetContext).pop('forward'),
                ),
              // Пересланное не правится (как в Telegram).
              if (message.outgoing && message.kind == models.MessageKind.text && message.forward == null)
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(t.edit),
                  onTap: () => Navigator.of(sheetContext).pop('edit'),
                ),
              // В группе чужие — с правом удалять сообщения (у всех).
              if (_cubit.canDelete(message))
                ListTile(
                  leading: Icon(Icons.delete_outline, color: error),
                  title: Text(t.delete, style: TextStyle(color: error)),
                  onTap: () => Navigator.of(sheetContext).pop('delete'),
                ),
              if (canRetractVote(message))
                ListTile(
                  leading: const Icon(Icons.undo),
                  title: Text(t.retractVote),
                  onTap: () => Navigator.of(sheetContext).pop('retract'),
                ),
              if (canClosePoll(chat, message, members: _cubit.state.members))
                ListTile(
                  leading: Icon(Icons.stop_circle_outlined, color: error),
                  title: Text(t.closePoll, style: TextStyle(color: error)),
                  onTap: () => Navigator.of(sheetContext).pop('closePoll'),
                ),
              if (canToggleComments(chat, message))
                commentsClosed
                    ? ListTile(
                        leading: const Icon(Icons.mode_comment_outlined),
                        title: Text(t.openComments),
                        onTap: () => Navigator.of(sheetContext).pop('openComments'),
                      )
                    : ListTile(
                        leading: Icon(Icons.comments_disabled_outlined, color: error),
                        title: Text(t.closeComments, style: TextStyle(color: error)),
                        onTap: () => Navigator.of(sheetContext).pop('closeComments'),
                      ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(t.select),
                onTap: () => Navigator.of(sheetContext).pop('select'),
              ),
            ],
          ),
        ),
      ),
    );
    if (!context.mounted) return;
    if (action != null && action.startsWith('react:')) {
      await _cubit.toggleReaction(message, action.substring('react:'.length));
      return;
    }
    switch (action) {
      case 'retry':
        await _cubit.retrySend(message);
      case 'reply':
        _cubit.startReply(message);
        _focus.requestFocus();
      case 'quote':
        _cubit.startReply(message, quote: quote);
        _focus.requestFocus();
      case 'copy':
        await Clipboard.setData(ClipboardData(text: message.text));
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.copied)));
      case 'copyMedia':
        await copyChatMedia(context, message);
      case 'saveMedia':
        await saveChatMedia(context, message);
      case 'shareMedia':
        await shareChatMedia(context, message);
      case 'edit':
        _cubit.startEdit(message);
      case 'pin':
        await _pin(chat, message);
      case 'forward':
        _cubit.startSelection(message);
        await _forward(context, single: true);
      case 'retract':
        await _cubit.votePoll(message, const []);
      case 'closePoll':
        if (await confirmClosePoll(context)) await _cubit.closePoll(message);
      case 'closeComments':
        if (await confirmCloseComments(context)) await _cubit.setCommentsClosed(message, true);
      case 'openComments':
        await _cubit.setCommentsClosed(message, false);
      case 'readers':
        await showMessageReaders(context, readers);
      case 'select':
        _cubit.startSelection(message);
      case 'delete':
        final forEveryone = await _askDelete(context, chat, 1);
        if (forEveryone != null && context.mounted) {
          await deleteWithDust(context, _cubit, [message.id], _keyFor, () => _cubit.delete(message, forEveryone: forEveryone));
        }
    }
  }
}

/// Текст сообщения вверху шторки действий — пузырём, как в ленте; можно
/// выделить фрагмент и «Цитировать». Длинный — прокручивается.
class _QuotePreview extends StatelessWidget {
  final GlobalKey<QuotableTextState> quoteKey;
  final models.Message message;
  final ValueChanged<models.MessageQuote> onQuote;

  const _QuotePreview({required this.quoteKey, required this.message, required this.onQuote});

  @override
  Widget build(BuildContext context) {
    final style = ChatMaterial.bubbleStyle(context);
    final out = message.outgoing;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: out ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.3),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: out ? style.outgoing : style.incoming,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: QuotableText(
                key: quoteKey,
                text: message.text,
                entities: message.entities,
                selectionControls: materialTextSelectionHandleControls,
                toolbarBuilder: (context, anchors, items) => AdaptiveTextSelectionToolbar.buttonItems(anchors: anchors, buttonItems: items),
                onQuote: onQuote,
                child: MessageText(
                  text: message.text,
                  entities: message.entities,
                  style: style.textStyle,
                  colors: out ? style.outgoingText : style.incomingText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
        // Автоудаление — значок таймера на аватаре (как в Telegram).
        ChatAvatar(chat: chat, size: 40, accentColor: scheme.primary, accentForeground: scheme.onPrimary, ttlBadgeColor: scheme.outline),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ChatTileContent.title(t, chat), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18)),
              if (subtitle.text.isNotEmpty)
                // «печатает…» — с бегущими точками.
                chat.typing.isNotEmpty
                    ? TypingText(subtitle.text, style: TextStyle(fontSize: 13, color: scheme.primary))
                    : Text(
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

  /// Панель эмодзи вместо клавиатуры.
  final EmojiPanelController emoji;
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
    required this.emoji,
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
      // Панель эмодзи открыта — она сама доходит до низа экрана.
      child: ListenableBuilder(
        listenable: emoji,
        builder: (context, child) => SafeArea(top: false, bottom: emoji.reserved == 0, child: child!),
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
                          : banner.quote
                          ? Icons.format_quote
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
                          composeBannerText(banner, const TextStyle(), scheme.onSurfaceVariant, scheme.primary),
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
                              // Картинка / видео с клавиатуры (буфер Gboard, GIF).
                              contentInsertionConfiguration: ContentInsertionConfiguration(
                                allowedMimeTypes: chatInsertMimeTypes,
                                onContentInserted: (content) => insertKeyboardMedia(context, content, input: input),
                              ),
                              minLines: 1,
                              maxLines: 6,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: t.screenChat.message,
                                // Эмодзи ↔ клавиатура (как в Telegram).
                                prefixIcon: ListenableBuilder(
                                  listenable: emoji,
                                  builder: (context, _) => IconButton(
                                    icon: Icon(emoji.open ? Icons.keyboard_outlined : Icons.emoji_emotions_outlined),
                                    color: scheme.onSurfaceVariant,
                                    tooltip: emoji.open ? t.screenChat.keyboard : t.screenChat.emoji,
                                    onPressed: emoji.toggle,
                                  ),
                                ),
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
                            child: (state.slowModeLeft > 0 || state.floodLeft > 0) && !editing
                                ? SlowModeCountdown(
                                    key: const ValueKey('slow'),
                                    seconds: math.max(state.slowModeLeft, state.floodLeft),
                                    color: scheme.onSurfaceVariant,
                                  )
                                : !canSend && !editing
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
            EmojiPanel(
              controller: emoji,
              input: input,
              style: EmojiPanelStyle(
                background: scheme.surfaceContainerLow,
                icon: scheme.onSurfaceVariant,
                accent: scheme.primary,
                text: scheme.onSurface,
                cupertino: false,
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

/// Писать нельзя — вместо поля ввода: «Комментарии закрыты» (срок вышел /
/// админ закрыл), «Подписаться, чтобы комментировать» (канал «только
/// подписчики»), «Комментировать можно с …» (подписаны меньше «Подписки не
/// менее») или в личном чате «… ограничивает, кто может писать».
class _CommentsBlockedBar extends StatelessWidget {
  final ChatState state;
  final Color color;

  const _CommentsBlockedBar({required this.state, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    Widget note(IconData icon, String text) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: secondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: secondary),
          ),
        ),
      ],
    );
    return Material(
      color: color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: switch (state.commentsBlock) {
            ChatCommentsBlock.subscribe => TextButton(
              onPressed: context.read<ChatCubit>().subscribeToChannel,
              child: Text(t.screenChat.commentsSubscribe),
            ),
            ChatCommentsBlock.wait when state.commentsWaitUntil != null => note(
              Icons.schedule,
              commentsWaitLabel(t, state.commentsWaitUntil!),
            ),
            // Собеседник у меня в «Заблокированных» — писать нельзя, пока не разблокирую.
            ChatCommentsBlock.blocked => TextButton(onPressed: context.read<ChatCubit>().unblockPeer, child: Text(t.screenChat.unblock)),
            ChatCommentsBlock.privacy => note(Icons.lock_outline, t.screenChat.privacyRestricted),
            // Группа, роль «Чтение».
            ChatCommentsBlock.readOnly => note(Icons.visibility_outlined, t.screenChat.readOnly),
            _ => note(Icons.lock_outline, t.screenChat.commentsClosed),
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
  final Color color;

  const _SearchBar({required this.state, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    final cubit = context.read<ChatCubit>();
    final total = state.searchResults.length;
    final label = total > 0
        ? t.mediaCounter(current: state.searchIndex + 1, total: total)
        : (state.searchQuery.trim().isEmpty ? '' : (state.searchLoading ? t.searchLoading : t.searchNoResults));
    final theme = Theme.of(context);
    return Material(
      color: color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(label, style: theme.textTheme.bodyMedium)),
                        // Сервер ещё ищет (или лента дотягивается до найденного).
                        if (state.searchLoading && total > 0) ...[
                          const SizedBox(width: 8),
                          const SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                        ],
                      ],
                    ),
                    // Без сети — нашли только то, что есть на устройстве.
                    if (state.searchOffline)
                      Text(
                        t.searchOffline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_up),
                // На последнем найденном — «ещё раньше» с сервера.
                onPressed: state.searchIndex + 1 < total || state.searchHasMore ? cubit.searchOlder : null,
              ),
              IconButton(icon: const Icon(Icons.keyboard_arrow_down), onPressed: state.searchIndex > 0 ? cubit.searchNewer : null),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
