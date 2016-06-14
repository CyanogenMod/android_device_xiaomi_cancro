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

/**
 * High touch sensitivity
 *
 * TS     = Mi3w
 * TS_640 = Mi4
 */
public class HighTouchSensitivity {

    // Atmel Glove Mode
    private static String GLOVE_PATH_TS = "/sys/bus/i2c/drivers/atmel_mxt_ts/2-004a/sensitive_mode";
    private static String GLOVE_PATH_TS_640 = "/sys/bus/i2c/drivers/atmel_mxt_ts_640t/2-004b/sensitive_mode";
    // Atmel Stylus mode
    private static String STYLUS_PATH_TS = "/sys/bus/i2c/drivers/atmel_mxt_ts/2-004a/stylus";
    private static String STYLUS_PATH_TS_640 = "/sys/bus/i2c/drivers/atmel_mxt_ts_640t/2-004b/stylus";

    private static String sensitiveMode_path() {
        File glove_ts = new File(GLOVE_PATH_TS);
        if (glove_ts.exists()) {
            return GLOVE_PATH_TS;
        } else {
            return GLOVE_PATH_TS_640;
        }
    };

    private static String stylus_path() {
        File stylus_ts = new File(STYLUS_PATH_TS);
        if (stylus_ts.exists()) {
            return STYLUS_PATH_TS;
        } else {
            return STYLUS_PATH_TS_640;
        }
    };


    /**
     * Whether device supports high touch sensitivity.
     *
     * @return boolean Supported devices must return always true
     */
    public static boolean isSupported() { return true; }

    /**
     * This method return the current activation status of high touch sensitivity
     *
     * @return boolean Must be false if high touch sensitivity is not supported or not activated,
     * or the operation failed while reading the status; true in any other case.
     */
    public static boolean isEnabled() {
        return (FileUtils.readOneLine(sensitiveMode_path()).equals("1")) && FileUtils.readOneLine(stylus_path()).equals("1");
    }

    /**
     * This method allows to setup high touch sensitivity status.
     *
     * @param status The new high touch sensitivity status
     * @return boolean Must be false if high touch sensitivity is not supported or the operation
     * failed; true in any other case.
     */
    public static boolean setEnabled(boolean state) {
        return FileUtils.writeLine(sensitiveMode_path(), (state ? "1" : "0")) && FileUtils.writeLine(stylus_path(), (state ? "1" : "0"));
    }

}
