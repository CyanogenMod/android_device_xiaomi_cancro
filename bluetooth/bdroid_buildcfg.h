/*
 *
 *  Copyright (c) 2013, The Linux Foundation. All rights reserved.
 *  Not a Contribution, Apache license notifications and license are retained
 *  for attribution purposes only.
 *
 * Copyright (C) 2012 The Android Open Source Project
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

#ifndef _BDROID_BUILDCFG_H
#define _BDROID_BUILDCFG_H

#define BLUETOOTH_QTI_SW TRUE

#define BTM_DEF_LOCAL_NAME   "Xiaomi MI3W"
// Enables Interleave scan
#define BTA_SKIP_BLE_READ_REMOTE_FEAT TRUE
#define BTA_HOST_INTERLEAVE_SEARCH  TRUE
#define MAX_L2CAP_CHANNELS    16
// skips conn update at conn completion
#define BTA_BLE_SKIP_CONN_UPD  TRUE
#define BT_CLEAN_TURN_ON_DISABLED 1

/* Defined if the kernel does not have support for CLOCK_BOOTTIME_ALARM */
#define KERNEL_MISSING_CLOCK_BOOTTIME_ALARM TRUE
#endif
