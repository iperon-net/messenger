import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../chats/message_formatting.dart';
import '../../chats/reactions.dart';
import '../../constants.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../themes.dart';
import 'chat_common.dart';

/// Окно чата (iOS): шапка с аватаром и «печатает…», лента пузырей, поле ввода
/// с markdown-ярлыками и скрепкой; в канале вместо поля — «Выключить звук».
/// Действия над сообщением — по long-press. Пока только UX-демо, см.
/// docs/plans/chats-groups-channels.md, «Этап 0».
class ChatCupertino extends StatefulWidget {
  const ChatCupertino({super.key});

  /// Оформление пузырей — и для окна чата, и для превью «Тем для чатов».
  static MessageBubbleStyle bubbleStyle(BuildContext context) {
    final primary = CupertinoDynamicColor.resolve(CupertinoTheme.of(context).primaryColor, context);
    final dark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final label = CupertinoColors.label.resolveFrom(context);
    return MessageBubbleStyle(
      incoming: dark ? const Color(0xFF262628) : const Color(0xFFFFFFFF),
      outgoing: primary,
      incomingText: MessageTextColors(
        text: label,
        link: primary,
        codeBackground: CupertinoColors.systemGrey5.resolveFrom(context),
        spoiler: CupertinoColors.systemGrey3.resolveFrom(context),
        quote: CupertinoColors.secondaryLabel.resolveFrom(context),
      ),
      outgoingText: const MessageTextColors(
        text: Color(0xFFFFFFFF),
        link: Color(0xFFFFFFFF),
        codeBackground: Color(0x33FFFFFF),
        spoiler: Color(0x66FFFFFF),
        quote: Color(0xE6FFFFFF),
      ),
      incomingMeta: CupertinoColors.secondaryLabel.resolveFrom(context),
      outgoingMeta: const Color(0xCCFFFFFF),
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
        final background = CupertinoTheme.brightnessOf(context) == Brightness.dark
            ? const Color(0xFF000000)
            : CupertinoColors.systemGroupedBackground.resolveFrom(context);
        final barColor = ThemesCupertino.appBackground.resolveFrom(context).withValues(alpha: 0.92);
        return PopScope(
          // «Назад» в режиме поиска закрывает поиск, а не чат.
          canPop: !state.searching,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _cubit.closeSearch();
          },
          child: CupertinoPageScaffold(
            backgroundColor: background,
            navigationBar: state.searching
                ? CupertinoNavigationBar(
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
                      child: Text(t.common.cancel),
                    ),
                  )
                : CupertinoNavigationBar(
                    previousPageTitle: '',
                    // Фон панели всегда (без автоскрытия у края ленты): иначе у верха
                    // истории панель становилась прозрачной и под ней была чёрная полоса.
                    automaticBackgroundVisibility: false,
                    backgroundColor: barColor,
                    middle: chat == null
                        ? null
                        : GestureDetector(
                            onLongPress: _startSearch,
                            child: _Header(chat: chat),
                          ),
                    trailing: chat == null
                        ? null
                        : GestureDetector(
                            onLongPress: _startSearch,
                            child: ChatAvatar(chat: chat, size: 36, accentColor: CupertinoTheme.of(context).primaryColor),
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
                                          style: ChatCupertino.bubbleStyle(context),
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          // Удержание — CupertinoContextMenu (menuWrapper), не action sheet.
                                          onLongPress: (_) {},
                                          menuWrapper: (message, bubble, preview) => _menu(context, chat, message, bubble, preview),
                                          controller: _scroll,
                                          keyFor: _keyFor,
                                          onCancelUpload: _cubit.cancelUpload,
                                          onReaction: _cubit.toggleReaction,
                                          onDoubleTap: _cubit.quickReact,
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
                              _SearchBar(state: state)
                            else if (chat.type == models.ChatType.channel)
                              _ChannelBar(chat: chat)
                            else
                              _ComposeBar(input: _input, focus: _focus, state: state, onSend: _send),
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

  /// Пузырь в нативном контекстном меню iOS (удержание): пузырь
  /// «приподнимается», фон размывается, под ним — полоса реакций и действия.
  Widget _menu(BuildContext context, models.Chat chat, models.Message message, Widget bubble, Widget Function(double) preview) {
    return _MessageContextMenu(actions: _menuActions(context, chat, message), bubble: bubble, preview: preview);
  }

  List<Widget> _menuActions(BuildContext context, models.Chat chat, models.Message message) {
    final t = context.t.screenChat;
    final canWrite = chat.type != models.ChatType.channel;
    final reactions = availableReactions(chat);

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
      if (message.outgoing && message.kind == models.MessageKind.text)
        action(t.edit, CupertinoIcons.pencil, () => _cubit.startEdit(message)),
      if (message.outgoing || chat.type == models.ChatType.private)
        action(t.delete, CupertinoIcons.delete, () => _confirmDelete(context, message), destructive: true),
    ];
  }

  Future<void> _confirmDelete(BuildContext context, models.Message message) async {
    final t = context.t.screenChat;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(t.deleteTitle),
        content: Text(t.deleteMessage),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
          CupertinoDialogAction(isDestructiveAction: true, onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(t.delete)),
        ],
      ),
    );
    if (confirmed ?? false) await _cubit.delete(message);
  }
}

