# 03-vk-id-login — Вход через VK ID

**Статус:** in progress (2026-11-25)

## Цель

Добавить на экран входа способ «Войти через VK ID» (iOS/Android): пользователь
авторизуется через VK ID, сервер подтверждает номер телефона из VK-аккаунта и
находит/создаёт пользователя — дальше стандартный флоу (облачный пароль при
двухшаговой верификации → сессия через `AuthLoginCompleter`). Запрашивается
только номер телефона (scope `phone`); имя, аватар и прочие данные VK не
используются и не сохраняются. Реализация по образцу входа через Яндекс.

## Принятые решения

- **Шаблон — Яндекс-вход** (`AuthCubit.yandexSignIn` в
  `lib/cubit/auth/auth_cubit.dart`, `internal/services/auth_yandex.go` на
  сервере): клиент получает токен через SDK → unary `AUTH_VK` → сервер сам
  проверяет токен в VK API, извлекает телефон, ищет/создаёт пользователя →
  `confirmationSession` → опционально облачный пароль → общий финал.
  Альтернатива отклонена: отдельный протокол логина вместо встраивания в
  существующий — нет смысла, весь финал (ML-DSA handshake, сессия) общается
  через `AuthLoginCompleter`.
- **Прото**: новый `protos/vk_v1.proto` по образцу `yandex_v1.proto`
  (`AuthVK.Request{token, clientId}` / `.Response{confirmationSession,
  hasTwoStepVerification}`) — клиент шлёт свой client_id вместе с токеном,
  потому что у платформ VK ID разные client_id (см. ниже); новый
  `MessageType AUTH_VK = 113` в `v1.proto` (номер свободен, после
  `ACCOUNT_ACTIVITY = 112`). `client_config_v1.proto` не трогаем.
  Протосы копируются в серверный репозиторий; серверные изменения катятся
  раньше клиентских.
- **Сервер** (`internal/services/auth_vk.go`): `POST https://id.vk.ru/oauth2/user_info`
  (парa `clientId` из запроса + `access_token`) → проверка, что `clientId`
  входит в разрешённый список (`OAuth.Vk.ClientIDs`: iOS + Android) и пара
  валидна — VK отклонит `user_info`, если токен выдан не этому client_id →
  извлечение `phone` (при scope `phone`) → нормализация номера →
  поиск/создание пользователя → `LoginMethod: loginMethodVk` →
  `confirmationSession` в Redis (`authConfirmation`, TTL как у Яндекса).
  Sentinel-ошибки (телефон не выдан, чужой client_id, VK-ошибка) → gRPC-коды с
  i18n-ключами по образцу `yandexError` в `internal/api/v1.go`.
  Альтернатива отклонена: обмен кода на токен внутри клиентского unary —
  кодVerifier и state живут в SDK, серверу от клиента нужен только токен.
- **Конфиг сервера**: `OAuth.Vk.{ClientIDs, UserInfoURL}` в
  `internal/settings/settings.go` + `iperon.yaml` (по образцу
  `OAuth.Yandex.{ClientID, InfoURL}`, но список — iOS + Android).
- **Клиент**: кнопка VK в секции «Войти через» (`auth_cupertino.dart` /
  `auth_material.dart`, синхронно), `enum _SignInProvider.vk`,
  `AuthCubit.vkSignIn()` — гард сети, обёртка `VkSdk` в `auth_sdk.dart` по
  образцу `YandexSdk` (интерфейс + нативная реализация, для тестов — мок),
  unary `AUTH_VK`, далее ветка Яндекса (двухшаговая верификация →
  `/auth/cloud_password`, иначе `AuthLoginCompleter`).
