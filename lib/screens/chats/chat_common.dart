import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart' as m;
import 'package:path/path.dart' as p;

import '../../split_layout.dart';
import '../../chats/channel_rights.dart';
import '../../chats/chats_remote_data_source.dart';
import '../../chats/chats_sync.dart';
import '../../chats/media_files.dart';
import '../../chats/media_prepare.dart';
import '../../chats/member_badge.dart';
import '../../chats/message_formatting.dart';
import '../../chats/message_quote.dart';
import '../../chats/newcomer.dart';
import '../../chats/read_receipts.dart';
import '../../chats/slow_mode.dart';
import '../../chats/video_prepare.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../extensions.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import '../../platform.dart';
import 'chat_create_common.dart';
import 'chat_info_common.dart';
import 'comments_limit.dart';
import 'media_caption_cupertino.dart';
import 'media_caption_material.dart';
import 'poll_create_cupertino.dart';
import 'poll_create_material.dart';

export '../../components/chats/chat_toast.dart' show showChatToast;

/// Общее для окна чата на обеих платформах (`chat_cupertino.dart` /
/// `chat_material.dart`).

/// Подзаголовок шапки: «печатает…», «был(а) недавно», «N участников» /
/// «N подписчиков». Счётчики в демо — псевдослучайные, стабильные по id.
({String text, bool active}) chatSubtitle(Translations t, models.Chat chat) {
  if (chat.typing.isNotEmpty) return (text: ChatTileContent.typing(t, chat), active: true);
  // Комментарии к посту — название канала под «Комментарии».
  if (chat.isThread) return (text: chat.title, active: false);
  final seed = chat.id.hashCode.abs();
  final count = chat.membersCount > 0 ? chat.membersCount : (chat.type == models.ChatType.channel ? 1200 + seed % 90000 : 3 + seed % 60);
  return switch (chat.type) {
    models.ChatType.private when chat.isSelf => (text: '', active: false),
    // «Iperon» — не человек: вместо «в сети» — что это за чат.
    models.ChatType.private when chat.isSystem => (text: t.systemNotice.subtitle, active: false),
    models.ChatType.private => chatPresence(t, chat),
    models.ChatType.group || models.ChatType.community => (text: t.screenChat.members(n: count, count: count.grouped), active: false),
    models.ChatType.channel => (text: t.screenChat.subscribers(n: count, count: count.grouped), active: false),
  };
}

/// Опрос: «Отменить голос» — проголосовали, не викторина, не завершён.
bool canRetractVote(models.Message message) {
  final poll = message.poll;
  return poll != null && poll.voted && !poll.quiz && !poll.closed;
}

/// Опрос: «Завершить опрос» — автор или админ (в группе — с правом удалять
/// сообщения, как на сервере), пока не завершён.
bool canClosePoll(models.Chat chat, models.Message message, {List<models.ChatMember> members = const []}) {
  final poll = message.poll;
  // Пересланный опрос — тот же опрос: завершает только автор исходного.
  if (poll == null || poll.closed || message.forward != null) return false;
  if (message.outgoing) return true;
  return chat.type == models.ChatType.group ? canDeleteOthers(chat, members) : chat.canManage;
}

/// «Завершить опрос?» — `true`, если подтвердили.
Future<bool> confirmClosePoll(BuildContext context) {
  final t = context.t.screenChat;
  return _confirmDestructive(context, title: t.closePollTitle, message: t.closePollMessage, action: t.closePoll);
}

/// Пост канала: «Закрыть комментарии» / «Открыть комментарии» — админ канала
/// с включёнными комментариями (с известными правами — с правом править
/// посты, как на сервере).
bool canToggleComments(models.Chat chat, models.Message message) =>
    chat.type == models.ChatType.channel &&
    chat.commentsEnabled &&
    chat.canManage &&
    !message.service &&
    (chat.myRights == null || channelCan(chat, const [], ChannelAction.editOthers));

/// «Заблокировать {name}?» (автор комментария — в канале) — `true`, если
/// подтвердили.
Future<bool> confirmBanCommenter(BuildContext context, String name) {
  final t = context.t.screenChat;
  return _confirmDestructive(
    context,
    title: t.banCommenterTitle(name: name),
    message: t.banCommenterMessage,
    action: t.banCommenter,
  );
}

/// «Закрыть комментарии?» — `true`, если подтвердили.
Future<bool> confirmCloseComments(BuildContext context) {
  final t = context.t.screenChat;
  return _confirmDestructive(context, title: t.closeCommentsTitle, message: t.closeCommentsMessage, action: t.closeComments);
}

/// Подтверждение необратимого действия: iOS — alert с красной кнопкой,
/// Android — диалог. `true`, если подтвердили.
Future<bool> _confirmDestructive(BuildContext context, {required String title, required String message, required String action}) async {
  if (Platform.isIOS) {
    return await c.showCupertinoDialog<bool>(
          context: context,
          builder: (dialogContext) => c.CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              c.CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
              c.CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(action),
              ),
            ],
          ),
        ) ??
        false;
  }
  return await m.showDialog<bool>(
        context: context,
        builder: (dialogContext) => m.AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            m.TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(context.t.common.cancel)),
            m.TextButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(action)),
          ],
        ),
      ) ??
      false;
}

/// Открытый опрос: «кто за что» — по вариантам, имена проголосовавших.
Future<void> showPollVoters(BuildContext context, models.MessagePoll poll) {
  final t = context.t.screenChat;
  Widget body(BuildContext sheetContext, Color secondary) => ListView(
    shrinkWrap: true,
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
    children: [
      for (final option in poll.options)
        if (option.voters.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              '${option.text} — ${t.votes(n: option.votes, count: option.votes.grouped)}',
              style: TextStyle(fontSize: 13, color: secondary),
            ),
          ),
          for (final name in option.voters)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  ContactAvatar(
                    contact: models.ChatMember(id: name, name: name),
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(name == 'Вы' ? context.t.screenChat.you : name)),
                ],
              ),
            ),
        ],
    ],
  );
  if (Platform.isIOS) {
    return c.showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7),
        decoration: BoxDecoration(
          color: c.CupertinoColors.systemBackground.resolveFrom(sheetContext),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  t.pollVoters,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: c.CupertinoColors.label.resolveFrom(sheetContext)),
                ),
              ),
              Flexible(
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 16, color: c.CupertinoColors.label.resolveFrom(sheetContext)),
                  child: body(sheetContext, c.CupertinoColors.secondaryLabel.resolveFrom(sheetContext)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return m.showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7),
        child: body(sheetContext, m.Theme.of(sheetContext).colorScheme.onSurfaceVariant),
      ),
    ),
  );
}

/// Строка «Прочитано сегодня в 12:30» / «Прочитали: 3» в меню своего
/// сообщения (`null` — ещё загружается). Время скрыто собеседником — просто
/// «Прочитано» (✓✓ видны всё равно).
String readInfoLabel(Translations t, models.Chat chat, MessageReadInfo? info) {
  final s = t.screenChat;
  if (chat.type != models.ChatType.private) return info == null ? s.readByTitle : s.readBy(count: info.readers.length);
  final date = info?.date;
  return date == null ? s.read : s.readAt(date: date.relativeFormat(t));
}

/// Грузит «кто / когда прочитал», только когда строка показана (меню
/// открыто), и перерисовывает её по ответу.
class MessageReadInfoBuilder extends StatefulWidget {
  final Future<MessageReadInfo> Function() load;
  final Widget Function(BuildContext context, MessageReadInfo? info) builder;

  const MessageReadInfoBuilder({super.key, required this.load, required this.builder});

  @override
  State<MessageReadInfoBuilder> createState() => _MessageReadInfoBuilderState();
}

class _MessageReadInfoBuilderState extends State<MessageReadInfoBuilder> {
  late final Future<MessageReadInfo> _future = widget.load();

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<MessageReadInfo>(future: _future, builder: (context, snapshot) => widget.builder(context, snapshot.data));
}

/// «Прочитали» в группе: кто и когда (от последних), с его реакцией.
Future<void> showMessageReaders(BuildContext context, List<MessageReader> readers) {
  final t = context.t;
  Widget body(Color secondary) => ListView(
    shrinkWrap: true,
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
    children: [
      for (final r in readers)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              ContactAvatar(
                contact: models.ChatMember(id: r.userID, name: r.name),
                size: 36,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(r.date.relativeFormat(t), style: TextStyle(fontSize: 13, color: secondary)),
                  ],
                ),
              ),
              if (r.reaction.isNotEmpty) Text(r.reaction, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
    ],
  );
  if (Platform.isIOS) {
    return c.showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7),
        decoration: BoxDecoration(
          color: c.CupertinoColors.systemBackground.resolveFrom(sheetContext),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  t.screenChat.readByTitle,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: c.CupertinoColors.label.resolveFrom(sheetContext)),
                ),
              ),
              Flexible(
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 16, color: c.CupertinoColors.label.resolveFrom(sheetContext)),
                  child: body(c.CupertinoColors.secondaryLabel.resolveFrom(sheetContext)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return m.showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.screenChat.readByTitle, style: m.Theme.of(sheetContext).textTheme.titleMedium),
            Flexible(child: body(m.Theme.of(sheetContext).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    ),
  );
}

