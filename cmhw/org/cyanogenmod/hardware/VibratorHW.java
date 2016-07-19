/*
 * Copyright (C) 2016 The CyanogenMod Project
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

import android.util.Log;

public class VibratorHW {

    private static final String TAG = "VibratorHW";

    private static final int DEFAULT_LEVEL = 60;
    private static final int MAX_LEVEL = 127;
    private static final int MIN_LEVEL = 10;
    private static final int WARNING_LEVEL = 85;
    private static final String LEVEL_PATH = "/sys/vibrator/pwmvalue";

    public static boolean isSupported() {
        return FileUtils.isFileWritable(LEVEL_PATH) &&
                FileUtils.isFileReadable(LEVEL_PATH);
    }

    public static int getMaxIntensity()  {
        return MAX_LEVEL;
    }

    public static int getMinIntensity()  {
        return MIN_LEVEL;
    }

    public static int getWarningThreshold()  {
        return WARNING_LEVEL;
    }

    public static int getCurIntensity()  {
        try {
            return Integer.parseInt(FileUtils.readOneLine(LEVEL_PATH));
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
        return -1;
    }

    public static int getDefaultIntensity()  {
        return DEFAULT_LEVEL;
    }

    public static boolean setIntensity(int intensity)  {
        return FileUtils.writeLine(LEVEL_PATH, String.valueOf(intensity));
    }
}
