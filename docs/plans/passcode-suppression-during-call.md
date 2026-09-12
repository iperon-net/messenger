# Подавление app-passcode во время активного звонка

## Context

App-lock (passcode/биометрия) — локальная блокировка приложения, отдельная от
серверной авторизации. Экран `ScreenLock` рисуется в `builder:` у
`CupertinoApp.router` / `MaterialApp.router` и при `isLocked == true` **полностью
заменяет** содержимое навигатора (`return ScreenLock(...)` вместо `child`, см.
`lib/app_cupertino.dart:191`, `lib/app_material.dart:161`). То есть passcode
накрывает весь UI, включая уже открытый пуш-роут `/call`.

Сам звонок живёт **вне** дерева виджетов: баннер входящего — нативный (CallKit на
iOS / `flutter_callkit_incoming` на Android), а комната LiveKit и аудио
поднимаются в сервисе `Calls` по событиям `CallPush`. Поэтому passcode **не
блокирует** приём/аудио/отбой — но **прячет внутренний экран `/call`** (видео +
внутриэкранные кнопки mute/камера/динамик), если приложение оказалось locked в
момент ответа (cold-start по push при `passcodeForceLocked` или истёкшем таймауте
авто-блокировки; либо возврат из фона с авто-блокировкой).

**Проблема (UX):** на iOS это сглажено нативными контролами CallKit (аудиозвонок
управляем без разблокировки), но видео не видно; на Android заметнее — чтобы
увидеть звонок и пользоваться in-app кнопками, надо ввести passcode.

**Цель:** во время активного звонка показывать `/call` без запроса passcode,
оставляя заблокированным весь остальной интерфейс.

## Главное ограничение (безопасность)

Наивное «звонок активен → не показывать passcode» даёт **полный обход блокировки**:
экран `/call` можно свернуть свайпом-назад (звонок продолжается, `CallGate`
допускает это — `_routeOpen=false`), и под ним окажется разблокированный
tab-shell (чаты/настройки). Поэтому подавлять надо по связке
**`callActive && текущий роут == /call`**, а НЕ по одному `callActive`. Как только
пользователь сворачивает звонок — passcode обязан вернуться поверх shell.

Второй принцип: **`isLocked` не сбрасываем.** Подавление — чисто визуальный гейт
в `builder:`. Тогда блокировка «сама» возвращается в тот же кадр, как только экран
звонка перестаёт быть верхним или звонок закончился — не нужен ручной re-lock и
нет окна гонки.

## Точки правки (зеркально в обоих app-root, по паттерну `isAuthRoute`)

1. **`lib/cubit/common_state.dart`** — два поля (dart_mappable, нужен
   `dart run build_runner build --delete-conflicting-outputs`):
   ```dart
   final bool callActive;   // default false
   final bool isCallRoute;  // default false
   ```
2. **`lib/cubit/common_cubit.dart`:**
   - В конструкторе подписаться на `getIt.get<Calls>().snapshots`, эмитить
     `callActive = status != idle && status != ended`; подписку отменять в
     `close()`. `Calls` уже в `get_it`, готов после `allReady`.
   - Добавить `setIsCallRoute(bool)` — копия `setIsAuthRoute`
     (`common_cubit.dart:173`).
3. **`_onRouteChanged`** (`lib/app_cupertino.dart:69`, `lib/app_material.dart`) —
   рядом с `isAuthRoute` вычислить `isCallRoute = location == "/call"` и прокинуть
   в кубит.
4. **Условие в `builder:`** (`lib/app_cupertino.dart:191`,
   `lib/app_material.dart:161`):
   ```dart
   final callVisible = state.callActive && state.isCallRoute;
   if (!state.isAuthRoute && state.settingsDevice.passcode.isNotEmpty && state.isLocked && !callVisible) {
     return ScreenLock(...);
   }
   ```

## Поведение (следует из дизайна)

- **Locked + приняли звонок** → `CallGate` пушит `/call` → `callVisible` →
  passcode подавлен → экран звонка виден и управляем.
- **Свернули `/call`** → `isCallRoute=false` → passcode тут же возвращается поверх
  shell; аудио продолжается; отбой — из ongoing-нотификации (Android) / CallKit
  (iOS). Тап по нотификации → `Calls.focusRequests` → `/call` снова сверху →
  снова подавлен.
- **Звонок завершился** → `callActive=false` → passcode возвращается автоматически
  (`isLocked` не сбрасывали).

## Риски (принять явно)

- **Модель угроз меняется:** взявший телефон во время входящего сможет принять и
  вести звонок (говорить, видеть видео) без passcode. Но (а) это ровно то, что
  системный телефон и нативные контролы CallKit уже позволяют сейчас; (б) в
  остальную часть приложения он не попадёт. Осознанный компромисс — **требует
  согласования с пользователем**.
- **Косметика:** при сворачивании `/call` возможен кадр-мелькание tab-shell до
  наложения passcode. Лечится blur/промежуточным гейтом; вероятно, допустимо.
- **Проверить при реализации:** на экране `/call` не должно быть кнопок,
  уводящих `context.go(...)` в другие разделы (иначе — лазейка мимо гейта). По
  текущему коду `/call` самодостаточен, риск низкий.

## Объём

Малый: 4 файла (`common_state.dart` + `.mapper.dart` через build_runner,
`common_cubit.dart`, `app_cupertino.dart`, `app_material.dart`), **без нативных
правок**. Логика повторяет существующий паттерн `isAuthRoute`.

## Статус

Не начато. Спроектировано (2026-09-12), ждёт согласования по смене модели угроз и
реализации.
