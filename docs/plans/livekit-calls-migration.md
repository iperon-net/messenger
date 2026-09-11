# Миграция звонков на LiveKit

## Зачем

Текущие звонки — ручной WebRTC 1-на-1: P2P-медиа (SRTP мимо сервера) + сигналинг
(offer/answer/ICE) через gRPC-стрим и core NATS relay, perfect negotiation,
offer-retransmit, trickle ICE, эфемерные TURN-креды (coturn). Эта ручная
SDP/ICE-логика — источник багов, а **групповые звонки** на ней пришлось бы
писать с нуля (свой SFU — гиблое дело).

LiveKit (self-host, Apache-2.0) — SFU + готовый сигналинг. Забирает на себя весь
SDP/ICE-обмен и даёт групповые «почти бесплатно» (та же комната, N участников).

### Ключевая мысль

LiveKit заменяет **сигналинг**, но **НЕ побудку**. Он не будит убитое
приложение. Поэтому вся push-инфраструктура (`call_push.dart`, `push.dart`,
`push.go/SendCallPush`, VoIP/FCM-токены, CallKit/ConnectionService) **реюзается
целиком** и рискам переезда не подвергается. Выкидывается именно ручной
SDP/ICE-слой.

### Стратегия: rip-and-replace (без фича-флага)

Приложение **ещё не в проде**, живых пользователей звонков нет — поэтому
инвариант «звонок жив на каждом шаге» и двойной движок за флагом не нужны (это
был бы оверинжиниринг ради несуществующих пользователей). Старый ручной механизм
**удаляем сразу** при написании замены (Фаза 2), на чистом месте. Между Фазой 1
и концом Фазы 2 звонок временно нерабочий — это допустимо. Побудку не трогаем.

## Что где сейчас

| Слой | Файлы | ~строк |
|---|---|---|
| Клиент: сигналинг+медиа+PC lifecycle | `lib/calls.dart` | 760 |
| Клиент: UI звонка | `lib/components/calls/call_view.dart`, `local_media_preview.dart`, `call_gate.dart`, `lib/screens/call/*` | ~385 |
| Клиент: побудка (РЕЮЗ) | `lib/call_push.dart`, `lib/push.dart` | 343 |
| Сервер: relay (УДАЛИТЬ) | `internal/api/v1.go` (`relayCallSignal`, `dispatchCallPush`, `CALL_ICE_SERVERS`) + `protos/call_v1.proto` | ~150 |
| Сервер: push (РЕЮЗ) | `internal/services/push.go` (`SendCallPush`) | ~120 |

`Calls` сохраняет неизменный публичный API к UI —
`startCall / accept / reject / hangup / snapshots` (`CallSnapshot`); меняются
только его потроха.

---

## Фаза 0 — Инфра + spike

- Поднять `livekit-server` (docker) на прод-сервере: ключи (`api-key`/`secret`),
  встроенный TURN (порты 443 / 7881 UDP), TLS. Redis пока не нужен — одна нода.
- Проверить связь **вне мессенджера**: `lk` CLI / demo-app, два устройства
  заходят в комнату, видят медиа. Через реальный NAT/coturn-сеть.

Выход: живой SFU, доказанная связность.

## Фаза 1 — Token-RPC на сервере (аддитивно) — ГОТОВО (2026-09-11)

- `protos/call_v1.proto`: добавлен
  `CallToken { Request{callId, toUserID}; Response{url, token} }`;
  `MessageType CALL_TOKEN = 27` в `v1.proto`. Оба репо синхронны, серверный pb
  регенерирован. **Клиентский Dart-pb НЕ регенерирован** — отложено в Фазу 2
  (новый `protoc-gen-dart` даёт большой шум переформатирования; регенерим там,
  где `CALL_TOKEN` реально используется. Команда:
  `protoc --dart_out=lib/protobuf -I. protos/v1.proto protos/call_v1.proto`,
  затем удалить лишние `*.pbserver.dart` — оригинал генерился с `grpc:`).
- Чеканка **LiveKit JWT** через `github.com/livekit/protocol/auth` (v1.51.0,
  прямая зависимость): `V1.callToken` — room = `callId`, identity = userID hex
  сессии, гранты `RoomJoin/CanPublish/CanSubscribe`, TTL из конфига (6h).
  Хендлер `case CALL_TOKEN` через `exchangeEncrypted` (шифрованный unary).
- Конфиг: блок `LiveKit{URL,APIKey,APISecret,TokenTTL}` в `settings.go` +
  `livekit:` в `iperon.yaml` (url `wss://livekit.iperon.net`, key `APIiperon01`;
  **apiSecret заполняется на сервере при деплое** — вне git). Пустой APISecret ⇒
  `CALL_TOKEN` отвечает `Unavailable`.
- Старый `relayCallSignal`/`iceServers` оставлены (удалим в Фазе 2) — Фаза 1
  чисто аддитивна, ничего не ломает. `go build`/`go vet` зелёные.

Выход: сервер умеет выдавать токен.

## Фаза 2 — LiveKit-движок на клиенте + снос старого (rip-and-replace)

Один заход, старое и новое не сосуществуют:

