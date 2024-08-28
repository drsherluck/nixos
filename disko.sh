#!/usr/bin/env bash
set -e

[[ -z "${NIXOS_HOST}" ]] && echo "NIXOS_HOST not set." && exit 1

repodir="$(git rev-parse --show-toplevel)"
sudo nix --experimental-features "nix-command flakes" \
    run github:nix-community/disko -- \
    --mode disko "$repodir/hosts/$NIXOS_HOST/disko.nix"
sudo nixos-generate-config --no-filesystems --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix "$repodir/hosts/$NIXOS_HOST/hardware.nix"