/// «Нет соединения» — серверное действие чатов не выполнено без сети
/// (`ChatsOfflineException`): iOS — диалог, Android — SnackBar.
void showChatsNoConnection(BuildContext context) {
  final t = context.t;
  if (Platform.isIOS) {
    c.showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => c.CupertinoAlertDialog(
        title: Text(t.common.noConnectionTitle),
        content: Text(t.common.noConnectionMessage),
        actions: [
          c.CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.of(dialogContext).pop(), child: Text(t.common.close)),
        ],
      ),
    );
    return;
  }
  m.ScaffoldMessenger.maybeOf(context)?.showSnackBar(m.SnackBar(content: Text(t.common.noConnectionTitle)));
}

/// Тап по «Переслано от …»: личный чат с автором оригинала; автор запретил
/// ссылку на аккаунт при пересылке — «Аккаунт скрыт пользователем».
Future<void> openForwardAuthor(BuildContext context, models.Message message) async {
  final forward = message.forward;
  if (forward == null || forward.self) return;
  if (forward.fromChannel) return _openForwardChannel(context, forward);
  if (forward.userID.isNotEmpty) {
    openMentionName(context, forward.userID);
  } else if (forward.hidden) {
    showChatToast(context, context.t.screenChat.forwardHidden);
  }
}

/// «Переслано из <канал>»: подписан (или уже читаем его без подписки) — окно
/// канала на исходном посте; нет — по публичному имени канала
/// (`fromUsername`, 4.4) — открыть его без подписки (`resolveLink`), тоже на
/// посте; частный — пояснение (предпросмотра по одному id у сервера нет).
/// Без сети и без кэша — «Нет соединения».
Future<void> _openForwardChannel(BuildContext context, models.MessageForward forward) async {
  final source = chatsDataSource(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo);
  if (source == null) return;
  final chats = await source.watchChats().first;
  if (!context.mounted) return;
  final at = forward.messageID.isEmpty ? '' : '?message=${forward.messageID}';
  final chat = chats.where((c) => c.id == forward.chatID).firstOrNull;
  if (chat != null && (chat.isMember || chat.browsing)) {
    await openChat(context, '/chats/chat/${forward.chatID}$at');
    return;
  }
  if (forward.username.isEmpty) {
    showChatToast(context, context.t.screenChat.forwardChannelUnavailable);
    return;
  }
  final String chatID;
  try {
    chatID = await source.resolveLink(forward.username);
  } on ChatsOfflineException {
    if (context.mounted) showChatsNoConnection(context);
    return;
  } on ChatsFloodException catch (error) {
    if (context.mounted) showChatsFlood(context, error.seconds);
    return;
  } on ChatsRequestException catch (error) {
    if (context.mounted) showChatsFailed(context, error.error);
    return;
  }
  if (!context.mounted) return;
  if (chatID.isEmpty) {
    showChatToast(context, context.t.screenChat.forwardChannelUnavailable);
    return;
  }
  // Имя могло перейти к другому каналу — тогда без прокрутки к посту.
  await openChat(context, '/chats/chat/$chatID${chatID == forward.chatID ? at : ''}');
}

/// Показывает [showChatsNoConnection], когда cubit сообщает о действии без
/// сети (растёт счётчик [notice], например `offlineNotice`). Ставится на
/// экран-владелец cubit'а (список, окно чата, «Новое сообщение»), чтобы
/// сообщение не показывалось дважды.
class ChatsOfflineListener<B extends StateStreamable<S>, S> extends StatelessWidget {
  final int Function(S state) notice;
  final Widget child;

  const ChatsOfflineListener({super.key, required this.notice, required this.child});

  @override
  Widget build(BuildContext context) => BlocListener<B, S>(
    listenWhen: (previous, current) => notice(current) > notice(previous),
    listener: (context, _) => showChatsNoConnection(context),
    child: child,
  );
}

/// «Закрепить» сверх [models.chatPinnedLimit] — объяснение, когда растёт
/// `ChatsState.pinnedLimitNotice`. Ставится на экран списка чатов.
class ChatsPinnedLimitListener extends StatelessWidget {
  final Widget child;

  const ChatsPinnedLimitListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) => BlocListener<ChatsCubit, ChatsState>(
    listenWhen: (previous, current) => current.pinnedLimitNotice > previous.pinnedLimitNotice,
    listener: (context, _) {
      final t = context.t.screenChats;
      unawaited(_showNotice(context, t.pinnedLimitMessage(n: models.chatPinnedLimit), title: t.pinnedLimitTitle));
    },
    child: child,
  );
}

/// Лимит частоты сервера на новые чаты: «попробуйте через …».
void showChatsFlood(BuildContext context, int seconds) {
  final t = context.t.screenChat;
  unawaited(_showNotice(context, t.floodNewChats(time: formatSlowModeLeft(seconds)), title: t.floodTitle));
}

/// Показывает [showChatsFlood], когда cubit сообщает об отказе по лимиту
/// частоты (растёт счётчик [notice]; [seconds] — сколько ждать).
class ChatsFloodListener<B extends StateStreamable<S>, S> extends StatelessWidget {
  final int Function(S state) notice;
  final int Function(S state) seconds;
  final Widget child;

  const ChatsFloodListener({super.key, required this.notice, required this.seconds, required this.child});

  @override
  Widget build(BuildContext context) => BlocListener<B, S>(
    listenWhen: (previous, current) => notice(current) > notice(previous),
    listener: (context, state) => showChatsFlood(context, seconds(state)),
    child: child,
  );
}

/// Группа создана / участники добавлены, но [count] человек нет — их
/// приватность «Кто может добавлять меня в группы».
Future<void> showChatsRestricted(BuildContext context, int count) {
  final t = context.t.chatAction;
  return _showNotice(
    context,
    t.restricted(n: count, count: count),
    title: t.restrictedTitle,
  );
}

/// Сервер отклонил действие с группой ([error] — ключ ошибки сервера).
void showChatsFailed(BuildContext context, String error) => unawaited(_showNotice(context, chatsFailedText(context.t, error)));

/// Текст отказа сервера по ключу [error] (см. [showChatsFailed]).
String chatsFailedText(Translations translations, String error) {
  final t = translations.chatAction;
  return switch (error) {
    'titleInvalid' => t.titleInvalid,
    'groupsDisabled' => t.groupsDisabled,
    'channelsDisabled' => t.channelsDisabled,
    'rightsTooWide' => t.rightsTooWide,
    'rankInvalid' => t.rankInvalid,
    'membersLimit' => t.membersLimit,
    'chatWriteForbidden' => t.chatWriteForbidden,
    'passwordInvalid' => t.passwordInvalid,
    'permissionDenied' => t.permissionDenied,
    'banned' => t.banned,
    'groupsLimit' => t.groupsLimit,
    'linkInvalid' || 'inviteInvalid' => t.linkInvalid,
    'linksLimit' => t.linksLimit,
    'usernameTaken' => t.usernameTaken,
    'usernameInvalid' => t.usernameInvalid,
    'newcomerRestricted' => t.newcomerRestricted,
    'slowModeWait' => t.slowModeWait,
    'pollClosed' => t.pollClosed,
    'pollForward' => t.pollForward,
    // Правка вложений (замена / добавление) — недопустимое сочетание.
    'mediaInvalid' => t.mediaInvalid,
    'reactionsLimit' => t.reactionsLimit,
    // Канал без подписки (4.4): реакции и голосование — подписчикам.
    'subscribeRequired' => t.subscribeRequired,
    // Комментарии к постам канала (4.3).
    'commentsDisabled' => t.commentsDisabled,
    'commentsClosed' => t.commentsClosed,
    'commentsSubscribersOnly' => t.commentsSubscribersOnly,
    final tooNew when commentsTooNewSeconds(tooNew) != null => t.commentsTooNew(
      time: untilTimeLabel(DateTime.now().add(Duration(seconds: commentsTooNewSeconds(tooNew)!))),
    ),
    _ => t.failed,
  };
}

/// Тап по пушу комментария: ветка поста [postID] канала [channelID] — из
/// кэша или с сервера. `threadID` пусто — не открылась, `error` — почему.
Future<({String threadID, String error})> openCommentsThread(
  Translations t, {
  required bool demo,
  required String channelID,
  required String postID,
}) async {
  final source = chatsDataSource(demo: demo);
  if (source == null) return (threadID: '', error: t.chatAction.failed);
  try {
    final id = await source.openComments(channelID, postID);
    return (threadID: id, error: id.isEmpty ? t.chatAction.failed : '');
  } on ChatsOfflineException {
    return (threadID: '', error: t.common.noConnectionMessage);
  } on ChatsFloodException {
    return (threadID: '', error: t.chatAction.failed);
  } on ChatsRequestException catch (error) {
    return (threadID: '', error: chatsFailedText(t, error.error));
  }
}

/// Показывает [showChatsRestricted] / [showChatsFailed], когда cubit сообщает
/// о частичном добавлении ([restricted] растёт, [count] — сколько не
/// добавлены) или отказе сервера ([failed] растёт, [error] — ключ).
class ChatsGroupNoticeListener<B extends StateStreamable<S>, S> extends StatelessWidget {
  final int Function(S state) restricted;
  final int Function(S state) count;
  final int Function(S state) failed;
  final String Function(S state) error;
  final Widget child;

