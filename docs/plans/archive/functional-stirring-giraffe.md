# Приватный поиск контактов через OPRF

## Context

Экран «Контакты» (`/contacts`, первая вкладка) сейчас — заглушка (`Center(child: Text('Contacts'))`). Нужен полноценный экран, находящий, кто из телефонной книги пользователя зарегистрирован в Iperon, **не раскрывая серверу сырые номера** телефонной книги.

Текущий серверный поиск по номеру (`RepositoryUsers.FindByPhoneNumber`) детерминированный: `hex(sha256(config.Salt ‖ sha256(number)))` с одной глобальной солью. Сервер знает соль → может брутфорсить пространство номеров. Это и заменяем на OPRF.

**Что уже готово (проверено в коде):**
- Сервер: VOPRF ristretto255/SHA-512 (RFC 9497) в `internal/crypto/voprf.go` с полным API (`Blind`/`Evaluate`/`Finalize`/`FullEvaluate`). При регистрации в запись пользователя уже пишется `oprf = FullEvaluate(number)` (`internal/services/auth.go:306,925`; поле `models.User.Oprf`, `internal/repositories/users.go`). Серверный публичный ключ VOPRF + fingerprint отдаётся клиенту через `META_DATA_INFO` (`protos/metadata_v1.proto` → `MetadataInfo_VOPRF`).
- Клиент: образец полной вертикали — модуль **profile** (proto+repo+cubit+2 экрана+ветка в `api._handleMessage`); `Utils.phoneNormalization().e164` для канонизации; `api.unaryEncodedWithResponse`/`api.on`/`api.sendEncoded`; `MetadataInfo_Response.voprf.publicKey` уже вычитывается в auth-флоу.

**Чего нет (пробелы, которые закрывает план):**
- Сервер: нет discovery-RPC (слепой `Evaluate` не проброшен в сервисный слой — там только `FullEvaluate`; нет `MessageType`; нет `FindByOprf`).
- Клиент: нет чтения телефонной книги (+разрешений); нет клиентской ristretto/OPRF-крипты; нет модуля контактов; экран пустой.

## Принятые решения

