# Десктопный клиент (macOS / Windows / Linux) — исследование

Статус: 2026-10-18 — исследование, разработка не начата.

## 1. Вывод

**Делать в этом же репозитории и в этом же Flutter-приложении** — добавить таргеты
`macos/`, `windows/`, `linux/`, а не заводить отдельный репозиторий.

Почему:
- Почти вся логика — чистый Dart и переносится без изменений: gRPC/стрим (`api.dart`),
  крипта (`lib/crypto/`, включая ML-KEM `pqcrypto` и секретные чаты), SQLite-кэш
  (`lib/repositories/`), синхронизация чатов (`lib/chats/`), кубиты, модели, i18n, proto.
  Это ~58 тыс. строк из ~85 тыс. (без сгенерированного); экраны — ~12 тыс. (Material)
  + ~14 тыс. (Cupertino).
- Отдельный репозиторий = либо копия этих 58 тыс. строк (и вечная синхронизация, как
  сейчас с `.proto` между клиентом и сервером), либо всё равно выносить их в общий
  пакет — то есть монорепо, только сложнее.
- Плагин без десктопной реализации не ломает сборку: он просто не регистрируется на
  этой платформе, падает только вызов (`MissingPluginException`). Значит, мобильные
  зависимости можно оставить, а вызовы — закрыть проверкой платформы.

Когда пересмотреть: если десктоп разойдётся с мобильным UI настолько, что общими
останутся только данные, — вынести ядро в пакет (`packages/iperon_core` через pub
workspaces) и сделать два приложения в одном репозитории. Начинать с этого не нужно.

## 2. Совместимость зависимостей

Платформы — из `flutter.plugin.platforms` установленных версий (pubspec.lock).

**Чистый Dart — работают везде:** material_ui, cupertino_ui, flutter_bloc/bloc, get_it,
go_router, slang, dart_mappable, grpc, protobuf, cryptography, pqcrypto, ristretto255,
dlibphonenumber, talker*, flutter_svg, lottie, animated_emoji, hugeicons,
font_awesome_flutter, flutter_boring_avatars, thumbhash, settings_ui, skeletonizer,
flutter_slidable, flutter_screen_lock, pin_code_fields, intl, objectid, sqlite_async.
SQLite с шифрованием — `sqlite3` 3.x через hooks (`source: sqlite3mc`, см. `hooks:` в
pubspec.yaml) собирается и на десктопе (нужен компилятор в CI).

**Есть macOS + Windows + Linux:** path_provider, flutter_secure_storage (Linux —
libsecret), share_plus, package_info_plus, device_info_plus, connectivity_plus,
audioplayers, wakelock_plus, url_launcher, image_picker (через file_selector — только
выбор файла), file_picker, record, emoji_picker_flutter, flutter_webrtc,
livekit_client.

**Частично:**
| Пакет | Десктоп | Что делать |
|---|---|---|
| firebase_core / firebase_remote_config | macOS, Windows (Windows у FlutterFire — «для разработки»), **Linux нет** | Конфиг на десктопе — из дефолтов + `.env`, позже с сервера; `Firebase.initializeApp` — только где есть |
| firebase_crashlytics | только macOS | На Windows/Linux — Sentry (или свой сбор логов) |
| firebase_messaging, firebase_app_installations | только macOS | Десктопу пуши не нужны: приложение живёт в трее со стримом, уведомления — локальные |
| local_auth | macOS, Windows | Разблокировка код-пароля Touch ID / Windows Hello; Linux — только PIN |
| passkeys | macOS, Windows | Вход по ключу там же; Linux — без него |
| permission_handler | Windows | На десктопе разрешения почти не нужны — обходить вызовы |
| flutter_contacts | macOS | Адресной книги на десктопе по сути нет — контакты только облачные (`isCloud`) |
| photo_manager | macOS | Не нужен — выбор файлов через file_picker / drag-and-drop |
| video_player | macOS | Windows/Linux — `media_kit` (или `video_player_win`) |
| flutter_image_compress | macOS | Windows/Linux — пакет `image` (чистый Dart) в изоляте |
| cryptography_flutter | macOS | На остальных — чистый Dart `cryptography` (медленнее, но работает) |

**Нет на десктопе:** flutter_callkit_incoming (CallKit/ConnectionService),
native_workmanager, yandex_login_sdk, camera (только мобильные+web), image_cropper,
screen_protector (наш форк — android/ios).

**Свои нативные каналы** (`MethodChannel`), которым нужны десктопные реализации или
заглушки: `push`, `call_window`, `call_audio`, `system_call`, `audio_devices`,
`call_pip` / `call_pip_ios`, `audio_route_ios`, `device_performance`,
`system_gestures`, `video` (сжатие видео), `files` (сохранить / открыть / буфер).

## 3. Что придётся сделать именно для десктопа

