#!/bin/bash

# 1 = icon
# 2 = #
# 3 = output

(
cd templates
cat backtemplate.svg | sed \
  -e "st_icon.png../$1g" \
  -e "s4z1z9$2g" | inkscape \
  --export-background='#FFFFFF' \
  --export-background-opacity=255 \
  --export-dpi=900 \
  --export-type=png \
  --export-filename="../$3" \
  --pipe
)
