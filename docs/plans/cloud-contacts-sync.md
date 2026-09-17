# Облачные контакты (синхронизация между устройствами)

## Context

Сейчас у пользователя с двумя устройствами добавленные вручную контакты (группа «Облачные» в UI, `ContactsState.cloud`) **не видны второму устройству**. Причины:

- Вручную добавленный контакт (`ContactsCubit.addByNumber`, source `MANUAL`) хранится **локально**: в таблице `cache` под ключом `contacts_manual` (keyed by userID) + в снимке `contacts`. На сервер уходит только OPRF-отпечаток номера (`CONTACTS_UPSERT`) — ребро для гейта звонков, **без PII**.
- Серверный граф хранит только OPRF-отпечатки (необратимый хэш), имени/номера там нет.
- Нет RPC на чтение графа (`ContactsDiscoveryEvaluate/Match`, `ContactsUpsert`, `ContactsRemove` — всё; ни `List`, ни stream-пуша).

Контакты из телефонной книги (registered/invitable) «появляются» на втором устройстве только потому, что оно само прогоняет **свою** книгу через OPRF — а не из-за синхронизации.

**Задача:** дать облачную синхронизацию контактов как **опцию**, пожертвовав приватностью только для неё. Обычные (книжные) контакты остаются как есть — OPRF, PII локально. Для облачных сервер хранит имя/фамилию/номер, зашифрованные **at-rest**.

## Принятые решения

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
3. **`RepositoryContacts.List(ctx, userID)`** — новый метод: `Find(bson.M{"userID": userID, "phoneEnc": bson.M{"$exists": true}})` → `[]ContactEdge` с блобами.
4. **`ServiceContacts`** (`internal/services/contacts.go`):
   - инжект `cryptoEncryptor CryptoEncryptorInterface` (как в `ServiceMyProfile`/`ServiceAuth`) + `publisher *ServicePublisher`.
   - `Upsert`: для рёбер с PII — `Encrypt(ctx, salt, strings.NewReader(field), &buf, OctetStream)`, `salt = []byte(ownerUserID.Hex())` → `edge.*Enc = buf.Bytes()`. После записи — пуш дельты.
   - `List(ctx, ownerUserID) ([]Contact, error)`: repo.List → `Decrypt` каждого `*Enc` → открытые строки.
   - вспомогательные `encryptField`/`decryptField` (пусто ⇒ nil / "").
5. **API-хендлеры** (`internal/api/v1.go`):
   - `CONTACTS_UPSERT`: из `item` вычитывать `GetFirstName/GetLastName/GetPhoneNumber` в `edge` (пусто — не облачный).
   - `CONTACTS_LIST` (новый `case`, шаблон — `MY_PROFILE` / `exchangeEncrypted`): `serviceContacts.List(session.UserID)` → `ContactsList_Response{Contacts: ...}`.
   - пуш `CONTACTS_UPDATED` через `publisher.PublishToUser(ctx, ownerUserID, CONTACTS_UPDATED, &v1.ContactsUpdated{...})` после `Upsert`/`Remove`.
6. **`ResolvePending`** (бонус): контакт зарегистрировался → пуш `CONTACTS_UPDATED` затронутым владельцам (по reverse-index `contactUserID`), чтобы `contactUserID` прилетел без ре-синка. Можно отдельным этапом.
7. **Тесты** — дополнить `internal/services/contacts_test.go` / `contacts_repo_test.go`: enc-roundtrip, List отдаёт только облачные, upsert без PII не создаёт облачное ребро.

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
6. **UI:** тумблер «Синхронизировать» (per-contact для книжных и/или глобальный). Стартовый минимум: `addByNumber` = всегда облачный; книжные — локальные; отдельный пункт «в облако» — второй этап.

## Порядок работ (этапы)

- **Этап 1 — proto + генерация** (оба репа). Мерджим сообщения/типы, генерим, коммитим сгенерённое.
- **Этап 2 — сервер:** model + repo (`Upsert` enc, `List`) + service (enc/dec, инжекты) + хендлеры `CONTACTS_UPSERT`(PII)/`CONTACTS_LIST` + пуш `CONTACTS_UPDATED`. Тесты. Деплой на staging.
- **Этап 3 — клиент:** выпилить `_manual`, `CONTACTS_LIST` на bootstrap, `api.on(CONTACTS_UPDATED)`, `addByNumber` с PII, снимок с `isCloud`, backfill. E2E на двух устройствах.
- **Этап 4 (бонус):** `ResolvePending`-пуш; UI-тумблер «в облако» для книжных контактов.

## Открытые вопросы

- **Гранулярность выбора:** только `addByNumber`=облако (минимум) или per-contact тумблер для книжных с самого начала? (Влияет на объём Этапа 3/UI.)
- **Явный `Source CLOUD`** vs правило «PII ⇒ облачное»? Пока правило — меньше движения; если UI нужно различать «ручной» и «книжный в облаке», добавить enum.
- **`ContactsList` пагинация:** сейчас полный список (300 контактов — норм). Курсор в `Request` — на будущее, не реализуем.
- **Лимит облачных контактов** на владельца (антиабьюз хранилища)? Задать потолок в сервисе.
- **`ResolvePending`-пуш** — Этап 4 или сразу в Этап 2?
