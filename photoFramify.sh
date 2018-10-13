#!/usr/bin/env bash

CURRENT_PATH=$(pwd)

# Default parameters
NAME_OF_OUTPUT_FOLDER=OUTPUT
MAX_HEIGHT=234 # The height of the pannel in the picture frame
MAX_WIDTH=416 # The with in the pannel is 480 supposedly but was trimed when "optimal" and fuzzy when "Auto fit" so 16:9ed it (234/9)*16=416
QUALITY=92
ADD_BLUR_BACKGROUND=true
RENAME_TO_MD5=true

# Override defaults with any arguments passed in via flags
while [ ! $# -eq 0 ]
do
  case "$1" in
    --output-folder | -o)
      NAME_OF_OUTPUT_FOLDER=$2;;
    --max-height | -h)
      MAX_HEIGHT=$2;;
    --max-width | -w)
      MAX_WIDTH=$2;;
    --quality | -q)
      QUALITY=$2;;
    --blur | -b)
      ADD_BLUR_BACKGROUND=$2;;
    --rename-to-md5 | -r)
      RENAME_TO_MD5=$2;;  
  esac
  shift
done

# Determine path of output directory
OUTPUT="$CURRENT_PATH"/"$NAME_OF_OUTPUT_FOLDER"

type_exists() {
    if [ "$(type -P "$1")" ]; then
        return 0
    fi
    return 1
}

function checkingForImagemagick {
  echo "checking for imagemagick"
  if type_exists convert; then
    printf "$(tput setaf 2)✓ Success: $(tput sgr0)%s.\\n" "imagemagick available"
  else
    printf "$(tput setaf 1)✗ Error: $(tput sgr0)%s.\\n" "please install imagemagick"
  fi
}

function makeOutputFolder {
  mkdir -p "$OUTPUT"
}

function convertImages {
  ITER=0
  FILE_COUNT=$(find "$CURRENT_PATH"/*.jpg -type f | wc -l | tr -d '[:space:]')
  for IMAGE in "$CURRENT_PATH"/*.jpg; do
    ((++ITER))

      BASE_NAME=$(basename "$IMAGE")
    if [ "$RENAME_TO_MD5" = true ] ; then
      MD5=$(md5 -q "$IMAGE")
      BASE_NAME=$(basename "$IMAGE")
      EXT=.${BASE_NAME#*.}
      FILE_NAME="${MD5}${EXT}";
    else
      FILE_NAME=$BASE_NAME
    fi

    printf "%s/%s\\nconverting:\\t %s => %s\\n" "$ITER" "$FILE_COUNT" "$BASE_NAME" "$FILE_NAME"

    if [ "$ADD_BLUR_BACKGROUND" = true ] ; then

      aspect=$(convert "$IMAGE" -format "%[fx:w/h]" info:)
      printf "\\twidth=%s; height=%s; aspect=%s;\\n" "$MAX_WIDTH" "$MAX_HEIGHT" "$aspect"

      convert "$IMAGE" \( -clone 0 -auto-orient -resize "${MAX_WIDTH}x${MAX_HEIGHT}^" -gravity center -blur 0x9 -fill white -colorize 40% -extent "$MAX_WIDTH"x"$MAX_HEIGHT" \) \
      \( -clone 0 -auto-orient -resize "$MAX_WIDTH"x"$MAX_HEIGHT"\> \) \
        -delete 0 -auto-orient -strip -gravity center -colorspace RGB -quality "$QUALITY" -compose over -composite "$OUTPUT"/"$FILE_NAME"
    else
      convert "$IMAGE" -resize "$MAX_WIDTH"x"$MAX_HEIGHT"\> -colorspace RGB -auto-orient -strip -quality "$QUALITY" "$OUTPUT"/"$FILE_NAME"
    fi
    printf "\\n"
  done
}

function printFileSizes {
  INPUT_TOTAL_FILE_SIZE=$(find "$CURRENT_PATH" -type f -name '*.jpg' -exec du -ch {} + | grep total$)
  printf "$(tput setaf 6)┃ $(tput sgr0)$(tput setaf 7)%s...$(tput sgr0)\\n" "INPUT DIR SIZE: $INPUT_TOTAL_FILE_SIZE"

  OUTPUT_TOTAL_FILE_SIZE=$(du -hcs "$OUTPUT" | grep total$)
  printf "$(tput setaf 6)┃ $(tput sgr0)$(tput setaf 7)%s...$(tput sgr0)\\n" "OUTPUT DIR SIZE: $OUTPUT_TOTAL_FILE_SIZE"
}

checkingForImagemagick
makeOutputFolder
convertImages
printFileSizes
printf "$(tput setaf 2)✓ Success: $(tput sgr0)%s.\\n" "Complete"

