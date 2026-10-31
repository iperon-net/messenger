#!/usr/bin/env bash
# Номер сборки, общий для iOS, macOS и Android: N × 100 + попытка, где N —
# последнее число версии (0.0.589 → 589), попытка — github.run_attempt (1–99).
# 0.0.589 → 58901, перезапуск на том же теге → 58902.
#
#   scripts/build_number.sh <build-name> [attempt]
#
# Растёт с каждым тегом и влезает в предел Android versionCode (2 100 000 000).
# Прежняя схема (UTC-время yyMMddHHmm) в него не влезала.
# Когда перейдём на v0.X.0 / vX.Y.Z, формулу надо будет расширить (иначе
# номер упадёт): например X × 10⁶ + … — сравнивают его TestFlight, Sparkle и Play.
set -euo pipefail

BUILD_NAME="${1:?usage: $0 <build-name> [attempt]}"
ATTEMPT="${2:-1}"

N="${BUILD_NAME##*.}"
if ! [[ "$N" =~ ^[0-9]+$ ]] || ! [[ "$ATTEMPT" =~ ^[0-9]+$ ]] || [ "$ATTEMPT" -lt 1 ] || [ "$ATTEMPT" -gt 99 ]; then
  echo "build_number.sh: bad build name '$BUILD_NAME' or attempt '$ATTEMPT'" >&2
  exit 1
fi

echo $((10#$N * 100 + 10#$ATTEMPT))
