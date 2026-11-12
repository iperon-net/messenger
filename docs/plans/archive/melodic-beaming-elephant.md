# Фаза 4 — фон/пуш для звонков (CallKit + VoIP / FCM)

## Context

Звонки (фазы 0–3) работают **только в foreground**: персистентный gRPC-стрим
открыт лишь при `authorized && foreground` (`lib/api.dart`), а сигналинг
(`CALL_OFFER`) доставляется через core NATS `PublishToUser` — fire-and-forget
(`internal/services/publisher.go:78`). Если стрим адресата закрыт (приложение в
фоне/выгружено), offer доставить некому — входящий не звонит. Это и есть
незакрытая **фаза 4** из `docs/plans/client-webrtc-calls.md` и
`~/GolandProjects/iperon/docs/plans/webrtc-signaling-relay.md`.

Под пуши сейчас **нет ничего**: на сервере нет ни хранения push-токенов, ни
FCM/APNs (проверено — в `go.mod` нет firebase/apns, в `models.Session` нет поля
токена); на клиенте `firebase_messaging`/`firebase_core` есть в `pubspec.yaml`,
но не подключены, нет CallKit, нет entitlements/VoIP-режима. Значит фаза строится
с нуля, full-stack.

**Решения (подтверждено с пользователем):**
- iOS: **CallKit + VoIP-push (PushKit/APNs)** — нативный экран входящего даже
  при выгруженном приложении. Это обязательный для iOS путь (обычный FCM VoIP не
  умеет).
- Все внешние предпосылки доступны (APNs Auth Key, Firebase service account).

**Ключевая идея архитектуры:** push — это только **побудка + звонок** (callId,
кто звонит, видео/аудио), а **не** переносчик SDP. Разбудив приложение, клиент
открывает стрим, а offer прилетает по стриму — этому уже помогает недавно
добавленный **ретрансмит `CALL_OFFER`** (`lib/calls.dart`, повтор каждые 1.5с до
30с): проснувшийся адресат поймает повтор в течение ~1.5с. Так SDP не кладётся в
push (проще, безопаснее, меньше размер payload).

## Поток

```
Caller                Server (relay + push)                 Callee (фон/killed)
 CALL_OFFER ──► relayCallSignal:                             
                • PublishToUser(NATS)  ── если стрим жив ──► приходит сразу
                • sendCallPush(callee) ── если стрим нет ──► VoIP/FCM push
                                                              → CallKit/ConnectionService звонит
                                                              → апп открывает стрим (foreground)
                                                              → ретрансмит CALL_OFFER долетает ► answer
 CALL_HANGUP/REJECT ► sendCallPush(cancel) ────────────────► CallKit dismiss
```

## Предпосылки (пользователь предоставляет)

- **APNs Auth Key** `.p8` + `Key ID` + `Team ID` (Apple Developer), Bundle ID.
- В Apple Developer для App ID включить **Push Notifications**; в Xcode-таргете —
  capability **Push Notifications** + Background Mode **Voice over IP** + **Remote
  notifications**.
- **Firebase service account JSON** для Go-бэка (FCM HTTP v1) — из того же
  проекта `iperon`.
- APNs Auth Key загрузить и в Firebase (для iOS-FCM data-канала — опционально,
  т.к. звонки идут прямым APNs-VoIP).

## Серверная часть (`~/GolandProjects/iperon`)

**Proto (`protos/`):**
- Новый `protos/push_token_v1.proto`: `RegisterPushToken.Request { string token;
  TokenType type (FCM|APNS_VOIP); int32 platform; }` + пустой `Response`.
- В `protos/v1.proto` в конец enum `MessageType` добавить `REGISTER_PUSH_TOKEN`
  (следующий номер после `CALL_ICE_SERVERS = 21`). Перегенерить `*.pb.go`.

**Хранение токена (Mongo):**
- Добавить в `internal/models/sessions.go` `Session`: `FcmToken string`,
  `VoipToken string`, `PushUpdatedAt time.Time` (VoIP-токен нужен отдельно от FCM
  — на iOS PushKit-токен ≠ FCM-токен).
