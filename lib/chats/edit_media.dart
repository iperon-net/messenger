import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:path/path.dart' as p;

import '../cdn.dart' show UploadCancelledException;
import '../models.dart' as models;
import '../protobuf/protos/chats_v1.pb.dart' as pb;
import 'chats_mapping.dart';
import 'chats_media.dart';
import 'chats_sync.dart' show ChatsOfflineException, ChatsRequestException;

/// Замена и добавление вложений при правке сообщения (как editMessage с media
/// в Telegram, `Messages.Edit.replaceMedia`): что можно, как выбранное
/// ложится в правку ([models.EditMedia]) и какой список вложений уходит на
/// сервер. Здесь — без сети и UI.

/// Отказ сервера на недопустимые вложения правки (INVALID_ARGUMENT); тот же
/// ключ — у локальной проверки до загрузки.
const editMediaInvalid = 'mediaInvalid';

/// Фото / видео — то, что собирается в альбом.
bool isAlbumKind(models.MessageKind kind) => kind == models.MessageKind.photo || kind == models.MessageKind.video;

/// Сколько вложений у сообщения: альбом — по элементам, одиночное фото / видео
/// / файл — одно, текст — ни одного.
int messageMediaCount(models.Message message) {
  if (message.media.isNotEmpty) return message.media.length;
  return isAlbumKind(message.kind) || message.kind == models.MessageKind.file ? 1 : 0;
}

/// Текст (подпись) сообщения правится: текст, фото, видео, файл — не
/// голосовое, не опрос, не звонок, не служебное, не пересланное (чужой текст,
/// как в Telegram). Права — отдельно (`ChatCubit.canEdit`).
bool canEditMessageText(models.Message message) =>
    !message.service &&
    message.forward == null &&
    message.systemNotice == null &&
    message.poll == null &&
    message.phoneCall == null &&
    (message.kind == models.MessageKind.text || isAlbumKind(message.kind) || message.kind == models.MessageKind.file);

/// Скрепка в режиме «Изменить»: заменить / добавить вложения можно у того, что
/// правится ([canEditMessageText]), уже принятого сервером (неотправленное и
/// отложенное правятся в своей очереди — только текст) и не в секретном чате.
bool canEditMessageMedia(models.Message message, {bool secret = false}) =>
    !secret &&
    canEditMessageText(message) &&
    randomIDOfLocal(message.id) == null &&
    scheduledIDOf(message.id) == null &&
    message.scheduledDate == null &&
    message.status != models.MessageStatus.pending &&
    message.status != models.MessageStatus.failed;

/// Что делает скрепка при правке [message]: добавляет к тексту, заменяет
/// одиночное или (альбом) — элемент, выбранный в шапке правки.
enum EditMediaMode { add, replace, album }

EditMediaMode editMediaMode(models.Message message) => switch (messageMediaCount(message)) {
  0 => EditMediaMode.add,
  1 => EditMediaMode.replace,
  _ => EditMediaMode.album,
};

/// Итог выбора в скрепке: новая правка; [truncated] — выбрали больше
/// [models.Message.maxAlbum], лишние отброшены; [rejected] — выбранное сюда не
/// подходит (в альбом — не фото / видео), правка не изменилась.
typedef EditMediaPick = ({models.EditMedia draft, bool truncated, bool rejected});

/// Положить выбранное [picked] в правку [draft] сообщения [message]:
/// текстовое — добавить (фото / видео — альбомом до лимита, иначе один файл),
/// одиночное — заменить, альбом — заменить элемент [index] (только фото /
/// видео).
EditMediaPick pickEditMedia(models.Message message, models.EditMedia draft, List<models.MessageMedia> picked, {int index = 0}) {
  if (picked.isEmpty) return (draft: draft, truncated: false, rejected: false);
  final count = messageMediaCount(message);
  if (count == 0) {
    final media = [
      for (final m in picked)
        if (isAlbumKind(m.kind)) m,
    ];
    if (media.isEmpty) return (draft: draft.copyWith(added: [picked.first]), truncated: false, rejected: false);
    // Ещё фото / видео к уже добавленным (файл, если был, уступает альбому).
    final all = [...draft.added.where((m) => isAlbumKind(m.kind)), ...media];
    final truncated = all.length > models.Message.maxAlbum;
    return (draft: draft.copyWith(added: all.take(models.Message.maxAlbum).toList()), truncated: truncated, rejected: false);
  }
  if (count == 1) return (draft: draft.copyWith(replaced: {0: picked.first}), truncated: false, rejected: false);
  final media = picked.where((m) => isAlbumKind(m.kind));
  if (index < 0 || index >= count || media.isEmpty) return (draft: draft, truncated: false, rejected: true);
  return (draft: draft.copyWith(replaced: {...draft.replaced, index: media.first}), truncated: false, rejected: false);
}

