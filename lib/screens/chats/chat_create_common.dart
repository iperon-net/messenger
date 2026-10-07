import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart' show XFile;

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_info_common.dart';

/// Общее для экранов «Новое» (Cupertino + Material): выбор фото чата, аватар и
/// статус контакта, тексты формы по типу чата.

/// Фото группы/канала/сообщества: галерея → кроп 1:1 (круг; у сообщества —
/// квадрат, его аватар — скруглённый квадрат). Возвращает путь к файлу или
/// `null` (лист закрыли). Как аватар профиля — ужимаем до 512 px.
Future<String?> pickChatPhoto(BuildContext context, models.ChatType type) async {
  final title = context.t.screenNewChat.editPhoto;
  final cropStyle = type == models.ChatType.community ? CropStyle.rectangle : CropStyle.circle;
  final result = await showToolbarAttachments(
    context,
    tabs: const [ToolbarAttachmentTabKind.gallery],
    processImage: (file) async {
      final cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        maxWidth: 512,
        maxHeight: 512,
        uiSettings: [
          IOSUiSettings(title: title, cropStyle: cropStyle, aspectRatioLockEnabled: true, resetAspectRatioEnabled: false),
          AndroidUiSettings(toolbarTitle: title, cropStyle: cropStyle, lockAspectRatio: true),
        ],
      );
      return cropped == null ? null : XFile(cropped.path);
    },
  );
  return switch (result) {
    ToolbarAttachmentImageResult(:final file) => file.path,
    _ => null,
  };
}

/// Аватар контакта — тот же плейсхолдер, что у личного чата с ним (по id).
class ContactAvatar extends StatelessWidget {
  final models.ChatMember contact;
  final double size;

  const ContactAvatar({super.key, required this.contact, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: BoringAvatar(name: contact.id, type: BoringAvatarType.beam, shape: const CircleBorder()),
    );
  }
}

/// «в сети» / «был(а) …» под именем контакта.
({String text, bool online}) contactStatus(Translations t, models.ChatMember contact) {
  final seen = contact.lastSeen;
  if (contact.online) return (text: t.screenChat.online, online: true);
  return (text: seen == null ? t.screenChat.lastSeenRecently : lastSeenText(t, seen), online: false);
}

/// Заголовок формы создания.
String createTitle(Translations t, models.ChatType type) => switch (type) {
  models.ChatType.channel => t.screenNewChat.channelTitle,
  models.ChatType.community => t.screenNewChat.communityTitle,
  _ => t.screenNewChat.groupTitle,
};

/// Подсказка поля названия.
String createNameHint(Translations t, models.ChatType type) => switch (type) {
  models.ChatType.channel => t.screenNewChat.channelName,
  models.ChatType.community => t.screenNewChat.communityName,
  _ => t.screenNewChat.groupName,
};

/// Подпись под описанием (у группы описания в форме нет).
String createDescriptionFooter(Translations t, models.ChatType type) =>
    type == models.ChatType.community ? t.screenNewChat.communityDescriptionFooter : t.screenNewChat.channelDescriptionFooter;

/// Подпись под выбором «Публичный / Частный».
String createTypeFooter(Translations t, models.ChatType type, bool isPublic) => switch ((type, isPublic)) {
  (models.ChatType.community, true) => t.screenNewChat.communityPublicFooter,
  (models.ChatType.community, false) => t.screenNewChat.communityPrivateFooter,
  (_, true) => t.screenNewChat.channelPublicFooter,
  (_, false) => t.screenNewChat.channelPrivateFooter,
};

/// Строка под полем публичной ссылки: подсказка / проверка / ошибка.
({String text, bool error, bool ok}) usernameHint(Translations t, ChatCreateState state) => switch (state.usernameStatus) {
  ChatUsernameStatus.empty => (text: t.screenNewChat.usernameEmpty, error: false, ok: false),
  ChatUsernameStatus.invalid => (text: t.screenNewChat.usernameInvalid, error: true, ok: false),
  ChatUsernameStatus.checking => (text: t.screenNewChat.usernameChecking, error: false, ok: false),
  ChatUsernameStatus.available => (text: t.screenNewChat.usernameAvailable, error: false, ok: true),
  ChatUsernameStatus.taken => (text: t.screenNewChat.usernameTaken, error: true, ok: false),
};

/// Выбранное фото в форме: круг (у сообщества — скруглённый квадрат), как
/// потом в [ChatAvatar].
class ChatPhotoPreview extends StatelessWidget {
  final String path;
  final models.ChatType type;
  final double size;

  const ChatPhotoPreview({super.key, required this.path, required this.type, this.size = 72});

  @override
  Widget build(BuildContext context) {
    final shape = type == models.ChatType.community
        ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(size * 0.28))
        : const CircleBorder();
    return ClipPath(
      clipper: ShapeBorderClipper(shape: shape),
      child: Image.file(File(path), width: size, height: size, fit: BoxFit.cover, cacheWidth: (size * 3).round()),
    );
  }
}

/// Варианты вступления в форме «Изменить»: у канала — «Публичный / Частный»,
/// у группы и сообщества — все четыре.
List<models.ChatJoinMode> joinModesOf(models.ChatType type) =>
    type == models.ChatType.channel ? const [models.ChatJoinMode.open, models.ChatJoinMode.link] : models.ChatJoinMode.values;

String joinModeLabel(Translations t, models.ChatType type, models.ChatJoinMode mode) => switch (mode) {
  models.ChatJoinMode.open when type == models.ChatType.channel => t.screenNewChat.typePublic,
  models.ChatJoinMode.link when type == models.ChatType.channel => t.screenNewChat.typePrivate,
  models.ChatJoinMode.open => t.screenNewChat.joinOpen,
  models.ChatJoinMode.link => t.screenNewChat.joinLink,
  models.ChatJoinMode.request => t.screenNewChat.joinRequest,
  models.ChatJoinMode.admins => t.screenNewChat.joinAdmins,
};

/// Подпись под выбором вступления: у канала (и при создании) — как
/// «Публичный / Частный».
String joinModeFooter(Translations t, ChatCreateState state) {
  if (state.type == models.ChatType.channel || !state.isEdit) return createTypeFooter(t, state.type, state.isPublic);
  return switch (state.joinMode) {
    models.ChatJoinMode.open => t.screenNewChat.joinOpenFooter,
    models.ChatJoinMode.link => t.screenNewChat.joinLinkFooter,
    models.ChatJoinMode.request => t.screenNewChat.joinRequestFooter,
    models.ChatJoinMode.admins => t.screenNewChat.joinAdminsFooter,
  };
}

String defaultRoleLabel(Translations t, models.ChatRole role) =>
    role == models.ChatRole.writer ? t.screenNewChat.roleWriter : t.screenNewChat.roleReader;

String defaultRoleFooter(Translations t, models.ChatRole role) =>
    role == models.ChatRole.writer ? t.screenNewChat.roleWriterFooter : t.screenNewChat.roleReaderFooter;