- Метод апдейта в репозитории сессий (рядом с существующими update-методами
  `ServiceSessions`), обновляющий поля токенов по `SessionID`.

**Хендлер `REGISTER_PUSH_TOKEN`** в `internal/api/v1.go`:
- Ветка в `message()` (рядом с `CALL_ICE_SERVERS`, через `exchangeEncrypted`) →
  `resolveSession` → записать токен в сессию. Клиент шлёт при логине и при
  refresh токена.

**Push-сервис** `internal/services/push.go` (новый):
- FCM: `firebase.google.com/go/v4/messaging` (service account) — high-priority
  **data**-message для Android (`android: {priority: high}`), без notification-
  блока (чтобы разбудить фоновый isolate).
- APNs-VoIP: `github.com/sideshow/apns2` с `.p8` — `push-type: voip`, topic =
  `<bundleID>.voip`. Payload: `{callId, fromUserID, fromName, video, action:
  incoming|cancel}`.
- `SendCallPush(ctx, toUserID, payload)` — берёт все сессии пользователя
  (`GetAllByUserID`), шлёт FCM на Android-сессии и APNs-VoIP на iOS-сессии.
- Конфиг: блок `push:` в `internal/settings/settings.go` (`Config`) +
  `iperon.yaml` — `fcm.credentialsFile`, `apns.{keyFile,keyID,teamID,bundleID,
  production}`. Валидация в существующем `checks`-списке. Пустой конфиг ⇒ push
  выключен (грациозно, только NATS).

**Триггер** в `relayCallSignal` (`internal/api/v1.go:985`):
- Для `CALL_OFFER` — после `PublishToUser` вызвать `push.SendCallPush(..., action:
  incoming)`. Для `CALL_HANGUP`/`CALL_REJECT` — `action: cancel` (снять
  CallKit-звонок). Fire-and-forget в горутине, ошибки в лог — relay не роняем.
- Отправляем push **всегда** (не пытаемся определить, жив ли NATS-подписчик —
  core NATS этого надёжно не сообщает). Двойного звонка нет: клиент дедупит по
  `callId` (уже есть `_isCurrentPeer` в `lib/calls.dart`), а на iOS CallKit —
  единый источник ринга.

**go.mod:** добавить `firebase.google.com/go/v4`, `github.com/sideshow/apns2`.

## Клиентская часть (`~/IdeaProjects/messenger`)

**Зависимости (`pubspec.yaml`):** добавить `flutter_callkit_incoming` (единый
CallKit iOS / ConnectionService+full-screen Android). `firebase_messaging`/
`firebase_core` уже есть.

**Регистрация токенов** — новый сервис `lib/push.dart` (`PushManager`,
регистрируется в `di.dart` по паттерну `Calls`, `dependsOn: [API, Auth]`):
- iOS: получить **VoIP-токен** через PushKit (нативный канал, см. ниже) +
  опционально FCM-токен; Android: FCM-токен (`FirebaseMessaging.instance.
  getToken()`).
- Слать `REGISTER_PUSH_TOKEN` через `api.sendEncoded`/`unaryEncoded` при логине и
  на `onTokenRefresh`. Хранить последний отправленный токен в `cache`
  (троттлинг, как `_deviceInfoUpdateCacheKey` в `lib/api.dart`).

**iOS нативка (`ios/Runner`):**
- Swift: `PKPushRegistry` (VoIP-токен + приём VoIP-пушей) → на каждый VoIP-push
  **немедленно** `CXProvider.reportNewIncomingCall` (требование Apple, иначе апп
  убьют). `flutter_callkit_incoming` закрывает это, но VoIP-токен и wiring
  PushKit добавляем в `AppDelegate`.
- `Info.plist`: `UIBackgroundModes` += `voip`, `remote-notification`.
- Создать `ios/Runner/Runner.entitlements` с `aps-environment`; подключить в
  таргете (учесть, что CI форсит manual signing — см. `_deploy_testflight.yaml`).

