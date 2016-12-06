#! /bin/sh

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
name="$(basename -s .jpg "$2")"
cat << EOF >> "$1"
        <div class="imageframe">
        <a href="$3/$name.html">
        <img class="image" src=$2 alt=$name>
        </a><br>
        <span class="legend">$name</span>
        </div>

EOF
}

generate_img_html () {
  pagename=""$2"/"$3".html"
  html_head "$pagename" "$3" "image_style.css"
  html_title "$pagename" "$3"
cat << EOF >> "$pagename"
        <div class="imageframe">
        <img class="image" src=$1/$3.jpg alt=$3><br>
        </div>

        <ul class="navbar">
        <li><a href="$4">Retour à la galerie</a></li>
        </ul>

EOF
  html_tail "$pagename"
}

generate_galerie () {
    for img in "$1/"*.jpg;
    do
      if [ -r "$img" ];
      then
        if [ ! -d ""$2"/vignette" ];
          then
            mkdir ""$2"/vignette"
          fi
          vignette=""$2"/vignette/$(basename "$img")"
          if [ ! -f "$vignette" ] || [ "$3" -eq 1 ];
          then
            gmic "$img" -cubism , -resize 200,200 -output "$vignette"
          fi
        generate_img_fragment "$4" "$vignette" "$2"
        generate_img_html "$1" "$2" "$(basename -s .jpg "$vignette")" "$4"
      fi
    done
}

galerie_main () {
  html_head "$4" "Galerie HTML" "galerie_style.css"
  html_title "$4" "Galerie d'images"
  generate_galerie "$1" "$2" "$3" "$4"
  html_tail "$4"
}
