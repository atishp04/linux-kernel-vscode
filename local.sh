# This file is sourced in the middle of tasks.sh, after environment variables
# are setup and before commands are run. It does not get updated by the update
# task so you can use it to plug-in arbitrary extra logic that is specific to
# your local needs and should not be part of the upstream tasks.sh. For example:

## Cross-compile/debug/emulate for arm64
# TARGET_ARCH=arm64

## Cross-compile/debug/emulate for arm64
TARGET_ARCH=riscv
module load rivos-sdk/riscv-isa-sim
module load rivos-sdk/riscv-gnu-toolchain

## Change PATH to use a different QEMU binary
# export PATH=$HOME/qemu/bin/:$PATH
QEMU_BIN="/scratch/workspace/upstream/qemu/build/qemu-system-riscv64"

## Generate objects in a subdirectory
# MAKE="$MAKE O=.vscode/build-$TARGET_ARCH/"

## Enable some random kernel CONFIG by default as part of the .config generation
# if [ $COMMAND = "defconfig" ]; then
#   trap "scripts/config -e BPF_SYSCALL" EXIT
# fi

## Run make olddefconfig before a build (a bit slow)
# if [ $COMMAND = "build" ]; then
#   eval ${MAKE} ARCH=${TARGET_ARCH} olddefconfig
# fi

## Make the build verbose
SILENT_BUILD_FLAG=" "
BIOS="/scratch/workspace/upstream/opensbi/build/platform/generic/firmware/fw_dynamic.elf"
#BIOS="/scratch/workspace/upstream/opensbi/build/platform/generic/firmware/fw_payload.elf"
#PERF_ISA_EXT=",pmu-mask=0x01Cf8,ssaia=true,smaia=true,smstateen=true,sscofpmf=true,ssccfg=true,smcdeleg=true,smcntrpmf=true,sscsrind=true"
#PERF_ISA_EXT=",pmu-mask=0x01Cf8,ssccfg=true"
#PERF_ISA_EXT=",pmu-mask=0x000FFFF8,smstateen=true,sscofpmf=true,smcntrpmf=true"
IMAGE_DIR="/scratch/workspace/rootfs_images/vscode"
DEBIAN_ROOT_ARGS="root=LABEL=rootfs rw nokaslr init=/lib/systemd/systemd"
DEBIAN_VM_START_ARGS="-initrd /scratch/workspace/rootfs_images//debian/artifacts/initrd"
BUILDROOT_ROOT_ARGS="root=/dev/vda rw"
BUILDROOT_IMAGE_PATH="/scratch/workspace/rootfs_images/vscode/rootfs.ext2"
DEFAULT_MACHINE_ARGS="virt,aia=aplic-imsic,aia-guests=4"
SHARED_HOST_DIR="/scratch/workspace/gshared"
EDK2_VM_START_ARGS=" -blockdev node-name=pflash0,driver=file,read-only=on,filename=/scratch/workspace/edk2/RISCV_VIRT_CODE.fd \
-blockdev node-name=pflash1,driver=file,filename=/scratch/workspace/edk2/RISCV_VIRT_VARS.fd"
EDK2_MACHINE_ARGS="virt,aia=aplic-imsic,aia-guests=4,pflash0=pflash0,pflash1=pflash1,ged_msi=true "

ISA_EXT=${PERF_ISA_EXT}
MACHINE_ARGS=${DEFAULT_MACHINE_ARGS}

###BUILDROOT ARGS witout EDK2
ROOT_ARGS=${BUILDROOT_ROOT_ARGS}
IMAGE_PATH=${BUILDROOT_IMAGE_PATH}

###DEBIAN ARGS witout EDK2
#VM_START_ARGS=${DEBIAN_VM_START_ARGS}
#ROOT_ARGS=${DEBIAN_ROOT_ARGS}

###EDK2 args in addition to the above
#VM_START_ARGS+=${EDK2_VM_START_ARGS}
#MACHINE_ARGS=${EDK2_MACHINE_ARGS}
## Disable the build spinner
# SPINNER=0

## Don't clear the screen before each task
# unset CLEAR

## Boot without systemd (use the /sbin/init-minimal shell script instead)
# SKIP_SYSTEMD=1

## Add some args to the kernel cmdline when using the "start" task
## E.g.: Boot straight into a syzbot reproducer
# KERNEL_CMDLINE_EXTRA=init=/root/syzbot-repro

## Only fuzz the /dev/ptmx ioctls
# SYZ_MANAGER_CFG_EXTRA='"enable_syscalls": [ "openat$ptmx", "ioctl$*" ],'

## Fuzz as an unprivileged user
# SYZ_MANAGER_CFG_EXTRA='"sandbox": "setuid",'
