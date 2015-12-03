#!/bin/sh

# Make a timelapse
# Precondition: current directory contains files in the format "IMG_*.jpg"
# Usage: lapse.sh [output filename]
# TODO: allow user to set framerate

FRAMERATE=15

if [ $# != 1 ]
then
	echo "Wrong number of args!"
else
	echo "making timelapse '$1'"
	ffmpeg -f image2 -pattern_type glob -r $FRAMERATE -i 'IMG_*.jpg' -r 30 -s hd1080 -vcodec libx264 $1
fi
