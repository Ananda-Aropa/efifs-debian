#!/bin/bash

ARCH=${DEB_BUILD_ARCH:-${DEB_ARCH:-${1:-amd64}}}

case "$ARCH" in
amd64) EFI_ARCH_SHORT=x64 ;;
i386) EFI_ARCH_SHORT=ia32 ;;
arm64) EFI_ARCH_SHORT=aa64 ;;
riscv64) EFI_ARCH_SHORT=riscv64 ;;
loong64) EFI_ARCH_SHORT=loongarch64 ;;
*)
	echo "Unsupported architecture: $ARCH"
	exit 1
	;;
esac

DRIVER_DIR=drivers_$EFI_ARCH_SHORT
rm -rf $DRIVER_DIR
mkdir -p $DRIVER_DIR

for fs in exfat f2fs hfsplus jfs ntfs udf xfs zfs; do
	ln -s /usr/share/efi-fs/${fs}_${EFI_ARCH_SHORT}.efi $DRIVER_DIR
done

exit 0