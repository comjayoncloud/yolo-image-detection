# YOLO Image Detection (bowl/tray/spill)

간단히 라벨링 -> 학습 -> 추론까지 재현 가능한 YOLOv8 실험 리포지토리.

- 대상 클래스: `bowl`, `tray`, `spill`
- 엔진: Ultralytics YOLOv8
- OS: macOS 기준 (CPU 동작, GPU 있으면 자동 사용)

## 폴더 구조

```text
yolo-image-detection/
├─ datasets/                      # 데이터셋(필수, 라벨 포함)
│  ├─ img10/
│  │  ├─ images/{train,val}/
│  │  └─ labels/{train,val}/     # YOLO txt: class cx cy w h (0~1 정규화)
│  ├─ img50/
│  └─ img100/
├─ scripts/
│  ├─ train.sh                    # 학습: ./scripts/train.sh img10 50 640
│  └─ infer.sh                    # 추론: ./scripts/infer.sh img10 test_images 640 0.25
├─ weights/                       # 학습된 가중치(best.pt) 저장(선택)
├─ test_images/                   # 임의 테스트 이미지(선택)
├─ classes.txt                    # 라벨 클래스: bowl, tray, spill
├─ yolov8n.pt                     # YOLOv8n base (없으면 자동 다운로드 가능)
├─ labelImg                       # 라벨링 (선택)
└─ launch_labelimg.sh             # labelImg 설치/실행 스크립트(선택)
```

## 1) 환경 설정 (macOS)

```text
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install ultralytics opencv-python pandas
```

## 2) 라벨링(선택)

```text
git clone https://github.com/tzutalin/labelImg.git
source .venv/bin/activate
pip install pyqt5 lxml
./launch_labelimg.sh
```

## 3) 학습

```text
# {img10 | img50 | img100 | onlyspill_41 }, epochs, imgsz, ?, earlystopping
./scripts/train.sh onlyspill_41 100 640 8 0
```

## 4) 추론

```text
# {img10 | img50 | img100}, src 폴더, imgsz, conf
./scripts/infer.sh img10 test_images/A 640 0.25
```
