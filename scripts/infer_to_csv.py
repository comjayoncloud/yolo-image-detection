from ultralytics import YOLO
from pathlib import Path
import pandas as pd
import argparse

EXTS = {".jpg",".jpeg",".png",".bmp",".tif",".tiff"}

p = argparse.ArgumentParser()
p.add_argument("--exp", required=True, choices=["img10","img50","img100"])
p.add_argument("--src", default="test_images")
p.add_argument("--imgsz", type=int, default=640)
p.add_argument("--conf", type=float, default=0.25)
args = p.parse_args()

EXP = args.exp
WEIGHT = Path(f"weights/{EXP}/best.pt")
IN_DIR = Path(args.src)
OUT_DIR = Path(f"reports/{EXP}")
(OUT_DIR/"vis").mkdir(parents=True, exist_ok=True)

model = YOLO(str(WEIGHT))
res = model.predict(
    source=str(IN_DIR),
    imgsz=args.imgsz, conf=args.conf,
    save=True, project=str(OUT_DIR), name="vis",
    exist_ok=True, verbose=False
)

rows = []
for r in res:
    img_name = Path(r.path).name
    for b in r.boxes:
        x1,y1,x2,y2 = [float(v) for v in b.xyxy[0].tolist()]
        rows.append({
            "image": img_name,
            "cls_id": int(b.cls.item()),
            "conf": float(b.conf.item()),
            "x1": round(x1), "y1": round(y1), "x2": round(x2), "y2": round(y2),
        })

# detections.csv
cols = ["image","cls_id","conf","x1","y1","x2","y2"]
df = pd.DataFrame(rows, columns=cols)
df.to_csv(OUT_DIR/"detections.csv", index=False)

# summary.csv (모든 입력 이미지를 포함, 미검출은 0)
all_imgs = sorted([p.name for p in IN_DIR.iterdir() if p.suffix.lower() in EXTS])
if df.empty:
    sum_df = pd.DataFrame({"image": all_imgs, "num_dets": [0]*len(all_imgs)})
else:
    counts = df.groupby("image").size().reindex(all_imgs, fill_value=0).reset_index(name="num_dets")
    sum_df = counts
sum_df.to_csv(OUT_DIR/"summary.csv", index=False)

print(f"[DONE] vis: {OUT_DIR/'vis'}")
print(f"[DONE] CSV: {OUT_DIR/'detections.csv'}, {OUT_DIR/'summary.csv'}")