**Android нативка (`android/app`):**
- `AndroidManifest.xml`: FCM (`FirebaseMessagingService` от `firebase_messaging`),
  full-screen intent permission, foreground-service для звонка,
  `POST_NOTIFICATIONS` (Android 13+). `google-services.json` уже подключён (есть
  Firebase).
- High-priority data-push → фоновый handler → `flutter_callkit_incoming`
  показывает нативный входящий.

**Обработка входящего пуша (общий Dart):**
- `FirebaseMessaging.onBackgroundMessage` (Android) / PushKit-колбэк (iOS) →
  показать CallKit-звонок с `callId`+`fromName`.
- На «принять» из CallKit: поднять приложение → `registerCommonDependencies()`
  (фоновый isolate стартует «холодным» — как отмечено про `helloWorldWorker` в
  `lib/main.dart`) → `API.setForeground(true)` откроет стрим → `Calls` поймает
  ретранслируемый `CALL_OFFER` → `accept()`. Связать `callId` из пуша с приходящим
  offer.
- На «отклонить»/`cancel`-push: `Calls.reject()` / закрыть CallKit.

**Интеграция с `Calls` (`lib/calls.dart`):**
- Добавить путь «принято из CallKit до прихода offer»: если пользователь принял в
  CallKit, а offer ещё не дошёл — держать состояние ожидания и вызвать `accept()`,
  когда offer прилетит по стриму (по `callId` из пуша).
- Снять экранную диагностику/временный диалер — по договорённости это фаза 3; в
  фазе 4 не трогаем, но учитываем при тестах.

## Порядок реализации (стадии)

1. **Токены**: proto + модель + хендлер `REGISTER_PUSH_TOKEN` + клиентский
   `PushManager` (получить/зарегистрировать). Проверка: токены в Mongo.
2. **Сервер-push**: `push.go` (FCM+APNs), конфиг, триггер в `relayCallSignal`.
   Проверка: при звонке в лог сервера уходит push, устройство получает data/VoIP.
3. **Android входящий**: FCM data → CallKit-incoming → принять/отклонить →
   реальный звонок. Проверка E2E: A(foreground) → B(Android, killed).
4. **iOS входящий**: PushKit+CallKit, entitlements, AppDelegate. Проверка E2E:
   A → B(iOS, killed). **Требует реального устройства + TestFlight/dev-профиля.**
5. **cancel-push** (снятие звонка при hangup/reject до ответа) + дедуп двойного
   ринга foreground.

## Verification

- **Токены**: залогиниться → проверить в Mongo (`sessions`), что `fcmToken`/
  `voipToken` заполнены; сменить токен → апдейт.
- **Android killed**: выгрузить B, позвонить с A → нативный входящий, принять →
  звук/видео. Отклонить/отменить с A → входящий пропадает.
- **iOS killed**: то же на реальном iPhone (VoIP/CallKit не работают в
  симуляторе). Проверить, что VoIP-push всегда репортится в CallKit (иначе iOS
  банит).
- **Foreground регресс**: убедиться, что при активном аппе нет двойного звонка
  (NATS + push) — дедуп по `callId`.
- **Деплой сервера** на staging (`~/docker/staging-iperon/`, workflow
  `staging.yaml`) с секретами push; нативные изменения клиента — полный `flutter
  run` + `pod install`, hot reload не годится.

## Риски / заметки

- iOS VoIP строг: каждый VoIP-push обязан немедленно репортиться в CallKit.
- Фоновый isolate стартует холодным — обязателен повторный
  `registerCommonDependencies()` (см. комментарий в `lib/main.dart`).
- Секреты push (APNs `.p8`, FCM SA JSON) — только на сервере; в CI восстанавливать
  из secrets, как `firebase_options.dart`/`.env` (см. CLAUDE.md, раздел CI/CD).
- Тест iOS-части невозможен на симуляторе и без прод/дев APNs-профиля — планируем
  на реальном устройстве.
