#!/bin/bash

# prereq is that the following command needs to be run:
# `sudo modprobe v4l2loopback`

ffmpeg -re -i $1 -map 0:v -vcodec rawvideo -vf format=yuv420p -f v4l2 -ss 0:00:00 /dev/video0