- Добавить `livekit_client` в `pubspec.yaml`.
- Переписать нутро `lib/calls.dart` на LiveKit: `startCall/accept` →
  запрос `CALL_TOKEN` → `Room.connect(url, token)` → `publishTrack(audio/video)`
  → события комнаты (`ParticipantConnected`, `TrackSubscribed`, `Disconnected`)
  маппятся в тот же `CallSnapshot`.
- **Ring поверх своего же NATS/стрима, без SDP:** звонящий шлёт лёгкий
  `CALL_RING` (callId, toUserID, video) → сервер релеит в стрим адресата **и**
  дёргает `SendCallPush` (переиспользуем `push.go` целиком). Отмена/отклонение —
  существующие `CALL_HANGUP`/`CALL_REJECT`. Отдельный сигнал «принял» не нужен:
  звонящий видит это как `ParticipantConnected` в комнате.
- **Удалить старый механизм:** perfect-negotiation (`_polite`/`_isPolite`),
  offer-retransmit, glare, ICE-буфер, `_createPeerConnection`,
  `_onOffer/_onAnswer/_onRemoteCandidate`, `_sendSignal`, `_fetchIceServers`
  в `calls.dart`; на сервере — SDP-кейсы `relayCallSignal`, `CALL_ICE_SERVERS`
  (TURN-HMAC), `Call.Signal`/`IceServers` из `call_v1.proto`.
- Побудку (`call_push.dart`, `push.dart`, `push.go`) НЕ трогаем.

Выход: звонок работает только через LiveKit.

## Фаза 3 — UI под LiveKit

- `call_view.dart` / `local_media_preview.dart`: рендерят треки участников
  виджетами LiveKit. `call_gate.dart` без изменений (навигация по `CallSnapshot`).

## Фаза 4 — Валидация 1-на-1

- Матрица тестов: iOS↔Android, foreground + побудка из убитого приложения
  (push → join room), mic/cam permission, отмена/reject, glare (одновременный
  звонок), реконнект сети.

Выход: крепкие 1-на-1 на LiveKit.

## Фаза 5 — Групповые звонки

- Комната уже держит N участников. Добавить точку входа «групповой звонок»,
  `CALL_RING` на нескольких адресатов (или групповая комната), grid-layout UI,
  active-speaker.

## Фаза 6 — coturn out

- **coturn на прод-сервере (`alica`, `/disk/compose/coturn/`) ОТКЛЮЧЁН**
  (2026-09-11) — встроенный TURN LiveKit (`livekit.iperon.net:5349`, TLS-серт LE)
  его замещает. Старый контейнер coturn остановлен.
- Остаётся почистить в коде: серверный `CALL_ICE_SERVERS`/`IceServers` + HMAC-креды
  (`V1.iceServers()`, блок `turn:` в `iperon.yaml`) и клиентский
  `_fetchIceServers()` — удаляются в Фазе 2 вместе с остальным legacy-сигналингом.
  См. память `webrtc-coturn-prod-deploy`.

## Статус инфры (Фаза 0) — ГОТОВО (2026-09-11)

- `livekit-server` поднят на `alica`, docker-сеть `iperon` (`10.10.1.90`),
  публичный IP `217.168.244.230`, `node_ip` прописан явно.
- Хост `livekit.iperon.net`, `wss` через nginx (443, WS-upgrade из `proxy_params`).
- Встроенный TURN/TLS на `5349` с сертом LE; coturn отключён.
- Порты: `7881/tcp`, `7882/udp` (медиа-mux), `5349/tcp`; `7880` только за nginx.
- Ключ `APIiperon01` + секрет в `livekit.yaml` — им же подписывать `CALL_TOKEN`.
- Сигналинг подтверждён: `lk room list` отвечает без ошибок авторизации.

## Отложенная фаза (опционально) — E2EE медиа

- Включить frame-encryption LiveKit с общим ключом; раздачу ключа участникам
  завязать на существующий key exchange (`lib/crypto/`). Делать отдельно —
  до этого медиа шифруется hop-by-hop (DTLS-SRTP), расшифровываемо на SFU.

---

## Оценка трудозатрат

| Задача | Оценка |
|---|---|
| Фаза 0: деплой + конфиг livekit-server | 0.5–1 д |
| Фаза 1: `CALL_TOKEN` + чеканка JWT (Go) | 1–2 д |
| Фаза 2: переписать `calls.dart` на LiveKit + ring + снос старого | 3–5 д |
| Фаза 3: адаптировать `call_view`/preview | 1 д |
| Фаза 4: тесты 1-на-1 обе стороны | 1–2 д |
| **Итого до надёжных 1-на-1** | **~1.5–2 недели** |
| Фаза 5: групповые (grid-UI + тесты) | +2–4 д |

## Развилки

1. **E2EE медиа.** SFU расшифровывает медиа (DTLS-SRTP только hop-by-hop). Для
   группового E2EE нужна раздача ключа всем участникам — отдельная работа. План:
   раскатать без E2EE-медиа, включить frame-encryption отдельной фазой.
2. **coturn.** Встроенный TURN LiveKit его замещает → уходит в Фазе 6.
