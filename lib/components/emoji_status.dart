import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../chats/animated_emoji.dart';
import '../i18n/translations.g.dart';
import '../models.dart' as models;

String emojiStatusText(BuildContext context, models.EmojiStatus status) {
  if (!status.active) return '';
  final expiresAt = status.expiresAt;
  if (expiresAt == null) return status.emoji;
  final now = DateTime.now();
  final sameDay = expiresAt.year == now.year && expiresAt.month == now.month && expiresAt.day == now.day;
  final until = sameDay ? DateFormat.Hm().format(expiresAt) : DateFormat.yMMMd().add_Hm().format(expiresAt);
  return context.t.screenMyProfile.emojiStatusUntil(emoji: status.emoji, until: until);
}

class EmojiStatusLabel extends StatefulWidget {
  final models.EmojiStatus status;
  final TextStyle? style;
  final bool showUntil;

  const EmojiStatusLabel({super.key, required this.status, this.style, this.showUntil = true});

  @override
  State<EmojiStatusLabel> createState() => _EmojiStatusLabelState();
}

class _EmojiStatusLabelState extends State<EmojiStatusLabel> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(covariant EmojiStatusLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    final expiresAt = widget.status.expiresAt;
    if (expiresAt == null || !widget.status.active) return;
    _timer = Timer(expiresAt.difference(DateTime.now()) + const Duration(milliseconds: 100), () {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.status.active) return const SizedBox.shrink();
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    final data = AnimatedEmojiStore.lookup(widget.status.emoji);
    final emoji = data != null && bundledAnimatedEmoji.contains(data.name)
        ? AnimatedBigEmoji(text: widget.status.emoji, style: style)
        : Text(widget.status.emoji, style: style);
    if (!widget.showUntil || widget.status.expiresAt == null) return emoji;
    final until = emojiStatusText(context, widget.status).substring(widget.status.emoji.length);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        emoji,
        Flexible(
          child: Text(until, maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
        ),
      ],
    );
  }
}
