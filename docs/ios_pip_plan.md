# iOS Picture-in-Picture для видеозвонков — план

Статус: **PoC в работе** (первая нативная реализация закоммичена в рабочее дерево,
на устройстве ещё не проверялась). Android PiP уже готов и работает отдельно.

## Цель

Показывать видео **собеседника** в системном мини-окне iOS, когда пользователь
сворачивает приложение во время видеозвонка (как FaceTime/WhatsApp). Своя камера
в фоне на iPhone всё равно не снимает — она остаётся приглушённой (собеседник
видит наш аватар), это уже реализовано (`pauseVideoForBackground`).

## Предпосылки (всё на месте)

- iOS deployment target **15.0** — доступен video-call PiP через
  `AVPictureInPictureController` + `AVSampleBufferDisplayLayer` content source.
- `UIBackgroundModes` содержит **`audio`** (и `voip`) — обязательное условие PiP.
- flutter_webrtc уже умеет конвертировать `RTCVideoFrame` → `CMSampleBuffer`
  (см. `FlutterRTCVideoPlatformView.m`) — переиспользуем логику.
- Доступ к нативному треку **без форка плагина**:
  `+[FlutterWebRTCPlugin sharedSingleton]` + `-remoteTrackForId:` → `RTCVideoTrack`,
  к которому вешаем свой `id<RTCVideoRenderer>` через `addRenderer:`.

## Архитектура

```
LiveKit RemoteVideoTrack (Dart)
        │  trackId = mediaStreamTrack.id
        ▼
[Dart] CallPipIos service ──MethodChannel(net.iperon.messenger/call_pip_ios)──►
        ▼
[ObjC] FlutterWebRTCPlugin.sharedSingleton.remoteTrackForId(trackId) → RTCVideoTrack
        │  addRenderer:
        ▼
[ObjC] CallPipRenderer <RTCVideoRenderer>
        │  renderFrame: → CVPixelBuffer → CMSampleBuffer → enqueue
        ▼
      AVSampleBufferDisplayLayer
        │  content source
        ▼
      AVPictureInPictureController  (+ SampleBufferPlaybackDelegate: live)
        │  canStartPictureInPictureAutomaticallyFromInline = YES
        ▼
   Система сама открывает PiP при сворачивании и закрывает при возврате
```

## Файлы

- `ios/Runner/CallPipController.h/.m` — **новое**. Владеет слоем, PiP-контроллером,
  рендерером; регистрирует `MethodChannel`; конвертация кадра (из плагина).
- `ios/Runner/Runner-Bridging-Header.h` — добавить `#import "CallPipController.h"`.
- `ios/Runner/AppDelegate.swift` — зарегистрировать канал:
  `CallPipController.shared().register(withMessenger: controller.binaryMessenger)`.
- `ios/Runner.xcodeproj/project.pbxproj` — **добавить .h/.m в таргет Runner**
  (перетащить в Xcode; см. «Открытые вопросы»).
- `lib/call_pip_ios.dart` — **новое**. Dart-обёртка канала (`isSupported`,
  `prepare(trackId)`, `teardown`).
- `lib/components/calls/call_view.dart` — на iOS при активном видеозвонке звать
  `prepare(remoteTrackId)`, на завершении/уходе — `teardown`. Обновлять при смене
  удалённого трека (`mediaEpoch`).

## Шаги

1. ✅ Нативный `CallPipController` (рендерер + слой + PiP-контроллер + делегат).
2. ✅ Регистрация канала в `AppDelegate` + bridging-header.
3. ✅ Dart-сервис `CallPipIos` + вызовы из `CallView` (iOS-only).
4. ⏳ Добавить файлы в таргет Runner (Xcode/pbxproj).
5. ⏳ Сборка на устройстве, проверка доступа к `WebRTC`/`FlutterWebRTCPlugin`
   символам из таргета Runner (header/link search paths).
6. ⏳ Проверка авто-старта PiP при сворачивании (слой должен быть «на экране» —
   возможно, добавить скрытый sublayer в окно).
7. ⏳ Увязка с аудиосессией CallKit (PiP не должен ломать маршрут звука).
8. ⏳ Крайние случаи: собеседник выключил камеру (показывать аватар/паузу),
   поворот, смена трека, завершение звонка из PiP.

## Риски / открытые вопросы

- **Доступ к символам `WebRTC` и `FlutterWebRTCPlugin` из таргета Runner.** Классы
  линкуются в приложение (плагин от них зависит), но header/module search paths у
  таргета Runner могут не видеть `<WebRTC/WebRTC.h>`. Обход в PoC: forward-declare
  `FlutterWebRTCPlugin` (класс резолвится в рантайме), `RTCVideoTrack` тянем из
  `<WebRTC/WebRTC.h>`. Если импорт не соберётся — добавить header search path в
  Podfile (`Runner` target) на pod `WebRTC-SDK`, либо весь модуль обернуть в
  runtime (`NSClassFromString`/`objc_msgSend`).
- **Авто-старт PiP.** `canStartPictureInPictureAutomaticallyFromInline` требует,
  чтобы контент был «на экране». Наш слой не в дереве Flutter — вероятно, добавим
  невидимый sublayer в `keyWindow`, чтобы система считала PiP-контент активным.
- **Добавление файлов в pbxproj.** Правка вручную рискованна; проще один раз
  перетащить .h/.m в Runner в Xcode (target membership = Runner).
- **Своя камера в фоне** остаётся приглушённой (ограничение iOS, не чиним).
- **Крэш-зона.** Рендерер живёт параллельно основному (Metal) рендеру звонка;
  жизненный цикл (attach/detach renderer, invalidate controller) вести аккуратно —
  ровно та область, где недавно ловили `EXC_BAD_ACCESS` (см. память проекта
  `webrtc-renderer-recreation-crash`).

## Проверка на устройстве (когда дойдём до 4–8)

- release/TestFlight-сборка (PiP из фона в debug может вести себя иначе).
- Видеозвонок → Home → должно открыться мини-окно с видео собеседника.
- Возврат → полноэкранный звонок, звук не рвётся.
- Собеседник выключил камеру → в PiP аватар/пауза, не заморозка.
