#!/bin/bash

# Delete and recreate output directories
rm -rf output
mkdir output
mkdir output/cards
mkdir output/backs
mkdir output/imgs
mkdir output/printpairs9x13
mkdir output/printpairs9x13backs
mkdir output/printa4
mkdir output/printa4backs

# Array to store card names
declare -a cards
declare -a backs
declare -a backsNotes

# Boolean to skip the first line (header)
skip=true

# Read the CSV file
while IFS=, read -r count backIcon backNumber backText frontPic icon coin action actionText power special; do
  # Skip header row
  if $skip ; then
    skip=false
    continue
  fi

  # Run generatecard.sh and generatepunch.sh for each row
  templates/generatecard.sh "imgs/$frontPic" "imgs/$icon" "$coin" "imgs/$action" "$actionText" "$power" "output/cards/$frontPic"
  templates/generatepunch.sh "output/cards/$frontPic" "output/imgs/$frontPic"
  backPic="$(echo "$frontPic" | sed s/.png/_back.png/g)"
  templates/generateback.sh "imgs/$backIcon" "$backNumber" "output/backs/$backPic"
  templates/generatepunch.sh "output/cards/$backPic" "output/imgs/$backPic"

  # Add this card to our array the appropriate number of times
  for ((i=0; i<count; i++)); do
    cards+=("$frontPic")
    backs+=("$backPic")
    backsNotes+=("$backText")
  done
done < input.csv

# Function to generate a print page
generate_print_page() {
  local printFunc=$1   # The print function to call
  local pageSize=$2    # The number of cards per page
  local rows=$3        # Number of rows (for reverse)
  local outputDir=$4   # The directory to write output files to
  local -n arr=$5      # The array of cards
  local -n arrBacks=$6 # The array of backs
  local reverse=$7     # Whether to reverse (for backs)
  local text=$8        # Credits text

  local z=0
  local fileArr=()

  for (( i = 0; i < ${#arr[@]}; i++ )); do
    # Add this card to the file array
    if [[ -z "$reverse" ]];then
      fileArr+=("output/cards/${arr[i]}")
      fileArr+=("imgs/${arrBacks[i]}")  # Add the backPic for this card
    else
      fileArr=("imgs/${arrBacks[i]}" "${fileArr[@]}")
      fileArr=("output/backs/${arr[i]}" "${fileArr[@]}")
    fi

    # If we've added enough cards for a page, generate the print page
    if (( (i + 1) % pageSize == 0 )); then
      if [[ ! -z "$reverse" ]];then
        newFileArr=()
        local columns=$(( (${#fileArr[@]} / 2) / rows ))  # corrected line
        for ((x=rows-1; x>=0; x--)); do
          start=$(( x * columns * 2 ))  # start point for each row considering pairs
          newFileArr=("${newFileArr[@]}" "${fileArr[@]:$start:$columns*2}")  # use $columns*2 here as well
        done
        fileArr=("${newFileArr[@]}")
      fi
      "$printFunc" "${fileArr[@]}" "$outputDir/print$(printf "%04d\n" $z).png" "$text"
      z=$((z+1))
      fileArr=()
    fi
  done

  if [ ${#fileArr[@]} -gt 0 ]; then
    # If we have some cards left over, repeat the last card to fill the page
    while (( ${#fileArr[@]} < pageSize * 2 )); do
      if [[ -z "$reverse" ]];then
        fileArr+=("output/cards/${arr[-1]}")
        fileArr+=("imgs/${arrBacks[-1]}")
      else
        fileArr=("imgs/${arrBacks[-1]}" "${fileArr[@]}")
        fileArr=("output/backs/${arr[-1]}" "${fileArr[@]}")
      fi
    done

    # Generate the final print page
    if [[ ! -z "$reverse" ]];then
      newFileArr=()
      local columns=$(( (${#fileArr[@]} / 2) / rows ))  # corrected line
      for ((x=rows-1; x>=0; x--)); do
        start=$(( x * columns * 2 ))  # start point for each row considering pairs
        newFileArr=("${newFileArr[@]}" "${fileArr[@]:$start:$columns*2}")  # use $columns*2 here as well
      done
      fileArr=("${newFileArr[@]}")
    fi
    "$printFunc" "${fileArr[@]}" "$outputDir/print$(printf "%04d\n" $z).png" "$text"
  fi
}

# Generate the print pages
text=`cat CREDITS`
generate_print_page templates/generateprintpairs9x13.sh 2 1 output/printpairs9x13 cards backsNotes "" "$text"
generate_print_page templates/generateprintpairs9x13.sh 2 1 output/printpairs9x13backs backs cards reverse "$text"
generate_print_page templates/generateprinta4.sh 8 2 output/printa4 cards backsNotes "" "$text"
generate_print_page templates/generateprinta4.sh 8 2 output/printa4backs backs cards reverse "$text"

convert "output/printa4/*.png" output/printa4-one-sided.pdf

fileArr=()
files=$(cd output/printa4;ls *.png)
for f in $files;do
  fileArr+=("output/printa4/$f")
  fileArr+=("output/printa4backs/$f")
done
convert "${fileArr[@]}" output/printa4-two-sided.pdf

(cd output
zip -r -9 imgs.zip imgs
zip -r -9 printpairs9x13.zip printpairs9x13
rm -rf cards backs output/printa4 output/printa4backs printpairs9x13 printpairs9x13backs printa4 printa4backs imgs
)
