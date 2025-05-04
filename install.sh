#!/usr/bin/env bash

set -euo pipefail

dotfiles_dir=$(dirname $(realpath "$0"))
targets=(
	"nvim"
	"mako"
	"sway"
	"wezterm"
	"compton.conf"
)
for t in "${targets[@]}"
do
	ln -s "${dotfiles_dir}/${t}" "${HOME}/.config/${t}"
done
