#!/usr/bin/env sh

COMMAND="${1}"
TEST="${2}"

# root directory of dotfiles project. We're copying files from here
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "${ROOT_DIR}/scripts/common.sh"

# ------------------------------------------------------------------------------
# main program
# ------------------------------------------------------------------------------

case "${1}" in
    report-clean)
        rm -f ${TEST_REPORT}
        ;;
    report-show)
        cat ${TEST_REPORT}
        ;;
    test-run)
        ${ROOT_DIR}/scripts/cmd-install.sh ${TEST}
        if ${ROOT_DIR}/scripts/cmd-install-verify.sh ${TEST}; then
            ${ROOT_DIR}/scripts/cmd-uninstall.sh ${TEST}
            ${ROOT_DIR}/scripts/cmd-uninstall-verify.sh ${TEST}
        else
            printf '%s (unintsall): %sSKIP%s\n' "${TEST}" "${YELLOW}" "${RESET}" >> "${TEST_REPORT}"
        fi
        ;;
esac
