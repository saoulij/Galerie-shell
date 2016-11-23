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
