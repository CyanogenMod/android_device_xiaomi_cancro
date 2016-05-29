#!/system/bin/sh

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

target=`getprop ro.product.model`
powermode=`getprop sys.perf.profile`
dev_governor=`ls /sys/class/devfreq/qcom,cpubw*/governor`

case "$powermode" in
    "2")
        #Performance
        stop mpdecision
        echo 1            > /sys/devices/system/cpu/cpu0/online
        echo 1            > /sys/devices/system/cpu/cpu1/online
        echo 1            > /sys/devices/system/cpu/cpu2/online
        echo 1            > /sys/devices/system/cpu/cpu3/online
        echo 0            > /sys/devices/system/cpu/sched_mc_power_savings
        echo performance  > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo performance  > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
        echo performance  > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
        echo performance   > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
        echo 20            > /sys/module/cpu_boost/parameters/boost_ms
        echo 1497600       > /sys/module/cpu_boost/parameters/input_boost_freq
        echo 40            > /sys/module/cpu_boost/parameters/input_boost_ms
        echo 1728000       > /sys/module/cpu_boost/parameters/sync_threshold
        echo 578000000     > /sys/class/kgsl/kgsl-3d0/max_gpuclk
        echo performance   > /sys/class/kgsl/kgsl-3d0/devfreq/governor
        echo "msm_cpufreq" > $dev_governor
        case "$target" in
            "MI 3W")
                echo 2265600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
                echo 2265600 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
                echo 2265600 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
                echo 2265600 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
                ;;
            "MI 4"*)
                echo 2457600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
                echo 2457600 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
                echo 2457600 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
                echo 2457600 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
                ;;
        esac
        ;;
    "1")
        #Balanced
        echo 1                                   > /sys/devices/system/cpu/cpu0/online
        echo 1                                   > /sys/devices/system/cpu/cpu1/online
        echo 1                                   > /sys/devices/system/cpu/cpu2/online
        echo 1                                   > /sys/devices/system/cpu/cpu3/online
        echo 2                                   > /sys/devices/system/cpu/sched_mc_power_savings
        echo interactive                         > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo interactive                         > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
        echo interactive                         > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
        echo interactive                         > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
        echo "19000 1400000:39000 1700000:19000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
        echo 99                                  > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
        echo 1497600                             > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
        echo 40000                               > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
        echo 20                                  > /sys/module/cpu_boost/parameters/boost_ms
        echo 1728000                             > /sys/module/cpu_boost/parameters/sync_threshold
        echo 1497600                             > /sys/module/cpu_boost/parameters/input_boost_freq
        echo 40                                  > /sys/module/cpu_boost/parameters/input_boost_ms
        echo 578000000                           > /sys/class/kgsl/kgsl-3d0/max_gpuclk
        echo msm-adreno-tz                       > /sys/class/kgsl/kgsl-3d0/devfreq/governor
        echo "cpubw_hwmon"                       > $dev_governor
        case "$target" in
            "MI 3W")
                echo 2265600                    > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
                echo 2265600                    > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
                echo 2265600                    > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
                echo 2265600                    > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
                echo "85 1500000:90 1800000:70" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
                ;;
            "MI 4"*)
                echo 2457600         > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
                echo 2457600         > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
                echo 2457600         > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
                echo 2457600         > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
                echo "85 1500000:99" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
                ;;
        esac
        start mpdecision
        ;;
    "0")
        #PowerSave
        stop mpdecision
        echo 1             > /sys/devices/system/cpu/cpu0/online
        echo 0             > /sys/devices/system/cpu/cpu1/online
        echo 0             > /sys/devices/system/cpu/cpu2/online
        echo 0             > /sys/devices/system/cpu/cpu3/online
        echo 2             > /sys/devices/system/cpu/sched_mc_power_savings
        echo conservative  > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo conservative  > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo conservative  > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
        echo conservative  > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
        echo conservative  > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
        echo 0             > /sys/module/cpu_boost/parameters/boost_ms
        echo 960000        > /sys/module/cpu_boost/parameters/sync_threshold
        echo 960000        > /sys/module/cpu_boost/parameters/input_boost_freq
        echo 40            > /sys/module/cpu_boost/parameters/input_boost_ms
        echo 330000000     > /sys/class/kgsl/kgsl-3d0/max_gpuclk
        echo msm-adreno-tz > /sys/class/kgsl/kgsl-3d0/devfreq/governor
        echo "cpubw_hwmon" > $dev_governor
        echo 1036800       > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
        echo 1036800       > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
        echo 1036800       > /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq
        echo 1036800       > /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq
        ;;
esac
