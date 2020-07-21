#!/bin/bash

# detect userid:groupid of contents of data folder
DATA_DIR="${DATA_DIR:-/data}"
ARCHIVEBOX_USER="${ARCHIVEBOX_USER:-archivebox}"

# Autodetect UID and GID of host user based on ownership of files in the volume
USID=$(stat --format="%u" "$DATA_DIR")
GRID=$(stat --format="%g" "$DATA_DIR")
COMMAND="$@"

# run django as the host user's uid:gid so that any files touched have the same permissions as outside the container
# e.g. ./manage.py runserver

chown "$USID":"$GRID" "$DATA_DIR"
chown -R "$USID":"$GRID" "/home/$ARCHIVEBOX_USER"
usermod -u $USID $ARCHIVEBOX_USER
groupmod -g $GRID $ARCHIVEBOX_USER
gosu $ARCHIVEBOX_USER bash -c "$COMMAND"
