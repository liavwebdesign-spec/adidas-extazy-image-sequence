#!/usr/bin/env bash
# Rebuild the image sequences from the source videos.
# Expects 1.mp4 .. 10.mp4 and the opening still in this directory, plus ffmpeg on PATH.
set -euo pipefail

SCENES=10
OPENING="${1:-תמונה פותחת.png}"

for i in $(seq 1 $SCENES); do
  echo "scene $i"
  # full quality: what the site settles on
  mkdir -p "site/frames/$i"
  ffmpeg -v error -y -i "$i.mp4" -vf "scale=1280:720" -q:v 3 "site/frames/$i/%03d.jpg"
  # proxy: loaded first so scrubbing always has a frame on slow connections
  mkdir -p "site/frames-lo/$i"
  ffmpeg -v error -y -i "$i.mp4" -vf "scale=640:360" -q:v 9 "site/frames-lo/$i/%03d.jpg"
done

ffmpeg -v error -y -i "$OPENING" -vf "scale=1920:-1" -q:v 3 site/opening.jpg
echo "done: $(find site/frames -name '*.jpg' | wc -l) full + $(find site/frames-lo -name '*.jpg' | wc -l) proxy frames"