/// Отменить замену элемента [index].
models.EditMedia undoEditReplace(models.EditMedia draft, int index) => draft.copyWith(replaced: {...draft.replaced}..remove(index));

/// Убрать добавленное [index].
models.EditMedia removeEditAdded(models.EditMedia draft, int index) => draft.copyWith(added: [...draft.added]..removeAt(index));

/// Элемент итогового списка вложений: исходное ([original] — индекс в
/// исходном) или новое ([fresh]).
typedef EditMediaSlot = ({int original, models.MessageMedia? fresh});

/// Итоговый список вложений после правки: исходные на своих местах (заменённые
/// — новыми), за ними добавленные.
List<EditMediaSlot> editMediaSlots(int originalCount, models.EditMedia draft) => [
  for (var i = 0; i < originalCount; i++) (original: draft.replaced[i] == null ? i : -1, fresh: draft.replaced[i]),
  for (final m in draft.added) (original: -1, fresh: m),
];

/// Такой список вложений допустим (как при отправке): одно — что угодно,
/// несколько — только фото / видео и не больше [models.Message.maxAlbum].
bool editMediaValid(List<models.MessageKind> kinds) =>
    kinds.isNotEmpty && kinds.length <= models.Message.maxAlbum && (kinds.length == 1 || kinds.every(isAlbumKind));

/// Новое вложение для `Messages.Edit.media` ([cdnID] / [thumbCdnID] — уже
/// загружены на CDN): как при отправке.
pb.MessageMedia editMediaToPb(
  models.MessageMedia item, {
  required List<int> cdnID,
  List<int>? thumbCdnID,
  required int size,
  required String mimeType,
}) {
  final kind = switch (item.kind) {
    models.MessageKind.photo => pb.MessageKind.MESSAGE_KIND_PHOTO,
    models.MessageKind.video => pb.MessageKind.MESSAGE_KIND_VIDEO,
    _ => pb.MessageKind.MESSAGE_KIND_FILE,
  };
  final file = kind == pb.MessageKind.MESSAGE_KIND_FILE;
  return pb.MessageMedia(
    kind: kind,
    cdnID: cdnID,
    thumbCdnID: thumbCdnID == null || thumbCdnID.isEmpty ? null : thumbCdnID,
    width: file ? null : item.width,
    height: file ? null : item.height,
    size: Int64(size),
    thumbhash: file ? null : item.thumbhash,
    spoiler: file ? null : item.spoiler,
    duration: file ? null : item.duration,
    fileName: p.basename(item.localPath),
    mimeType: mimeType,
  );
}

/// Исходное вложение — в `Messages.Edit.media` как есть, без ссылок на
/// скачивание (их заполняет сервер при выдаче).
pb.MessageMedia keptMediaToPb(pb.MessageMedia media) => media.deepCopy()
  ..clearFile()
  ..clearThumbFile();

/// cdnID (файлы и обложки), которые были у [before] и пропали в [after] —
/// заменённые правкой: их копии на устройстве можно чистить.
List<List<int>> replacedMediaIDs(pb.MessageContent before, pb.MessageContent after) {
  final kept = <String>{
    for (final m in after.media) ...[idHex(m.cdnID), idHex(m.thumbCdnID)],
  };
  return [
    for (final m in before.media)
      for (final id in [m.cdnID, m.thumbCdnID])
        if (id.isNotEmpty && !kept.contains(idHex(id))) id,
  ];
}

/// Сообщение после правки вложений — локально (демо: сервера нет).
models.Message applyEditMedia(models.Message message, models.EditMedia draft) {
  if (draft.isEmpty) return message;
  final original = message.media.isNotEmpty
      ? message.media
      : [
          if (messageMediaCount(message) == 1)
            models.MessageMedia(kind: message.kind, localPath: message.localPath, size: message.fileSize, duration: message.duration),
        ];
  final items = [for (final slot in editMediaSlots(original.length, draft)) slot.fresh ?? original[slot.original]];
  if (items.isEmpty) return message;
  final first = items.first;
  if (items.length == 1 && first.kind == models.MessageKind.file) {
    return message.copyWith(
      kind: models.MessageKind.file,
      media: const [],
      localPath: first.localPath,
      fileName: p.basename(first.localPath),
      fileSize: first.size,
      linkPreview: null,
    );
  }
  return message.copyWith(kind: first.kind, media: items, localPath: first.localPath, fileName: '', fileSize: 0, linkPreview: null);
}

