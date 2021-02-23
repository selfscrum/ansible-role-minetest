#!/bin/bash

# mode mods so that the unzipped directories match the server
# usage from within ansible: movemod.sh <zipfile> <mod-dir>
# pre: zip file content exists and possibly the new-dir from a previous run
# post: zip file content is moved to new-dir

zip=$1
newdir=$2

if [[ -z $zip || -z $newdir ]] ; then
    echo "Usage: movemod.sh <zip-file> <mod-dir>"
    exit 1
fi

mkdir -p /tmp/zip.$$
mv $zip /tmp/zip.$$
cd /tmp/zip.$$
unzip $(basename $zip)
rm $(basename $zip)

if [[ $(ls -1 | wc -l) -ne 1 ]] ; then
    echo "Unsupported zip file format"
    exit 1
fi

unzipped=$(ls -1)

if [[ ! -d $unzipped ]] ; then
    echo "Unsupported zip file format"
    exit 1
fi


if [[ -e $newdir ]] ; then
    rm -rf $newdir
fi

mv $unzipped $newdir
rm -rf /tmp/zip.$$
