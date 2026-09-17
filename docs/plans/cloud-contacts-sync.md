# Облачные контакты (синхронизация между устройствами)

## Context

Сейчас у пользователя с двумя устройствами добавленные вручную контакты (группа «Облачные» в UI, `ContactsState.cloud`) **не видны второму устройству**. Причины:

- Вручную добавленный контакт (`ContactsCubit.addByNumber`, source `MANUAL`) хранится **локально**: в таблице `cache` под ключом `contacts_manual` (keyed by userID) + в снимке `contacts`. На сервер уходит только OPRF-отпечаток номера (`CONTACTS_UPSERT`) — ребро для гейта звонков, **без PII**.
- Серверный граф хранит только OPRF-отпечатки (необратимый хэш), имени/номера там нет.
- Нет RPC на чтение графа (`ContactsDiscoveryEvaluate/Match`, `ContactsUpsert`, `ContactsRemove` — всё; ни `List`, ни stream-пуша).

Контакты из телефонной книги (registered/invitable) «появляются» на втором устройстве только потому, что оно само прогоняет **свою** книгу через OPRF — а не из-за синхронизации.

**Задача:** дать облачную синхронизацию контактов как **опцию**, пожертвовав приватностью только для неё. Обычные (книжные) контакты остаются как есть — OPRF, PII локально. Для облачных сервер хранит имя/фамилию/номер, зашифрованные **at-rest**.

## Принятые решения

- **Гранулярность выбора — вариант A (зафиксировано).** `addByNumber` (ручное добавление) = **всегда** облачный. Контакты из телефонной книги = **всегда** локальные/приватные (как сейчас). Никакого per-contact/глобального тумблера на старте. Per-contact «в облако» для книжных — потенциальный Этап 4, если появится спрос.
- **Источник облачного ребра — правило без enum (вариант A, зафиксировано).** «Пришло непустое `phoneNumber` ⇒ ребро облачное». Маркер в БД — наличие `phoneEnc`. Новый `Source CLOUD` не вводим (при решении 1A книжных облачных не существует — все облачные это `MANUAL`).
- **`ContactsList` — полный список без пагинации (вариант A, зафиксировано).** Курсор в `Request` резервируем на будущее, не реализуем.
- **Лимит облачных контактов на владельца — 5000, вынесен в конфиг (зафиксировано).** Проверка в `ServiceContacts.Upsert`; значение читается из настроек (`config.Contacts.CloudLimit`, `env-default:"5000"`), а не хардкодом.
- **Две дорожки сосуществуют.** Обычные контакты (телефонная книга) — без изменений: OPRF-discovery, PII локально, на сервере только OPRF-ребро. Облачные — новый опциональный слой поверх того же ребра: дополнительно PII на сервере + синхронизация.
- **Шифрование at-rest, НЕ E2E.** Ключ у сервера (`crypto.Encryptor`, `settings.GetEncryptorSecret()`). Защищает от кражи дампа БД, **не от оператора**: чтобы отдать контакт на другое устройство, сервер его расшифровывает. Это осознанная жертва ради простоты (растворяет проблему передачи ключа между устройствами — передавать нечего).
  - **UI-честность:** тумблер называть по свойству — «Синхронизировать между устройствами» / «Облачные контакты», **не** «приватные». Приватный — это OPRF-путь. (Telegram-модель как опция поверх Signal-модели.)
- **Пофайловое шифрование** (не единый blob): три отдельных BLOB — `firstNameEnc`, `lastNameEnc`, `phoneEnc`. С точки зрения приватности разницы нет (ключ всё равно у сервера) — это выбор формы схемы: чище колонки, частичное обновление. Цена — 3×128 байт header'а на контакт (~75 КБ на 300 контактов, мелочь).
- **`displayName` не храним** — производный (`firstName + " " + lastName`, фолбэк на номер), клиент восстановит сам.
- **Nonce-колонок нет.** `Encryptor` — самодостаточный контейнер: 128-байтный `headerPadding` несёт version/length/sha256/nonce/contentType, дальше GCM-шифротекст. `HeaderParse` читает `Nonce = dataBytes[41:53]`. Один BLOB на поле.
- **`hkdfSalt = []byte(ownerUserID.Hex())`** — привязка шифротекста к владельцу; доступен и на encrypt, и на decrypt. `contentType = EncryptorContentTypeApplicationOctetStream`, один `Encrypt` на поле.
- **Маркер «облачный» = наличие `phoneEnc`.** У облачного контакта номер есть всегда (add-by-number или книжный контакт с номером). У OPRF-only рёбер и call-рёбер `phoneEnc` нет. Надёжно отличает. (Альтернатива — явный `cloud bool`; не берём, лишнее поле.)
- **PII в proto — открытым текстом.** Клиент шлёт `firstName/lastName/phoneNumber` строками; канал уже защищён сессией (`exchangeEncrypted`). Сервер шифрует **перед записью**, расшифровывает **перед отдачей**. В proto никаких `_enc`/`_nonce`.
- **Правило «PII присутствует ⇒ облачное ребро»** — не плодим новый `Source`. `MANUAL` остаётся, книжный контакт в облаке идёт `source=OPRF` + PII.

