#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <dpi> <input pdf> <output pdf>"
    exit 1
fi


BUILDDIR=/tmp/rasterize

mkdir -p $BUILDDIR
rm -f $BUILDDIR/*

dpi=$1
file=$2
outputfile=$3

echo "Processing ${file} with ${dpi} dpi..."

echo "Separating file by pages to parallelize processing..."
pdfseparate "$file" $BUILDDIR/input-page%d.pdf

echo "Converting to JPEG..."
for pdf_file in $BUILDDIR/*.pdf; do
    base=$(basename "$pdf_file")
    pdftoppm -progress -singlefile -jpeg -r "$dpi" "$pdf_file" "$BUILDDIR/${base%.*}"&
done
wait

echo "Rasterizing..."
for jpg_file in $BUILDDIR/*.jpg; do
    base=$(basename "$jpg_file")
    vtracer --input "$jpg_file" --output "$BUILDDIR/${base%.*}.svg" --colormode bw --mode polygon
done
wait

echo "Converting back to PDF..."
for svg_file in $BUILDDIR/*.svg; do
    base=$(basename "$svg_file")
    cairosvg "$svg_file" -o "$BUILDDIR/${base%.*}.rasterized.pdf"
done
wait

echo "Concatenating the PDF..."
pdfunite $BUILDDIR/*.rasterized.pdf "$BUILDDIR/rasterized.pdf"

echo "Making sure PDF is compatible..."
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$outputfile" "$BUILDDIR/rasterized.pdf"

echo "Done, output is in $outputfile"
