# Application compatibility roadmap

## Current state

Wijesuriya OS is currently an experimental Buildroot-based x86-64 Linux boot image. It is not yet a desktop OS and does not currently include a Windows compatibility layer, an Android runtime, or an iOS runtime. Do not describe these formats as supported until runtime integration and tests pass.

## Target formats and realistic implementation

| Format | Intended approach | Important limits |
|---|---|---|
| Native Linux applications | Build a desktop stack and package/runtime support for Linux applications | Desktop libraries, graphics, audio, storage, and package management must be added first |
| Windows .exe and legacy DOS .com | Wine for compatible Windows applications; DOSBox or another suitable emulator for DOS programs | Compatibility varies by app; kernel drivers and some anti-cheat/DRM software will not work |
| Windows .msi | Use Wine's supported installer tooling, such as msiexec, after Wine is integrated | Not every installer or Windows service is compatible |
| Android .apk | Investigate Waydroid or another Android container/runtime on a compatible Linux host | Requires compatible kernel features, Binder support, graphics integration, and Android userspace; ARM-only apps may need translation |
| Apple iOS .ipa | No general-purpose native Linux runtime is available for arbitrary iOS apps | Signing, Apple frameworks, DRM, and platform restrictions prevent promising general compatibility |

## Safe implementation order

1. Establish a reliable boot-tested x86-64 ISO and retain CI evidence for the build and QEMU smoke test.
2. Add a desktop environment and graphics/input/audio/network foundations. Choose a maintainable package strategy rather than assuming the current tiny initramfs can run desktop software.
3. Add a Wine-based Windows compatibility layer and test a small, redistributable set of Windows applications. Treat .exe, .msi, and .com as distinct cases.
4. Evaluate Android runtime feasibility against the selected kernel and target hardware; add it only after kernel configuration and runtime tests pass.
5. Keep iOS .ipa as unsupported unless a lawful, technically viable runtime for the specific apps and hardware is identified.

## Acceptance criteria

- Each feature is marked supported only after its runtime is present in the image and automated/manual tests demonstrate it works.
- CI must fail when a required runtime package or integration test fails.
- Never run untrusted application files automatically. Show the file origin and request user confirmation before launch.
- Provide clear logs and a way to uninstall/disable compatibility components.
- Test the ISO in QEMU, then test graphics, networking, USB, and real target hardware separately. A QEMU boot test alone does not prove app compatibility or hardware support.
