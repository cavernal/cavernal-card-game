#!/bin/bash

# 1 = card
# 2 = output

(
cd templates
cat punchtemplate.svg | sed \
  -e "st_card.png../$1g" | \
inkscape \
  --export-background='#FFFFFF' \
  --export-background-opacity=255 \
  --export-dpi=900 \
  --export-type=png \
  --export-filename="../$2" \
  --pipe
)
