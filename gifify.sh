#!/usr/bin/env bash

function printHelpAndExit {
cat <<EOF
Usage:
  gifify [options] input-file output-file

Options: (all optional)
  -c value  Crop the input from the top left of the image, i.e. 640:480
  -C        Conserve memory by writing frames to disk (slower)
  -F        Fast mode produces results faster, at lower quality
  -o value  The output file
  -r value  Set the output framerate (default 10)
  -s value  Set the speed modifier (default 1)
            NOTE: GIFs max out at 100fps depending on platform. For consistency,
            ensure that FPSxSPEED is not > ~60!
  -p value  Scale the output, e.g. 320:240

Example:
  gifify -c 240:80 -o my-gif -x my-movie.mov
EOF
exit $1
}

noupload=0
fps=10
speed=1
fast=0
useio=0

OPTERR=0

while getopts "c:o:p:r:s:FCh" opt; do
  case $opt in
    c) crop=$OPTARG;;
    C) useio=1;;
    F) fast=1;;
    h) printHelpAndExit 0;;
    o) outfile=$OPTARG;;
    p) scale=$OPTARG;;
    r) fps=$OPTARG;;
    s) speed=$OPTARG;;
    *) printHelpAndExit 1;;
  esac
done

shift $(( OPTIND - 1 ))

infile="$1"
if [ -z "$outfile" ]; then
  outfile="$2"
fi

if [ -z "$outfile" ]; then
  outfile="${infile}.gif"
fi

if [ -z "$infile" ]; then printHelpAndExit 1; fi

if [ $crop ]; then
  crop="crop=${crop}:0:0"
else
  crop=
fi

if [ $scale ]; then
  scale="scale=${scale}"
else
  scale=
fi

if [ $scale ] || [ $crop ]; then
  filter="-vf $scale$crop"
else
  filter=
fi

# -delay uses time per tick (a tick defaults to 1/100 of a second)
# so 60fps == -delay 1.666666 which is rounded to 2 because convert
# apparently stores this as an integer. To animate faster than 60fps,
# you must drop frames, meaning you must specify a lower -r. This is
# due to the GIF format as well as GIF renderers that cap frame delays
# < 3 to 3 or sometimes 10. Source:
# http://humpy77.deviantart.com/journal/Frame-Delay-Times-for-Animated-GIFs-214150546
delay=$(bc -l <<< "100/$fps/$speed")

if [ $useio -ne 1 ]; then
  if [ $fast -ne 1 ]; then
    ffmpeg -loglevel panic -i "$infile" $filter -r $fps -f image2pipe -vcodec ppm - | convert +dither -layers Optimize -delay $delay - gif:- | gifsicle --optimize=3 - -o "$outfile"
  else
    # gifsicle accepts only int values for delay
    delay=$(( 100 / $fps / $speed ))
    ffmpeg -loglevel panic -i "$infile" $filter -r $fps -pix_fmt rgb24 -f gif - | gifsicle --optimize=3 --delay=${delay} - -o "$outfile"
  fi
else
  temp=$(mktemp /tmp/tempfile.XXXXXXXXX)
  ffmpeg -loglevel panic -i "$infile" $filter -r $fps -f image2pipe -vcodec ppm - >> "$temp"
  cat "$temp" | convert +dither -layers Optimize -delay $delay - gif:- | gifsicle --optimize=3 - -o "$outfile"
  rm "$temp"
fi
