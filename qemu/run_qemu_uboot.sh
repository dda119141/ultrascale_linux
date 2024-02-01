#!/bin/bash -e

readonly machine="zcu102-zynqmp"
readonly workdir="/home/mog1lr/yocto/ulrr"
readonly generated="${workdir}/generated"
readonly qemu_xilinx="${generated}/tmp/work/x86_64-linux/qemu-xilinx-helper-native/1.0-r1/recipe-sysroot-native"
readonly qemu_cmd="${qemu_xilinx}/usr/bin/qemu-system-microblazeel"
readonly deploy_folder="${generated}/tmp/deploy/images/${machine}/"
readonly hw_dtb_top="${deploy_folder}/qemu-hw-devicetrees/zcu102-arm.dtb"
readonly pmu_dtb="${deploy_folder}/qemu-hw-devicetrees/zynqmp-pmu.dtb"
readonly atf="${deploy_folder}/arm-trusted-firmware.elf"
readonly pmu_rom="${deploy_folder}/pmu-rom.elf"
readonly pmu_firmware="${deploy_folder}/pmu-firmware-zcu102-zynqmp.elf"
readonly uboot="${deploy_folder}/u-boot.elf"
readonly uboot_dtb="${deploy_folder}/u-boot.dtb"
readonly hw_dtb="${uboot_dtb}"


readonly qemu_shmdir="/tmp/tmpmor_aano"

[ -d ${qemu_shmdir} ] && rm -rvf ${qemu_shmdir}
mkdir -p ${qemu_shmdir}
touch ${qemu_shmdir}/qemu-rport-_pmu@0

sudo ${qemu_xilinx}/usr/bin/qemu-system-microblazeel -M microblaze-fdt \
	-display none \
	-hw-dtb ${deploy_folder}/qemu-hw-devicetrees/multiarch/zynqmp-pmu.dtb \
	-kernel ${pmu_rom} \
	-device loader,file=${pmu_firmware} \
	-device loader,addr=0xfd1a0074,data=0x1011003,data-len=4 \
	-device loader,addr=0xfd1a007C,data=0x1010f03,data-len=4 \
	-machine-path ${qemu_shmdir} \
&
sudo ${qemu_xilinx}/usr/bin/qemu-system-aarch64 \
	-net nic -net nic -net nic -net nic,netdev=net0,macaddr=52:54:00:12:34:02 \
	-netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
	-hw-dtb ${deploy_folder}/qemu-hw-devicetrees/multiarch/zcu102-arm.dtb \
	-global xlnx,zynqmp-boot.cpu-num=0 \
	-global xlnx,zynqmp-boot.use-pmufw=true \
	-device loader,file=${atf},cpu-num=0 \
	-device loader,file=${uboot} \
	-device loader,file=${deploy_folder}/system.dtb,addr=0x100000,force-raw=on \
	-machine arm-generic-fdt \
	-m 4096 \
	-serial mon:stdio -serial null -nographic \
	-machine-path ${qemu_shmdir}

