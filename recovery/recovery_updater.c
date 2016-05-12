/*
 * Copyright (C) 2016, The CyanogenMod Project
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

#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "edify/expr.h"

#define MAX(a, b) (((a) > (b)) ? (a) : (b))

#define ALPHABET_LEN 256
#define KB 1024

#define BASEBAND_PART_PATH "/dev/block/platform/msm_sdcc.1/by-name/modem"
#define BASEBAND_VER_STR_START "MPSS.DI."
#define BASEBAND_VER_STR_START_LEN 8
#define BASEBAND_VER_BUF_LEN 255
#define BASEBAND_SZ 64000 * KB    /* MMAP 64M of BASEBAND, BASEBAND partition is 64M */

/* Boyer-Moore string search implementation from Wikipedia */

/* Return longest suffix length of suffix ending at str[p] */
static int max_suffix_len(const char *str, size_t str_len, size_t p) {
    uint32_t i;

    for (i = 0; (str[p - i] == str[str_len - 1 - i]) && (i < p); ) {
        i++;
    }

    return i;
}

/* Generate table of distance between last character of pat and rightmost
 * occurrence of character c in pat
 */
static void bm_make_delta1(int *delta1, const char *pat, size_t pat_len) {
    uint32_t i;
    for (i = 0; i < ALPHABET_LEN; i++) {
        delta1[i] = pat_len;
    }
    for (i = 0; i < pat_len - 1; i++) {
        uint8_t idx = (uint8_t) pat[i];
        delta1[idx] = pat_len - 1 - i;
    }
}

/* Generate table of next possible full match from mismatch at pat[p] */
static void bm_make_delta2(int *delta2, const char *pat, size_t pat_len) {
    int p;
    uint32_t last_prefix = pat_len - 1;

    for (p = pat_len - 1; p >= 0; p--) {
        /* Compare whether pat[p-pat_len] is suffix of pat */
        if (strncmp(pat + p, pat, pat_len - p) == 0) {
            last_prefix = p + 1;
        }
        delta2[p] = last_prefix + (pat_len - 1 - p);
    }

    for (p = 0; p < (int) pat_len - 1; p++) {
        /* Get longest suffix of pattern ending on character pat[p] */
        int suf_len = max_suffix_len(pat, pat_len, p);
        if (pat[p - suf_len] != pat[pat_len - 1 - suf_len]) {
            delta2[pat_len - 1 - suf_len] = pat_len - 1 - p + suf_len;
        }
    }
}

static char * bm_search(const char *str, size_t str_len, const char *pat,
        size_t pat_len) {
    int delta1[ALPHABET_LEN];
    int delta2[pat_len];
    int i;

    bm_make_delta1(delta1, pat, pat_len);
    bm_make_delta2(delta2, pat, pat_len);

    if (pat_len == 0) {
        return (char *) str;
    }

    i = pat_len - 1;
    while (i < (int) str_len) {
        int j = pat_len - 1;
        while (j >= 0 && (str[i] == pat[j])) {
            i--;
            j--;
        }
        if (j < 0) {
            return (char *) (str + i + 1);
        }
        i += MAX(delta1[(uint8_t) str[i]], delta2[j]);
    }

    return NULL;
}

static int get_baseband_version(char *ver_str, size_t len) {
    int ret = 0;
    int fd;
    char *baseband_data = NULL;
    char *offset = NULL;

    fd = open(BASEBAND_PART_PATH, O_RDONLY);
    if (fd < 0) {
        ret = errno;
        goto err_ret;
    }

    baseband_data = (char *) mmap(NULL, BASEBAND_SZ, PROT_READ, MAP_PRIVATE, fd, 0);
    if (baseband_data == (char *)-1) {
        ret = errno;
        goto err_fd_close;
    }

    /* Do Boyer-Moore search across BASEBAND data */
    offset = bm_search(baseband_data, BASEBAND_SZ, BASEBAND_VER_STR_START, BASEBAND_VER_STR_START_LEN);
    if (offset != NULL) {
        strncpy(ver_str, offset, len);
    } else {
        ret = -ENOENT;
    }

    munmap(baseband_data, BASEBAND_SZ);
err_fd_close:
    close(fd);
err_ret:
    return ret;
}

/* verify_baseband("BASEBAND_VERSION", "BASEBAND_VERSION", ...) */
Value * VerifyBasebandFn(const char *name, State *state, int argc, Expr *argv[]) {
    char current_baseband_version[BASEBAND_VER_BUF_LEN];
    char *baseband_version;
    int i, ret;

    ret = get_baseband_version(current_baseband_version, BASEBAND_VER_BUF_LEN);
    if (ret) {
        return ErrorAbort(state, "%s() failed to read current BASEBAND version: %d",
                name, ret);
    }

    for (i = 0; i < argc; i++) {
        baseband_version = Evaluate(state, argv[i]);
        if (baseband_version < 0) {
            return ErrorAbort(state, "%s() error parsing arguments: %d",
                name, baseband_version);
        }

        uiPrintf(state, "Checking for BASEBAND version %s", baseband_version);

        /**
         * @param count is hardcoded to 11 to check "MPSS.DI.?.0" value only
         *   because xiaomi changes the other 8 chars every weekly update
         *   and we just need a MPSS.DI.4.0 baseband
         */
        if (strncmp(baseband_version, current_baseband_version, 11) == 0) {
            return StringValue(strdup("1"));
        }
    }

    uiPrintf(state, "ERROR: It appears you are running an unsupported baseband. Please visit   http://bit.ly/cancroCMBaseband   to learn how to update.");
    return StringValue(strdup("0"));
}

void Register_librecovery_updater_cancro() {
    RegisterFunction("cancro.verify_baseband", VerifyBasebandFn);
}
