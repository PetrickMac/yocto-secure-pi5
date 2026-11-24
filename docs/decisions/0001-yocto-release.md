# ADR-0001: Use Yocto 5.0 Scarthgap (LTS)

- **Status:** Accepted
- **Date:** 2026-11-23

## Context
Two LTS releases are available: 5.0 **Scarthgap** (Apr 2024, support to Apr 2028) and 6.0 **Wrynose** (May 2026, support to Apr 2030). The target is a Raspberry Pi 5; the build host is Ubuntu 24.04. The sprint is 10 days, so a stable, well-documented path matters more than the newest features.

## Decision
Use **Scarthgap** with `meta-raspberrypi` (`scarthgap`) and `meta-lts-mixins` (`scarthgap/u-boot`) for Pi 5 U-Boot support. Build host stays on Ubuntu 24.04, which both releases support.

## Consequences
- ✅ Most tutorials, vendor BSPs and community answers target Scarthgap; Pi 5 support has been exercised for two years.
- ✅ Ubuntu 24.04 host is supported by both releases, so migrating later doesn't require a host change.
- ⚠️ Older defaults (sysvinit as default init, `debug-tweaks`, `cve-check` class rather than Wrynose's `sbom-cve-check`).
- ➡️ Migrating to Wrynose is a planned post-sprint exercise — it mirrors real product upgrade work.
