#!/bin/bash -e

set -o xtrace

readonly machine="zcu102-zynqmp"
readonly QEMU_VERSION=7.2.0

# Download source code
curl -fsSLO https://download.qemu.org/qemu-"$QEMU_VERSION".tar.xz && \
tar xvJf qemu-"$QEMU_VERSION".tar.xz && \
cd qemu-"$QEMU_VERSION" 

# Build QEMU for aarch64
./configure \
        --target-list=arm-softmmu,aarch64-softmmu \
        --enable-system        \

make -j$(nproc)
