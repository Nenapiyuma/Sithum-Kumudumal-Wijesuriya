#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

required_tools=(make gcc wget tar cpio rsync xorriso grub-mkrescue sha256sum)
missing=()
for tool in "${required_tools[@]}"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    missing+=("$tool")
  fi
done
if (("${#missing[@]}" > 0)); then
  printf 'ERROR: missing required host tools: %s\n' "${missing[*]}" >&2
  echo "Install build-essential, wget, cpio, rsync, xorriso, grub-common and GRUB BIOS/EFI utilities." >&2
  exit 2
fi

BUILDROOT_VERSION="2025.02.1"
BUILDROOT_TARBALL="buildroot-${BUILDROOT_VERSION}.tar.gz"
BUILDROOT_URL="https://buildroot.org/downloads/${BUILDROOT_TARBALL}"
mkdir -p dl output
if [[ ! -d buildroot ]]; then
  if [[ ! -s "dl/$BUILDROOT_TARBALL" ]]; then
    wget --https-only --tries=3 --timeout=30 -O "dl/$BUILDROOT_TARBALL" "$BUILDROOT_URL"
  fi
  tar -xzf "dl/$BUILDROOT_TARBALL"
  mv "buildroot-${BUILDROOT_VERSION}" buildroot
fi

cp configs/wijesuriya_x86_64_defconfig buildroot/.config
make -C buildroot olddefconfig
make -C buildroot -j"$(getconf _NPROCESSORS_ONLN)"

IMAGES="$ROOT/buildroot/output/images"
KERNEL="$IMAGES/bzImage"
INITRD="$IMAGES/rootfs.cpio.gz"
[[ -s "$KERNEL" ]] || { echo "ERROR: Buildroot kernel image not found: $KERNEL" >&2; exit 1; }
[[ -s "$INITRD" ]] || { echo "ERROR: Buildroot initramfs not found: $INITRD" >&2; exit 1; }

ISO_ROOT="$ROOT/output/iso-root"
rm -rf "$ISO_ROOT"
mkdir -p "$ISO_ROOT/boot/grub"
cp "$KERNEL" "$ISO_ROOT/bzImage"
cp "$INITRD" "$ISO_ROOT/rootfs.cpio.gz"
cp board/grub.cfg "$ISO_ROOT/boot/grub/grub.cfg"
grub-mkrescue -o "$ROOT/output/Wijesuriya-OS-x86_64.iso" "$ISO_ROOT"
test -s "$ROOT/output/Wijesuriya-OS-x86_64.iso"
sha256sum "$ROOT/output/Wijesuriya-OS-x86_64.iso" | tee "$ROOT/output/Wijesuriya-OS-x86_64.iso.sha256"
echo "Built ISO: output/Wijesuriya-OS-x86_64.iso"
