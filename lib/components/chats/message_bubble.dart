import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../chats/voice_player.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'media_viewer.dart';
import 'message_text.dart';
import 'spoiler_dust.dart';
import 'swipe_to_reply.dart';

/// Платформенное оформление окна чата (см. `chat_cupertino.dart` /
/// `chat_material.dart`).
class MessageBubbleStyle {
  final Color incoming;
  final Color outgoing;
  final MessageTextColors incomingText;
  final MessageTextColors outgoingText;
  final Color incomingMeta;
  final Color outgoingMeta;

  /// Плашки дат и сервисных сообщений.
  final Color pill;
  final Color pillText;
  final TextStyle textStyle;

  const MessageBubbleStyle({
    required this.incoming,
    required this.outgoing,
    required this.incomingText,
    required this.outgoingText,
    required this.incomingMeta,
    required this.outgoingMeta,
    required this.pill,
    required this.pillText,
    required this.textStyle,
  });
}

/// Цвет имени автора в группе — стабильный по имени (как в Telegram).
Color senderColor(String name) {
  const palette = [
    Color(0xFFE17076),
    Color(0xFFF5A623),
    Color(0xFF7BC862),
    Color(0xFF6EC9CB),
    Color(0xFF65AADD),
    Color(0xFFA695E7),
    Color(0xFFEE7AAE),
  ];
  return palette[name.hashCode.abs() % palette.length];
}

/// Лента сообщений: снизу новые, разделители дней, подряд идущие сообщения
/// одного автора группируются (хвост — у последнего, имя — у первого, аватар
/// в группе — у последнего).
class ChatMessagesView extends StatelessWidget {
  final List<models.Message> messages;
  final models.ChatType chatType;
  final MessageBubbleStyle style;
  final ValueChanged<models.Message> onLongPress;

  /// Тап по фото/видео ([index] — элемент альбома).
  final void Function(models.Message message, int index)? onMediaTap;
  final EdgeInsets padding;
  final ScrollController? controller;

  /// Поиск по чату: подсветка вхождений [highlight], у [focusedID] (текущее
  /// найденное) — ярче.
  final String highlight;
  final String? focusedID;

  /// Ключ строки сообщения — чтобы прокрутить к нему (поиск).
  final GlobalKey Function(String messageID)? keyFor;

  /// Крестик на прогрессе загрузки вложений.
  final ValueChanged<models.Message>? onCancelUpload;

  /// Тап по реакции под сообщением; двойной тап по пузырю — быстрая реакция.
  final void Function(models.Message message, String emoji)? onReaction;
  final ValueChanged<models.Message>? onDoubleTap;

  /// Свайп сообщения влево — ответить; `null` — нельзя (канал, поиск).
  final ValueChanged<models.Message>? onReply;

  /// Тап по цитате ответа — перейти к исходному сообщению.
  final ValueChanged<models.Message>? onReplyTap;

  /// Над этим сообщением — разделитель «Непрочитанные сообщения» (ключ строки —
  /// `keyFor(unreadDividerID)`).
  final String? unreadFromID;

  /// Подсветка строки (переход по цитате) — гаснет плавно, когда `null`.
  final String? flashID;

  /// Режим выделения: отмеченные [selectedIDs], тап по строке — [onSelect].
  final bool selecting;
  final List<String> selectedIDs;
  final ValueChanged<models.Message>? onSelect;
  final Color selectionColor;

  /// Id строки-разделителя для [keyFor].
  static const unreadDividerID = '__unread__';

  /// Обёртка пузыря контекстным меню (см. [MessageBubble.menuWrapper]).
  final Widget Function(models.Message message, Widget bubble, Widget Function(double maxWidth) preview)? menuWrapper;

