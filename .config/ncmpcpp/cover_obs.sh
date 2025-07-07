#!/bin/bash

DEBUG=0

COVER="/tmp/album_cover.png"
EMB_COVER="/tmp/album_cover_embedded.png"
file="$MUSIC_DIR/$(mpc --format %file% current 2>/dev/null)"  
debug() {
  if [ "$DEBUG" = true ]; then
    echo "$1"
  fi
}

debug "Music Directory: $MUSIC_DIR"
debug "Current Track File: $file"

art=$(playerctl --player=mopidy metadata mpris:artUrl | sed 's|^file://||' 2>/dev/null)

debug "Album Art URL: $art"

if [[ $art =~ ^/local/ ]]; then
  art="${art#/local/}" # Remove '/local/' prefix

  cp "$HOME/.local/share/mopidy/local/images/$art" "$COVER" > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    debug "Cover copied successfully from local file: $COVER"
  else
    debug "Failed to copy cover from local file."
    art="$HOME/.config/ncmpcpp/default_cover.png"
  fi

elif [[ $art =~ ^http ]]; then
  curl -s -o "$COVER" "$art"

  if [ $? -ne 0 ]; then
    debug "Failed to download cover from URL."
    art="$HOME/.config/ncmpcpp/default_cover.png" 
  else
    if [ -f "$COVER" ]; then
      debug "Cover downloaded successfully: $COVER"
      ls -lh "$COVER" > /dev/null 2>&1 
    else
      debug "Failed to download cover."
      art="$HOME/.config/ncmpcpp/default_cover.png"
    fi
  fi

else
  debug "No valid album art found. Using default cover."
  art="$HOME/.config/ncmpcpp/default_cover.png" 
fi

# Note: Uncomment to enable notifications
# notify-send -r 27072 "Now Playing" "$(mpc --format '%title% \n%artist% - %album%' current 2>/dev/null)" -i "$COVER"
