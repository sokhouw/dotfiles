#!/usr/bin/env sh

# ------------------------------------------------------------------------------
# colors
# ------------------------------------------------------------------------------

RED=$(printf '\033[1;31m')
GREEN=$(printf '\033[1;32m')
BLUE=$(printf '\033[1;34m')
YELLOW=$(printf '\033[1;33m')
GREY=$(printf '\033[1;30m')
RESET=$(printf '\033[0;m')

# ------------------------------------------------------------------------------
# checking installed version
# ------------------------------------------------------------------------------

installed_version() {
    cat "${CONFIG_HOME}/dotfiles/VERSION" 2>/dev/null
}

# ------------------------------------------------------------------------------
# running os commands
# ------------------------------------------------------------------------------

os_cmd() {
    cmd="${1}"
    printf '%s: ' "$*"
    shift 1
    if error=$("${cmd}" "$@" 2>&1 >/dev/null); then
        printf '%sok%s\n' "${GREEN}" "${RESET}"
    else
        printf '%s%s%s\n' "${RED}" "${error}" "${RESET}"
        exit 1
    fi
}

# ------------------------------------------------------------------------------
# printing messages
# ------------------------------------------------------------------------------

msg_error() {
    printf '%s[ERROR]%s %s\n' "${RED}" "${RESET}" "${1}"
}

msg_warn() {
    printf '%s[WARN]%s %s\n' "${YELLOW}" "${RESET}" "${1}"
}

msg_info() {
    printf '%s[INFO]%s %s\n' "${GREY}" "${RESET}" "${1}"
}

# ------------------------------------------------------------------------------
# uninstall instructions
# ------------------------------------------------------------------------------

uninstall_instr_run() {
    # move uninstall file to temp location so its parent dir can be rmdir-ed
    instr_file="$(mktemp)"
    mv -f "${UNINSTALL_FILE}" "${instr_file}"
    cat "${instr_file}" | while IFS= read -r cmd; do
        printf '%s: ' "${cmd}"
        if error=$(sh -c "${cmd}" 2<&1 >/dev/null); then
            printf '%sok%s\n' "${GREEN}" "${RESET}"
        else
            printf '%s%s%s\n' "${RED}" "${error}" "${RESET}"
        fi
    done
    rm "${instr_file}"
}

uninstall_instr() {
    echo "$*" >> "${UNINSTALL_FILE}" 
}

# ------------------------------------------------------------------------------
# verify instructions
# ------------------------------------------------------------------------------

verify_instr() {
    echo "$*" >> "${VERIFY_FILE}"
}

verify_instr_run() {
    # move uninstall file to temp location so its parent dir can be rmdir-ed
    verify_file="$(mktemp)"
    mv -f "${VERIFY_FILE}" "${verify_file}"
    cat "${verify_file}" | while IFS= read -r cond; do
        printf '%s: ' "${cond}"
        if eval "${cond}"; then
            printf '%sok%s\n' "${GREEN}" "${RESET}"
        else
            rm "${verify_file}"
            exit 1
        fi
    done || return 1
    rm -f "${verify_file}"
}

# ------------------------------------------------------------------------------
# is_Installed
# ------------------------------------------------------------------------------

is_installed() {
    if [ -z "${UNINSTALL_FILE}" ]; then
        UNINSTALL_FILE="${STATE_HOME}/dotfiles/uninstall"
    fi
    [ -f "${UNINSTALL_FILE}" ]
}

# ------------------------------------------------------------------------------
# preparing execution environment for install/uninstall default/test
# ------------------------------------------------------------------------------

case "${COMMAND}" in
    install|uninstall|is-installed|install-verify|uninstall-verify|test-run|report-show|report-clean)
        if [ -z "${TEST}" ]; then
            printf '%s===> %s%s\n' "${BLUE}" "${COMMAND}" "${RESET}"
        else
            printf '%s===> %s (%s)%s\n' "${BLUE}" "${COMMAND}" "${TEST}" "${RESET}"
        fi
        ;;
    *)
        msg_error "bad command: ${COMMAND}"
        exit 1
        ;;
esac

# setup home directory
if [ -z "${TEST}" ]; then
    HOME_DIR="${HOME}"
else
    HOME_DIR="$(pwd)/_build/test/${TEST}"
    TEST_HOME_DIR="$(pwd)/test/${TEST}"
    if [ "${COMMAND}" = "install" ]; then
        os_cmd rm -rf "${HOME_DIR}"
        os_cmd mkdir -p "$(dirname "${HOME_DIR}")"
        os_cmd cp -r "${TEST_HOME_DIR}" "$(dirname "${HOME_DIR}")/${TEST}"
    fi
fi

# use XDG variables if set or in test profile, otherwise use their defaults
if [ -z "${XDG_CONFIG_HOME}" ] || [ ! -z "${TEST}" ]; then
    CONFIG_HOME="${HOME_DIR}/.config"
else
    CONFIG_HOME="${XDG_CONFIG_HOME}"
fi
if [ -z "${XDG_STATE_HOME}" ] || [ ! -z "${TEST}" ]; then
    STATE_HOME="${HOME_DIR}/.local/state"
else
    STATE_HOME="${XDG_STATE_HOME}"
fi
if [ -z "${XDG_DATA_HOME}" ] || [ ! -z "${TEST}" ]; then
    DATA_HOME="${HOME_DIR}/.local/share"
else
    DATA_HOME="${XDG_DATA_HOME}"
fi

# set global variables
VERSION_FILE="${CONFIG_HOME}/dotfiles/VERSION"
UNINSTALL_FILE="${STATE_HOME}/dotfiles/uninstall"
VERIFY_FILE="${STATE_HOME}/dotfiles/verify"
TEST_REPORT="_build/test/report"

export HOME_DIR CONFIG_HOME STATE_HOME DATA_HOME
export VERSION_FILE UNINSTALL_FILE VERIFY_FILE HOME
export TEST_HOME_DIR TEST_REPORT TEST
