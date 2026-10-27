import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/chats_sync.dart' show ChatsOfflineException, ChatsRequestException;
import 'package:messenger/chats/edit_media.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/protobuf/protos/models.pb.dart' as pbm;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Замена и добавление вложений при правке (Messages.Edit.replaceMedia).
void main() {
  setUpAll(() async {
    await AppLocale.ru.build();
  });

  final date = DateTime(2026, 10, 23);
  models.Message message({
    String id = '10',
    models.MessageKind kind = models.MessageKind.text,
    List<models.MessageMedia> media = const [],
    models.MessageStatus status = models.MessageStatus.sent,
  }) => models.Message(id: id, chatID: 'c', kind: kind, text: 'текст', outgoing: true, date: date, media: media, status: status);

  const photo = models.MessageMedia(kind: models.MessageKind.photo, localPath: '/new/photo.jpg', width: 10, height: 20);
  const video = models.MessageMedia(kind: models.MessageKind.video, localPath: '/new/video.mp4', thumbPath: '/new/thumb.jpg');
  const file = models.MessageMedia(kind: models.MessageKind.file, localPath: '/new/doc.pdf', size: 3);
  final album = message(
    kind: models.MessageKind.photo,
    media: const [
      models.MessageMedia(kind: models.MessageKind.photo),
      models.MessageMedia(kind: models.MessageKind.video),
      models.MessageMedia(kind: models.MessageKind.photo),
    ],
  );

  group('скрепка в режиме «Изменить»', () {
    test('доступна у текста, фото, видео, файла', () {
      for (final kind in [models.MessageKind.text, models.MessageKind.photo, models.MessageKind.video, models.MessageKind.file]) {
        expect(canEditMessageText(message(kind: kind)), isTrue, reason: '$kind');
        expect(canEditMessageMedia(message(kind: kind)), isTrue, reason: '$kind');
      }
    });

    test('нет у голосового, опроса, звонка, служебного, пересланного, уведомления «Iperon»', () {
      final base = message();
      final cases = {
        'голосовое': message(kind: models.MessageKind.voice),
        'опрос': base.copyWith(
          kind: models.MessageKind.poll,
          poll: const models.MessagePoll(question: '?', options: []),
        ),
        'звонок': base.copyWith(kind: models.MessageKind.call, phoneCall: const models.MessageCall(video: false)),
        'служебное': base.copyWith(service: true),
        'пересланное': base.copyWith(forward: const models.MessageForward(name: 'Анна')),
        'уведомление': base.copyWith(systemNotice: const models.SystemNotice(kind: models.SystemNoticeKind.newLogin)),
      };
      for (final MapEntry(:key, :value) in cases.entries) {
        expect(canEditMessageMedia(value), isFalse, reason: key);
        expect(canEditMessageText(value), isFalse, reason: key);
      }
    });

    test('нет в секретном чате, у неотправленного и отложенного (текст там правится)', () {
      expect(canEditMessageMedia(message(), secret: true), isFalse);
      final local = message(id: localMessageID(5), status: models.MessageStatus.pending);
      expect(canEditMessageMedia(local), isFalse);
      expect(canEditMessageText(local), isTrue);
      expect(canEditMessageMedia(message(id: scheduledMessageID(7))), isFalse);
      expect(canEditMessageMedia(message(status: models.MessageStatus.failed)), isFalse);
    });

    test('режим: добавить к тексту, заменить одиночное, выбрать в альбоме', () {
      expect(editMediaMode(message()), EditMediaMode.add);
      expect(editMediaMode(message(kind: models.MessageKind.file)), EditMediaMode.replace);
      expect(editMediaMode(message(kind: models.MessageKind.photo, media: const [photo])), EditMediaMode.replace);
      expect(editMediaMode(album), EditMediaMode.album);
    });
  });

  group('итоговый список вложений', () {
    test('замена одного в альбоме — остальные на своих местах', () {
      final pick = pickEditMedia(album, const models.EditMedia(), [video], index: 1);
      expect(pick.rejected, isFalse);
      final slots = editMediaSlots(3, pick.draft);
      expect([for (final s in slots) s.original], [0, -1, 2]);
      expect(slots[1].fresh, video);
      expect(editMediaValid([for (final s in slots) s.fresh?.kind ?? album.media[s.original].kind]), isTrue);
      // Отмена замены — снова исходное.
      expect(editMediaSlots(3, undoEditReplace(pick.draft, 1)).every((s) => s.fresh == null), isTrue);
    });

    test('в альбом — только фото / видео', () {
      final pick = pickEditMedia(album, const models.EditMedia(), [file], index: 0);
      expect(pick.rejected, isTrue);
      expect(pick.draft.isEmpty, isTrue);
      expect(editMediaValid([models.MessageKind.photo, models.MessageKind.file]), isFalse);
    });

    test('одиночное заменяется чем угодно, в том числе файлом', () {
      final single = message(
        kind: models.MessageKind.photo,
        media: const [models.MessageMedia(kind: models.MessageKind.photo)],
      );
      final pick = pickEditMedia(single, const models.EditMedia(), [file, photo]);
      expect(editMediaSlots(1, pick.draft).single.fresh, file);
      expect(editMediaValid([models.MessageKind.file]), isTrue);
    });

    test('к тексту — альбом (текст станет подписью), файл — один', () {
      final text = message();
      final media = pickEditMedia(text, const models.EditMedia(), [photo, video, file]);
      expect([for (final s in editMediaSlots(0, media.draft)) s.fresh], [photo, video]);
      final doc = pickEditMedia(text, const models.EditMedia(), [file]);
      expect(doc.draft.added, [file]);
      // Фото после файла — альбом без файла.
      expect(pickEditMedia(text, doc.draft, [photo]).draft.added, [photo]);
      expect(removeEditAdded(media.draft, 0).added, [video]);
    });

    test('лимит альбома: лишнее отбрасывается', () {
      final text = message();
      final first = pickEditMedia(text, const models.EditMedia(), List.filled(7, photo));
      expect(first.truncated, isFalse);
      final second = pickEditMedia(text, first.draft, List.filled(5, video));
      expect(second.truncated, isTrue);
      expect(second.draft.added, hasLength(models.Message.maxAlbum));
      expect(editMediaValid(List.filled(models.Message.maxAlbum + 1, models.MessageKind.photo)), isFalse);
    });

    test('демо: сообщение после правки — альбом / файл', () {
      final withPhotos = applyEditMedia(message(), models.EditMedia(added: const [photo, video]));
      expect(withPhotos.kind, models.MessageKind.photo);
      expect(withPhotos.media, [photo, video]);
      expect(withPhotos.text, 'текст');
      final withFile = applyEditMedia(
        message(kind: models.MessageKind.photo, media: const [photo]),
        const models.EditMedia(replaced: {0: file}),
      );
      expect(withFile.kind, models.MessageKind.file);
      expect(withFile.media, isEmpty);
      expect(withFile.fileName, 'doc.pdf');
    });
  });

  group('отправка правки', () {
    late Directory dir;
    setUp(() async => dir = await Directory.systemTemp.createTemp('edit_media'));
    tearDown(() async => dir.delete(recursive: true));

    final chat = List<int>.filled(12, 9);
    final oldPhoto = List<int>.filled(12, 1);
    final oldVideo = List<int>.filled(12, 2);
    final oldThumb = List<int>.filled(12, 3);
    pb.MessageContent original() => pb.MessageContent(
      text: 'подпись',
      media: [
        pb.MessageMedia(
          kind: pb.MessageKind.MESSAGE_KIND_PHOTO,
          cdnID: oldPhoto,
          file: pbm.CDN(cdnID: oldPhoto, url: 'https://cdn/1'),
        ),
        pb.MessageMedia(kind: pb.MessageKind.MESSAGE_KIND_VIDEO, cdnID: oldVideo, thumbCdnID: oldThumb),
      ],
    );

    test('без сети — ни загрузки, ни запроса', () async {
      var calls = 0;
      await expectLater(
        editMessageMedia(
          edit: pb.Messages_Edit(chatID: chat, messageID: Int64(10)),
          draft: const models.EditMedia(added: [photo]),
          hasNetwork: () async => false,
          original: () async {
            calls++;
            return original();
          },
          upload: (file, thumb, onProgress) async {
            calls++;
            return const [];
          },
          send: (edit) async => calls++,
        ),
        throwsA(isA<ChatsOfflineException>()),
      );
      expect(calls, 0);
    });

    test('новые — на CDN (видео с обложкой), затем один Edit со всем списком', () async {
      final newVideo = File('${dir.path}/v.mp4')..writeAsBytesSync(List.filled(100, 1));
      final newThumb = File('${dir.path}/t.jpg')..writeAsBytesSync(List.filled(10, 2));
      final uploaded = <String>[];
      final sent = <pb.Messages_Edit>[];
      final progress = <(int, int)>[];
      await editMessageMedia(
        edit: pb.Messages_Edit(chatID: chat, messageID: Int64(10), text: 'новая подпись'),
        draft: models.EditMedia(
          replaced: {
            1: models.MessageMedia(kind: models.MessageKind.video, localPath: newVideo.path, thumbPath: newThumb.path, duration: 4),
          },
        ),
        hasNetwork: () async => true,
        original: () async => original(),
        upload: (file, thumb, onProgress) async {
          uploaded.add(file.path);
          onProgress(1, 1);
          return List<int>.filled(12, 40 + uploaded.length);
        },
        send: (edit) async => sent.add(edit),
        onUpload: (s, t) => progress.add((s, t)),
      );
      expect(uploaded, [newVideo.path, newThumb.path]);
      expect(progress.last, (110, 110));
      final edit = sent.single;
      expect(edit.replaceMedia, isTrue);
      expect(edit.text, 'новая подпись');
      expect(edit.media, hasLength(2));
      // Исходное фото — как было, без ссылки на скачивание.
      expect(edit.media[0].cdnID, oldPhoto);
      expect(edit.media[0].hasFile(), isFalse);
      expect(edit.media[1].kind, pb.MessageKind.MESSAGE_KIND_VIDEO);
      expect(edit.media[1].cdnID, List<int>.filled(12, 41));
      expect(edit.media[1].thumbCdnID, List<int>.filled(12, 42));
      expect(edit.media[1].size.toInt(), 100);
      expect(edit.media[1].duration, 4);
    });

    test('недопустимый список — как отказ сервера, без загрузки', () async {
      var uploads = 0;
      await expectLater(
        editMessageMedia(
          edit: pb.Messages_Edit(chatID: chat, messageID: Int64(10)),
          draft: const models.EditMedia(added: [file]),
          hasNetwork: () async => true,
          original: () async => original(),
          upload: (file, thumb, onProgress) async {
            uploads++;
            return const [];
          },
          send: (edit) async {},
        ),
        throwsA(isA<ChatsRequestException>().having((e) => e.error, 'error', editMediaInvalid)),
      );
      expect(uploads, 0);
    });
  });

  group('применение EditMessage с новыми вложениями', () {
    final me = List<int>.filled(12, 1);
    final chat = List<int>.filled(12, 9);
    late Directory dir;
    late SqliteDatabase db;
    late ChatsRepository store;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('edit_media_db');
      db = SqliteDatabase(path: '${dir.path}/test.db');
      await db.execute('''
        CREATE TABLE chatMessages (
          userID BLOB NOT NULL,
          chatID BLOB NOT NULL,
          messageID INTEGER NOT NULL,
          fromUserID BLOB NOT NULL,
          date INTEGER NOT NULL DEFAULT 0,
          editDate INTEGER NOT NULL DEFAULT 0,
          randomID INTEGER NOT NULL DEFAULT 0,
          mediaUnread INTEGER NOT NULL DEFAULT 0,
          silent INTEGER NOT NULL DEFAULT 0,
          content BLOB NOT NULL,
          searchText TEXT NOT NULL DEFAULT '',
          reactions BLOB NULL,
          reactionsUnread INTEGER NOT NULL DEFAULT 0,
          expireAt INTEGER NOT NULL DEFAULT 0, poll BLOB NULL, searchHit INTEGER NOT NULL DEFAULT 0,
          authorSignature TEXT NOT NULL DEFAULT '', postOut INTEGER NOT NULL DEFAULT 0, views INTEGER NOT NULL DEFAULT 0, viewed INTEGER NOT NULL DEFAULT 0, comments BLOB NULL,
          PRIMARY KEY (userID, chatID, messageID)
        );
      ''');
      await db.execute(ChatsRepository.mentionsSchema);
      await db.execute(ChatsRepository.threadsSchema);
      await db.execute('''
        CREATE TABLE chatPinned (
          userID BLOB NOT NULL,
          chatID BLOB NOT NULL,
          messageID INTEGER NOT NULL,
          message BLOB NOT NULL,
          shared INTEGER NOT NULL DEFAULT 1,
          PRIMARY KEY (userID, chatID, messageID)
        );
      ''');
      store = ChatsRepository(logger: Logger(), db: db);
    });

    tearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    pb.ChatMessage chatMessage(pb.MessageContent content, {int editDate = 0}) =>
        pb.ChatMessage(chatID: chat, messageID: Int64(10), fromUserID: me, date: Int64(1000), editDate: Int64(editDate), content: content);

    test('текст → фото: вложения в кэше, пузырь и превью — фото, старые файлы отданы на чистку', () async {
      final oldA = List<int>.filled(12, 1);
      final oldB = List<int>.filled(12, 2);
      final oldThumb = List<int>.filled(12, 3);
      final fresh = List<int>.filled(12, 4);
      final before = pb.MessageContent(
        text: 'альбом',
        media: [
          pb.MessageMedia(kind: pb.MessageKind.MESSAGE_KIND_PHOTO, cdnID: oldA),
          pb.MessageMedia(kind: pb.MessageKind.MESSAGE_KIND_VIDEO, cdnID: oldB, thumbCdnID: oldThumb),
        ],
      );
      await store.upsertMessage(userID: me, message: chatMessage(before));
      // Второй элемент альбома заменили фото.
      final after = pb.MessageContent(
        text: 'альбом',
        media: [
          pb.MessageMedia(kind: pb.MessageKind.MESSAGE_KIND_PHOTO, cdnID: oldA),
          pb.MessageMedia(kind: pb.MessageKind.MESSAGE_KIND_PHOTO, cdnID: fresh, width: 30, height: 40, thumbhash: 'h'),
        ],
      );
      final cached = await store.message(userID: me, chatID: chat, messageID: 10);
      await store.upsertMessage(userID: me, message: chatMessage(after, editDate: 2000));
      expect(replacedMediaIDs(cached!.content, after), [oldB, oldThumb]);

      final stored = (await store.message(userID: me, chatID: chat, messageID: 10))!;
      final model = messageFromPb(stored, chatID: idHex(chat), myUserID: me, readOutboxMaxID: 0, isSelf: false);
      expect(model.edited, isTrue);
      expect(model.kind, models.MessageKind.photo);
      expect([for (final m in model.media) m.kind], [models.MessageKind.photo, models.MessageKind.photo]);
      expect(model.media[1].width, 30);
      expect(model.media[1].thumbhash, 'h');

      // Текстовое с добавленным файлом — в списке чатов «файл».
      final text = chatMessage(pb.MessageContent(text: 'привет'));
      expect(lastMessageFromPb(text, myUserID: me, readOutboxMaxID: 0, isSelf: false).kind, models.MessageKind.text);
      final withFile = chatMessage(
        pb.MessageContent(
          text: 'привет',
          media: [pb.MessageMedia(kind: pb.MessageKind.MESSAGE_KIND_FILE, cdnID: fresh, fileName: 'a.pdf')],
        ),
      );
      expect(lastMessageFromPb(withFile, myUserID: me, readOutboxMaxID: 0, isSelf: false).kind, models.MessageKind.file);
      final fileModel = messageFromPb(withFile, chatID: idHex(chat), myUserID: me, readOutboxMaxID: 0, isSelf: false);
      expect(fileModel.fileName, 'a.pdf');
      expect(fileModel.text, 'привет');
    });
  });
}
