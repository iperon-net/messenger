# Обновление приложения: баннер новой версии и каналы установки

Статус: 2026-10-31, план. Не начато.

## 1. Задача

Сейчас обновление есть только на macOS (Sparkle). На остальных платформах есть лишь
принудительный экран «Обновите приложение» (`AppUpdateGate`,
`lib/components/app_update/`) — когда сборка старше `client.minimalVersion` из админки.
Нужно:

- **мягкое** уведомление «Доступна версия 0.0.N» — баннер, который можно отложить;
- обновление через **тот канал, откуда приложение установлено**: Google Play, RuStore,
  APK с сайта / GitHub, TestFlight / App Store, DMG + Sparkle;
- чтобы каналы не мешали друг другу (APK с сайта и Play — одна подпись, один ряд номеров
  сборки).

Проблема уже сейчас: `openAppUpdate()` на Android всегда ведёт в Google Play, где
приложения нет, — у тех, кто поставил APK руками, принудительный экран — тупик.

## 2. Что уже есть

- **Версия / номер сборки** общие для iOS, macOS и Android (`scripts/build_number.sh`,
  job `Version` в `build_and_deploy.yaml`): `0.0.N`, номер `N × 100 + попытка`. Растёт
  с каждым тегом и влезает в предел `versionCode` Play — значит, обновление из любого
  канала встаёт поверх сборки из другого без `INSTALL_FAILED_VERSION_DOWNGRADE`.
- **Подпись Android** — свой release-ключ (`iperon-release.jks`, секреты
  `ANDROID_KEYSTORE_*`), SHA-256 `9D:10:38:5A:…:75:50`. APK по ABI
  (`--split-per-abi`) публикуются в GitHub Release `v<версия>`
  (`_deploy_android.yaml`): `Iperon-<версия>-<abi>.apk` и постоянные `Iperon-<abi>.apk`.
- **macOS**: Sparkle + `appcast-macos.xml` в Latest-релизе, раздаёт nginx
  `download.iperon.net/macos/` (сервер, `docs/nginx/download.iperon.net.conf` в iperon).
- **Принудительное обновление**: `ClientConfig.minimalVersion` (админка) →
  `Settings.minimalVersion` → `AppUpdateGate` (слушает `Settings`, поднимается без
  перезапуска); `isVersionOlder()` сравнивает `0.0.N` по числам.

## 3. Каналы

Клиент определяет канал один раз при старте:

| Канал | Как определить | Источник «последней версии» | Кнопка «Обновить» |
|---|---|---|---|
| Google Play | установщик `com.android.vending` | Play In-App Updates API | flexible update: качает в фоне → «Перезапустить» |
| RuStore | установщик `ru.vk.store` | RuStore SDK обновлений | то же через SDK |
| APK (сайт / GitHub) | установщик пустой или системный (`com.google.android.packageinstaller`, `com.android.packageinstaller`, браузеры и т. п.) | наш манифест `android-latest.json` (§4) | скачать APK своего ABI → системное окно установки (§5) |
| TestFlight | `sandboxReceipt` в `appStoreReceiptURL` | наш манифест `ios-latest.json` (§4) | `itms-beta://` |
| App Store | обычный receipt | iTunes Lookup API (`itunes.apple.com/lookup?bundleId=…`) | ссылка на страницу в App Store |
| macOS (DMG) | — | Sparkle / `appcast-macos.xml` | `Desktop.checkForUpdates()` |

- Android: `PackageManager.getInstallSourceInfo(packageName).installingPackageName`
  (API 30+; ниже — `getInstallerPackageName`), через MethodChannel
  (`net.iperon.messenger/app_update`). Неизвестный установщик считаем каналом APK.
- iOS: последний путь чека `Bundle.main.appStoreReceiptURL` == `sandboxReceipt` → TestFlight
  (debug-сборки тоже дают sandbox — для них баннер выключен).
- Канал храним в памяти; в `Subscribe` / `CRASH_REPORT` можно передавать его на сервер
  (статистика: сколько сидит на APK) — по желанию, не блокер.

**Почему магазины — по их API, а не по серверу**: версия в магазине появляется после ревью и
поэтапной раскатки, и только магазин знает, доступна ли она конкретному пользователю.
Серверное «есть 0.0.600» при не раскатанной в Play версии = баннер, ведущий в никуда.