- **Зависимость**: официальный `vkid_flutter_sdk` (v1.0.3, обёртка нативных
  VK SDK iOS/Android). Требует нативных настроек: iOS — `VK_APP_CLIENT_ID`/
  `VK_APP_CLIENT_SECRET` в Info.plist, `LSApplicationQueriesSchemes:
  vkauthorize-silent`, URL-схема `vk{appID}`, universal link + Associated
  Domains; Android — manifest placeholders `VKIDClientID`/`VKIDClientSecret`/
  `VKIDRedirectHost`/`VKIDRedirectScheme` (их gradle-плагин
  `vkid.manifest.placeholders` не нужен — значения задаёт
  `android/app/build.gradle.kts`). Альтернатива отклонена: свой флоу через
  системный браузер — больше кода и нет быстрого входа через приложение VK.
  `vk_id_auth2` (сторонний) — не рассматривался как основной из-за
  неофициальности.
- **Форк в `third_party/vkid_flutter_sdk`** (пакет заносится целиком, как
  `flutter_callkit_incoming`, `cryptography_flutter`, `screen_protector` —
  `dependency_overrides`); исходники сверены с pub.dev 1.0.3 (sha256 архива).
  Полный список патч — в шапке `third_party/vkid_flutter_sdk/pubspec.yaml`:
  - Maven-репозиторий VK `artifactory-external.vkpartner.ru` →
    `nexus-external.vkteam.ru`: старый артефакты SDK больше не отдаёт (404).
    Это единственный патч, без которого сборка не проходит;
  - guard для KGP и JVM target через `kotlin { compilerOptions }` — как в
    остальных форках. Первоначальная посылка «ванильный 1.0.3 не собирается с
    AGP 9 built-in Kotlin» для нашей конфигурации не подтвердилась: пока у
    приложения `android.builtInKotlin=false`, ванильный пакет тоже собирается
    (проверено сборкой 25.11); guard нужен на случай включения built-in Kotlin
    (VKCOM/vkid-android-sdk#120);
  - метод канала `clientId` на обеих платформах — client_id сборки;
  - на iOS ошибка авторизации отдаётся `FlutterError` с кодом, как на Android:
    апстрим возвращал строку, и отмена входа превращалась в
    `AuthOtherError("unknown error")`.
  Предполагавшиеся R8 `-dontwarn` для `ru.ok.tracer.base.*` /
  `javax.inject.Inject` не понадобились — R8 на них не жаловался. Альтернативы
  отклонены: git-зависимость от community-зеркала (неофициальное, 0 звёзд,
  может исчезнуть) и `android.builtInKotlin=false` на весь проект (остальные
  плагины уже переехали на built-in Kotlin).
- **Тип приложения**: публичное — SDK сам обменивает код на access_token на
  устройстве и отдаёт его клиенту; сервер не хранит VK-токены и не делает
  обмен. Риск IP-привязки токена закрывается спайком (шаг 1). Альтернатива
  (конфиденциальное приложение, обмен кода на сервере, service_token +
  IP allowlist, лимит 120k/день) — если спайк провалится (шаг 1).
- **Два client_id — iOS и Android** (наблюдение пользователя из кабинета: у
  платформ де-факто разные client_id) — client_id и client_secret каждой
  платформы вшиваются в нативную конфигурацию соответствующей сборки (iOS —
  Info.plist `VK_APP_CLIENT_ID`/`VK_APP_CLIENT_SECRET`, Android — manifest
  placeholders); SDK читает их нативно. Dart узнаёт client_id у плагина (метод
  канала `clientId`, добавлен в форке): по нему решается, настроен ли VK в
  сборке (кнопки нет, если нет client_id или секрета), и он уходит серверу в
  `AuthVK.Request`. Поле в `ClientConfig` не нужно. Значения лежат вне git: iOS —
  `ios/Flutter/VKIDCredentials.xcconfig`, Android — `android/vkid.properties`;
  на CI оба файла пишут деплой-workflow из секретов `vkid_ios_client_id` /
  `vkid_ios_client_secret` и `vkid_android_client_id` /
  `vkid_android_client_secret` (без секретов сборка проходит, но без входа
  через VK — с предупреждением в логе). staging и production одной платформы
  делят один client_id. Альтернатива отклонена: `vk_client_id` через
  `ClientConfig` — сервер не знает платформу запрашивающего, а SDK в любом
  случае требует нативную конфигурацию при сборке.
- **Universal link `https://iperon.net/auth/vk-id`** (решение пользователя) —
  AASA `https://iperon.net/.well-known/apple-app-site-association` уже
  развёрнута (личные чаты `iperon.net/<имя>`); в её `components` добавляется
  один компонент `{"/": "/auth/vk-id", "comment": "VK ID: возврат из
  авторизации"}` — строго до exclude `/*/*` (двухсегментный путь иначе
  поймается этим exclude; компоненты оцениваются сверху вниз). Query-ключ не
  указываем — матчатся любые параметры (`code`, `state` от VK). Entitlements
  уже содержат `applinks:iperon.net` (release и debug) — менять их не нужно.
  На сайте страницы `/auth/vk-id` нет (VK требует «не занятый вебом» link);
  404 без установленного приложения — норма. Android в AASA не нуждается:
  возврат по схеме `vk{appID}://`, владение проверяется SHA-1 в кабинете VK.
  Альтернативы отклонены: staging.iperon.net (AASA пришлось бы отдавать с
  Go-сервера или прокси перед ним) и отдельный домен (лишняя инфраструктура
  без выгоды).
- **client_secret на клиенте**: требование VK SDK для мобильного флоу — так
  устроен официальный SDK; приложение публичное.
- **Платформы**: кнопка VK только на iOS/Android (`AppPlatform`); на macOS
  не показывается — Flutter SDK не поддерживает macOS.
- **VK-токен разовый**: используется сервером только для подтверждения номера,
  нигде не сохраняется (клиентом и сервером) — как у Яндекса; контракт
  фиксируется комментарием в `vk_v1.proto`. VK ID-идентификаторы пользователей
  не сохраняются.
- **i18n**: новые ключи ошибок по образцу `yandex.*` (`vk.phoneMissing` и т.п.)
  в `lib/i18n/en.i18n.yaml` + `ru.i18n.yaml`.
- **Тестовые аккаунты staging не затрагиваются**: VK-вход не зависит от
  fixedCode/звонков, подтверждение номера идёт от VK.
- **НЕ делаем в этом этапе**: хранение VK refresh token и фоновое обновление,
  виджет «3 в 1»/One Tap-кнопки SDK (просто кнопка в списке способов входа),
  вход через OK/Mail (входит в SDK, но не включаем), веб/macOS-авторизация,
  отправка VK-данных профиля в мессенджер.
- **Найдено при реализации (25.11)**: способ входа зашит на сервере не только в
  сервисе входа, поэтому VK добавлен и туда: `MessageSystemNotice.LoginMethod.VK
  = 5` (`chats_v1.proto`; уведомление «новый вход» на других устройствах →
  клиентский `systemNotice.methodVk`), `models.UserPhoneVerificationSourceVk
  = 4` (источник подтверждения номера в `users`, подпись в админке
  `users.source.vk`), `loginMethodVk = "vk"` (журнал по Яровой, метрики);
  регион номера как у Яндекса — любой валидный (`phoneAllowedForSource`).
- **Ошибки VK на сервере (25.11, проверено запросами)**: VK присылает ошибки с
  HTTP 200 в поле `error`, причём в двух видах — OAuth-код строкой
  (`invalid_token`, `invalid_request`) или объект API-ошибки (HTTP 404,
  `error_code`), — сервер смотрит на поле, а не на статус. Вина клиента только
  у `invalid_token` (→ `vk.invalidToken`); прочее (`invalid_request`, 404,
  5xx, не-JSON) — сбой на нашей стороне или в VK → `vk.unavailable` и ошибка в
  логе. Чужой `clientId` отсекается на сервере без запроса к VK. Телефон без
  доступа «Номер телефона» приходит замаскированным (`*******0044`) →
  `vk.phoneMissing`.
- **Порядок выхода из SDK (25.11, проверено на живом токене)**: `logout()` VK SDK
  — не очистка локального кэша, как `signOut()` у Яндекса, а запрос
  `POST id.vk.ru/oauth2/logout`, который отзывает токены: после него
  `user_info` отвечает `invalid_token`, refresh — `invalid_grant`. Поэтому
  клиент выходит из SDK только **после** ответа `AUTH_VK` (в `finally`), а не
  сразу после получения токена — иначе сервер не успел бы подтвердить номер.
  Токены спайка (`/tmp/vk-spike/token_phone.json`) этой проверкой отозваны.
- **Возврат в приложение на iOS — `SceneDelegate`**, а не `AppDelegate`: в
  scene-based приложении ссылки приходят туда (там же уже обрабатывается
  Яндекс). Два пути: схема `vk{client_id}://…` и Universal Link
  `https://iperon.net/auth/vk-id` (по нему приложение VK возвращает после
  быстрой авторизации — подтверждено исходниками vkid-ios-sdk 2.9.2,
  `AuthByProviderFlow`).
- **Coil 2.6 в приложении (25.11)**: VK ID SDK тянет `io.coil-kt:coil:2.6.0`,
  и он вытесняет coil 1.4 из classpath — в debug это молча ломало бы загрузку
  аватаров форком `flutter_callkit_incoming` (написан под API Coil 1), release
  падал на R8 (`coil.bitmap.BitmapPool`). Форк callkit переведён на API Coil 2
  (`CircleTransform`, `SafeTarget`, зависимость 2.6.0) — аватары входящего
  звонка и уведомления проверить на устройстве.
- **Репозиторий VK в Gradle — с фильтром групп** `com.vk.*` и `ru.ok.tracer`
  (зависимость `tracking-tracer`), чтобы Nexus VK не отвечал на запросы чужих
  библиотек.

## Шаги

- [x] 1. Спайк (без коммита): настроить VK-приложение в кабинете Business ID
  (iOS/Android-платформы, universal link `https://iperon.net/auth/vk-id`,
  SHA-1 подписи debug/release); в существующую AASA на iperon.net добавить
  компонент `/auth/vk-id` до exclude `/*/*`; включить scope `phone`;
  curl-проверка `POST https://id.vk.ru/oauth2/user_info`
  с токеном, выданным SDK-флоу, — телефон приходит и вызов работает с
  серверного IP. При провале — переключение на конфиденциальное приложение
  (обмен кода на сервере).
  Прогресс (21.11): AASA обновлена и проверена (`/auth/vk-id` открыт
  приложению, веб-страницы нет — 404); модерация доступов пройдена —
  «Номер телефона» в конфиге приложения, `scope=phone` в authorize принят.
  client_id: iOS `54898052` (universal link `https://iperon.net/auth/vk-id`,
  публичное, включено), Android `54898051` (package `net.iperon.messenger`,
  публичное, включено), Web `54912015` (базовый домен `iperon.net`,
  доверенный redirect `https://iperon.net/auth/vk-id` — тестовый канал
  web-authorize для спайка; в кабинете каждая платформа = отдельное
  приложение со своим client_id). Web-authorize для `54912015`: HTTP 302,
  redirect и `scope=phone` приняты; для iOS/Android client_id web-authorize
  https-redirect не признаёт — там флоу SDK со схемой `vk{appID}://`
  (проверено: 302). Серверный список валидации в этапе — iOS + Android. Диагностика вердикта:
  curl HTML `id.vk.ru/authorize`, поле `"auth_error":{"message":...}`.
  Найдено: web-authorize принимает схему `vk54898052://vk.ru/blank.html`
  (HTTP 302 — флоу SDK), но НЕ https-universal-link — iOS universal link
  web-authorize не признаётся, нужна Web-платформа у приложения
  (базовый домен `iperon.net`, доверенный redirect `https://iperon.net/auth/vk-id`)
  — иначе ручная curl-проверка user_info невозможна (код из scheme-редиректа
  в браузере не перехватить). Browser-логин выполнен (21.11): обмен кода
  прошёл (access/refresh/id_token, `expires_in` 3600), `user_info` вернул
  профиль — но **без телефона**: VK сузил scope до `vkid.personal_info`,
  refresh с `scope=phone` → `invalid_scope`. Причина: расширенный доступ
  «Номер телефона» per-application — у Web-приложения `54912015` он не
  включён; включить в «Доступах» 54912015 и проверить в 54898052/54898051.
  После включения — refresh с `scope=phone` по живому refresh_token →
  `user_info` с немаскированным `phone`; затем e2e-проверка вызова с IP
  staging. Токены/ответы: `/tmp/vk-spike/{token,userinfo}.json` (chmod 600).
  PKCE-материал: `/tmp/vk-spike/pkce.txt`.
  Проверено (25.11), web-приложение `54912015`: доступ «Номер телефона»
  включён — страница authorize перечисляет `phone` в scopes приложения и не
  сужает `scope=phone`. Права старого refresh_token не расширяются: refresh
  с `scope=phone` → `invalid_scope`, с `vkid.personal_info phone` →
  HTTP 200, но scope снова `vkid.personal_info`; согласие на телефон даётся
  только при авторизации. Повторная авторизация в браузере (PKCE:
  `/tmp/vk-spike/pkce2.txt`): обмен кода → scope `phone vkid.personal_info`,
  `user_info` вернул немаскированный `phone` — 11 цифр с кодом страны,
  без `+` (один пример; учесть в нормализации номера на сервере).
  Замечания для шага 3: VK отвергает токен, выданный другому client_id
  (`invalid_token`) — пару «clientId + токен» проверяет сам VK; ошибки VK
  приходят с HTTP 200 (неизвестный client_id — HTTP 404 с `error`-объектом),
  то есть смотреть надо на поле `error`, а не на статус; для публичных
  приложений лимит 15 000 запросов в сутки на один IP-адрес.
  Токены/ответы: `/tmp/vk-spike/{token_phone,userinfo_phone}.json`
  (chmod 600). Вызов с серверного IP проверен (25.11, пользователь запускал
  с хоста `alica`): `user_info` с тем же токеном → HTTP 200, `phone` на
  месте — токен к IP клиента не привязан, публичное приложение подтверждено.
  Доступ `phone` включён и у iOS `54898052` / Android `54898051` (страница
  authorize перечисляет `phone` в scopes обоих). Не проверено: токен
  SDK-флоу — его получится получить только после нативной интеграции
  (шаг 4).
  SHA-1 в кабинете Android (25.11): в поле «SHA-1 хеш подписи приложения»
  стояли отпечатки SHA-256 (32 байта), а VK сверяет SHA-1 (20 байтов,
  `gradle signingReport`). Заменены на SHA-1 (скриншот кабинета от
  пользователя): debug (этот Mac,
  `~/.android/debug.keystore`)
  `90:4C:5E:1C:F6:DC:45:AD:F7:B0:6A:10:4F:36:30:31:98:2A:EE:E8`; release
  (`iperon-release.jks`, снят с APK v0.0.666)
  `BD:FF:BF:A7:CD:80:54:43:55:79:9B:4A:34:E8:C3:0C:52:E8:A3:A3`. Убранный
  оттуда отпечаток `95:63:5C:…` перенесён из кабинета Яндекс OAuth и не
  подписывает ни одну сборку на этом Mac — вероятно, старый ключ
  (`~/iperon-keystore.jks`). В Яндексе оба значения корректны: его кабинет
  сверяет SHA-256 («SHA256 Fingerprints»), VK — SHA-1.
  Итог (25.11): спайк пройден на токене web-приложения `54912015` — телефон
  приходит, вызов с серверного IP работает, доступы и подписи в кабинетах
  настроены. Токен SDK-флоу проверяется на шаге 4, после нативной интеграции.
- [x] 2. Прото (оба репозитория): `vk_v1.proto` (`Request{token, clientId}`),
  `AUTH_VK = 113` в `v1.proto`; регенерация Dart
  (`protoc --dart_out=grpc:lib/protobuf`, `dart format lib/protobuf`) и Go
  (`task gen` сервера по затронутым прото). Коммит сервера раньше клиента.
  Сделано 25.11 (коммиты `2626218` — сервер, `a4b3117` — клиент). Сверх
  плана: в `chats_v1.proto` у
  `MessageSystemNotice.LoginMethod` добавлен `VK = 5` — иначе способ входа в
  уведомлении «новый вход» на других устройствах показывался бы неизвестным.
  Go на сервере сгенерирован точечно (`protoc --go_out=. --go-grpc_out=.` по
  `vk_v1.proto`, `v1.proto`, `chats_v1.proto` с закреплёнными в `Taskfile`
  плагинами из `bin/`), а не `task gen` по всем прото: полный прогон меняет
  шапку `protoc v5.29.3` → `v7.36.2` ещё в 9 нетронутых файлах. На этом Mac
  генератор Dart обновился 17.11 (protoc_plugin 22 → 25), поэтому в
  перегенерированных `v1.pb.dart` / `v1.pbjson.dart` кроме `AUTH_VK` появились
  класс `IperonApi` и дескриптор сервиса — штатный вывод нового генератора под
  `protobuf` 6.1.0.
- [x] 3. Сервер: `OAuth.Vk.{ClientIDs, UserInfoURL}` в `settings.go` +
  `iperon.yaml`, `internal/services/auth_vk.go` (user_info с парой
  clientId+токен, телефон, поиск/создание пользователя, sentinel-ошибки),
  диспетчер `AUTH_VK` и маппер ошибок в `internal/api/v1.go`; go-тесты
  `auth_vk` (мок user_info: телефон есть / нет / чужая пара client_id+токен);
  `go build ./...`, `go vet ./...`, `go test ./...`, `golangci-lint run ./...`.
  Сделано 25.11 (коммиты, сервер: `ff45214` — сервис, `c078d3f` — тесты):
  `internal/services/auth_vk.go`
  (`ServiceAuth.VKLogin`), `OAuth.Vk` в `settings.go` (в локальном
  `iperon.yaml` дописан блок `oauth.vk.clientIds`; в конфиге staging тот же
  блок добавил пользователь 25.11 — начнёт действовать только после выкатки
  сервера: текущая версия неизвестные ключи игнорирует), `AUTH_VK` и `vkError`
  в `internal/api/v1.go`,
  `VKLogin` в `interfaces.go`, источник `UserPhoneVerificationSourceVk`,
  `loginMethodVk`, подпись в админке `users.source.vk`, справка в
  `internal/services/AGENTS.md`. Тесты `auth_vk_test.go`: новый и существующий
  пользователь, оба client_id, зарубежный номер, чужой client_id (VK не
  спрашивается), замаскированный телефон, ошибки VK во всех видах, не
  настроен; плюс случаи VK в `TestPhoneAllowedForSource` и
  `TestNoticeLoginMethod`. Проверки зелёные: `go build ./...`, `go vet ./...`,
  `go test ./...` (20 пакетов), `golangci-lint` (0 замечаний).
- [x] 4. Клиент, нативная интеграция: форк `vkid_flutter_sdk` 1.0.3 в
  `third_party/` (диф против pub.dev + AGP 9-патч, репозиторий nexus,
  R8-правила) + `dependency_overrides`; iOS (Info.plist, entitlements
  Associated Domains, AppDelegate `open url`), Android (settings/build.gradle:
  репозиторий + плагин placeholders), `VkSdk`/`NativeVkSdk` в
  `lib/cubit/auth/auth_sdk.dart`, `vkOauthClientID`/`vkOauthClientSecret` в
  `lib/settings.dart`; проверка debug/release сборки Android с AGP 9.
  По ходу шага схема изменилась — актуальные решения в «Принятых решениях»:
  возврат на iOS принимает `SceneDelegate`, значения лежат в нативной
  конфигурации сборки (а не в `lib/settings.dart`), плагин
  `vkid.manifest.placeholders` не нужен.
  Сделано 25.11 (коммиты, клиент: `37b8bfd` — callkit на Coil 2, `59e1e7f` —
  форк SDK, `4c50292` — нативная интеграция). Форк `third_party/vkid_flutter_sdk`
  (патчи — в его шапке). iOS: `VK_APP_CLIENT_ID`/`VK_APP_CLIENT_SECRET`,
  схема `vk$(VK_APP_CLIENT_ID)` и `vkauthorize-silent` в `Info.plist`; ключи —
  из `ios/Flutter/VKIDCredentials.xcconfig` (gitignored, `#include?` в
  `Debug.xcconfig`/`Release.xcconfig`); возвраты в приложение —
  `ios/Runner/SceneDelegate.swift`. Android: репозиторий VK в
  `android/build.gradle.kts`, плейсхолдеры из `android/vkid.properties`
  (gitignored) в `android/app/build.gradle.kts`. Dart: `VkSdk`/`NativeVkSdk`
  в `auth_sdk.dart`, зависимость и override в `pubspec.yaml`. CI: шаг «Restore
  VK ID credentials» в `_deploy_android.yaml` и `_deploy_testflight.yaml`.
  Сборки 25.11 проходят: Android debug и release (R8), iOS release без
  подписи. Через SPM подтянулся vkid-ios-sdk 2.9.5 (в podspec плагина 2.9.2;
  2.9.4–2.9.5 — технические релизы без изменения API, 3.0.0 не подтянется).
  Не проверено на устройстве: сам вход через VK (нужны client_secret обоих
  приложений из кабинета VK ID) и аватары входящего звонка/уведомления после
  перехода callkit на Coil 2.
- [x] 5. Клиент, флоу: `AuthCubit.vkSignIn()` (гард сети, отмены SDK,
  `AUTH_VK`, ветка двухшаговой верификации / `AuthLoginCompleter`), кнопка VK
  в `auth_cupertino.dart`/`auth_material.dart` (`_SignInProvider.vk`,
  занятость `signInBusy`, скрытие на macOS), i18n-ключи `vk.*`.
  Сделано 25.11 (commit `5c44be5` — клиент): `AuthCubit.vkSignIn()` и
  `vkSignInAvailable()`; кнопка VK — третьей в ряду «Войти через» в обоих
  экранах, с семантической меткой «Войти через VK ID»; ключи `vk.*`,
  `systemNotice.methodVk`, `screenAuth.signInWithVk`; способ входа VK в
  `chats_mapping.dart`. Ключевое отличие от Яндекса — `logout()` SDK в
  `finally` после ответа сервера (см. «Порядок выхода из SDK»). Скрытие на
  macOS — без явного `AppPlatform`: там нет плагина, и `clientId()` возвращает
  пустую строку.
- [x] 6. Клиент, тесты: юнит-тесты `AuthCubit.vkSignIn` (сеть недоступна /
  отмена пользователем / ошибка сервера / успех → финал), `AppLocale.ru.build()`
  в `setUpAll`; серверные тесты из шага 3 зелёные на CI.
  Сделано 25.11 (commit `78f32a5` — клиент): в `test/auth/auth_cubit_test.dart`
  — `FakeVkSdk` и 9
  случаев `vkSignIn`/`vkSignInAvailable` (offline, VK не настроен, отмена,
  ошибка SDK, пустой токен, ошибка сервера, успех с двухшаговой проверкой;
  logout — ровно один и строго после запроса к серверу); в
  `test/chats/system_notices_test.dart` — способ входа VK в уведомлении.
  Серверные тесты зелёные и на CI (пуш 25.11, workflow Staging).
- [x] 7. Прекоммиты (`dart format lib`, `flutter analyze`, `flutter test`),
  регенерация `INDEX.md` перед docs-коммитами.
  Сделано 25.11: `dart format lib test` — без изменений, `flutter analyze` —
  чисто, `flutter test` — 1515 пройдены, 5 skipped; `INDEX.md` перегенерирован.
  Коммиты — по шагам выше; шаги CI — `c9728df` (клиент). Запушено 25.11 —
  сервер, затем клиент; CI в обоих репозиториях зелёный.

## Тестирование

- [🤖] `dart format lib` (без изменений), `flutter analyze` — чисто,
  `flutter test` — зелёные (+1515, 5 skipped, 2026-11-25).
- [🤖] Сборки с VK SDK (2026-11-25): Android debug и release (R8), iOS release
  без подписи, macOS debug.
- [🤖] Юнит-тесты (2026-11-25): клиентский `AuthCubit.vkSignIn` (все ветки,
  включая «logout строго после запроса к серверу»), способ входа VK в
  уведомлении «новый вход»; серверные go-тесты `auth_vk` (мок user_info).
  Сервер: `go build ./...`, `go vet ./...`, `go test ./...` (20 пакетов),
  `golangci-lint` — 0 замечаний.
- [🤖] Нативный флоу на эмуляторе Android (2026-11-25), локально с фиктивным
  секретом: без секрета кнопки VK нет, со секретом появляется третьей в ряду
  «Войти через»; по нажатию SDK открывает страницу VK ID «Вход в Iperon»
  (Chrome Custom Tab) — VK принимает client_id `54898051` и схему возврата;
  отмена возвращает на экран входа без ошибки и с разблокированными кнопками,
  повторное нажатие снова открывает VK. Вход в аккаунт не выполнялся.
  На iOS в рантайме не запускался (только сборка).
- [🤖] Staging после выкатки (2026-11-25): `AUTH_VK` с фиктивным токеном
  отвечает `vk.invalidToken` и для client_id из списка (сервер дошёл до VK),
  и для чужого client_id — новая версия сервера и блок `oauth.vk` в конфиге
  staging работают.
- [ ] Ревью качества кода через Kimi (`task review` — `kimi -p`): найденные
  проблемы исправлены или отклонены с обоснованием.
- [ ] Звонки на Android после перехода callkit на Coil 2: аватар вызывающего
  на экране входящего звонка и в уведомлении.
- [ ] e2e (устройства/эмуляторы; `cmd/testpeer` сервера как «второй телефон»):
  нужны настоящие client_secret приложений из кабинета VK ID и конфиг
  `oauth.vk` на staging. iOS и Android — реальный VK-аккаунт с телефоном
  против staging: кнопка VK → авторизация в VK ID (приложение VK / веб-шторка)
  → вход в аккаунт Iperon, привязанный к номеру VK; новый номер → создание
  пользователя; существующий → вход без дубликатов; двухшаговая верификация →
  облачный пароль; offline — явная ошибка без оптимистичного входа.
- [ ] Пользовательская приёмка: UX кнопки и текстов ошибок на Cupertino и
  Material, поведение при отмене авторизации в VK, отсутствии приложения VK,
  отсутствии сети; macOS — кнопки VK нет.

## Открытые вопросы

- ~~Способ интеграции на клиенте: официальный SDK или системный браузер~~
  решено: официальный `vkid_flutter_sdk` (форк в `third_party/`; перечень
  патчей — в шапке форка и в «Принятых решениях»).
- ~~Тип приложения: публичное или конфиденциальное~~ решено: публичное — SDK
  обменивает код на устройстве, сервер проверяет токен через `user_info`;
  спайк шага 1 остаётся проверкой IP-привязки.
- ~~Одно или два VK-приложения для staging/production~~ решено: одно
  приложение на оба окружения.
- ~~Домен universal link для iOS~~ решено: iperon.net
  (`https://iperon.net/auth/vk-id`, AASA в `.well-known` на домене).
- Лимит частоты `AUTH_VK` — **не блокирует**, выносится в отдельный план: для
  публичных приложений VK даёт 15 000 запросов в сутки на один IP, а каждый
  вызов с неизвестным токеном тратит один запрос сервера — заливкой мусорных
  токенов квоту можно выбрать, и вход через VK перестанет работать до конца
  суток. У Яндекса такого лимита нет, поэтому у `AUTH_YANDEX` ограничения тоже
  нет. Предложение: лимит неудачных `AUTH_VK` по IP клиента.

Блокирующих вопросов нет.
