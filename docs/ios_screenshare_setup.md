# iOS: настройка демонстрации экрана (Broadcast Upload Extension)

Dart/Android-часть демонстрации экрана уже в коде (`Calls.toggleScreenShare`,
UI в `call_view.dart`). На iOS для захвата **всего экрана** нужен отдельный
таргет — **Broadcast Upload Extension** (ReplayKit) — и **App Group** для
передачи кадров в основное приложение. Исходники расширения уже лежат в
`ios/BroadcastExtension/`, ключи в `Info.plist`/entitlements Runner добавлены.
Осталось то, что нельзя сделать правкой файлов: зарегистрировать таргет в
Xcode-проекте, завести App Group в Apple Developer и обновить подпись/CI.

Значения по проекту:

| Параметр | Значение |
|---|---|
| Bundle ID приложения | `net.iperon.messenger` |
| Bundle ID расширения | `net.iperon.messenger.broadcast` |
| App Group | `group.net.iperon.messenger` |
| Минимальная iOS | 15.0 (как у Runner) |

---

## 1. Xcode: создать таргет расширения

1. Открыть `ios/Runner.xcworkspace` в Xcode.
2. **File → New → Target… → Broadcast Upload Extension**.
   - Product Name: `BroadcastExtension`.
   - **Снять галку** «Include UI Extension».
   - Embed in Application: `Runner`.
   - Bundle Identifier должен получиться `net.iperon.messenger.broadcast`.
3. Xcode создаст группу `BroadcastExtension` со своими `SampleHandler.swift` и
   `Info.plist`. **Удалить сгенерированный `SampleHandler.swift`** (Move to Trash)
   и **добавить наши файлы** из `ios/BroadcastExtension/` в таргет расширения
   (Add Files to "Runner"…, поставить галку target = BroadcastExtension, снять у
   Runner):
   - `SampleHandler.swift`, `SampleUploader.swift`, `SocketConnection.swift`,
     `Atomic.swift`, `DarwinNotificationCenter.swift`.
   - Заменить сгенерированный `Info.plist` нашим `ios/BroadcastExtension/Info.plist`
     (или проверить, что содержимое совпадает — `NSExtensionPrincipalClass` =
     `$(PRODUCT_MODULE_NAME).SampleHandler`).
4. В настройках таргета `BroadcastExtension`:
   - **Deployment Target = 15.0** (иначе archive упадёт на несовпадении с Runner).
   - **Signing & Capabilities → + Capability → App Groups**, добавить
     `group.net.iperon.messenger`. Xcode пропишет `BroadcastExtension.entitlements`
     — заменить его нашим `ios/BroadcastExtension/BroadcastExtension.entitlements`
     или убедиться, что App Group тот же.
5. Таргет `Runner` → **Signing & Capabilities → + Capability → App Groups**,
   добавить тот же `group.net.iperon.messenger`. (Entitlements Runner уже содержат
   его — Xcode подхватит.)
6. Подов расширению не нужно — оно использует только `ReplayKit`/`Foundation`/
   `CoreImage`. Podfile не трогаем.

> Почему это не сделано скриптом: регистрация app-extension таргета меняет
> `project.pbxproj` (build phases, embed-extension copy phase, зависимости) —
> ручная правка pbxproj слишком легко ломает проект, поэтому шаг делается в GUI.

## 2. Apple Developer Portal

1. **Identifiers → App Groups** → создать `group.net.iperon.messenger`.
2. App ID `net.iperon.messenger`: включить capability **App Groups**, привязать
   группу.
3. Создать App ID `net.iperon.messenger.broadcast`, включить **App Groups** +
   привязать ту же группу.
4. **Перевыпустить provisioning profiles** (App Store / distribution):
   - для `net.iperon.messenger` (теперь с App Group);
   - новый для `net.iperon.messenger.broadcast`.

## 3. CI (`.github/workflows/_deploy_testflight.yaml`)

Сейчас workflow ставит **один** профиль и подписывает **один** таргет
(`net.iperon.messenger`). Нужно добавить профиль расширения:

1. **Новый секрет** с base64 профиля расширения (напр.
   `IOS_BROADCAST_PROVISIONING_PROFILE_BASE64`). Профиль Runner тоже перевыпустить
   (с App Group) и обновить существующий секрет.
2. В шаге «Install provisioning profile» установить **оба** профиля (декодировать
   и скопировать в `~/Library/MobileDevice/Provisioning Profiles/`), запомнив имя
   профиля расширения в `BROADCAST_PROFILE_NAME`.
3. Подпись расширения: у него свой `PRODUCT_BUNDLE_IDENTIFIER`, поэтому ключи
   `Release.xcconfig` (они общие/для Runner) на него не лягут корректно. Проще
   всего — задать подпись расширения через отдельный xcconfig таргета или через
   аргументы `xcodebuild`; главное, чтобы **ExportOptions.plist** содержал оба
   профиля:
   ```xml
   <key>provisioningProfiles</key>
   <dict>
     <key>net.iperon.messenger</key>
     <string>${PROFILE_NAME}</string>
     <key>net.iperon.messenger.broadcast</key>
     <string>${BROADCAST_PROFILE_NAME}</string>
   </dict>
   ```
4. Проверить, что перевыпущенный профиль Runner включает App Group — иначе
   archive упадёт на entitlements (в Runner теперь есть
   `com.apple.security.application-groups`).

## 4. Проверка на устройстве

- Только **release/TestFlight** сборка (см. память `ios-voip-push-testing` —
  debug из cold-start ненадёжен; демонстрация экрана в debug тоже капризна).
- Начать звонок → в панели «Экран» → системный диалог ReplayKit → выбрать
  «Iperon Screen» → Начать вещание. Собеседник должен увидеть экран (`contain`,
  подпись «Демонстрирует экран»).
- Проверить одновременную работу камеры + экрана, отбой во время шаринга,
  уход/возврат из фона.

## Как это работает (справка)

Расширение захватывает кадры и пишет их в unix-сокет `rtc_SSFD` в контейнере
App Group; на стороне приложения `FlutterBroadcastScreenCapturer` (flutter_webrtc)
читает их, потому что в `Runner/Info.plist` заданы `RTCAppGroupIdentifier` и
`RTCScreenSharingExtension`. Флаг включается из Dart:
`ScreenShareCaptureOptions(useiOSBroadcastExtension: true)` в
`Calls.toggleScreenShare`.
