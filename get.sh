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

version=$(head -1 debian/changelog | awk '{print $2}')
version=${version%%-*}
version=${version#"("}

while read -r fs; do
	fs=${fs#'Package: efi-fs-'}
	fs=${fs//-/_}
	mkdir -p "$fs"
	wget -O "${fs}/${fs}_${EFI_ARCH_SHORT}.efi" "https://github.com/pbatard/EfiFs/releases/download/v${version}/${fs}_${EFI_ARCH_SHORT}.efi"
done < <(grep 'Package: efi-fs-' debian/control)
