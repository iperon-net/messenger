# Iperon messenger

## Git hooks (pre-commit)

This repo uses [`dart_pre_commit`](https://pub.dev/packages/dart_pre_commit) to
run `dart format` and `dart analyze` on staged files before each commit —
mirroring the CI checks in `.github/workflows/build_and_publish.yaml` so problems are
caught locally, before pushing.

The hook lives in `.githooks/pre-commit`, but git does **not** clone the
`core.hooksPath` setting. After cloning, enable it once:

```bash
flutter pub get
git config core.hooksPath .githooks
```

Configuration lives under the `dart_pre_commit:` key in `pubspec.yaml`. To run
the checks manually: `dart run dart_pre_commit`.
