# Экран профиля пользователя (по userID / username)

## Context

Сейчас в приложении есть только экран **своего** профиля (`SettingsMyProfile*`), работающий через
`MessageType.MY_PROFILE`. На сервере в последнем коммите
(`6a03600` — "feat(services): add service to fetch public user profiles") уже добавлен публичный
профиль чужого пользователя: `MessageType.PROFILE = 23`, `protos/profile_v1.proto`
(`Profile.Request{userID}` / `Profile.Response{firstName,lastName,aboutMe,birthDate,avatar(CDN),
username,phoneNumber}`), сервис `ServiceProfile.GetByUserID` и хендлер в `internal/api/v1.go`.

Нужно на клиенте: экран просмотра чужого профиля (Фамилия/Имя, телефон, username, аватар),
локальный кэш в новой таблице `profiles`, скачивание аватара в существующую таблицу `downloads`,
и обработку входящего `PROFILE` в `API._handleMessage` (запись в `profiles` + скачивание аватара).

По решению пользователя дополнительно дорабатывается **сервер**: (1) поиск профиля по `username`
(сейчас только по `userID`); (2) добавление `userID` в `Profile.Response` (иначе `_handleMessage`
не знает, к какому пользователю относится пришедший в стриме профиль).

Клиентский код переиспользует готовый паттерн «свой профиль»: `SettingsMyProfileCubit`
(`lib/cubit/settings/settings_my_profile_cubit.dart`), репозиторий `MyProfile`
(`lib/repositories/my_profile.dart`), модель `MyProfile` (`lib/models/my_profile.dart`) и
`CDNManager` (`lib/cdn.dart`) — скачивание/расшифровка аватара уже реализованы там и не меняются.

---

## Часть A. Сервер (`~/GolandProjects/iperon`)

### A1. `userID` в ответе
`protos/profile_v1.proto` → `Profile.Response`: добавить `optional bytes userID = 8;`.
Хендлер `internal/api/v1.go` (`case v1.MessageType_PROFILE`, ~стр. 758) — заполнить
`UserID: userID[:]` в возвращаемом `Profile_Response`. Регенерировать `profile_v1.pb.go`.

### A2. Поиск по username
- `protos/profile_v1.proto` → `Profile.Request`: сделать выбор идентификатора
  `oneof identifier { bytes userID = 1; string username = 2; }`.
- `internal/repositories/profile.go`: добавить `GetByUsername(ctx, username)` (Mongo-запрос по
  полю `username`; убедиться, что на коллекции `profiles` есть индекс по `username`).
- `internal/services/profile.go`: `ServiceProfile` — метод получения профиля по username
  (внутри резолвит userID, дальше та же логика, что `GetByUserID`).
- `internal/api/v1.go` (`case v1.MessageType_PROFILE`): ветвление по `Request.identifier` —
  userID (12 байт, как сейчас) либо username → соответствующий вызов сервиса.
- Обновить интерфейс `ServiceProfileInterface` (`internal/api/interfaces.go`).

> Проверить/добавить unique-индекс `username` в Mongo-коллекции `profiles` для быстрого lookup.

---

## Часть B. Клиент (`/Users/kostya/IdeaProjects/messenger`)

### B1. Protobuf
- Скопировать серверный `profile_v1.proto` (с правками A1/A2) в `protos/profile_v1.proto`.
- В `protos/v1.proto` добавить в enum `MessageType`: `PROFILE = 23;` (сейчас последний `= 22`).
- Регенерировать Dart protobuf через `protoc` (см. CLAUDE.md → `lib/protobuf/`): появятся
  `lib/protobuf/protos/profile_v1.pb.dart` и обновится сгенерированный `MessageType`.
  Убедиться, что новый тип реэкспортируется через `lib/protobuf.dart`.

