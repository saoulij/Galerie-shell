#! /bin/sh

html_head () {
cat << EOF > "$1"
<!DOCTYPE html>
  <html>
      <head>
          <meta charset=utf-8 />
          <title>$2</title>
      </head>

      <body>

EOF
}

html_title () {
cat << EOF >> "$1"
       <h1>$2</h1>

EOF
}

html_tail () {
cat << EOF >> "$1"
    </body>
</html>
EOF
}

generate_img_fragment () {
cat << EOF >> "$1"
        <img src=$2 alt=$(basename -s .jpg $2)>

EOF
}

generate_galerie () {
    for img in "$1/"*.jpg;
    do
      if [ -r "$img" ];
      then
        if [ ! -d "$2/vignette" ];
          then
            mkdir "$2/vignette"
          fi
          vignette="$2/vignette/$(basename $img)"
          if [ ! -f "$vignette" ] || [ "$3" -eq 1 ];
          then
            gmic "$img" -cubism , -resize 200,200 -output "$vignette"
          fi
        generate_img_fragment "$4" "$vignette"
      fi
    done
}

galerie_main () {
  html_head "$4" "Test de la génération de HTML"
  html_title "$4" "Galerie HTML"
  generate_galerie "$1" "$2" "$3" "$4"
  html_tail "$4"
}
