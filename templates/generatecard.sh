#!/bin/bash

# 1 = front
# 2 = icon
# 3 = # coins 0-5 or empty
# 4 = action
# 5 = action text
# 6 = value
# 7 = output

nothing='nothing.png'

coin5='t_coin_5.png'
if [ -z "$3" ] || [ "$3" -lt "5" ];
  then coin5="$nothing"
fi
coin4='t_coin_4.png'
if [ -z "$3" ] || [ "$3" -lt "4" ];
  then coin4="$nothing"
fi
coin3='t_coin_3.png'
if [ -z "$3" ] || [ "$3" -lt "3" ];
  then coin3="$nothing"
fi
coin2='t_coin_2.png'
if [ -z "$3" ] || [ "$3" -lt "2" ];
  then coin2="$nothing"
fi
coin1='t_coin_1.png'
if [ -z "$3" ] || [ "$3" -lt "1" ];
  then coin1="$nothing"
fi
(
cd templates
cat cardtemplate.svg | sed \
  -e "st_front.png../$1g" \
  -e "st_icon.png../$2g" \
  -e "st_coin_1.png$coin1g" \
  -e "st_coin_2.png$coin2g" \
  -e "st_coin_3.png$coin3g" \
  -e "st_coin_4.png$coin4g" \
  -e "st_coin_5.png$coin5g" \
  -e "st_action.png../$4g" \
  -e "s4z1z8$5g" \
  -e "s4z1z9$6g" | inkscape \
  --export-background='#FFFFFF' \
  --export-background-opacity=255 \
  --export-dpi=900 \
  --export-type=png \
  --export-filename="../$7" \
  --pipe
)
