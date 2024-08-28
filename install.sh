#!/usr/bin/env bash
set -e

[[ -z "${NIXOS_HOST}" ]] && echo "NIXOS_HOST not set." && exit 1

repodir="$(git rev-parse --show-toplevel)"
sudo nixos-install --root /mnt --flake "$repodir#$NIXOS_HOST"
cp -r $repodir /mnt/home/danilo/nixos
