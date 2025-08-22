#!/usr/bin/env bash
set -euo pipefail

# 사용: ./scripts/train.sh <img10|img50|img100> [epochs] [imgsz] [batch] [patience] [model]
# 예시: ./scripts/train.sh img10 50 640 8 15 yolov8n.pt

EXP="${1:?Usage: ./scripts/train.sh <img10|img50|img100> [epochs] [imgsz] [batch] [patience] [model]}"
EPOCHS="${2:-50}"
IMGSZ="${3:-640}"
BATCH="${4:-8}"
PATIENCE="${5:-15}"

# 모델 선택 (yolov8n.pt < yolov8s.pt < yolov8m.pt < yolov8l.pt < yolov8x.pt)
MODEL="${6:-yolov8m.pt}"


DATA_DIR="datasets/$EXP"
YAML="$DATA_DIR/data.yaml"
SAVE_DIR="runs/train/$EXP"

echo "[TRAIN] exp=$EXP epochs=$EPOCHS imgsz=$IMGSZ batch=$BATCH patience=$PATIENCE model=$MODEL"

# sanity check
if [[ ! -f "$YAML" ]]; then
  echo "❌ data.yaml not found: $YAML"; exit 1
fi
rm -f "$DATA_DIR"/*.cache || true

# train
yolo task=detect mode=train \
  model="$MODEL" \
  data="$YAML" \
  epochs="$EPOCHS" \
  batch="$BATCH" \
  imgsz="$IMGSZ" \
  patience="$PATIENCE" \
  project="runs/train" name="$EXP" exist_ok=True

# keep best.pt
mkdir -p "weights/$EXP"
if [[ -f "$SAVE_DIR/weights/best.pt" ]]; then
  cp "$SAVE_DIR/weights/best.pt" "weights/$EXP/best.pt"
  echo "[DONE] -> weights/$EXP/best.pt"
else
  echo "⚠️ best.pt not found in $SAVE_DIR/weights/"
fi