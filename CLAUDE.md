# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make gen      # protobuf + build_runner (dart_mappable/json_serializable/envied) + slang i18n
make watch    # build_runner in watch mode during development
make lang     # slang i18n generation only
make build    # release APK + App Bundle + IPA with obfuscation and debug symbols
make upload   # upload IPA to App Store via altool
make sql      # pull SQLite DB from connected Android device via adb
```

Run `make gen` after modifying any `.proto` files, annotated models, or translation files.

## Architecture

Flutter messenger app (package: `net.iperon.messenger`) targeting Android (Material) and iOS (Cupertino) with separate UI implementations sharing the same BLoC/Cubit logic.

**Layer overview:**
- `lib/main.dart` — entry point; detects `Platform.isIOS` to select Material vs Cupertino app root; bootstraps DI and registers all cubits in `MultiBlocProvider`
- `lib/di.dart` — `get_it` service locator; `registerCommonDependencies()` / `unregisterCommonDependencies()` (called on logout); dependency order: `Logger` → `Utils`/`Crypto`/`Repositories`/`API` → `Routers`/`Services`
- `lib/api.dart` — gRPC channel to `staging.iperon.net:443`; `API.call()` wraps all gRPC calls, returns `""` on success or a localized i18n key string on failure; `callOptions()` injects `x-app-version` and `x-request-id` metadata
- `lib/routers.dart` — two separate `GoRouter` instances: `Routers.material()` and `Routers.cupertino()`; auth redirect built-in via `redirect` callback checking `sessions.getActive()`
- `lib/screens/` — one folder per screen; each contains `*_cubit.dart`, `*_state.dart`, `*_screen_material.dart`, `*_screen_cupertino.dart`
- `lib/repositories/` — SQLCipher-encrypted SQLite (`repositories.dart` uses `part` directives for `settings_device.dart`, `users.dart`, `sessions.dart`)
- `lib/services/` — business logic layer; `Services` facade with `part "auth.dart"`
- `lib/models/` — `dart_mappable` immutable value objects
- `lib/settings.dart` — `envied`-backed settings from `.env` file (database name, ECDH fingerprint, Yandex OAuth client ID, phone moderation number)
- `lib/constants.dart` — `Status` enum `{ initialization, loading, success }`

## State Management

**Pattern:** `flutter_bloc` Cubit with `dart_mappable` states (not Freezed).

- State classes annotated with `@MappableClass()`; generate `*.mapper.dart` files via `make gen`
- State updates via `state.copyWith(...)`; `Status` enum on each state for async tracking
- All cubits provided globally in `MultiBlocProvider` at app startup in `main.dart`
- Cubits initialize lazily: screens call `context.read<XCubit>().initialization()` from `initState()`
- `MainCubit` is the root-level cubit holding `SettingsDevice`, `User`, `Session`, and runtime permission statuses (contacts, notifications)
- BLoC observer (`talker_bloc_logger`) active in debug mode only

## API Communication

gRPC clients (`AuthClient`, `MetadataClient`) generated from `protos/auth_v1.proto` and `protos/models.proto`. Error handling in `API.call()`:
- `StatusCode.unknown` / `unavailable` → `"errorConnectingToTheServer"`
- `StatusCode.deadlineExceeded` → `"unableToConnectToTheServer"`
- `StatusCode.cancelled` / `invalidArgument` → passes through `err.message` directly as i18n key
- `StatusCode.internal` → `"internalServerError"`

Streaming responses (`ResponseStream<T>`) used for real-time call password completion.

## Syncer (real-time bidirectional stream)

`lib/syncer/syncer.dart` (with `part "auth.dart"` / `part "device_sessions.dart"`) owns a persistent bidirectional gRPC stream (`SyncerClient.messages`) for real-time sync. It is a `get_it` singleton; only the iOS `HomeCupertinoScreen` currently drives its lifecycle — `connect()` in `initState`, `dispose()` on background/hidden, `connect()` on resume (via `AppLifecycleListener`).

**Connect / auth handshake:** `connect()` tears down any prior stream, loads `sessions.getActive()`, and — if there is no active session — emits `controllerAuth.add(false)` and returns *without opening a stream* (opening one while logged out would loop: server closes it → reconnect → repeat). On open, `_onListen` sends an encrypted `AuthRequest`; the server replies with `AuthResponse` (per-user salt + server time).

**Reconnect:** every stream termination (`onCancel` / `onDone` / `onError`) funnels through `_onTerminated` → `_reconnect` (random 1–5s backoff). Three guard flags: `_disposed` (intentional close, no reconnect), `_reconnecting` (dedupe termination arriving in several callbacks at once), `_unauthenticated` (session rejected — suppress reconnect until the next explicit `connect()`; reset at the top of `connect()`).

**Auth rejection is trailers-only — this is the subtle part:** the server rejects an invalid session/user with a *trailers-only* gRPC response carrying `grpc-status: 16 (unauthenticated)`. grpc-dart does **not** deliver this to the response `onError`; it surfaces only as `_onCancel` plus the `response.headers` / `response.trailers` futures. `_onGrpcMetadata` inspects those maps for `grpc-status`, and `_onUnauthenticated` (idempotent) clears the local session (`sessions.logout()`), sets `_unauthenticated`, and emits `controllerAuth.add(false)`.

**Global auth redirect:** `lib/streams.dart` `Streams.controllerAuth` (broadcast `StreamController<bool>`) is the single auth-state channel. The root app widgets in `main.dart` subscribe to it and call `_router.go("/auth")` on `false`. This is the *only* place that redirects to auth on session loss — do not add per-screen listeners. All logout/rejection paths (`_onUnauthenticated`, `Auth.logoutRequest`, inactive-session `connect()`) converge on `controllerAuth.add(false)`.

## Database

`sqlite3mc` (SQLite Multiple Ciphers) via the `hooks.user_defines.sqlite3.source: sqlite3mc` entry in `pubspec.yaml`. Encryption password (60–100 random chars) stored in `FlutterSecureStorage`. Plain SQLite used in debug builds. `IS_DELETE_DATABASE` env flag wipes DB and key on next launch.

Schema (migration via `userVersion`, currently at version 1): `settingsDevice`, `users`, `sessions`, `contacts`. Foreign key cascades enabled.

## Authentication Flow

Two flows selected by phone number matching `PHONE_NUMBER_MODERATION_APPLICATION_STORE` env var:
1. **CallPassword (default):** phone entry → `AuthCallPasswordRequest` → stream for call completion → ECDH key exchange (X25519) → shared secret → session establishment
2. **SMS (moderation number only):** phone entry → `AuthSMSRequest` → SMS code entry screen (`/auth/sms`)

Yandex OAuth (`yandex_login_sdk`) integrated in `AuthCubit.signIn()`.

## i18n

Translation files in `lib/i18n/` (Russian + English). Usage:
- `context.t.keyName` — compile-time safe key
- `context.t[errorKey]` — dynamic key lookup (used for API error strings); returns `null` if key missing, fall back to `context.t.unknownError`

## Platform UI Convention

- `*_screen_material.dart` → Android; `*_screen_cupertino.dart` → iOS
- `Routers.material()` and `Routers.cupertino()` define separate route trees — keep routes in sync when adding screens
- App locked to portrait during auth flow
- Global text scaling: `TextScaler.linear(0.95)` applied at app root in both Material and Cupertino apps
- Cupertino theme color changes dynamically based on `SettingsDeviceColorTheme` stored in `MainCubit` (blue/green/purple)