1. **Платформенный слой.** `lib/platform.dart` с возможностями (`hasCallKit`,
   `hasPush`, `hasAddressBook`, `hasCamera`, `isDesktop`…) вместо разбросанных
   `Platform.isIOS / isAndroid` (их 85). В DI (`lib/di.dart`) — регистрировать
   десктопные реализации (уведомления, звонки) вместо мобильных. `main.dart`:
   Crashlytics / Firebase / PushManager / CallPush — только где есть.
2. **UI.** Брать Material-экраны (на десктопе сейчас и так выберется Material — ветка
   «не iOS») и сделать их адаптивными, а не писать третий вариант:
   - две панели при широком окне (список чатов + чат; ShellRoute в `routers.dart`);
   - правый клик = контекстное меню, наведение мышью, полосы прокрутки;
   - горячие клавиши (Enter — отправить, Shift+Enter — перенос, Ctrl/⌘+K — поиск,
     Esc, ↑ — редактировать последнее);
   - drag-and-drop файлов в чат, вставка картинок из буфера;
   - окно: размер/положение (`window_manager`), трей (`tray_manager`), бейдж
     непрочитанных (Dock / иконка на панели задач), автозапуск.
3. **Уведомления.** Пушей нет — приложение держит стрим, пока запущено (в трее).
   Новые сообщения из стрима → `flutter_local_notifications` (macOS, Windows, Linux).
   Сервер уже не шлёт пуш онлайн-сессии (presence) — телефон при этом пуш получит.
4. **Вход.** Звонок-пароль работает как есть. Добавить **вход по QR с телефона** (как
   Telegram Desktop): десктоп показывает QR → телефон подтверждает → сервер выдаёт
   сессию. Это новая серверная ручка. Яндекс ID — через браузер (OAuth + возврат
   по ссылке), passkeys — macOS/Windows.
5. **Звонки.** LiveKit на десктопе есть. Вместо CallKit — своё окно входящего и
   системное уведомление со звуком; выбор микрофона/камеры/динамика; демонстрация
   экрана на десктопе естественнее (её реализовывали и откатили 2026-09-24 — revert dd334ce).
6. **Медиа.** Сжатие фото — `image`, видео — без сжатия на первом шаге (или ffmpeg),
   просмотр видео — `media_kit` на Windows/Linux, обрезка аватара — чистый Dart
   (`crop_your_image`).
7. **Секретные чаты.** Решить: Telegram Desktop их не поддерживает. Технически у нас
   крипта на чистом Dart, десктоп — просто ещё одно устройство (`capabilities`),
   так что поддержать можно. Защита от скриншотов — `NSWindow.sharingType = .none`
   (macOS), `SetWindowDisplayAffinity` (Windows), на Linux нет.
8. **Хранение.** Ключ БД — Keychain (macOS, нужны entitlements), DPAPI (Windows),
   libsecret (Linux). Пути в БД — только относительные (iOS меняет путь к контейнеру при обновлении —
   то же правило для десктопа).
9. **Сборка и выпуск.** macOS — подпись + нотаризация, DMG (и/или Mac App Store);
   Windows — MSIX или установщик + сертификат подписи; Linux — deb/AppImage/Flatpak.
   Автообновление — `auto_updater` (Sparkle / WinSparkle). CI — отдельные задания
   на macOS / Windows / Linux раннерах (сейчас CI только iOS).

## 4. Сервер

- Вход по QR (новая пара ручек: создать токен входа → подтвердить с телефона → выдать
  сессию десктопу через стрим).
- Платформа/тип устройства в сессии (для «Устройств» и решений о пушах).
- Остальное (стрим, presence, чаты, звонки, секретные чаты) — без изменений.

## 5. Этапы

0. Спайк (1–2 дня): включить macOS, сделать так, чтобы приложение запустилось
   (обойти Firebase/Push/CallKit/WorkManager), вход по звонку, список чатов и чат.
   Оценить, что сломалось.
1. Платформенный слой + DI + `main.dart`, конфиг без Firebase, сбор крэшей.
2. Адаптивный Material: две панели, мышь, клавиатура, drag-and-drop, окно/трей.
3. Локальные уведомления из стрима, бейдж, автозапуск.
4. Вход по QR (сервер + клиент).
5. Медиа (сжатие, видео-плеер, обрезка) и звонки (окно входящего, устройства).
6. Windows, затем Linux; упаковка, подпись, автообновление, CI.

Порядок платформ: macOS → Windows → Linux (у macOS больше всего плагинов и Firebase).

## 6. Открытые вопросы

- Секретные чаты на десктопе — да/нет (§3.7).
- macOS — Material или отдельная «маковая» стилистика (`macos_ui`)? Рекомендация —
  Material, как Telegram Desktop (у него один вид на всех ОС).
- Mac App Store или только сайт (песочница App Store ограничивает трей/автозапуск).
- Крэши на Windows/Linux — Sentry (внешний сервис) или свой сбор.
