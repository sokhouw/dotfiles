#!/usr/bin/env sh

# ------------------------------------------------------------------------------
# colors
# ------------------------------------------------------------------------------

RED=$(printf '\033[1;31m')
GREEN=$(printf '\033[1;32m')
# BLUE=$(printf '\033[1;34m')
YELLOW=$(printf '\033[1;33m')
GREY=$(printf '\033[1;30m')
RESET=$(printf '\033[0;m')

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
# uninstall
#   this function needs variable UNINSTALL_FILE
# ------------------------------------------------------------------------------

uninstall_instr_run() {
    if [ -z "${UNINSTALL_FILE}" ]; then
        UNINSTALL_FILE="${STATE_HOME}"/dotfiles/uninstall
    fi
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
}

uninstall_instr() {
    echo "$*" >> "${UNINSTALL_FILE}" 
}

# ------------------------------------------------------------------------------
# preparing execution environment for install & uninstall
# ------------------------------------------------------------------------------

prepare() {
    arg_command="${1}"
    shift 1
    PROFILE="default"
    VERBOSE=""
    HOME_DIR="${HOME}"

    # process command-line arguments
    while [ ! -z "${1}" ]; do
        case "${1}" in
            --test)
                PROFILE="test"
                HOME_DIR="/tmp/dotfiles"
                shift 1
                ;;
            --verbose)
                VERBOSE="1"
                shift 1
                ;;
            --soft-link)
                if [ "${arg_command}" = "install" ]; then
                    INSTALL_SOFT_LINKING="1"
                else
                    bad_args
                fi
                shift 1
        esac
    done

    # use XDG variables if set or in test profile, otherwise use their defaults
    if [ -z "${XDG_CONFIG_HOME}" ] || [ "${PROFILE}" = "test" ]; then
        CONFIG_HOME="${HOME_DIR}/.config"
    else
        CONFIG_HOME="${XDG_CONFIG_HOME}"
    fi
    if [ -z "${XDG_STATE_HOME}" ] || [ "${PROFILE}" = "test" ]; then
        STATE_HOME="${HOME_DIR}/.local/state"
    else
        STATE_HOME="${XDG_STATE_HOME}"
    fi

    # set global variables
    DOTFILES_LINK="${HOME_DIR}/.dotfiles"
    BIN_HOME="${HOME_DIR}/bin"

    if [ ! -z "${VERBOSE}" ]; then
        msg_info "ROOT_DIR=\"${ROOT_DIR}\""
        msg_info "HOME_DIR=\"${HOME_DIR}\""
        msg_info "CONFIG_HOME=\"${CONFIG_HOME}\""
        msg_info "STATE_HOME=\"${STATE_HOME}\""
        msg_info "UNINSTALL_FILE=\"${UNINSTALL_FILE}\""
    fi

    # add some content to test home dir in test profile
    if [ "${arg_command}" = "install" ] && [ "${PROFILE}" = "test" ]; then
        mkdir "${HOME_DIR}"
        touch "${HOME_DIR}/.bashrc"
        printf "# line 1\n# line 2\n" >> "${HOME_DIR}/.bashrc"
    fi
}
