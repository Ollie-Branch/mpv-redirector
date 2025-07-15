#!/usr/bin/env sh

echo $1

yt-dlp -f bestvideo*+bestaudio/best $1 -o - | mpv -

if [ ! $? = 0 ]; then
    firefox $1
fi

sleep 5
