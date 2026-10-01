# Push-уведомления (по модели Telegram)

Статус: этапы 1–2 реализованы (не проверены на устройствах), остальное — план. Дата: 2026-10-01.

## Контекст

Сейчас push есть **только для звонков**: Android — FCM data-only
(`internal/services/push.go`, `CallFcmService.kt`), iOS — PushKit VoIP
(`AppDelegate.swift`, topic `<bundleID>.voip`). Обычных (alert) пушей нет:

- iOS не вызывает `registerForRemoteNotifications` / `requestAuthorization`, APNs
  alert-токен не регистрируется, нет Notification Service Extension (NSE), нет App Group.
- В `RegisterPushToken.TokenType` только `FCM`, `APNS_VOIP`; в Mongo `sessions` —
  `fcmToken`, `voipToken`.
- APNs-клиент один на сервер (`push.apns.production`), а не по токену.
- `PublishToUser` (core NATS) теряет событие, если стрим закрыт, fallback на push
  захардкожен только в `relayCallSignal`.
- Настроек уведомлений нет ни на сервере, ни в UI.
- Чатов нет (клиент — заглушка, сервер — ни proto, ни хранения). Пуши о сообщениях —
  последний этап; до него конвейер обкатываем на `CONTACT_JOINED` и пропущенных звонках.

## Как у Telegram (что берём)

| Telegram | У нас |
|---|---|
| `account.registerDevice(token_type, token, app_sandbox, secret)` | `RegisterPushToken` + `TokenType.APNS` + `sandbox` |
| `secret` — ключ шифрования payload | ключ выводим HKDF из `sharedKey` сессии, без передачи |
| Зашифрованный `p` в пуше, расшифровка в NSE / в приложении | то же: APNs `mutable-content` + NSE, FCM data-only + нативный Kotlin |
| `loc_key` + `loc_args` (`MESSAGE_TEXT`, `CONTACT_JOINED`, `PHONE_CALL_MISSED`…) | `PushPayload.kind` + `args` |
| `READ_HISTORY`, `MESSAGE_DELETED` — снять уведомления на других устройствах | этап 7; на iOS нужен filtering entitlement |
| Бейдж считает сервер | этап 7 (нужны счётчики непрочитанных) |
| `account.updateNotifySettings` (глобальные + исключения по чату) | `NotifySettings`, этап 6 |
| `account.updateDeviceLocked` (без превью при код-пароле) | решаем на клиенте: NSE/Kotlin читают флаг «включён код-пароль» |
| Не пушить, если клиент онлайн | presence-гейт + явный сигнал «ушёл в фон» + клиентское подавление в foreground |
| Communication Notifications / MessagingStyle | этап 7 |

Не берём: VoIP-пуши для сообщений (Apple запрещает с iOS 13), FCM на iOS (APNs
напрямую — клиент `apns2` и .p8 уже есть), HMS (позже, отдельным этапом — см. «Решения»); RuStore — не решено.

## Формат пуша

Общий для обоих каналов зашифрованный блоб `p`:

```
p = base64( header || AES-256-GCM(PushPayload) )
header = version(1) || sessionID[0..8] || nonce(12)     // AAD = header
key    = HKDF-SHA256(ikm = session.sharedKey, salt = session.sharedSalt, info = "iperon-push-v1")
```

`sessionID[0..8]` — чтобы получатель выбрал ключ (задел под несколько аккаунтов, как
`auth_key_id` у Telegram).

Новый `protos/push_payload_v1.proto` (не ходит по gRPC, только внутри `p`):

```proto
message PushPayload {
  enum Kind {
    UNKNOWN = 0;
    TEST = 1;
    CONTACT_JOINED = 2;
    CALL_MISSED = 3;
    MESSAGE = 10;          // этап 7
    READ_HISTORY = 11;     // этап 7, тихий
    MESSAGE_DELETED = 12;  // этап 7, тихий
  }
  Kind kind = 1;
  bytes fromUserID = 2;
  bytes chatID = 3;
  int64 messageID = 4;
  string title = 5;        // готовый заголовок (имя из профиля/номер), сервер локализует не нужно
  string body = 6;         // пусто, если showPreviews=false
  repeated string args = 7;
  int32 badge = 8;         // 0 = не трогать
  int64 date = 9;
  repeated int64 messageIDs = 10; // для READ_HISTORY / MESSAGE_DELETED
}
```

