##!/usr/bin/env bash
cd "$(dirname "$0")" #set wd to file location
SHOW_TAGS=(4SSUSun)  #insert you favourite show tags here
STORAGE=/mnt/storage/Musik/FM4/downloads
COUNT=0
for SHOW_TAG in "${SHOW_TAGS[@]}"; do
  URLS="$(python fm4.py -s ${SHOW_TAG}| tr -d '[],')" #call python script to get the stream URL
  for URL in $URLS; do
        let COUNT++
        mkdir -p ${STORAGE}/${SHOW_TAG} #creates show directory if it doesn't exist
        URL="${URL%\'}" #removes the starting quote
        URL="${URL#\'}" #removes the last quote
        DATE="${URL#*id=}"
        DATE="${DATE%%_*}"
        FILENAME="${STORAGE}/${SHOW_TAG}/${DATE}_${SHOW_TAG}_${COUNT}.mp3"
        echo $FILENAME
        if [ ! -f ${FILENAME} ]
        then
                logger "downloading ${FILENAME}"
                wget -O ${FILENAME} ${URL} #download show
                #upload to cloud? use rclone!
        else
                logger "skipping file ${FILENAME}, it does already exist"
        fi
  done
done