### B2. Таблица `profiles` (миграция)
Файл `lib/repositories/repositories.dart`, DDL таблицы `profiles` (уже добавлен в migration 1,
~стр. 193-205, незакоммичен). **Исправить и дополнить прямо в migration 1** (таблица ещё не
поставлялась в релиз; существующим dev-БД потребуется `IS_DELETE_DATABASE=1`):
- Убрать висячую запятую после `FOREIGN KEY (avatarCdnID) ...` — иначе `CREATE TABLE` падает.
- Добавить колонку `phoneNumber TEXT NULL` (в `Profile.Response` телефон есть; свой профиль
  берёт телефон из `users`, но для чужого его нужно хранить здесь).
- Индекс по username (пользователь просил): `CREATE INDEX idx_profiles_username ON profiles(username);`
  (`userID` уже покрыт `UNIQUE`).
- Итоговые колонки: `profileID PK, userID BLOB UNIQUE, username, fistName, lastName, birthDate,
  aboutMe, phoneNumber, avatarCdnID BLOB → downloads(cdnID)`. FK на `users` **не** добавлять
  (чужой профиль не связан с локальной `users`).

### B3. Модель `Profile`
Новый `lib/models/profile.dart` по образцу `lib/models/my_profile.dart`
(`@MappableClass(includeCustomMappers: [EpochDateTimeMapper()])`, `part 'profile.mapper.dart'`):
поля `userID`, `username`, `fistName`, `lastName`, `birthDate?`, `aboutMe`, `phoneNumber`,
`avatarCdnID (List<int>?)`. Добавить экспорт в `lib/models.dart`. Запустить `build_runner`.

### B4. Репозиторий `Profiles`
Новый part-файл `lib/repositories/profiles.dart` (`part of 'repositories.dart';`) по образцу
`my_profile.dart`. Методы:
- `getByUserID({required List<int> userID}) -> models.Profile` (SELECT всех колонок, пустая
  модель если нет).
- `upsert({userID, fistName, lastName, birthDate, aboutMe, username, phoneNumber})` — INSERT …
  ON CONFLICT(userID) DO UPDATE (все текстовые поля профиля разом).
- `updateAvatarByCdnID({userID, cdnID})` — как в `MyProfile`.

