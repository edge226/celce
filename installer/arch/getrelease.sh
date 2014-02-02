#!/bin/sh -e
# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Grabs the release from the specified chroot ($1) and prints it out on stdout.
# Fails with an error code of 1 if the chroot does not belong to this distro.

USAGE="${0##*/} -a|-r /path/to/chroot

Detects the release (-r) or arch (-a) of the chroot and prints it on stdout.
Fails with an error code of 1 if the chroot does not belong to this distro."

if [ "$#" != 2 ] || [ "$1" != '-a' -a "$1" != '-r' ]; then
    echo "$USAGE" 1>&2
    exit 2
fi

rel="`sed -n -e 's/^ID=//p' "${2%/}/etc/os-release"`"

if [ "$rel" = 'archarm' ]; then
    rel="alarm"
elif [ "$rel" != 'arch' ]; then
    exit 1
fi

# Print the architecture if requested
if [ "$1" = '-a' ]; then
    for pacmandesc in "${2%/}"/var/lib/pacman/local/pacman-[0-9]*/desc; do
        awk 'ok {print; exit}  /^%ARCH%$/ {ok=1}' "$pacmandesc" 2>/dev/null
        exit 0
    done
else
    echo "$rel"
fi

exit 0