- **Модель приватности:** 2-раундовый OPRF. Сервер узнаёт **пересечение** (какие контакты зарегистрированы), но **никогда — сырые номера**. Совпадает с уже хранимым полем `oprf`. (Полный PSI со скрытием пересечения — отдельная задача, вне объёма.)
- **Крипта клиента:** ✅ **реализована и провалидирована** (`lib/crypto/oprf.dart`, тест `test/oprf_test.dart`). Клиентская сторона `bytemare/voprf` в режиме **VOPRF (mode 0x01)** — не базовый OPRF 0x00, как предполагалось изначально, — поверх Dart-пакета [`ristretto255`](https://pub.dev/packages/ristretto255) 1.0.2 (порт gtank/ristretto255 — той же библиотеки, что тянет Go-сервер) + `package:cryptography` (SHA-512). FFI на Rust не понадобился. Спайк подтвердил байт-совместимость с сервером (векторы из `bytemare/voprf@v0.21.0`).
  - Точные факты (проверены в исходниках сервера): context-строка = `OPRFV1-\x01-ristretto255-SHA512` (идентификатор без дефиса перед 512, **не** как в RFC 9497 → RFC-тест-векторы не подходят). HashToGroup = `expand_message_xmd(SHA-512, msg, "HashToGroup-"+ctx, 64)` → `Element.fromUniformBytes`. Серверный `Evaluate` возвращает сериализованную `Evaluation` = `I2OSP(ne,2) ‖ I2OSP(lp,2) ‖ elements ‖ proofC ‖ proofS` (для 1 элемента = 100 байт с DLEQ-пруфом). Finalize = `SHA-512(lenPrefix(input) ‖ lenPrefix(N) ‖ "Finalize")`. DLEQ-пруф клиент пока **не проверяет** (для матчинга не нужен при честном сервере; проверка — hardening-TODO).
- **UX:** список контактов книги — сверху найденные в Iperon (тап → профиль/чат), ниже остальные с кнопкой «Пригласить». Плюс поиск.
- **Объём:** полная вертикаль сервер (Go) + клиент (Flutter).

## Протокол (2 раунда)

Раунд 1 — слепая оценка:
1. Клиент нормализует каждый контакт в e164 (`Utils.phoneNormalization`), отбрасывает пустые/дубликаты.
2. Для каждого номера: `(blind, blindedElement) = OPRF.Blind(e164)` (hash-to-ristretto255 → умножение на случайный скаляр).
3. Клиент шлёт `repeated bytes blindedElements` серверу.
4. Сервер: `evaluatedElement = Evaluate(blindedElement)` своим приватным ключом (номер не виден). Возвращает `repeated bytes evaluatedElements` в том же порядке.
5. Клиент: `oprfOutput = Finalize(e164, blind, evaluatedElement)` → равно `FullEvaluate(e164)`, что сервер хранит в `user.oprf`.

Раунд 2 — проверка членства:
6. Клиент шлёт `repeated bytes oprfOutputs` (готовые отпечатки).
7. Сервер `FindByOprf(oprfOutputs)` → возвращает совпадения: для каждого найденного `{ oprf, userID }` (можно сразу минимальную карточку). Клиент сопоставляет `oprf` с локальным номером.

Оба раунда — через persistent-стрим (`sendEncoded`/`on`) либо `unaryEncodedWithResponse` (шифруется сессионным ключом). Батчинг: слать пачками (напр. по 512 элементов), т.к. книга может быть большой.

## Серверная часть (Go, `~/GolandProjects/iperon`) — ✅ ГОТОВО

Реализовано, собирается (`go build ./...`), `go vet`, тесты и `golangci-lint` — чисто; моки регенерированы (`task mockery`). Транспорт — шифрованный request/response через существующий `exchangeEncrypted`.
1. **Proto:** `protos/contacts_v1.proto` — `ContactsDiscoveryEvaluate.{Request,Response}` и `ContactsDiscoveryMatch.{Request,Match,Response}`. Сгенерировано (`PATH=bin protoc ...`, т.к. `task gen` требует плагины из `bin/`).
2. **MessageType:** `CONTACTS_DISCOVERY_EVALUATE = 24`, `CONTACTS_DISCOVERY_MATCH = 25` в `protos/v1.proto` (клиент должен совпасть).
3. **Evaluate:** `Evaluate(blindedElement)` добавлен в `services.CryptoVOPRFInterface` (реализация уже была в `internal/crypto/voprf.go`).
4. **Репозиторий:** `RepositoryUsers.FindByOprf` (Mongo `$in`, `bson.Binary`, проекция `_id`+`oprf`, без расшифровки номера) + sparse-индекс на `oprf` в `repositories.go`.
5. **Сервис:** `internal/services/contacts.go` (`ServiceContacts.Evaluate`/`Match`), провайден в `services/fx.go`.
6. **Handler:** два кейса в `internal/api/v1.go` через `exchangeEncrypted`; `ServiceContactsInterface` в `api/interfaces.go`, поле+конструктор V1, wiring в `api/di.go`.
7. **Лимит батча:** `contactsDiscoveryBatchLimit = 1024` (простой потолок; полноценный rate-limit — TODO).

**Осталось по серверу (не в этом заходе):** unit-тест `FindByOprf`/`ServiceContacts`; полноценный rate-limit; опциональная проверка, что стоит ли перевести Evaluate в OPRF-режим (без DLEQ-пруфа) ради экономии 64 байт/элемент.

## Клиентская часть (Flutter, `/Users/kostya/IdeaProjects/messenger`) — ✅ ГОТОВО (код)

Реализовано; `flutter analyze` и `dart format` — чисто, `test/oprf_test.dart` зелёный. Транспорт — `api.unaryEncodedWithResponse` (два раунда). Экраны заменили заглушки в `lib/screens/home/contacts_*.dart`, route обёрнут в `BlocProvider<ContactsCubit>` в обеих ветках `routers.dart`.

**Важная поправка (найдена в коде auth):** OPRF-вход = `Utils.phoneNormalization(...).raw` (цифры без `+`), **не** `.e164` — именно эту строку сервер `FullEvaluate` при регистрации (`internal/services/auth.go`: клиент шлёт `raw`, сервер `TrimPrefix(+)`). Иначе отпечатки не совпадут.

**Нюанс генерации proto:** локальный `protoc-gen-dart` (protoc_plugin 25.0.0) новее версии, которой сгенерирован репозиторий → полная регенерация `v1.*` даёт лишний churn и ломает orphan `v1.pbserver.dart` (в HEAD дескриптор `IperonServiceBase$json` лежит в `v1.pbjson.dart`, новый плагин его убирает). Решение: `v1.pb/pbgrpc/pbjson.dart` откатаны к HEAD, в `v1.pbenum.dart`+`v1.pbjson.dart` вручную добавлены 2 значения `MessageType` (24/25) и поднят предел `_byValue`. `contacts_v1.*` — новые файлы (новый стиль плагина, совместимы).

Реализованные файлы: `lib/crypto/oprf.dart` (крипта), `lib/cubit/contacts/` (cubit+state+mapper), `lib/repositories/contacts.dart` (+миграция 2), `lib/screens/home/contacts_*.dart`, i18n `screenContacts`, разрешения (Android `READ_CONTACTS`, iOS `NSContactsUsageDescription` + локализации).

### Осталось (ручная проверка / доработки)
- **E2E на устройстве:** `flutter run` (+`pod install` из-за нативных разрешений), реальная книга, 2 тестовых номера на staging → проверить секции «В Iperon»/«Пригласить» и что в логах сервера нет сырых номеров. Не выполнено в этом заходе (нужно устройство).
- Тяжёлый blind в isolate при очень большой книге; проверка DLEQ-пруфа; серверный rate-limit.

### Зависимости и разрешения
- `pubspec.yaml`: добавить `ristretto255`, `flutter_contacts` (чтение книги). `permission_handler` уже есть.
- Android: `READ_CONTACTS` в `android/app/src/main/AndroidManifest.xml`.
- iOS: `NSContactsUsageDescription` — **локализованно** в `ios/Runner/{en,ru}.lproj/InfoPlist.strings` (+ дефолт в `Info.plist`), по паттерну камеры/фото из CLAUDE.md.

### Крипта — `lib/crypto/oprf.dart` ✅ ГОТОВО
Класс `Oprf` (`part of 'crypto.dart'`, доступен через `getIt.get<Crypto>().oprf`):
- `Future<(Uint8List blind, Uint8List blindedElement)> blind(input, {fixedBlind})` — `fixedBlind` только для тестов.
- `Future<Uint8List> finalize({input, blind, evaluation})` → выход OPRF (== `user.oprf`).
- Внутри: `expand_message_xmd(SHA-512)`, hash-to-group, разбор `Evaluation`, unblind, финальный хэш — всё реализовано и покрыто тестом на Go-векторах.

Публичный ключ VOPRF (`MetadataInfo_Response.voprf.publicKey`) понадобится только для будущей проверки DLEQ-пруфа — в текущей реализации не используется.

### Proto клиента
- Скопировать `protos/contacts_v1.proto`, сгенерировать в `lib/protobuf/protos/contacts_v1.pb.dart`, добавить `export` в barrel `lib/protobuf/protos/protobuf.dart`. Обновить `MessageType` в `lib/protobuf/protos/v1.pbenum.dart` (регенерация из `v1.proto`).

### Репозиторий (локальный кэш) — `lib/repositories/contacts.dart`
`part of 'repositories.dart'` по образцу `profiles.dart`: таблица `contacts` (миграция `migrations.add(SqliteMigration(n, ...))` — **новая, не править существующие**): `phoneE164`, `oprf BLOB`, `userID BLOB NULL`, `displayName`, `isRegistered`, `lastSyncedAt`. Методы `upsertAll`, `getRegistered`, `getAll`, `markRegistered`. Зарегистрировать в `repositories.dart` (`part`, поле, init).

### Cubit — `lib/cubit/contacts/`
По образцу `lib/cubit/profile/`:
- `contacts_cubit.dart` (`ContactsCubit extends Cubit<ContactsState>`): `initialization()` —
  1. проверить/запросить разрешение (`permission_handler`);
  2. прочитать книгу (`flutter_contacts`), нормализовать → e164;
  3. мгновенно отдать кэш из `repositories.contacts`;
  4. запустить синк: `blind` всех → раунд 1 (`unaryEncodedWithResponse`, батчами) → `finalize` → раунд 2 → `upsertAll` + `emit(success)`.
  - методы: `refresh()`, `search(query)`, `invite(contact)` (SMS/share-list).
- `contacts_state.dart` (`@MappableClass` + `part '.mapper.dart'`): `status`, `error`, `List<ContactItem> registered`, `List<ContactItem> invitable`, `query`. Запустить `build_runner` после.
- Экспорт cubit в `lib/cubit/cubit.dart`.

### Экраны — `lib/screens/contacts/contacts_cupertino.dart` + `contacts_material.dart`
Заменить заглушки в `lib/screens/home/contacts_*.dart` (или вынести и обновить импорт вкладки). `BlocProvider<ContactsCubit>` поднять в шелле вкладки (`home_cupertino.dart`/роутер), как profile.
- Cupertino: `CupertinoPageScaffold` + `AppCupertinoNavigationBar` (поиск), `CupertinoListSection.insetGrouped` двумя секциями: «В Iperon» (аватар `AnimatedBoringAvatar`/`Image.memory`, тап → `/profile/:userID` или чат) и «Пригласить» (кнопка «Пригласить»). Состояния: запрос разрешения / загрузка / пусто.
- Material: зеркально (`material_ui`), по паттерну пары экранов.
- i18n: добавить ключи в `lib/i18n/en.i18n.yaml` + `ru.i18n.yaml` (заголовки секций, кнопки, тексты разрешений), `dart run slang`.

### Приём в стриме (опц.)
Если Match ходит через persistent-стрим, добавить ветку в `api._handleMessage` (`lib/api.dart`, рядом с `case MessageType.PROFILE`). Если через `unaryEncodedWithResponse` — не нужно.

## Verification

1. **Спайк совместимости крипты — ✅ ВЫПОЛНЕН.** `flutter test test/oprf_test.dart` зелёный: `blind` (с фикс. blind) даёт серверный `blindedElement`, `finalize` даёт `user.oprf`. Эталон — векторы `bytemare/voprf@v0.21.0`. Пакет `ristretto255` дал все нужные операции; FFI не понадобился.
2. **Сервер:** unit на `FindByOprf`; ручной прогон Evaluate/Match-хендлеров.
3. **E2E:** `flutter run` на устройстве с реальной книгой; зарегистрировать 2 тестовых номера на staging; убедиться, что они попали в секцию «В Iperon», остальные — в «Пригласить». Проверить логи сервера — сырых номеров книги там быть не должно.
4. `flutter analyze` + `dart format lib` перед push (enforced в CI).

## Риски / открытые вопросы

- **Совместимость DST/финализации** между Dart-реализацией и `bytemare/voprf` — главный риск; закрывается спайком (#1).
- **Enumeration через OPRF:** сервер — оракул `FullEvaluate`; лимиты батча/rate-limit на discovery обязательны, иначе клиент может перебирать номера. (OPRF защищает от офлайн-брутфорса соли, но не от онлайн-перебора без лимитов.)
- **Ротация серверного OPRF-ключа** инвалидирует все хранимые `user.oprf` и клиентские кэши — на MVP считаем ключ статичным (как сейчас в конфиге).
- **Производительность** на большой книге: батчинг + вычисление blind в isolate при необходимости.
