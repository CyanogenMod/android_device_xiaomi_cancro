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
BOARD_VENDOR := xiaomi

CANCRO_PATH := device/xiaomi/cancro

# ReleaseTools
TARGET_RELEASETOOLS_EXTENSIONS := $(CANCRO_PATH)/releasetools
TARGET_RECOVERY_UPDATER_LIBS := librecovery_updater_cancro

TARGET_BOARD_INFO_FILE ?= $(CANCRO_PATH)/board-info.txt

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8974
TARGET_NO_BOOTLOADER         := true
TARGET_NO_RADIOIMAGE         := true

# Platform
TARGET_BOARD_PLATFORM     := msm8974
TARGET_BOARD_PLATFORM_GPU := qcom-adreno330

# Architecture
TARGET_ARCH         := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI      := armeabi-v7a
TARGET_CPU_ABI2     := armeabi
TARGET_CPU_SMP      := true
TARGET_CPU_VARIANT  := krait

# Flags
BOARD_GLOBAL_CFLAGS   += -D__ARM_USE_PLD -D__ARM_CACHE_LINE_SIZE=64 -DUSE_RIL_VERSION_10
BOARD_GLOBAL_CPPFLAGS += -DUSE_RIL_VERSION_10

# Kernel
BOARD_KERNEL_CMDLINE               := console=none vmalloc=340M androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3
BOARD_KERNEL_CMDLINE               += androidboot.selinux=permissive
BOARD_KERNEL_SEPARATED_DT          := true
BOARD_KERNEL_BASE                  := 0x00000000
BOARD_KERNEL_PAGESIZE              := 2048
BOARD_MKBOOTIMG_ARGS               := --ramdisk_offset 0x02000000 --tags_offset 0x01E00000
TARGET_KERNEL_SOURCE               := kernel/xiaomi/cancro
TARGET_KERNEL_ARCH                 := arm
TARGET_KERNEL_CONFIG               := cyanogen_cancro_defconfig
TARGET_KERNEL_CROSS_COMPILE_PREFIX := arm-linux-androideabi-
BOARD_DTBTOOL_ARGS                 := -2

# Vendor Init
TARGET_UNIFIED_DEVICE       := true
TARGET_INIT_VENDOR_LIB      := libinit_cancro
TARGET_LIBINIT_DEFINES_FILE := $(CANCRO_PATH)/init/init_cancro.cpp

# QCOM hardware
BOARD_USES_QCOM_HARDWARE            := true
TARGET_POWERHAL_VARIANT             := qcom
TARGET_POWERHAL_SET_INTERACTIVE_EXT := $(CANCRO_PATH)/power/power_ext.c

# Audio
BOARD_USES_ALSA_AUDIO                      := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true

# FM Radio
TARGET_FM_LEGACY_PATCHLOADER := true

# Bluetooth
BOARD_HAVE_BLUETOOTH                        := true
BOARD_HAVE_BLUETOOTH_QCOM                   := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(CANCRO_PATH)/bluetooth
QCOM_BT_USE_SMD_TTY                         := true
BLUETOOTH_HCI_USE_MCT                       := true

# Radio
TARGET_RIL_VARIANT                := caf
FEATURE_QCRIL_UIM_SAP_SERVER_MODE := true

# Graphics
USE_OPENGL_RENDERER               := true
TARGET_CONTINUOUS_SPLASH_ENABLED  := true
TARGET_USES_C2D_COMPOSITION       := true
TARGET_USE_COMPAT_GRALLOC_PERFORM := true
TARGET_USES_ION                   := true
OVERRIDE_RS_DRIVER                := libRSDriver_adreno.so
NUM_FRAMEBUFFER_SURFACE_BUFFERS   := 3

# Shader cache config options
# Maximum size of the  GLES Shaders that can be cached for reuse.
# Increase the size if shaders of size greater than 12KB are used.
MAX_EGL_CACHE_KEY_SIZE := 12*1024

# Maximum GLES shader cache size for each app to store the compiled shader
# binaries. Decrease the size if RAM or Flash Storage size is a limitation
# of the device.
MAX_EGL_CACHE_SIZE := 2048*1024

# Camera
TARGET_HAS_LEGACY_CAMERA_HAL1          := true
TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS := true
USE_DEVICE_SPECIFIC_CAMERA             := true

# Wifi
BOARD_HAS_QCOM_WLAN              := true
BOARD_WLAN_DEVICE                := qcwcn
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_FW_PATH_STA          := "sta"
WIFI_DRIVER_FW_PATH_AP           := "ap"
TARGET_PROVIDES_WCNSS_QMI        := true
TARGET_USES_QCOM_WCNSS_QMI       := true
TARGET_USES_WCNSS_CTRL           := true

# Filesystem
TARGET_USERIMAGES_USE_EXT4          := true
TARGET_USERIMAGES_USE_F2FS          := true
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE   := ext4
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_BOOTIMAGE_PARTITION_SIZE      := 16384000
BOARD_RECOVERYIMAGE_PARTITION_SIZE  := 16384000
BOARD_SYSTEMIMAGE_PARTITION_SIZE    := 1342177280
BOARD_USERDATAIMAGE_PARTITION_SIZE  := 13291503000
BOARD_CACHEIMAGE_PARTITION_SIZE     := 393216000
BOARD_PERSISTIMAGE_PARTITION_SIZE   := 16384000
BOARD_FLASH_BLOCK_SIZE              := 131072

# Recovery
RECOVERY_FSTAB_VERSION             := 2
TARGET_RECOVERY_DENSITY            := xhdpi
TARGET_RECOVERY_FSTAB              := $(CANCRO_PATH)/rootdir/root/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT       := "RGBX_8888"
TARGET_RECOVERY_LCD_BACKLIGHT_PATH := \"/sys/class/leds/lcd-backlight/brightness\"

# CM Hardware
BOARD_USES_CYANOGEN_HARDWARE = true
BOARD_HARDWARE_CLASS += \
    hardware/cyanogen/cmhw \
    $(CANCRO_PATH)/cmhw

# No old RPC for prop
TARGET_NO_RPC := true

# GPS HAL lives here
TARGET_GPS_HAL_PATH         := $(CANCRO_PATH)/gps
TARGET_PROVIDES_GPS_LOC_API := true

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"

# Keymaster
TARGET_KEYMASTER_WAIT_FOR_QSEE := true

# Simple time service client
BOARD_USES_QC_TIME_SERVICES := true

# Charger
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true

# Enable dex-preoptimization to speed up first boot sequence
ifeq ($(HOST_OS),linux)
  ifeq ($(TARGET_BUILD_VARIANT),user)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
    endif
  endif
endif
DONT_DEXPREOPT_PREBUILTS := true

# SELinux policies
# qcom sepolicy
include device/qcom/sepolicy/sepolicy.mk

BOARD_SEPOLICY_DIRS += \
        $(CANCRO_PATH)/sepolicy

-include vendor/xiaomi/cancro/BoardConfigVendor.mk
-include vendor/qcom/binaries/msm8974/graphics/BoardConfigVendor.mk
