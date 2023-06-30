#!/bin/bash

# 1 = card1 front
# 2 = card1 back
# 3 = card2 front
# 4 = card2 back
# 5 = output

(
cd templates
cat printpairs9x13template.svg | sed \
  -e "st_card1.png../$1g" \
  -e "st_back1.png`echo ${2} | sed -e s@.png@@g -e s@imgs/@@g`g" \
  -e "st_card2.png../$3g" \
  -e "st_back2.png`echo ${4} | sed -e s@.png@@g -e s@imgs/@@g`g" \
  -e "st_text_text${6}g" | \
inkscape \
  --export-background='#FFFFFF' \
  --export-background-opacity=255 \
  --export-dpi=300 \
  --export-type=png \
  --export-filename="../$5" \
  --pipe
)
