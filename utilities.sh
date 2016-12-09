#! /bin/bash

html_head () {
  cat << EOF > "$1"
<!DOCTYPE html>
  <html>
    <head>
        <meta charset=utf-8 />
        <title>$2</title>
        <style>
EOF
  cat "$3" >> "$1"
  cat << EOF >> "$1"
        </style>
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
  cat << EOF >> "$INDEX"
        <div class="imageframe">
        <a href="$DEST/$imgname.html">
        <img class="image" src=$vignette alt=$imgname>
        </a><br>
        <span class="legend">$imgname</span>
        </div>

EOF
}

generate_navi () {
  if [ $i -ne 0 ]; then
    p=$(($i-1))
    prec="$DEST/$(basename -s .jpg ${IMG[p]}).html"
    cat << EOF >> "$1"
          <li><a href="$prec">Précédent</a></li>
EOF
fi

  if [ $i -ne $(( ${#IMG[@]} - 1 )) ]; then
    s=$(($i+1))
    suiv="$DEST/$(basename -s .jpg ${IMG[s]}).html"
    cat << EOF >> "$1"
        <li><a href="$suiv">Suivant</a></li>
EOF
  fi

  cat << EOF >> "$1"
          <li><a href="$INDEX">Retour à la galerie</a></li>
          </ul>

EOF
}

generate_img_html () {
  html_head "$1" "$imgname" "image_style.css"
  html_title "$1" "$imgname"

  cat << EOF >> "$1"
        <div class="imageframe">
        <img class="image" src=$SOURCE/$imgname.jpg alt=$imgname><br>
        </div>

        <ul>

EOF

  generate_navi "$1"
  html_tail "$1"
}

generate_galerie () {
    if [ ! -d "$DEST/vignette" ];
    then
      mkdir "$DEST/vignette"
    fi

    for i in "${!IMG[@]}";
    do
      if [ -r "${IMG[i]}" ];
      then
          imgname="$(basename -s .jpg "${IMG[i]}")"
          vignette="$DEST/vignette/$(basename "${IMG[i]}")"
          if [ ! -f "$vignette" ] || [ "$FORCE" -eq 1 ];
          then
            gmic "${IMG[i]}" -cubism , -resize 200,200 -output "$vignette"
          fi

      generate_img_fragment
      generate_img_html "$DEST/$imgname.html"

      fi
    done
}

galerie_main () {
  SOURCE="$1"
  DEST="$2"
  FORCE="$3"
  INDEX="$4"
  IMG=("$SOURCE"/*.jpg)

  html_head "$INDEX" "Galerie HTML" "galerie_style.css"
  html_title "$INDEX" "Galerie d'images"
  generate_galerie
  html_tail "$INDEX"
}
