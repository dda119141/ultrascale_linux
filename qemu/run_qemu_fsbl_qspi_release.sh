#!/bin/bash -e

set -o xtrace

export this_dir=$(cd `dirname $0` ; pwd)
readonly machine="zcu102-zynqmp"
readonly xilinxdir="${this_dir}/.."
readonly drives="${this_dir}/../drives"
readonly generated="${xilinxdir}/../yocto/xilinx/zcu102/generated"
#readonly qemu_xilinx="${generated}/tmp/work/x86_64-linux/qemu-xilinx-helper-native/1.0-r1/recipe-sysroot-native/usr/bin"
readonly qemu_xilinx="${this_dir}/qemu_src/qemu_xilinx/build"
readonly qemu_cmd="${qemu_xilinx}/usr/bin/qemu-system-microblazeel"
readonly deploy_folder="${generated}/tmp/deploy/images/${machine}"
readonly hw_dtb_top="${deploy_folder}/qemu-hw-devicetrees/zcu102-arm.dtb"
readonly pmu_dtb="${deploy_folder}/qemu-hw-devicetrees/zynqmp-pmu.dtb"
#readonly atf="${deploy_folder}/arm-trusted-firmware.elf"
readonly atf="${xilinxdir}/bootloader/arm_trusted_firmware/generated/src/build/zynqmp/release/bl31/bl31.elf"
readonly pmu_rom="${deploy_folder}/pmu-rom.elf"
readonly pmu_firmware="${deploy_folder}/pmu-firmware-zcu102-zynqmp.elf"
readonly uboot="${deploy_folder}/u-boot.elf"
readonly uboot_dtb="${deploy_folder}/u-boot.dtb"
readonly hw_dtb="${xilinxdir}/kernel/device-tree/zcu102-arm.dtb"
readonly fsbl="${xilinxdir}/bootloader/coreboot/build/fsboot_a53_zc102.elf"
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
	-hw-dtb ${deploy_folder}/qemu-hw-devicetrees/multiarch/zynqmp-pmu.dtb \
	-kernel ${pmu_rom} \
	-machine-path ${qemu_shmdir} \
&
sudo ${qemu_xilinx}/qemu-system-aarch64 \
	-machine arm-generic-fdt \
	-m 4096 \
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