  const ChatsGroupNoticeListener({
    super.key,
    required this.restricted,
    required this.count,
    required this.failed,
    required this.error,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => BlocListener<B, S>(
    listenWhen: (previous, current) => restricted(current) > restricted(previous),
    listener: (context, state) => unawaited(showChatsRestricted(context, count(state))),
    child: BlocListener<B, S>(
      listenWhen: (previous, current) => failed(current) > failed(previous),
      listener: (context, state) => showChatsFailed(context, error(state)),
      child: child,
    ),
  );
}

/// Тап по упоминанию по имени (без @username) — профиль человека.
void openMentionName(BuildContext context, String userID) => openUserProfile(context, userID);

/// Подписи отправителей в пузырях группы (звание / «владелец» / «админ») из
/// известных участников; в личном чате и канале — нет.
Map<String, String> chatSenderBadges(Translations t, models.Chat chat, List<models.ChatMember> members) {
  if (chat.type != models.ChatType.group && chat.type != models.ChatType.community) return const {};
  return senderBadges(members, owner: t.screenChatInfo.roleOwner, admin: t.screenChatInfo.roleAdmin);
}

/// Тап по человеку (участник, упоминание, «Переслано от») — его профиль. В
/// демо у людей нет настоящих userID — сразу личный чат, как раньше.
Future<void> openUserProfile(BuildContext context, String userID) async {
  if (userID.isEmpty) return;
  if (context.read<CommonCubit>().state.settingsDevice.chatsDemo) return openPrivateChatWith(context, userID);
  await context.push(profileRoute(context, userID));
}

/// Личный чат с [userID] («Сообщение» в профиле): существующий — сразу (и
/// без сети), новый создаёт сервер — без сети «Нет соединения». Источник — как
/// у экранов: демо или настоящие чаты.
Future<void> openPrivateChatWith(BuildContext context, String userID) async {
  if (userID.isEmpty) return;
  final source = chatsDataSource(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo);
  if (source == null) return;
  final String chatID;
  try {
    chatID = await source.openPrivateChat(userID);
  } on ChatsOfflineException {
    // Новый личный чат создаёт сервер.
    if (context.mounted) showChatsNoConnection(context);
    return;
  } on ChatsFloodException catch (error) {
    if (context.mounted) showChatsFlood(context, error.seconds);
    return;
  }
  if (chatID.isNotEmpty && context.mounted) await openChat(context, '/chats/chat/$chatID');
}

/// Кнопка внизу, когда писать нельзя: подпись (`null` — «Звук» канала) и
/// действие (`null` — неактивна: заявка уже отправлена).
(String?, VoidCallback?) channelBarAction(BuildContext context, models.Chat chat) {
  final t = context.t.screenChat;
  final cubit = context.read<ChatCubit>();
  if (chat.isMember) return (null, () => cubit.setMuted(!chat.muted));
  if (chat.joinRequested) return (t.requestSent, null);
  final label = chat.type == models.ChatType.channel
      ? t.subscribe
      : (chat.joinMode == models.ChatJoinMode.request ? t.requestJoin : t.joinGroup);
  // Ждём ответа сервера — второй раз не нажать.
  return (label, cubit.state.joining ? null : cubit.join);
}

/// Имя пользователя в ссылке `iperon.net/<имя>` (как на сервере).
final _linkUsername = RegExp(r'^[A-Za-z0-9_]{5,24}$');

/// Ссылка `iperon.net/<имя>` или `iperon.net/+код` (из сообщения, `@имя` или
/// снаружи — см. `DeepLinkGate`) — открыть в приложении: пользователя —
/// личный чат с ним, канал / группу — не подписаны — с «Подписаться» внизу.
/// `false` — не наша ссылка (`/blog`, другой сайт): открыть в браузере.
/// Нет такого пользователя / недействительное приглашение — сообщение об
/// этом; без сети — «Нет соединения».
Future<bool> openIperonLink(BuildContext context, Uri uri) async {
  final host = uri.host.toLowerCase().replaceFirst(RegExp(r'^www\.'), '');
  if (host != 'iperon.net') return false;
  final path = uri.pathSegments.firstOrNull ?? '';
  if (path.isEmpty) return false;
  final demo = context.read<CommonCubit>().state.settingsDevice.chatsDemo;
  // В демо публичные имена каналов бывают короче.
  final username = uri.pathSegments.length == 1 && (demo ? !path.startsWith('+') : _linkUsername.hasMatch(path));
  if (!username && !path.startsWith('+')) return false;
  final source = chatsDataSource(demo: demo);
  if (source == null) return false;
  final String chatID;
  try {
    chatID = await source.resolveLink(path);
  } on ChatsOfflineException {
    if (context.mounted) showChatsNoConnection(context);
    return true;
  } on ChatsFloodException catch (error) {
    if (context.mounted) showChatsFlood(context, error.seconds);
    return true;
  } on ChatsRequestException catch (error) {
    // Группы выключены (флаг) и т. п. — пояснение, а не «ссылка недействительна».
    if (context.mounted) showChatsFailed(context, error.error);
    return true;
  }
  if (!context.mounted) return true;
  if (chatID.isNotEmpty) {
    await openChat(context, '/chats/chat/$chatID');
    return true;
  }
  await _showNotice(context, username ? context.t.screenChat.userNotFound : context.t.screenChat.linkInvalid);
  return true;
}

/// Короткое пояснение: iOS — диалог с «ОК» ([title] — заголовок), Android —
/// SnackBar.
Future<void> _showNotice(BuildContext context, String text, {String? title}) async {
  if (Platform.isIOS) {
    await c.showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => c.CupertinoAlertDialog(
        title: title == null ? null : Text(title),
        content: Text(text),
        actions: [c.CupertinoDialogAction(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(context.t.common.ok))],
      ),
    );
  } else {
    m.ScaffoldMessenger.of(context).showSnackBar(m.SnackBar(content: Text(text)));
  }
}

/// «Новичкам — без ссылок и медиа»: можно ли нам отправить это — [media]
/// (вложение, голосовое, опрос) или текст [raw] (с markdown-ярлыками) и
/// пересылаемые. Нельзя — объясняем (до когда / «только подписчикам») и
/// возвращаем `false`.
bool checkNewcomer(BuildContext context, {bool media = false, String raw = '', List<models.Message> forwarding = const []}) {
  final state = context.read<ChatCubit>().state;
  if (!state.newcomerRestricted) return true;
  final (text, entities) = parseMarkdownShortcuts(raw.trim());
  if (!media && isLinkFree(text, entities) && forwarding.every(newcomerAllows)) return true;
  final t = context.t;
  final until = state.newcomerUntil;
  final message = until == null ? t.screenChat.newcomerSubscribe : t.screenChat.newcomerWaitUntil(time: untilTimeLabel(until));
  unawaited(_showNotice(context, message, title: t.screenChat.newcomerTitle));
  return false;
}

/// Медленный режим: можно ли отправить сейчас [count] сообщений. Нельзя
/// (ещё идёт отсчёт или сообщений больше одного) — объясняем и возвращаем
/// `false`.
bool checkSlowMode(BuildContext context, {int count = 1}) {
  final state = context.read<ChatCubit>().state;
  final t = context.t.screenChat;
  // Лимит частоты сервера — раньше медленного режима: действует во всех чатах.
  if (state.floodLeft > 0) {
    unawaited(_showNotice(context, t.floodWait(time: formatSlowModeLeft(state.floodLeft)), title: t.floodTitle));
    return false;
  }
  if (!(state.chat?.slowModeApplies ?? false)) return true;
  final text = state.slowModeLeft > 0
      ? t.slowModeWait(time: formatSlowModeLeft(state.slowModeLeft))
      : (count > 1 ? t.slowModeOneMessage : null);
  if (text == null) return true;
  unawaited(_showNotice(context, text, title: t.slowMode));
  return false;
}

/// Медленный режим: обратный отсчёт вместо кнопки отправки / микрофона; тап —
/// пояснение.
class SlowModeCountdown extends StatelessWidget {
  final int seconds;
  final Color color;

  const SlowModeCountdown({super.key, required this.seconds, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => checkSlowMode(context),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            formatSlowModeLeft(seconds),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color, fontFeatures: const [FontFeature.tabularFigures()]),
          ),
        ),
      ),
    );
  }
}

/// Выбранное вложение до отправки: путь, тип (фото / видео / файл) и, для
/// видео, правки из редактора.
class AttachmentDraft {
  final String path;
  final models.MessageKind kind;

  /// Обрезка / без звука / обложка / кадрирование (редактор видео); `null` — как есть.
  ChatVideoEdit? edit;

  AttachmentDraft(this.path, this.kind);

  bool get isMedia => kind == models.MessageKind.photo || kind == models.MessageKind.video;

  bool get isVideo => kind == models.MessageKind.video;

  Future<({String thumb, int durationMs, int width, int height})?>? _preview;
  int _previewAt = -1;

  /// Кадр-превью видео (обложка или начало отрезка) и длительность исходника;
  /// пересчитывается, только когда меняется кадр.
  Future<({String thumb, int durationMs, int width, int height})?> get videoPreview {
    final at = edit?.thumbAtMs ?? 0;
    if (_preview == null || _previewAt != at) {
      _previewAt = at;
      _preview = chatVideoPreview(path, atMs: at);
    }
    return _preview!;
  }
}

/// Итог превью перед отправкой: подпись, «Скрыть под спойлер» (меню «⋯») и
/// «HD» — видео в 1080p вместо 720p.
typedef MediaCaptionResult = ({String caption, bool spoiler, bool hd});

