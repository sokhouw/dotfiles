#!/usr/bin/env sh

# root directory of dotfiles project. We're copying files from here
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "${ROOT_DIR}/scripts/common.sh"

# ------------------------------------------------------------------------------
# main program
# ------------------------------------------------------------------------------

prepare check
version="$(cat "${VERSION_FILE}" 2>/dev/null)"
if [ ! -z "${version}" ]; then
    echo "dotfiles-${version} installed"
else
    echo "dotfiles not installed"
fi
