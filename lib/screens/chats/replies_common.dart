import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../chats/chats_mapping.dart' show idBytes;
import '../../chats/media_prepare.dart' show thumbhashImage;
import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;

/// Общее для экрана «Ответы» (подэтап 4.6) на Cupertino и Material: лента
/// ответов как у чата (снизу новые), только чтение. Над пузырём — «в
/// комментариях к <канал>» и начало поста; в пузыре — имя автора, превью
/// медиа и текст. Тап — ветка на этом сообщении.
class RepliesFeed extends StatelessWidget {
  /// Пузыри — как в окне чата этой платформы.
  final MessageBubbleStyle style;

  /// Подписи над пузырём и пустой экран.
  final Color secondary;

  /// Индикатор дозагрузки (платформенный).
  final Widget progress;

  final EdgeInsets padding;

  const RepliesFeed({super.key, required this.style, required this.secondary, required this.progress, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChats;
    return BlocBuilder<RepliesCubit, RepliesState>(
      builder: (context, state) {
        if (state.replies.isEmpty) {
          if (state.status != Status.success) return Center(child: progress);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                t.repliesEmpty,
                textAlign: TextAlign.center,
                style: TextStyle(color: secondary),
              ),
            ),
          );
        }
        final cubit = context.read<RepliesCubit>();
        final items = state.replies.reversed.toList();
        final more = state.hasOlder ? 1 : 0;
        return ListView.builder(
          reverse: true,
          padding: padding.add(const EdgeInsets.symmetric(vertical: 8)),
          itemCount: items.length + more,
          itemBuilder: (context, index) {
            if (index >= items.length) {
              // Дошли до верха — следующая страница с сервера.
              WidgetsBinding.instance.addPostFrameCallback((_) => cubit.loadOlder());
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Center(child: state.loadingOlder ? progress : const SizedBox(height: 20)),
              );
            }
            final reply = items[index];
            // Строка построена — она на экране (или вот-вот будет): прочтение
            // пакетом.
            cubit.seen(reply);
            return ReplyRow(key: ValueKey(reply.replyID), reply: reply, style: style, secondary: secondary);
          },
        );
      },
    );
  }
}

/// Один ответ: подпись «в комментариях к …», аватар автора и пузырь.
class ReplyRow extends StatelessWidget {
  final models.ChatReply reply;
  final MessageBubbleStyle style;
  final Color secondary;

  const ReplyRow({super.key, required this.reply, required this.style, required this.secondary});

  static const _avatar = 34.0;

  @override
  Widget build(BuildContext context) {
    final t = context.t.screenChats;
    final caption = reply.channelTitle.isEmpty ? t.repliesInCommentsUnknown : t.repliesInComments(title: reply.channelTitle);
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(reply.route),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: _avatar + 8, bottom: 4, right: 40),
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: FaIcon(reply.mention ? FontAwesomeIcons.at : FontAwesomeIcons.reply, size: 11, color: secondary),
                      ),
                    ),
                    TextSpan(text: caption),
                    if (reply.postText.isNotEmpty) TextSpan(text: ' · ${reply.postText.replaceAll('\n', ' ')}'),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: secondary),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Скрытый автор — заглушка без фото (как в баннере).
                reply.hidden
                    ? UserAvatar(userID: null, placeholderName: 'hidden', size: _avatar)
                    : UserAvatar(userID: idBytes(reply.authorID), placeholderName: reply.authorID, size: _avatar),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width * 0.75),
                  child: _bubble(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble(BuildContext context) {
    final t = context.t.screenChats;
    final text = reply.text.isNotEmpty
        ? reply.text
        : switch (reply.kind) {
            models.MessageKind.photo => t.photo,
            models.MessageKind.video => t.video,
            models.MessageKind.file => t.file,
            models.MessageKind.voice => t.voice,
            models.MessageKind.poll => '📊 ${context.t.screenChat.poll}',
            _ => '',
          };
    final media = _media();
    final name = reply.hidden
        ? context.t.inAppNotice.appName
        : (reply.authorName.isEmpty ? context.t.sessionsPrivacyAndSecurity.unknownUser : reply.authorName);
    return Container(
      decoration: BoxDecoration(color: style.incoming, borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ?media,
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 7, 12, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style.textStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: senderColor(name)),
                ),
                if (text.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    reply.kind == models.MessageKind.poll && reply.text.isNotEmpty ? '📊 $text' : text,
                    maxLines: 12,
                    overflow: TextOverflow.ellipsis,
                    style: style.textStyle.copyWith(color: style.incomingText.text),
                  ),
                ],
                const SizedBox(height: 2),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  widthFactor: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (reply.unread) ...[
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(color: style.incomingText.link, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(_time(reply.date), style: TextStyle(fontSize: 12, color: style.incomingMeta)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Превью фото / видео: скачанный файл, иначе размытое из thumbhash.
  Widget? _media() {
    if (reply.kind != models.MessageKind.photo && reply.kind != models.MessageKind.video) return null;
    final preview = thumbhashImage(reply.thumbhash);
    final Widget image;
    if (reply.mediaPath.isNotEmpty) {
      image = ChatMediaImage(path: reply.mediaPath, thumbhash: reply.thumbhash, cacheWidth: 600);
    } else if (preview != null) {
      image = Image(image: preview, fit: BoxFit.cover, gaplessPlayback: true);
    } else {
      return null;
    }
    return SizedBox(
      width: 240,
      height: 160,
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          if (reply.kind == models.MessageKind.video)
            const Center(child: FaIcon(FontAwesomeIcons.solidCirclePlay, size: 36, color: Color(0xCCFFFFFF))),
        ],
      ),
    );
  }

  /// Сегодня — время, иначе — дата и время.
  static String _time(DateTime date) {
    final local = date.toLocal();
    final now = DateTime.now();
    final today = local.year == now.year && local.month == now.month && local.day == now.day;
    final time = DateFormat.jm().format(local);
    return today ? time : '${local.chatListFormat()} $time';
  }
}
