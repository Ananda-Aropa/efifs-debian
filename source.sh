#!/bin/bash

UPSTREAM=https://github.com/pbatard/EfiFs
MODULES="affs afs bfs btrfs cbfs cpio cpio erofs exfat ext2 f2fs fat hfs hfsplus iso9660 jfs minix minix minix2 minix2 minix3 minix3 newc nilfs2 ntfs odc procfs reiserfs romfs sfs squash4 tar udf ufs1 ufs1 ufs2 xfs zfs"
ARCHITECTURES="x64 ia32 aa64 riscv64 loong64"

export UPSTREAM MODULES ARCHITECTURES
