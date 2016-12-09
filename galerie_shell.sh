#!/bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)

SOURCE="$DIR"
DEST="$DIR"
VERB=0
FORCE=0
INDEX="index.html"
HELP=0

while [ $# -gt 0 ]
do
key="$1"

case $key in
  --source)
    if [ ! -d "$2" ]; then
      echo "$2: no such directory"
      exit 1
    fi
    SOURCE="$(cd "$2"; pwd)"
    shift
    ;;
  --dest)
    if [ ! -d "$2" ]; then mkdir -p "$2"; fi
    DEST="$(cd "$2"; pwd)"
    shift
    ;;
  --verb)
    VERB=1
    ;;
  --force)
    FORCE=1
    ;;
  --help)
    HELP=1
    ;;
  --index)
    filename="$(basename "$2")"
    extension="${filename##*.}"
    if [ "$extension" != ".jpg" ]; then
      echo "$2: extension should be '.html'"
      exit 1
    fi
    INDEX="$2"
    shift
    ;;
esac
shift
done

if [ $HELP -ne 0 ]
then
  echo "usage: ./galerie_shell.sh [--source REP] [--dest REP] [--verb] [--force] [--help] [--index FICHIER]
  --source REP : Répertoire contenant les images JPEG à miniaturiser.
  --dest REP : Répertoire cible (où on va générer les vignettes et le fichier HTML).
  --verb : mode \"verbeux\".
  --force : Forcer la création de vignette, même si la vignette existe déjà.
  --help : Afficher la liste des options disponibles, et quitter.
  --index FICHIER : générer la galerie dans le fichier spécifié au lieu de générer un fichier index.html.
  "
  exit 0
fi

if [ $VERB -ne 0 ]
then
  echo "SOURCE=$SOURCE"
  echo "DEST=$DEST"
  echo "VERB=$VERB"
  echo "FORCE=$FORCE"
  echo "HELP=$HELP"
  echo "INDEX=$INDEX"
fi

. "$DIR"/utilities.sh

galerie_main "$SOURCE" "$DEST" "$FORCE" "$DEST/$INDEX"

if [ -f "$INDEX" ]
then
    echo "Now run 'firefox $INDEX' to check the result"
else
    echo "ERROR: $INDEX was not generated"
fi