Подключить в `repositories.dart`: `part "profiles.dart";` (блок part'ов, ~стр. 17-24),
поле `late Profiles profiles;` (~стр. 51-58), инициализацию
`profiles = Profiles(logger: logger, db: db);` в конце `_initialization()` (~стр. 249-256).

### B5. `API._handleMessage` — обработка `PROFILE`
`lib/api.dart`, `_handleMessage` (switch, ~стр. 510). Добавить ветку по образцу `MY_PROFILE`
(стр. 533):
```
case MessageType.PROFILE:
  final payload = Profile_Response.fromBuffer(message.payload);
  final userID = payload.userID;               // добавлен в A1
  await repositories.profiles.upsert(userID: userID, fistName: ..., lastName: ...,
      birthDate: payload.hasBirthDate() ? payload.birthDate.toDateTime(toLocal:true) : null,
      aboutMe: ..., username: ..., phoneNumber: ...);
  if (payload.hasAvatar()) {
    final cdn = models.CDN.fromProto(payload.avatar);
    await getIt.get<CDNManager>().download(cdn: cdn);           // сидит кэш downloads
    await repositories.profiles.updateAvatarByCdnID(userID: userID, cdnID: cdn.cdnID);
  }
```
Скачивание аватара cache-aware (`CDNManager.download`) — повторный вызов из кубита даст cache-hit.

### B6. Cubit `ProfileCubit`
Новый `lib/cubit/profile/profile_cubit.dart` + `profile_state.dart`
(`@MappableClass`, поля: `status`, `firstName`, `lastName`, `username`, `phoneNumber`,
`birthDate?`, `aboutMe`, `avatarBytes?`, `boringAvatarHash`, `error`) — по образцу
`SettingsMyProfileCubit`/`SettingsMyProfileState`. Экспорт кубита в `lib/cubit/cubit.dart`.

`initialization({required List<int> userID, required AppLocale locale})`:
1. Показать кэш сразу: `repositories.profiles.getByUserID` → emit полей; если `avatarCdnID`
   не пуст — `cdnManager.cachedFile(...)` → emit `avatarBytes` (без сети).
2. Подписаться на `api.on(MessageType.PROFILE)`; в листенере распарсить `Profile_Response`,
   **отфильтровать по `payload.userID == userID`**, emit полей и — при `hasAvatar()` —
   `cdnManager.download(...)` → emit `avatarBytes`. (Запись в БД делает `_handleMessage`.)
3. Отправить запрос: `api.sendEncoded(MessageType.PROFILE, Profile_Request(userID: userID).writeToBuffer())`
   (по username — `Profile_Request(username: ...)`).
4. `phoneNumber` форматировать через `utils.phoneNormalization(...).international`; `boringAvatarHash`
   — от userID/телефона.

`close()` — отменить подписку.

### B7. Экран + маршрут
- Экраны `lib/screens/profile/profile_cupertino.dart` и `profile_material.dart` по образцу
  `lib/screens/settings/settings_my_profile_cupertino.dart` (+ material), но **read-only**
  (без редактирования/выбора аватара): аватар (или `flutter_boring_avatars` плейсхолдер),
  Фамилия+Имя, телефон, username, «о себе». `BlocBuilder<ProfileCubit, ProfileState>`.
- Маршруты в `lib/routers.dart` в **обе** ветки (cupertino `_common` и material `_commonMaterial`):
  `GoRoute(path: "/profile/:userID", parentNavigatorKey: rootNavigatorKey, pageBuilder: _page/_pageMaterial(...))`
  с `BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()..initialization(userID: hexToBytes(state.pathParameters['userID']!), locale: ...))`.
  Открывать через `context.go('/profile/<hex-userID>')` (userID в hex, `Utils.bytesToHex`/`hexToBytes`).

### B8. i18n
Добавить строки экрана в `lib/i18n/en.i18n.yaml` и `ru.i18n.yaml` (напр. `screenProfile.*`:
заголовок, подписи телефона/username/«о себе»), затем `dart run slang`.

---

## Verification

1. Сервер: пересобрать, поднять staging/локально; проверить `PROFILE` по userID и по username
   (grpcurl/тест) — в ответе есть `userID`, `phoneNumber`, `avatar`.
2. Клиент: `flutter pub get`; регенерация — `protoc` (protobuf), `dart run build_runner build
   --delete-conflicting-outputs` (mapper), `dart run slang` (i18n).
3. `flutter analyze` + `dart format lib` (CI en-forced).
4. Запустить с `IS_DELETE_DATABASE=1` (пересоздать БД с таблицей `profiles`).
5. Перейти на `/profile/<hex-userID>` существующего пользователя: убедиться, что показаны ФИО,
   телефон, username, аватар; повторное открытие — аватар мгновенно из кэша (без сети).
6. Проверить запись строки в таблицу `profiles` и файла в `downloads` (лог `CDNManager` /
   инспекция БД); убедиться, что `_handleMessage` не падает при отсутствии аватара.

---

## Статус выполнения (2026-09-09)

Реализовано и проверено (`flutter analyze` — чисто, `dart format` — ок; сервер `go build`/`vet`/`gofmt` — чисто):

- **Сервер (A1/A2):** `oneof identifier{userID|username}` в `Profile.Request`, `userID` в `Profile.Response`;
  `GetByUsername` в репозитории/сервисе (`getByFilter`, `enrich`), ветвление в хендлере `PROFILE`
  (`NotFound` при отсутствии), обновлены интерфейсы, перегенерированы protobuf + моки.
- **Клиент (B1–B8):** proto + `PROFILE=23`, таблица `profiles` (+ `phoneNumber`, индекс `idx_profiles_username`)
  и репозиторий `Profiles`, модель `Profile`, ветка `PROFILE` в `API._handleMessage`, `ProfileCubit`/`ProfileState`,
  экраны `profile_cupertino/material`, маршрут `/profile/:userID` в обеих ветках роутера, i18n `screenProfile`.
- **Точка входа для теста:** кнопка «Мой профиль» на вкладке «Звонки» (Cupertino + Material) →
  `context.go('/profile/$_myUserID')`. Полноценные переходы из контактов/чатов — отдельной задачей.

Осталось: прогон вживую (пункты 4–6 выше) на устройстве с поднятым сервером.