## 4. Манифест последней версии (APK, TestFlight)

Статический файл в GitHub Release, по аналогии с `appcast-macos.xml`. CI кладёт его в
релиз, nginx `download.iperon.net` отдаёт из Latest-релиза — сервер и админка не нужны:
опубликовали релиз → обновление появилось.

`https://download.iperon.net/android/latest.json` (asset `android-latest.json`):

```json
{
  "version": "0.0.591",
  "build": 59101,
  "publishedAt": "2026-10-31T10:50:00Z",
  "apks": {
    "arm64-v8a":   {"url": "https://download.iperon.net/android/Iperon-0.0.591-arm64-v8a.apk",   "size": 66844534, "sha256": "…"},
    "armeabi-v7a": {"url": "…", "size": 60125682, "sha256": "…"},
    "x86_64":      {"url": "…", "size": 73906018, "sha256": "…"}
  }
}
```

`https://download.iperon.net/ios/latest.json` (asset `ios-latest.json`): `version`, `build`,
`publishedAt`. Пишется **после** загрузки в TestFlight; билд ещё обрабатывается Apple
(минуты–полчаса), поэтому клиент показывает баннер не раньше `publishedAt + 1 ч`.

- Сравнение — по `build` (номер сборки), не по строке версии.
- Подпись манифеста не нужна: Android не поставит обновление с другой подписью поверх
  установленного, а `sha256` защищает от битой загрузки. HTTPS — обязательно.
- Не latest-релизы (pre-release) в манифест не попадают — nginx берёт файл из Latest.
- Кэш nginx для `latest.json` — короткий (5 мин), как у appcast.

## 5. Установка APK из приложения (канал APK)

- **Разрешение `REQUEST_INSTALL_PACKAGES`** — Google Play запрещает его мессенджерам. Поэтому
  две сборки (product flavors в `android/app/build.gradle.kts`):
  - `play` — без разрешения, обновление только через Play;
  - `direct` — с разрешением, для GitHub / сайта / RuStore (RuStore разрешение допускает —
    проверить при подключении).

  Один `applicationId`, одна подпись, общий номер сборки — переход между ними без удаления.
  CI: `flutter build apk --flavor direct --split-per-abi` для релиза, позже
  `flutter build appbundle --flavor play` для Play.
- Поток: проверка `latest.json` → баннер → «Обновить» → загрузка APK своего ABI
  (`Build.SUPPORTED_ABIS[0]`) в кэш с прогрессом в баннере → проверка `sha256` →
  `PackageInstaller` session (или `ACTION_VIEW` + `FileProvider`, уже есть
  `MediaFileProvider`) → системное окно «Обновить приложение?».
- Android 8+: при первом обновлении система попросит разрешить «Установку неизвестных
  приложений» для Iperon (`Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES`) — показать
  пояснение до перехода в настройки.
- Мобильная сеть: APK ~60–75 МБ — на мобильной сети спрашивать перед загрузкой
  (`connectivity_plus`), на Wi-Fi — сразу.
- Без разрешения (flavor `play` поставлен руками) — запасной путь: открыть ссылку на APK
  в браузере.

## 6. Google Play — решить до первой загрузки

- **Ключ подписи**: при регистрации в Play App Signing выбрать **«использовать свой ключ»**
  и загрузить `iperon-release.jks` (через PEPK). Иначе Google подпишет приложение своим
  ключом, и APK с GitHub и версия из Play станут несовместимы (смена канала только через
  удаление, с потерей данных). Изменить это после первой загрузки нельзя.
- Upload key — отдельный ключ для загрузки AAB (его можно перевыпустить).
- После подключения Play: SHA-256 ключа Play App Signing совпадёт с нашим — `assetlinks.json`,
  Яндекс OAuth и `rpOpaqueOrigins` менять не придётся.
- In-App Updates: плагин `in_app_update`; `flexible` для мягкого баннера, `immediate` —
  для принудительного обновления (вместо ссылки в магазин).
- CI: AAB (`flutter build appbundle --flavor play`) → fastlane `supply` или
  `r0adkll/upload-google-play` в internal track; секрет `PLAY_SERVICE_ACCOUNT_JSON`.

## 7. Баннер (UI)

- Показываем, когда номер сборки ниже последнего в своём канале и экран принудительного
  обновления не показан.
