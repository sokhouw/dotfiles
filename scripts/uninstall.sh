#!/usr/bin/env sh

# root directory of dotfiles project. We're copying files from here
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "${ROOT_DIR}/scripts/common.sh"

# ------------------------------------------------------------------------------
# main program
# ------------------------------------------------------------------------------

prepare uninstall
uninstall_instr_run
