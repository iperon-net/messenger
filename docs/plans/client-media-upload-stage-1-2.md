# Клиент: загрузка больших медиафайлов (этапы 1+2 сервера)

## Контекст

На сервере (`iperon`, см. `docs/plans/breezy-uploading-courier.md` и `docs/plans/shimmying-tumbling-owl.md`
в репозитории `iperon`) уже реализованы:

- **Этап 1** — сырой bidi-стрим `rpc Upload (stream Upload.Request) returns (stream Upload.Response)`:
  клиент шлёт `Upload.Init{sessionId, fileSize, resumeUploadId?}` → `InitAck{uploadId, receivedBytes}`,
  затем `Upload.Chunk{data}` → `ChunkAck{receivedBytes}` на каждый чанк, затем `Upload.Done{}` →
  `CompleteAck{uploadId, receivedBytes}`. Докачка после обрыва — через `resumeUploadId`.
- **Этап 2** — `MessageType.UPLOAD_CONFIRM` (обычный зашифрованный unary-обмен, как
  `MY_PROFILE_UPDATE`): клиент передаёт ключ шифрования файла + метаданные, сервер заворачивает
  ключ, стримит уже принятый ciphertext в S3 и возвращает `CDN{cdnID, url, hashSumEncrypted,
  signatureKey, salt, createAt}`.

Ключевое допущение всей схемы (см. `breezy-uploading-courier.md`): **файл шифрует клиент**, сервер
ciphertext ни разу не расшифровывает. На клиенте (`messenger`, Flutter) сейчас для этого нет вообще
ничего: `protos/` не синхронизирован с новыми сообщениями, `lib/crypto/` умеет только сессионный
конверт (`Syncer`, AES-GCM-256 + HKDF-SHA256, см. `lib/crypto/syncer.dart`), а `unaryEncoded` в
`lib/api.dart` не возвращает и не расшифровывает ответ (годится только для запросов с пустым
`_Response{}`, как `MyProfileUpdate`).

**Явно вне скоупа этого плана**: подключение к конкретному UI-потребителю (аватар, вложения в чат).
На сервере пока нет ни одного способа привязать `cdn_id` к сущности (см. обсуждение в
`shimmying-tumbling-owl.md`, раздел "привязка `cdn_id` к сущности" — сознательно отложено), а на
клиенте нет ни чата/сообщений (только UI-заглушка вкладки), ни реального вызова аватарки
(`settings_my_profile_edit_cubit.dart` использует только generated boring-аватар). Поэтому цель
этого плана — довести до рабочего состояния **переиспользуемый примитив** "зашифровать файл,
залить с докачкой, подтвердить, получить `cdn_id`/`url`", готовый к подключению, когда появится
первый реальный потребитель.

## 1. Синхронизация proto + генерация Dart

`messenger/protos/v1.proto` отстаёт от `iperon/protos/v1.proto` (нет `Upload`-сообщений,
`UPLOAD_CONFIRM` в `MessageType`, `rpc Upload`) и не хватает файла `upload_confirm_v1.proto`.

- Скопировать актуальные `protos/v1.proto` и `protos/upload_confirm_v1.proto` из `iperon` в
  `messenger/protos/` (файл `protos/models.proto` в `messenger` уже содержит `CDN` в нужной форме —
  сверить, что не разошёлся).
- Перегенерировать: `protoc --dart_out=lib/protobuf protos/*.proto` из корня репозитория
  (`protoc-gen-dart` уже установлен через `pub global activate protoc_plugin`, судя по
  `~/.pub-cache/bin/protoc-gen-dart`). Не редактировать `*.pb*.dart` руками (см. `CLAUDE.md`).
- Добавить новые экспорты в `lib/protobuf/protobuf.dart`: `./protos/upload_confirm_v1.pb.dart` и
  `./protos/models.pb.dart` (сейчас экспортируется только `models.pbenum.dart` — `CDN` из
  `models.pb.dart` наружу не течёт, а он нужен для типа `UploadConfirm_Response.cdn`).

## 2. Файловое шифрование (новый `lib/crypto/file_encryptor.dart`, `part of 'crypto.dart'`)

