# WebRTC-звонки на клиенте (1-на-1, ICE)

## Контекст

Задача — голосовые/видео-звонки 1-на-1 через WebRTC поверх ICE. Транспорт
для сигналинга писать **не нужно**: он уже есть.

- Долгоживущий двунаправленный gRPC-стрим (`API.Stream`, `lib/api.dart`)
  открыт, пока `authorized && foreground`. Отправка — `api.sendEncoded(type,
  bytes)`, приём — `api.on(type)`. Каждое сообщение E2-шифруется на ключах
  сессии между клиентом и сервером.
- На сервере каждый стрим подписан на NATS-subjects `userID.<hex>` и
  `sessionID.<hex>`, а `ServicePublisher.PublishToUser` доставляет сообщение
  конкретному пользователю (все его устройства). Это и есть маршрут
  «звонящий → вызываемый». См. серверный план `webrtc-signaling-relay.md`.
- Есть вкладка `/calls` с пустыми `CallsCupertino/CallsMaterial` — задел под UI.

Сигнальный обмен ложится классически:

```
Caller                     Server (relay)                    Callee
  │  CALL_OFFER (sdp) ────► PublishToUser(callee) ─────────►  │  входящий
  │  ◄──────────── PublishToUser(caller) ◄──── CALL_ANSWER ───┤
  │  CALL_ICE_CANDIDATE ──► ...relay... ───────────────────►  │  addCandidate
  │  ◄────────────────────── ...relay... ◄── CALL_ICE_CANDIDATE┤  (trickle, обе стороны)
  │              ── медиа НАПРЯМУЮ p2p (или через TURN) ─────► │
```

Медиа (SRTP) идёт мимо сервера — напрямую p2p, а за symmetric NAT / в
мобильных сетях через TURN-relay. Здесь работает ICE.

## Зафиксированные решения

- **Скоуп:** только 1-на-1 (один `RTCPeerConnection` на звонок). Группы =
  SFU, вне scope.
- **TURN:** свой coturn с эфемерными кредами (HMAC `use-auth-secret`), креды
  выдаёт сервер отдельным RPC. Клиент секрет TURN не хранит.
- **Фон:** входящие при закрытом стриме (app в фоне) — отдельная поздняя фаза
  (нужен push + CallKit/ConnectionService). Пока звонок только при активном
  приложении (стрим открыт лишь в foreground).
- **Trickle ICE** — кандидаты шлём по мере сбора, не ждём полного gathering.
- **Perfect negotiation** — роль polite/impolite выбираем детерминированно
  (сравнение своего и чужого `userID`), чтобы гасить glare.

## Фаза 0 — медиа-слой ✅

- `flutter_webrtc` в `pubspec.yaml`.
- iOS: добавить `NSMicrophoneUsageDescription` **локализованно** в
  `ios/Runner/{en,ru}.lproj/InfoPlist.strings` (+ английский дефолт в
  `Info.plist`). Камера (`NSCameraUsageDescription`) уже есть.
- Android: `RECORD_AUDIO`, `CAMERA`, foreground-service для звонка в
  `AndroidManifest.xml`.
- Проверка: локальный `RTCVideoRenderer` с камерой/микрофоном рендерится.
- Нативный плагин требует полного `flutter run` + `pod install`, не hot reload.

## Фаза 1 — сигналинг + первый p2p-звонок (foreground, STUN) ✅

> **Готово.** p2p-звонок (аудио/видео) между двумя устройствами в одной сети
> поднимается на STUN. Переход в `active` драйвится `onIceConnectionState`
> (агрегированный `onConnectionState` на мобильных ненадёжен — оставлен как
> вторичный). На экране звонка временно включена строка-диагностика
> (`CallSnapshot.debug` → `CallState.debug` → `call_view.dart`) и временный
> диалер на `/calls` — **снимем вместе в фазе 3**.

- Перегенерить protobuf после изменений в `protos/` (`CALL_*` типы + `call_v1.proto`).
  Серверная часть — в `webrtc-signaling-relay.md`.
