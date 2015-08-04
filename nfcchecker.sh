#!/tmp/busybox sh
#
# Copyright (C) 2015 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:${PATH}


# ui_print
OUTFD=$(\
    /tmp/busybox ps | \
    /tmp/busybox grep -v "grep" | \
    /tmp/busybox grep -o -E "/tmp/updater .*" | \
    /tmp/busybox cut -d " " -f 3\
);

if /tmp/busybox test -e /tmp/update_binary ; then
    OUTFD=$(\
        /tmp/busybox ps | \
        /tmp/busybox grep -v "grep" | \
        /tmp/busybox grep -o -E "update_binary(.*)" | \
        /tmp/busybox cut -d " " -f 3\
    );
fi

ui_print() {
    if [ "${OUTFD}" != "" ]; then
        echo "ui_print ${1} " 1>&"${OUTFD}";
        echo "ui_print " 1>&"${OUTFD}";
    else
        echo "${1}";
    fi
}

deletenfc() {
/tmp/busybox rm -rf /system/app/NfcNci/;
/tmp/busybox rm -rf /system/priv-app/Tag/;
ui_print "NFC Deleted!";
}


if /tmp/busybox grep -q 1974 /sys/devices/system/soc/soc0/raw_id; then
deletenfc;

elif /tmp/busybox grep -q 1972 /sys/devices/system/soc/soc0/raw_id; then
deletenfc;

else
ui_print "Keeping NFC!";

fi

exit 0
