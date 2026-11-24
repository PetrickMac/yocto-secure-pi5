# CLAUDE.md — yocto-secure-pi5

## What this project is
A personal 10-day learning project (Nov 30 → Dec 9, 2026) by Petrick, an IoT Platform Engineer, to learn **Yocto**, the **Linux boot process / filesystem**, and **embedded device hardening** by building a security-focused custom Linux image for a **Raspberry Pi 5**. Plan: `docs/PLAN.md`.

**Learning is the goal, not just a working image.**

## How to help me
- **Teach, then do.** Before giving a command or writing a recipe, explain in 2–4 sentences what it does and how it connects to the pieces around it (BitBake ↔ recipe ↔ layer ↔ image ↔ boot chain). Diagrams (ASCII or mermaid) are welcome.
- When I'm on a "🔧 hands-on" step from PLAN.md, prefer **guiding me to write it** over writing it for me, unless I ask you to just do it.
- Point to the relevant Yocto doc section or variable glossary entry when you introduce a variable.
- Flag anything **irreversible** (OTP fuses, EEPROM changes, `dd` to the wrong disk) loudly and ask first.
- Don't update `docs/journal/` or other docs unless I ask.

## Environment
- **Build host:** Fitlet 3, hostname `patmac-fitlet3`, Ubuntu 24.04 LTS, 4 cores, 32 GB RAM, ~850 GB free. Builds run in `tmux` over SSH from a Windows PC.
- 4 cores is the bottleneck: avoid suggestions that trigger needless full rebuilds; protect `sstate-cache` and `downloads`.
- **Yocto:** 5.0 **Scarthgap** (LTS). All layers on `scarthgap` branches (`meta-lts-mixins` on `scarthgap/u-boot`). Use Scarthgap syntax (`:append`, `:remove`, `UNPACKDIR` does NOT exist yet — use `S`/`WORKDIR`).
- **Targets:** `qemux86-64` (Phase 1), `raspberrypi5` (Phase 2+).
- **Hardware on hand:** Raspberry Pi 5, Fitlet 3, Pi 4s, CH341A programmer. No new purchases during the sprint.

## Repo conventions
- Upstream layers live in `layers/` (gitignored, cloned by `scripts/fetch-layers.sh`, pinned in `layers.lock`).
- **All customization goes in `meta-secure-pi5/`** — never edit files under `layers/`. Use `.bbappend` + config fragments.
- Recipe naming: `recipes-<area>/<name>/<name>_<version>.bb`. Every recipe needs `SUMMARY`, `LICENSE`, `LIC_FILES_CHKSUM`.
- `build/` is gitignored; only `conf-snippets/` documents local.conf intent.
- Commits: small, imperative ("Add hello-secure recipe"), one concept per commit.

## Useful commands
```bash
source layers/poky/oe-init-build-env build
bitbake <target>                         # build
bitbake -e <recipe> | grep ^VAR=         # final value of a variable
bitbake -c devshell <recipe>             # shell in recipe's build env
bitbake -c menuconfig virtual/kernel     # kernel config
bitbake-layers show-layers | show-appends | show-recipes
oe-pkgdata-util list-pkgs | find-path
runqemu qemux86-64 nographic             # Ctrl+a x to exit
```
