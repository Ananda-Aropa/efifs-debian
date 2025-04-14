#!/bin/bash

case "${DEB_BUILD_ARCH:-${DEB_ARCH:-amd64}}" in
amd64) EFI_ARCH_SHORT=x64 ;;
i386) EFI_ARCH_SHORT=ia32 ;;
arm64) EFI_ARCH_SHORT=aa64 ;;
riscv64) EFI_ARCH_SHORT=riscv64 ;;
loong64) EFI_ARCH_SHORT=loongarch64 ;;
*)
	echo "Unsupported architecture: ${DEB_BUILD_ARCH:-${DEB_ARCH}}"
	exit 1
	;;
esac

mkdir -p drivers_$EFI_ARCH_SHORT

for fs in exfat fsfs hfsplus jfs ntfs udf xfs zfs; do
	ln -s /usr/share/efi-fs/${fs}_${EFI_ARCH_SHORT}.efi drivers_$EFI_ARCH_SHORT
done

exit 0