/// Скрепка: фото/видео из галереи, камера или файл → превью с подписью →
/// отправка. Несколько фото/видео уходят альбомом (по [models.Message.maxAlbum]
/// в сообщении), файлы — отдельными сообщениями. Подпись — у первого
/// сообщения; текст из поля ввода [input] переносится в подпись (как в Telegram).
Future<void> pickAndSendAttachments(BuildContext context, {TextEditingController? input}) async {
  final cubit = context.read<ChatCubit>();
  final chat = cubit.state.chat;
  if (!checkSlowMode(context) || !checkNewcomer(context, media: true)) return;
  // «Опрос» — в группах, сообществах, каналах и комментариях (не в личных);
  // в канале — у тех, кто публикует (поле ввода есть только у них), с
  // [ChatsFeatures.channelExtras] (на сервере — подэтап 4.2).
  final features = cubit.features;
  final polls =
      chat != null &&
      chat.type != models.ChatType.private &&
      (chat.type == models.ChatType.channel ? features.channelExtras && chat.canPost : features.groupExtras);
  // Десктоп: галереи нет — сразу системный выбор файлов (фото и видео из них
  // уходят как медиа, остальное — файлами); с опросом — сначала выбор.
  if (AppPlatform.isDesktop) {
    final poll = polls && await _desktopAttachPoll(context);
    if (!context.mounted) return;
    if (poll) {
      final created = await showPollCreateMaterial(context, channel: chat.type == models.ChatType.channel);
      if (created != null) await cubit.sendPoll(created);
      return;
    }
    final files = await pickAttachmentDocuments();
    if (!context.mounted) return;
    await sendAttachmentDrafts(context, [for (final file in files) attachmentDraft(file.path)], input: input);
    return;
  }
  final result = await showToolbarAttachments(
    context,
    tabs: [ToolbarAttachmentTabKind.gallery, ToolbarAttachmentTabKind.file, if (polls) ToolbarAttachmentTabKind.poll],
    media: ToolbarAttachmentMediaType.all,
    multiSelect: true,
  );
  if (result is ToolbarAttachmentPollResult) {
    if (!context.mounted || chat == null) return;
    final channel = chat.type == models.ChatType.channel;
    final poll = Platform.isIOS
        ? await showPollCreateCupertino(context, channel: channel)
        : await showPollCreateMaterial(context, channel: channel);
    if (poll != null) await cubit.sendPoll(poll);
    return;
  }
  final items = switch (result) {
    ToolbarAttachmentImageResult(:final file, :final source) => [
      attachmentDraft(file.path, asFile: source == ToolbarAttachmentTabKind.file),
    ],
    ToolbarAttachmentMultiImageResult(:final files, :final source) => [
      for (final file in files) attachmentDraft(file.path, asFile: source == ToolbarAttachmentTabKind.file),
    ],
    ToolbarAttachmentEmojiResult() || ToolbarAttachmentLinkResult() || ToolbarAttachmentPollResult() || null => const <AttachmentDraft>[],
  };
  if (!context.mounted) return;
  await sendAttachmentDrafts(context, items, input: input);
}

/// Скрепка на десктопе в чате с опросами: `true` — «Опрос», `false` — «Файл»
/// (или закрыли — тогда выбор файла тоже не открываем: см. вызов).
Future<bool> _desktopAttachPoll(BuildContext context) async {
  final poll = await m.showModalBottomSheet<bool>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          m.ListTile(
            leading: const m.Icon(m.Icons.attach_file),
            title: Text(context.t.screenMyProfile.chooseFile),
            onTap: () => Navigator.of(context).pop(false),
          ),
          m.ListTile(
            leading: const m.Icon(m.Icons.poll_outlined),
            title: Text(context.t.screenChat.poll),
            onTap: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ),
  );
  return poll ?? false;
}

/// Вставка из буфера обмена (меню «Вставить» в поле ввода, картинка с
/// клавиатуры на Android): фото и видео — тем же превью с подписью, что и
/// из скрепки.
Future<void> sendPastedMedia(BuildContext context, List<String> paths, {TextEditingController? input}) async {
  if (paths.isEmpty || !checkSlowMode(context) || !checkNewcomer(context, media: true)) return;
  await sendAttachmentDrafts(context, [for (final path in paths) attachmentDraft(path)], input: input);
}

/// «Вставить» в поле ввода, когда в буфере обмена фото / видео (например,
/// «Копировать» в галерее): они — файлами и в превью с подписью.
Future<void> pasteClipboardMedia(BuildContext context, {TextEditingController? input}) async {
  final paths = await MediaFiles.pasteMedia();
  if (!context.mounted) return;
  if (paths.isEmpty) return showChatToast(context, context.t.screenChat.pasteFailed);
  await sendPastedMedia(context, paths, input: input);
}

/// Что поле ввода принимает с клавиатуры (Android: вставка картинки из буфера
/// Gboard, GIF-клавиатура).
const chatInsertMimeTypes = [...kDefaultContentInsertionMimeTypes, 'video/mp4', 'video/3gpp', 'video/webm'];

/// Картинка / видео с клавиатуры — как вставка из буфера.
Future<void> insertKeyboardMedia(BuildContext context, KeyboardInsertedContent content, {TextEditingController? input}) async {
  final path = await MediaFiles.saveInserted(content.data, content.mimeType);
  if (path == null || !context.mounted) return;
  await sendPastedMedia(context, [path], input: input);
}

/// Превью с подписью и сжатие выбранных вложений [items]: подпись, фото и
/// видео (сжатые, в исходном порядке) и файлы как есть; `null` — отменили.
/// Текст из поля ввода [input] переносится в подпись (и из поля убирается).
/// [onCompressing] — началось сжатие видео (вернуть «закончилось»).
Future<({String caption, List<models.MessageMedia> media, List<AttachmentDraft> files})?> prepareAttachmentDrafts(
  BuildContext context,
  List<AttachmentDraft> items, {
  TextEditingController? input,
  VoidCallback Function()? onCompressing,
}) async {
  if (items.isEmpty || !context.mounted) return null;
  final initial = input?.text ?? '';
  final sheet = Platform.isIOS
      ? await showMediaCaptionCupertino(context, items, initialCaption: initial)
      : await showMediaCaptionMaterial(context, items, initialCaption: initial);
  if (sheet == null || !context.mounted) return null;

  // Фото — параллельно; видео — по очереди, с окном прогресса и «Отмена».
  final done = items.any((i) => i.kind == models.MessageKind.video) ? onCompressing?.call() : null;
  final List<models.MessageMedia> media;
  try {
    media = await _prepareMedia(
      context,
      [
        for (final i in items)
          if (i.isMedia) i,
      ],
      spoiler: sheet.spoiler,
      quality: sheet.hd ? ChatVideoQuality.hd : ChatVideoQuality.standard,
    );
  } on ChatVideoCancelled {
    return null;
  } finally {
    done?.call();
  }
  // Текст из поля ввода ушёл в подпись (после отмены сжатия — остаётся).
  if (initial.isNotEmpty) input?.clear();
  return (
    caption: sheet.caption,
    media: media,
    files: [
      for (final i in items)
        if (!i.isMedia) i,
    ],
  );
}

/// Превью с подписью и отправка выбранных вложений [items] (см.
/// [pickAndSendAttachments]).
Future<void> sendAttachmentDrafts(BuildContext context, List<AttachmentDraft> items, {TextEditingController? input}) async {
  final cubit = context.read<ChatCubit>();
  if (items.isEmpty || !context.mounted) return;
  // Медленный режим — только одно сообщение: один альбом или один файл.
  final mediaCount = items.where((i) => i.isMedia).length;
  final messages = (mediaCount + models.Message.maxAlbum - 1) ~/ models.Message.maxAlbum + items.length - mediaCount;
  if (!checkSlowMode(context, count: messages)) return;

  // Сжатие видео бывает долгим — собеседник видит «отправляет видео…» уже
  // сейчас (дальше его продолжит загрузка, см. ChatsSync).
  final prepared = await prepareAttachmentDrafts(
    context,
    items,
    input: input,
    onCompressing: () {
      final handle = cubit.beginActivity(models.ChatActivity.uploadVideo);
      return () => cubit.endActivity(handle);
    },
  );
  if (prepared == null) return;
  final media = prepared.media;

  var pending = prepared.caption;
  String takeCaption() {
    final value = pending;
    pending = '';
    return value;
  }

  for (var start = 0; start < media.length; start += models.Message.maxAlbum) {
    final chunk = media.sublist(start, math.min(start + models.Message.maxAlbum, media.length));
    await cubit.sendMedia(
      kind: chunk.every((m) => m.kind == models.MessageKind.video) ? models.MessageKind.video : models.MessageKind.photo,
      localPath: chunk.length == 1 ? chunk.single.localPath : '',
      fileName: chunk.length == 1 ? p.basename(chunk.single.localPath) : '',
      media: chunk,
      caption: takeCaption(),
    );
  }
  for (final file in prepared.files) {
    await cubit.sendMedia(kind: file.kind, localPath: file.path, fileName: p.basename(file.path), caption: takeCaption());
  }
}

