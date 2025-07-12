#!/bin/bash

set -e

cd "$(dirname "$0")"

. ../source.sh

DISTRO="${DISTRO:-unstable}"
MAINTAINER=$(git log -1 --pretty=format:'%an <%ae>')
ORIGIN=$(git remote get-url origin)

upstream_version=$(wget -O /dev/null "$UPSTREAM/releases/latest" 2>&1 | grep "$UPSTREAM/releases/tag/" | head -1 | awk '{print $2}')
upstream_version=${upstream_version##*/}
VERSION=${upstream_version#v}
REVISION=${REVISION:-0}

echo "v$VERSION" > ../VERSION

PACKAGE_NAME=efi-fs

# Gen control
cat <<EOF >control
Source: $PACKAGE_NAME
Section: libs
Priority: optional
Maintainer: $MAINTAINER
Build-Depends:
 debhelper-compat (= 13),
 wget,
 bash
Standards-Version: 4.6.2
Homepage: $ORIGIN
Vcs-Browser: $ORIGIN
Vcs-Git: $ORIGIN

Package: refind-drivers-extra
Architecture: amd64 i386 arm64
Multi-Arch: foreign
Depends: 
 refind,
 refind-files-i386 [amd64],
 refind-files-amd64 [i386],
 efi-fs-exfat,
 efi-fs-f2fs,
 efi-fs-hfsplus,
 efi-fs-jfs,
 efi-fs-ntfs,
 efi-fs-udf,
 efi-fs-xfs,
 efi-fs-zfs,
 \${misc:Depends},
Description: Extra EFI filesystem drivers for rEFInd

EOF

for module in $MODULES; do
		# Append to control file
		cat <<EOF >>control
Package: efi-fs-$module
Architecture: $ARCHITECTURES
Multi-Arch: foreign
Depends: \${misc:Depends},
Description: $module filesystem driver for uEFI

EOF
		# Create .install file
		echo "${module}/${module}_*.efi usr/share/efi-fs" >"efi-fs-$module.install"
done

# Gen changelog (from latest commit)
MSG=$(git log -1 --pretty=format:'%s')
DATE=$(git log -1 --pretty=format:'%ad' --date=format:'%a, %d %b %Y %H:%M:%S %z')

# Generate changelog
cat <<EOF >changelog
$PACKAGE_NAME ($VERSION-$REVISION) $DISTRO; urgency=medium

$(echo -e "$MSG" | sed -r 's/^/  * /g')

 -- $MAINTAINER  $DATE

EOF