#!/bin/bash

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

for SUBARCH in $EFI_ARCH_SHORTS; do
	DRIVER_DIR=drivers_$SUBARCH
	rm -rf "$DRIVER_DIR"
	mkdir -p "$DRIVER_DIR"

	for fs in exfat f2fs hfsplus jfs ntfs udf xfs zfs; do
		ln -s "/usr/share/efi-fs/${fs}_${SUBARCH}.efi" "$DRIVER_DIR"
	done
done

exit 0