/// Вложения для правки сообщения (скрепка в режиме «Изменить»): фото и видео
/// — сжатые, как при отправке (окно «Сжатие видео» с «Отменой» —
/// [ChatVideoCancelled]), файлы — как есть; в исходном порядке. Без листа
/// подписи: подпись — текст в поле ввода.
Future<List<models.MessageMedia>> prepareEditAttachments(BuildContext context, List<AttachmentDraft> items) async {
  final media = await _prepareMedia(
    context,
    [
      for (final i in items)
        if (i.isMedia) i,
    ],
    spoiler: false,
    quality: ChatVideoQuality.standard,
  );
  var next = 0;
  return [
    for (final i in items)
      if (i.isMedia)
        media[next++]
      else
        models.MessageMedia(kind: models.MessageKind.file, localPath: i.path, size: await File(i.path).length()),
  ];
}

/// Сжатие фото и видео перед отправкой, в исходном порядке. Видео дольше —
/// если его подготовка заметна (> 0,4 с), показывается окно «Сжатие видео» с
/// прогрессом по всем видео и «Отменой» ([ChatVideoCancelled]).
Future<List<models.MessageMedia>> _prepareMedia(
  BuildContext context,
  List<AttachmentDraft> items, {
  required bool spoiler,
  required ChatVideoQuality quality,
}) async {
  final photos = [for (final item in items) item.kind == models.MessageKind.photo ? _prepare(item, spoiler: spoiler) : null];
  final result = List<models.MessageMedia?>.filled(items.length, null);
  final videos = [
    for (final (i, item) in items.indexed)
      if (item.kind == models.MessageKind.video) (i, item),
  ];
  if (videos.isNotEmpty) {
    final progress = ValueNotifier<double>(0);
    ChatVideoJob? current;
    var cancelled = false;
    final close = _showVideoProgress(
      context,
      progress,
      onCancel: () {
        cancelled = true;
        current?.cancel();
      },
    );
    try {
      for (final (n, (i, item)) in videos.indexed) {
        if (cancelled) throw const ChatVideoCancelled();
        current = ChatVideoJob();
        final video = await prepareChatVideo(
          item.path,
          quality: quality,
          edit: item.edit,
          job: current,
          onProgress: (value) => progress.value = (n + value) / videos.length,
        );
        if (cancelled) throw const ChatVideoCancelled();
        result[i] = video == null
            ? models.MessageMedia(kind: item.kind, localPath: item.path, spoiler: spoiler)
            : models.MessageMedia(
                kind: item.kind,
                localPath: video.path,
                width: video.width,
                height: video.height,
                size: video.size,
                thumbPath: video.thumbPath,
                thumbhash: video.thumbhash,
                duration: video.duration,
                spoiler: spoiler,
              );
      }
    } finally {
      close();
      progress.dispose();
    }
  }
  for (final (i, photo) in photos.indexed) {
    if (photo != null) result[i] = await photo;
  }
  return [for (final m in result) m!];
}

/// Окно «Сжатие видео» (с задержкой — короткая подготовка без мигания).
/// Возвращает функцию закрытия.
VoidCallback _showVideoProgress(BuildContext context, ValueListenable<double> progress, {required VoidCallback onCancel}) {
  BuildContext? dialogContext;
  var closed = false;
  var popped = false;
  final timer = Timer(const Duration(milliseconds: 400), () {
    if (closed || !context.mounted) return;
    final t = context.t;
    Widget percent(BuildContext context) =>
        ValueListenableBuilder<double>(valueListenable: progress, builder: (context, value, _) => Text('${(value * 100).round()}%'));
    if (Platform.isIOS) {
      c.showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          // Закрыли раньше, чем окно построилось, — закрываем сразу после.
          if (closed && !popped) {
            popped = true;
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
          }
          return PopScope(
            canPop: false,
            child: c.CupertinoAlertDialog(
              title: Text(t.screenChat.videoCompressing),
              content: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<double>(
                      valueListenable: progress,
                      builder: (context, value, _) => _ProgressLine(value: value, color: c.CupertinoTheme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 8),
                    percent(context),
                  ],
                ),
              ),
              actions: [c.CupertinoDialogAction(onPressed: onCancel, child: Text(t.common.cancel))],
            ),
          );
        },
      );
    } else {
      m.showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          // Закрыли раньше, чем окно построилось, — закрываем сразу после.
          if (closed && !popped) {
            popped = true;
            WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pop());
          }
          return PopScope(
            canPop: false,
            child: m.AlertDialog(
              title: Text(t.screenChat.videoCompressing),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: progress,
                    builder: (context, value, _) => m.LinearProgressIndicator(value: value),
                  ),
                  const SizedBox(height: 12),
                  percent(context),
                ],
              ),
              actions: [m.TextButton(onPressed: onCancel, child: Text(t.common.cancel))],
            ),
          );
        },
      );
    }
  });
  return () {
    closed = true;
    timer.cancel();
    final dialog = dialogContext;
    if (dialog != null && dialog.mounted && !popped) {
      popped = true;
      Navigator.of(dialog).pop();
    }
  };
}

/// Полоска прогресса (у Cupertino своей нет).
class _ProgressLine extends StatelessWidget {
  final double value;
  final Color color;

  const _ProgressLine({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: color.withValues(alpha: 0.2)),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0.0, 1.0),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

Future<models.MessageMedia> _prepare(AttachmentDraft item, {bool spoiler = false}) async {
  final photo = item.kind == models.MessageKind.photo ? await prepareChatPhoto(item.path) : null;
  if (photo == null) return models.MessageMedia(kind: item.kind, localPath: item.path, spoiler: spoiler);
  return models.MessageMedia(
    kind: item.kind,
    localPath: photo.path,
    width: photo.width,
    height: photo.height,
    size: photo.size,
    thumbPath: photo.thumbPath,
    thumbhash: photo.thumbhash,
    spoiler: spoiler,
  );
}

const _videoExtensions = {'.mp4', '.mov', '.m4v', '.3gp', '.webm', '.mkv'};
const _imageExtensions = {'.jpg', '.jpeg', '.png', '.heic', '.heif', '.webp', '.gif'};

AttachmentDraft attachmentDraft(String path, {bool asFile = false}) {
  final ext = p.extension(path).toLowerCase();
  // Из таба «Файл» — всегда файлом (фото/видео без сжатия, как в Telegram).
  final kind = asFile
      ? models.MessageKind.file
      : _videoExtensions.contains(ext)
      ? models.MessageKind.video
      : _imageExtensions.contains(ext)
      ? models.MessageKind.photo
      : models.MessageKind.file;
  return AttachmentDraft(path, kind);
}

/// Миниатюра вложения в превью перед отправкой.
class AttachmentThumb extends StatelessWidget {
  final AttachmentDraft item;
  final double size;

  /// «Скрыть под спойлер» — фото/видео размыты с пылью, как уйдут в чат.
  final bool spoiler;

  const AttachmentThumb({super.key, required this.item, required this.size, this.spoiler = false});

  @override
  Widget build(BuildContext context) {
    final Widget child = switch (item.kind) {
      models.MessageKind.photo => Image.file(File(item.path), fit: BoxFit.cover, cacheWidth: (size * 3).round()),
      models.MessageKind.video => _VideoDraftThumb(item: item, size: size),
      _ => ColoredBox(
        color: const Color(0xFF3A3A3C),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              item.kind == models.MessageKind.video ? FontAwesomeIcons.circlePlay : FontAwesomeIcons.solidFile,
              size: 26,
              color: const Color(0xCCFFFFFF),
            ),
            if (item.kind == models.MessageKind.file)
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                child: Text(
                  p.basename(item.path),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: Color(0xCCFFFFFF)),
                ),
              ),
          ],
        ),
      ),
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: IgnorePointer(
          child: MediaSpoiler(enabled: spoiler && item.isMedia, child: child),
        ),
      ),
    );
  }
}

/// Открывает редактор видео [item] (нажатие на миниатюру в листе подписи);
/// `true` — правки изменились, миниатюру нужно перерисовать.
Future<bool> editVideoDraft(BuildContext context, AttachmentDraft item, {required Color accent, required Color onAccent}) async {
  final result = await showChatVideoEditor(context, path: item.path, initial: item.edit, accent: accent, onAccent: onAccent);
  if (result == null) return false;
  item.edit = result.edit;
  return true;
}

/// Миниатюра видео до отправки: кадр (обложка), длительность отрезка, значок
/// «без звука» и карандаш — по нажатию открывается редактор.
class _VideoDraftThumb extends StatelessWidget {
  final AttachmentDraft item;
  final double size;

  const _VideoDraftThumb({required this.item, required this.size});