**APNs (alert, topic = bundleID, `apns-push-type: alert`, priority 10):**

```json
{
  "aps": {
    "alert": { "loc-key": "PUSH_FALLBACK_BODY" },
    "mutable-content": 1,
    "sound": "default",
    "thread-id": "<chatHex|kind>"
  },
  "p": "<base64>"
}
```

`loc-key` локализуется системой из `Localizable.strings` (en/ru) — фолбэк «Новое
уведомление», если NSE не успел/упал. `apns-collapse-id` = id уведомления.

**FCM (Android):** data-only `{ "p": "<base64>" }`, `priority: high` для видимых,
`normal` для тихих. Ключ `action` у звонков не трогаем — call-пуши остаются как есть.

Id уведомления: `<kind>:<chatHex>:<messageID>` — по нему потом снимаем
(`removeDeliveredNotifications` / `NotificationManager.cancel(tag, id)`).

---

## Этап 0. Подготовка (вне кода)

> **Отложен (2026-10-01):** Apple-аккаунт будут переводить на юрлицо — App ID,
> App Group, профили и заявку на filtering entitlement делаем уже на новом аккаунте.
> Если это конвертация существующего аккаунта, Team ID сохраняется; если новый
> аккаунт — меняется Team ID: перенос приложения (App Transfer), новый .p8 для
> APNs, новые keychain access groups и `appID` в AASA (passkeys, applinks).
> Этот этап блокирует этапы 3 и 7 (iOS); этапы 1, 2, 4, 5, 6 от него не зависят —
> существующего .p8 и `aps-environment` для alert-пушей хватает.

- [ ] Apple Developer: App ID `net.iperon.messenger.NotificationService`, App Group
  `group.net.iperon.messenger`, Keychain Sharing; provisioning profiles (dev +
  App Store) для расширения.
- [ ] Включить capability **Communication Notifications** у основного App ID (этап 7,
  но профиль лучше пересоздать один раз).
- [ ] Подать заявку на `com.apple.developer.usernotifications.filtering`
  (developer.apple.com/contact/request/notification-service) — рассматривают не сразу,
  нужна для этапа 7.
- [ ] Сервер: убедиться, что .p8 и service-account JSON лежат на staging
  (`push.apns.*`, `push.fcm.credentialsFile` сейчас пустые в `iperon.yaml`).

## Этап 1. Токены и доставка

Статус (2026-10-01): **код написан** (клиент + сервер, в рабочем дереве), собирается
(`go build/test`, golangci-lint, `flutter analyze`, debug APK, iOS без подписи).
На устройствах НЕ проверено.

**Proto:**

- [x] `RegisterPushToken`: `TokenType.APNS = 2`, `optional bool sandbox = 4`
  (optional — чтобы сервер отличал «не прислал» у старых клиентов).
- [x] `PUSH_TEST = 67` + `push_test_v1.proto` (ответ — счётчики apns/fcm/failed).
- [x] Dart и Go перегенерированы.

**Сервер:**

- [x] `Session`: `apnsToken`, `apnsSandbox`, `voipSandbox` (`*bool`);
  `SetPushToken(..., sandbox *bool)` пишет парное поле `<канал>Sandbox`.
- [x] REGISTER_PUSH_TOKEN: маппинг `APNS` → `apnsToken`, неизвестный тип →
  `InvalidArgument`.
- [x] `ServicePush`: два клиента `apns2` (production/development) с общим JWT,
  выбор по окружению токена; без флага — `push.apns.production`. Topic: alert —
  `bundleID`, VoIP — `bundleID.voip`. Общий `sendApns` чистит мёртвые токены любого
  канала.
