#! /bin/bash

# Teste si les vignette ne sont pas recrées si elles existent
# Teste ensuite si l'option --force force la création de nouvelles vignettes

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source dest
mkdir -p source dest

make-img.sh source/image-1.jpg

galerie-shell.sh --source source --dest dest

##################
echo -en "\033[1m\033[43m Generating, normal (no --force) \033[0m"
sleep 1;

date1=$(stat --format '%Y' dest/vignette/image-1.jpg)

galerie-shell.sh --source source --dest dest > /dev/null

date2=$(stat --format '%Y' dest/vignette/image-1.jpg)

if [ "$date1" -eq "$date2" ]
then
    echo -e "\033[1m\033[42m [SUCCESS] \033[0m: vignettes not regenerated."
else
    echo -e "\033[1m\033[41m [FAILED] \033[0m: vignettes regenerated!"
fi

###################
echo -en "\033[1m\033[43m Generating, use --force \033[0m"
sleep 1;

date1=$(stat --format '%Y' dest/vignette/image-1.jpg)

galerie-shell.sh --source source --dest dest --force > /dev/null

date2=$(stat --format '%Y' dest/vignette/image-1.jpg)

if [ "$date1" -eq "$date2" ]
then
    echo -e "\033[1m\033[41m [FAILED] \033[0m: vignettes not regenerated!"
else
    echo -e "\033[1m\033[42m [SUCCESS] \033[0m: vignettes regenerated."
fi