  @override
  Widget build(BuildContext context) {
    const white = Color(0xFFFFFFFF);
    final edit = item.edit;
    return FutureBuilder(
      future: item.videoPreview,
      builder: (context, snapshot) {
        final preview = snapshot.data;
        final total = preview?.durationMs ?? 0;
        final ms = edit == null ? total : (edit.endMs > 0 ? edit.endMs : total) - edit.startMs;
        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xFF3A3A3C)),
            if (preview != null && preview.thumb.isNotEmpty)
              if (edit != null && edit.changesFrame && preview.width > 0 && preview.height > 0)
                // Кадрирование и поворот — как уйдёт в чат.
                FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: edit.frameSize(preview.width, preview.height).width,
                    height: edit.frameSize(preview.width, preview.height).height,
                    child: ChatVideoReframe(
                      crop: edit.crop,
                      rotation: edit.rotation,
                      sourceAspect: preview.width / preview.height,
                      child: Image.file(File(preview.thumb), fit: BoxFit.fill, gaplessPlayback: true),
                    ),
                  ),
                )
              else
                Image.file(File(preview.thumb), fit: BoxFit.cover, cacheWidth: (size * 3).round(), gaplessPlayback: true),
            const Positioned(
              top: 5,
              right: 5,
              child: _ThumbBadge(child: FaIcon(FontAwesomeIcons.pen, size: 10, color: white)),
            ),
            if (preview != null)
              Positioned(
                left: 5,
                bottom: 5,
                child: _ThumbBadge(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (edit?.mute ?? false) ...[
                        const FaIcon(FontAwesomeIcons.volumeXmark, size: 10, color: white),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        chatVideoTime(Duration(milliseconds: ms)),
                        style: const TextStyle(fontSize: 11, color: white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ThumbBadge extends StatelessWidget {
  final Widget child;

  const _ThumbBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: const Color(0x80000000), borderRadius: BorderRadius.circular(6)),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3), child: child),
    );
  }
}

/// Плашка над полем ввода: «Ответ Анне: …» / «Редактирование: …».
///
/// [quote] — отвечаем на фрагмент («Цитировать»): в [text] — цитата, её
/// разметка — [entities] (рисовать через [composeBannerText]).
({String title, String text, bool quote, List<models.MessageEntity> entities})? composeBanner(Translations t, ChatState state) {
  final forwarding = state.forwarding;
  if (forwarding.isNotEmpty && state.editing == null) {
    String nameOf(models.Message m) => (m.forward?.self ?? m.outgoing) ? t.screenChat.you : (m.forward?.name ?? m.senderName);
    final first = forwarding.first;
    // Одно — его текст, несколько — от кого.
    final text = forwarding.length == 1
        ? (first.text.isNotEmpty ? first.text : messageKindLabel(t, first.kind))
        : t.screenChat.forwardFrom(names: {for (final m in forwarding) nameOf(m)}.where((n) => n.isNotEmpty).join(', '));
    return (title: t.screenChat.forwardMessages(n: forwarding.length), text: text.replaceAll('\n', ' '), quote: false, entities: const []);
  }
  final message = state.editing ?? state.reply;
  if (message == null) return null;
  final text = message.text.isNotEmpty ? message.text : messageKindLabel(t, message.kind);
  if (state.editing != null) {
    // Вложения меняются — что с ними будет (и загрузка при сохранении).
    final draft = state.editMedia;
    final progress = state.editUploadProgress;
    final note = progress != null
        ? t.screenChat.editMediaUploading(percent: (progress * 100).round())
        : draft == null || draft.isEmpty
        ? null
        : draft.added.isNotEmpty
        ? t.screenChat.editMediaAdd(n: draft.added.length)
        : t.screenChat.editMediaReplace;
    return (title: t.screenChat.editing, text: note ?? text.replaceAll('\n', ' '), quote: false, entities: const []);
  }
  final name = message.outgoing ? t.screenChat.you : (message.senderName.isNotEmpty ? message.senderName : state.chat?.title ?? '');
  final quote = state.replyQuote;
  if (quote != null) {
    // Замена \n пробелом длину не меняет — offset'ы разметки те же.
    return (title: t.screenChat.replyQuoteTo(name: name), text: quote.text.replaceAll('\n', ' '), quote: true, entities: quote.entities);
  }
  return (title: name, text: text.replaceAll('\n', ' '), quote: false, entities: const []);
}

/// Строка текста плашки над полем ввода; у цитаты — с её разметкой (спойлер
/// скрыт). [color] — цвет текста, [link] — ссылок.
Widget composeBannerText(
  ({String title, String text, bool quote, List<models.MessageEntity> entities}) banner,
  TextStyle style,
  Color color,
  Color link,
) {
  if (banner.entities.isEmpty) {
    return Text(
      banner.text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style.copyWith(color: color),
    );
  }
  return IgnorePointer(
    child: MessageText(
      text: banner.text,
      entities: banner.entities,
      style: style,
      maxLines: 1,
      colors: MessageTextColors(
        text: color,
        link: link,
        codeBackground: color.withValues(alpha: 0.12),
        spoiler: color.withValues(alpha: 0.3),
        quote: color,
      ),
    ),
  );
}

/// Удаление сообщений [ids] с эффектом «пыли» (как в Telegram): снимки — до
/// запроса (пока строки на экране), и строки держат место в ленте; удалось —
/// они становятся пустым местом, по нему рассыпается пыль, потом место плавно
/// схлопывается ([MessageDust.vanish]). Не удалось (нет сети) — всё как было.
Future<void> deleteWithDust(
  BuildContext context,
  MessageDust cubit,
  List<String> ids,
  GlobalKey Function(String id) keyFor,
  Future<bool> Function() delete,
) async {
  final snapshots = await DustEffect.captureAll(ids.map((id) => keyFor(id).currentContext));
  if (snapshots.isEmpty) {
    await delete();
    return;
  }
  cubit.holdForDust(ids);
  final ok = await delete();
  if (ok && context.mounted) {
    cubit.vanish(ids);
    DustEffect.play(context, snapshots);
  } else {
    cubit.releaseDust(ids);
    for (final snapshot in snapshots) {
      snapshot.dispose();
    }
  }
}

/// Сообщения [ids] удалены не здесь ([MessageDust.dustRequests]): видимые
/// рассыпаются пылью, как при своём удалении; не видно ни одного (вне экрана,
/// слабое устройство) — просто уходят из ленты.
Future<void> dissolveRemoved(BuildContext context, MessageDust cubit, List<String> ids, GlobalKey Function(String id) keyFor) async {
  final snapshots = await DustEffect.captureAll(ids.map((id) => keyFor(id).currentContext));
  if (snapshots.isEmpty || !context.mounted) {
    cubit.releaseDust(ids);
    for (final snapshot in snapshots) {
      snapshot.dispose();
    }
    return;
  }
  cubit.vanish(ids);
  DustEffect.play(context, snapshots);
}

/// Прокрутка ленты сообщений к строке с ключом [key] (поиск по чату). Лента
/// строится лениво: если строки ещё нет, листаем к старым (offset растёт —
/// список перевёрнут), потом к новым, пока она не построится; затем ставим её
/// в середину экрана.
///
/// [alignment] — куда поставить строку: 0 — к низу экрана, 1 — к верху
/// (лента перевёрнута); [duration] `zero` — без анимации.
Future<void> scrollToMessage(
  ScrollController scroll,
  GlobalKey key, {
  double alignment = 0.5,
  Duration duration = const Duration(milliseconds: 250),
}) async {
  if (!scroll.hasClients) return;
  for (final older in [true, false]) {
    for (var i = 0; i < 60 && key.currentContext == null; i++) {
      final position = scroll.position;
      final step = position.viewportDimension * 0.8;
      final target = (older ? position.pixels + step : position.pixels - step).clamp(0.0, position.maxScrollExtent);
      if (target == position.pixels) break;
      scroll.jumpTo(target);
      await WidgetsBinding.instance.endOfFrame;
    }
  }
  final context = key.currentContext;
  if (context == null || !context.mounted) return;
  await Scrollable.ensureVisible(context, alignment: alignment, duration: duration, curve: Curves.easeOutCubic);
}

/// Навигация по ленте чата (как в Telegram):
/// - при открытии — к разделителю «Непрочитанные сообщения»;
/// - кнопка «вниз» ([showDown]) со счётчиком новых входящих ниже экрана
///   ([unread]); после перехода по цитате она сначала возвращает к сообщению,
///   с которого перешли;
/// - тап по цитате — к исходному сообщению с подсветкой ([flashID]); его
///   нет в ленте (старое) — сначала [reveal] (окно вокруг него);
/// - своё новое сообщение — лента прокручивается вниз;
/// - лента — окно «вокруг сообщения» ([detached]): у его конца — [loadNewer]
///   с удержанием места, «вниз» видна всегда и ведёт к самому новому
///   ([toLatest]).
class ChatScrollTracker extends ChangeNotifier {
  final ScrollController scroll;
  final GlobalKey Function(String id) keyFor;
  final Future<void> Function(String id)? reveal;
  final Future<void> Function()? toLatest;
  final Future<bool> Function()? loadNewer;

  ChatScrollTracker(this.scroll, this.keyFor, {this.reveal, this.toLatest, this.loadNewer}) {
    scroll.addListener(_onScroll);
  }

  bool showDown = false;

  /// Лента — окно «вокруг сообщения», новее есть ещё (`ChatState.hasNewer`).
  bool detached = false;
  bool _loadingNewer = false;
  int unread = 0;
  String? flashID;

  /// Ответ на фрагмент: он подсвечен в тексте [flashID].
  (int, int)? flashRange;

  List<models.Message> _messages = const [];

  /// Входящие новее этой даты пользователь ещё не видел (счётчик на «вниз»).
  DateTime? _seenUntil;
  bool _unreadApplied = false;

  /// Откуда переходили по цитатам — «вниз» возвращает туда по очереди.
  final _returnTo = <String>[];
  Timer? _flashTimer;

  bool get _atBottom => !scroll.hasClients || scroll.offset < 40;

