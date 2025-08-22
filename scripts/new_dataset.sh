#!/usr/bin/env bash
set -euo pipefail
# 사용법: ./scripts/new_dataset.sh <exp> [auto|onlyspill|bts]
# 규칙: onlyspill_* -> 1클래스(spill), 그 외 -> 3클래스(bowl,tray,spill)

EXP="${1:?Usage: $0 <exp> [auto|onlyspill|bts] }"
MODE="${2:-auto}"
[[ "$MODE" == auto && "$EXP" == onlyspill_* ]] && MODE=onlyspill
[[ "$MODE" == auto ]] && MODE=bts

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR="${ROOT}/datasets/${EXP}"
mkdir -p "$DIR"/{images,labels}/{train,val}
touch "$DIR"/images/train/.gitkeep "$DIR"/images/val/.gitkeep \
      "$DIR"/labels/train/.gitkeep "$DIR"/labels/val/.gitkeep

if [[ "$MODE" == onlyspill ]]; then NC=1; NAMES="[spill]"; else NC=3; NAMES="[bowl, tray, spill]"; fi

cat > "$DIR/data.yaml" <<EOF
path: datasets/${EXP}
train: images/train
val: images/val
nc: ${NC}
names: ${NAMES}
EOF

echo "[DONE] scaffold -> datasets/${EXP}"