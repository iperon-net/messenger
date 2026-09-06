# Клиент: скачивание больших медиафайлов (этап 3)

## Контекст

Апложад (этапы 1+2) уже реализован — см. `client-media-upload-stage-1-2.md`:
`CDNManager.uploadFile`/`uploadBytes`, chunked-шифрование `FileEncryptor`, докачка
через `resumeUploadId`, `onProgress`, таблица `uploads` для незавершённых аплоадов.
`CDNManager.uploadFile` возвращает доменную модель `models.CDN`
(`cdnID, url, hashSumEncrypted, contentType, encryptionKey, hkdfSalt, createAt`).

Этап 3 (см. серверный `breezy-uploading-courier.md`) — отдача файла клиенту:
клиент качает ciphertext напрямую с CDN по HTTP(S), расшифровывает локально,
кладёт в хранилище устройства. Цель этого плана — **переиспользуемый примитив**
"по готовому `models.CDN` → расшифрованный файл на диске, с докачкой и
`onProgress`", симметричный upload-примитиву, готовый к подключению, когда
появится первый реальный потребитель (вложение в чат).

### Зафиксированные решения

1. **Хранилище:** `getApplicationCacheDirectory()`, подпапка `media/`. Кэш —
   контент перекачиваемый (есть `url`+ключ), не раздувает iCloud-бэкап
   расшифрованными копиями, app-private (plaintext не светится в галерее).
2. **`noncePrefix` — вариант C (вывод из ключа).** Nonce чанка =
   `noncePrefix`(8) + счётчик(4). `fileKey`/`hkdfSalt` до скачивающего доезжают,
   а `noncePrefix` — **выводим детерминированно** из них через HKDF, а не храним
   и не передаём. Убирает лишнее хранимое поле и любые правки proto/сервера ради
   nonce. Уникальность держится на свежем случайном `fileKey` на файл.
3. **Примитив принимает `models.CDN`.** В `models.CDN` уже есть всё нужное для
   расшифровки (`url`, `encryptionKey`, `hkdfSalt`, `contentType`,
   `hashSumEncrypted`). Поэтому серверный `MEDIA_INFO` (получение `CDN` по
   `cdn_id`) этому примитиву **не нужен** — он вне скоупа (как в upload-плане
   вынесена привязка `cdn_id` к сущности). Общий размер ciphertext берём из
   HTTP `Content-Length`, отдельного поля размера не требуется.

**Итог по границам:** правок proto и сервера в этом плане **нет вообще**
(вариант C снимает нужду в nonce-поле, приём `models.CDN` снимает нужду в
`MEDIA_INFO`). Задача полностью клиентская.

## 1. Крипто: `FileEncryptor` — вывод nonce + `decryptFile`

`lib/crypto/file_encryptor.dart` (`part of 'crypto.dart'`).

### 1.1 Вывод `noncePrefix` (вариант C)

- Новый `info`-лейбл рядом с существующим `_hkdfInfo`:
  ```dart
  static final List<int> _hkdfNonceInfo = utf8.encode('iperon-media-nonce-v1');
  ```
- Новый метод:
  ```dart
  Future<List<int>> deriveNoncePrefix({required List<int> fileKey, required List<int> hkdfSalt}) async {
    final key = await algorithmHkdf.deriveKey(secretKey: SecretKey(fileKey), nonce: hkdfSalt, info: _hkdfNonceInfo);
    return (await key.extractBytes()).sublist(0, 8);
  }
  ```
  (тот же `Hkdf`-примитив; другой `info` → независимый от `chunkKey` вывод).
- **Удалить** `generateNoncePrefix()` — больше не нужен.

### 1.2 `encryptFile` больше не принимает `noncePrefix`

Сигнатура теряет параметр `noncePrefix` — метод выводит его сам из
`fileKey`/`hkdfSalt` в начале. Детерминированность (и, значит, докачка)
сохраняется: те же `fileKey`/`hkdfSalt` → тот же префикс → тот же ciphertext.

### 1.3 Новый `decryptFile` (обратная операция)

```dart
Future<void> decryptFile({
  required File cipherFile,   // скачанный ciphertext-времянник
  required File outFile,      // расшифрованный результат
  required List<int> fileKey,
  required List<int> hkdfSalt,
}) async
```

- `chunkKey = HKDF(fileKey, hkdfSalt, info: _hkdfInfo)`, `noncePrefix = deriveNoncePrefix(...)`.
- Читает ciphertext фреймами по `chunkSize + _fileEncryptorTagSize` (последний
  короче). `isFinal` — ровно когда после текущего фрейма в файле ничего не
  осталось (EOF).
