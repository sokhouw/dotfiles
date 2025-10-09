#!/usr/bin/env sh

COMMAND="uninstall-verify"
TEST="${1}"

# root directory of dotfiles project. We're copying files from here
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "${ROOT_DIR}/scripts/common.sh"

# ------------------------------------------------------------------------------
# preparing test
# ------------------------------------------------------------------------------

if ! diff -qr "${HOME_DIR}" "${TEST_HOME_DIR}"; then
    printf '%sFAILED%s\n' "${RED}" "${RESET}"
    exit 1
else
    printf '%sPASS%s\n' "${GREEN}" "${RESET}"
fi
