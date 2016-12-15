#! /bin/sh

# Teste si les vignette ne sont pas recrées si elles existent
# Teste ensuite si l'option --force force la création de nouvelles vignettes

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source dest
mkdir -p source dest

make-img.sh source/image-1.jpg

galerie-shell.sh --source source --dest dest

if [ -f dest/index.html ]
then
    echo "Now run 'firefox dest/index.html' to check the result"
else
    echo "ERROR: dest/index.html was not generated"
fi

##################
echo "Generating, normal (no --force)"
sleep 1;

date1=$(stat --format '%Y' dest/vignette/image-1.jpg)

galerie-shell.sh --source source --dest dest

date2=$(stat --format '%Y' dest/vignette/image-1.jpg)

if [ $date1 -eq $date2 ]
then
    echo "[SUCCESS]: vignettes not regenerated."
else
    echo "[FAILED]: vignettes regenerated!"
fi

###################
echo "Generating, use --force"
sleep 1;

date1=$(stat --format '%Y' dest/vignette/image-1.jpg)

galerie-shell.sh --source source --dest dest --force

date2=$(stat --format '%Y' dest/vignette/image-1.jpg)

if [ $date1 -eq $date2 ]
then
    echo "[FAILED]: vignettes not regenerated!"
else
    echo "[SUCCESS]: vignettes regenerated."
fi