  @override
  void dispose() {
    scroll.removeListener(_onScroll);
    _flashTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final show = detached || (scroll.hasClients && scroll.offset > 300);
    var changed = show != showDown;
    showDown = show;
    if (detached && scroll.hasClients && scroll.offset < 600) unawaited(_loadNewer());
    if (_atBottom && !detached) {
      _returnTo.clear();
      changed |= _markSeen();
    }
    if (changed) notifyListeners();
  }

  /// Внизу — всё прочитано.
  bool _markSeen() {
    if (_messages.isNotEmpty) _seenUntil = _messages.last.date;
    final changed = unread != 0;
    unread = 0;
    return changed;
  }

  /// Конец окна «вокруг сообщения» — страница новее; лента остаётся на том
  /// же сообщении (список перевёрнут: новое внизу сдвинуло бы экран).
  Future<void> _loadNewer() async {
    final load = loadNewer;
    if (load == null || _loadingNewer || _messages.isEmpty) return;
    _loadingNewer = true;
    final anchor = _messages.last.id;
    try {
      if (!await load()) return;
      await WidgetsBinding.instance.endOfFrame;
      await scrollToMessage(scroll, keyFor(anchor), alignment: 1, duration: Duration.zero);
    } finally {
      _loadingNewer = false;
    }
  }

  /// Новые сообщения / разделитель из [ChatState]; [detached] — лента — окно
  /// «вокруг сообщения».
  void update(List<models.Message> messages, String? unreadFromID, {bool detached = false}) {
    final previous = _messages;
    final wasDetached = this.detached;
    _messages = messages;
    this.detached = detached;
    if (detached != wasDetached) {
      showDown = detached || (scroll.hasClients && scroll.offset > 300);
      notifyListeners();
    }
    if (messages.isEmpty || detached) return;
    _seenUntil ??= messages.last.date;

    if (!_unreadApplied && unreadFromID != null) {
      _unreadApplied = true;
      final i = messages.indexWhere((m) => m.id == unreadFromID);
      if (i >= 0) {
        _seenUntil = i > 0 ? messages[i - 1].date : messages.first.date.subtract(const Duration(microseconds: 1));
        _recount();
        notifyListeners();
        // Разделитель — у верха экрана, после первой отрисовки ленты.
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await scrollToMessage(scroll, keyFor(ChatMessagesView.unreadDividerID), alignment: 0.95, duration: Duration.zero);
          _onScroll();
        });
        return;
      }
    }

    // Своё новое сообщение — вниз, к нему.
    final last = messages.last;
    if (previous.isNotEmpty && last.outgoing && !previous.any((m) => m.id == last.id)) {
      jumpToBottom();
    }
    if (_atBottom) {
      _markSeen();
    } else {
      _recount();
    }
    notifyListeners();
  }

  void _recount() {
    final seen = _seenUntil;
    unread = seen == null ? 0 : _messages.where((m) => !m.outgoing && !m.service && m.date.isAfter(seen)).length;
  }

  /// Тап по цитате ответа в [from] — к исходному сообщению.
  Future<void> jumpToReply(models.Message from) async {
    final reply = from.reply;
    if (reply == null) return;
    var original = _messages.where((m) => m.id == reply.messageID).firstOrNull;
    // Старое, не в ленте, — окно вокруг него.
    if (original == null && reveal != null) {
      await reveal!(reply.messageID);
      await WidgetsBinding.instance.endOfFrame;
      original = _messages.where((m) => m.id == reply.messageID).firstOrNull;
    }
    if (original == null) return;
    _returnTo.add(from.id);
    final quote = reply.quote;
    await _jumpTo(original.id, range: quote == null ? null : locateQuote(original.text, quote));
  }

  /// Кнопка «вниз»: назад к сообщению, с которого перешли по цитате, иначе —
  /// в самый низ.
  Future<void> down() async {
    while (_returnTo.isNotEmpty) {
      final id = _returnTo.removeLast();
      if (_messages.any((m) => m.id == id)) return _jumpTo(id);
    }
    // Окно «вокруг сообщения» — к самому новому: снова обычная лента.
    if (detached && toLatest != null) {
      await toLatest!();
      await WidgetsBinding.instance.endOfFrame;
      if (scroll.hasClients) scroll.jumpTo(0);
      return;
    }
    await jumpToBottom();
  }

  Future<void> jumpToBottom() async {
    if (!scroll.hasClients) return;
    // Издалека — сначала прыжок поближе, чтобы не листать всю историю.
    final near = scroll.position.viewportDimension;
    if (scroll.offset > near * 3) scroll.jumpTo(near);
    await scroll.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic);
  }

  /// Перейти к сообщению [id] с подсветкой (плашка закреплённых).
  Future<void> jumpTo(String id) => _jumpTo(id);

  /// [range] — подсветить ещё и фрагмент текста (цитата); его держим
  /// дольше, чтобы успеть прочитать.
  Future<void> _jumpTo(String id, {(int, int)? range}) async {
    await scrollToMessage(scroll, keyFor(id));
    flashID = id;
    flashRange = range;
    notifyListeners();
    _flashTimer?.cancel();
    _flashTimer = Timer(Duration(milliseconds: range == null ? 900 : 1600), () {
      flashID = null;
      flashRange = null;
      notifyListeners();
    });
  }
}

/// Круглая кнопка «вниз» в правом нижнем углу ленты, со счётчиком новых.
class ChatScrollDownButton extends StatelessWidget {
  final ChatScrollTracker tracker;
  final Color background;
  final Color iconColor;
  final Color badgeColor;
  final Color badgeTextColor;

