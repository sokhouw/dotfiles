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
    printf '%sFAIL%s\n' "${RED}" "${RESET}"
    printf '%s (install): %sFAIL%s\n' "${TEST}" "${RED}" "${RESET}" >> "${TEST_REPORT}"
    return 1
    
else
    printf '%sPASS%s\n' "${GREEN}" "${RESET}"
    printf '%s (install): %sPASS%s\n' "${TEST}" "${GREEN}" "${RESET}" >> "${TEST_REPORT}"
    return 0
fi
