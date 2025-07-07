
COVER="/tmp/album_cover.png"
TEMP_COVER="/tmp/temp_album_cover.png"
IMG_SIZE="750x750"
IMG_OFFSET=11

get_terminal_size() {
  local size
  size=$(stty size)
  IFS=' ' read -r rows cols <<< "$size"
  echo "$cols,$rows"
}

resize_cover_image() {
  local size
  size=$(get_terminal_size)
  IFS=',' read -r width height <<< "$size"

  if [ -f "$COVER" ]; then
    magick "$COVER" -resize "$IMG_SIZE" "$TEMP_COVER"

	sleep 1

    # Check if resizing was successful
    if [ $? -ne 0 ]; then
      echo "Error resizing image: $COVER. Using original cover instead."
      cp "$COVER" "$TEMP_COVER" || {
        echo "Failed to copy original cover image."
        exit 1
      }
    fi
  else
    echo "Cover image not found: $COVER"
    exit 1
  fi
}

function add_cover {
  clear
  resize_cover_image

  if [ -f "$TEMP_COVER" ]; then
    # kitty +kitten icat "$TEMP_COVER" || echo "Failed to display cover image."
	printf "\033[${IMG_OFFSET};$((IMG_OFFSET*2))H"
	img2sixel "$TEMP_COVER"
  else
    echo "Temporary cover image does not exist: $TEMP_COVER"
  fi
}

if [ ! -f "$COVER" ]; then
  cp "$HOME/.config/ncmpcpp/default_cover.png" "$COVER" || {
    echo "Failed to copy default cover image."
    exit 1
  }
fi

add_cover

while inotifywait -q -e close_write "$COVER"; do
  add_cover
done
