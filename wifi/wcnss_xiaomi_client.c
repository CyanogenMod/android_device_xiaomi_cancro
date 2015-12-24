/*
 * Copyright (C) 2015, The CyanogenMod Project
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

//#define LOG_NDEBUG 0

#define LOG_TAG "wcnss_xiaomi"

#define MAC_ADDR_SIZE 6

#include <cutils/log.h>

extern int qmi_nv_read_wlan_mac(unsigned char** mac);

int wcnss_init_qmi(void)
{
    /* empty */
    return 0;
}

int wcnss_qmi_get_wlan_address(unsigned char *pBdAddr)
{
    int i;
    unsigned char *buf = NULL;

    qmi_nv_read_wlan_mac(&buf);

    /* swap bytes */
    for (i = 0; i < MAC_ADDR_SIZE; i++) {
        pBdAddr[i] = buf[MAC_ADDR_SIZE - 1 - i];
    }

    ALOGI("Found MAC address: %02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx\n",
            pBdAddr[0],
            pBdAddr[1],
            pBdAddr[2],
            pBdAddr[3],
            pBdAddr[4],
            pBdAddr[5]);

    return 0;
}

void wcnss_qmi_deinit(void)
{
    /* empty */
}
