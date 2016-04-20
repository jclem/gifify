#!/bin/bash

function printHelpAndExit {
  echo 'Usage:'
  echo '  gifify [options] filename'
  echo ''
  echo 'Options: (all optional)'
  echo '  c CROP:      The x and y crops, from the top left of the image, i.e. 640:480'
  echo '  o OUTPUT:    The basename of the file to be output (default "output")'
  echo '  r FPS@SPEED: With 60@1.5, output at 60FPS at a speed of 1.5x the'
  echo '               source material. NOTE: It is best to keep FPSxSPEED'
  echo '               below approximately 60.'
  echo '  p SCALE:     Rescale the output, e.g. 320:240'
  echo '  x:           Remove the original file and resulting .gif once the script is complete'
  echo ''
  echo 'Example:'
  echo '  gifify -c 240:80 -o my-gif my-movie.mov'
  exit $1
}

fpsspeed='10@1'

OPTERR=0

while getopts 'c:o:p:r:s:' opt; do
  case $opt in
    c) crop=$OPTARG;;
    h) printHelpAndExit 0;;
    o) output=$OPTARG;;
    r) fpsspeed=$OPTARG;;
    p) scale=$OPTARG;;
    *) printHelpAndExit 1;;
  esac
done

shift $(( OPTIND - 1 ))

filename=$1

if [ -z ${output} ]; then
  output=$filename
fi

if [ -z "$filename" ]; then printHelpAndExit 1; fi

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

# -delay uses time per tick (a tick defaults to 1/100 of a second), so 60fps ==
# -delay 1.666666 which is rounded to 2 because convert apparently stores this
# as an integer.
#
# To animate faster than 60fps, you must drop frames, meaning you must specify
# a lower -r. This is due to the GIF format as well as GIF renderers that cap
# frame delays < 3 to 3 or sometimes 10. Source:
# http://humpy77.deviantart.com/journal/Frame-Delay-Times-for-Animated-GIFs-214150546

echo 'Exporting movie...'

fps=$(echo $fpsspeed | cut -d'@' -f1)
speed=$(echo $fpsspeed | cut -d'@' -f2)

if [ ! -z "$speed" ]; then
  speed=1
fi

delay=$(bc -l <<< "100/$fps/$speed")
temp=$(mktemp /tmp/tempfile.XXXXXXXXX)

ffmpeg -loglevel panic -i "$filename" $filter -r $fps -f image2pipe -vcodec ppm - >> $temp

echo 'Making gif...'
cat $temp | convert +dither -layers Optimize -delay $delay - "${output}.gif"
echo "${output}.gif"
