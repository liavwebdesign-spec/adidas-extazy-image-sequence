#!/usr/bin/env bash
# Rebuild the image sequences from the source videos.
# Expects 1.mp4 .. 10.mp4 and the opening still in this directory, plus ffmpeg on PATH.
set -euo pipefail

SCENES=10
OPENING="${1:-תמונה פותחת.png}"

for i in $(seq 1 $SCENES); do
  mkdir -p "site/frames/$i"
  echo "scene $i"
  ffmpeg -v error -y -i "$i.mp4" -vf "scale=1280:720" -q:v 3 "site/frames/$i/%03d.jpg"
done

ffmpeg -v error -y -i "$OPENING" -vf "scale=1920:-1" -q:v 3 site/opening.jpg
echo "done: $(find site/frames -name '*.jpg' | wc -l) frames"
