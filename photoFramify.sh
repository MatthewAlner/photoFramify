#!/usr/bin/env bash

CURRENT_PATH=$(pwd)

# Change these Parameters
NAME_OF_OUTPUT_FOLDER=OUTPUT
MAX_HEIGHT=234 #The height of the pannel in the picture frame
MAX_WIDTH=416 #The with in the pannel is 480 supposedly but was trimed when "optimal" and fuzzy when "Auto fit" so 16:9ed it (234/9)*16=416
QUALITY=92
ADD_BLUR_BACKGROUND=true
RENAME_TO_MD5=true

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
      test1=$(convert xc: -format "%[fx:$aspect>($MAX_WIDTH/$MAX_HEIGHT)?1:0]" info:)
      test2=$(convert xc: -format "%[fx:$aspect>=1?1:0]" info:)
      printf "\\twidth=%s; height=%s; aspect=%s;\\n" "$MAX_WIDTH" "$MAX_HEIGHT" "$aspect"

      if [ "$test1" -eq 1 ]; then
        printf "\\taspect larger than desired aspect (wider than tall)\\n"
        RESIZE_ARG="${MAX_HEIGHT}x${MAX_HEIGHT}^"
      elif [ "$test2" -eq 1 ]; then
        printf "\\taspect less than desired aspect (wider than tall) but greater than or equal to 1\\n"
        RESIZE_ARG="${MAX_WIDTH}x${MAX_WIDTH}"
      else
        printf "\\taspect less than 1 (taller than wide)\\n"
        RESIZE_ARG="${MAX_WIDTH}x${MAX_WIDTH}^"
      fi

      convert "$IMAGE" \( -clone 0 -auto-orient -resize "$RESIZE_ARG" -gravity center -blur 0x9 -fill white -colorize 40% -crop "$MAX_WIDTH"x"$MAX_HEIGHT"+0+0 +repage \) \
      \( -clone 0 -auto-orient -resize "$MAX_WIDTH"x"$MAX_HEIGHT"\> \) \
        -delete 0 -auto-orient -gravity center -colorspace RGB -quality "$QUALITY" -compose over -composite "$OUTPUT"/"$FILE_NAME"
    else
      convert "$IMAGE" -resize "$MAX_WIDTH"x"$MAX_HEIGHT"\> -colorspace RGB -auto-orient -quality "$QUALITY" "$OUTPUT"/"$FILE_NAME"
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

