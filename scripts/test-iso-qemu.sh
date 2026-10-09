#!/usr/bin/env bash
set -euo pipefail
ISO="${1:-output/Wijesuriya-OS-x86_64.iso}"
if [[ ! -s "$ISO" ]]; then
  echo "ERROR: ISO not found or empty: $ISO" >&2
  exit 2
fi
command -v qemu-system-x86_64 >/dev/null || {
  echo "ERROR: qemu-system-x86_64 is required" >&2
  exit 2
}
LOG="$(mktemp)"
trap 'rm -f "$LOG"' EXIT
set +e
timeout 90s qemu-system-x86_64 \
  -machine accel=tcg -m 1024 -smp 2 -cdrom "$ISO" -boot d \
  -display none -serial "file:$LOG" -monitor none -no-reboot
status=$?
set -e
cat "$LOG"
if grep -Eqi 'Welcome to Wijesuriya OS|login:|Starting.*init' "$LOG"; then
  echo "PASS: QEMU reached Linux userspace"
  exit 0
fi
echo "FAIL: no userspace boot marker detected (qemu exit $status)" >&2
exit 1
