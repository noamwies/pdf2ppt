#!/bin/bash

# Script to convert PDF file to JPG images
#
# Dependencies:
# * pdftk
# * imagemagick
# python3 with tqdm, python-pptx packages
# based on from https://gist.github.com/yura/670974

PDF=$1

echo "Processing $PDF"
DIR=`basename "$1" .pdf`

mkdir "$DIR"

echo '  Splitting PDF file to pages...'
pdftk "$PDF" burst output "$DIR"/%04d.pdf
pdftk "$PDF" dump_data output "$DIR"/metadata.txt

echo '  Converting pages to JPEG files...'
for i in "$DIR"/*.pdf; do
  # convert -colorspace RGB -interlace none -density 300x300 -quality 100 "$i" "$DIR"/`basename "$i" .pdf`.jpg
  # convert -colorspace RGB -interlace none -quality 100 "$i" "$DIR"/`basename "$i" .pdf`.jpg
  convert -colorspace RGB -interlace none -quality 75 "$i" "$DIR"/`basename "$i" .pdf`.jpg
done
echo '  Converting JPEG files to PPTX...'
python3 jpg2ppt.py --output_path="$DIR.pptx"  --images_regex="$DIR/*.jpg"
echo 'All done'
