#! /bin/sh

html_head () {
  pagename="$1"
  title="$2"
  css="$3"

cat << EOF > "$pagename"
<!DOCTYPE html>
  <html>
      <head>
          <meta charset=utf-8 />
          <title>$title</title>
          <style>
EOF
cat "$css" >> "$pagename"
cat << EOF >> "$pagename"
          </style>
      </head>

      <body>
EOF
}

html_title () {
  pagename="$1"
  title="$2"

cat << EOF >> "$pagename"
       <h1>$title</h1>

EOF
}

html_tail () {
  pagename="$1"

cat << EOF >> "$pagename"
    </body>
</html>
EOF
}

generate_img_fragment () {
  index="$1"
  source="$2"
  imgname="$(basename -s .jpg "$2")"
  pagename="$3/$imgname.html"

cat << EOF >> "$index"
        <div class="imageframe">
        <a href="$pagename">
        <img class="image" src=$source alt=$imgname>
        </a><br>
        <span class="legend">$imgname</span>
        </div>

EOF
}

generate_img_html () {
  imgsource="$1"
  imgname="$3"
  pagename="$2/$imgname.html"
  index="$4"

  html_head "$pagename" "$imgname" "image_style.css"
  html_title "$pagename" "$imgname"

cat << EOF >> "$pagename"
        <div class="imageframe">
        <img class="image" src=$imgsource alt=$imgname><br>
        </div>

        <ul>
        <li><a href="$index">Retour à la galerie</a></li>
        </ul>

EOF

  html_tail "$pagename"
}

generate_galerie () {
  source="$1"
  dest="$2"
  force="$3"
  index="$4"

    for img in "$source"/*.jpg;
    do
      if [ -r "$img" ];
      then

        if [ ! -d "$dest/vignette" ];
          then
            mkdir "$dest/vignette"
          fi

          vignette="$dest/vignette/$(basename "$img")"

          if [ ! -f "$vignette" ] || [ "$force" -eq 1 ];
          then
            gmic "$img" -cubism , -resize 200,200 -output "$vignette"
          fi

        generate_img_fragment "$index" "$vignette" "$dest"
        generate_img_html "$source" "$dest" "$(basename -s .jpg "$vignette")" "$index"

      fi
    done
}

galerie_main () {
  source="$1"
  dest="$2"
  force="$3"
  index="$4"

  html_head "$index" "Galerie HTML" "galerie_style.css"
  html_title "$index" "Galerie d'images"
  generate_galerie "$source" "$dest" "$force" "$index"
  html_tail "$index"
}
