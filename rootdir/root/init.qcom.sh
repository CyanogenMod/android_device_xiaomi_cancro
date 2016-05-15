#!/system/bin/sh
# Copyright (c) 2009-2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

target=`getprop ro.board.platform`
if [ -f /sys/devices/soc0/soc_id ]; then
    platformid=`cat /sys/devices/soc0/soc_id`
else
    platformid=`cat /sys/devices/system/soc/soc0/id`
fi
#
# Function to start sensors for DSPS enabled platforms
#
start_sensors()
{
    if [ -c /dev/msm_dsps -o -c /dev/sensors ]; then
        mkdir -p /data/system/sensors
        chown -h system.system /data/system/sensors
        touch /data/system/sensors/settings
        chmod -h 775 /data/system/sensors
        chmod -h 664 /data/system/sensors/settings
        chown -h system /data/system/sensors/settings

        mkdir -p /data/misc/sensors
        chmod -h 775 /data/misc/sensors
        mkdir -p /persist/misc/sensors
        chmod 775 /persist/misc/sensors

        if [ ! -s /data/system/sensors/settings ]; then
            # If the settings file is empty, enable sensors HAL
            # Otherwise leave the file with it's current contents
            echo 1 > /data/system/sensors/settings
        fi
        start sensors
    fi
}

