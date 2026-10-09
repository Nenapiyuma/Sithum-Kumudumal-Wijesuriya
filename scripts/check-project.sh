#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

required=(
  README.md
  configs/wijesuriya_x86_64_defconfig
  board/grub.cfg
  scripts/build-iso.sh
  scripts/test-iso-qemu.sh
  .github/workflows/ci.yml
)
for path in "${required[@]}"; do
  [[ -s "$path" ]] || { echo "FAIL: missing or empty $path" >&2; exit 1; }
done

for script in scripts/*.sh; do
  bash -n "$script"
done

grep -q 'BR2_x86_64=y' configs/wijesuriya_x86_64_defconfig
grep -q 'initrd /rootfs.cpio.gz' board/grub.cfg
echo "PASS: required files, shell syntax, x86-64 config, and GRUB initrd entry"
