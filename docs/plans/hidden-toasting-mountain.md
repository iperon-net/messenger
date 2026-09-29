# Облачный пароль + email (двухшаговая проверка)

## Context

Нужна «двухшаговая проверка» уровня Telegram: дополнительный **облачный пароль**, который
хранится **на сервере** как argon2id-хэш, плюс **email** для восстановления. Мотивация:
телефон/звонок-пароль — единственный сейчас фактор входа; кто угодно с доступом к номеру
входит в аккаунт. Облачный пароль добавляет второй фактор при входе на новом устройстве,
а email позволяет восстановить доступ, если пароль забыт.

Обе кодовые базы уже частично подготовлены:
- **Сервер** (`~/GolandProjects/iperon`, Go/fx/gRPC/**MongoDB**): флаг `hasCloudPassword`
  протянут через весь login-флоу, но захардкожен в `"false"` (`internal/services/auth.go:1017`).
  SMTP-модуль (`internal/smtp/`) и шаблон письма `confirmation_code` (en/ru, «Your verification
  code: {{.Code}}») **уже написаны, но нигде не вызываются**. argon2 отсутствует, но
  `golang.org/x/crypto/argon2` уже в go.mod. Миграций нет — поля добавляются в bson-структуру.
- **Клиент** (Flutter, этот репозиторий): в `AuthCallPasswordConfirmation.Response` уже есть
  `hasTwoStepVerification` + `confirmationSession`; в `auth_callpassword_confirmation_cubit.dart:173`
  стоит TODO ровно в точке ветвления второго шага.

### Согласованные решения (с пользователем)
- **Восстановление** при забытом пароле — **да** (на экране входа «Забыли пароль?» → код на
  email → новый пароль).
- **Верификация email кодом** при установке/смене — **да**.
- **Отключение** облачного пароля в настройках (с вводом текущего) — **да**.
- email хранить **в нижнем регистре**, дубликаты между аккаунтами разрешены.
- Поэтому: **email обязателен при первичной установке** облачного пароля (без него
  восстановление невозможно).

### Модель безопасности (ключевое)
- **Клиент никогда не шлёт пароль в открытом виде.** Клиент считает дешёвый **pre-hash** и
  передаёт **его** вместо plaintext; сервер применяет поверх argon2id. Разделение труда:
  - **клиент** — `pwHash = SHA-256("iperon-cloud-pw-v1" ‖ password)` (domain-separation тегом,
    чтобы транслируемое значение не совпадало с чужими rainbow-таблицами и с любым другим местом,
    где хэшируется пароль). Считать через `package:cryptography`. Хэш **одинаков во всех точках** —
    вход, установка, смена, восстановление (как identical-параметры у локального код-пароля: разошлись
    → пароли никогда не совпадут). В proto это поле `pwHash` (`bytes`, 32 байта), а не `string password`.
  - **сервер** — `argon2id(salt, pwHash)`, соль/параметры/апгрейд на сервере.
  - Что это даёт: сервер и его логи **никогда не видят настоящий пароль** → защита от
    reuse-харвестинга (тот же пароль на почте/банке не утекает через дамп логов/рогуе-админа).
  - Чего НЕ даёт: `pwHash` — **password-эквивалент** для нашего сервера и **реплеится** при вскрытом
    TLS (захват аккаунта). Pre-hash это НЕ исправляет — только SRP/OPAQUE (см. «Почему не SRP»).
    Поэтому две страховки ниже — часть механизма, а не best-practice.
- ⚠️ **Всё держится на TLS.** `lib/api.dart` сейчас использует `ChannelCredentials.insecure()`; в
  проде трафик идёт по TLS (443). Т.к. `pwHash` password-эквивалентен:
  1. **жёстко гарантировать, что release-канал никогда не `insecure()`** (ассерт/фейл сборки при
     прод-хосте на insecure-канале);
  2. **не логировать поле `pwHash`** — ни в клиентском `TalkerGrpcLogger`, ни в серверном
     request-логгере.
- **Argon2id на сервере обязателен** (pre-hash его дополняет, а не заменяет — иначе pass-the-hash:
  утечка БД = мгновенный вход реплеем). Параметрами владеет сервер (локальный код-пароль на клиенте —
  отдельная история). Рекомендация: `argon2.IDKey`, salt 16 байт (random), time=3, memory=64*1024,
  threads=4, keyLen=32; хранить `salt || hash`.
- **Rate limiting**: на login-проверке пароля считать попытки по `confirmationSession` в Redis;
  после N неудач инвалидировать `confirmationSession`; возвращать `attemptsLeft`.

### Почему не SRP

SRP (Secure Remote Password, PAKE) доказывает знание пароля **без передачи пароля по сети** —
пароль не появляется в открытом виде ни в TLS-туннеле, ни в памяти/логах сервера; сервер хранит
не хэш, а `verifier`. Так сделана двухшаговая проверка в Telegram. Мы **сознательно** его не
делаем — по трём причинам:

1. **Явное решение пользователя** — «на сервере в argon2id». Это фиксированный продуктовый выбор.
2. **Резко бо́льшая сложность именно в нашем стеке.** SRP — это handshake на 2 round-trip'а
   (клиент→`A`, сервер→`salt,B`, клиент→`M1`, сервер→`M2`), а не один unary-вызов. Отсюда:
   - серверу нужно держать **эфемерное состояние между раундами** (`b,B,A`) в Redis по
     `confirmationSession` (в argon2-варианте его нет вообще);
   - на клиенте появляется настоящая крипта (`x`, `A`, `S`, `K`, `M1`/`M2` на `BigInt`), а при
     установке/смене/**восстановлении** пароля клиент считает `verifier` — т.е. recovery-flow тоже
     получает клиентскую SRP-регистрацию;
   - **главный риск — SRP на Dart**: аудированной библиотеки под Dart фактически нет; либо
     неаудированный пакет с pub.dev, либо ручная реализация (~150-250 строк) с байт-в-байт отладкой
     совместимости с серверной Go-либой (`1Password/srp` / `opencoff/go-srp`). Ошибка в SRP не
     падает исключением, а **молча делает протокол небезопасным**.
   - Итого сверху к текущему плану: грубо **+5-9 человеко-дней**, с риском, сконцентрированным в
     самой хрупкой (Dart) части.
3. **Модель угроз уже целиком TLS-зависима.** Сообщения, сигналинг звонков, профиль идут по тому же
   каналу. SRP защищает *только пароль* от вскрытого TLS/сервера, оставляя остальное незащищённым —
   непропорционально дорого за это одно свойство. argon2-подход полностью закрывает **реальную
   заявленную угрозу** (доступ к номеру = вход в аккаунт); SRP закрывает *дополнительную*
   (компрометация TLS/сервера), которая здесь не первоочередная.

**Дешёвая страховка вместо SRP (обязательна, т.к. безопасность argon2-подхода «арендуется» у TLS):**
- жёстко гарантировать, что release-канал никогда не `insecure()` (ассерт/фейл сборки при
  прод-хосте на insecure-канале);
- **не логировать** поле `password` в `AUTH_CLOUD_PASSWORD` — ни в клиентском `TalkerGrpcLogger`,
  ни в любом request-логгере на сервере.

**Если PAKE понадобится в будущем** — смотреть не на SRP, а на **OPAQUE** (современный aPAKE на
базе OPRF): устойчивее SRP (verifier не поддаётся pre-computation), и у нас **OPRF-крипта уже есть**
(contacts discovery). Это отдельный крупный заход, не для этой итерации.

### Почему argon2 считает сервер, а не клиент

Задача argon2 — защитить **хранимое** значение от офлайн-брутфорса при утечке БД, а хранимым
владеет сервер. Перенос argon2 на клиент не помогает и создаёт проблемы:

1. **Pass-the-hash.** Если клиент считает argon2, а сервер хранит присланное как есть (сравнение на
   равенство), то хранимое = то, чем аутентифицируются → **утечка БД = мгновенный вход без
   брутфорса** (реплей украденного). Значит сервер всё равно **обязан** хэшировать присланное ещё
   раз — клиентский argon2 серверный не отменяет.
2. **Соль.** При входе клиент должен воспроизвести ту же соль, что при установке. Детерминированная
   соль (из телефона/userID) предсказуема; присылка соли сервером до входа = лишний round-trip +
   **enumeration** (неаутентифицированный узнаёт, есть ли у номера пароль и его соль) — дорога к
   SRP. argon2 без соли — просто дорогая детерминированная функция, цена потрачена впустую.
3. **Апгрейд параметров.** memory/time надо повышать со временем; серверный argon2 позволяет это
   централизованно + rehash-on-login. Клиентский вмораживает параметры в десятки версий на
   устройствах.
4. **Слабые устройства.** argon2 memory-hard; на дохлом Android параметры под серверное железо =
   лаги/OOM. Пришлось бы брать параметры под самое слабое устройство → слабее для всех.
5. **Выигрыша по безопасности нет.** Присланное значение всё равно password-эквивалент и реплеится
   при вскрытом TLS — то же, что у дешёвого pre-hash, но с ловушками выше. SRP-свойства это не даёт.

Правильное разделение труда: **клиент — дешёвый pre-hash с domain-separation** (защита плейнтекста
от сервера/логов, reuse), **сервер — argon2id с солью** (защита БД, апгрейд параметров). NB:
локальный код-пароль на клиенте использует argon2id корректно — там хэш **не покидает устройство**,
сравнивается локально, соль локальная; для *серверного* пароля ограничения принципиально другие.

---

## Протокол (правится в ОБОИХ репозиториях `protos/`, затем регенерация)

Новый файл **`protos/cloud_password_v1.proto`** (оба репо). Новые значения в
`protos/v1.proto` enum `MessageType` — следующие свободные (макс. занятый 48; зарезервированы
16,17,18,21), т.е. **49–56**:

**NB (pre-hash):** везде, где пользователь вводит пароль, по проводу идёт `pwHash` (`bytes`, 32 байта =
клиентский `SHA-256("iperon-cloud-pw-v1" ‖ password)`), а НЕ plaintext-строка (см. «Модель
безопасности»). Сервер применяет argon2id поверх `pwHash`.

**Pre-auth (вход, до сессии — unary, как `AUTH_CALL_PASSWORD`):**
- `AUTH_CLOUD_PASSWORD` — `Request{bytes confirmationSession; bytes pwHash}` →
  `Response{bool success; optional string error; optional int32 attemptsLeft}`
- `AUTH_CLOUD_PASSWORD_RECOVERY` — `Request{bytes confirmationSession}` →
  `Response{string maskedEmail; optional string error}` (шлёт код на email)
- `AUTH_CLOUD_PASSWORD_RECOVERY_CONFIRM` —
  `Request{bytes confirmationSession; string code; bytes newPwHash}` →
  `Response{bool success; optional string error}`

**Authenticated (настройки — через `exchangeEncrypted`, как `MY_PROFILE_UPDATE`):**
- `CLOUD_PASSWORD_INFO` — `Request{}` → `Response{bool isEnabled; string maskedEmail; bool isEmailVerified}`
- `CLOUD_PASSWORD_SET` — `Request{bytes currentPwHash; bytes newPwHash}` →
  `Response{bool success; optional string error}` (`currentPwHash` пуст при первичной установке)
- `CLOUD_PASSWORD_DISABLE` — `Request{bytes currentPwHash}` → `Response{bool success; optional string error}`
- `CLOUD_PASSWORD_EMAIL_SET` — `Request{bytes currentPwHash; string email}` →
  `Response{bool success; optional string error}` (шлёт код верификации)
- `CLOUD_PASSWORD_EMAIL_VERIFY` — `Request{string code}` → `Response{bool success; optional string error}`

Регенерация: сервер — `task gen` (нужен `protoc` в PATH) + `task mockery` при изменении
мокаемых интерфейсов; клиент — `protoc --dart_out=...` по существующему процессу в `lib/protobuf/`.

---

## Сервер (`~/GolandProjects/iperon`)

1. **Хранение** — `internal/repositories/users.go`:
   - В `userDocument` (`:42`) добавить `cloudPasswordHash []byte` (salt||hash) и `emailEncrypted
     []byte` (шифровать тем же `cryptoEncryptor`, что и телефон; email заранее в lowercase),
     `emailVerified bool`.
   - Добавить методы по образцу `SetLastSeen` (`:303`, `UpdateByID/$set`): `SetCloudPassword`,
     `ClearCloudPassword`, `SetEmail`, `SetEmailVerified`. Расширить
     `RepositoryUsersInterface` (`internal/services/interfases.go:70`) + `task mockery`.
   - В доменную `models.User` (`internal/models/users.go:16`) добавить соответствующие поля.
2. **argon2id-хелпер** — в `internal/crypto/` (рядом с `encryptor.go`): `HashPassword(pwHash)` /
   `VerifyPassword(pwHash, stored)`. Использует `golang.org/x/crypto/argon2`. На вход подаётся
   клиентский `pwHash` (32 байта), НЕ plaintext — сервер plaintext не видит (см. «Модель безопасности»).
3. **Login-гейт**:
   - `CallPasswordWebhook` (`internal/services/auth.go:1017`): выставлять NATS-заголовок
     `hasCloudPassword="true"`, если у найденного юзера есть `cloudPasswordHash`. (Флаг уже
     доезжает до клиента как `hasTwoStepVerification`.)
   - Новый хендлер `AUTH_CLOUD_PASSWORD` (dispatch в `internal/api/v1.go message()` рядом с
     `:478`): по `confirmationSession` из Redis-хэша `authConfirmation` достать userID → юзера →
     `VerifyPassword`. При успехе пометить в Redis у этого `confirmationSession` флаг
     `cloudPasswordPassed=true`. Считать/декрементить попытки; при исчерпании — удалить
     `confirmationSession`.
   - **Гейт в `ServiceAuth.Confirmation` (`internal/services/auth.go:263`)**: если у юзера есть
     `cloudPasswordHash`, а у `confirmationSession` нет `cloudPasswordPassed` — отказать
     (`invalidArgument`). Это защищает от прямого вызова `AUTH_CONFIRMATION` в обход.
   - Аналогичный гейт применить и к пути moderation-store (`Confirmation` общий — покрывается
     автоматически, проверить).
4. **Восстановление (pre-auth)**:
   - `AUTH_CLOUD_PASSWORD_RECOVERY`: по `confirmationSession`→юзер→email; сгенерировать код,
     положить в Redis (TTL, напр. 10 мин, ключ по `confirmationSession`); отправить через
     `smtp.Smtp.Send(ctx, email, smtp.TemplateConfirmationCode, lang, TemplateConfirmationCodeData{Code})`.
     Вернуть маскированный email. Инъекция `*smtp.Smtp` (через интерфейс + mockery) в `ServiceAuth`.
   - `AUTH_CLOUD_PASSWORD_RECOVERY_CONFIRM`: сверить код → `HashPassword(newPwHash)` →
     `SetCloudPassword` → пометить `cloudPasswordPassed=true` у `confirmationSession`.
5. **Настройки (authenticated, через `exchangeEncrypted`, `internal/api/v1.go:1741`)**: хендлеры
   `CLOUD_PASSWORD_INFO / _SET / _DISABLE / _EMAIL_SET / _EMAIL_VERIFY`. `_SET`/`_DISABLE`/
   `_EMAIL_SET` проверяют `currentPwHash` (если пароль уже установлен). `_EMAIL_SET` шлёт код
   тем же SMTP; код в Redis по userID; `_EMAIL_VERIFY` подтверждает и ставит `emailVerified`.
   Логика — в `ServiceAuth` или новом `ServiceCloudPassword` (вписать в `NewV1`/DI).
6. `iperon.yaml` — убедиться, что `smtp.*` заполнены (DSN/креды/FromEmail); модуль уже
   зарегистрирован (`smtp.Module` в `internal/api/di.go`).

---

## Клиент (Flutter, этот репозиторий)

### Вход
0. **Pre-hash хелпер** (общий для входа и настроек): `cloudPasswordHash(String password) → Uint8List`
   = `SHA-256("iperon-cloud-pw-v1" ‖ utf8(password))` через `package:cryptography`. Положить рядом с
   криптой (напр. `lib/crypto/`), использовать во ВСЕХ точках (вход/установка/смена/восстановление) —
   расхождение = пароли не совпадут. По проводу всегда `pwHash`, не plaintext.
1. **Ветвление** в `lib/cubit/auth/auth_callpassword_confirmation_cubit.dart` (ветка
   `AuthCallPasswordStatus.success`, `:171`, где TODO `:173`): если
   `response.hasTwoStepVerification == true` — не запускать META_DATA/AUTH_CONFIRMATION, а
   `emit(redirectURI: "/auth/cloud_password?confirmationSession=<hex>")`. Иначе — как сейчас.
2. **Рефактор**: вынести блок META_DATA_INFO → AUTH_CONFIRMATION → persist(session) →
   `Auth.refresh()` → `redirect /chats` (`:177–284`) в переиспользуемый метод (напр. приватный
   хелпер или общий модуль), чтобы новый cloud-password-кубит вызывал ту же
   последовательность после проверки пароля. (Сейчас этот блок дублируется в
   `auth_moderation_application_store_cubit.dart` — можно заодно свести, но не обязательно.)
3. **Новый экран + кубит** `/auth/cloud_password`:
   - Кубит `lib/cubit/auth/auth_cloud_password_cubit.dart` (+ `_state.dart` + `.mapper.dart`,
     `dart_mappable`, `build_runner`). Метод `submit(password)` → `pwHash = cloudPasswordHash(password)`
     (п.0) → pre-auth unary `AUTH_CLOUD_PASSWORD{pwHash}` (`api.call(() => api.client.unary(...))`) →
     при успехе запустить общий completion-хелпер из п.2. Показ `attemptsLeft`/ошибок.
   - Экраны `lib/screens/auth/auth_cloud_password_cupertino.dart` + `_material.dart` (поле
     пароля + «Забыли пароль?»).
   - **Восстановление**: «Забыли пароль?» → `AUTH_CLOUD_PASSWORD_RECOVERY` (показать
     маскированный email) → экран ввода кода + нового пароля →
     `AUTH_CLOUD_PASSWORD_RECOVERY_CONFIRM` → общий completion-хелпер. Можно отдельным
     под-экраном/состоянием этого же кубита.
   - **Маршруты** в `lib/routers.dart`: новый child под обоими `/auth`-блоками (cupertino
     `:459–518`, material `:923–975`), по образцу `/auth/call_password_confirmation` (query
     `confirmationSession`, валидация → редирект на `/auth` при отсутствии).

### Настройки
4. **Пункт меню** «Облачный пароль» в
   `lib/screens/settings/settings_privacy_and_security_{cupertino,material}.dart` (рядом с
   код-паролем, `cupertino :63–80`), `context.go("/settings/privacy_and_security/cloud_password")`.
5. **Экран настроек облачного пароля** `settings_cloud_password_{cupertino,material}.dart` +
   кубит `lib/cubit/settings/settings_cloud_password_cubit.dart` (+state+mapper). При открытии —
   `CLOUD_PASSWORD_INFO` (через `api.unaryEncodedWithResponse`). **Все вводимые пароли (текущий/новый)
   перед отправкой прогонять через `cloudPasswordHash()` (п.0 «Вход»)** — по проводу `currentPwHash`/
   `newPwHash`, не plaintext. Меню:
   - **не установлен**: «Установить» → ввод нового пароля (+подтверждение) → `CLOUD_PASSWORD_SET`
     → ввод email → `CLOUD_PASSWORD_EMAIL_SET` → ввод кода → `CLOUD_PASSWORD_EMAIL_VERIFY`.
   - **установлен**: «Изменить пароль» (текущий→новый, `CLOUD_PASSWORD_SET` с `currentPassword`),
     «Изменить email» (текущий пароль→новый email→код), «Отключить» (текущий пароль,
     `CLOUD_PASSWORD_DISABLE`).
   - Под-экраны ввода — по образцу passcode create/verify
     (`settings_passcode_create_*`, `settings_passcode_*`). Использовать `api.unaryEncoded[WithResponse]`.
   - **Маршруты** в `lib/routers.dart`: nested-route под `/settings/privacy_and_security` в
     ОБОИХ деревьях (образец — passcode `:331–354`), с `BlocProvider`.
6. **Offline-guard** (по правилам CLAUDE.md): все set/change/disable/verify — server-authoritative,
   оффлайн не редактируются. Перед вызовом проверять сеть (`getIt.get<Utils>().hasNetwork()` /
   `ConnectionCubit`) и давать явный фидбек (Cupertino `showCupertinoDialog` / Material
   `SnackBar`), не делать optimistic-rollback.

### i18n
7. `lib/i18n/en.i18n.yaml` + `ru.i18n.yaml` (потом `dart run slang`):
   - метка меню в `sessionsPrivacyAndSecurity`;
   - новая секция `screenSettingsCloudPassword` (настройки: установить/изменить/отключить/email/код);
   - секция `screenAuthCloudPassword` (вход: ввод пароля, «Забыли пароль?», восстановление,
     осталось попыток) рядом с `screenAuthCallpasswordConfirmation`;
   - ключи ошибок в `grpcError`. Термины: облачный пароль, код-пароль.

### Кодоген (клиент)
8. После правки моделей состояний — `dart run build_runner build --delete-conflicting-outputs`;
   после i18n — `dart run slang`; после proto — регенерация `lib/protobuf/`.

---

## Verification (end-to-end)

Тесты юнитов в репо нет — проверяем вручную на staging + сервере.

1. **Сборка/статика**: `flutter analyze` + `dart format lib` (клиент); `task linter` + `task
   test` (сервер). Регенерации proto/mapper/slang прошли без ошибок.
2. **Установка (настройки)**: войти, Настройки → Приватность → Облачный пароль → установить
   пароль → ввести email → **проверить, что письмо с кодом реально пришло** (SMTP) → ввести код
   → статус «включён».
3. **Вход со вторым шагом**: выйти/новое устройство → звонок-пароль → **должен появиться экран
   облачного пароля** → неверный пароль показывает ошибку и `attemptsLeft` → верный →
   `AUTH_CONFIRMATION` проходит → `/chats`.
4. **Гейт**: убедиться (лог сервера/ручной вызов), что `AUTH_CONFIRMATION` без пройденного
   cloud-password для юзера с паролем отклоняется.
4a. **Pre-hash + страховки**: убедиться, что по проводу идёт `pwHash` (не plaintext); что `pwHash`
   **не попадает в логи** (клиентский `TalkerGrpcLogger` + серверный request-логгер); что
   release-сборка не поднимает канал `insecure()` на прод-хосте (ассерт/фейл сборки срабатывает).
5. **Восстановление**: на экране входа «Забыли пароль?» → код на email → новый пароль → вход.
6. **Смена/отключение**: изменить пароль (с вводом текущего), изменить email (код), отключить
   (с текущим) → повторный вход больше не требует пароль.
7. **Rate limit**: несколько неверных попыток подряд → `confirmationSession` инвалидируется,
   возврат на `/auth`.
8. **Grafana/логи** (`mcp__grafana`) — проверить отсутствие ошибок SMTP/argon2 на сервере.

## Открытые нюансы (решить по ходу)
- Единый completion-хелпер входа vs дублирование (как сейчас в moderation-кубите) — предлагаю
  вынести общий, но это рефактор существующего кода.
- Хранить email шифрованным блобом (как телефон) — да; lowercase до шифрования; поиск по email
  не нужен (восстановление идёт через `confirmationSession`→userID).
- Оба репозитория `protos/` держать идентичными.
