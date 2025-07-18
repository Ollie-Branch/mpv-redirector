#!/usr/bin/env bash
# Dependencies: bash, fzf, yt-dlp, mpv, gtk-open
# We require bash now due to needing its arrays to implement this functionality
# cleanly

echo "$XDG_CONFIG_HOME"

CONFIG_DIR="$XDG_CONFIG_HOME/mpv-redirector"
CONFIG_FILE="$CONFIG_DIR/config.sh"
# As much as I like flatpak, why can't they just be normal
LAUNCHER_FILE_DIRS=("/usr/share/applications" \
                    "$HOME/.local/share/applications/" \
                    "/var/lib/flatpak/exports/share/applications" \
                    "$HOME/.local/share/flatpak/exports/share/applications")
LAUNCHER_FILE_ARRAY=()
BROWSER_LAUNCHER_FILES=()

if [ ! -f $CONFIG_FILE ]; then
    echo "there is no config directory and/or file, running first time setup"
    mkdir -p $CONFIG_DIR
    touch $CONFIG_FILE

    # Get all the files found in LAUNCHER_FILE_DIRS and add those to the
    # LAUNCHER_FILE_ARRAY
    # First awk removes first element, second separates elements by spaces to
    # fit with how bash separates array elements.
    for i in "${LAUNCHER_FILE_DIRS[@]}"; do
        LAUNCHER_FILE_ARRAY+=($(find "$i" | awk 'NR>1 {print $0}' | \
            awk -v ORS=' ' '{print $1}'))
    done

    # grep all the files in the LAUNCHER_FILE_ARRAY for the "WebBrowser" string
    # so we can find all the web browsers installed on the system.
    for i in "${LAUNCHER_FILE_ARRAY[@]}"; do
        grep "WebBrowser" "$i"
        # $? is the exit code of the previous command, 0 means grep matched
        # succesfully
        if [ $? = 0 ]; then
            BROWSER_LAUNCHER_FILES+=("$i")
        fi
    done
    echo "in the upcoming screen, choose which browser you want to launch when \
mpv-director encounters a non-video url"
    sleep 4
    # The awk formats it into a format grep and fzf expect, a list of newline
    # separated items.
    echo "${BROWSER_LAUNCHER_FILES[@]}" | \
        awk -F ' ' '{for (i=1; i<=NF; i++) print $i, "\n"}' | grep -v mpv-redirector \
        | fzf | sed 's/^/PREFERRED_BROWSER=/' >> "$CONFIG_FILE"
fi

source "$CONFIG_FILE"


echo $1
yt-dlp -f bestvideo*+bestaudio/best $1 -o - | mpv -

if [ ! $? = 0 ]; then
    gtk-launch "$(echo $PREFERRED_BROWSER | awk -F"/" '{print $NF}')" $1
fi

sleep 5
exit
