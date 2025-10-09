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
    printf '%sFAIL%s\n' "${RED}" "${RESET}"
    printf '%s (uninstall): %sFAIL%s\n' "${TEST}" "${RED}" "${RESET}" >> _build/test/report
else
    printf '%sPASS%s\n' "${GREEN}" "${RESET}"
    printf '%s (uninstall): %sPASS%s\n' "${TEST}" "${GREEN}" "${RESET}" >> _build/test/report
fi
