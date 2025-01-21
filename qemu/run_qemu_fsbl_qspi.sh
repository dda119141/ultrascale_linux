#!/bin/bash -e

set -o xtrace

export this_dir=$(cd `dirname $0` ; pwd)
readonly machine="zcu102-zynqmp"
readonly xilinxdir="${this_dir}/.."
readonly drives="${this_dir}/../drives"
readonly qemu_xilinx="${this_dir}/generated/src/build"
readonly pmu_dtb="${xilinxdir}/bootloader/pmu/generated/src/LATEST/MULTI_ARCH/zynqmp-pmu.dtb"
readonly atf="${xilinxdir}/bootloader/arm_trusted_firmware/generated/src/build/zynqmp/release/bl31/bl31.elf"
readonly pmu_rom="${xilinxdir}/bootloader/pmu/generated/PMU_ROM/pmu-rom.elf"
readonly hw_dtb="${xilinxdir}/bootloader/pmu/generated/src/LATEST/MULTI_ARCH/zcu102-arm.dtb"
readonly fsbl="${xilinxdir}/bootloader/coreboot/generated/src/build/fsboot_a53_zc102.elf"
readonly QSPI_24BIT="1"
readonly QSPI_24BIT_INDEX="0"
readonly QSPI_32BIT="2"
readonly QSPI_32BIT_INDEX="1"


readonly qemu_shmdir="/tmp/tmpmor_aano"

[ -d ${qemu_shmdir} ] && rm -rvf ${qemu_shmdir}
mkdir -p ${qemu_shmdir}
touch ${qemu_shmdir}/qemu-rport-_pmu@0

sudo ${qemu_xilinx}/qemu-system-microblazeel -M microblaze-fdt \
	-display none \
	-hw-dtb ${pmu_dtb} \
	-kernel ${pmu_rom} \
	-machine-path ${qemu_shmdir} \
&
sudo ${qemu_xilinx}/qemu-system-aarch64 \
	-machine arm-generic-fdt \
	-m 4096 \
	-s -S \
	-nographic \
	-chardev stdio,mux=on,id=char0,logfile=fsbl.log,signal=off \
	-mon chardev=char0,mode=readline \
	-serial chardev:char0 \
	-hw-dtb ${hw_dtb} \
	-global xlnx,zynqmp-boot.cpu-num=0 \
	-global xlnx,zynqmp-boot.use-pmufw=false \
	-device loader,file=${fsbl},cpu-num=0 \
	-drive file=qemu_qspi_low.bin,if=mtd,format=raw,index=0 \
	-drive file=qemu_qspi_high.bin,if=mtd,format=raw,index=1 \
	-drive file=${drives}/qemu_sd.img,if=sd,format=raw,index=1 \
	-boot mode=${QSPI_32BIT} \
	-machine-path ${qemu_shmdir}




