import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../chats/media_files.dart';
import '../../i18n/translations.g.dart';
import '../../platform.dart';
import '../../models.dart' as models;
import 'chat_toast.dart';

/// Действия с вложениями сообщения (меню сообщения, просмотр медиа):
/// открыть файл, копировать фото / видео в буфер обмена, сохранить, поделиться.
/// [index] — один элемент альбома (`null` — все вложения сообщения).
/// [overlay] — уведомления плашкой и на Android (экран без Scaffold).

/// Есть ли у сообщения вложения, с которыми это можно делать.
bool chatMediaActionable(models.Message m) =>
    !m.service &&
    (m.isAlbum || m.kind == models.MessageKind.photo || m.kind == models.MessageKind.video || m.kind == models.MessageKind.file);

/// Файл (документ), а не фото / видео.
bool _isFile(models.Message m) => !m.isAlbum && m.kind == models.MessageKind.file;

/// Подпись «Сохранить …»: файл — в «Файлы» (iOS) / «Загрузки» (Android), фото
/// и видео — в галерею.
String chatMediaSaveLabel(Translations t, models.Message m) =>
    _isFile(m) ? (Platform.isIOS ? t.screenChat.saveToFiles : t.screenChat.saveToDownloads) : t.screenChat.saveToGallery;

/// Вложения как файлы для системы; `null` — какое-то ещё не скачано.
List<MediaFile>? _files(models.Message m, int? index) {
  final stamp = DateFormat('yyyyMMdd_HHmmss').format(m.date);
  if (_isFile(m)) {
    return _ready(m.localPath) ? [MediaFile(m.localPath, name: m.fileName)] : null;
  }
  final items = m.isAlbum
      ? [for (final (i, media) in m.media.indexed) (i: i, path: media.localPath, video: media.kind == models.MessageKind.video)]
      : [(i: 0, path: m.localPath, video: m.kind == models.MessageKind.video)];
  final chosen = index == null ? items : items.where((item) => item.i == index).toList();
  if (chosen.isEmpty || chosen.any((item) => !_ready(item.path))) return null;
  return [
    for (final item in chosen)
      // В галерее и у других приложений — «Iperon_дата», а не id файла в кэше.
      MediaFile(item.path, name: 'Iperon_$stamp${item.i > 0 ? '_${item.i + 1}' : ''}${p.extension(item.path)}', video: item.video),
  ];
}

bool _ready(String path) => path.isNotEmpty && File(path).existsSync();

/// Открыть файл: iOS — просмотр Quick Look, Android — приложение для этого
/// типа; нечем открыть — iOS: «Поделиться» (открыть в другом приложении),
/// Android: сообщение.
Future<void> openChatFile(BuildContext context, models.Message m) async {
  final files = _files(m, null);
  if (files == null) return showChatToast(context, context.t.screenChat.mediaNotReady);
  if (await MediaFiles.open(files.first) || !context.mounted) return;
  if (Platform.isIOS) {
    await MediaFiles.share(files, context: context);
  } else {
    showChatToast(context, context.t.screenChat.noAppToOpen);
  }
}

/// Фото / видео (или файл) — в буфер обмена: вставляется в другой мессенджер.
Future<void> copyChatMedia(BuildContext context, models.Message m, {int? index, bool overlay = false}) async {
  final t = context.t.screenChat;
  final files = _files(m, index);
  if (files == null) return showChatToast(context, t.mediaNotReady, overlay: overlay);
  final ok = await MediaFiles.copy(files);
  if (context.mounted) showChatToast(context, ok ? t.copied : t.copyFailed, overlay: overlay);
}

/// Сохранить: фото / видео — в галерею, файл — в «Файлы» / «Загрузки»
/// (десктоп — всё в «Загрузки»).
Future<void> saveChatMedia(BuildContext context, models.Message m, {int? index, bool overlay = false}) async {
  final t = context.t.screenChat;
  final files = _files(m, index);
  if (files == null) return showChatToast(context, t.mediaNotReady, overlay: overlay);
  final file = _isFile(m);
  final result = file ? await MediaFiles.saveFile(files.first) : await MediaFiles.saveToGallery(files);
  if (!context.mounted) return;
  final text = switch (result) {
    // iOS: место в «Файлах» выбрали сами — подтверждать нечего.
    MediaSaveResult.saved when file && Platform.isIOS => null,
    // Десктоп: всё — в «Загрузки».
    MediaSaveResult.saved => file || AppPlatform.isDesktop ? t.savedToDownloads : t.savedToGallery,
    MediaSaveResult.canceled => null,
    MediaSaveResult.denied => t.galleryDenied,
    MediaSaveResult.failed => t.saveFailed,
  };
  if (text != null) showChatToast(context, text, overlay: overlay);
}

/// Системное «Поделиться» вложениями.
Future<void> shareChatMedia(BuildContext context, models.Message m, {int? index, bool overlay = false}) async {
  final files = _files(m, index);
  if (files == null) return showChatToast(context, context.t.screenChat.mediaNotReady, overlay: overlay);
  await MediaFiles.share(files, context: context);
}
