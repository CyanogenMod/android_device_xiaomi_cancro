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

"""Custom OTA commands for cancro devices"""

import common
import os

TARGET_DIR = os.getenv('OUT')
UTILITIES_DIR = os.path.join(TARGET_DIR, 'utilities')
TARGET_DEVICE = os.getenv('CUSTOM_BUILD')

def FullOTA_Assertions(info):

  info.output_zip.write(os.path.join(TARGET_DIR, "nfcchecker.sh"), "nfcchecker.sh")
  info.output_zip.write(os.path.join(UTILITIES_DIR, "busybox"), "busybox")

  info.script.AppendExtra(
        ('package_extract_file("checksoc.sh", "/tmp/nfcchecker.sh");\n'
         'set_metadata("/tmp/nfcchecker.sh", "uid", 0, "gid", 0, "mode", 0777);'))
  info.script.AppendExtra(
        ('package_extract_file("busybox", "/tmp/busybox");\n'
         'set_metadata("/tmp/busybox", "uid", 0, "gid", 0, "mode", 0777);'))

def FullOTA_InstallEnd(info):

  info.script.AppendExtra('assert(run_program("/tmp/nfcchecker.sh") == 0);')
