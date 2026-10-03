# Push-уведомления (по модели Telegram)

Статус: этапы 1, 2, 3, 4, 5, 6 реализованы; этапы 5 и 6 проверены на устройствах 2026-10-02, этап 3 — частично (2026-10-03: расшифровка, код-пароль, пропущенный звонок и тап по нему, в т.ч. с холодного старта). 2026-10-02 на устройствах подтверждено: iPhone — обычный и шифрованный тестовый пуш (фолбэк-текст), Android — обычный и шифрованный (нативная расшифровка). Доставка в фоне с выгруженным приложением тоже подтверждена (два телефона под одним аккаунтом, тест с одного на другой). Код-пароль на Android тоже подтверждён (шифрованный пуш приходит как «Новое уведомление»). Не проверены: тапы на Android. Остальное — план. Дата: 2026-10-01.

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

> **2026-10-03:** для этапа 3 портал настроен на текущем аккаунте физлица. Позже
> приложение переедет на новый аккаунт юрлица (App Transfer, аккаунт физлица остаётся)
> — сменится Team ID: App ID и профиль расширения, новый .p8 для APNs, `appID` в AASA
> (passkeys, applinks) повторить там; Keychain на устройствах после переезда, скорее
> всего, не прочитается (разлогин) — лучше до публичного релиза. Заявку на filtering
> entitlement подавать уже с аккаунта юрлица.

- [x] Apple Developer: App ID `net.iperon.messenger.NotificationService` (без
  capabilities) и его App Store-профиль. App Group не нужен (решение этапа 3 — общий
  Keychain); профиль основного приложения не менялся.
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

**Проверено (2026-10-02):** iPhone получает тестовый пуш (APNs alert, loc-key) —
обычный и шифрованный (через конвейер этапа 2, фолбэк «Новое уведомление»).

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