Нужна потоковая (chunked) AEAD-схема — файл может быть гигабайтным, весь plaintext/ciphertext в
памяти держать нельзя, а мультимедиа-пайплайн должен уметь докачивать с точной границы чанка после
обрыва. Сессионный `Syncer` (single-shot AES-GCM над всем сообщением) для этого не подходит и
трогать его не нужно — файловое шифрование живёт отдельно.

**Предлагаемая схема** (STREAM-конструкция, тот же подход обсуждался для серверного
`crypto.Encryptor` в памяти `crypto_streaming_aead_plan` — там для другого флоу, но идея та же и
годится здесь; **отметить как решение, требующее ревью** перед реализацией):

- Генерируются один раз на файл: `fileKey` (32 случайных байта) и `hkdfSalt` (32 случайных байта) —
  именно они позже уходят в `UploadConfirm.Request.encryptionKey`/`hkdfSalt` россыпью, plaintext-ключ
  на сервер никогда не попадает как есть (сервер его дополнительно заворачивает своим ключом, но это
  уже не забота клиента).
- Ключ шифрования чанков: `chunkKey = HKDF-SHA256(secret: fileKey, salt: hkdfSalt, info: "iperon-media-file-v1", length: 32)`
  — тем же `Hkdf`/`Sha256` примитивом, что уже использует `Syncer` (`package:cryptography`, без
  новых зависимостей).
- Файл режется на чанки фиксированного размера (предлагаю 256 KiB — компромисс между накладными
  расходами AEAD-тега на чанк и памятью на чанк; это же значение — размер `Upload.Chunk.data`,
  сетевой чанк = один зашифрованный фрейм, лишней прослойки нет).
- Nonce на чанк: 8 случайных байт (генерируются один раз на файл, хранятся рядом с `fileKey`) + 4
  байта big-endian номера чанка = 12 байт (`AesGcm.with256bits()` ждёт именно 12-байтовый nonce, как
  и в `syncer.dart`). Последний чанк — со старшим битом счётчика, инвертированным (та же защита от
  усечения потока, что просит memory-план для сервера): получатель (когда появится этап 3) обязан
  проверить этот бит, иначе можно молча обрезать конец файла.
- API: `Stream<Uint8List> encryptFile({required File file, required List<int> fileKey, required List<int> hkdfSalt})`
  — читает файл чанками (`file.openRead()`), шифрует каждый через `AesGcm.encrypt`, отдаёт
  `ciphertext + tag` (16 байт) на чанк. Детерминированность (тот же `fileKey`/`hkdfSalt`/nonce-префикс
  → тот же ciphertext на том же индексе чанка) — то, что делает докачку возможной: при resume клиент
  просто продолжает enumerator с чанка `receivedBytes ~/ cipherChunkSize`, а не шифрует заново с нуля.
- Тесты: round-trip (шифруем чанками → вручную расшифровываем и сверяем с исходным файлом),
  граничные случаи (0 байт, ровно один чанк, чанк впритык к границе), детерминированность повторного
  вызова с теми же ключами/nonce-префиксом.

## 3. Локальное состояние докачки (SQLite)

Резюме в памяти (как на сервере) клиенту недостаточно: сервер теряет реестр при рестарте процесса,
что приемлемо для него (единственная реплика, живёт секунды-минуты между рестартами), но у клиента
"перезапуск" — это норма (юзер убил апп между чанками большого видео), и docs/plans/breezy-uploading-courier.md
прямо предполагает докачку "после обрыва соединения", не только сетевого микроглюка.

Новая часть `lib/repositories/uploads.dart` (`part of 'repositories.dart'`, по образцу
`my_profile.dart`), таблица (следующий свободный номер миграции после текущей `1` — см. TODO в
`CLAUDE.md` про недостающую `users.salt`, согласовать порядок при мерже):

