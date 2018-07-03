#!/bin/bash

# please change
RECORDEDJSON="/home/chinachu/chinachu/data/recorded.json"
LOGDIR="/mnt/hdd/share/log/"
MP4DIR="/mnt/hdd/share/mp4/"
GDDIR="/mnt/gd/mp4/"

# do not change
TSFILENAME=${1##*/}
MP4FILENAME="${TSFILENAME%.*}.mp4"
LOG="${LOGDIR}${TSFILENAME%.*}.log"
MP4FILEPATH="${MP4DIR}${MP4FILENAME}"
GDFILEPATH="${GDDIR}${MP4FILENAME}"
exec &> $LOG

# for escaping conflict of writing to recorded.json
sleep 5

# append to recorded.json
RECORDEDJSONTEMP=`cat $RECORDEDJSON`
echo $RECORDEDJSONTEMP | jq -c ".+[ \
  $(
    echo $2 |
    jq  ".id += \"_mp4\"" | \
    jq  ".recorded = \"${MP4FILEPATH//\//\\\/}\"" | \
    jq -c ".title = \"[mp4]$(echo $2 | jq '.title' | tr --delete \")\"" \
  )
  ]" > $RECORDEDJSON

# disallow writing to ts file
chmod 444 "$1"

# encode ts to mp4
nice -n 10 HandBrakeCLI \
    -i "$1" -o "${MP4FILEPATH}" \
    -f MP4 -O -e x264 \
    --x264-preset medium --x264-tune animation \
    --h264-profile high -q 25 --vfr \
    -a 1 -E fdk_aac -B 160 -6 stereo

# allow writing to ts file
chmod 666 "$1"

# upload mp4 to Google Drive if filename has "[gd]"
if [ $(echo ${TSFILENAME} | grep -e '[gd]') ]; then
  echo "Uploading mp4 to Google Drive"
  chmod 444 "${MP4FILEPATH}"
  touch "${GDFILEPATH}"
  cp -v "${MP4FILEPATH}" "${GDFILEPATH}"
fi

# allow writing to mp4 file
chmod 666 "${MP4FILEPATH}"
