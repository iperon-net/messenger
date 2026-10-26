import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart' as m;

import '../../split_layout.dart';
import '../../auth.dart';
import '../../chats/chats_sync.dart' show ChatsOfflineException, ChatsFloodException;
import '../../chats/secret/secret_chats_list.dart';
import '../../chats/secret/secret_chats_sync.dart';
import '../../components.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../platform.dart';
import '../../models.dart' as models;
import '../../repositories.dart';
import '../../settings.dart';
import '../../utils.dart';
import 'chat_common.dart';

/// Общее для окна секретного чата и его экрана ключа (Cupertino + Material).

/// Куда открывать строку списка чатов: секретный — своё окно.
String chatRoute(models.Chat chat) => chat.isSecret
    ? '/chats/secret/${chat.id.substring(secretChatIDPrefix.length)}'
    : (chat.isReplies ? '/chats/replies' : '/chats/chat/${chat.id}');

/// «Начать секретный чат» (меню «Ещё» профиля чата): не себе, фича включена,
/// при «только Premium» — у меня Premium (принять запрос может любой — это не
/// про кнопку).
Future<bool> secretChatAvailable(List<int> peerUserID) async {
  final settings = getIt.get<Settings>();
  final me = getIt.get<Auth>().session.userID;
  // Десктоп секретные чаты не умеет (docs/plans/desktop-client.md §3.7).
  if (!AppPlatform.hasSecretChats) return false;
  if (peerUserID.isEmpty || listEquals(me, peerUserID) || !settings.secretChatsEnabled) return false;
  if (!settings.secretChatsPremiumOnly) return true;
  return getIt.get<Repositories>().myProfile.isPremium(userID: me);
}

var _secretChatStarting = false;

/// Начать секретный чат с [peerUserID] и открыть его. Нужна сеть; ошибка (нет
/// сети, нет Premium, у собеседника нет поддержки…) — iOS алертом, Android —
/// SnackBar.
Future<void> startSecretChat(BuildContext context, List<int> peerUserID) async {
  if (_secretChatStarting) return;
  _secretChatStarting = true;
  final t = context.t;
  String error;
  try {
    final chatID = await SecretChatsSync.instance.create(peerUserID);
    if (context.mounted) await openChat(context, '/chats/secret/${getIt.get<Utils>().bytesToHex(chatID)}');
    return;
  } on ChatsOfflineException {
    error = t.common.noConnectionTitle;
  } on ChatsFloodException {
    error = t.secretChat.errorFlood;
  } on SecretChatRequestException catch (e) {
    final ts = t.secretChat;
    error = e.isPremiumRequired
        ? ts.errorPremiumRequired
        : e.isPeerUnsupported
        ? ts.errorPeerUnsupported
        : e.isDisabled
        ? ts.errorDisabled
        : e.isFrozen
        ? ts.errorFrozen
        : e.isPrivacyRestricted
        ? ts.errorPrivacyRestricted
        : ts.errorGeneric;
  } catch (e, stackTrace) {
    getIt.get<Logger>().handle(e, stackTrace);
    error = t.secretChat.errorGeneric;
  } finally {
    _secretChatStarting = false;
  }
  if (!context.mounted) return;
  final message = error;
  if (Platform.isIOS) {
    await c.showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => c.CupertinoAlertDialog(
        title: Text(t.secretChat.title),
        content: Text(message),
        actions: [
          c.CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.of(dialogContext).pop(), child: Text(t.common.close)),
        ],
      ),
    );
  } else {
    m.ScaffoldMessenger.of(context).showSnackBar(m.SnackBar(content: Text(message)));
  }
}

/// iOS: варианты таймера самоуничтожения для выпадающего меню (галочка у
/// текущего).
List<Widget> secretTtlMenuCupertino(BuildContext context, int current, ValueChanged<int> onPicked) {
  final t = context.t;
  return [
    for (final seconds in secretTtlOptions)
      c.CupertinoMenuItem(
        trailing: current == seconds ? const Icon(c.CupertinoIcons.checkmark) : null,
        onPressed: () => onPicked(seconds),
        child: Text(secretTtlLabel(t, seconds)),
      ),
  ];
}