- [x] `PUSH_TEST`: `SendTestPush` — на все сессии пользователя без presence-гейта,
  один пуш на токен; лимит — раз в 10 с на пользователя (in-memory, на инстанс).
  iOS — alert с `loc-key` `PUSH_TEST_*`, Android — FCM data `{kind: test}`.
- [x] Тесты: выбор gateway по окружению, rate-limit.

**Клиент iOS:**

- [x] APNs-токен — через `FirebaseMessaging.getAPNSToken()`: firebase_messaging
  сам регистрирует приложение в APNs (swizzling AppDelegate), нативный код не нужен.
  Повтор до 5 раз по 3 с, если токен ещё не выдан; синк на старте, после логина и на
  каждый resume.
- [x] `sandbox = kDebugMode` (debug подписан `RunnerDebug.entitlements` =
  development; Profile/Release — production) — и для APNS, и для APNS_VOIP. Кэш-ключ
  VoIP сменён на `_v2`, чтобы один раз переотправить токен уже с окружением.
- [x] Показ в foreground — `setForegroundNotificationPresentationOptions` (делегат
  `UNUserNotificationCenter` держит firebase_messaging). Этап 3 потребует своего
  решения для «не показывать, если открыт этот чат».
- [x] Разрешение — `permission_handler` (`PERMISSION_NOTIFICATIONS=1` в Podfile),
  мягкий баннер на вкладке «Чаты» (`ChatsCubit`).
- [x] `Localizable.strings` en/ru (`PUSH_TEST_TITLE/BODY`, `PUSH_FALLBACK_BODY`),
  добавлены в `project.pbxproj`.

**Клиент Android:**

- [x] Каналы `messages_v1`, `groups_v1`, `other_v1` (`NotificationChannels.kt`,
  создаются в `MainActivity.onCreate` и перед показом из FCM-сервиса).
- [x] `POST_NOTIFICATIONS` объявлен в манифесте; запрос — тот же баннер на «Чатах»
  (плюс прежний на «Звонках»).
- [x] Тестовый пуш рисуется нативно в `CallFcmService` (без Flutter-isolate), иконка
  `ic_stat_notification`.
- [x] FCM-токен синкается и на resume.

**Общее:**

- [x] Экран «Разработчик» → «Тестовое уведомление» (обе платформы, без kDebugMode —
  нужен в TestFlight).
- [x] ~~Отвязка токенов на логаут~~ — не нужна: выход = `DEVICE_SESSIONS_TERMINATE`
  своей сессии, сервер удаляет документ сессии вместе с токенами.

**Проверить на устройствах:**

1. На staging должны быть заданы `push.apns.*` (.p8, keyID, teamID, bundleID) и
   `push.fcm.credentialsFile`. alert-пуши используют тот же .p8, что VoIP.
2. iPhone, debug-сборка (`flutter run`): разрешить уведомления на «Чатах» →
   «Разработчик» → «Тестовое уведомление» → баннер в foreground и в фоне; в логах
   сервера `environment=development`.
3. iPhone, TestFlight: то же, `environment=production`; VoIP-звонки продолжают
   работать (VoIP-токен переотправится с `sandbox=false`).
4. Android: разрешить уведомления → тест → уведомление в канале «Прочее».
5. Нужен `pod install` / полный `flutter run` (Podfile, новые ресурсы).

## Этап 2. Серверный конвейер

Статус (2026-10-02): **код написан** (сервер + немного клиента, в рабочем дереве),
`go test ./internal/...`, golangci-lint, `flutter analyze`, debug APK — зелёные. На
устройствах НЕ проверено.

**Proto:** `push_payload_v1.proto` (`PushPayload` + описание формата `p`),
`app_state_v1.proto` + `APP_STATE = 68`, `PushTest.Request.encrypted` /
`Response.queued`. Dart и Go перегенерированы.

**Шифрование `p`** — `internal/crypto/push.go` (`PushKey`, `SealPush`, `OpenPush`):
- [x] формат как в разделе «Формат пуша»; keyID = первые 8 байт 32-байтного
  `session.Session` (то, что клиент знает как `session.session`);