- Для каждого фрейма: `algorithmAesGcm.decrypt(SecretBox.fromConcatenation(...))`
  с `nonce = _nonceFor(noncePrefix, index, isFinal: isFinal)` (метод уже есть).
- **Защита от усечения** получается бесплатно: старший бит счётчика инвертирован
  только у финального фрейма. Если поток обрезали, `decrypt` не-финального
  фрейма с финальным nonce (или наоборот) даёт AEAD-ошибку — расшифровка падает,
  а не молча отдаёт обрезанный файл. Явную проверку дублировать не нужно.
- Пишет plaintext в `outFile` по мере расшифровки (`RandomAccessFile`), в памяти
  весь файл не держим.

### 1.4 Тесты (`test/`, без сети)

- round-trip: `encryptFile` → `decryptFile` == исходный файл;
- детерминированность выведенного nonce (тот же ключ/соль → тот же ciphertext);
- граничные размеры: 0 байт, ровно один чанк, чанк+1 байт, несколько чанков;
- усечение: отрезать последний фрейм / байт → `decryptFile` обязан бросить.

## 2. Upload-код: убрать хранимый `noncePrefix` (следствие варианта C)

`noncePrefix` больше нигде не хранится — чистим:

- **`lib/models/upload_state.dart`**: удалить поле `noncePrefix` (и из
  конструктора, и из `copyWithUploadID`). Модель — обычный класс, кодогенерации
  нет.
- **`lib/repositories/uploads.dart`**: убрать `noncePrefix` из `_columns`,
  `create`, `_fromRow`.
- **`lib/repositories/repositories.dart`** (миграция 1): убрать строку
  `noncePrefix BLOB NOT NULL` из `CREATE TABLE uploads` (правим миграцию 1
  напрямую — согласовано, БД пересоздаётся).
- **`lib/cdn.dart`**:
  - `_resolveUploadState`: не генерировать `noncePrefix`, убрать из
    `UploadState(...)`.
  - `_runUploadStream`: вызов `crypto.fileEncryptor.encryptFile(...)` — убрать
    аргумент `noncePrefix`.

`flutter analyze` должен остаться чистым.

## 3. Локальное состояние скачивания (SQLite, таблица `downloads`)

Новая часть `lib/repositories/downloads.dart` (`part of 'repositories.dart'`, по
образцу `uploads.dart`) + таблица в миграции 1:

```sql
CREATE TABLE downloads (
  cdnID            BLOB PRIMARY KEY,   -- models.CDN.cdnID
  url              TEXT NOT NULL,
  tmpPath          TEXT NOT NULL,      -- ciphertext-времянник (докачка)
  targetPath       TEXT NULL,          -- расшифрованный файл, когда готов
  encryptionKey    BLOB NOT NULL,
  hkdfSalt         BLOB NOT NULL,
  contentType      TEXT NOT NULL,
  hashSumEncrypted BLOB NOT NULL,      -- sha256 ciphertext для проверки целостности
  cipherSize       INTEGER NULL,       -- Content-Length, известен после первого ответа
  receivedBytes    INTEGER NOT NULL DEFAULT 0,
  status           TEXT NOT NULL,      -- downloading | ready | failed
  createdAt        INTEGER NOT NULL
);
```

- Новая модель `lib/models/download_state.dart` (обычный класс, как
  `UploadState`; добавить `export` в `lib/models/models.dart`).
- Репозиторий `Downloads`: `create`, `getByCdnID`, `setCipherSize`,
  `addReceivedBytes`/`setReceivedBytes`, `markReady(targetPath)`, `delete`,
  `getAll` (для будущей уборки/резюма). Геттер `repositories.downloads` +
  инициализация в `_initialization` (по образцу `uploads`).
- Запись создаётся перед первым GET, обновляет `receivedBytes` по мере закачки,
  переводится в `ready` после расшифровки; строка **не удаляется** после успеха —
  это реестр кэша (позволяет cache-hit и уборку). Времянник `tmpPath` удаляется
  после расшифровки.

## 4. `CDNManager.download`

`lib/cdn.dart`. HTTP — встроенный `dart:io HttpClient` (поддерживает `Range`,
без новой зависимости). Симметрично upload: `DownloadException`, те же
`_maxStreamAttempts`/`_retryDelay`/`_transientStatusCodes` (сетевые ретраи).

```dart
Future<File> download({
  required models.CDN cdn,
  void Function(int receivedBytes, int totalBytes)? onProgress,
}) async
```

Реализация одного вызова:

