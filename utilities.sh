#! /bin/sh

html_head () {
cat << EOF > "$1"
<!DOCTYPE html>
  <html>
      <head>
          <meta charset=utf-8 />
          <title>$2</title>
          <style>
          body {
              background-color: #DCDCDC;
              font-size: 100%;
          }

          h1 {
            text-align: center;
            font-size: 3em;
            font-family: Verdana, Sans-Serif;
          }

          .imageframe {
            float: left;
            background-color: white;
            border: 1px dashed #C0C0C0;
            padding: 8px;
            margin: 8px;
            text-align:center;
          }

          .image {
            border: 1px solid black;
            border-radius: 5px;
          }

          .legend {
            font-style: italic;
            font-family: "Times New Roman", Serif;
            font-size: 1.5em;
            text-transform: capitalize;
          }
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
        <img class="image" src=$2 alt=$name><br>
        <span class="legend">$name</span>
        </div>

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
          vignette="$2/vignette/$(basename "$img")"
          if [ ! -f "$vignette" ] || [ "$3" -eq 1 ];
          then
            gmic "$img" -cubism , -resize 200,200 -output "$vignette"
          fi
        generate_img_fragment "$4" "$vignette"
      fi
    done
}

galerie_main () {
  html_head "$4" "Galerie HTML"
  html_title "$4" "Galerie d'images"
  generate_galerie "$1" "$2" "$3" "$4"
  html_tail "$4"
}