- [x] тест-векторы `internal/crypto/testdata/push_vectors.json` (копия в клиенте
  `test/fixtures/`), Go-тест + независимая проверка на Dart `package:cryptography`
  (`test/push_crypto_test.dart`) — HKDF-ключ сверен ещё и вручную. Swift/Kotlin на
  этапах 3/4 должны проходить те же векторы.

**Очередь** — `internal/services/notifications.go` (`ServiceNotifications`):
- [x] `Notify(ctx, Notification)` → JetStream-стрим `push` (subject
  `push.user.<hex>`, WorkQueue, file storage, MaxAge 1ч, дедуп по
  `Nats-Msg-Id = Notification.ID` в окне 2 мин). Стрим/consumer создаются в
  `Start` (fx lifecycle). Push выключен в конфиге → Notify/воркер — no-op.
- [x] Durable consumer `push-worker` (AckWait 2 мин, MaxDeliver 3 — только на случай
  падения инстанса), до 32 задач параллельно на инстанс; несколько инстансов делят
  очередь.
- [x] Воркер: сессии → `ExceptDeviceID` → гейт настроек (заглушка «всё можно» до
  этапа 6) → presence (кроме `IgnorePresence`) → имя отправителя → `PushPayload` →
  шифрование ключом каждой сессии → APNs/FCM, один пуш на уникальный токен.
- [x] Временные ошибки (сеть, 429, 5xx; у FCM — всё, кроме мёртвого токена)
  повторяются внутри обработки: 3 попытки, 1 с → 2 с. `ServicePush` теперь возвращает
  `pushOutcome` (sent / failed / retryable).
- [x] APNs: `aps.alert.loc-key = PUSH_FALLBACK_BODY`, `mutable-content: 1`,
  `thread-id` (чат или тип), звук (кроме `Silent`), бейдж, `apns-collapse-id = ID`,
  expiration 24 ч. FCM: data `{p}`, priority high, TTL 24 ч. Текст режется до 512
  символов (лимит 4 КБ).
- [x] Имя отправителя: облачный контакт получателя (`ServiceContacts.CloudContactName`,
  новый `RepositoryContacts.GetCloudEdge`) → профиль → номер.
- [x] Тесты: очередь на встроенном nats-server (доставка + дедуп), payload, фильтры,
  повторы.

**Presence:**
- [x] Клиент на уходе в фон сразу шлёт по ещё живому стриму `APP_STATE{foreground:false}`
  (`API._sendAppState`, прямо в `_outgoing`, до паузы через 3 с), на возврате в
  пределах грейса — `true`. Сервер (`V1.setSessionForeground`) сразу снимает/ставит
  presence сессии и рассылает переход контактам; heartbeat subscribe не продлевает
  presence свёрнутой сессии (`backgroundSessions`), новый стрим флаг сбрасывает. Старый
  сервер неизвестный тип игнорирует (в `message` нет default-ветки с ошибкой).
- [ ] Подавление системного уведомления в foreground на клиенте — этапы 3/4 (сейчас
  iOS показывает всё, что пришло).

**Проверка конвейера:** экран «Разработчик» → «Тестовое уведомление (шифрованное)»
(`PUSH_TEST{encrypted:true}` → `Notify(kind=TEST, IgnorePresence)`). Пока нет NSE,
iPhone покажет фолбэк «Новое уведомление» — это и есть проверка формата APNs-payload;
Android такие пуши пока глотает (`CallFcmService`, этап 4). В логах сервера —
`notifications: delivered` со счётчиками и `latency`.

**Не сделано / отложено:**
- [ ] Метрики Prometheus (пока только структурные логи `notifications: delivered` —
  по ним можно строить панели в Grafana/Loki).
- [ ] Тихие типы (`READ_HISTORY`, `MESSAGE_DELETED`) — особый APNs-payload, этап 7.

## Этап 3. iOS: Notification Service Extension

