# Project Plan — self-paced milestones

Work at my own pace: some milestones take one session, some take several. Move on only when the ✅ is true.

Rules for myself:
- **Understand before automating.** Do it by hand first, then script it.
- **Kick off long builds before bed / work.** 4 cores = first builds take hours.
- **One journal entry per work session** in `docs/journal/` (what I did, what broke, what I learned).
- **Never edit upstream layers.** Changes go in `meta-secure-pi5` via recipes and `.bbappend`s.
- **Nothing irreversible** (no OTP fuse burning on the Pi 5) during this project.

Legend: 🧠 concept · 🔧 hands-on · ✅ done-when

---

## Phase 1 — Yocto fundamentals in QEMU

### Milestone 1 — First build
- 🧠 What Yocto *is*: Poky vs OpenEmbedded vs BitBake; layers, recipes, classes, `.conf` files; MACHINE vs DISTRO vs IMAGE.
- 🔧 `fetch-layers.sh`, `source oe-init-build-env build`, read the generated `conf/local.conf` and `conf/bblayers.conf` line by line.
- 🔧 Copy in `conf-snippets/local.conf.append` (shared caches, thread counts).
- 🔧 Start `bitbake core-image-minimal` in tmux → let it run (overnight or while away).
- ✅ Build running; journal entry explains MACHINE/DISTRO/IMAGE in my own words.

### Milestone 2 — Boot it and look around
- 🔧 `runqemu qemux86-64 nographic`, log in as root.
- 🧠 Linux filesystem tour: FHS (`/etc /usr /var /run /proc /sys /dev`), what's a real disk vs a virtual fs (`mount`, `findmnt`).
- 🧠 Init: who is PID 1? (`ps`, `cat /proc/1/cmdline`) — sysvinit is Poky's default in Scarthgap.
- 🔧 Explore `build/tmp/deploy/images/`, `tmp/work/`, `bitbake -e core-image-minimal | less`, `bitbake -c devshell busybox`.
- ✅ Can draw the task flow: fetch → unpack → patch → configure → compile → install → package → rootfs → image.

### Milestone 3 — My own layer + image + recipe
- 🔧 `bitbake-layers create-layer ../meta-secure-pi5`, `bitbake-layers add-layer`, `show-layers`.
- 🔧 Write `secure-pi5-image.bb` (inherit `core-image`), and a tiny `hello-secure` C recipe built from a local source.
- 🔧 Switch init to **systemd** via `local.conf` / distro settings; rebuild; compare PID 1.
- ✅ My image boots in QEMU, runs my binary, and uses systemd.

## Phase 2 — Real hardware

### Milestone 4 — Raspberry Pi 5 BSP
- 🧠 What a BSP layer provides: machine conf, kernel recipe, bootloader/firmware, device trees.
- 🔧 Add `meta-raspberrypi` (+ `meta-lts-mixins` `scarthgap/u-boot`, `meta-oe`); `MACHINE = "raspberrypi5"`; long build — start it before stepping away.
- 🔧 Flash the `.wic.bz2` to microSD (bmaptool on Fitlet, or Raspberry Pi Imager → "Use custom" on Windows).
- ✅ Pi 5 boots my image; console via HDMI+keyboard (or USB-UART if I have one).

### Milestone 5 — The boot chain, for real
- 🧠 Pi 5 boot: EEPROM → firmware/`config.txt`/`cmdline.txt` → kernel + DTB (→ optional U-Boot) → rootfs → init.
- 🔧 Read the boot partition contents; change `cmdline.txt` via recipe (not by hand); enable U-Boot (`RPI_USE_U_BOOT = "1"`) and watch the extra stage.
- 🔧 `dmesg`, `systemd-analyze`, `systemd-analyze blame`.
- ✅ `docs/architecture.md` boot diagram updated with what I *observed*.

## Phase 3 — Securing the device

### Milestone 6 — Image hardening
- 🔧 Remove `debug-tweaks` (empty root password!) → set users with `extrausers`, disable root login, SSH keys only.
- 🔧 Strip the package list to the minimum; check listening ports (`ss -tulpn`).
- 🔧 `IMAGE_FEATURES += "read-only-rootfs"` — find what breaks and why (`/var`, `/etc` writes).
- ✅ Hardening checklist in journal with before/after evidence.

### Milestone 7 — The kernel
- 🧠 Kernel recipe, `defconfig` vs config fragments (`.cfg`), `bitbake -c menuconfig virtual/kernel`, `diffconfig`.
- 🔧 Add a fragment that disables something unneeded and enables a hardening option; verify with `zcat /proc/config.gz` (or `/boot/config-*`).
- ✅ Kernel change lives in `meta-secure-pi5` as a `.bbappend` + `.cfg`.

### Milestone 8 — Supply chain: CVEs and SBOM
- 🧠 Why fleets care: SBOM, CVE triage (ties directly to my Fitlet CVE campaign work).
- 🔧 `INHERIT += "cve-check"` → read the report; enable SPDX SBOM output (`create-spdx`, default on in Scarthgap) and inspect it.
- 🔧 Pin layer revisions (`layers.lock`) so builds are reproducible.
- ✅ Can answer: "which packages in my image have open CVEs, and which are patched?"

### Milestone 9 — Verified boot concepts (reversible only)
- 🧠 Chain of trust: Pi 5 secure boot (signed `boot.img`, key hash in OTP — **read only, don't burn**), U-Boot signed FIT images, dm-verity for rootfs integrity.
- 🔧 Stretch: build a signed FIT image with U-Boot verifying the kernel signature (`UBOOT_SIGN_ENABLE`) — reversible, no fuses.
- ✅ Trust-chain diagram in `docs/architecture.md` marking each stage: verified / not verified / how I'd verify it in production.

### Milestone 10 — Reproducible + write-up
- 🔧 Optional: move the layer setup to **kas** (`kas.yml`) — how teams pin and share builds.
- 🔧 Clean README, final architecture diagrams, "what I'd do next" (Wrynose migration, RP2350 secure co-processor, OTA with RAUC/Mender/ADU).
- ✅ Someone could clone the repo and reproduce my image.

---

## Backlog (after the core milestones)
- Migrate to Yocto 6.0 Wrynose (good real-world exercise).
- RP2350 (Pico 2) as a secure co-processor / watchdog over UART.
- A/B updates (RAUC or Mender) — maps to Azure Device Update work.
- Offensive side: UART/JTAG/SPI flash extraction (CH341A) against my own image.
---JOURNAL---
docs/decisions:
0001-yocto-release.md

docs/journal:
TEMPLATE.md