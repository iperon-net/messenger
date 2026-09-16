# Облачная адресная книга + гейт звонков (Stage 1)

## Context

Продолжение [OPRF-discovery](functional-stirring-giraffe.md). Сервер теперь ДОЛЖЕН знать соцграф «кто у кого в контактах», чтобы **гейтить звонки** в стиле Telegram: звонок `A→B` разрешён, если у B настройка `calls = everybody`, ИЛИ (`contacts`) `A ∈ contacts(B)`. Осознанное ослабление приватности OPRF ради контроля доступа; на этапе 1 enforcement ТОЛЬКО для звонков (сообщения/группы — позже, модель данных проектируется сразу общей per-channel).

«Облачная адресная книга» = серверный граф контактов — первоклассное хранилище (не побочка от MATCH). Источники наполнения (этап 1): (a) OPRF-discovery из системной книги, (b) ручное добавление по номеру в приложении. Работает даже без доступа к системной книге.

Транспорт — как в discovery: шифрованный `unaryEncoded`/`unaryEncodedWithResponse`. Хранение контактов — по **OPRF-отпечатку** номера (сервер не видит сырых номеров) + `contactUserID`, который сервер сам резолвит через `FindByOprf` при регистрации контакта (pending → resolved).

## Принятые решения (RESOLVED)

- **Правило доступа (Telegram-style):** проверка `A→B` целиком по стороне получателя B. У B per-channel настройка `calls ∈ {everybody, contacts}` (favorites отложен, добавляется без миграции). Дефолт `calls = contacts`. Deny = жёсткий `codes.PermissionDenied` (тихий quarantine/«call request» отложен). **Двусторонность:** на пройденном `A→B` сервер апсертит ребро `A→B` (source=Call), чтобы обратный звонок прошёл автоматически.
- **Хранилище Mongo:** документ-на-ребро (не embedded-массив — ради reverse-index/backfill/точечного remove). `oprf` храним ВСЕГДА, даже после резолва. Приватность не материализуем до первого изменения (нет записи = дефолт contacts).
- **Протокол:** запись графа — ОТДЕЛЬНЫЕ `CONTACTS_UPSERT`/`CONTACTS_REMOVE`; MATCH остаётся чистым discovery. Ручное добавление = UPSERT с source=MANUAL (клиент сам гоняет OPRF на 1 номере). `contactUserID` сервер всегда резолвит сам (клиенту не доверяем). Явный `remove` RPC сразу на этапе 1 (replace-all не покрывает iOS limited / ручное / отсутствие доступа к книге).
- **Гейт** в `relayCallSignal` на `CALL_RING` (НЕ на `CALL_TOKEN` — тот лишь чеканит room-JWT, обе стороны его просят). Инициирующий RING с клиента — **unary** (иначе стрим проглотил бы `PermissionDenied`).

## Серверная часть (Go, `~/GolandProjects/iperon`) — ✅ РЕАЛИЗОВАНО + ТЕСТЫ

Build/vet/`go test`/golangci-lint чисто; моки регенерированы. Сборка/тесты требуют `CGO_ENABLED=0` (иначе Xcode-license на cgo). Gen proto: `PATH=$(pwd)/bin:$PATH protoc --go_out=. --go-grpc_out=. ...`.

