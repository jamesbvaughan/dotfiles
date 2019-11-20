#!/bin/sh

# Get all the PDFs in the home directory.
FILES=$(fd -e pdf '' $HOME)

# Filter out the beginning of the paths and the file extension
# and pass those files to rofi for the user to select from.
FILE_INDEX=$(echo "$FILES" \
  | sed -e "s#$HOME/\(.*\)\.pdf#\1#gi" \
  | rofi -dmenu -i -p " PDF" -format d)

# If the user selected a file, open it up!
case $FILE_INDEX in
  -1) ;;
  "") ;;
  *) zathura "$(echo "$FILES" | sed -n ${FILE_INDEX}p)" ;;
esac

