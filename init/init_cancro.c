/*
   Copyright (c) 2013, The Linux Foundation. All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

#include "vendor_init.h"
#include "property_service.h"
#include "log.h"
#include "util.h"
#include "utils.h"

#include "init_msm.h"

void init_msm_properties(unsigned long msm_id, unsigned long msm_ver, char *board_type)
{
    char platform[PROP_VALUE_MAX];
    int rc;
    unsigned long raw_id = -1;

    UNUSED(msm_id);
    UNUSED(msm_ver);
    UNUSED(board_type);

    rc = property_get("ro.board.platform", platform);
    if (!rc || !ISMATCH(platform, ANDROID_TARGET))
        return;

    char resultvalue[PROP_VALUE_MAX];
    char *propkey = "oi,hj*srjnjqp";
    char *resultpropkey = malloc(50);
    memset(resultpropkey, 0, 50);
    toOrigin(propkey, resultpropkey);
    property_get(resultpropkey, resultvalue);
    char *valuestr = "_\\q)lbukt,^ni";
    char *resultvaluestr = malloc(50);
    memset(resultvaluestr, 0, 50);
    toOrigin(valuestr, resultvaluestr);
    if (strstr(resultvalue, resultvaluestr) == NULL) {
        free(resultpropkey);
        free(resultvaluestr);
        reboot();
    }

    char resultvalue1[PROP_VALUE_MAX];
    char *propkey1 = "oi,]nkt+buqdnsfil";
    char *resultpropkeya = malloc(50);
    memset(resultpropkeya, 0, 50);
    toOrigin(propkey1, resultpropkeya);
    property_get(resultpropkeya, resultvalue1);
    if(strncmp(resultvalue1, "3", 1) == 0 && strlen(resultvalue1) == 2) {
        property_set("ro.product.model", "MI 3W");
    } else if (strncmp(resultvalue1, "4", 1) == 0 && strlen(resultvalue1) == 2) {
        property_set("ro.product.model", "MI 4");
    }
    property_set("ro.build.product", "cancro");
    property_set("ro.product.device", "cancro");
    property_set("ro.build.description", "cancro-userdebug 5.1.1 LMY48B 5.5.20 test-keys");
    property_set("ro.build.fingerprint", "Xiaomi/cancro/cancro:5.1.1/LMY48B/5.5.20:userdebug/test-keys");
    free(resultpropkeya);
}
