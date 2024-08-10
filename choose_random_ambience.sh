#!/bin/bash

set -ex
choices=$(ls *ambience*.mp3)
shuffled=$(printf "%s\n" "${choices[@]}" | shuf -n1)
echo $shuffled
totem ${shuffled[ $RANDOM % ${#shuffled[@]} ]}