```sql
CREATE TABLE uploads (
  localID       TEXT PRIMARY KEY,   -- сгенерированный клиентом id вложения (для UI/повторной попытки)
  uploadID      TEXT NULL,          -- null, пока не пришёл первый InitAck
  filePath      TEXT NOT NULL,
  fileSize      INTEGER NOT NULL,
  fileKey       BLOB NOT NULL,
  hkdfSalt      BLOB NOT NULL,
  nonceSalt     BLOB NOT NULL,      -- 8-байтовый nonce-префикс шифрования файла
  folder        TEXT NOT NULL,
  contentType   TEXT NOT NULL,
  fileName      TEXT NOT NULL,
  createdAt     INTEGER NOT NULL
);
```

Запись создаётся перед первым `Upload.Init`, обновляется `uploadID` после `InitAck`, и **удаляется
только после успешного `UPLOAD_CONFIRM`** — если приложение убьют посреди загрузки, при следующем
запуске можно найти незавершённые строки и предложить пользователю продолжить/отменить (сама
автоматика докачки при старте — уже решение продукта/UI, вне этого плана; здесь только то, что
данные для неё не теряются).

## 4. Сетевой слой: `UploadManager` (новый `lib/upload.dart`, синглтон в `get_it`)

По аналогии с `API`/`Crypto` — отдельный класс, а не часть `API`, чтобы не раздувать и без того
большой `lib/api.dart` неродственной логикой (у `Upload` — свой отдельный gRPC-метод, отдельный
жизненный цикл на файл, а не один долгоживущий стрим на всё приложение).

```dart
class UploadManager {
  final api = getIt.get<API>();
  final crypto = getIt.get<Crypto>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();

  Future<CDN> uploadFile({
    required File file,
    required String folder,
    required String contentType,
    void Function(int sent, int total)? onProgress,
  }) async { ... }
}
```

Реализация одного вызова `uploadFile`:

1. Если для `file.path` уже есть незавершённая строка в `uploads` — переиспользовать её
   (`fileKey`/`hkdfSalt`/`uploadID`) вместо генерации новых; иначе создать новую запись.
2. Открыть `client.upload(...)` (после регенерации у `IperonClient` появится метод `upload`,
   зеркальный существующему `client.stream(...)`, см. `lib/api.dart:_open`) — **отдельный** bidi-вызов
   на каждую попытку загрузки/докачки, не переиспользующий persistent-стрим `API`.
3. Отправить `Upload_Request(init: Upload_Init(sessionId: <hex сессии>, fileSize: ..., resumeUploadId: <uploadID или null>))`.
   `sessionId` — по конвенции сервера (`hex.DecodeString` в `api.V1.Upload`, см. `iperon`) это
   hex-строка сессионного токена, а не сессионно-зашифрованный конверт — стрим `Upload` сырой, без
   `Syncer` (см. допущения в `breezy-uploading-courier.md`: "секретность уже обеспечена ключом файла").
4. Дождаться `InitAck`, сохранить `uploadId` в БД, взять `receivedBytes` как стартовый оффсет.
5. `crypto.fileEncryptor.encryptFile(...)`, пропустить (`skip`) уже подтверждённые чанки по индексу
   `receivedBytes ~/ cipherChunkSize`, слать оставшиеся как `Upload_Request(chunk: Upload_Chunk(data: ...))`,
   ждать `ChunkAck` перед следующим (сервер подтверждает каждый чанк последовательно — см. серверный
   план, пайплайнинг не предусмотрен), обновлять `onProgress`.
6. При обрыве стрима (`onError`/`onDone` раньше `CompleteAck`) — не считать это фатальной ошибкой
   вызова: поймать, переоткрыть `client.upload(...)` с тем же `resumeUploadId` (шаг 2 заново),
   продолжить с оффсета из нового `InitAck`. Ограничить число автоматических попыток (например, 3
   с растущей паузой, по аналогии с `_reconnectDelay`/`backoffStrategy` в `API`), дальше —
   пробрасывать ошибку наружу (UI решает: повторить руками/отменить).
7. Отправить `Upload_Request(done: Upload_Done())`, дождаться `CompleteAck`, сверить
   `receivedBytes == fileSize` (сервер и так проверяет и вернёт `InvalidArgument` при несовпадении —
   клиент просто пробрасывает эту ошибку, не дублирует проверку).