## Модель данных

### Mongo, коллекция `contacts` (добавка к документу-ребру)

```
_id, userID, oprf, contactUserID, source, createdAt, updateAt   // как сейчас
firstNameEnc  BinData(0x00)   // Encryptor output; omitempty
lastNameEnc   BinData(0x00)   // omitempty (пустая фамилия ⇒ нет поля)
phoneEnc      BinData(0x00)   // omitempty; наличие = «облачный контакт»
```

**Индексы — без изменений.** Облачные запросы идут по `userID` (покрыт `userID_oprf`). По зашифрованным полям не ищем (детерминированного шифрования нет — для поиска по номеру уже есть `oprf`).

**Миграции не нужны:** старые рёбра просто без PII-полей. Ре-апсертом ничего не ломаем.

### `internal/models/contacts.go` — `ContactEdge`

```go
type ContactEdge struct {
	UserID        bson.ObjectID
	Oprf          []byte
	ContactUserID *bson.ObjectID
	Source        ContactSource
	// Облачные PII, зашифрованные at-rest (nil ⇒ приватное OPRF-ребро).
	FirstNameEnc []byte
	LastNameEnc  []byte
	PhoneEnc     []byte
	CreatedAt time.Time
	UpdateAt  time.Time
}
```

## Proto

### `protos/contacts_v1.proto` — новые сообщения

```proto
// Cloud-контакт: PII, синхронизируемое между устройствами. Сервер хранит поля
// шифрованными at-rest (Encryptor, hkdfSalt=ownerUserID), но ДЕРЖИТ КЛЮЧ — это
// не E2E. Пустые firstName/lastName/phoneNumber ⇒ приватное OPRF-ребро (как раньше).
message Contact {
  bytes oprf = 1;                  // отпечаток номера — адрес ребра
  bytes contactUserID = 2;         // резолв; пусто пока pending
  ContactsUpsert.Source source = 3;
  string firstName = 4;
  string lastName = 5;
  string phoneNumber = 6;
  int64 updatedAt = 7;             // epoch ms — для дельт/сортировки
}

// Полный список облачных контактов владельца — тянется новым устройством на
// bootstrap. Сервер отдаёт PII уже расшифрованным.
message ContactsList {
  message Request {}               // владелец из сессии
  message Response {
    repeated Contact contacts = 1; // только рёбра с PII (phoneEnc exists)
  }
}

// Push-дельта всем устройствам владельца (NATS user.<hex>) при add/remove/resolve.
message ContactsUpdated {
  repeated Contact upserted = 1;
  repeated bytes removedOprf = 2;
}
```

### `protos/contacts_v1.proto` — `ContactsUpsert.Item` +3 поля

```proto
message Item {
  bytes oprf = 1;
  Source source = 2;

  // Только для облачных контактов. Пусто ⇒ приватное OPRF-ребро, PII не покидает
  // устройство. Открытый текст в защищённом сессией канале; сервер шифрует at-rest.
  string firstName = 3;
  string lastName = 4;
  string phoneNumber = 5;
}
```

### `protos/v1.proto` — `MessageType` (следом за `PRIVACY_SETTINGS_UPDATE = 32`)

```proto
CONTACTS_LIST    = 33;   // unary pull (bootstrap нового устройства)
CONTACTS_UPDATED = 34;   // push-дельта на устройства владельца
```

**Генерация:** `protoc` в обоих репах → обновить `lib/protobuf/**` (клиент) и `internal/api/v1/*.pb.go` (сервер). Клиент: не забыть `_omitEnumNames`-стиль enum (генерится автоматически).

