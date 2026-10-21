# Системные уведомления (служебный чат «Iperon»)

Статус: 2026-10-21. Этапы 1 (сервер), 2 (клиент) и 3 (нативные пуши) написаны; на стенде и устройствах не проверены.

## 1. Задача

Сообщать пользователю на всех его устройствах о событиях безопасности аккаунта:
вошли с нового устройства, установили / сменили / сняли облачный пароль, сбросили
его по почте, ввели неверный облачный пароль при входе и т. п. Как сервисные
сообщения Telegram от аккаунта 777000 («Новый вход в аккаунт…»).

## 2. Решение

**Служебный чат с системным пользователем «Iperon»**, а не отдельный канал
уведомлений. Сообщение — обычное сообщение личного чата, поэтому даром получаем:

- историю («что происходило с аккаунтом»);
- доставку на выключенные устройства (журнал `pts` → `GET_DIFFERENCE`);
- синхронизацию между устройствами (UPDATES по стриму);
- пуш (`ServiceNotifications.Notify`), счётчик непрочитанных, бейдж.

### Системный пользователь

- `models.SystemUserID` = ObjectID `000000000000000000000001` (константа, та же на
  клиенте). Документа в `users` нет: вход, поиск, контакты, OPRF его не видят.
- `PROFILE` по этому ID отдаёт синтетический профиль: `firstName = "Iperon"`,
  `official = true` (новое поле `Profile.Response.official`). Аватар клиент берёт из
  своих ассетов.
- Чат «я ↔ система» — обычный личный чат (`GetOrCreatePrivateChat`, `pairKey`),
  `models.Chat.IsSystem()`. Создаётся первым уведомлением.
- У системного пользователя есть строка диалога в `chatMembers` (нужна логике
  `clearedMaxId` / очистки медиа), но **нет журнала**: `ServiceChats.append`
  пропускает `SystemUserID` (журнал никто не читает, а общий счётчик `pts` на всех
  пользователей был бы горячей точкой).

### Ограничения чата

| Действие | Поведение |
|---|---|
| `Send`, пересылка в чат, `Schedule` | `ErrChatWriteForbidden` («chatWriteForbidden») |
| `CanWrite` | `false` — клиент вместо поля ввода показывает «Звук вкл/выкл» |
| `SetTTL`, `SetNoForwards` (и запрос) | `ErrChatForbidden` |
| Реакции, закреп, пересылка из чата | запрещены сами (уведомление — служебное содержимое, `isServiceMessage`) |
| Звонок (`CALL_RING`) системному | `PermissionDenied` |
| Секретный чат с системным | `CanMessageUser = false` |
| `RecordCall` с системным | пропуск |
| «Печатает…» | никому |
| Удалить сообщение / очистить / удалить чат | можно (у себя); новое уведомление вернёт чат |
| Заглушить | можно — тогда без пуша (как у обычного чата) |

### Содержимое сообщения

Структура, а не готовый текст: текст собирает клиент через slang на языке
устройства, а под сообщением можно показать кнопки действий.

```proto
// chats_v1.proto
message MessageContent {
  ...
  MessageSystemNotice systemNotice = 14;
}

message MessageSystemNotice {
  enum Kind {
    UNKNOWN = 0;
    NEW_LOGIN = 1;               // вход с нового устройства
    CLOUD_PASSWORD_SET = 2;      // включена двухшаговая проверка
    CLOUD_PASSWORD_CHANGED = 3;
    CLOUD_PASSWORD_DISABLED = 4;
    CLOUD_PASSWORD_RESET = 5;    // сброшен по коду из письма
    CLOUD_PASSWORD_WRONG = 6;    // при входе ввели неверный облачный пароль
    RECOVERY_EMAIL_SET = 7;      // подтверждена почта восстановления
    PASSKEY_ADDED = 8;
    PASSKEY_REMOVED = 9;
  }
  enum LoginMethod { ... CALL_PASSWORD / SMS / PASSKEY / YANDEX }
  Kind kind = 1;
  bytes sessionID = 2;   // сессия, которая это сделала (вход — новая сессия)
  string deviceModel = 3; int32 os = 4; string osVersion = 5; string appVersion = 6;
  string ip = 7; string locationEnglish = 8; string locationRussian = 9;
  LoginMethod loginMethod = 10;
  string email = 11;     // маска почты (RECOVERY_EMAIL_SET)
  string passkeyLabel = 12;
}
```

Клиент не может прислать `systemNotice` (`validateMessageContent` → InvalidArgument).
Сообщение — от `SystemUserID`, непрочитанное, без автоудаления, в поиск по сообщениям
не попадает (служебное).

### Пуш

Новый `PushPayload.Kind.SYSTEM_NOTICE = 15`: `chatID` / `messageID` — чат «Iperon»,
`title = "Iperon"`, `body` пустой; текст собирает устройство (iOS NSE, Android
`MessagePushHandler`) по `args`:

- `args[0]` — имя `MessageSystemNotice.Kind` (`NEW_LOGIN`, …);
- `args[1]` — устройство (`deviceModel`), `args[2]` / `args[3]` — место (en / ru).

