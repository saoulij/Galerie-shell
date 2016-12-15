#! /bin/bash

html_head () {
  if [ "$VERB" -eq 1 ]; then echo "creation de $(basename "$1") et ajout de l'entete"; fi

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
  if [ "$VERB" -eq 1 ]; then echo "ajout d'un titre a $(basename "$1")"; fi

  cat << EOF >> "$1"
       <h1>$2</h1>

EOF
}

html_tail () {
  if [ "$VERB" -eq 1 ]; then echo "ajout du code fin a $(basename "$1")"; fi

  cat << EOF >> "$1"
      </body>
  </html>
EOF
}

generate_img_fragment () {
  if [ "$VERB" -eq 1 ]; then echo "ajout de la vignette $(basename "$vignette") a $(basename "$INDEX")"; fi

  cat << EOF >> "$INDEX"
        <div class="frame">
        <div class="imageframe">
        <a href="$DEST/$imgname.html">
        <img class="image" src=$vignette alt=$imgname>
        </a></div><br>
        <span class="legend">$imgname</span>
        </div>

EOF
}

generate_navi () {
  if [ "$VERB" -eq 1 ]; then echo "generation de la navigation sur la page $(basename "$1")"; fi

  if [ "$i" -ne 0 ]; then
    p=($i-1)
    prec="$DEST/$(basename -s .jpg "${IMG[p]}").html"
    cat << EOF >> "$1"
          <li><a href="$prec">Précédent</a></li>
EOF
fi

  if [ "$i" -ne $(( ${#IMG[@]} - 1 )) ]; then
    s=($i+1)
    suiv="$DEST/$(basename -s .jpg "${IMG[s]}").html"
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
  if [ "$VERB" -eq 1 ]; then echo "generation de la page $(basename "$1")"; fi

  html_head "$1" "$imgname" "image_style.css"
  html_title "$1" "$imgname"

  if [ "$VERB" -eq 1 ]; then echo "ajout de $imgname a $(basename "$1")"; fi
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
      if [ "$VERB" -eq 1 ]; then echo "mkdir: creation du repertoire vignette"; fi
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
            if [ "$VERB" -eq 1 ]; then echo "creation de la vignette de l'image $imgname"; fi
          fi

      generate_img_fragment
      generate_img_html "$DEST/$imgname.html"

      fi
    done
}

galerie_main () {
  IMG=("$SOURCE"/*.jpg)

  html_head "$INDEX" "Galerie HTML" "galerie_style.css"
  html_title "$INDEX" "Galerie d'images"
  generate_galerie
  html_tail "$INDEX"
}
