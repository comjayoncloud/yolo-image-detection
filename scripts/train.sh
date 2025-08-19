#!/usr/bin/env bash
set -e
EXP=${1:?Usage: ./scripts/train.sh <img10|img50|img100> [epochs] [imgsz]}
EPOCHS=${2:-50}
IMGSZ=${3:-640}

echo "[TRAIN] $EXP  epochs=$EPOCHS  imgsz=$IMGSZ"
yolo detect train \
  data=datasets/$EXP/data.yaml \
  model=yolov8n.pt \
  epochs=$EPOCHS imgsz=$IMGSZ \
  project=runs/train name=${EXP} exist_ok=True

mkdir -p weights/$EXP
cp runs/train/${EXP}/weights/best.pt weights/${EXP}/best.pt
echo "[DONE] weights/${EXP}/best.pt"