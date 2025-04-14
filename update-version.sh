#!/bin/bash

upstream=https://github.com/pbatard/EfiFs

upstream_version=$(wget -O /dev/null $upstream/releases/latest 2>&1 | grep "$upstream/releases/tag/" | head -1 | awk '{print $2}')
upstream_version=${upstream_version##*/}
upstream_version=${upstream_version#v}

sed -i -r "s/efi-fs \([0-9]+(\.[0-9]+)+/efi-fs ($upstream_version/g" debian/changelog