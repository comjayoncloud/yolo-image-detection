#!/usr/bin/env bash
set -euo pipefail

# 사용: ./scripts/infer.sh <img10|img50|img100> [src_dir] [imgsz] [conf]
EXP=${1:?Usage: ./scripts/infer.sh <img10|img50|img100> [src_dir] [imgsz] [conf]}
SRC=${2:-test_images}
IMGSZ=${3:-640}
CONF=${4:-0.25}

echo "[INFER] exp=$EXP src=$SRC imgsz=$IMGSZ conf=$CONF"

WEIGHT="weights/$EXP/best.pt"
OUT_DIR="reports/$EXP"

# 1) 시각화 + txt 예측
yolo detect predict \
  model="$WEIGHT" \
  source="$SRC" \
  imgsz="$IMGSZ" \
  conf="$CONF" \
  save=True save_txt=True save_conf=True \
  project="$OUT_DIR" name="vis" exist_ok=True

# 2) CSV 생성
python scripts/infer_to_csv.py --exp "$EXP"

echo "[DONE] vis: $OUT_DIR/vis"
echo "[DONE] CSV: $OUT_DIR/detections.csv, $OUT_DIR/summary.csv"