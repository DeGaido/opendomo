#!/bin/sh
#desc:Install plugin file
# This script will install the plugin file or exit with error codes.
# It will ignore versions of the files, so it can be used to install an older
# version than the installed one.

# Copyright(c) 2014 OpenDomo Services SL. Licensed under GPL v3 or later

if test -z "$1"
then
    echo "usage: $0 pluginID"
    echo "usage: $0 /path/to/plugin.file"
    echo
    exit 1
fi

if test -f "$1"
then
    # If the parameter is a file, the name should be composed by PKGID-VERSION
    PKGID=`basename $1| cut -f1 -d'-'`
	PKGVER=`basename $1| cut -f1 -d. | cut -f2 -d-`
else
	# otherwise, the version will be taken from the repository index
    PKGID="$1"
	PKGVER=""
fi

# The repository index file must exist.
# Otherwise it will trigger a self-explanatory error.
REPOFILE="/var/opendomo/tmp/repo.lst"
if ! test -f "$REPOFILE"
then
	echo "#ERROR $REPOFILE does not exist. Launch managePlugins.sh and try again"
	exit 2
fi
DEPS=`grep ^$1 $REPOFILE| cut -f4 -d';' |sort |head -n1`
URLFILE=`grep ^$1 $REPOFILE| cut -f2 -d';' |sort |head -n1`
PROGRESS="/var/opendomo/run/$PKGID.progress"
STORAGE="/mnt/odconf/plugins"

if ! test -d $STORAGE
then
    mkdir -p $STORAGE
fi

LFILE="$STORAGE/`basename $URLFILE`"

echo "00" > $PROGRESS


if wget $URLFILE -O $LFILE -q --no-check-certificate
then
    SHA1=`grep ^$1 $REPOFILE| cut -f5 -d';' |sort |head -n1`
	PKGVER=`basename $LFILE| cut -f1 -d'.' | cut -f2 -d'-'`
    #TODO Check SHA1
else
    exit 2
fi
echo "50" > $PROGRESS

#Execute as root
if ! test -z "$DEPS"; then
	sudo apt-get update
    sudo apt-get install $DEPS -y
else
	echo "No dependencies found"
fi
echo "75" > $PROGRESS

#Saving timestamp
echo $PKGVER > /var/opendomo/plugins/$PKGID.version

cd /
echo $LFILE | grep ".tar.gz" - && /bin/tar -m --no-overwrite-dir -zxvf $LFILE | grep -v /$ > /var/opendomo/plugins/$PKGID.files
echo $LFILE | grep ".zip" - && /usr/local/bin/unzip -o $LFILE | grep -v /$ | cut -f2 -d':' |sed 's/ //'> /var/opendomo/plugins/$PKGID.files
rm $PROGRESS
