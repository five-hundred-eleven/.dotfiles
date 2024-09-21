#!/bin/bash

#set -x

duration=$1

if [ -z "$duration" ]
then
    min_duration=40
    max_duration=90
    echo "Optional argument duration not given, generating randomized duration in range ${min_duration}m - ${max_duration}m"
    duration="$(python -c "import random; print(random.randint($min_duration, $max_duration))")m"
    echo "duration: $duration"
fi

echo "Duration: $duration"

function random_seek() {
    set -x
    sleep 1
    num_seek=$((RANDOM % 5))
    for i in $(seq 1 $num_seek)
    do
        totem --seek-fwd
        sleep 0.1
    done
}
# I don't like the quality of shuf- it seems biased towards selecting some choices more than others
#choice=$(printf "%s\n" "$(ls *ambience*.mp3)" | shuf | shuf | shuf | shuf | shuf -n1)
py="
import os
import os.path
import random

ambiences = set()
for path, _, files in os.walk(os.getcwd()):
    for file in files:
        if not os.path.isfile(file):
            continue
        if not file.endswith('.mp3'):
            continue
        if 'ambience' not in file and 'ambiance' not in file:
            continue
        ambiences.add(os.path.join(path, file))
ambiences = list(ambiences)
for _ in range(5):
    random.shuffle(ambiences)
print(random.choice(ambiences))
"
choice=$(python -c "$py")
echo "Choice: $choice"
echo "Ambience will begin in 10 seconds..."
#export -f random_seek
#nohup bash -c random_seek &
sleep 10
timeout $duration totem $choice
if [ $? -eq 124 ]
then
    totem '/media/cowley/muninn/ambience/Maarten Schellekens - Spring Morning.mp3'
fi