  const ChatScrollDownButton({
    super.key,
    required this.tracker,
    required this.background,
    required this.iconColor,
    required this.badgeColor,
    this.badgeTextColor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: tracker,
      builder: (context, _) {
        final visible = tracker.showDown;
        return IgnorePointer(
          ignoring: !visible,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            child: AnimatedScale(
              scale: visible ? 1 : 0.6,
              duration: const Duration(milliseconds: 180),
              child: GestureDetector(
                onTap: tracker.down,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: background,
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 1))],
                      ),
                      child: FaIcon(FontAwesomeIcons.chevronDown, size: 18, color: iconColor),
                    ),
                    if (tracker.unread > 0)
                      Positioned(
                        top: -9,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '${tracker.unread}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: badgeTextColor),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Круглая кнопка ❤️ над кнопкой «вниз» (как в Telegram): есть наши
/// сообщения с непрочитанными реакциями ([count]); тап — к самому старому.
/// Она же «@» (упоминания нас, [icon]) — ещё выше на [above] видимых кнопок
/// (❤️). Кнопка «вниз» спрятана — опускаются на её место. Положение — сама
/// (Positioned), класть прямо в Stack ленты.
class ChatReactionsButton extends StatelessWidget {
  final ChatScrollTracker tracker;
  final int count;
  final VoidCallback onTap;
  final Color background;
  final Color iconColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final FaIconData icon;
  final int above;

  const ChatReactionsButton({
    super.key,
    required this.tracker,
    required this.count,
    required this.onTap,
    required this.background,
    required this.iconColor,
    required this.badgeColor,
    this.badgeTextColor = const Color(0xFFFFFFFF),
    this.icon = FontAwesomeIcons.heart,
    this.above = 0,
  });

  @override
  Widget build(BuildContext context) {
    final visible = count > 0;
    return ListenableBuilder(
      listenable: tracker,
      builder: (context, _) => AnimatedPositioned(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        right: 10,
        bottom: (tracker.showDown ? 62 : 10) + above * 52.0,
        child: IgnorePointer(
          ignoring: !visible,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            child: AnimatedScale(
              scale: visible ? 1 : 0.6,
              duration: const Duration(milliseconds: 180),
              child: GestureDetector(
                onTap: onTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: background,
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 1))],
                      ),
                      child: FaIcon(icon, size: 18, color: iconColor),
                    ),
                    if (visible)
                      Positioned(
                        top: -9,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '$count',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: badgeTextColor),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Цвета плашки закреплённого — свои у Cupertino и Material.
class PinnedBarStyle {
  final Color background;
  final Color accent;
  final Color text;
  final Color secondary;
  final Color separator;

  const PinnedBarStyle({
    required this.background,
    required this.accent,
    required this.text,
    required this.secondary,
    required this.separator,
  });
}

/// Плашка закреплённого под шапкой (как в Telegram): слева полоска-индикатор
/// (несколько закреплённых — по сегменту на каждое, до 4), «Закреплённое
/// сообщение #N», превью фото/видео и текст. Тап — к сообщению; справа —
/// список всех закреплённых (если их несколько) или крестик «открепить».
class PinnedMessageBar extends StatelessWidget {
  static const height = 52.0;

  /// От новых к старым ([ChatState.pinnedMessages]); показывается [index]-е.
  final List<models.Message> pinned;
  final int index;
  final PinnedBarStyle style;
  final VoidCallback onTap;

  /// `null` — открепить нельзя (канал для подписчика).
  final VoidCallback? onUnpin;

  /// Экран «Закреплённые сообщения» — значок списка вместо крестика, когда
  /// закреплённых несколько.
  final VoidCallback? onList;

  const PinnedMessageBar({
    super.key,
    required this.pinned,
    required this.index,
    required this.style,
    required this.onTap,
    this.onUnpin,
    this.onList,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final i = index % pinned.length;
    final message = pinned[i];
    // Номер — от старого (#1) к новому, как в Telegram.
    final number = pinned.length - i;
    final text = message.text.isNotEmpty ? message.text : messageKindLabel(t, message.kind);
    final segments = math.min(pinned.length, 4);
    final current = (number - 1) % segments;
    final thumb = messageMediaThumb(message);
    final showList = pinned.length > 1 && onList != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: style.background,
          border: Border(bottom: BorderSide(color: style.separator, width: 0.5)),
        ),
        padding: const EdgeInsets.only(left: 14),
        child: Row(
          children: [
            SizedBox(
              width: 2.5,
              height: 34,
              child: Column(
                children: [
                  for (var s = 0; s < segments; s++) ...[
                    if (s > 0) const SizedBox(height: 2),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          // Сверху — новые: текущий сегмент считается снизу.
                          color: style.accent.withValues(alpha: segments - 1 - s == current ? 1 : 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                // По умолчанию AnimatedSwitcher центрирует — текст прижат влево.
                layoutBuilder: (current, previous) => Stack(alignment: Alignment.centerLeft, children: [...previous, ?current]),
                child: Row(
                  key: ValueKey(message.id),
                  children: [
                    if (thumb != null) ...[thumb, const SizedBox(width: 8)],
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  pinned.length > 1 ? t.screenChat.pinnedNumber(n: number) : t.screenChat.pinnedTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: style.accent),
                                ),
                              ),
                              const SizedBox(width: 4),
                              // Залитая — у обоих, контурная — только у меня.
                              PinIcon(onlyMe: message.pinnedOnlyMe, size: 13, color: style.accent),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Text(
                            text.replaceAll('\n', ' '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14, color: style.text),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showList)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onList,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: FaIcon(FontAwesomeIcons.listUl, size: 17, color: style.secondary),
                ),
              )
            else if (onUnpin != null)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onUnpin,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: FaIcon(FontAwesomeIcons.xmark, size: 16, color: style.secondary),
                ),
              )
            else
              const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}

/// Обои из «Тем для чатов» (Настройки → Оформление) на всю площадь —
/// фон ленты чата и экрана «Закреплённые сообщения».
class ChatWallpaperLayer extends StatelessWidget {
  final bool dark;

  const ChatWallpaperLayer({super.key, required this.dark});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommonCubit, CommonState>(
      buildWhen: (previous, current) =>
          previous.settingsDevice.chatWallpaper != current.settingsDevice.chatWallpaper ||
          previous.settingsDevice.chatWallpaperColor != current.settingsDevice.chatWallpaperColor ||
          previous.settingsDevice.chatWallpaperIntensity != current.settingsDevice.chatWallpaperIntensity,
      builder: (context, common) => ChatWallpaper(
        pattern: common.settingsDevice.chatWallpaper,
        colorIndex: common.settingsDevice.chatWallpaperColor,
        intensity: common.settingsDevice.chatWallpaperIntensity,
        dark: dark,
      ),
    );
  }
}

/// Ссылка в набираемом тексте [raw] (markdown-ярлыки учитываются) — над
/// полем ввода плашка «Предпросмотр ссылки» с ×; `null` — ссылки нет.
String? composeLinkUrl(String raw) {
  if (!raw.contains('.')) return null;
  final (text, entities) = parseMarkdownShortcuts(raw);
  return firstLinkUrl(text, entities);
}

/// Подсказка упоминаний в поле ввода группы: «@» + начало имени или
/// @username перед курсором → участники ([suggestions]); выбор — вставляет
/// `@username ` (или имя, если username нет — запоминается для `mentionName`).
class ComposeMentions extends ChangeNotifier {
  ComposeMentions(this.input) {
    input.addListener(_update);
  }

  final TextEditingController input;

  /// Подсказка работает (группа / сообщество / комментарии).
  bool enabled = false;

  /// Участники чата (без нас).
  List<models.ChatMember> members = const [];

  /// Упомянутые по имени — уходят в `ChatCubit.send(mentions:)`.
  final _picked = <models.ChatMember>[];

  String? _query;
  int _start = 0;

  static final _pattern = RegExp(r'(?:^|\s)@([\p{L}\p{N}_]*)$', unicode: true);

  void _update() {
    String? query;
    final selection = input.selection;
    if (enabled && selection.isValid && selection.isCollapsed) {
      final before = input.text.substring(0, selection.baseOffset);
      final match = _pattern.firstMatch(before);
      if (match != null) {
        query = match.group(1)!;
        _start = selection.baseOffset - query.length - 1;
      }
    }
    if (query == _query) return;
    _query = query;
    notifyListeners();
  }

  List<models.ChatMember> get suggestions {
    final query = _query?.toLowerCase();
    if (query == null) return const [];
    bool fits(models.ChatMember m) =>
        m.username.toLowerCase().startsWith(query) || m.name.toLowerCase().split(' ').any((word) => word.startsWith(query));
    return [
      for (final m in members)
        if (!m.isSelf && fits(m)) m,
    ].take(20).toList();
  }

  void pick(models.ChatMember member) {
    final end = input.selection.baseOffset;
    if (end < _start) return;
    final insert = member.username.isNotEmpty ? '@${member.username} ' : '${member.name} ';
    if (member.username.isEmpty && !_picked.any((m) => m.id == member.id)) _picked.add(member);
    final text = input.text.replaceRange(_start, end, insert);
    input.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: _start + insert.length),
    );
  }

  /// Упомянутые по имени для отправки (и сброс).
  List<models.ChatMember> take() {
    final result = [..._picked];
    _picked.clear();
    return result;
  }

  @override
  void dispose() {
    input.removeListener(_update);
    super.dispose();
  }
}

/// Список подсказок «@» над полем ввода: аватар, имя, @username. Пусто — ничего.
class MentionSuggestions extends StatelessWidget {
  final ComposeMentions mentions;
  final Color background;
  final Color text;
  final Color secondary;
  final Color separator;

  const MentionSuggestions({
    super.key,
    required this.mentions,
    required this.background,
    required this.text,
    required this.secondary,
    required this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: mentions,
      builder: (context, _) {
        final items = mentions.suggestions;
        if (items.isEmpty) return const SizedBox.shrink();
        return Container(
          constraints: const BoxConstraints(maxHeight: 4.5 * 48),
          decoration: BoxDecoration(
            color: background,
            border: Border(top: BorderSide(color: separator, width: 0.5)),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final member = items[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => mentions.pick(member),
                child: SizedBox(
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        ContactAvatar(contact: member, size: 32),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            member.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: text),
                          ),
                        ),
                        if (member.username.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text('@${member.username}', style: TextStyle(fontSize: 14, color: secondary)),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Удаление чата с выбором «У меня» / «У меня и собеседника» — личный, кроме
/// «Избранного» и «Iperon» (у собеседника история тоже очищается, чат пропадает из его
/// списка). Так же — удаление и закрепление сообщений в нём. Выбор — отдельным
/// меню после пункта действий: на iOS выпадающим ([scopeMenuCupertino] в
/// chat_actions_cupertino.dart), на Android шторкой ([pickScopeMaterial] в
/// chat_actions_material.dart).
bool chatDeleteScoped(models.Chat chat) => chat.type == models.ChatType.private && !chat.isSelf && !chat.isSystem;

/// Просмотры постов канала (подэтап 4.2): раз в [_interval] — какие посты
/// сейчас на экране ([ChatCubit.postsVisible]; дальше — `ChannelViews`).
/// Окно не наверху (открыт другой экран) или приложение в фоне — на экране
/// ничего. Только если [ChatCubit.tracksViews].
class ChannelViewsSampler {
  final ChatCubit cubit;
  final ScrollController scroll;
  final GlobalKey Function(String id) keyFor;

  /// Окно чата сейчас видно пользователю (его маршрут — верхний).
  final bool Function() active;

  ChannelViewsSampler({required this.cubit, required this.scroll, required this.keyFor, required this.active}) {
    _timer = Timer.periodic(_interval, (_) => _sample());
  }

  /// Чаще порога «≥ 0,5 с на экране», чтобы он соблюдался с точностью шага.
  static const _interval = Duration(milliseconds: 250);

  late final Timer _timer;

  void dispose() => _timer.cancel();

  void _sample() {
    if (!cubit.tracksViews) return;
    final shown = active() && WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    cubit.postsVisible(shown ? visibleMessageIDs(scroll, cubit.state.messages, keyFor) : const []);
  }
}

/// id сообщений [messages], которые сейчас на экране ленты [scroll]: видна
/// хотя бы половина пузыря (у длинного — половина высоты ленты).
List<String> visibleMessageIDs(ScrollController scroll, List<models.Message> messages, GlobalKey Function(String id) keyFor) {
  if (!scroll.hasClients) return const [];
  final viewport = scroll.position.context.storageContext.findRenderObject();
  if (viewport is! RenderBox || !viewport.attached || !viewport.hasSize) return const [];
  final top = viewport.localToGlobal(Offset.zero).dy;
  final height = viewport.size.height;
  final bottom = top + height;
  return [
    for (final message in messages)
      if (keyFor(message.id).currentContext?.findRenderObject() case final RenderBox box when box.attached && box.hasSize)
        if (_overlap(box, top, bottom) case final overlap when overlap > 0 && (overlap >= box.size.height / 2 || overlap >= height / 2))
          message.id,
  ];
}

double _overlap(RenderBox box, double top, double bottom) {
  final y = box.localToGlobal(Offset.zero).dy;
  return math.min(bottom, y + box.size.height) - math.max(top, y);
}
