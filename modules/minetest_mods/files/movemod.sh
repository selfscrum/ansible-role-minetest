#!/bin/bash

# mode mods so that the unzipped directories match the server
# usage from within ansible: movemod.sh <original-dir> <new-dir>
# pre: zip file content exists and possibly the new-dir from a previous run
# post: zip file content is moved to new-dir


originaldir=$1
newdir=$2

if [[ -z $originaldir || -z $newdir ]] ; then
    echo "Usage: movemod.sh <original-dir> <new-dir>"
    exit 1
fi

if [[ -e $newdir ]] ; then
    rm -rf $newdir
fi

if [[ -e $originaldir ]] ; then
    mv $originaldir $newdir
fi