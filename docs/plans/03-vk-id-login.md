# 03-vk-id-login — Вход через VK ID

**Статус:** draft

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
  Domains; Android — gradle-плагин `vkid.manifest.placeholders` (clientId,
  clientSecret, схема `vk{appID}`). Альтернатива отклонена: свой флоу через
  системный браузер — больше кода и нет быстрого входа через приложение VK.
  `vk_id_auth2` (сторонний) — не рассматривался как основной из-за
  неофициальности.
- **Патч под AGP 9**: ванильный 1.0.3 не собирается с AGP 9 built-in Kotlin
  (issue VKCOM/vkid-android-sdk#120, открыт) — `android/build.gradle` пакета
  применяет `kotlin-android` безусловно и использует `kotlinOptions`; у нас
  AGP 9.1.1 / Gradle 9.3.1. Патчим сами, по конвейеру репозитория: пакет
  заносится в `third_party/vkid_flutter_sdk` (как `flutter_callkit_incoming`,
  `cryptography_flutter`, `screen_protector` — `dependency_overrides`), патч
  по Flutter migration guide (убрать `apply plugin: "kotlin-android"`,
  `kotlinOptions` → top-level `kotlin { compilerOptions { jvmTarget } }`);
  исходники сверяются с pub.dev 1.0.3 (зеркало-фикс
  KonstantenKomkov/vkid-flutter-sdk существует, но неофициальное — не
  подключаем вслепую). Попутно в форке: Maven-репозиторий
  `artifactory-external.vkpartner.ru` → `nexus-external.vkteam.ru` (первый
  умирает после 30.09.2026) и R8 `-dontwarn` для `ru.ok.tracer.base.*` /
  `javax.inject.Inject`. Патч-комментарий — в блоке third_party в
  `pubspec.yaml`, полный список — в шапке форка. Альтернативы отклонены:
  git-зависимость от community-зеркала (неофициальное, 0 звёзд, может
  исчезнуть) и `android.builtInKotlin=false` на весь проект (остальные плагины
  уже переехали на built-in Kotlin).
- **Тип приложения**: публичное — SDK сам обменивает код на access_token на
  устройстве и отдаёт его клиенту; сервер не хранит VK-токены и не делает
  обмен. Риск IP-привязки токена закрывается спайком (шаг 1). Альтернатива
  (конфиденциальное приложение, обмен кода на сервере, service_token +
  IP allowlist, лимит 120k/день) — если спайк провалится (шаг 1).
- **Два client_id — iOS и Android** (наблюдение пользователя из кабинета: у
  платформ де-факто разные client_id) — client_id и client_secret каждой
  платформы вшиваются в нативную конфигурацию соответствующей сборки (iOS —
  Info.plist `VK_APP_CLIENT_ID`/`VK_APP_CLIENT_SECRET`, Android — gradle
  placeholders `clientId`/`clientSecret`); SDK читает их нативно, Dart-геттер
  и поле в `ClientConfig` не нужны. staging и production одной платформы
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

## Шаги

- [ ] 1. Спайк (без коммита): настроить VK-приложение в кабинете Business ID
  (iOS/Android-платформы, universal link `https://iperon.net/auth/vk-id`,
  SHA-1 подписи debug/release); в существующую AASA на iperon.net добавить
  компонент `/auth/vk-id` до exclude `/*/*`; включить scope `phone`;
  curl-проверка `POST https://id.vk.ru/oauth2/user_info`
  с токеном, выданным SDK-флоу, — телефон приходит и вызов работает с
  серверного IP. При провале — переключение на конфиденциальное приложение
  (обмен кода на сервере).
  Прогресс (15.11): AASA обновлена и проверена (`/auth/vk-id` открыт
  приложению, веб-страницы нет — 404); приложение создано, iOS client_id
  `54898051` (Android — уточнить); toggle «Номер телефона» включён, но
  изменение доступов ушло в модерацию VK (до 3 дней, уведомление по почте) —
  до одобрения user_info отдаёт маскированный номер. Найденная серверная
  ошибка authorize — `redirect_uri is missing or invalid` (видна в HTML
  страницы authorize: `"error":{"message":...}`): сверить Universal link
  iOS-платформы посимвольно и добавить Web-платформу (базовый домен
  `iperon.net`, доверенный redirect `https://iperon.net/auth/vk-id`) — это
  независимо от модерации доступов. Диагностика: вердикт ошибки читается
  curl'ом из HTML `id.vk.ru/authorize`, Safari на iPhone показывает только
  «Ошибка загрузки»; обмен кода требует `device_id` (он приходит в
  редиректе вместе с code). PKCE-материал: `/tmp/vk-spike/pkce.txt`.
- [ ] 2. Прото (оба репозитория): `vk_v1.proto` (`Request{token, clientId}`),
  `AUTH_VK = 113` в `v1.proto`; регенерация Dart
  (`protoc --dart_out=grpc:lib/protobuf`, `dart format lib/protobuf`) и Go
  (`task gen` сервера по затронутым прото). Коммит сервера раньше клиента.
- [ ] 3. Сервер: `OAuth.Vk.{ClientIDs, UserInfoURL}` в `settings.go` +
  `iperon.yaml`, `internal/services/auth_vk.go` (user_info с парой
  clientId+токен, телефон, поиск/создание пользователя, sentinel-ошибки),
  диспетчер `AUTH_VK` и маппер ошибок в `internal/api/v1.go`; go-тесты
  `auth_vk` (мок user_info: телефон есть / нет / чужая пара client_id+токен);
  `go build ./...`, `go vet ./...`, `go test ./...`, `golangci-lint run ./...`.
- [ ] 4. Клиент, нативная интеграция: форк `vkid_flutter_sdk` 1.0.3 в
  `third_party/` (диф против pub.dev + AGP 9-патч, репозиторий nexus,
  R8-правила) + `dependency_overrides`; iOS (Info.plist, entitlements
  Associated Domains, AppDelegate `open url`), Android (settings/build.gradle:
  репозиторий + плагин placeholders), `VkSdk`/`NativeVkSdk` в
  `lib/cubit/auth/auth_sdk.dart`, `vkOauthClientID`/`vkOauthClientSecret` в
  `lib/settings.dart`; проверка debug/release сборки Android с AGP 9.
- [ ] 5. Клиент, флоу: `AuthCubit.vkSignIn()` (гард сети, отмены SDK,
  `AUTH_VK`, ветка двухшаговой верификации / `AuthLoginCompleter`), кнопка VK
  в `auth_cupertino.dart`/`auth_material.dart` (`_SignInProvider.vk`,
  занятость `signInBusy`, скрытие на macOS), i18n-ключи `vk.*`.
- [ ] 6. Клиент, тесты: юнит-тесты `AuthCubit.vkSignIn` (сеть недоступна /
  отмена пользователем / ошибка сервера / успех → финал), `AppLocale.ru.build()`
  в `setUpAll`; серверные тесты из шага 3 зелёные на CI.
- [ ] 7. Прекоммиты (`dart format lib`, `flutter analyze`, `flutter test`),
  регенерация `INDEX.md` перед docs-коммитами.

## Тестирование

- [ ] `dart format lib` (без изменений), `flutter analyze` — чисто,
  `flutter test` — зелёные.
- [ ] Юнит-тесты: клиентский `AuthCubit.vkSignIn` (все ветки) и серверные
  go-тесты `auth_vk` (мок user_info; тесты с переводами —
  `await AppLocale.ru.build()` в setUpAll).
- [ ] Ревью качества кода через Kimi (`task review` — `kimi -p`): найденные
  проблемы исправлены или отклонены с обоснованием.
- [ ] e2e (устройства/эмуляторы; `cmd/testpeer` сервера как «второй телефон»):
  iOS и Android — реальный VK-аккаунт с телефоном против staging: кнопка VK →
  авторизация в VK ID (приложение VK / веб-шторка) → вход в аккаунт Iperon,
  привязанный к номеру VK; новый номер → создание пользователя; существующий →
  вход без дубликатов; двухшаговая верификация → облачный пароль; offline —
  явная ошибка без оптимистичного входа.
- [ ] Пользовательская приёмка: UX кнопки и текстов ошибок на Cupertino и
  Material, поведение при отмене авторизации в VK, отсутствии приложения VK,
  отсутствии сети; macOS — кнопки VK нет.

## Открытые вопросы

- ~~Способ интеграции на клиенте: официальный SDK или системный браузер~~
  решено: официальный `vkid_flutter_sdk` (форк в `third_party/` с AGP 9-патчем).
- ~~Тип приложения: публичное или конфиденциальное~~ решено: публичное — SDK
  обменивает код на устройстве, сервер проверяет токен через `user_info`;
  спайк шага 1 остаётся проверкой IP-привязки.
- ~~Одно или два VK-приложения для staging/production~~ решено: одно
  приложение на оба окружения.
- ~~Домен universal link для iOS~~ решено: iperon.net
  (`https://iperon.net/auth/vk-id`, AASA в `.well-known` на домене).

Блокирующих вопросов нет — можно переходить к шагу 1 (спайк) после апрува
плана.
