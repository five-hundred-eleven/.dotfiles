#!/bin/bash

#set -ex

duration=$1

if [ -z "$duration" ]
then
    echo "Missing required argument duration, ex 20m"
    exit 1
fi

echo "Duration: $duration"

choices=$(ls *ambience*.mp3)
shuffled=$(printf "%s\n" "${choices[@]}" | shuf -n1)
echo $shuffled
timeout $duration totem ${shuffled[ $RANDOM % ${#shuffled[@]} ]}
if [ $? -eq 124 ]
then
    totem '/media/cowley/muninn/ambience/Maarten Schellekens - Spring Morning.mp3'
fi
