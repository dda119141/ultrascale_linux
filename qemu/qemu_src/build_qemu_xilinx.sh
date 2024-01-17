#!/bin/bash -e

set -o xtrace

readonly machine="zcu102-zynqmp"

# Download source code
#tar xvJf qemu-"$QEMU_VERSION".tar.xz && \
cd qemu_xilinx 

# Build QEMU for aarch64
./configure \
        --target-list=aarch64-softmmu,microblazeel-softmmu	\
        --enable-fdt	\
				--disable-kvm	\
				--disable-xen


make -j$(nproc)
