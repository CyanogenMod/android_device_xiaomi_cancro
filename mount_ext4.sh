#!/system/bin/sh
export PATH=/system/bin:/system/xbin:$PATH
BLOCK_DEVICE=$1
MOUNT_POINT=$2
LOG_FILE="/dev/null"
LOG_LOCATION="/data/.fsck_log/"
TMP_LOG_LOCATION="/dev/.fsck_log/"

if [ "${MOUNT_POINT}" == "/data" ]; then
    mkdir -p ${TMP_LOG_LOCATION}
    chmod 600 ${TMP_LOG_LOCATION}
    TIMESTAMP=`date +%F_%H-%M-%S`
    LOG_FILE=${TMP_LOG_LOCATION}/data_${TIMESTAMP}.log
elif [ "${MOUNT_POINT}" == "/cache" ]; then
    mkdir -p ${LOG_LOCATION}
    chmod 600 ${LOG_LOCATION}
    TIMESTAMP=`date +%F_%H-%M-%S`
    LOG_FILE=${LOG_LOCATION}/cache_${TIMESTAMP}.log
elif [ "${MOUNT_POINT}" == "/persist" ]; then
    busybox find ${LOG_LOCATION} -type f -mtime +14  -exec rm {} \;
    busybox mv ${TMP_LOG_LOCATION}/* ${LOG_LOCATION}/
    TIMESTAMP=`date +%F_%H-%M-%S`
    LOG_FILE=${LOG_LOCATION}/persist_${TIMESTAMP}.log
fi

if [ -e ${BLOCK_DEVICE} ]; then
    /system/bin/dumpe2fs -h ${BLOCK_DEVICE} 2>&1 >${LOG_FILE}
    ret1=$?
    if [ $ret1 -ne 0 ];then
        mke2fs -T ext4 -j -L ${MOUNT_POINT} ${BLOCK_DEVICE}
        ret2=$?
        echo "${PART_ALIAS} partition format ret = $ret2"
        if [ $ret2 -ne 0 ];then
            exit 1
        fi
    fi

    e2fsck -y ${BLOCK_DEVICE} 2>&1 >>${LOG_FILE}
    ret3=$?
    echo "e2fsck on ${BLOCK_DEVICE} ret = $ret3" 2>&1 >>${LOG_FILE}

    mount -t ext4 -o nosuid,nodev,barrier=1,noauto_da_alloc,discard ${BLOCK_DEVICE} ${MOUNT_POINT}

    if [ -e ${MOUNT_POINT}/extend_size.userdata ]; then
        umount ${MOUNT_POINT}
        e2fsck -f -y ${BLOCK_DEVICE}
        ret4=$?
        echo "Forced e2fsck on ${BLOCK_DEVICE} ret = $ret4"
        if [ $ret4 -eq 4 ]; then
            e2fsck -y ${BLOCK_DEVICE}
        fi
        resize2fs ${BLOCK_DEVICE}
        ret5=$?
        echo "resize ${BLOCK_DEVICE} ret = $ret5"
        e2fsck -y ${BLOCK_DEVICE}
        ret6=$?
        echo "e2fsck on ${BLOCK_DEVICE} ret = $ret6"
        mount -t ext4 -o nosuid,nodev,barrier=1,noauto_da_alloc,discard ${BLOCK_DEVICE} ${MOUNT_POINT}
        if [ $ret5 -eq 0 -o $ret5 -eq 2 ]; then
            rm ${MOUNT_POINT}/extend_size*
        fi
    fi
fi

# hide recovery partition
RECOVERY_NODE="$(busybox readlink -f /dev/block/platform/msm_sdcc.1/by-name/recovery)"
busybox mv "${RECOVERY_NODE}" /dev/recovery_moved
busybox mknod -m 0600 "${RECOVERY_NODE}" b 1 3
