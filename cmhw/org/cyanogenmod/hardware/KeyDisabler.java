/*
 * Copyright (C) 2015 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.cyanogenmod.hardware;

import org.cyanogenmod.internal.util.FileUtils;

import java.io.File;
/*
 * Disable capacitive keys
 *
 * This is intended for use on devices in which the capacitive keys
 * can be fully disabled for replacement with a soft navbar. You
 * really should not be using this on a device with mechanical or
 * otherwise visible-when-inactive keys
 *
 * TS     = Mi3w
 * TS_640 = Mi4
 */

public class KeyDisabler {

    // Mi3w
    private static String CONTROL_PATH_TS = "/sys/bus/i2c/drivers/atmel_mxt_ts/2-004a/keys_off";
    // Mi4
    private static String CONTROL_PATH_TS_640 = "/sys/bus/i2c/drivers/atmel_mxt_ts_640t/2-004b/keys_off";

    private static String KeyDisabler_path() {
        File ts = new File(CONTROL_PATH_TS);
        File ts_640 = new File(CONTROL_PATH_TS_640);
        if (ts.exists()) {
            return CONTROL_PATH_TS;
        } else {
            return CONTROL_PATH_TS_640;
        }
    };

    public static boolean isSupported() { return true; }

    public static boolean isActive() {
        return (FileUtils.readOneLine(KeyDisabler_path()).equals("0"));
    }

    public static boolean setActive(boolean state) {
        return FileUtils.writeLine(KeyDisabler_path(), (state ? "1" : "0"));
    }

}