start_battery_monitor()
{
	if ls /sys/bus/spmi/devices/qpnp-bms-*/fcc_data ; then
		chown -h root.system /sys/module/pm8921_bms/parameters/*
		chown -h root.system /sys/module/qpnp_bms/parameters/*
		chown -h root.system /sys/bus/spmi/devices/qpnp-bms-*/fcc_data
		chown -h root.system /sys/bus/spmi/devices/qpnp-bms-*/fcc_temp
		chown -h root.system /sys/bus/spmi/devices/qpnp-bms-*/fcc_chgcyl
		chmod -h 0660 /sys/module/qpnp_bms/parameters/*
		chmod -h 0660 /sys/module/pm8921_bms/parameters/*
		mkdir -p /data/bms
		chown -h root.system /data/bms
		chmod -h 0770 /data/bms
		start battery_monitor
	fi
}

start_charger_monitor()
{
	if ls /sys/module/qpnp_charger/parameters/charger_monitor; then
		chown -h root.system /sys/module/qpnp_charger/parameters/*
		chown root.system /sys/class/power_supply/battery/input_current_max
		chown root.system /sys/class/power_supply/battery/input_current_trim
		chown root.system /sys/class/power_supply/battery/input_current_settled
		chown root.system /sys/class/power_supply/battery/voltage_min
		chmod 0664 /sys/class/power_supply/battery/input_current_max
		chmod 0664 /sys/class/power_supply/battery/input_current_trim
		chmod 0664 /sys/class/power_supply/battery/input_current_settled
		chmod 0664 /sys/class/power_supply/battery/voltage_min
		chmod 0664 /sys/module/qpnp_charger/parameters/charger_monitor
		start charger_monitor
	fi
}

start_copying_prebuilt_qcril_db()
{
    if [ -f /system/vendor/qcril.db -a ! -f /data/misc/radio/qcril.db ]; then
        cp /system/vendor/qcril.db /data/misc/radio/qcril.db
        chown -h radio.radio /data/misc/radio/qcril.db
    fi
}


baseband=`getprop ro.baseband`
#
# Suppress default route installation during RA for IPV6; user space will take
# care of this
# exception default ifc
for file in /proc/sys/net/ipv6/conf/*
do
  echo 0 > $file/accept_ra_defrtr
done
echo 1 > /proc/sys/net/ipv6/conf/default/accept_ra_defrtr

case "$baseband" in
        "svlte2a")
        start bridgemgrd
        ;;
esac

# start sensor related operation when the device is not X5
if [ $(getprop ro.boot.hwversion | grep -e 5[0-9]) ]; then
    /system/bin/log -p e -t "SensorSelect" "Device is X5, not call 'start_sensors'"
else
    /system/bin/log -p e -t "SensorSelect" "Device is not X5, call 'start_sensors'"
    start_sensors
fi

if [ $(getprop ro.boot.hwversion | grep -e 4[0-9]) ]; then
    echo 20 > /sys/class/leds/button-backlight/max_brightness
    echo 20 > /sys/class/leds/button-backlight1/max_brightness
fi

leftvalue=`getprop permanent.button.bl.leftvalue`
rightvalue=`getprop permanent.button.bl.rightvalue`

# update the brightness to meet the requirement from HW
if [ $(getprop ro.boot.hwversion | grep -e 5[0-9]) ]; then
    if [ "$leftvalue" = "" ]; then
        echo 15 > /sys/class/leds/button-backlight1/max_brightness
    else
        echo $leftvalue > /sys/class/leds/button-backlight1/max_brightness
    fi
    if [ "$rightvalue" = "" ]; then
        echo 9 > /sys/class/leds/button-backlight/max_brightness
    else
        echo $rightvalue > /sys/class/leds/button-backlight/max_brightness
    fi
fi

# Update the panel color property
if [ $(getprop ro.boot.hwversion | grep -e 5[0-9]) ]; then
    if [ -f /sys/bus/i2c/devices/2-004c/panel_color ]; then
        # Atmel
        color=`cat /sys/bus/i2c/devices/2-004c/panel_color`
    elif [ -d /sys/bus/i2c/devices/2-0020/input ]; then
        # Synaptics
        syna_folder=`ls /sys/bus/i2c/devices/2-0020/input/ | grep -e ^input`
        if [ -f /sys/bus/i2c/devices/2-0020/input/$syna_folder/panelcolor ]; then
            color=`cat /sys/bus/i2c/devices/2-0020/input/$syna_folder/panelcolor`
        fi
    else
        color="0"
    fi

    case "$color" in
        "1")
            setprop sys.panel.color WHITE
            echo WHITE
            ;;
        "2")
            setprop sys.panel.color BLACK
            echo BLACK
            ;;
        "6")
            setprop sys.panel.color PINK
            echo PINK
            ;;
        *)
            setprop sys.panel.color UNKNOWN
            echo UNKNOWN
            ;;
    esac
fi

case "$target" in
    "msm7630_surf" | "msm7630_1x" | "msm7630_fusion")
        if [ -f /sys/devices/soc0/hw_platform ]; then
            value=`cat /sys/devices/soc0/hw_platform`
        else
            value=`cat /sys/devices/system/soc/soc0/hw_platform`
        fi
        case "$value" in
            "Fluid")
             start profiler_daemon;;
        esac
        ;;
    "msm8660" )
        if [ -f /sys/devices/soc0/hw_platform ]; then
            platformvalue=`cat /sys/devices/soc0/hw_platform`
        else
            platformvalue=`cat /sys/devices/system/soc/soc0/hw_platform`
        fi
        case "$platformvalue" in
            "Fluid")
                start profiler_daemon;;
        esac
        ;;
    "msm8960")
        case "$baseband" in
            "msm")
                start_battery_monitor;;
        esac

        if [ -f /sys/devices/soc0/hw_platform ]; then
            platformvalue=`cat /sys/devices/soc0/hw_platform`
        else
            platformvalue=`cat /sys/devices/system/soc/soc0/hw_platform`
        fi
        case "$platformvalue" in
             "Fluid")
                 start profiler_daemon;;
             "Liquid")
                 start profiler_daemon;;
        esac
        ;;
    "msm8974")
        platformvalue=`cat /sys/devices/soc0/hw_platform`
        case "$platformvalue" in
             "Fluid")
                 start profiler_daemon;;
             "Liquid")
                 start profiler_daemon;;
        esac
        case "$baseband" in
            "msm")
                start_battery_monitor
                ;;
        esac
        start_charger_monitor
        ;;
    "msm8226")
        start_charger_monitor
        ;;
    "msm8610")
        start_charger_monitor
        ;;
esac

bootmode=`getprop ro.bootmode`
emmc_boot=`getprop ro.boot.emmc`
case "$emmc_boot"
    in "true")
        if [ "$bootmode" != "charger" ]; then # start rmt_storage and rfs_access
            start rmt_storage
            start rfs_access
        fi
    ;;
esac

#
# Copy qcril.db if needed for RIL
#
start_copying_prebuilt_qcril_db
echo 1 > /data/misc/radio/db_check_done
