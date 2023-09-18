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
output="${basename}_small.mp4"

echo "input: $input"
echo "output: $output"

ffmpeg -t 8000 -i $input -s 720x480 -c:a copy $output