/// Android: нижний лист с вариантами таймера; `null` — закрыли.
Future<int?> pickSecretTtlMaterial(BuildContext context, int current) {
  final t = context.t;
  return m.showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(t.secretChat.ttl, style: m.Theme.of(sheetContext).textTheme.titleMedium),
          ),
          for (final seconds in secretTtlOptions)
            m.ListTile(
              leading: m.Icon(seconds == 0 ? m.Icons.timer_off_outlined : m.Icons.timer_outlined),
              title: Text(secretTtlLabel(t, seconds)),
              trailing: current == seconds ? const m.Icon(m.Icons.check) : null,
              onTap: () => Navigator.of(sheetContext).pop(seconds),
            ),
        ],
      ),
    ),
  );
}

/// Скрепка: фото / видео из галереи или файл → превью с подписью (сжатие —
/// как в обычных чатах) → отправка. Каждое вложение — отдельным сообщением,
/// подпись — у первого; текст из поля ввода [input] переносится в подпись.
Future<void> pickSecretAttachments(BuildContext context, {TextEditingController? input}) async {
  final cubit = context.read<SecretChatCubit>();
  final result = await showToolbarAttachments(
    context,
    tabs: const [ToolbarAttachmentTabKind.gallery, ToolbarAttachmentTabKind.file],
    media: ToolbarAttachmentMediaType.all,
    multiSelect: true,
  );
  final items = switch (result) {
    ToolbarAttachmentImageResult(:final file, :final source) => [
      attachmentDraft(file.path, asFile: source == ToolbarAttachmentTabKind.file),
    ],
    ToolbarAttachmentMultiImageResult(:final files, :final source) => [
      for (final file in files) attachmentDraft(file.path, asFile: source == ToolbarAttachmentTabKind.file),
    ],
    ToolbarAttachmentEmojiResult() || ToolbarAttachmentLinkResult() || ToolbarAttachmentPollResult() || null => const <AttachmentDraft>[],
  };
  if (items.isEmpty || !context.mounted) return;
  final prepared = await prepareAttachmentDrafts(context, items, input: input);
  if (prepared == null) return;
  await cubit.sendMedia(media: prepared.media, files: [for (final file in prepared.files) file.path], caption: prepared.caption);
}

/// Тап по вложению: файл — открыть, фото / видео — просмотр без «Сохранить /
/// Поделиться» (как с защитой содержимого).
Future<void> openSecretMedia(BuildContext context, SecretChatState state, models.Message message, int index) {
  if (message.kind == models.MessageKind.file) return openChatFile(context, message);
  return showChatMediaViewer(context, messages: state.messages, message: message, index: index, chatTitle: state.title, noForwards: true);
}

/// Подзаголовок шапки / текст вместо поля ввода по состоянию чата.
String secretChatStatusText(Translations t, models.SecretChatStatus status, String name) => switch (status) {
  models.SecretChatStatus.waiting => t.secretChat.waitingFor(name: name),
  models.SecretChatStatus.ready => t.secretChat.title,
  models.SecretChatStatus.closed => t.secretChat.closed,
};

/// Отпечаток ключа: крупные эмодзи и hex по 8 символов в 4 строки (как
/// «Ключ шифрования» в Telegram), моноширинным.
class SecretChatFingerprintView extends StatelessWidget {
  final List<String> emoji;
  final String hex;
  final Color hexColor;

  const SecretChatFingerprintView({super.key, required this.emoji, required this.hex, required this.hexColor});

  @override
  Widget build(BuildContext context) {
    final groups = [for (var i = 0; i + 8 <= hex.length; i += 8) hex.substring(i, i + 8)];
    final lines = [for (var i = 0; i < groups.length; i += 2) groups.skip(i).take(2).join('  ')];
    return Column(
      children: [
        Text(emoji.join('  '), style: const TextStyle(fontSize: 40), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        for (final line in lines)
          Text(
            line.toUpperCase(),
            style: TextStyle(fontFamily: 'Courier', fontSize: 17, letterSpacing: 1.5, color: hexColor),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}

/// Обои из «Тем для чатов» (Настройки → Оформление) — как в обычных чатах.
class SecretChatWallpaper extends StatelessWidget {
  final bool dark;

  const SecretChatWallpaper({super.key, required this.dark});

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
