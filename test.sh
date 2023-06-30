#!/bin/bash
templates/generatecard.sh "$1" "templates/t_icon.png" "5" "templates/t_action.png" "x2" "50" "../test.png"
templates/generatepunch.sh "../test.png" "../punch.png"
qiv -t ../punch.png