/// Пузырь сообщения с `CupertinoContextMenu`. Превью открытого меню —
/// тот же пузырь той же ширины, что в ленте (ширину запоминаем при раскладке),
/// ужатый под выданный меню прямоугольник.
class _MessageContextMenu extends StatefulWidget {
  final List<Widget> actions;
  final Widget bubble;
  final Widget Function(double maxWidth) preview;

  const _MessageContextMenu({required this.actions, required this.bubble, required this.preview});

  @override
  State<_MessageContextMenu> createState() => _MessageContextMenuState();
}

class _MessageContextMenuState extends State<_MessageContextMenu> {
  double? _width;

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu.builder(
      enableHapticFeedback: true,
      actions: widget.actions,
      builder: (context, animation) {
        final width = _width;
        if (animation.value < CupertinoContextMenu.animationOpensAt || width == null) {
          return _SizeReporter(onSize: (size) => _width = size.width, child: widget.bubble);
        }
        return FittedBox(fit: BoxFit.scaleDown, child: widget.preview(width));
      },
    );
  }
}

/// Сообщает размер ребёнка после каждой раскладки (без GlobalKey: превью
/// меню строится одновременно в ленте и в оверлее).
class _SizeReporter extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onSize;

  const _SizeReporter({required this.onSize, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSizeReporter(onSize);

  @override
  void updateRenderObject(BuildContext context, _RenderSizeReporter renderObject) => renderObject.onSize = onSize;
}

class _RenderSizeReporter extends RenderProxyBox {
  ValueChanged<Size> onSize;

  _RenderSizeReporter(this.onSize);

  @override
  void performLayout() {
    super.performLayout();
    onSize(size);
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
  final FocusNode focus;
  final ChatState state;
  final VoidCallback onSend;

  const _ComposeBar({required this.input, required this.focus, required this.state, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final primary = CupertinoTheme.of(context).primaryColor;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final banner = composeBanner(t, state);
    final editing = state.editing != null;

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
            if (banner != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                child: Row(
                  children: [
                    FaIcon(editing ? FontAwesomeIcons.pen : FontAwesomeIcons.reply, size: 16, color: primary),
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
                          Text(
                            banner.text,
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                    minimumSize: Size.zero,
                    onPressed: editing ? null : () => pickAndSendAttachments(context, input: input),
                    child: FaIcon(FontAwesomeIcons.paperclip, size: 22, color: secondary),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      controller: input,
                      focusNode: focus,
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
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: input,
                    builder: (context, value, _) {
                      final canSend = value.text.trim().isNotEmpty;
                      return CupertinoButton(
                        padding: const EdgeInsets.only(left: 8, bottom: 2),
                        minimumSize: Size.zero,
                        onPressed: canSend ? onSend : null,
                        child: Icon(
                          editing ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.arrow_up_circle_fill,
                          size: 32,
                          color: canSend ? primary : CupertinoColors.systemGrey3.resolveFrom(context),
                        ),
                      );
                    },
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

  const _ChannelBar({required this.chat});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChat;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ThemesCupertino.appBackground.resolveFrom(context),
        border: Border(top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            onPressed: () => context.read<ChatCubit>().setMuted(!chat.muted),
            child: Text(chat.muted ? t.unmute : t.mute),
          ),
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
