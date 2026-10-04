import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../chats/message_formatting.dart';
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
  late final ChatCubit _cubit;
  bool _draftLoaded = false;

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
    super.dispose();
  }

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
      listenWhen: (previous, current) => previous.editing != current.editing || previous.chat == null && current.chat != null,
      listener: (context, state) {
        // Черновик из списка — один раз при открытии.
        if (!_draftLoaded && state.chat != null) {
          _draftLoaded = true;
          if (_input.text.isEmpty && state.chat!.draft.isNotEmpty) _input.text = state.chat!.draft;
        }
        final editing = state.editing;
        if (editing != null) {
          _input.text = toMarkdownShortcuts(editing.text, editing.entities);
          _focus.requestFocus();
        }
      },
      builder: (context, state) {
        final chat = state.chat;
        final background = CupertinoTheme.brightnessOf(context) == Brightness.dark
            ? const Color(0xFF000000)
            : CupertinoColors.systemGroupedBackground.resolveFrom(context);
        return CupertinoPageScaffold(
          backgroundColor: background,
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: '',
            backgroundColor: ThemesCupertino.appBackground.resolveFrom(context).withValues(alpha: 0.92),
            middle: chat == null ? null : _Header(chat: chat),
            trailing: chat == null ? null : ChatAvatar(chat: chat, size: 36, accentColor: CupertinoTheme.of(context).primaryColor),
          ),
          child: SafeArea(
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
                                  dark: CupertinoTheme.brightnessOf(context) == Brightness.dark,
                                ),
                              ),
                            ),
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
                                    onLongPress: (message) => _actions(context, chat, message),
                                  ),
                          ],
                        ),
                      ),
                      if (chat.type == models.ChatType.channel)
                        _ChannelBar(chat: chat)
                      else
                        _ComposeBar(input: _input, focus: _focus, state: state, onSend: _send),
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
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          if (canWrite) CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop('reply'), child: Text(t.reply)),
          if (message.text.isNotEmpty)
            CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop('copy'), child: Text(t.copy)),
          if (message.outgoing && message.kind == models.MessageKind.text)
            CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop('edit'), child: Text(t.edit)),
          if (message.outgoing || chat.type == models.ChatType.private)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(sheetContext).pop('delete'),
              child: Text(t.delete),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(context.t.common.cancel)),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'reply':
        _cubit.startReply(message);
        _focus.requestFocus();
      case 'copy':
        await Clipboard.setData(ClipboardData(text: message.text));
      case 'edit':
        _cubit.startEdit(message);
      case 'delete':
        final confirmed = await showCupertinoDialog<bool>(
          context: context,
          builder: (dialogContext) => CupertinoAlertDialog(
            title: Text(t.deleteTitle),
            content: Text(t.deleteMessage),
            actions: [
              CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(t.delete),
              ),
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
                    onPressed: editing ? null : () => pickAndSendAttachments(context),
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