## Серверная часть (Go, `~/GolandProjects/iperon`)

1. **`models.ContactEdge`** — добавить `FirstNameEnc/LastNameEnc/PhoneEnc []byte` (см. выше).
2. **`RepositoryContacts.Upsert`** (`internal/repositories/contacts.go`) — в `$set` класть непустые блобы `bson.Binary{Subtype: 0x00, Data: edge.FirstNameEnc}` и т.д. `replaceAllDelete` не трогаем (по `source=OPRF`; книжный облачный контакт переживёт replace-all, пока его `oprf` в наборе книги — приемлемо).
3. **`RepositoryContacts.List(ctx, userID)`** — новый метод: `Find(bson.M{"userID": userID, "phoneEnc": bson.M{"$exists": true}})` → `[]ContactEdge` с блобами. Плюс `CountCloud(ctx, userID)` — `CountDocuments({userID, phoneEnc: {$exists: true}})` для проверки лимита.
4. **Конфиг лимита** (`internal/settings/settings.go`): добавить в `Config` блок
   ```go
   Contacts struct {
       CloudLimit int `yaml:"cloudLimit" env-default:"5000"`
   } `yaml:"contacts"`
   ```
   + геттер `GetContactsCloudLimit() int` в `Settings` и в `SettingsInterface` сервиса контактов.
5. **`ServiceContacts`** (`internal/services/contacts.go`):
   - инжект `cryptoEncryptor CryptoEncryptorInterface` (как в `ServiceMyProfile`/`ServiceAuth`) + `publisher *ServicePublisher` + `settings` (для лимита).
   - `Upsert`: **лимит** — перед записью облачных рёбер `repositoryContacts.CountCloud(userID) + len(новые облачные) > GetContactsCloudLimit()` → `codes.ResourceExhausted`. Для рёбер с PII — `Encrypt(ctx, salt, strings.NewReader(field), &buf, OctetStream)`, `salt = []byte(ownerUserID.Hex())` → `edge.*Enc = buf.Bytes()`. После записи — пуш дельты.
   - `List(ctx, ownerUserID) ([]Contact, error)`: repo.List → `Decrypt` каждого `*Enc` → открытые строки.
   - вспомогательные `encryptField`/`decryptField` (пусто ⇒ nil / "").
6. **API-хендлеры** (`internal/api/v1.go`):
   - `CONTACTS_UPSERT`: из `item` вычитывать `GetFirstName/GetLastName/GetPhoneNumber` в `edge` (пусто — не облачный).
   - `CONTACTS_LIST` (новый `case`, шаблон — `MY_PROFILE` / `exchangeEncrypted`): `serviceContacts.List(session.UserID)` → `ContactsList_Response{Contacts: ...}`.
   - пуш `CONTACTS_UPDATED` через `publisher.PublishToUser(ctx, ownerUserID, CONTACTS_UPDATED, &v1.ContactsUpdated{...})` после `Upsert`/`Remove`.
7. **`ResolvePending`** (в объёме Этапа 2): контакт зарегистрировался → пуш `CONTACTS_UPDATED` затронутым владельцам (по reverse-index `contactUserID`), чтобы `contactUserID` прилетел без ре-синка. Дельта для пуша — облачные рёбра этих владельцев с данным `oprf` (расшифровать PII перед пушем).
8. **Тесты** — дополнить `internal/services/contacts_test.go` / `contacts_repo_test.go`: enc-roundtrip, List отдаёт только облачные, upsert без PII не создаёт облачное ребро, лимит `CloudLimit` отдаёт `ResourceExhausted`.

## Клиентская часть (Flutter)

1. **proto** — перегенерить, `lib/protobuf/protos/contacts_v1.pb*.dart` + `MessageType` в `v1.pbenum.dart`.
2. **`ContactsCubit`** (`lib/cubit/contacts/contacts_cubit.dart`):
   - **Убрать локальный `_manual`-костыль** (`contacts_manual` в кэше, `_loadManual/_saveManual/_addManual/_removeManual`, подмешивание в `discover`). Облачные контакты теперь — источник истины на сервере.
   - `addByNumber`: слать PII в `ContactsUpsert_Item{firstName, lastName, phoneNumber, source: MANUAL}`. Локально не хранить — контакт прилетит пушем `CONTACTS_UPDATED` (и себе тоже, `PublishToUser` шлёт всем сессиям владельца) → кладём в снимок `contacts` + state.
   - **bootstrap:** после `preload()` дёргать `CONTACTS_LIST` → положить облачные в снимок + state (группа `cloud`).
   - **подписка:** `api.on(MessageType.CONTACTS_UPDATED)` → applyDelta (upsert/remove) в state + снимок.
   - `removeContact` для облачного: как сейчас `CONTACTS_REMOVE`; удаление прилетит пушем (убрать локальный оптимистичный код или оставить + идемпотентная обработка пуша).
   - **exclusion-set** остаётся для книжных (чтобы OPRF-ребро не вернуло удалённый книжный контакт).