Не гасится настройками уведомлений (это безопасность), только заглушённым чатом.
Не идёт на сессию-инициатора (`Notification.ExceptSessionID`). Старые сборки нового
`kind` не знают — увидят чат при следующем открытии.

### Откуда приходят уведомления

Пишет `ServiceChats.PostSystemNotice(userID, notice, exceptSessionID)`; публикует
fanout api (`V1.postSystemNotice`, фоном, как `RecordCall`). Точки:

| Событие | Где |
|---|---|
| `NEW_LOGIN` | `ServiceAuth.Confirmation` (единственное место создания сессии: звонок, SMS, passkey, Яндекс, облачный пароль). Только для существующего пользователя. |
| `CLOUD_PASSWORD_WRONG` | `CloudPasswordVerify`, первая неверная попытка на `confirmationSession` (не спамит). |
| `CLOUD_PASSWORD_RESET` | `CloudPasswordRecoveryConfirm` (сброс при входе) и `CloudPasswordReset` (сброс из настроек). |
| `CLOUD_PASSWORD_SET` / `CHANGED` | `CloudPasswordSet` (был ли пароль раньше). |
| `CLOUD_PASSWORD_DISABLED` | `CloudPasswordDisable`. |
| `RECOVERY_EMAIL_SET` | `CloudPasswordEmailVerify` (почта подтверждена). |
| `PASSKEY_ADDED` / `REMOVED` | `PasskeyRegisterFinish` / `PasskeyDelete`. |

Выключатель — `systemNotices.enabled` в конфиге сервера, **по умолчанию выключен**.
Сборки без поддержки показали бы от «Iperon» пустое сообщение, поэтому включать
только вместе с выходом клиента.

Pre-auth события (`Confirmation`, `CloudPasswordVerify`, `RecoveryConfirm`) пишет
сам `ServiceAuth` через узкий интерфейс `SystemNoticesInterface` (реализует api,
ставится `SetSystemNotices`); остальные — обработчики api после успеха (там
известна сессия-инициатор).

## 3. Клиент (как сделано)

- `models.systemUserID` / `systemAccountName`, `Chat.isSystem`; `canPost` у него `false` —
  внизу «Звук» (как у подписчика канала), без свайпа-ответа, реакций, пересылки (и в «Переслать в…»
  его нет), выбора «удалить у обоих».
- Уведомление — обычный входящий пузырь: текст собирает `systemNoticeText` (`chats_mapping.dart`,
  заголовок жирным, подробности строками, место — по языку), превью в списке —
  `systemNoticeTitle`; `Message.systemNotice` (вид, `sessionID`, устройство) — для кнопок.
- Кнопки внизу пузыря (`MessageBubble.actions`, `ChatMessagesView.actionsFor`):
  «Устройства» и «Это не я» (не для текущей сессии) — `system_notice_common.dart`: подтверждение →
  `hasNetwork()` → `DEVICE_SESSIONS_TERMINATE` → облачный пароль не включён — предложить включить.
- Имя — всегда «Iperon» (`_loadPeers`), аватар — значок приложения на цвете темы
  (`SystemAccountAvatar`, `assets/images/system_account.svg`), подзаголовок «Служебные уведомления».
- Профиль (`ProfileX`): без звонков, в «Ещё» только «Удалить чат»; в «Заблокировать пользователя»
  его нет. Поле `Profile.Response.official` клиент пока не читает — узнаёт по ID.
- Пуш: тап `SYSTEM_NOTICE` ведёт в чат (`routeForKind`); iOS NSE и Android собирают текст по
  `args` (`PUSH_SYSTEM_*` / `push_system_*`), без аватара — значок приложения.
- Демо-режим: чат «Iperon» с двумя уведомлениями.

## 4. Этапы

1. **Сервер** — proto, системный пользователь, ограничения чата, `PostSystemNotice`,
   хуки, пуш `SYSTEM_NOTICE`, тесты.
2. **Клиент** — Dart-константа `SystemUserID`, синтетический профиль (имя, аватар из
   ассетов, галочка), пузырь уведомления (`*_cupertino` / `*_material`), строки
   `en` / `ru`, вместо поля ввода — «Звук», скрыть «Позвонить», «Заблокировать»,
   «Секретный чат», «Добавить в контакты»; кнопки «Устройства» и «Это не я»
   (`DEVICE_SESSIONS_TERMINATE` по `sessionID` + предложить облачный пароль, гард
   `hasNetwork()`); данные для демо-режима.
3. **Нативные пуши** — `SYSTEM_NOTICE` в iOS NSE и Android (локализованный текст по
   `args`, тап открывает чат «Iperon»).
4. **Позже (по желанию)**:
   - плашка «Новый вход — Это я / Это не я» над списком чатов (как в Telegram 10);
   - защита от угона: сессия моложе 24 часов не может завершать другие сессии и
     менять / снимать облачный пароль;
   - другие события: смена номера, `@username`, удаление аккаунта.
