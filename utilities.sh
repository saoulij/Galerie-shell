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
    for img in *.jpg;
    do
      if [ -f "$img" ];
      then
        if [ ! -f "v_$img" ];
        then
          gmic "$img" -cubism , -resize 200,200 -output "v_$img"
        fi
        generate_img_fragment "v_$img"
      fi
    done
}

galerie_main () {
  (
  html_head "Test de la génération de HTML"
  html_title 'Galerie HTML'
  generate_galerie
  html_tail
  ) > index.html
}