- Где: плашка над списком чатов (как «Подключение…»/архив) — обе платформы, на планшете —
  в левой панели. Текст: «Доступна версия 0.0.N» + «Обновить» / крестик.
- Крестик — «Позже»: прячет для этой версии на 24 ч; новая версия показывает снова.
  Храним в `settingsDevice` (`updateDismissedBuild`, `updateDismissedAt`; миграция —
  `DeviceDatabase.migrations`, не account DB).
- Состояния кнопки для APK / Play: «Обновить» → «Загрузка 42%» → «Установить» /
  «Перезапустить».
- macOS: Sparkle показывает своё окно при автопроверке — баннер не нужен; в «Настройки» →
  «О приложении» — «Проверить обновления» (уже `Desktop.checkForUpdates()`).
- iOS: нативно iOS не даёт ставить из приложения — только ссылка. TestFlight и так шлёт
  пуш о новом билде, поэтому баннер на iOS — для App Store-канала в первую очередь.
- Принудительный экран (`AppUpdateGate`) остаётся, но его кнопка ведёт в свой канал
  (`openAppUpdate()` по §3), а не всегда в Play.
- i18n: секция `appUpdate.*` (en/ru) — баннер, загрузка, ошибки, пояснение про
  «неизвестные приложения», вопрос о мобильной сети.
- Offline: проверка без сети молча пропускается (повтор при `ConnectionCubit` → online и
  раз в 6 ч в foreground); ошибка загрузки — «Не удалось скачать обновление» + «Повторить».

## 8. Код

- `lib/app_update.dart` — `AppUpdates.instance`: канал (MethodChannel), проверка по каналу,
  `ValueNotifier<AppUpdateState>` (нет / доступна версия / загрузка % / готово к установке /
  ошибка), `dismiss()`, `start()`. Не в `get_it` — как `ChatsSync.instance`; запуск из
  `startAccountServices`.
- `lib/components/app_update/` — баннер `app_update_banner_{cupertino,material}.dart`;
  `openAppUpdate()` переезжает на `AppUpdates`.
- Android: `AppUpdateHandler.kt` (источник установки, ABI, загрузка не здесь — в Dart;
  установка через `PackageInstaller`), канал на движке, как `PushChannel`.
- iOS: определение TestFlight в `AppDelegate`/`SceneDelegate` через тот же канал.
- CI: `_deploy_android.yaml` пишет `android-latest.json` (sha256 через `sha256sum`),
  `_deploy_testflight.yaml` — `ios-latest.json` в релиз; nginx — `/android/` и `/ios/`
  по образцу `/macos/`.

## 9. Этапы

1. **Канал + `openAppUpdate()` по каналу.** Определение источника установки (Android, iOS),
   принудительный экран ведёт в свой канал; для APK — ссылка `Iperon-<abi>.apk` в браузере.
   Чинит тупик у тех, кто поставил APK.
2. **Манифест + баннер.** `android-latest.json` / `ios-latest.json` в CI, nginx
   `/android/`, `/ios/`; `AppUpdates` + баннер «Доступна версия» с «Позже»; кнопка — ссылка
   (как этап 1).
3. **Flavors `play` / `direct` + установка APK из приложения.** Загрузка с прогрессом,
   sha256, `PackageInstaller`, пояснение про неизвестные источники, вопрос о мобильной сети.
4. **Google Play.** Регистрация со своим ключом (§6), AAB в CI, internal track, In-App
   Updates (flexible + immediate для принудительного).
5. **RuStore** (если решим) — SDK обновлений, свой канал.

## 10. Открытые вопросы

- Тихий период: показывать баннер не сразу, а через N часов после релиза (успеть отозвать
  сырую сборку)? Можно полем `notBefore` в манифесте или правилом в клиенте.
- Отзыв релиза: если версию сняли — достаточно вернуть Latest на прошлый релиз (манифест
  снова старый), или нужен серверный стоп-кран (`ClientConfig.updatesPaused`)?
- Передавать канал установки на сервер (статистика) — да / нет.
- RuStore — нужен ли вообще и когда.
- App Store: когда приложение появится в App Store, TestFlight-сборки и App Store-сборки
  будут с одним номером — нужен ли баннер TestFlight-тестерам о версии из App Store
  (нет — разные каналы).
