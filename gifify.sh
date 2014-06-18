#!/bin/bash

function printHelpAndExit {
  echo 'Usage:'
  echo '  gifify -conx filename'
  echo ''
  echo 'Options: (all optional)'
  echo '  c CROP:   The x and y crops, from the top left of the image, i.e. 640:480'
  echo '  o OUTPUT: The basename of the file to be output (default "output")'
  echo '  r FPS:    Output at this (frame)rate (default 10)'
  echo '  s SPEED:  Output using this speed modifier (default 1)'
  echo '            NOTE: GIFs max out at 100fps depending on platform. For consistency,'
  echo '            ensure that FPSxSPEED is not > ~60!'
  echo '  x:        destroy original file and GIF.'
  echo '  d SCALE:  Scales GIF image to specified dimensions (default no scale)'
  echo ''
  echo 'Example:'
  echo '  gifify -c 240:80 -o my-gif -x my-movie.mov'
  exit $1
}

fps=10
speed=1

OPTERR=0

while getopts "c:o:r:s:d:x" opt; do
  case $opt in
    c) crop=$OPTARG;;
    h) printHelpAndExit 0;;
    o) output=$OPTARG;;
    r) fps=$OPTARG;;
    s) speed=$OPTARG;;
    d) scale=$OPTARG;;
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
  crop="-vf crop=${crop}:0:0"
else
  crop=
fi

if [ $scale ]; then
  scale="-vf scale=${scale}:0:0"
else
  scale=
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

ffmpeg -loglevel panic -i $filename $crop -r $fps -f image2pipe $scale -vcodec ppm - >> $temp
echo "Temp file created."

echo 'Making gif...'
cat $temp | convert +dither -layers Optimize -delay $delay - ${output}.gif
cleartemp=$(rm $temp) | echo "Temp file removed."

if [ $cleanup ]; then
    rm $filename
    rm ${output}.gif
    echo "Files deleted."
else
    echo "Filename:" ${output}.gif
fi