#!/bin/bash

if [ -z $1 ] ; then
    echo "need input file at position 1"
    exit 1
fi

set -ex

input=$1

if ! [ -f $input ] ; then
    echo "$input does not appear to exist"
    exit 1
fi

basename=${input%.*}
output="${basename}.mp4"

echo "input: $input"
echo "output: $output"

ffmpeg -loop 1 -i $input -c:v libx264 -t 8000 -pix_fmt yuv420p -vf scale=640:480 $output
