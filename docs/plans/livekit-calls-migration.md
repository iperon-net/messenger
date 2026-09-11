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

## Фаза 2 — LiveKit-движок на клиенте + снос старого (rip-and-replace) — ГОТОВО (2026-09-11)

Один заход, старое и новое не сосуществуют:

- `pubspec.yaml`: добавлен `livekit_client: ^2.12.0`; `flutter_webrtc`
  запинен ровно на `1.6.0` (livekit пинит эту версию — `^1.6.1` конфликтует).
- `lib/calls.dart` переписан на LiveKit, публичный API к UI неизменен:
  `startCall/accept` → `CALL_TOKEN` (`api.unaryEncodedWithResponse`) →
  `Room.connect(url, token)` → `setMicrophoneEnabled/setCameraEnabled` →
  события комнаты (`ParticipantConnected`, `TrackSubscribed/Unsubscribed`,
  `ParticipantDisconnected`, `RoomDisconnected`) маппятся в тот же
  `CallSnapshot`. Видеодорожки (`VideoTrack`) живут в сервисе (не immutable),
  UI читает их геттерами `localVideoTrack`/`remoteVideoTrack`; смену дорожек
  сигналит новый монотонный `CallSnapshot.mediaEpoch` (иначе mappable-equality
  снимков не различит их). Громкая связь — `AudioManager.instance
  .setSpeakerOutputPreferred` (не устаревший `Hardware.setSpeakerphoneOn`).
- **Ring без SDP:** `CallRing{callId, toUserID, fromUserID, video}` — один
  message на `CALL_RING`/`CALL_HANGUP`/`CALL_REJECT` (тип задаёт конверт).
  Звонящий шлёт `CALL_RING` → сервер релеит в стрим адресата **и** дёргает
  `SendCallPush`. «Принял» отдельным сигналом не шлём — звонящий видит
  `ParticipantConnected`.
- **Снесено:** на клиенте — perfect-negotiation, offer-retransmit, glare,
  ICE-буфер, `_createPeerConnection`, `_onOffer/_onAnswer/_onRemoteCandidate`,
  `_sendSignal`, `_fetchIceServers`, RTC-рендереры. На сервере — SDP-кейсы
  `relayCallSignal`, `CALL_ICE_SERVERS`/`iceServers()` (TURN-HMAC),
  `Call.Signal`/`IceServers` из `call_v1.proto`; в `v1.proto`
  `CALL_OFFER/ANSWER/ICE_CANDIDATE/ICE_SERVERS` удалены и `reserved 16,17,18,21`.
- Клиентский Dart-pb регенерирован (отложенное из Фазы 1).
- **Адаптирован UI, чтобы репо компилировалось** (формально Фаза 3):
  `call_cubit.dart` отдаёт `VideoTrack?`-геттеры + `mediaEpoch`;
  `call_state.dart` получил поле `mediaEpoch` (+ build_runner);
  `call_view.dart` рендерит `VideoTrackRenderer` вместо `RTCVideoView`.
- Побудку (`call_push.dart`, `push.dart`, `push.go`) НЕ трогали.
- `flutter analyze` зелёный, `dart format lib` прогнан.

Выход: звонок работает только через LiveKit.

## Фаза 3 — UI под LiveKit — ГОТОВО (2026-09-11)

- `call_view.dart`: удалённое видео — `VideoTrackRenderer` на весь экран,
  локальное — PiP (сделано ещё в Фазе 2). Добавлена **личность собеседника**:
  имя вместо заглушки «Звонок» + аватар (для аудиозвонка; для видео не дублируем,
  лицо уже на экране). Плейсхолдер — `AnimatedBoringAvatar` (сид = hex userID),
  как на экране профиля.
- `call_cubit.dart` / `call_state.dart`: `CallState` получил `displayName`,
  `boringAvatarHash`, `avatarBytes` (+ `Uint8ListMapper`). `CallCubit` разрешает
  профиль собеседника по `remoteUserID` тем же путём, что и `ProfileCubit`:
  мгновенно из кэша БД (`repositories.profiles` + `cdnManager.cachedFile`) и
  из стрима `PROFILE` (запрос + слушатель) — чтобы дозаполнить незнакомца
  (входящий от не-контакта). Имя собирается с учётом локали (RU: «Фамилия Имя»),
  фолбэк — телефон → username.
- Удалён мёртвый `local_media_preview.dart` — спайк-виджет Фазы 0 на
  `flutter_webrtc`, нигде не использовался после переезда на LiveKit.
- `call_gate.dart` без изменений (навигация по `CallSnapshot`).
- `flutter analyze` зелёный, `dart format lib` прогнан.

**Не входит в эту фазу** (нужен бэкенд, которого нет): полноценный список
вызовов/история на вкладке «Звонки» — там пока временный диалер по hex-userID
(`calls_cupertino/material.dart`). Отдельная фича, вне миграции.

## Фаза 4 — Валидация 1-на-1

