#! /bin/sh

html_head () {
    echo "<!DOCTYPE html>"
    echo ""
    echo "<html>"
    echo "    <head>"
    echo "        <meta charset=utf-8 />"
    echo "        <title>$1</title>"
    echo "    </head>"
    echo ""
    echo "    <body>"
    echo ""
}

html_title () {
    echo "        <h1>$1</h1>"
    echo ""
}

html_tail () {
    echo "    </body>"
    echo "</html>"
}

generate_img_fragment () {
    echo "        <img src=$1 alt=$(basename -s .jpg $1)>"
    echo ""
}

generate_galerie () {
    for img in $(ls "$1/"*.jpg);
    do
      if [ -r "$img" ];
      then
        if [ ! -d "$2" ];
          then
            mkdir "$2"
          fi
          vignette="$2/$(basename $img)"
          if [ ! -f "$2/$img" ];
          then
            gmic "$img" -cubism , -resize 200,200 -output "$vignette"
          fi
        generate_img_fragment "$vignette"
      fi
    done
}

galerie_main () { #param: 1=source, 2=dest, 3=index
  (
  html_head "Test de la génération de HTML"
  html_title 'Galerie HTML'
  generate_galerie "$1" "$2"
  html_tail
  ) > "$3"
}