- **Proto:** `v1.proto` enum `CONTACTS_UPSERT=29, CONTACTS_REMOVE=30, PRIVACY_SETTINGS=31, PRIVACY_SETTINGS_UPDATE=32`; `contacts_v1.proto` (+ContactsUpsert `{Item{oprf,Source=OPRF|MANUAL}, bool full}`, ContactsRemove `{repeated bytes oprf}`); новый `privacy_v1.proto` (PrivacySettings get `{Audience calls}`, PrivacySettingsUpdate; Audience=EVERYBODY|CONTACTS).
- **Модели:** `models/contacts.go` (`ContactEdge{UserID, Oprf, ContactUserID*, Source, CreatedAt, UpdateAt}`, `ContactSource Oprf/Manual/Call`), `models/privacy.go` (`PrivacySettings`, `PrivacyAudience Everybody/Contacts`).
- **Репозитории:** `contacts.go` (Upsert/Remove/IsContact/AddCallEdge/ResolvePending, пишет через bson.M), `privacy.go` (Get→ErrPrivacySettingsNotFound/SetCalls). Индексы: `contacts` (userID_oprf uniq partial{oprf exists}, userID_contactUserID uniq partial{contactUserID exists}, contactUserID partial, oprf sparse), `privacySettings` (userId uniq). Дубль-ключи в upsert/backfill/AddCallEdge → warn.
- **Сервисы:** `ServiceContacts` (Upsert резолвит contactUserID через FindByOprf; Remove; CanCall; RecordCallEdge), новый `ServicePrivacy` (GetCalls дефолт Contacts / SetCalls).
- **API:** 4 кейса в `v1.go message()` + мапперы; гейт в `relayCallSignal` только на CALL_RING (deny→PermissionDenied; на пропуске RecordCallEdge A→B best-effort). **Backfill** в `RepositoryUsers.Create` (`ResolvePending(oprf,newID)` best-effort). Wiring: fx.go, api/di.go, interfaces.go, NewV1(+servicePrivacy), .mockery.yml.
- **Тесты:** `privacy_test.go`, `contacts_test.go` (на моках) + `contacts_repo_test.go`, `privacy_repo_test.go` (реальный in-process Mongo через memongo/setupTest). Запуск: `CGO_ENABLED=0 go test ./internal/...`.

## Клиентская часть (Flutter) — ✅ РЕАЛИЗОВАНО (код), `flutter analyze`/`dart format` чисто

Proto: enum 29-32 добавлен ВРУЧНУЮ в `v1.pbenum.dart` (+values, `_byValue` 28→32) и `v1.pbjson.dart` (не регенерить v1.* целиком); `contacts_v1.*`/`privacy_v1.*` регенерированы, export в `protobuf.dart`.

- **graph-sync** (`contacts_cubit.dart`): `_discoverOprf(..., fullAccess)` после каждой пачки шлёт `CONTACTS_UPSERT` (source OPRF, `full` только на первой пачке; iOS limited→full=false), best-effort. Общий примитив `_oprfOutputs(inputs)` (blind→evaluate→finalize).
- **Приватность звонков:** `SettingsPrivacyAndSecurityCubit`/State (+enum `CallsPrivacyAudience{everybody,contacts}`, дефолт contacts) грузит `PRIVACY_SETTINGS` / шлёт `PRIVACY_SETTINGS_UPDATE` оптимистично. Строка «Кто может звонить» в обоих `settings_privacy_and_security_*`. i18n `sessionsPrivacyAndSecurity.whoCanCall/callsEverybody/callsContacts`.
- **Гейт на звонке** (`calls.dart`): инициирующий RING → unary (`_sendRingInitiating`→`api.unaryEncoded(CALL_RING)`); при `StatusCode.permissionDenied`→`_teardown(CallEndReason.notAllowed)` (новый enum-кейс + i18n `screenCall.endedNotAllowed`, обработан в `call_view.dart`).

### Ручное add/remove + UX «облачных контактов» (итерации 2026-09-16)