/// Правка с вложениями по шагам: сеть (нет — [ChatsOfflineException] без
/// единого запроса и загрузки) → проверка итогового списка (как отказ сервера
/// [editMediaInvalid]) → загрузка новых файлов [upload] (файл → cdnID; у видео
/// — и обложка) с общим прогрессом [onUpload] → один [send] `Edit
/// {replaceMedia, media}` со всем списком. [edit] — уже с чатом, сообщением,
/// текстом и разметкой; [original] — содержимое сообщения из кэша.
Future<void> editMessageMedia({
  required pb.Messages_Edit edit,
  required models.EditMedia draft,
  required Future<bool> Function() hasNetwork,
  required Future<pb.MessageContent?> Function() original,
  required Future<List<int>> Function(File file, void Function(int sent, int total) onProgress) upload,
  required Future<void> Function(pb.Messages_Edit edit) send,
  void Function(int sent, int total)? onUpload,
  bool Function()? isCancelled,
}) async {
  if (!await hasNetwork()) throw const ChatsOfflineException();
  final content = await original();
  if (content == null) throw const ChatsRequestException(editMediaInvalid, StatusCode.invalidArgument);
  final before = content.media;
  final slots = editMediaSlots(before.length, draft);
  final kinds = [for (final slot in slots) slot.fresh?.kind ?? kindFromPb(before[slot.original].kind)];
  // Голосовое / кружок не меняются, файл в альбом, больше 10 — как отказ сервера.
  if (!editMediaValid(kinds) || before.any((m) => m.kind == pb.MessageKind.MESSAGE_KIND_VOICE)) {
    throw const ChatsRequestException(editMediaInvalid, StatusCode.invalidArgument);
  }

  // Что грузить: (элемент итогового списка, обложка ли, файл).
  final jobs = <({int slot, bool thumb, File file})>[];
  for (final (i, slot) in slots.indexed) {
    final fresh = slot.fresh;
    if (fresh == null) continue;
    jobs.add((slot: i, thumb: false, file: File(fresh.localPath)));
    if (fresh.kind == models.MessageKind.video && fresh.thumbPath.isNotEmpty) jobs.add((slot: i, thumb: true, file: File(fresh.thumbPath)));
  }
  final sizes = [for (final job in jobs) await job.file.length()];
  final total = sizes.fold(0, (a, b) => a + b);
  final cdnIDs = <int, List<int>>{};
  final thumbIDs = <int, List<int>>{};
  var done = 0;
  onUpload?.call(0, total);
  try {
    for (final (j, job) in jobs.indexed) {
      if (isCancelled?.call() ?? false) throw const UploadCancelledException();
      final cdnID = await upload(
        job.file,
        (sent, cipherTotal) => onUpload?.call(uploadedBytes(done: done, current: sizes[j], sent: sent, total: cipherTotal), total),
      );
      done += sizes[j];
      onUpload?.call(done, total);
      (job.thumb ? thumbIDs : cdnIDs)[job.slot] = cdnID;
    }
  } on UploadCancelledException {
    rethrow;
  } on FileSystemException {
    rethrow;
  } catch (_) {
    // Связь пропала посреди загрузки — «Нет соединения», правки не было.
    if (!await hasNetwork()) throw const ChatsOfflineException();
    rethrow;
  }
  if (isCancelled?.call() ?? false) throw const UploadCancelledException();

  final media = <pb.MessageMedia>[];
  for (final (i, slot) in slots.indexed) {
    final fresh = slot.fresh;
    media.add(
      fresh == null
          ? keptMediaToPb(before[slot.original])
          : editMediaToPb(
              fresh,
              cdnID: cdnIDs[i]!,
              thumbCdnID: thumbIDs[i],
              size: fresh.size > 0 ? fresh.size : await File(fresh.localPath).length(),
              mimeType: chatMediaContentType(fresh.localPath),
            ),
    );
  }
  await send(
    edit.deepCopy()
      ..replaceMedia = true
      ..media.addAll(media),
  );
}
