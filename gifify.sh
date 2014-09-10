#!/bin/bash

function printHelpAndExit {
  echo 'Usage:'
  echo '  gifify [options] filename'
  echo ''
  echo 'Options: (all optional)'
  echo '  c CROP:   The x and y crops, from the top left of the image, i.e. 640:480'
  echo '  o OUTPUT: The basename of the file to be output (default "output")'
  echo '  n:        Do not upload the resulting image to CloudApp'
  echo '  r FPS:    Output at this (frame)rate (default 10)'
  echo '  s SPEED:  Output using this speed modifier (default 1)'
  echo '            NOTE: GIFs max out at 100fps depending on platform. For consistency,'
  echo '            ensure that FPSxSPEED is not > ~60!'
  echo '  t TEXT    Add a caption to the image'
  echo '  p SCALE:  Rescale the output, e.g. 320:240'
  echo '  x:        Remove the original file and resulting .gif once the script is complete'
  echo ''
  echo 'Example:'
  echo '  gifify -c 240:80 -o my-gif -x my-movie.mov'
  exit $1
}

function getLength() {
    ff=$(ffmpeg -i $filename 2>&1)
    d="${ff#*Duration: }"
    echo "${d%%,*}"
    exit $1
}

noupload=0
fps=10
speed=1

OPTERR=0

while getopts "c:o:p:r:s:t:nx" opt; do
  case $opt in
    c) crop=$OPTARG;;
    h) printHelpAndExit 0;;
    o) output=$OPTARG;;
    n) noupload=1;;
    p) scale=$OPTARG;;
    r) fps=$OPTARG;;
    s) speed=$OPTARG;;
    t) text=$OPTARG;;
    x) cleanup=1;;
    *) printHelpAndExit 1;;
  esac
done

shift $(( OPTIND - 1 ))

filename=$1

if [ -z ${output} ]; then
  output=$filename
fi

if [ -z $filename ]; then printHelpAndExit 1; fi

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

subtitles=${text}

if [ "$text" ]; then
    : > /tmp/subs.srt
    text="$subtitles"
    (echo 1; echo "00:00:00,000 -->"  $(getLength 1); echo "$subtitles") >> /tmp/subs.srt
    capfile="-vf subtitles=/tmp/subs.srt"
else
    capfile=
fi

# -delay uses time per tick (a tick defaults to 1/100 of a second)
# so 60fps == -delay 1.666666 which is rounded to 2 because convert
# apparently stores this as an integer. To animate faster than 60fps,
# you must drop frames, meaning you must specify a lower -r. This is
# due to the GIF format as well as GIF renderers that cap frame delays
# < 3 to 3 or sometimes 10. Source:
# http://humpy77.deviantart.com/journal/Frame-Delay-Times-for-Animated-GIFs-214150546
echo 'Exporting movie...'
delay=$(bc -l <<< "100/$fps/$speed")
temp=$(mktemp /tmp/tempfile.XXXXXXXXX)

ffmpeg -loglevel panic -i $filename $capfile $filter -r $fps -f image2pipe -vcodec ppm - >> $temp

echo 'Making gif...'
cat $temp | convert +dither -layers Optimize -delay $delay - ${output}.gif

if [ $noupload -ne 1 ]; then
    open -a Cloud ${output}.gif
    
    if [ $cleanup ]; then
        rm $filename
        rm ${output}.gif
        echo "Files deleted."
    fi
else
    echo "Filename:" ${output}.gif
fi