#!/usr/bin/env bash
# Сборка и выпуск macOS-клиента (docs/plans/desktop-client.md §10):
# flutter build → подпись Developer ID (hardened runtime) → нотаризация + staple
# приложения → DMG → подпись, нотаризация + staple DMG → EdDSA-подпись Sparkle →
# appcast → GitHub Release (раздаёт nginx на download.iperon.net).
#
#   scripts/macos_release.sh <build-name> [build-number]
#
# Каждый шаг включается своими переменными, без них — пропускается (локально
# можно собрать неподписанный DMG только для своего Mac):
#   MACOS_SIGN_IDENTITY   — «Developer ID Application: … (BPXUY5LQZC)»; без неё
#                           дальше подписи ничего не идёт (нотаризовать нечего).
#   нотаризация           — NOTARY_PROFILE (локально: `xcrun notarytool
#                           store-credentials`) или ASC_KEY_ID + ASC_ISSUER_ID +
#                           ASC_KEY_PATH (.p8, CI).
#   SPARKLE_ED_KEY_FILE   — приватный EdDSA-ключ Sparkle (CI); локально без неё
#                           sign_update берёт ключ из связки ключей. Подпись и
#                           appcast — только для нотаризованной сборки.
#   GITHUB_RELEASE_REPO + GH_TOKEN — публикация (релиз v<версия>, тег уже есть).
#
# Выпуск для всех — только версия X.Y.0 (тег v0.1.0, v1.2.0): её релиз
# становится последним (latest) — Iperon.dmg на сайте и appcast, установленные
# копии обновятся. Остальные (v0.0.541 — обычные сборки вместе с TestFlight) —
# pre-release: только Iperon-<версия>.dmg для тестеров по прямой ссылке.
# RELEASE=1/0 — переопределить.
#
# Результат — build/macos/release/: Iperon-<версия>.dmg, Iperon.dmg и appcast-macos.xml.
set -euo pipefail

BUILD_NAME="${1:?usage: $0 <build-name> [build-number]}"
# Номер сборки = CFBundleVersion = sparkle:version: Sparkle сравнивает его, он
# обязан расти. Общий для всех платформ (scripts/build_number.sh): на CI его
# передаёт job Version, локально — из версии с попыткой 1.
BUILD_NUMBER="${2:-$("$(dirname "$0")/build_number.sh" "$BUILD_NAME")}"

if [ -z "${RELEASE:-}" ]; then
  if [[ "$BUILD_NAME" =~ ^[0-9]+\.[0-9]+\.0$ ]]; then RELEASE=1; else RELEASE=0; fi
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

APP="build/macos/Build/Products/Release/Iperon.app"
OUT="build/macos/release"
DMG="$OUT/Iperon-$BUILD_NAME.dmg"
ENTITLEMENTS="macos/Runner/Release.entitlements"
SPARKLE_BIN="macos/Pods/Sparkle/bin"
DOWNLOAD_HOST="https://download.iperon.net"
MIN_SYSTEM="14.0"

rm -rf "$OUT"
mkdir -p "$OUT"

echo "==> flutter build macos $BUILD_NAME ($BUILD_NUMBER)"
# Release на macOS — universal (arm64 + x86_64).
flutter build macos --release --build-name="$BUILD_NAME" --build-number="$BUILD_NUMBER"
lipo -archs "$APP/Contents/MacOS/Iperon"

# Повтор codesign: сервер меток времени Apple (`--timestamp`) иногда
# отвечает «The timestamp service is not available» — через полминуты проходит.
codesign_retry() {
  local attempt
  for attempt in 1 2 3 4 5; do
    codesign "$@" && return 0
    [ "$attempt" = 5 ] && return 1
    echo "    codesign: попытка $attempt не удалась, повтор через 30 с"
    sleep 30
  done
}

sign() {
  codesign_retry --force --timestamp --options runtime --sign "$MACOS_SIGN_IDENTITY" "$@"
}

