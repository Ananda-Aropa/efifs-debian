#!/bin/bash

. ./source.sh

upstream_version=$(wget -O /dev/null "$UPSTREAM/releases/latest" 2>&1 | grep "$UPSTREAM/releases/tag/" | head -1 | awk '{print $2}')
upstream_version=${upstream_version##*/}
upstream_version=${upstream_version#v}

sed -i -r "s/efi-fs \([0-9]+(\.[0-9]+)+/efi-fs ($upstream_version/g" debian/changelog