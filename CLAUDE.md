# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make gen      # protobuf + build_runner (freezed/json_serializable) + slang i18n generation
make watch    # build_runner in watch mode during development
make build    # release APK + App Bundle with obfuscation and debug symbols
```

Run `make gen` after modifying any `.proto` files, Freezed models, or translation files.

## Architecture

Flutter messenger app targeting Android (Material) and iOS (Cupertino) with separate UI implementations sharing the same BLoC logic.

**Layer overview:**
- `lib/main.dart` — entry point, platform detection, dependency injection bootstrap
- `lib/di.dart` — `get_it` service locator, registers all singletons with `registerSingletonAsync` and dependency ordering via `dependsOn`
- `lib/api.dart` — gRPC channel to `staging.iperon.net:443`, metadata interceptor (injects `x-app-version` and `x-request-id`)
- `lib/routers.dart` — `go_router` navigation tree
- `lib/screens/` — one folder per screen; each contains `*_cubit.dart`, `*_state.dart`, `*_screen_material.dart`, `*_screen_cupertino.dart`
- `lib/repositories/` — SQLCipher-encrypted SQLite access layer
- `lib/models/` — Freezed immutable value objects with JSON serialization

## State Management

**Pattern:** `flutter_bloc` Cubit (event-less BLoC).

- State defined with `@freezed` annotation; updates via `state.copyWith(...)`
- Status enum `{ initialization, loading, success }` on each state for async tracking
- Cubits are initialized lazily: screens call `context.read<XCubit>().initialization()` from `initState()`
- BLoC observer active in debug mode only

## API Communication

gRPC clients (`AuthClient`, `MetadataClient`) generated from protobuf. All calls go through `API.call()`:
- Returns `""` on success
- Returns a localized error key string on failure (gRPC status codes mapped to i18n keys)
- Streaming responses (`ResponseStream<T>`) used for real-time events (e.g., call password completion)

## Database

SQLCipher-encrypted SQLite. Password is a random 60–100 character string stored in `FlutterSecureStorage`. Plain SQLite used in debug builds (`IS_DELETE_DATABASE` flag also available for dev resets). Foreign key constraints enabled at pragma level.

## Authentication Flow

1. Phone number entry → server returns call session
2. Streaming listener watches for call password completion in real time
3. Two-stage confirmation: ECDH key exchange → shared secret → session establishment
4. Device fingerprint sent: OS type/model/version, app build info

## Code Generation

| Generator | Purpose |
|---|---|
| `freezed` | Immutable data classes |
| `json_serializable` | JSON encoding/decoding |
| Protobuf / `build_runner` | gRPC stubs |
| `slang` | i18n (Russian + English) |
| `envied` | `.env` environment variables |

Always run `make gen` after touching any annotated models or `.proto` files.

## Platform UI Convention

- `*_screen_material.dart` → Android; `*_screen_cupertino.dart` → iOS
- App locked to portrait during auth flow
- Global text scaling: `TextScaler.linear(0.95)` applied at app root
