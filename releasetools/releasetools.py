#
# Copyright (C) 2016 The CyanogenMod Project
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

import hashlib
import common
import re

def FullOTA_Assertions(info):
    AddBasebandAssertion(info)
    return

def IncrementalOTA_Assertions(info):
    AddBasebandAssertion(info)
    return

def AddBasebandAssertion(info):
    android_info = info.input_zip.read("OTA/android-info.txt")
    m = re.search(r'require\s+version-baseband\s*=\s*(\S+)', android_info)
    if m:
        versions = m.group(1).split('|')
        if len(versions) and '*' not in versions:
            cmd = 'assert(cancro.verify_baseband(' + ','.join(['"%s"' % baseband for baseband in versions]) + ') == "1");'
            info.script.AppendExtra(cmd)
    return


def FullOTA_PostValidate(info):
    info.script.AppendExtra('run_program("/sbin/e2fsck", "-fy", "/dev/block/platform/msm_sdcc.1/by-name/system");');
    info.script.AppendExtra('run_program("/tmp/install/bin/resize2fs_static", "/dev/block/platform/msm_sdcc.1/by-name/system");');
    info.script.AppendExtra('run_program("/sbin/e2fsck", "-fy", "/dev/block/platform/msm_sdcc.1/by-name/system");');

def FullOTA_InstallEnd(info):
    info.script.Mount("/system");
    info.script.AppendExtra('assert(run_program("/tmp/install/bin/device_check.sh") == 0);');
    info.script.Unmount("/system");