3. **Разметка групп** (`_emitPartitioned`): `cloud` теперь определяется не локальным `manualE164`, а тем, что контакт пришёл из `CONTACTS_LIST`/`CONTACTS_UPDATED` (server-truth). Держать `Set<String> _cloudE164` из серверных данных.
4. **`repositories/contacts.dart`**: снимок остаётся для мгновенного показа; облачные писать с флагом-источником, чтобы `preload()` разложил их в `cloud` до ответа `CONTACTS_LIST`. (Добавить колонку `isCloud`/переиспользовать — миграция снимка.)
5. **Одноразовый backfill:** при первом запуске после апдейта — если в старом `contacts_manual` что-то есть, ре-апсертнуть в облако с PII, затем очистить локальный ключ. Иначе ручные контакты «повиснут» только на старом устройстве.
6. **UI:** по решению 1A **тумблера нет** — `addByNumber` всегда облачный, книжные всегда локальные. Обработать новую ошибку лимита (`ResourceExhausted`) в `addByNumber` → `ContactAddResult.limitReached` с сообщением пользователю. (Per-contact «в облако» — Этап 4, если понадобится.)

## Порядок работ (этапы)

- **Этап 1 — proto + генерация** (оба репа). ✅ **ГОТОВО.** В `contacts_v1.proto` добавлены `Contact`/`ContactsList`/`ContactsUpdated` + PII-поля в `ContactsUpsert.Item`; в `v1.proto` — `CONTACTS_LIST=33`/`CONTACTS_UPDATED=34`. Оба репа синхронизированы (файлы идентичны). Сервер: `protoc --go_out=. --go-grpc_out=.` (плагины в `./bin`+`~/go/bin`) → `internal/api/v1/*.pb.go`, `go build` проходит. Клиент: `protoc --dart_out=lib/protobuf -I. protos/{contacts_v1,v1}.proto` → `lib/protobuf/protos/*.dart`, `dart format` применён, analyze чистый (одно пре-существующее `info` про deprecated Timestamp.create). _Прим.: генерация без `grpc:`-опции создаёт лишний `v1.pbserver.dart` — удалять; grpc-стабы живут в `v1.pbgrpc.dart` и при изменении только enum не требуют регенерации._
- **Этап 2 — сервер:** model + repo (`Upsert` enc, `List`) + service (enc/dec, инжекты) + хендлеры `CONTACTS_UPSERT`(PII)/`CONTACTS_LIST` + пуш `CONTACTS_UPDATED`. Тесты. Деплой на staging.
- **Этап 3 — клиент:** выпилить `_manual`, `CONTACTS_LIST` на bootstrap, `api.on(CONTACTS_UPDATED)`, `addByNumber` с PII, снимок с `isCloud`, backfill. E2E на двух устройствах.
- **Этап 4 (бонус):** `ResolvePending`-пуш; UI-тумблер «в облако» для книжных контактов.

## Решённые вопросы

- **Гранулярность выбора → A.** `addByNumber` = всегда облако; книжные всегда локальны; тумблера нет.
- **Источник ребра → A.** Правило «есть PII ⇒ облачное», без `Source CLOUD`.
- **`ContactsList` пагинация → A.** Полный список; курсор зарезервирован, не реализуем.
- **Лимит → 5000, в конфиге** (`config.Contacts.CloudLimit`, `env-default:"5000"`), проверка в `ServiceContacts.Upsert` → `ResourceExhausted`.

- **`ResolvePending`-пуш → Этап 2.** Приглашённый контакт «оживает» на устройствах владельца сразу после его регистрации (пуш `CONTACTS_UPDATED` по reverse-index).

## Открытые вопросы

_(нет — все решены)_