- [ ] Новый target `NotificationService` (Swift), bundle
  `net.iperon.messenger.NotificationService`, App Group + Keychain Sharing в обоих
  entitlements (`Runner.entitlements`, `RunnerDebug.entitlements`, новый для NSE).
- [ ] **Хранилище ключей пушей** — method channel `push_keys` (Swift): пишет
  `{sessionIDprefix: pushKey}` в Keychain с access group
  `$(AppIdentifierPrefix)net.iperon.messenger.shared`. Dart после логина (и при
  старте — миграция существующих сессий) выводит ключ и сохраняет; на логаут — удаляет.
  NSE не может читать SQLCipher-базу, поэтому только Keychain.
- [ ] Флаг «включён код-пароль» → `UserDefaults(suiteName: group)` → NSE показывает
  «Новое сообщение» без текста (аналог `updateDeviceLocked`).
- [ ] NSE: base64 → header → ключ → `AES.GCM.open` (CryptoKit) → `PushPayload`
  через SwiftProtobuf (решено; Swift-код из `push_payload_v1.proto` генерируется
  `protoc --swift_out`, SPM/CocoaPods-зависимость только у target NSE) →
  `title`/`body`/`threadIdentifier`/`userInfo` (`route`, id). Ошибка → оставить фолбэк.
- [ ] Тап: `didReceive response` в `AppDelegate` → channel `push` → Dart →
  `router.go(route)`. Cold start — маршрут копится нативно, Dart забирает после
  `getIt.allReady()`.
- [ ] Foreground: `willPresent` — спрашиваем Dart (или нативный флаг текущего
  экрана): если открыт тот же чат — `[]`, иначе `[.banner, .sound]` (позже свой
  in-app баннер).
- [ ] CI: `_deploy_testflight.yaml` — второй provisioning profile; сейчас ключи
  подписи дописываются в `Release.xcconfig` и действуют на **все** target'ы —
  `PROVISIONING_PROFILE_SPECIFIER` нужно задавать per-target (через `xcconfig` с
  условием по `PRODUCT_BUNDLE_IDENTIFIER` или в `pbxproj`). `ExportOptions.plist` —
  добавить расширение в `provisioningProfiles`. Fastlane `beta` — импорт второго
  профиля.

## Этап 4. Android: нативная обработка

- [ ] `CallFcmService.onMessageReceived`: есть `p` → `MessagePushHandler.handle()`
  и **не** вызывать `super` (не поднимать Flutter-isolate ради уведомления); call-пуши
  — как сейчас.
- [ ] `push_keys` channel (Kotlin): ключи в `EncryptedSharedPreferences`
  (androidx.security) — Dart пишет после логина/миграции, удаляет на логаут.
- [ ] `MessagePushHandler`: расшифровка (`javax.crypto` AES/GCM), выбор канала по
  `kind`, `NotificationCompat` с `setGroup(chatHex)` + summary; для `MESSAGE` —
  `MessagingStyle` с дозаписью к уже показанному
  (`extractMessagingStyleFromNotification`). Флаг код-пароля — из того же хранилища.
- [ ] Foreground (`ProcessLifecycleOwner` STARTED): не показывать, отдать в Dart
  (`onMessage`-аналог через channel), если нужно.
- [ ] Тап: `PendingIntent` в `MainActivity` с extra `route` → channel `push` → Dart
  (тот же API, что на iOS). Учитывать `onNewIntent`.
- [ ] Unit-тест расшифровки на тех же векторах, что сервер.

## Этап 5. Первые настоящие пуши (до чатов)

- [ ] `CONTACT_JOINED` — «X теперь в Iperon»: при регистрации нового пользователя
  найти тех, у кого его номер в контактах (OPRF/MATCH-индекс сервера, см.
  `contacts-graph-call-gating.md`), и `Notify` каждому. Только новые регистрации,
  не повторно; тап → профиль контакта.
