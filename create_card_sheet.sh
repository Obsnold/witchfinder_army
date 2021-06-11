#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "xcf_to_pdf.sh PATH_TO_INPUT"
    echo "$#"
    exit 0
fi


IN_DIR="$(realpath $1)"
TEMP="temp"

FRONT_1="witch_card.png" 
FRONT_2="witch_card.png" 
FRONT_3="witch_card.png"
FRONT_4="witch_card.png"
FRONT_5="witch_card.png"
FRONT_6="cultist_card.png"
FRONT_7="cultist_card.png"
FRONT_8="cultist_card.png"
FRONT_9="cultist_card.png"

BACK_1="card_back.png" 
BACK_2="card_back.png" 
BACK_3="card_back.png" 
BACK_4="card_back.png" 
BACK_5="card_back.png" 
BACK_6="card_back.png" 
BACK_7="card_back.png" 
BACK_8="card_back.png" 
BACK_9="card_back.png" 



#the values below are all in pixels
CARD_WIDTH=750
CARD_HEIGHT=1050
CARD_X_OFFSET="-2"
CARD_Y_OFFSET="+2"
PAGE_WIDTH=2480
PAGE_HEIGHT=3508
PIXEL_DENSITY=300


echo "input $IN_DIR"

rm -rf out
mkdir out
mkdir $TEMP

cp -r $IN_DIR/* $TEMP
find $TEMP -name "*.svg"  -exec sh -c 'inkscape $1 --export-png=${1%.svg}.png' _ {} \;
#find $TEMP -name "*.png"  -exec sh -c 'convert -resize 750x1050! $1 ${1%}' _ {} \;

echo "use ImageMagick to paste everything together"
convert +append $TEMP/$FRONT_1 $TEMP/$FRONT_2 $TEMP/$FRONT_3 $TEMP/row_1.png
convert +append $TEMP/$FRONT_4 $TEMP/$FRONT_5 $TEMP/$FRONT_6 $TEMP/row_2.png
convert +append $TEMP/$FRONT_7 $TEMP/$FRONT_8 $TEMP/$FRONT_9 $TEMP/row_3.png
convert -append $TEMP/row_1.png $TEMP/row_2.png $TEMP/row_3.png $TEMP/front.png
convert $TEMP/front.png $TEMP/front.jpg
convert -extent "$PAGE_WIDTH"x"$PAGE_HEIGHT" -density $PIXEL_DENSITY -colorspace RGB -gravity center -background white  $TEMP/front.jpg $TEMP/front.pdf

convert +append $TEMP/$BACK_3 $TEMP/$BACK_2 $TEMP/$BACK_1 $TEMP/row_1.png
convert +append $TEMP/$BACK_6 $TEMP/$BACK_5 $TEMP/$BACK_4 $TEMP/row_2.png
convert +append $TEMP/$BACK_9 $TEMP/$BACK_8 $TEMP/$BACK_7 $TEMP/row_3.png
convert -append $TEMP/row_1.png $TEMP/row_2.png $TEMP/row_3.png $TEMP/back.png
convert $TEMP/back.png $TEMP/back.jpg
convert -extent "$PAGE_WIDTH"x"$PAGE_HEIGHT" -density $PIXEL_DENSITY -colorspace RGB -gravity center -background white  $TEMP/back.jpg $TEMP/back.pdf

convert -density 600 -colorspace RGB $TEMP/front.pdf $TEMP/back.pdf ./out/Witchfinder_General.pdf

#montage -border 1 -bordercolor black -tile x3 -geometry "$CARD_WIDTH"x"$CARD_HEIGHT"$CARD_X_OFFSET$CARD_Y_OFFSET  $FRONT_ORDER $TEMP/front.jpg
#montage -border 1 -bordercolor black -tile x3 -geometry "$CARD_WIDTH"x"$CARD_HEIGHT"$CARD_X_OFFSET$CARD_Y_OFFSET  $BACK_ORDER $TEMP/back.jpg
#convert -extent "$PAGE_WIDTH"x"$PAGE_HEIGHT" -density $PIXEL_DENSITY -gravity center -background white  $TEMP/front.jpg $TEMP/front.pdf
#convert -extent "$PAGE_WIDTH"x"$PAGE_HEIGHT" -density $PIXEL_DENSITY -gravity center -background white  $TEMP/back.jpg $TEMP/back.pdf
#convert -density $PIXEL_DENSITY $TEMP/front.pdf $TEMP/back.pdf ./out/Witchfinder_General.pdf

echo "Create tts files"
convert +append $TEMP/$FRONT_1 $TEMP/$FRONT_2 $TEMP/$FRONT_3 $TEMP/$FRONT_4 $TEMP/$FRONT_5 $TEMP/$FRONT_6 $TEMP/$FRONT_7 $TEMP/$FRONT_8 $TEMP/$FRONT_9 out/tts_front.png
convert +append $TEMP/$BACK_1 $TEMP/$BACK_2 $TEMP/$BACK_3 $TEMP/$BACK_4 $TEMP/$BACK_5 $TEMP/$BACK_6 $TEMP/$BACK_7 $TEMP/$BACK_8 $TEMP/$BACK_9 out/tts_back.png
convert out/tts_front.png -resize 6588x2076 -background white -gravity North -extent 6588x2076 out/tts_front.jpg
convert out/tts_back.png -resize 6588x2076 -background white -gravity North -extent 6588x2076 out/tts_back.jpg

rm -rf $TEMP