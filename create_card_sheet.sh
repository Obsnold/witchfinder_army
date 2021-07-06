#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "xcf_to_pdf.sh PATH_TO_INPUT"
    echo "$#"
    exit 0
fi


IN_DIR="$(realpath $1)"
TEMP="temp"

#declare -a PAGES=(  "witch_card.png witch_card.png witch_card.png witch_card.png witchfinder_general_card.png cultist_card.png cultist_card.png cultist_card.png cultist_card.png" 
#                    "witch_card.png cultist_card.png witchfinder_card.png witchfinder_card.png witchfinder_card.png witchfinder_card.png witchfinder_card.png witchfinder_card.png witchfinder_card.png" 
#                    "witchfinder_card.png witchfinder_card.png witchfinder_card.png witchfinder_card.png witchfinder_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png"
#                    "ghost_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png"
#                    "ghost_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png ghost_card.png"
#                )

declare -a PAGES=("witch_card.png witch_card.png cultist_card.png cultist_card.png witchfinder_general_card.png witchfinder_card.png witchfinder_card.png witchfinder_card.png witchfinder_card.png")

BACK="back_card.png" 


#the values below are all in pixels
CARD_WIDTH=750
CARD_HEIGHT=1050
PAGE_WIDTH=2480
PAGE_HEIGHT=3508
PIXEL_DENSITY=300


echo "input $IN_DIR"

rm -rf out
mkdir out
mkdir $TEMP

cp -r $IN_DIR/* $TEMP
find $TEMP -name "*card.svg"  -exec sh -c 'inkscape $1 --export-png=${1%.svg}.png' _ {} \;
#find $TEMP -name "*.png"  -exec sh -c 'convert -resize 750x1050! $1 ${1%}' _ {} \;

RES=1

for PAGE in "${PAGES[@]}"
do

    echo "-------------------"
    echo "Process page: $RES"
    echo $PAGE

    #get each card
    FRONT_1=$(echo $PAGE | cut -d' ' -f1)
    FRONT_2=$(echo $PAGE | cut -d' ' -f2)
    FRONT_3=$(echo $PAGE | cut -d' ' -f3)
    FRONT_4=$(echo $PAGE | cut -d' ' -f4)
    FRONT_5=$(echo $PAGE | cut -d' ' -f5)
    FRONT_6=$(echo $PAGE | cut -d' ' -f6)
    FRONT_7=$(echo $PAGE | cut -d' ' -f7)
    FRONT_8=$(echo $PAGE | cut -d' ' -f8)
    FRONT_9=$(echo $PAGE | cut -d' ' -f9)

    convert +append $TEMP/$FRONT_1 $TEMP/$FRONT_2 $TEMP/$FRONT_3 $TEMP/row_1.png
    convert +append $TEMP/$FRONT_4 $TEMP/$FRONT_5 $TEMP/$FRONT_6 $TEMP/row_2.png
    convert +append $TEMP/$FRONT_7 $TEMP/$FRONT_8 $TEMP/$FRONT_9 $TEMP/row_3.png
    convert -append $TEMP/row_1.png $TEMP/row_2.png $TEMP/row_3.png $TEMP/front.png
    convert $TEMP/front.png $TEMP/front.jpg
    convert -extent "$PAGE_WIDTH"x"$PAGE_HEIGHT" -density $PIXEL_DENSITY -colorspace RGB -gravity center -background white  $TEMP/front.jpg $TEMP/out_$(printf "%.2d" $RES).pdf

    RES=$((RES+1))

    convert +append $TEMP/$BACK $TEMP/$BACK $TEMP/$BACK $TEMP/row_1.png
    convert +append $TEMP/$BACK $TEMP/$BACK $TEMP/$BACK $TEMP/row_2.png
    convert +append $TEMP/$BACK $TEMP/$BACK $TEMP/$BACK $TEMP/row_3.png
    convert -append $TEMP/row_1.png $TEMP/row_2.png $TEMP/row_3.png $TEMP/back.png
    convert $TEMP/back.png $TEMP/back.jpg
    convert -extent "$PAGE_WIDTH"x"$PAGE_HEIGHT" -density $PIXEL_DENSITY -colorspace RGB -gravity center -background white  $TEMP/back.jpg $TEMP/out_$(printf "%.2d" $RES).pdf

    RES=$((RES+1))
    echo "-------------------"
done

convert -density 600 -colorspace RGB $TEMP/out_*.pdf ./out/Witchfinder_General.pdf

#echo "Create tts files"
#convert +append $TEMP/$FRONT_1 $TEMP/$FRONT_2 $TEMP/$FRONT_3 $TEMP/$FRONT_4 $TEMP/$FRONT_5 $TEMP/$FRONT_6 $TEMP/$FRONT_7 $TEMP/$FRONT_8 $TEMP/$FRONT_9 out/tts_front.jpg   
#convert +append $TEMP/$BACK $TEMP/$BACK $TEMP/$BACK $TEMP/$BACK $TEMP/$BACK $TEMP/$BACK $TEMP/$BACK $TEMP/$BACK $TEMP/$BACK out/tts_back.jpg
#convert out/tts_front.jpg -resize 6588x2076 -background white -gravity North -extent 6588x2076 out/tts_front.jpg
#convert out/tts_back.jpg -resize 6588x2076 -background white -gravity North -extent 6588x2076 out/tts_back.jpg

rm -rf $TEMP