- **`Calls`-сервис** (регистрируем в `lib/di.dart` по паттерну `API`):
  глобально слушает `api.on(CALL_OFFER)`. При входящем — пушит полноэкранный
  роут поверх табов через `rootNavigatorKey` (как в гайдлайне роутинга).
  Провайдить высоко в shell, чтобы входящий ловился на любом экране (как
  `ConnectionCubit`).
- Обёртка над `RTCPeerConnection`:
  - `createOffer/Answer`, `setLocal/RemoteDescription`;
  - `onIceCandidate → sendEncoded(CALL_ICE_CANDIDATE, ...)` (trickle);
  - входящие `CALL_ICE_CANDIDATE → addCandidate`;
  - `onTrack → RTCVideoRenderer` (remote), локальный трек — свой renderer;
  - perfect negotiation по сравнению `userID`.
- `CallCubit` + `CallState` (конвенция проекта: `dart_mappable`,
  `@MappableClass`, `Status`): машина состояний
  `idle → outgoing/incoming → connecting → active → ended`.
- Экраны — пары cupertino/material: входящий звонок и активный звонок;
  наполнить `/calls`.
- Резолв адресата: `toUserID` берём из контакта/чата, откуда инициируют звонок.
- **Цель фазы:** успешный p2p-звонок между двумя устройствами в одной сети
  (только STUN).

## Фаза 2 — ICE / TURN ✅

> **Готово end-to-end.** coturn развёрнут на прод-сервере, relay-кандидат
> подтверждён через Trickle ICE (клиент → `CALL_ICE_SERVERS` → эфемерные
> HMAC-креды → relay-аллокация на coturn). Ниже — что было сделано.
>
> - Proto: `MessageType CALL_ICE_SERVERS = 21` + `IceServers.{Request,Server,
>   Response}` в `call_v1.proto` (синхронно в клиенте и сервере, перегенерено).
> - Сервер: хендлер `CALL_ICE_SERVERS` через `exchangeEncrypted` →
>   `V1.iceServers()` генерит эфемерные TURN-креды по схеме coturn
>   `use-auth-secret` (username = `<expiry>:<userID hex>`, credential =
>   base64(HMAC-SHA1(secret, username))). Конфиг — блок `turn:` в `iperon.yaml`
>   (`secret`/`ttl`/`stunUrls`/`turnUrls`); пустой `secret` ⇒ только STUN.
> - Клиент: `Calls._fetchIceServers()` запрашивает серверы unary-вызовом
>   (`unaryEncodedWithResponse`) перед каждым `_createPeerConnection`; при
>   ошибке/пустом ответе — fallback на публичный STUN.
>
> **Остаётся:** развернуть coturn (`use-auth-secret`, тот же `secret`, что в
> `iperon.yaml`), прописать реальные `stunUrls`/`turnUrls`. До этого звонки
> ходят только STUN (в пределах доступного NAT).

- Клиент запрашивает у сервера эфемерные ICE-серверы (новый Unary-RPC,
  напр. `IceServers` — детали в серверном плане): `urls`, `username`,
  `password` с коротким TTL.
- Кладём их в `iceServers` конфиг **перед** созданием `RTCPeerConnection`
  (обновлять на каждый звонок — креды короткоживущие).
- Цель: звонки проходят через мобильные сети / за NAT.

## Фаза 3 — UI/UX

- Полноценные экраны: mute, speaker/earpiece, video-toggle, camera-flip,
  длительность, состояния «звоним / соединение / занято / отклонён / завершён».

## Фаза 4 — фон/пуш (отдельно, позже)

- Подключить `firebase_messaging` (сейчас закомментирован) — VoIP / FCM
  high-priority push, чтобы будить входящий при закрытом стриме.
- CallKit (iOS) / ConnectionService (Android) для нативного экрана входящего.

## Нюансы

- **E2E:** SDP/кандидаты проходят через сервер (внутри NATS payload открытые,
  до клиента шифруются сессией). Само медиа — SRTP p2p, сервер его не видит.
  E2E самого сигналинга — отдельная задача, вне фазы 1.
- **Foreground-ограничение** осознанное: стрим открыт только при
  `authorized && foreground`, фон = фаза 4.
- `fromUserID` проставляет сервер из сессии — клиенту не доверяем.
