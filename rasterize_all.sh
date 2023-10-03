echo $BASH_ENV

OUTPUT_FOLDER=out/

mkdir -p $OUTPUT_FOLDER

for f in *.pdf; do
    base=$(basename "$f")
    rasterize_pdf 600 "$f" "$OUTPUT_FOLDER/$base"
done
