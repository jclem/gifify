#!/bin/bash

function printHelpAndExit {
  echo 'Usage:'
  echo '  gifify -conx filename'
  echo ''
  echo 'Options: (all optional)'
  echo '  c CROP:   The x and y crops, from the top left of the image, i.e. 640:480'
  echo '  o OUTPUT: The basename of the file to be output (default "output")'
  echo '  n:        Do not upload the resulting image to CloudApp'
  echo '  x:        Remove the original file and resulting .gif once the script is complete'
  echo ''
  echo 'Example:'
  echo '  gifify -c 240:80 -o my-gif -x my-movie.mov'
  exit $1
}

noupload=0

OPTERR=0

while getopts "c:o:nx" opt; do
  case $opt in
    c) crop=$OPTARG;;
    h) printHelpAndExit 0;;
    o) output=$OPTARG;;
    n) noupload=1;;
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

ffmpeg -i $filename $crop -r 10 -f image2pipe -vcodec ppm - | convert -verbose +dither -layers Optimize - ${output}.gif

if [ $noupload -ne 1 ]; then
  echo `cloudapp -d ${output}.gif`

  if [ $cleanup ]; then
    rm $filename
    rm ${output}.gif
  fi
else
  echo ${output}.gif
fi
