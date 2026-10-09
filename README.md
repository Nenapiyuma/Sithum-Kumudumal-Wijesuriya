# Wijesuriya OS

**Wijesuriya OS** is an experimental, minimal x86-64 Linux distribution project. It uses the Linux kernel and Buildroot to assemble a small bootable system image, with GRUB as the ISO bootloader.

> Status: initial source scaffold. A successful GitHub Actions build and boot smoke test are required before calling a release boot-tested.

## Features planned
- x86-64 PC / virtual-machine target
- Linux kernel + BusyBox userspace, built with Buildroot
- Bootable ISO using GRUB
- Reproducible CI build and downloadable ISO artifact
- Open-source scripts and configuration

## Build on Ubuntu/Debian

Install dependencies:

```sh
sudo apt-get update
sudo apt-get install -y build-essential git wget cpio unzip rsync bc file   libncurses-dev python3 xorriso grub-pc-bin grub-efi-amd64-bin mtools   qemu-system-x86 shellcheck
```

Build the ISO:

```sh
chmod +x scripts/*.sh
./scripts/build-iso.sh
```

The output is written to `output/Wijesuriya-OS-x86_64.iso`.

Run a headless boot smoke test (requires QEMU):

```sh
./scripts/test-iso-qemu.sh output/Wijesuriya-OS-x86_64.iso
```

## GitHub Actions

Push to `main` or use **Actions → Build Wijesuriya OS** to run the source checks, build the ISO, and test booting it in QEMU. The ISO is uploaded as an artifact only when the build and smoke test pass.

## Important limitations
This is a small starter Linux distribution, not a Windows replacement or a complete desktop environment. The first build is intended to verify that the kernel boots and reaches userspace. Hardware support, networking, a desktop interface, installers, persistence, and security hardening are future work.

## License
MIT for this repository's original scripts and configuration. Buildroot, Linux, BusyBox, and GRUB retain their own licenses.