#!/bin/bash

(
cd templates
cat printa4template.svg | sed \
  -e "st_card1.png../${1}g" \
  -e "st_back1.png`echo ${2} | sed -e s@.png@@g -e s@imgs/@@g`g" \
  -e "st_card2.png../${3}g" \
  -e "st_back2.png`echo ${4} | sed -e s@.png@@g -e s@imgs/@@g`g" \
  -e "st_card3.png../${5}g" \
  -e "st_back3.png`echo ${6} | sed -e s@.png@@g -e s@imgs/@@g`g" \
  -e "st_card4.png../${7}g" \
  -e "st_back4.png`echo ${8} | sed -e s@.png@@g -e s@imgs/@@g`g" \
  -e "st_card5.png../${9}g" \
  -e "st_back5.png`echo ${10} | sed -e s@.png@@g -e s@imgs/@@g`g" \
  -e "st_card6.png../${11}g" \
  -e "st_back6.png`echo ${12} | sed -e s@.png@@g -e s@imgs/@@g`g" \
  -e "st_card7.png../${13}g" \
  -e "st_back7.png`echo ${14} | sed -e s@.png@@g -e s@imgs/@@g`g" \
  -e "st_card8.png../${15}g" \
  -e "st_back8.png`echo ${16} | sed -e s@.png@@g -e s@imgs/@@g`g" \
  -e "st_text_text${18}g" | \
inkscape \
  --export-background='#FFFFFF' \
  --export-background-opacity=255 \
  --export-dpi=300 \
  --export-type=png \
  --export-filename="../${17}" \
  --pipe
)
