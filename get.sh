#!/bin/bash

. ./source.sh

ARCH=${DEB_TARGET_ARCH:-${ARCH:-${1:-$(dpkg --print-architecture)}}}

case "$ARCH" in
amd64 | i386) EFI_ARCH_SHORTS="x64 ia32" ;;
arm64) EFI_ARCH_SHORTS=aa64 ;;
riscv64) EFI_ARCH_SHORTS=riscv64 ;;
loong64) EFI_ARCH_SHORTS=loongarch64 ;;
*)
	echo "Unsupported architecture: $ARCH"
	exit 1
	;;
esac

# version=$(head -1 debian/changelog | awk '{print $2}')
# version=${version%%-*}
# version=${version#"("}
version=$(cut -d 'v' -f2 VERSION)

for fs in $MODULES; do
	fs=${fs//-/_}
	rm -rf "$fs"
	mkdir -p "$fs"
	for SUBARCH in $EFI_ARCH_SHORTS; do
		wget -O "${fs}/${fs}_${SUBARCH}.efi" "$UPSTREAM/releases/download/v${version}/${fs}_${SUBARCH}.efi"
	done
done