- [ ] `CALL_MISSED` — только **iOS**: когда звонок закончился без ответа
  (`CALL_HANGUP` от звонящего до `CALL_ACCEPT` / таймаут) — пуш вызываемому (CallKit
  пишет в «Недавние», но уведомления не даёт). На **Android** серверный не шлём —
  остаётся локальное уведомление плагина `flutter_callkit_incoming` (решено
  2026-10-01, чтобы не было дублей): воркер фильтрует `CALL_MISSED` по
  `pushPlatform != ANDROID`.
- [ ] Тап по `CALL_MISSED` (iOS) → вкладка «Звонки».

## Этап 6. Настройки уведомлений

**Proto** `protos/notify_settings_v1.proto`, MessageType `NOTIFY_SETTINGS` (снимок,
также push по стриму на другие устройства) и `NOTIFY_SETTINGS_UPDATE`:

```proto
message NotifySettings {
  enum Scope { PRIVATE = 0; GROUPS = 1; CHANNELS = 2; PEER = 3; }
  message Item {
    Scope scope = 1;
    bytes peerID = 2;      // только для PEER
    int64 muteUntil = 3;   // 0 — не заглушено, max int — навсегда
    bool showPreviews = 4;
    bool silent = 5;       // без звука
    string sound = 6;
  }
  // + отдельные флаги: contactJoined, missedCalls
}
```

- [ ] Сервер: коллекция `notifySettings`, чтение в воркере этапа 2 (кэш в Redis),
  после записи — `PublishToUser` (паттерн мультидевайс-синхронизации приватности).
- [ ] Клиент: SQLite-кэш (новая миграция) + cubit по образцу
  `SettingsPrivacyAndSecurityCubit`: чтение offline из БД, запись только online с
  гардом `hasNetwork()` (без оптимистичного отката).
- [ ] UI «Уведомления и звуки» (Cupertino + Material, i18n en/ru): личные / группы /
  каналы (вкл/выкл, превью, звук), «Новые контакты», «Пропущенные звонки»; ссылка на
  системные настройки, если разрешение не выдано. Пункт в `settings_*.dart` и маршруты
  в обоих роутерах (`pageBuilder:` с `_page`/`_pageMaterial`).
- [ ] Исключения по чату — вместе с чатами (этап 7), там же «Заглушить на…».

## Этап 7. Сообщения (после серверной части чатов)

- [ ] `Kind.MESSAGE` при новом сообщении: тип вложения в `args` (фото/видео/файл →
  локализованный текст на клиенте), учёт `PEER`-исключений и `muteUntil`.
- [ ] `READ_HISTORY` / `MESSAGE_DELETED`: снять уведомления на всех устройствах
  пользователя. iOS: с filtering entitlement NSE снимает
  (`removeDeliveredNotifications`) и подавляет показ; без него — фолбэк
  background-push (`content-available`, priority 5, троттлится системой). Android —
  `cancel` нативно.
- [ ] Бейдж: серверные счётчики непрочитанных → `aps.badge` / `PushPayload.badge`.
- [ ] Communication Notifications (iOS 15+): `INSendMessageIntent` + `INPerson` с
  аватаркой — кэш аватарок должен лежать в контейнере App Group (связано с
  `contacts-avatars-plan`).
- [ ] Android: аватарки в `Person`, conversation shortcuts, действия «Ответить»
  (RemoteInput) и «Прочитано» — нужен способ отправить без UI (headless Flutter
  engine или нативный gRPC-вызов); выбираем здесь, на этапе 7, не раньше.
- [ ] In-app баннер вместо системного в foreground.

## Решения (2026-10-01)

1. `CALL_MISSED`: на Android остаётся локальное уведомление плагина звонков,
   серверный пуш — только iOS.
2. NSE разбирает `PushPayload` через **SwiftProtobuf**.
3. **Huawei (HMS Push)** — нужен, но позже, отдельным этапом после основного
   конвейера: `TokenType.HMS`, канал в `ServicePush`, `HmsMessageService` на
   Android с тем же `MessagePushHandler`. Формат `p` общий, так что ляжет без
   переделок. RuStore — не обсуждали.
4. «Ответить/Прочитано» из уведомления на Android — решаем на этапе 7, вместе с
   чатами.