Статус (2026-10-03): **код написан** (клиент, в рабочем дереве). Release-сборка без
подписи (`flutter build ios --release --no-codesign`), `flutter analyze`, `flutter test`
— зелёные; Swift-расшифровка и разбор `PushPayload` проверены на общих векторах
(`PushCrypto.swift` + сгенерированный `push_payload_v1.pb.swift`, собраны `swiftc` вместе
с SwiftProtobuf из Pods — оба вектора, включая все поля вектора #1). Сервер не менялся.

**Проверено (2026-10-03, TestFlight v0.0.283, iPhone):** шифрованный тестовый пуш
расшифровывается расширением; с включённым код-паролем — «Новое уведомление» (по
syslog: ключ найден, расшифровка прошла, сработал флаг код-пароля), без код-пароля —
настоящий текст. «Пропущенный звонок» приходит и из фона, и с выгруженным приложением;
тап открывает «Звонки» в обоих случаях (в т.ч. холодный старт — отложенный тап).
Обновление не разлогинило (группа Keychain по умолчанию не сменилась).

Найдено при проверке: с выгруженным приложением пропущенный сначала не приходил —
VoIP-пуш входящего поднимает приложение в фоне, оно открывает стрим (presence online)
без `APP_STATE{foreground:false}`, и сервер отбрасывал CALL_MISSED как `onlineSkipped`.
Исправлено на сервере: `IgnorePresence: true` для CALL_MISSED (`missed_calls.go`),
задеплоено и проверено 2026-10-03. Для сообщений так нельзя — см. пункт «Ложный онлайн»
в этапе 7.

Решения (2026-10-03): делаем на текущем аккаунте физлица (позже перенос на юрлицо через
App Transfer — портал повторить). **Без App Group**: ключи пушей и флаг код-пароля — в
общем Keychain, Keychain Sharing не требует настройки на портале и пересоздания профиля
основного приложения. На портале создан только App ID
`net.iperon.messenger.NotificationService` (без capabilities) и его App Store-профиль.

- [x] Target `NotificationService` (`ios/NotificationService/`, bundle
  `net.iperon.messenger.NotificationService`, iOS 15) добавлен в `project.pbxproj`
  (скриптом через гем `xcodeproj`), встроен в Runner фазой «Embed Foundation
  Extensions» **до** «Thin Binary» (иначе цикл в сборке Flutter). Свои базовые xcconfig
  (`ios/NotificationService/{Debug,Release,Profile}.xcconfig`): поды расширения +
  `Flutter/Generated.xcconfig` (версия = версии приложения), без `Flutter/Release.xcconfig`
  (он тянет поды Runner).
- [x] SwiftProtobuf — под у target'а `NotificationService` в `Podfile`
  (`use_frameworks! :linkage => :static` — CocoaPods требует use_frameworks! и у хоста, и
  у расширения; статически, чтобы не встраивать фреймворк). Swift-код генерируется
  `protoc --swift_out=ios/NotificationService --swift_opt=Visibility=Internal -Iprotos
  protos/push_payload_v1.proto` (protoc-gen-swift 1.38.1 из `brew install swift-protobuf`;
  под — `~> 1.38`, не ниже генератора).
- [x] **Keychain** — `ios/Shared/PushKeychain.swift` (в обоих target'ах): access group
  `<TeamID>.net.iperon.messenger.shared` (префикс из Info.plist `AppIdentifierPrefix`),
  `AfterFirstUnlockThisDeviceOnly` (пуши приходят на заблокированный телефон). Ключ по
  keyID, `putKey` заменяет прежние; флаг код-пароля — отдельная запись. В
  `keychain-access-groups` Runner'а первой стоит собственная группа приложения — чтобы
  группа по умолчанию (flutter_secure_storage, пароль БД) не сменилась.
- [x] NSE (`NotificationService.swift`): `p` → `PushCrypto` (CryptoKit AES-GCM) →
  `PushPayload` → заголовок/текст как на Android (TEST, CONTACT_JOINED с именем из
  адресной книги по `args[0]`, CALL_MISSED, MESSAGE с `threadIdentifier = chat:<hex>`);
  код-пароль → «Iperon / Новое уведомление»; нет ключа/ошибка → остаётся фолбэк
  `PUSH_FALLBACK_BODY`. В `userInfo` дописывает kind/id/chatID/fromUserID. Тексты — свой
  `Localizable.strings` (en/ru).
- [x] Канал `net.iperon.messenger/push` на iOS — `ios/Runner/PushBridge.swift` (тот же
  контракт, что на Android: `setPushKey`, `clearPushKeys`, `setPasscodeEnabled`,
  `takeInitialTap`, `onNotificationTap`). `PushManager` в Dart теперь работает с каналом
  на обеих платформах.
- [x] Делегат `UNUserNotificationCenter` — сам `AppDelegate` (ставится до `super` в
  didFinishLaunching). Пуши с `p`: foreground — не показываем, кроме TEST (как на
  Android); тап → `PushBridge` → Dart (`routeForKind`), холодный старт — отложенный тап.
  Остальные пуши уходят в `super` → плагины (firebase_messaging не подменяет делегат,
  раз это FlutterAppLifeCycleProvider).
- [x] CI: `_deploy_testflight.yaml` ставит второй профиль (секрет
  `IOS_NSE_PROVISIONING_PROFILE_BASE64`, проброшен в `build_and_deploy.yaml`), дописывает
  ручную подпись в `ios/NotificationService/Release.xcconfig` и добавляет расширение в
  `ExportOptions.plist`.
- [ ] READ_HISTORY / MESSAGE_DELETED — снимать уведомления (этап 7, нужен filtering
  entitlement).

**Проверка на устройстве (TestFlight):**

- [x] «Разработчик» → «Тестовое уведомление (шифрованное)» → «Шифрованное тестовое
  уведомление: расшифровка работает».
- [x] С включённым код-паролем — «Новое уведомление».
- [x] «Пропущенный звонок» приходит (фон и выгруженное приложение).
- [x] Тап по «Пропущенному звонку» открывает «Звонки» (фон и холодный старт).
- [x] Вход в приложение после обновления не слетел.
- [ ] «Контакт присоединился» — имя из адресной книги.
- [ ] Тап по «Контакт присоединился» открывает «Контакты».
- [ ] После выхода из аккаунта — фолбэк «Новое уведомление».

## Этап 4. Android: нативная обработка

Статус (2026-10-02): **код написан** (клиент, в рабочем дереве). Kotlin unit-тесты
(`./gradlew :app:testDebugUnitTest`, 5 шт.), Dart-тесты, `flutter analyze`, debug APK —
зелёные. На устройстве НЕ проверено. Сервер не менялся (кроме второго тест-вектора).

- [x] `CallFcmService.onMessageReceived`: data с `p` → `MessagePushHandler.handle()`,
  `super` не зовём (Flutter-isolate не поднимается); call-пуши и `kind=test` — как раньше.
- [x] Ключи — `PushKeyStore.kt`: ключ пушей в SharedPreferences, обёрнутый AES-GCM
  ключом из Android Keystore (без `androidx.security`, она deprecated). Аккаунт один —
  `put` заменяет прежние ключи. Dart (`PushManager._syncPushKey`) выводит HKDF и
  отдаёт ключ по каналу `net.iperon.messenger/push` на старте/логине, на разлогине —
  `clearPushKeys`. Флаг код-пароля — `setPasscodeEnabled` (старт + `CommonCubit.setPasscode`).
- [x] `PushCrypto.kt` (AES-GCM, чистый JVM) + `PushPayload.kt` (свой маленький
  protobuf-декодер вместо protobuf-javalite + codegen; неизвестные поля пропускает,
  repeated int64 — packed и unpacked). Тесты на общих векторах; добавлен вектор #1 с
  настоящим `PushPayload` (кириллица, эмодзи, все поля).
- [x] `MessagePushHandler.kt`: нет ключа → молча (разлогин/старая сессия); битый `p` →
  лог. `READ_HISTORY`/`MESSAGE_DELETED` → снять уведомление чата (TODO этап 7: при
  удалении — только удалённые сообщения). Приложение на экране (`MainActivity.isForeground`,
  onStart..onStop) → не показываем, кроме TEST. Код-пароль → «Iperon / Новое уведомление».
  Тексты: TEST, CONTACT_JOINED («теперь в Iperon»), CALL_MISSED, MESSAGE —
  `MessagingStyle` с дозаписью к показанному (`extractMessagingStyleFromNotification`,
  до 7 сообщений), тег `chat:<hex>`; прочие — тег = id уведомления. Каналы: MESSAGE →
  `messages_v1`, остальное → `other_v1`. `androidx.core:core-ktx:1.18.0` подключён
  явно (та же версия, что уже резолвится).
- [x] Тап: `PendingIntent` → `MainActivity` (action `PUSH_TAP`, extras kind/id/chat/from)
  → `onCreate`/`onNewIntent` → канал `onNotificationTap` или отложенный тап холодного
  старта, который Dart забирает `takeInitialTap`. Маршрут решает Dart
  (`PushManager.routeForKind`: контакт → `/contacts`, пропущенный → `/calls`, сообщение
  → `/chats`), переход — `goRouter.go` через `PushManager.onRoute` (ставят оба корня
  приложения).
- [ ] Группы (`groups_v1`) и summary-уведомление — когда появятся типы чатов (этап 7).
- [ ] Действия «Ответить»/«Прочитано» — этап 7.

**Проверено (2026-10-02):** обычный и шифрованный тестовый пуш на Android приходят
(шифрованный — с расшифрованным текстом), в т.ч. с выгруженным приложением; с
включённым код-паролем шифрованный приходит как «Новое уведомление».

**Проверить на устройстве:** «Разработчик» → «Тестовое уведомление (шифрованное)» →
уведомление «Шифрованное тестовое уведомление: расшифровка работает» (и в фоне, и с
выгруженным процессом); с включённым код-паролем — «Новое уведомление»; после выхода из
аккаунта старые пуши не показываются.

## Этап 5. Первые настоящие пуши (до чатов)

Статус (2026-10-02): **код написан** (сервер + Android, в рабочем дереве), тесты сервера
(включая очередь на встроенном nats-server и Redis через miniredis), golangci-lint,
debug APK — зелёные. 2026-10-02 пользователь проверил на устройствах «Контакт
присоединился» и «Пропущенный вызов».

- [x] `CONTACT_JOINED` — `ServiceNotifications.NotifyContactJoined`, зовёт `ServiceAuth`
  сразу после создания нового пользователя (оба пути регистрации — Confirmation и
  call-password webhook; Yandex идёт через Confirmation). Владельцы — `OwnersOf(newUser)`:
  любое ребро (приватное OPRF и облачное), pending-рёбра к этому моменту уже
  резолвнуты. В фоне (регистрация не ждёт), ID `contact_joined:<owner>:<newUser>`
  (дедуп). Заголовок — облачное имя у владельца → профиль → номер; в `args[0]` —
  номер в E.164: Android берёт имя из адресной книги устройства (`PhoneLookup`, если
  выдан READ_CONTACTS) — как Telegram, «как записан у меня». Тап → `/contacts`.
- [x] `CALL_MISSED` — `ServiceMissedCalls` (Redis `call:ringing:<callId>`, TTL 1 ч,
  кормится из `relayCallSignal`): RING запоминает, ACCEPT (любое устройство) забывает,
  HANGUP от звонящего до ответа (отмена/таймаут) или REJECT с `busy` от вызываемого →
  пропущенный. Ручное отклонение — не пропущенный. GETDEL — повторный отбой не даёт
  второго пуша. **Только iOS** (`Notification.Platform`; на Android остаётся
  уведомление плагина звонков). `args[0] = "video"` для видеозвонка. Тап → `/calls`.
  На iPhone до NSE (этап 3) придёт фолбэк «Новое уведомление».
- [ ] Отключение «Новые контакты» / «Пропущенные звонки» — настройки, этап 6.

## Этап 6. Настройки уведомлений

Статус (2026-10-02): **готово**. `go test ./internal/...`, проверка fx-графа,
`flutter analyze`, `flutter test` — зелёные; 2026-10-02 пользователь проверил на
устройствах (iOS + Android): переключатели, синхронизация между устройствами, offline,
отключение «Контакт присоединился» / «Пропущенные звонки».

**Proto** `protos/notify_settings_v1.proto`, `NOTIFY_SETTINGS = 69` (снимок — и ответ на
запрос, и push по стриму после изменения), `NOTIFY_SETTINGS_UPDATE = 70` (одна настройка
за запрос, `oneof change`: тип чатов целиком / `contact_joined` / `missed_calls`):

```proto
message NotifySettings {
  enum Scope { PRIVATE = 0; GROUPS = 1; CHANNELS = 2; }
  message ScopeSettings { bool enabled = 1; bool show_previews = 2; bool sound = 3; }
  message Response {
    ScopeSettings private_chats = 1; ScopeSettings groups = 2; ScopeSettings channels = 3;
    bool contact_joined = 4; bool missed_calls = 5;
  }
}
```

- [x] Сервер: коллекция `notifySettings` (`RepositoryNotifySettings`, уникальный индекс
  `userId`, поля-указатели — отсутствующее = «включено»), `ServiceNotifySettings`,
  хендлеры в `v1.go` + `publishNotifySettings` (паттерн мультидевайс-синхронизации
  приватности).
- [x] Гейт в воркере (`applyNotifySettings`): `CONTACT_JOINED` / `CALL_MISSED` по
  тумблерам; `MESSAGE` — по `Notification.Scope`: выключено → не шлём, без превью →
  пустые `body`/`args`, без звука → `Silent`. `TEST` и тихие служебные типы настройки не
  гасят. Ошибка чтения → шлём (fail open). Redis-кэш не делали: один `FindOne` по
  индексу на уведомление — дёшево; вернёмся, если станет узким местом.
- [x] Android-пропущенный (рисует плагин звонков): сервер кладёт `showMissed=false` в
  incoming call-пуш, клиент передаёт плагину `missedCallNotification.showNotification =
  false` (фоновый isolate), в foreground-пути читает настройку из кэша.
- [x] Клиент: SQLite-кэш (миграция 11, `notifySettings`, BLOB ответа на userID, пишется в
  `API._handleMessage`) + `SettingsNotificationsCubit`: чтение offline, запись online с
  гардом `hasNetwork()`, без оптимистичного отката.
- [x] UI «Уведомления и звуки» (Cupertino + Material, i18n en/ru): пункт в Настройках
  (над «Конфиденциальностью»), `/settings/notifications` — типы чатов (Вкл./Выкл.) +
  «События» (контакт присоединился, пропущенные звонки) + баннер «Уведомления выключены»
  с кнопкой «Включить», если нет системного разрешения (перепроверка на resume);
  `/settings/notifications/:scope` — показывать / предпросмотр / звук.
- [ ] Исключения по чату — вместе с чатами (этап 7), там же «Заглушить на…».
- [ ] Выбор мелодии (сейчас звук только вкл/выкл).

**Проверить на устройстве:** выключить «Контакт присоединился» → новый пользователь из
книги не даёт пуша (в логах сервера `notifications: delivered … skippedBy=settings`);
выключить «Пропущенные звонки» → на iPhone нет пуша о пропущенном, на Android после
неотвеченного звонка нет уведомления плагина; изменение на одном устройстве сразу видно
на втором; offline — переключатели заблокированы, значения из кэша.

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
- [ ] **Ложный «онлайн» после фонового запуска звонком (iOS) — до запуска MESSAGE.**
  VoIP-пуш поднимает выгруженное приложение в фоне; `API._appActive` по умолчанию
  `true`, lifecycle в таком запуске не приходит → стрим открывается (Subscribe →
  presence online), `APP_STATE{foreground:false}` не уходит, и сессия числится
  онлайн, пока iOS не усыпит процесс и стрим не отвалится по keepalive. Всё это
  время сервер отбрасывает пуши по presence (`onlineSkipped`) — MESSAGE после
  такого звонка потеряются. Найдено 2026-10-03 на CALL_MISSED (Loki:
  `onlineSkipped:1, apnsSent:0`); для CALL_MISSED обошли на сервере
  (`IgnorePresence: true` в `missed_calls.go`), для сообщений так нельзя.
  Чинить на клиенте: стартовое `_appActive` брать из
  `WidgetsBinding.instance.lifecycleState` / `UIApplication.applicationState`
  (не `active` → `false`). Риск: `setCallActive(true)` ставится только на подключении к комнате, а пока звонок звонит, стрим нужен, чтобы дошёл `CALL_HANGUP` звонящего — его надо держать и на время звонка (или поднимать presence-нейтрально). Сначала
  проверить на устройстве, какое состояние Flutter сообщает при фоновом запуске
  (лог `lifecycle:` в файловом логе), и что cold-start входящий не ломается.

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