- Матрица тестов: iOS↔Android, foreground + побудка из убитого приложения
  (push → join room), mic/cam permission, отмена/reject, glare (одновременный
  звонок), реконнект сети.

### Чек-лист тестирования на устройствах (вернуться позже)

Собрать TestFlight с фиксом двойного владения AVAudioSession (externalCallSystem
+ гейтинг аудиодвижка + регистрация исходящего в CallKit + `configureAudioSession:
false`), затем проверить:

- [ ] **Android→iOS, ответ с локскрина через CallKit** — двусторонний звук.
- [ ] **iOS→Android, исходящий** (теперь идёт через CallKit-UI из-за
      `startCall`) — двусторонний звук; проверить, что системный CallKit-экран
      исходящего выглядит ок.
- [ ] iOS→iOS, оба направления, foreground и побудка из убитого приложения.
- [ ] Отмена звонящим до ответа (`action=cancel`) снимает нативный экран.
- [ ] Reject получателем.
- [ ] Реконнект сети во время активного звонка.
- [ ] **Свежая установка**: первый звонок из фона у нового пользователя —
      микрофон ещё не выдан, iOS не может показать промпт на CallKit-пути →
      звонок упадёт. Проверить необходимость проактивного запроса mic-permission
      в foreground (при первом заходе на вкладку звонков / старте / приёме).

**Android: экран звонка требовал разблокировку устройства (keyguard) — ПОЧИНЕНО
(не коммичено, ждёт проверки на устройстве).** Отпечаток — это keyguard самого
устройства (в приложении PIN не заведён, наш `ScreenLock` ни при чём). Причина:
`MainActivity` не была объявлена `showWhenLocked`/`turnScreenOn`, поэтому Android
не рисует её поверх keyguard. Приложение поднимается двумя путями плагина
(custom-notification), и **оба надо ловить**:
  - full-screen intent входящего (экран выключен): `action == null`, но в extras
    есть `EXTRA_CALLKIT_CALL_DATA`;
  - «Ответить» из `TransparentActivity`: `action` содержит `ACTION_CALL_*`.
Важно: в фоне стрим закрыт (`api.setForeground(false)`), поэтому Dart о входящем
узнаёт только на «принять» — ставить флаг из Dart на входящем поздно, keyguard уже
показан. Значит флаг должен ставить **натив** при подъёме Activity.
Фикс (не коммичено, Kotlin компилируется):
  1. `MainActivity.kt`: `onCreate`/`onNewIntent` при call-intent (по
     `EXTRA_CALLKIT_CALL_DATA` **или** `ACTION_CALL`) включают показ поверх
     локскрина (`setShowWhenLocked`+`setTurnScreenOn`); MethodChannel
     `net.iperon.messenger/call_window` метод `allowOverLockscreen(bool)`.
  2. `call_push.dart`: держит флаг на время звонка через канал (ставит при
     активном статусе, снимает по `idle`/`ended`), чтобы мессенджер не оставался
     виден поверх блокировки. iOS — no-op.
Мелкий остаток: при пропущенном (не принятом) звонке из фона Dart не узнаёт о
завершении (стрим был закрыт) → флаг снимется только на следующем снимке. Не
блокер.
**ОБНОВЛЕНО (валидация на Pixel 9, см. ниже):** описанный выше keyguard-подход
через `showWhenLocked` на `MainActivity` оказался НЕДОСТАТОЧНЫМ (биометрию зовёт
активити плагина `CallkitIncomingActivity`, а не наша) → перешли на вендоринг
плагина. А «связь не устанавливается» — это была НЕ проблема killed-кейса, а
сочетание оборванной подписки `_incoming` + двойного приёма
(`DUPLICATE_IDENTITY`); оба ПОЧИНЕНЫ (см. следующий подраздел).

### Android: валидация на Pixel 9 (Android 17/API37) + логи LiveKit — 3 корневые причины, ВСЁ ПОЧИНЕНО (2026-09-11, не коммичено)

Проверено на реальном устройстве и логами LiveKit-сервера. **Инфраструктура
LiveKit ИСПРАВНА** (iPhone соединяется по UDP ~0.8с, обе стороны publish/subscribe,
`connectionType udp`) — прежние подозрения на ICE/coturn были НЕВЕРНЫ. Все три
бага — клиентские:

1. **Входящий не обрабатывался вообще (и foreground, и push).** `api.dart._close()`
   (вызывается из `_reconcile` при `!_authorized`) закрывал и обнулял broadcast
   `_incoming`. На старте `_reconcile` успевает вызвать `_close()` (сессия ещё
   грузится), а `Calls` уже подписан на `api.on(CALL_RING)` в конструкторе → старый
   контроллер уничтожался, `_open()` создавал новый, подписка `Calls` навсегда
   висела на мёртвом. Симптом: `unhandled stream message type: CALL_RING`, но
   `Calls._handleSignal` не вызывался. **Фикс:** `_close()` больше не трогает
   `_incoming` (живёт как синглтон `API`; закрываем только в `shutdown()` при
   завершении процесса). Доставка чужой сессии безопасна — `_dispatch` гейтится на
   `auth.isAuthorized`.
