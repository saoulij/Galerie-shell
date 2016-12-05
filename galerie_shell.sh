#!/bin/sh

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
    INDEX="$2"
    shift
    ;;
esac
shift
done

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