# notarize <файл .zip/.dmg>: отправить и дождаться ответа Apple; не Accepted —
# печатаем журнал и падаем.
notarize() {
  local auth
  if [ -n "${NOTARY_PROFILE:-}" ]; then
    auth=(--keychain-profile "$NOTARY_PROFILE")
  else
    auth=(--key "${ASC_KEY_PATH:?}" --key-id "${ASC_KEY_ID:?}" --issuer "${ASC_ISSUER_ID:?}")
  fi
  echo "==> notarytool submit $1"
  local result id status
  result="$(xcrun notarytool submit "$1" "${auth[@]}" --wait --output-format plist)"
  id="$(plutil -extract id raw - <<<"$result")"
  status="$(plutil -extract status raw - <<<"$result")"
  echo "    $id: $status"
  if [ "$status" != "Accepted" ]; then
    xcrun notarytool log "$id" "${auth[@]}" || true
    exit 1
  fi
}

can_notarize() {
  [ -n "${NOTARY_PROFILE:-}" ] || { [ -n "${ASC_KEY_ID:-}" ] && [ -n "${ASC_ISSUER_ID:-}" ] && [ -n "${ASC_KEY_PATH:-}" ]; }
}

NOTARIZED=0
if [ -n "${MACOS_SIGN_IDENTITY:-}" ]; then
  echo "==> codesign ($MACOS_SIGN_IDENTITY)"
  # Изнутри наружу. Sparkle — по его инструкции (XPC-сервисы, Autoupdate,
  # Updater.app), у Downloader.xpc сохраняем его entitlements.
  SPARKLE="$APP/Contents/Frameworks/Sparkle.framework"
  sign "$SPARKLE/Versions/B/XPCServices/Installer.xpc"
  sign --preserve-metadata=entitlements "$SPARKLE/Versions/B/XPCServices/Downloader.xpc"
  sign "$SPARKLE/Versions/B/Autoupdate"
  sign "$SPARKLE/Versions/B/Updater.app"
  sign "$SPARKLE"
  for f in "$APP"/Contents/Frameworks/*; do
    [ "$f" = "$SPARKLE" ] && continue
    sign "$f"
  done
  sign --entitlements "$ENTITLEMENTS" "$APP"
  codesign --verify --deep --strict --verbose=2 "$APP"

  if can_notarize; then
    # Приложение отдельно: staple на .app — Gatekeeper не ходит в сеть и после
    # копирования из DMG / обновления Sparkle.
    ditto -c -k --keepParent "$APP" "$OUT/Iperon.zip"
    notarize "$OUT/Iperon.zip"
    rm "$OUT/Iperon.zip"
    xcrun stapler staple "$APP"
    NOTARIZED=1
  else
    echo "==> нотаризация пропущена (нет NOTARY_PROFILE / ASC_*)"
  fi
else
  echo "==> подпись пропущена (нет MACOS_SIGN_IDENTITY): DMG откроется только на этом Mac"
fi

echo "==> DMG"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
ditto "$APP" "$STAGE/Iperon.app"
ln -s /Applications "$STAGE/Applications"
hdiutil create -volname "Iperon" -srcfolder "$STAGE" -fs HFS+ -format UDZO -ov "$DMG"

if [ -n "${MACOS_SIGN_IDENTITY:-}" ]; then
  codesign_retry --force --timestamp --sign "$MACOS_SIGN_IDENTITY" "$DMG"
  if [ "$NOTARIZED" = 1 ]; then
    notarize "$DMG"
    xcrun stapler staple "$DMG"
    spctl --assess --type open --context context:primary-signature --verbose=2 "$DMG"
  fi
fi

if [ "$NOTARIZED" != 1 ]; then
  echo "==> готово (без appcast): $DMG"
  exit 0
fi

KEY_ARGS=()
if [ -n "${SPARKLE_ED_KEY_FILE:-}" ]; then
  KEY_ARGS=(--ed-key-file "$SPARKLE_ED_KEY_FILE")
elif [ "${CI:-}" = "true" ]; then
  # В CI связки с ключом нет — без секрета appcast не собрать.
  echo "==> готово (без appcast, нет SPARKLE_ED_KEY_FILE): $DMG"
  exit 0
fi
echo "==> Sparkle: подпись и appcast"
# ${a[@]+…} — пустой массив под set -u в bash 3.2 (системный на macOS).
SIGNATURE="$("$SPARKLE_BIN/sign_update" ${KEY_ARGS[@]+"${KEY_ARGS[@]}"} -p "$DMG")"
LENGTH="$(stat -f%z "$DMG")"
DMG_URL="$DOWNLOAD_HOST/macos/$(basename "$DMG")"
PUB_DATE="$(LC_ALL=C date -u '+%a, %d %b %Y %H:%M:%S +0000')"

# Только последняя версия: Sparkle ставит её поверх любой старой.
cat >"$OUT/appcast-macos.xml" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
  <channel>
    <title>Iperon</title>
    <item>
      <title>$BUILD_NAME</title>
      <pubDate>$PUB_DATE</pubDate>
      <sparkle:version>$BUILD_NUMBER</sparkle:version>
      <sparkle:shortVersionString>$BUILD_NAME</sparkle:shortVersionString>
      <sparkle:minimumSystemVersion>$MIN_SYSTEM</sparkle:minimumSystemVersion>
      <enclosure url="$DMG_URL" length="$LENGTH" type="application/octet-stream" sparkle:edSignature="$SIGNATURE"/>
    </item>
  </channel>
</rss>
EOF

if [ -z "${GITHUB_RELEASE_REPO:-}" ]; then
  echo "==> готово (без публикации, нет GITHUB_RELEASE_REPO): $OUT"
  exit 0
fi

# Публикация — GitHub Release v<версия> в GITHUB_RELEASE_REPO (gh, токен в
# GH_TOKEN): DMG и appcast из раннера GitHub в Cloud.ru S3 не доходили —
# крупные передачи замирали на ~16 минутах. Наружу файлы раздаёт nginx
# download.iperon.net, забирая их из релизов и кэшируя (сервер,
# docs/nginx/download.iperon.net.conf): `/macos/appcast.xml` и `/macos/Iperon.dmg` —
# из последнего релиза (latest), `/macos/Iperon-<версия>.dmg` — из релиза версии.
# Не выпуск для всех — pre-release: latest на него не переключается, appcast и
# Iperon.dmg у клиентов прежние, DMG версии доступен тестерам по ссылке.
TAG="v$BUILD_NAME"
cp "$DMG" "$OUT/Iperon.dmg"
echo "==> GitHub Release $GITHUB_RELEASE_REPO $TAG"
FLAGS=(--latest)
if [ "$RELEASE" != 1 ]; then
  FLAGS=(--prerelease --latest=false)
fi
# Релиз версии общий для платформ (позже — и Windows): кто первый, тот создаёт,
# остальные дописывают файлы. Тег должен уже быть (--verify-tag).
if gh release view "$TAG" --repo "$GITHUB_RELEASE_REPO" >/dev/null 2>&1 ||
  ! gh release create "$TAG" --repo "$GITHUB_RELEASE_REPO" --verify-tag "${FLAGS[@]}" \
    --title "Iperon $BUILD_NAME" --notes "Iperon $BUILD_NAME" "$DMG" "$OUT/Iperon.dmg"; then
  gh release upload "$TAG" --repo "$GITHUB_RELEASE_REPO" --clobber "$DMG" "$OUT/Iperon.dmg"
fi
# appcast — последним: клиенты увидят версию, только когда DMG уже лежит.
gh release upload "$TAG" --repo "$GITHUB_RELEASE_REPO" --clobber "$OUT/appcast-macos.xml"
# Релиз мог создать Android (_deploy_android.yaml — всегда pre-release):
# latest / pre-release выставляем здесь, когда appcast уже лежит.
if [ "$RELEASE" = 1 ]; then
  gh release edit "$TAG" --repo "$GITHUB_RELEASE_REPO" --prerelease=false --latest
else
  gh release edit "$TAG" --repo "$GITHUB_RELEASE_REPO" --prerelease --latest=false
fi

echo "==> готово: $DMG_URL"
