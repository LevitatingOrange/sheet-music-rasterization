# Sheet music conversion

## The what
This repo contains a small script (`rasterize_pdf.sh`), that can be used to process a black and white PDF that
is comprised of images into a much smaller and rasterized PDF. It uses [Vtracer](https://github.com/visioncortex/vtracer)

## They why
Henle's digital library of sheet music is great, but the exported/printed PDFs are comprised of images of each bars. This makes the creation of PDFs take ages (though that I can't fix), produces large files and results in slow display of the sheet music on my Remarkable 2, on some PDF viewers it can't even be viewed at all.

## The how
Easiest way is the provided docker image (to skip dependency installation), build it:

```sh
sudo docker build . -t sheet_music_conv --build-arg USER="$USER" --build-arg UID="$UID"
```

and run it, mounting a folder to `/home/$USER/docs` that contains the PDF files you want to be rasterized. Rasterized output is then in the subfolder `out`, e.g.:

```sh
sudo docker run --rm -it -v $(pwd):/home/$USER/docs sheet_music_conv
```

This procedure uses sensible defaults, but make sure to look into each script to find ways to reduce file size, optimize quality, as you wish.


# TODOS
* [ ] At github actions so that image is build and available for everyone.