  const ChatMessagesView({
    super.key,
    required this.messages,
    required this.chatType,
    required this.style,
    required this.onLongPress,
    this.onMediaTap,
    this.padding = EdgeInsets.zero,
    this.controller,
    this.highlight = '',
    this.focusedID,
    this.keyFor,
    this.onCancelUpload,
    this.onReaction,
    this.onDoubleTap,
    this.onReply,
    this.onReplyTap,
    this.unreadFromID,
    this.flashID,
    this.selecting = false,
    this.selectedIDs = const [],
    this.onSelect,
    this.selectionColor = const Color(0xFF007AFF),
    this.menuWrapper,
  });

  static bool _sameDay(DateTime a, DateTime b) {
    final x = a.toLocal();
    final y = b.toLocal();
    return x.year == y.year && x.month == y.month && x.day == y.day;
  }

  static bool _grouped(models.Message a, models.Message b) =>
      !a.service &&
      !b.service &&
      a.outgoing == b.outgoing &&
      a.senderName == b.senderName &&
      _sameDay(a.date, b.date) &&
      b.date.difference(a.date).abs() < const Duration(minutes: 5);

  @override
  Widget build(BuildContext context) {
    final group = chatType == models.ChatType.group || chatType == models.ChatType.community;
    // Список перевёрнут (reverse): индекс 0 — самое новое внизу.
    final items = <Widget>[];
    for (var i = messages.length - 1; i >= 0; i--) {
      final m = messages[i];
      final older = i > 0 ? messages[i - 1] : null;
      final newer = i + 1 < messages.length ? messages[i + 1] : null;
      final groupedWithOlder = older != null && _grouped(older, m);
      final groupedWithNewer = newer != null && _grouped(m, newer);

      if (m.service) {
        items.add(_Pill(text: m.text, style: style));
      } else {
        items.add(
          Padding(
            key: keyFor?.call(m.id),
            padding: EdgeInsets.only(top: groupedWithOlder ? 2 : 8),
            // Режим выделения: тап по строке отмечает, слева — кружок, жесты
            // пузыря (меню, медиа, реакции) выключены. Дерево одно и то же в
            // обоих режимах — пузыри не пересоздаются.
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: selecting && onSelect != null ? () => onSelect!(m) : null,
              child: AnimatedContainer(
                duration: Duration(milliseconds: selecting ? 150 : 400),
                color: selecting && selectedIDs.contains(m.id)
                    ? selectionColor.withValues(alpha: 0.18)
                    : style.outgoing.withValues(alpha: m.id == flashID ? 0.25 : 0),
                child: Stack(
                  children: [
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      padding: EdgeInsets.only(left: selecting ? 38 : 0),
                      child: IgnorePointer(
                        ignoring: selecting,
                        child: SwipeToReply(
                          onReply: onReply == null ? null : () => onReply!(m),
                          background: style.pill,
                          iconColor: style.pillText,
                          child: MessageBubble(
                            key: ValueKey(m.id),
                            message: m,
                            style: style,
                            tail: !groupedWithNewer,
                            showSender: group && !m.outgoing && !groupedWithOlder,
                            avatar: group && !m.outgoing
                                ? (groupedWithNewer ? const SizedBox(width: 34) : _SenderAvatar(name: m.senderName))
                                : null,
                            onLongPress: () => onLongPress(m),
                            onMediaTap: onMediaTap == null ? null : (index) => onMediaTap!(m, index),
                            highlight: highlight,
                            focused: m.id == focusedID,
                            onCancelUpload: onCancelUpload == null ? null : () => onCancelUpload!(m),
                            onReaction: onReaction == null ? null : (emoji) => onReaction!(m, emoji),
                            onDoubleTap: onDoubleTap == null ? null : () => onDoubleTap!(m),
                            onReplyTap: onReplyTap == null ? null : () => onReplyTap!(m),
                            menuWrapper: menuWrapper == null ? null : (bubble, preview) => menuWrapper!(m, bubble, preview),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: selecting ? 1 : 0,
                          child: Center(
                            child: _SelectCheck(selected: selectedIDs.contains(m.id), color: selectionColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      if (m.id == unreadFromID) {
        items.add(_UnreadDivider(key: keyFor?.call(unreadDividerID), style: style));
      }
      if (older == null || !_sameDay(older.date, m.date)) {
        items.add(_Pill(text: m.date.chatDayFormat(context.t), style: style));
      }
    }

    return ListView.builder(
      controller: controller,
      reverse: true,
      padding: padding,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }
}

class _SenderAvatar extends StatelessWidget {
  final String name;

  const _SenderAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: SizedBox(
        width: 30,
        height: 30,
        child: BoringAvatar(name: name, type: BoringAvatarType.beam, shape: const CircleBorder()),
      ),
    );
  }
}

/// Плашка по центру: дата или сервисное сообщение.
/// Кружок выделения слева от сообщения: пустой с белой обводкой (виден на
/// обоях) или залитый с галочкой.
class _SelectCheck extends StatelessWidget {
  final bool selected;
  final Color color;

  const _SelectCheck({required this.selected, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? color : const Color(0x33000000),
        border: Border.all(color: const Color(0xFFFFFFFF), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 3)],
      ),
      child: selected ? const FaIcon(FontAwesomeIcons.check, size: 11, color: Color(0xFFFFFFFF)) : null,
    );
  }
}

/// «Непрочитанные сообщения» — полоса во всю ширину над первым непрочитанным.
class _UnreadDivider extends StatelessWidget {
  final MessageBubbleStyle style;

  const _UnreadDivider({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 4),
      color: style.pill,
      alignment: Alignment.center,
      child: Text(
        context.t.screenChat.unreadMessages,
        style: style.textStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: style.pillText),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final MessageBubbleStyle style;

  const _Pill({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(color: style.pill, borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: style.textStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: style.pillText),
            ),
          ),
        ),
      ),
    );
  }
}

/// Пузырь сообщения: имя автора (группа), цитата ответа, медиа/файл/голосовое,
/// текст с разметкой и время с галочками в правом нижнем углу.
class MessageBubble extends StatelessWidget {
  final models.Message message;
  final MessageBubbleStyle style;

  /// Последнее в группе подряд идущих — острый угол у края.
  final bool tail;
  final bool showSender;

  /// Колонка аватара слева (входящие в группе); `null` — без неё.
  final Widget? avatar;
  final VoidCallback onLongPress;

  /// Тап по фото/видео ([index] — элемент альбома).
  final ValueChanged<int>? onMediaTap;

  /// Поиск по чату: подсвечиваемая строка; [focused] — текущее найденное.
  final String highlight;
  final bool focused;

  /// Крестик на прогрессе загрузки вложений.
  final VoidCallback? onCancelUpload;

  /// Тап по реакции под сообщением (поставить/снять свою).
  final ValueChanged<String>? onReaction;

  /// Двойной тап по пузырю — быстрая реакция.
  final VoidCallback? onDoubleTap;

  /// Тап по цитате ответа.
  final VoidCallback? onReplyTap;

  /// Обёртка пузыря контекстным меню (iOS — `CupertinoContextMenu`): [bubble] —
  /// пузырь в ленте, [preview] — он же для превью меню, без жестов, с заданной
  /// предельной шириной. С обёрткой [onLongPress] не используется.
  final Widget Function(Widget bubble, Widget Function(double maxWidth) preview)? menuWrapper;

  const MessageBubble({
    super.key,
    required this.message,
    required this.style,
    required this.tail,
    required this.showSender,
    required this.onLongPress,
    this.onMediaTap,
    this.avatar,
    this.highlight = '',
    this.focused = false,
    this.onCancelUpload,
    this.onReaction,
    this.onDoubleTap,
    this.onReplyTap,
    this.menuWrapper,
  });

  static const _radius = Radius.circular(18);
  static const _tailRadius = Radius.circular(5);

  /// Поверх фото/альбома, пока грузится: кольцо прогресса с крестиком по
  /// центру и «1,2 из 3,4 МБ» в углу (как в Telegram).
  Widget _uploadOverlay(BuildContext context, models.Message m, Widget media) {
    if (!m.isUploading) return media;
    return Stack(
      children: [
        media,
        Positioned.fill(
          child: Center(
            child: UploadProgressRing(
              progress: m.uploadProgress,
              size: 48,
              color: const Color(0xFFFFFFFF),
              background: const Color(0x80000000),
              onCancel: onCancelUpload,
            ),
          ),
        ),
        Positioned(
          left: 8,
          top: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(color: const Color(0x80000000), borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              child: Text(uploadProgressText(context, m), style: style.textStyle.copyWith(fontSize: 12, color: const Color(0xFFFFFFFF))),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final m = message;
    final out = m.outgoing;
    final colors = out ? style.outgoingText : style.incomingText;
    final metaColor = out ? style.outgoingMeta : style.incomingMeta;
    // Значок в кружке цвета ссылки (файл, голосовое). У исходящих на iOS ссылка
    // белая — белый значок пропал бы, поэтому он цвета пузыря.
    final iconColor = out ? style.outgoing : const Color(0xFFFFFFFF);
    final metaStyle = style.textStyle.copyWith(fontSize: 12, color: metaColor);
    final time = DateFormat.Hm().format(m.date.toLocal());
    final metaText = '${m.edited ? '${t.screenChat.edited} ' : ''}$time';

    final meta = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(metaText, style: metaStyle),
        if (out) ...[
          const SizedBox(width: 3),
          FaIcon(
            switch (m.status) {
              models.MessageStatus.pending => FontAwesomeIcons.clock,
              models.MessageStatus.sent => FontAwesomeIcons.check,
              models.MessageStatus.read => FontAwesomeIcons.checkDouble,
            },
            size: 11,
            color: metaColor,
          ),
        ],
      ],
    );
    // Невидимый хвост под время: nbsp, чтобы не переносился отдельно.
    final trailing = '  $metaText${out ? '     ' : ''}';

    // Пока вложения грузятся — тап по медиа не открывает просмотр.
    final mediaTap = m.isUploading ? null : onMediaTap;
    final Widget? media = switch (m.kind) {
      _ when m.isAlbum => _uploadOverlay(context, m, _AlbumGrid(message: m, onTap: mediaTap)),
      models.MessageKind.photo || models.MessageKind.video => _uploadOverlay(context, m, _MediaPreview(message: m, onTap: mediaTap)),
      models.MessageKind.file => _FileRow(
        message: m,
        colors: colors,
        iconColor: iconColor,
        metaStyle: metaStyle,
        onCancelUpload: onCancelUpload,
      ),
      models.MessageKind.voice => _VoiceRow(message: m, colors: colors, iconColor: iconColor, metaStyle: metaStyle),
      models.MessageKind.text => null,
    };
    // Подпись и имя у фото — с отступами пузыря (само фото почти до краёв).
    final visual = m.kind == models.MessageKind.photo || m.kind == models.MessageKind.video || m.isAlbum;
    final captionInset = visual ? 7.0 : 0.0;
    final content = <Widget>[];
    if (showSender && m.senderName.isNotEmpty) {
      content.add(
        Padding(
          padding: EdgeInsets.fromLTRB(captionInset, captionInset / 2, captionInset, 2),
          child: Text(
            m.senderName,
            style: style.textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: senderColor(m.senderName)),
          ),
        ),
      );
    }
    if (m.forward case final forward?) {
      // «Переслано от Анна» — имя жирным, как в Telegram.
      final name = forward.self ? t.screenChat.you : forward.name;
      final label = t.screenChat.forwardedFrom(name: '\u0000');
      final split = label.indexOf('\u0000');
      final linkStyle = style.textStyle.copyWith(fontSize: 13.5, height: 1.2, color: colors.link);
      content.add(
        Padding(
          padding: EdgeInsets.fromLTRB(captionInset, captionInset / 2, captionInset, 4),
          child: Text.rich(
            TextSpan(
              style: linkStyle,
              children: [
                TextSpan(text: label.substring(0, split)),
                TextSpan(
                  text: name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: label.substring(split + 1)),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    if (m.reply case final reply?) {
      content.add(_ReplyQuote(reply: reply, colors: colors, style: style, onTap: onReplyTap));
    }
    if (media != null) content.add(media);

    // С реакциями время уезжает в их строку (справа), как в Telegram.
    final hasReactions = m.reactions.isNotEmpty;
    if (m.text.isNotEmpty) {
      content.add(
        Padding(
          padding: EdgeInsets.fromLTRB(captionInset, media != null ? 6 : 0, captionInset, 0),
          child: Stack(
            children: [
              MessageText(
                text: m.text,
                entities: m.entities,
                style: style.textStyle,
                colors: colors,
                trailing: hasReactions ? '' : trailing,
                trailingStyle: metaStyle,
                highlight: highlight,
                highlightColor: focused ? const Color(0xCCFF9500) : const Color(0x66FFCC00),
              ),
              if (!hasReactions) Positioned(right: 0, bottom: 0, child: meta),
            ],
          ),
        ),
      );
    }
    if (hasReactions) {
      content.add(
        Padding(
          padding: EdgeInsets.fromLTRB(captionInset, 6, captionInset, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Expanded: реакции слева, время прижато к правому краю пузыря.
              Expanded(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final r in m.reactions)
                      _ReactionChip(
                        reaction: r,
                        colors: colors,
                        chosenText: iconColor,
                        textStyle: metaStyle,
                        onTap: onReaction == null
                            ? null
                            : () {
                                HapticFeedback.selectionClick();
                                onReaction!(r.emoji);
                              },
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              meta,
            ],
          ),
        ),
      );
    } else if (m.text.isEmpty) {
      content.add(
        Align(
          alignment: Alignment.centerRight,
          child: Padding(padding: EdgeInsets.fromLTRB(0, 4, captionInset, 0), child: meta),
        ),
      );
    }

    // [maxWidth] — предел ширины: в ленте 80% строки, в превью меню — ширина
    // пузыря в ленте (чтобы текст перенёсся так же).
    Widget body(double maxWidth) => ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: GestureDetector(
        // С обёрткой (iOS-меню) long-press ловит `CupertinoContextMenu`.
        onLongPress: menuWrapper == null ? onLongPress : null,
        onDoubleTap: onDoubleTap == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onDoubleTap!();
              },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: out ? style.outgoing : style.incoming,
            borderRadius: BorderRadius.only(
              topLeft: _radius,
              topRight: _radius,
              bottomLeft: !out && tail ? _tailRadius : _radius,
              bottomRight: out && tail ? _tailRadius : _radius,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(visual ? 4 : 11, visual ? 4 : 7, visual ? 4 : 11, 7),
            child: IntrinsicWidth(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: content),
            ),
          ),
        ),
      ),
    );
    final inList = LayoutBuilder(builder: (context, constraints) => body(math.min(constraints.maxWidth * 0.8, 520)));
    final bubble = menuWrapper == null ? inList : menuWrapper!(inList, (maxWidth) => IgnorePointer(child: body(maxWidth)));

    return Padding(
      padding: EdgeInsets.only(left: avatar == null ? 10 : 6, right: 10),
      child: Row(
        mainAxisAlignment: out ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ?avatar,
          Flexible(child: bubble),
        ],
      ),
    );
  }
}

class _ReplyQuote extends StatelessWidget {
  final models.MessageReply reply;
  final MessageTextColors colors;
  final MessageBubbleStyle style;

  final VoidCallback? onTap;

  const _ReplyQuote({required this.reply, required this.colors, required this.style, this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = reply.text.isNotEmpty ? reply.text : messageKindLabel(t, reply.kind);
    final quote = Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
        color: colors.link.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(color: colors.link, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reply.senderName.isEmpty ? t.screenChat.you : reply.senderName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style.textStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: colors.link),
          ),
          Text(
            text.replaceAll('\n', ' '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style.textStyle.copyWith(fontSize: 13, color: colors.text),
          ),
        ],
      ),
    );
    if (onTap == null) return quote;
    return GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: quote);
  }
}

/// «Фото» / «Файл» … — для цитат и превью без текста.
String messageKindLabel(Translations t, models.MessageKind kind) => switch (kind) {
  models.MessageKind.photo => t.screenChat.photo,
  models.MessageKind.video => t.screenChat.video,
  models.MessageKind.file => t.screenChat.file,
  models.MessageKind.voice => t.screenChat.voice,
  models.MessageKind.text => '',
};

/// Фото/видео: выбранный файл или (в демо-истории) цветная заглушка.
/// Миниатюра в пузыре: Hero для перехода в полноэкранный просмотр + тап.
Widget _tappableMedia(models.Message message, int index, ValueChanged<int>? onTap, Widget child) {
  final hero = Hero(tag: chatMediaHeroTag(message, index), child: child);
  if (onTap == null) return hero;
  return GestureDetector(onTap: () => onTap(index), child: hero);
}

class _MediaPreview extends StatelessWidget {
  final models.Message message;
  final ValueChanged<int>? onTap;

  const _MediaPreview({required this.message, this.onTap});

  static const _width = 260.0;

  @override
  Widget build(BuildContext context) {
    final video = message.kind == models.MessageKind.video;
    final meta = message.media.firstOrNull;
    // Пропорции из метаданных — пузырь не «прыгает», пока грузится картинка.
    final aspect = meta?.aspectRatio;
    final height = aspect == null ? (video ? 190.0 : _width) : (_width / aspect).clamp(140.0, 340.0);
    final Widget image;
    if (video && (meta?.thumbPath ?? '').isNotEmpty) {
      image = SizedBox(width: _width, height: height, child: chatVideoThumb(meta!, cacheWidth: 780));
    } else if (message.localPath.isNotEmpty && !video) {
      image = SizedBox(
        width: _width,
        height: height,
        child: ChatMediaImage(path: message.localPath, thumbhash: meta?.thumbhash ?? '', cacheWidth: 780),
      );
    } else {
      image = SizedBox(
        width: _width,
        height: height,
        child: chatMediaPlaceholder('${message.id}-0', video: video),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: _tappableMedia(message, 0, onTap, MediaSpoiler(enabled: meta?.spoiler ?? false, child: image)),
    );
  }
}

/// Альбом: фото/видео сеткой как в Telegram — ряды по 1–3 плитки, у первого
/// ряда крупнее; углы скруглены только снаружи.
class _AlbumGrid extends StatelessWidget {
  final models.Message message;
  final ValueChanged<int>? onTap;

  const _AlbumGrid({required this.message, this.onTap});

  static const _width = 260.0;
  static const _gap = 2.0;

  /// Сколько плиток в каждом ряду.
  static List<int> _rows(int n) => switch (n) {
    2 => [2],
    3 => [1, 2],
    4 => [1, 3],
    5 => [2, 3],
    6 => [3, 3],
    7 => [1, 3, 3],
    8 => [2, 3, 3],
    9 => [3, 3, 3],
    _ => [2, 2, 3, 3],
  };

  static double _rowHeight(int count) => switch (count) {
    1 => 170,
    2 => 130,
    _ => 90,
  };

  @override
  Widget build(BuildContext context) {
    final items = message.media.take(models.Message.maxAlbum).toList();
    final rows = <Widget>[];
    var index = 0;
    for (final count in _rows(items.length)) {
      final height = _rowHeight(count);
      final tileWidth = (_width - _gap * (count - 1)) / count;
      rows.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) const SizedBox(width: _gap),
              SizedBox(width: tileWidth, height: height, child: _tile(items[index + i], index + i)),
            ],
          ],
        ),
      );
      index += count;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: _width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < rows.length; i++) ...[if (i > 0) const SizedBox(height: _gap), rows[i]],
          ],
        ),
      ),
    );
  }

  Widget _tile(models.MessageMedia item, int index) {
    final video = item.kind == models.MessageKind.video;
    final Widget child = video && item.thumbPath.isNotEmpty
        ? chatVideoThumb(item, playSize: 34, cacheWidth: 520)
        : item.localPath.isEmpty || video
        ? chatMediaPlaceholder('${message.id}-$index', video: video, iconSize: 26)
        : ChatMediaImage(path: item.localPath, thumbhash: item.thumbhash, cacheWidth: 520);
    return _tappableMedia(message, index, onTap, MediaSpoiler(enabled: item.spoiler, child: child));
  }
}