1. **Резолв состояния.** `repositories.downloads.getByCdnID(cdn.cdnID)`:
   - если `status == ready` и `targetPath` существует на диске → cache-hit,
     вернуть `File(targetPath)` сразу;
   - иначе взять существующую строку (докачка) или создать новую (`tmpPath =
     <cache>/media/.part/<cdnIDhex>`, `status = downloading`).
2. **Закачка ciphertext с докачкой.** Цикл попыток (как upload):
   - `HttpClient` GET `cdn.url` с `Range: bytes=<receivedBytes>-`;
   - ответ `206 Partial` → дописываем (append) в `tmpPath`; `200 OK` (сервер
     проигнорировал Range) → пишем с нуля, `receivedBytes = 0`;
   - `cipherSize` — из `Content-Length` (для 206 — из `Content-Range` total);
     сохранить в БД;
   - по мере чтения потока: append в файл, `receivedBytes += n`, обновить в БД
     (не на каждый байт — батчами), `onProgress?.call(receivedBytes, cipherSize)`;
   - при обрыве сети (транзиентная ошибка) — не фатально: пауза
     (`_retryDelay * attempt`), заново GET с `Range` от нового `receivedBytes`;
     после `_maxStreamAttempts` — пробросить `DownloadException`.
3. **Проверка целостности.** `sha256(tmpPath) == cdn.hashSumEncrypted` — иначе
   `DownloadException` (объект битый/подменён), времянник удалить.
4. **Расшифровка.** `targetPath = <cache>/media/<cdnIDhex><.ext>` (ext из
   `contentType` через маленький хелпер, fallback — без расширения).
   `crypto.fileEncryptor.decryptFile(cipherFile: File(tmpPath), outFile:
   File(targetPath), fileKey: cdn.encryptionKey, hkdfSalt: cdn.hkdfSalt)`.
   AEAD-ошибка здесь → `DownloadException` (в т.ч. усечение — см. 1.3).
5. **Финал.** Удалить `tmpPath`, `markReady(targetPath)`, вернуть
   `File(targetPath)`.

**Прогресс:** `onProgress(receivedBytes, cipherSize)` считает **байты
ciphertext** (сеть), симметрично `onProgress` аплоада. Фаза расшифровки прогресс
не двигает (быстрая относительно сети); при желании — отдельный колбэк позже.

**Докачка через рестарт приложения:** времянник + `receivedBytes` в БД
переживают перезапуск, повторный `download(cdn)` резюмирует. Политика
авто-резюма на старте — продуктовое решение (вне скоупа, как в upload-плане).

### 4.1 Сид кэша при аплоаде (без перекачки своего же файла)

Когда файл заливает сам клиент (аватарка, вложение), plaintext уже на
устройстве — качать его обратно после `UPLOAD_CONFIRM` бессмысленно. Поэтому
`uploadFile`, получив `CDN` из `_confirm`, вызывает `_seedDownloadCache`:
копирует исходный plaintext в `<cache>/media/<cdnID><.ext>` и заводит строку
`downloads` со `status = ready` (`cipherSize = totalCipherSize(plaintextSize)`,
чтобы cache-hit отдавал корректный `total`). Тогда последующий `download(cdn)`
для только что залитого файла — cache-hit без сети и без расшифровки.
Best-effort: ошибка сида не валит успешный аплоад (глотается в лог).

## 5. DI

Правок нет: `CDNManager` уже зарегистрирован (`dependsOn: [API, Crypto, Auth,
Repositories]`), закачке хватает той же связки. `Downloads` — часть
`Repositories`.

## Явно не делаем сейчас

- **`MEDIA_INFO`** (получение `models.CDN` по `cdn_id` с сервера) — нужен только
  когда у потребителя будет один `cdn_id` (сообщение в чате), а не готовый `CDN`.
  Отдельная задача (proto + сервер), вне этого примитива.
- **UI-интеграция** (показ вложения, аватарки) — потребителей пока нет.
- **Авто-резюм/уборка** брошенных `downloads` при старте — данные для этого
  заложены, политика — продуктовое решение.
- **Шифрованный кэш на диске** — сейчас расшифрованный файл лежит в app-private
  cache в открытом виде. Если появится требование "plaintext не хранить на
  диске" — это отдельный редизайн (расшифровка в память на просмотр).

## Проверка

1. `flutter analyze` чист после правок (в т.ч. удаления `noncePrefix`).
2. Юнит-тесты `FileEncryptor` (round-trip, детерминированность, границы,
   усечение) — без сети.
3. Интеграционно (руками, против залитого через `uploadFile` файла): взять
   `models.CDN` из результата upload, `download(cdn)` → сверить, что
   расшифрованный файл побайтно равен исходному; оборвать сеть посреди закачки и
   проверить, что повтор резюмирует с правильного оффсета, а не с нуля.
