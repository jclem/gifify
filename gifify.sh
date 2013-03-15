#!/bin/bash

function printHelpAndExit {
  echo 'Usage:'
  echo '  gifify -coux filename'
  echo ''
  echo 'Options: (all optional)'
  echo '  c CROP:   The x and y crops, from the top left of the image, i.e. 640:480'
  echo '  o OUTPUT: The basename of the file to be output (default "output")'
  echo '  u:        Upload the resulting image to CloudApp'
  echo '  x:        Remove the resulting image once the script is complete'
  echo ''
  echo 'Example:'
  echo '  gifify -c 240:80 -o my-gif -u -x my-movie.mov'
  exit $1
}

output=output

OPTERR=0

while getopts "c:o:ux" opt; do
  case $opt in
    c) crop=$OPTARG;;
    h) printHelpAndExit 0;;
    o) output=$OPTARG;;
    u) upload=1;;
    x) cleanup=1;;
    *) printHelpAndExit 1;;
  esac
done

shift $(( OPTIND - 1 ))

filename=$1
if [ -z $filename ]; then printHelpAndExit 1; fi

if [ $crop ]; then
  crop="-vf crop=${crop}:0:0"
else
  crop=
fi

ffmpeg -i $filename -pix_fmt rgb24 -r 10 ${crop} ${output}.gif

convert -layers Optimize ${output}.gif ${output}.gif

if [ $upload ]; then
  echo `cloudapp -d ${output}.gif`

  if [ $cleanup ]; then
    rm ${output}.gif
  fi
else
  echo ${output}.gif
fi