class _FileRow extends StatelessWidget {
  final models.Message message;
  final MessageTextColors colors;
  final Color iconColor;
  final TextStyle metaStyle;
  final VoidCallback? onCancelUpload;

  const _FileRow({required this.message, required this.colors, required this.iconColor, required this.metaStyle, this.onCancelUpload});

  @override
  Widget build(BuildContext context) {
    final name = message.fileName.isNotEmpty ? message.fileName : context.t.screenChat.file;
    final dot = name.lastIndexOf('.');
    final ext = dot > 0 ? name.substring(dot + 1).toUpperCase() : '';
    // Размер: настоящий у отправленного файла, у демо-истории — псевдослучайный,
    // стабильный для сообщения.
    final size = message.fileSize > 0 ? message.fileSize : 200000 + (message.id.hashCode.abs() % 480) * 10000;
    final uploading = message.isUploading;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        uploading
            ? UploadProgressRing(
                progress: message.uploadProgress,
                size: 44,
                color: iconColor,
                background: colors.link,
                onCancel: onCancelUpload,
              )
            : Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: colors.link, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: FaIcon(FontAwesomeIcons.solidFile, size: 18, color: iconColor),
              ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: metaStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: colors.text),
              ),
              Text(
                uploading ? uploadProgressText(context, message) : '${formatBytes(context, size)}${ext.isEmpty ? '' : ' · $ext'}',
                style: metaStyle.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VoiceRow extends StatelessWidget {
  final models.Message message;
  final MessageTextColors colors;
  final Color iconColor;
  final TextStyle metaStyle;

  const _VoiceRow({required this.message, required this.colors, required this.iconColor, required this.metaStyle});

  static const _barWidth = 2.5;
  static const _barGap = 1.5;
  static const _height = 22.0;

  /// Уровни 0..1: записанная волна или (демо-история без неё) псевдослучайная.
  List<double> _bars() {
    if (message.waveform.isNotEmpty) return [for (final v in message.waveform) 0.12 + 0.88 * (v.clamp(0, 31) / 31)];
    final random = math.Random(message.id.hashCode);
    return List.generate(28, (_) => 0.2 + random.nextDouble() * 0.8);
  }

  static String _time(int seconds) => '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final bars = _bars();
    final width = bars.length * (_barWidth + _barGap);
    final player = VoicePlayer.instance;
    return ListenableBuilder(
      listenable: player,
      builder: (context, _) {
        final current = player.currentID == message.id;
        final playing = player.isPlaying(message.id);
        final progress = player.progressOf(message.id);
        // Играет — сколько прошло, иначе — длина.
        final seconds = current ? player.position.inSeconds : message.duration;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => player.toggle(message),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: colors.link, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Padding(
                  // Треугольник «play» визуально по центру — чуть правее.
                  padding: EdgeInsets.only(left: playing ? 0 : 2),
                  child: FaIcon(playing ? FontAwesomeIcons.pause : FontAwesomeIcons.play, size: 15, color: iconColor),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Тап по волне текущего голосового — перемотка.
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: current ? (details) => player.seek(message.id, details.localPosition.dx / width) : null,
                  child: SizedBox(
                    width: width,
                    height: _height,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (final (i, h) in bars.indexed)
                          Container(
                            width: _barWidth,
                            height: _height * h,
                            margin: const EdgeInsets.symmetric(horizontal: _barGap / 2),
                            decoration: BoxDecoration(
                              color: (i + 0.5) / bars.length <= progress ? colors.link : colors.link.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(_time(seconds), style: metaStyle),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Размер файла по-человечески: «340 КБ», «3,4 МБ», «1,2 ГБ» (дробная часть —
/// с разделителем текущего языка).
String formatBytes(BuildContext context, int bytes) {
  final t = context.t.screenChat;
  final locale = Localizations.maybeLocaleOf(context)?.toLanguageTag();
  const kb = 1024;
  const mb = kb * 1024;
  const gb = mb * 1024;
  if (bytes < mb) return '${(bytes / kb).ceil()} ${t.kb}';
  final oneDecimal = NumberFormat('0.0', locale);
  if (bytes < gb) return '${oneDecimal.format(bytes / mb)} ${t.mb}';
  return '${oneDecimal.format(bytes / gb)} ${t.gb}';
}

/// «1,2 из 3,4 МБ» — сколько вложений уже загружено.
String uploadProgressText(BuildContext context, models.Message m) {
  final total = formatBytes(context, m.uploadTotal);
  // Единица — один раз, у общего размера (если она совпадает).
  final unit = total.split(' ').last;
  var done = formatBytes(context, m.uploadedBytes);
  if (done.endsWith(' $unit')) done = done.substring(0, done.length - unit.length - 1);
  return context.t.screenChat.uploadProgress(done: done, total: total);
}

/// Кольцо прогресса загрузки с крестиком отмены по центру.
class UploadProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final Color color;
  final Color background;
  final VoidCallback? onCancel;

  const UploadProgressRing({
    super.key,
    required this.progress,
    required this.size,
    required this.color,
    required this.background,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onCancel,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        alignment: Alignment.center,
        // Плавно между шагами прогресса (они приходят пачками по чанкам).
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: progress),
          duration: const Duration(milliseconds: 200),
          builder: (context, value, child) => CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(progress: value, color: color),
            child: child,
          ),
          child: SizedBox.square(
            dimension: size,
            child: Center(
              child: FaIcon(FontAwesomeIcons.xmark, size: size * 0.36, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 2.5;
    final rect = (Offset.zero & size).deflate(stroke / 2 + 3);
    // Минимальная дуга — чтобы в самом начале было видно, что загрузка идёт.
    final sweep = math.max(0.04, progress) * 2 * math.pi;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweep,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.color != color;
}

/// Реакция под сообщением: эмодзи + число. Наша — залита цветом ссылки.
class _ReactionChip extends StatelessWidget {
  final models.MessageReaction reaction;
  final MessageTextColors colors;

  /// Цвет числа на нашей (залитой) реакции — контрастный к цвету ссылки.
  final Color chosenText;
  final TextStyle textStyle;
  final VoidCallback? onTap;

  const _ReactionChip({required this.reaction, required this.colors, required this.chosenText, required this.textStyle, this.onTap});

  @override
  Widget build(BuildContext context) {
    final chosen = reaction.chosen;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: chosen ? colors.link : colors.link.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Непрозрачный цвет: у полупрозрачного эмодзи «выцветает».
            Text(reaction.emoji, style: textStyle.copyWith(fontSize: 15, color: const Color(0xFF000000))),
            const SizedBox(width: 4),
            Text(
              '${reaction.count}',
              style: textStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: chosen ? chosenText : colors.link),
            ),
          ],
        ),
      ),
    );
  }
}

/// Полоса реакций в меню сообщения (long-press): тап — поставить/снять.
class ReactionPicker extends StatelessWidget {
  final List<String> emojis;

  /// Уже поставленные нами — подсвечены.
  final List<String> selected;
  final Color selectedBackground;
  final ValueChanged<String> onSelected;

  const ReactionPicker({
    super.key,
    required this.emojis,
    this.selected = const [],
    required this.selectedBackground,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView, а не ListView: в меню iOS полоса стоит внутри
    // IntrinsicHeight, а вьюпорт ListView интринсики не поддерживает.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          for (final emoji in emojis)
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onSelected(emoji);
              },
              child: Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: selected.contains(emoji) ? selectedBackground : null, shape: BoxShape.circle),
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
        ],
      ),
    );
  }
}
