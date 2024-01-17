#!/bin/bash -e

set -o xtrace

export this_dir=$(cd `dirname $0` ; pwd)
readonly machine="zcu102-zynqmp"
readonly xilinxdir="${this_dir}/.."
readonly generated="${xilinxdir}/../yocto/xilinx/zcu102/generated"
readonly qemu_xilinx="${generated}/tmp/work/x86_64-linux/qemu-xilinx-helper-native/1.0-r1/recipe-sysroot-native"
readonly qemu_cmd="${qemu_xilinx}/usr/bin/qemu-system-microblazeel"
readonly deploy_folder="${generated}/tmp/deploy/images/${machine}"
readonly hw_dtb_top="${deploy_folder}/qemu-hw-devicetrees/zcu102-arm.dtb"
readonly pmu_dtb="${deploy_folder}/qemu-hw-devicetrees/zynqmp-pmu.dtb"
readonly atf="${deploy_folder}/arm-trusted-firmware.elf"
readonly pmu_rom="${deploy_folder}/pmu-rom.elf"
readonly pmu_firmware="${deploy_folder}/pmu-firmware-zcu102-zynqmp.elf"
readonly uboot="${deploy_folder}/u-boot.elf"
readonly uboot_dtb="${deploy_folder}/u-boot.dtb"
readonly hw_dtb="${uboot_dtb}"
readonly fsbl="${xilinxdir}/bootloader/coreboot/build/fsboot_a53_zc102.elf"


readonly qemu_shmdir="/tmp/tmpmor_aano"

[ -d ${qemu_shmdir} ] && rm -rvf ${qemu_shmdir}
mkdir -p ${qemu_shmdir}
touch ${qemu_shmdir}/qemu-rport-_pmu@0

sudo ${qemu_xilinx}/usr/bin/qemu-system-microblazeel -M microblaze-fdt \
	-display none \
	-hw-dtb ${deploy_folder}/qemu-hw-devicetrees/multiarch/zynqmp-pmu.dtb \
	-kernel ${pmu_rom} \
	-machine-path ${qemu_shmdir} \
&
sudo ${qemu_xilinx}/usr/bin/qemu-system-aarch64 \
	-machine arm-generic-fdt \
	-m 4096 \
	-s -S \
	-serial mon:stdio -serial null -nographic \
	-hw-dtb ${deploy_folder}/qemu-hw-devicetrees/multiarch/zcu102-arm.dtb \
	-global xlnx,zynqmp-boot.cpu-num=0 \
	-device loader,file=${fsbl},cpu-num=0 \
	-machine-path ${qemu_shmdir}




