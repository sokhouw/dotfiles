#!/usr/bin/env sh

COMMAND="install-verify"
TEST="${1}"

# root directory of dotfiles project. We're copying files from here
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "${ROOT_DIR}/scripts/common.sh"

# ------------------------------------------------------------------------------
# preparing test
# ------------------------------------------------------------------------------

if ! verify_instr_run; then
    printf '%sFAILED%s\n' "${RED}" "${RESET}"
    printf '%s: %sFAILED%s\n' "${TEST}" "${RED}" "${RESET}" >> _build/test/report
else
    printf '%sPASS%s\n' "${GREEN}" "${RESET}"
    printf '%s: %sPASS%s\n' "${TEST}" "${GREEN}" "${RESET}" >> _build/test/report
fi
