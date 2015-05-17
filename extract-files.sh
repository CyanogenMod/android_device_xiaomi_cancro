#!/bin/bash

set -e

export VENDOR=xiaomi
export DEVICE=cancro

function extract() {
    for FILE in `egrep -v '(^#|^$)' $1`; do
        OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
        FILE=`echo ${PARSING_ARRAY[0]} | sed -e "s/^-//g"`
        DEST=${PARSING_ARRAY[1]}
        if [ -z $DEST ]; then
            DEST=$FILE
        fi
        DIR=`dirname $FILE`
        if [ ! -d $2/$DIR ]; then
            mkdir -p $2/$DIR
        fi
        # Try CM target first
        adb pull /system/$DEST $2/$DEST
        # if file does not exist try OEM target
        if [ "$?" != "0" ]; then
            adb pull /system/$FILE $2/$DEST
        fi
    done
}



DEVBASE=../../../vendor/$VENDOR/$DEVICE/proprietary
rm -rf $DEVBASE/*

extract ../../$VENDOR/$DEVICE/device-proprietary-files.txt $DEVBASE

./../../$VENDOR/$DEVICE/setup-makefiles.sh