8. Вызвать `UPLOAD_CONFIRM` (см. следующий раздел) с `fileKey`/`hkdfSalt`/`fileName`/`contentType`/`folder`.
9. При успехе — удалить строку из `uploads`, вернуть `CDN`. При ошибке `UPLOAD_CONFIRM` — **не**
   удалять строку и не запускать заново шаги 2–7 (файл уже на сервере, только подтверждение не
   прошло) — просто дать вызывающему коду возможность повторить `confirm` отдельно (сервер тоже
   спроектирован под безопасный повторный `UPLOAD_CONFIRM`, см. `shimmying-tumbling-owl.md`).

## 5. `UPLOAD_CONFIRM`: новый метод в `API`, возвращающий расшифрованный ответ

Существующий `unaryEncoded` (`lib/api.dart:599`) осознанно отбрасывает ответ сервера — годится
только когда `_Response{}` пуст. Для `UPLOAD_CONFIRM` ответ (`CDN`) нужен, поэтому добавляется
соседний метод, а не меняется поведение существующего (не трогать вызовы `MyProfileUpdate` и т.п.):

```dart
/// Как [unaryEncoded], но расшифровывает и возвращает тело ответа — для
/// вызовов, где `_Response` непустой (см. `_dispatch` — тот же `crypto.syncer.decode`).
Future<(APICallStatus, Uint8List?)> unaryEncodedWithResponse(MessageType type, Uint8List payload) async {
  final crypto = getIt.get<Crypto>();
  final auth = getIt.get<Auth>();

  final encoded = await crypto.syncer.encode(session: auth.session, message: payload);

  Uint8List? responsePayload;
  final status = await call(() async {
    final response = await client.unary(Message(messageType: type, message: encoded));
    responsePayload = Uint8List.fromList(await crypto.syncer.decode(session: auth.session, message: Uint8List.fromList(response.message)));
  });

  return (status, responsePayload);
}
```

`UploadManager` вызывает: `unaryEncodedWithResponse(MessageType.UPLOAD_CONFIRM, UploadConfirm_Request(...).writeToBuffer())`,
на успехе — `UploadConfirm_Response.fromBuffer(payload!).cdn`.

## 6. DI

`lib/di.dart`: `UploadManager` — новый `registerSingletonAsync`, `dependsOn: [API, Crypto, Auth, Repositories]`
(та же связка, что использует сама логика загрузки); добавить симметрично в
`unregisterCommonDependencies()`.

## Явно не делаем сейчас

- **Никакой UI-интеграции** (кнопка отправки фото в чат, реальная загрузка аватарки) — потребителей
  пока нет ни на клиенте (чат — только UI-заглушка вкладки), ни на сервере (`MyProfileAvatarUpdate`
  принимает только `bytes avatar`, а не `cdn_id` — см. отложенное решение в `shimmying-tumbling-owl.md`).
- **Автоматическое возобновление при старте приложения** брошенных строк `uploads` — сама возможность
  докачки заложена (данные не теряются), но политика "когда именно резюмировать" — уже продуктовое
  решение с UI (спросить пользователя / тихо в фоне / только по Wi-Fi), не техническая часть.
- **Прогресс-бар/UI-компонент** — `onProgress` колбэк в `UploadManager` есть, отрисовка — отдельная
  задача, когда появится экран-потребитель.

## Проверка

1. `protoc --dart_out=lib/protobuf protos/*.proto`, затем `flutter analyze` — новые сгенерированные
   типы не должны ломать анализ.
2. Юнит-тесты `lib/crypto/file_encryptor.dart` (round-trip, детерминированность, граничные размеры)
   без сети/сервера.
3. Интеграционно (руками, против локального `iperon`): взять файл, `UploadManager.uploadFile(...)`
   → сверить, что объект появился в S3-бакете (`s3Cdn`, см. `iperon/internal/settings`) и запись — в
   `cdn` в Mongo, полученный `url` открывается. Отдельно — оборвать Wi-Fi посреди чанков и проверить,
   что автоматический ретрай (шаг 6 выше) реально резюмирует с правильного оффсета, а не начинает
   сначала.
