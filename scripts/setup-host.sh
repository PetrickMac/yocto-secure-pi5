#!/usr/bin/env bash
# Install Yocto Scarthgap host dependencies on Ubuntu 24.04 (build host: Fitlet 3).
set -euo pipefail

sudo apt update
sudo apt install -y \
  gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio \
  python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping \
  python3-git python3-jinja2 python3-subunit zstd liblz4-tool file locales libacl1 \
  tmux bmap-tools

sudo locale-gen en_US.UTF-8

# Ubuntu 24.04 restricts unprivileged user namespaces via AppArmor, which
# BitBake uses for network isolation of tasks. If builds fail with
# "User namespaces are not usable by BitBake", see docs/journal notes and the
# Yocto ref-manual "System Requirements" section. Not changed automatically —
# it's a host security setting, so make that call deliberately.
if [[ "$(sysctl -n kernel.apparmor_restrict_unprivileged_userns 2>/dev/null || echo 0)" == "1" ]]; then
  echo "NOTE: AppArmor restricts unprivileged user namespaces on this host."
  echo "      Only if BitBake complains, relax it with:"
  echo "      echo 'kernel.apparmor_restrict_unprivileged_userns = 0' | sudo tee /etc/sysctl.d/60-bitbake-userns.conf && sudo sysctl --system"
fi

echo "Host ready: $(nproc) cores, $(free -h | awk '/Mem:/{print $2}') RAM, $(df -h ~ | awk 'NR==2{print $4}') free"
