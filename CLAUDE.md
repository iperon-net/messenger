# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make gen      # protoc → lib/protobuf/, then build_runner (dart_mappable/envied), then slang i18n
make watch    # build_runner in watch mode during development
make lang     # slang i18n generation only
make build    # runs `make kmp` first, then release APK + App Bundle + IPA (obfuscated, split debug symbols)
make upload   # upload IPA to App Store via altool
make sql      # pull SQLite DB from connected Android device via adb
```

Run `make gen` after modifying any `.proto` files, annotated models (`dart_mappable`), `.env`, or translation files. Proto generation calls `protoc` directly (output `lib/protobuf/`, committed to the repo); `build_runner` is invoked with `--define=envied_generator:envied=path=.env` so `envied` reads the local `.env`.

## Architecture

Flutter messenger app (package: `net.iperon.messenger`) targeting Android (Material) and iOS (Cupertino) with separate UI implementations sharing the same BLoC/Cubit logic.

**Cubits and screens are separate trees.** Business/state logic lives in `lib/cubit/` (grouped by feature: `auth/`, `settings/`, `contacts/`, `home/`, plus root `main_cubit.dart` / `common_cubit.dart`); UI lives in `lib/screens/` (only `*_screen_material.dart` / `*_screen_cupertino.dart` files). `lib/screens.dart` is a barrel that re-exports every screen. Do not colocate cubits inside `lib/screens/`.

**Layer overview:**
- `lib/main.dart` — entry point; detects `Platform.isIOS` to select Material vs Cupertino app root; bootstraps DI and provides only the root-level cubits (`MainCubit`, `HomeCubit`, `ContactsCubit`) in `MultiBlocProvider`. Feature cubits (`AuthCubit`, `SettingsDeviceSessionsCubit`, `SettingsPrivateAndSecurityCubit`, …) are provided per-route in `routers.dart`.
- `lib/di.dart` — `get_it` service locator; `registerCommonDependencies()` / `unregisterCommonDependencies()` (called on logout). All registered as async singletons with `dependsOn`: `Logger` → `Utils`/`Crypto`/`Repositories`/`API` → `Routers`/`Services` → `Streams` → `Syncer`.
- `lib/api.dart` — gRPC channel to `staging.iperon.net:443`; `API.call()` wraps all gRPC calls, returns `""` on success or a localized i18n key string on failure; `callOptions()` injects `x-app-version` and `x-request-id` metadata
- `lib/routers.dart` — two separate `GoRouter` instances: `Routers.material()` and `Routers.cupertino()`; auth redirect built-in via `redirect` callback checking `sessions.getActive()`; wraps individual routes in `BlocProvider` for their feature cubit
- `lib/repositories/` — encrypted SQLite; `repositories.dart` uses `part` directives for `device_sessions.dart`, `sessions.dart`, `settings_device.dart`, `users.dart`, `cache.dart`
- `lib/services/` — business logic layer; `Services` facade with `part "auth.dart"`
- `lib/crypto/crypto.dart` — `Crypto` singleton (re-exported by `lib/crypto.dart`); X25519 ECDH shared-secret derivation, with `part "syncer.dart"` (syncer message framing/padding/encrypt/decrypt) and `part "voprf.dart"` (VOPRF client — see Crypto section)
- `lib/syncer/` — persistent bidirectional gRPC stream (see Syncer section)
- `lib/streams.dart` — `Streams` singleton owning `controllerAuth`, the single global auth-state channel
- `lib/protobuf/` — generated gRPC/proto Dart (committed); sources in `protos/` (`auth_v1`, `metadata_v1`, `models`, `syncer_v1`, and `protos/messages/*`)
- `lib/models/` — `dart_mappable` immutable value objects (barrel `lib/models.dart`)
- `lib/settings.dart` — `envied`-backed settings from `.env` file (database name, ECDH fingerprint, Yandex OAuth client ID, phone moderation number)
- `lib/constants.dart` — `Status` enum `{ initialization, loading, success }`

## State Management

**Pattern:** `flutter_bloc` Cubit with `dart_mappable` states (not Freezed).

- State classes annotated with `@MappableClass()`; generate `*.mapper.dart` files via `make gen`
- State updates via `state.copyWith(...)`; `Status` enum on each state for async tracking
- Root cubits (`MainCubit`, `HomeCubit`, `ContactsCubit`) are provided globally in `MultiBlocProvider` in `main.dart`; feature cubits are provided per-route in `routers.dart`
- Cubits initialize lazily: screens call `context.read<XCubit>().initialization()` from `initState()`
- `MainCubit` is the root-level cubit holding `SettingsDevice`, `User`, `Session`, and runtime permission statuses (contacts, notifications)
- BLoC observer (`talker_bloc_logger`) active in debug mode only

## API Communication

gRPC clients (`AuthClient`, `MetadataClient`, `SyncerClient`) generated into `lib/protobuf/` from the `protos/` sources. Error handling in `API.call()`:
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

Schema (migration via `userVersion`, currently at version 1): `settingsDevice`, `users`, `sessions`, `cache`, `deviceSessions`, `contacts`, `contactPhoneNumbers`. Foreign key cascades enabled. All table creation lives in one `if (userVersion == 0)` block in `repositories.dart`; bump `PRAGMA user_version` and add a migration branch when changing the schema.

## Authentication Flow

Two flows selected by phone number matching `PHONE_NUMBER_MODERATION_APPLICATION_STORE` env var:
1. **CallPassword (default):** phone entry → `AuthCallPasswordRequest` → stream for call completion → `AuthConfirmationRequest`/`Response` with ML-KEM-768 (Kyber768) key exchange (Ed25519-signed, fingerprint-pinned) → shared key + salt → session establishment
2. **SMS (moderation number only):** phone entry → `AuthSMSRequest` → SMS code entry screen (`/auth/sms`)

Yandex OAuth (`yandex_login_sdk`) integrated in `AuthCubit.signIn()`.

## Cryptography

The auth key exchange is **post-quantum ML-KEM-768 (Kyber768)**, not classical ECDH — done in `services/auth.dart` via `pqcrypto` (`PqcKem.kyber768`), *not* through the `Crypto` facade. The client generates two KEM keypairs (one for the shared key, one for the salt), sends the public keys in `AuthConfirmationRequest`, and `decapsulate`s the server's ciphertexts from `AuthConfirmationResponse`. Both ciphertexts are Ed25519-verified against the server's EdDSA public key, which is itself SHA-256 fingerprint-pinned to `Settings.publicKeyEdDSAFingerprint`.

`Crypto` (`lib/crypto/crypto.dart`) is a separate `get_it` singleton facade:
- **X25519 ECDH** (`sharedSecretKey`) — present but currently unused (no callers); the live auth flow uses ML-KEM above.
- **Syncer framing** (`part "syncer.dart"`, class `Syncer`) — `encode`/`decode` of syncer stream payloads: builds a `Header`, pads to a block size, and encrypts/decrypts messages by `SyncerMessageType` and sequence number.
- **VOPRF** (`part "voprf.dart"`, class `VOPRF`) — client implementation of RFC 9497 verifiable OPRF (Ristretto255-SHA512), used by the two-step-verification flow. It mirrors the Go server implementation at `/Users/kostya/GolandProjects/iperon/internal/crypto/voprf.go` (a registered additional working directory); keep the two in sync when touching the protocol. Flow: `setServerPublicKey` → `blind(input)` → send `blindedElement` → `finalize`.

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