2. **Биометрия при ответе с локскрина.** Полноэкранный входящий рисует активити
   плагина `CallkitIncomingActivity` (fullScreenIntent), её `onAcceptClick()`
   жёстко зовёт `requestDismissKeyguard()` (лог: `Activity requesting to dismiss
   Keyguard: CallkitIncomingActivity`). Конфигом не отключить. **Фикс:** вендоринг
   плагина в `third_party/flutter_callkit_incoming` + `dependency_overrides` в
   корневом `pubspec.yaml`; из `CallkitIncomingActivity.onAcceptClick` удалён
   `dismissKeyguard()` (и метод + импорт `KeyguardManager`). Ответ идёт сразу на
   `MainActivity` (showWhenLocked) без отпечатка. Проверено: `dismiss Keyguard` в
   логах ответа больше нет. Патч переносить вручную при апдейте плагина.
3. **«Нет голоса»/«сразу отрубается» = ДВОЙНОЙ ПРИЁМ → `DUPLICATE_IDENTITY`.** Плагин
   шлёт accept дважды (действие `CallkitNotificationService` + broadcast из
   `TransparentActivity`) → два `acceptFromPush` → два `Room.connect` с одной
   identity → сервер выбивает участника (`removing duplicate participant reason:
   DUPLICATE_IDENTITY`, `session 0s`), звонок рвётся мгновенно. Ключ: одиночный
   чистый звонок держится и **звук есть** — значит инфра/аудио ок, дело в дубле.
   Слоёные гарды `_acceptedCallId`(call_push) и `_handlingCallId`(calls.accept)
   оказались ненадёжны. **Решил** синхронный флаг `_connectingRoom` в choke-point
   `Calls._connectRoom`: `_room` выставляется только ПОСЛЕ `await CALL_TOKEN`,
   поэтому одной проверки `_room != null` мало (оба видят null); `_connectingRoom=
   true` до первого await закрывает окно. Сброс в `_teardown`, снятие после
   `_room=room`. Проверено на устройстве: одиночный join, `connectionType udp`,
   **двусторонний звук есть**.

**Дожато в коде (analyze зелёный, устройство отключено — НЕ проверено вживую):**
- дедуп-лог: в `acceptFromPush` на обоих proceed-путях `_handlingCallId=callId`
  ставится синхронно (до await) — повторный accept отсекается верхним гардом ещё
  до эмита/`CALL_TOKEN`, а не только `_connectingRoom` на уровне комнаты;
- earpiece: в `_connectRoom` после `_publishLocalMedia` на Android явный
  `AudioManager.setSpeakerOutputPreferred(_snapshot.speakerOn)` (аудио → earpiece,
  видео → speaker) — иначе LiveKit по умолчанию уходит в speaker.

Инфра LiveKit (для истории): coturn УБРАН, встроенный TURN LiveKit. `livekit.yaml`:
`node_ip 217.168.244.230`, `use_external_ip:false`, udp-mux `7882`, tcp `7881`,
`turn.enabled` tls `5349` domain `livekit.iperon.net` (cert `*.iperon.net` валиден).
Порты открыты/проброшены, DNS ок, nginx→7880 health `OK`.

**Android: тап по ongoing-нотификации не возвращал на экран звонка — ПОЧИНЕНО
(не коммичено).** Если во время звонка свернуть экран `/call` (свайп-назад/домой),
тап по звонку в шторке не открывал его заново. Причины: (1) `CallGate` пушил
`/call` только на переходе в активный статус, а флаг открытости десинкался при
ручном закрытии; (2) тап по нотификации не давал Dart явного сигнала. Фикс:
  - `Calls`: `focusRequests`-поток + `requestFocus()` (сигнал «вывести звонок на
    передний план», отдельно от снимков — статус не меняется).
  - `CallGate`: авто-открытие только на переходе idle/ended→активный (`_wasActive`);
    открытость `/call` теперь отслеживается через future от `push()` (сброс при
    любом закрытии, включая свайп-назад); подписка на `focusRequests` открывает
    `/call` заново, если звонок активен.
  - `MainActivity.kt`: тёплый call-intent (тап по нотификации) → `focusCall` в
    Flutter через канал `call_window`; `call_push.dart` ловит `focusCall` →
    `calls.requestFocus()`. Kotlin BUILD SUCCESSFUL, analyze/format зелёные.

Открытые доработки, всплывшие в Фазе 4 (сделать при возврате):

- Проактивный запрос разрешения на микрофон в foreground (см. чек-лист выше).
- Заменить имя звонящего в CallKit с «Iperon» на фактического собеседника
  (`nameCaller` в `_incomingParams`/`_outgoingParams` + `AppDelegate.swift`).
- Разобрать Crashlytics `Fatal Exception: FlutterError` во время активного
  звонка (issue 62faceae).

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
