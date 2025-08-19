#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
source .venv/bin/activate
# 첫 번째 인자: 처음 열 폴더(원하면 바꿔도 됨)
IMG_DIR="./datasets/img10/images/train"
# 두 번째 인자: 사전 클래스 파일(항상 고정)
python labelImg/labelImg.py "$IMG_DIR" "./classes.txt"