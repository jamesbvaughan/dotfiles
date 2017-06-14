#!/bin/sh
# James' backup script

SRC=~
DEST=/run/media/james/james-backup

# rsync -avzh --delete --progress2 $SRC $DEST
rsync -azh --delete --info=progress2 $SRC $DEST
