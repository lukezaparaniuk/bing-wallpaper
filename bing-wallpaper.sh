#!/usr/bin/env bash

PICTURE_DIR="$HOME/Pictures/bing-wallpapers/"

rm -r $PICTURE_DIR

mkdir -p $PICTURE_DIR

urls=( $(curl -s http://www.bing.com | \
    grep -Eo "url:'.*?'" | \
    sed -e "s/url:'\([^']*\)'.*/http:\/\/bing.com\1/" | \
    sed -e "s/\\\//g") )

# Two URLs are currently returned
url=${urls[0]}

filename=$(echo $url | sed -e "s/.*\/\(.*\)/\1/")

if [ ! -f $PICTURE_DIR/$filename ]; then
    echo "Downloading: $filename ..."
    curl -Lo "$PICTURE_DIR/$filename" $url
else
    echo "Skipping: $filename ..."
fi

sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '$PICTURE_DIR/$filename'";

killall Dock # Required to actually apply the change

echo "Set wallpaper to $PICTURE_DIR/$filename"