- **`addByNumber({firstName, lastName, rawNumber})`** (`contacts_cubit.dart`): нормализация → OPRF по 1 номеру → `CONTACTS_UPSERT`(MANUAL, full=false) → `_matchUserID(oprf)` (userID или null). displayName = «Имя Фамилия» (при пустом → международный номер). Возвращает `ContactAddResult{addedRegistered,addedPending,invalidNumber,failed}`.
- **Устойчивые ручные контакты (manual-set):** добавленного номера НЕТ в телефонной книге устройства, поэтому он хранится отдельно — `_ManualContact` в кэше (`repositories.cache`, ключ `contacts_manual`, JSON). `discover()` **подмешивает** manual-set в `entries` перед OPRF (putIfAbsent — книга приоритетна), иначе replace-all снимка стёр бы его. На добавление контакт сразу: (1) в manual-set, (2) в снимок БД (`repositories.contacts.upsertOne`), (3) в state (`_insertContact`). `preload()` (фаза A из БД) показывает их, зная manual-set из кэша.
- **Локальный exclusion-set** (`contacts_excluded_e164`): удалённый номер ещё в книге → без него следующий discovery вернул бы его OPRF-ребром. `discover()`/`preload()` фильтруют excluded и не шлют их в UPSERT. `removeContact` добавляет e164 в exclusion + чистит manual-set; `addByNumber` снимает из exclusion (`_unexclude`).
- **Три группы в UI** (`_emitPartitioned` → `state.{registered, invitable, cloud}`): «В контактах» (из книги, зарегистрированы), **«Облачные контакты»** (в manual-set — добавлены вручную, любого статуса), «Пригласить» (из книги, не в Iperon). Группировка «облачных» — по membership в manual-set. `known`-map для перерисовки собирается из `registered`+`cloud`.
- **`removeContact(item)`:** OPRF → `CONTACTS_REMOVE` → exclusion + manual-remove → мгновенно убирает из всех трёх списков.
- **UX-решения (пользователь):**
  - Свайп-удаление (Dismissible endToStart + confirm) **ТОЛЬКО в «Облачных контактах»** — тайлы `_registeredTile`/`_invitableTile` получили флаг `removable` (обёртка `_dismissible`), книжные секции без удаления (их место — системная книга).
  - Добавление — **отдельный полноэкранный push-экран** `/contacts/add` (не диалог): `ContactsAddCupertino`/`ContactsAddMaterial` (поля Имя/Фамилия/Телефон с `PhoneInputFormatter` из формы авторизации). Роут вложен в `/contacts` c `parentNavigatorKey: rootNavigatorKey` + `pageBuilder: _page`/`_pageMaterial` (нативный переход/свайп-назад). Экран вне scope shell-провайдера `ContactsCubit` → возвращает `ContactAddInput` через `context.pop`; список (`_showAddByNumber`) ждёт `context.push<ContactAddInput>` и зовёт cubit.
  - Кнопка подтверждения: **Material — галочка `FontAwesomeIcons.check`** (как в редактировании профиля); **Cupertino — текст «Добавить»** (по правке пользователя).
- i18n `screenContacts`: `addByNumber/addByNumberHint/addFirstName/addLastName/add/addedRegistered/addedPending/addInvalidNumber/addFailed/remove/removeTitle/removeMessage/cloudContacts`.

## Осталось

- **E2E на устройстве (staging):** наполнение графа при discovery; дефолт-гейт (звонок не-контакту → экран «Нельзя позвонить»); смена настройки на everybody; двусторонность (после дозвона обратный проходит); ручное add по номеру (в т.ч. незарегистрированного → «Облачные», позже переезд в «В контактах» при регистрации); remove + переживание re-sync (exclusion). Нужно устройство + `flutter run` (нативные разрешения → `pod install`).
- **НИЧЕГО НЕ ЗАКОММИЧЕНО** (ни сервер, ни клиент). Перед push: `dart format lib` + `flutter analyze` (enforced в CI); сервер — `CGO_ENABLED=0 go test ./internal/...` + golangci-lint.
- Отложено (не этап 1): favorites-уровень; тихий quarantine вместо hard-deny; reverse-index push о регистрации (мгновенное обновление вместо 24h TTL); гейт для сообщений/групп; серверный rate-limit discovery.

## Риски / открытые вопросы

- **Enumeration через OPRF-оракул** — discovery/UPSERT без rate-limit позволяют перебор номеров. Лимит батча есть (1024), полноценный rate-limit — TODO.
- **manual-set vs книга:** контакт, добавленный вручную и позже появившийся в системной книге, остаётся в «Облачных» (membership в manual-set приоритетна). Осознанное упрощение.
- **Ротация серверного OPRF-ключа** инвалидирует все `user.oprf`, рёбра `contacts.oprf` и клиентские кэши — на MVP ключ статичный.
