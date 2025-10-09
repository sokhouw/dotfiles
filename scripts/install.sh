#!/usr/bin/env sh

# root directory of dotfiles project. We're copying files from here
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "${ROOT_DIR}/scripts/common.sh"

# ------------------------------------------------------------------------------
# install actions
# ------------------------------------------------------------------------------

install_dir() {
    if [ -d "${1}" ]; then
        if [ ! -w "${1}" ]; then
            printf 'directory %s: %snot writeable%s\n' "${1}" "${RED}" "${RESET}"
            exit 1
        fi
    else
        if [ ! -d "$(dirname "${1}")" ]; then
            install_dir "$(dirname "${1}")"
        fi
        if error=$(mkdir "${1}" 2>&1 >/dev/null); then
            printf 'directory %s: %screated%s\n' "${1}" "${GREEN}" "${RESET}"
            uninstall_instr rmdir "${1}"
        else
            printf 'directory %s: %s%s%s\n' "${1}" "${RED}" "${error}" "${RESET}"
            exit 1
        fi
    fi
}

install_config() {
    os_cmd cp -r "${1}" "${CONFIG_HOME}/$(basename "${1}")"
    uninstall_instr rm -rf "${CONFIG_HOME}/$(basename "${1}")"
}

install_create_backup_mv() {
    if [ -e "${1}" ]; then
        os_cmd mv "${1}" "${1}".bak
        uninstall_instr mv "${1}".bak "${1}"
    fi
}

install_create_backup_cp() {
    if [ -e "${1}" ]; then
        os_cmd cp "${1}" "${1}".bak
        uninstall_instr mv -f "${1}".bak "${1}"
    fi
}

install_soft_link() {
    if [ ! -e "${2}" ]; then
        install_create_backup_mv "${2}"
    fi
    os_cmd ln -s "${1}" "${2}"
    uninstall_instr rm "${2}"
}

install_tmux_plugin() {
    echo "cloning ${1} into ${2}: "
    printf '%s' "${GREY}"
    if GIT_TERMINAL_PROMPT=0 git -c credential.helper= clone "https://github.com/${1}" "${2}"; then
        printf '%s' "${RESET}"
        printf '%sok%s\n' "${GREEN}" "${RESET}"
        uninstall_instr rm -rf "${2}"
        return 0
    else
        printf '%s' "${RESET}"
        printf '%sfailed%s\n' "${RED}" "${RESET}"
        exit 1
    fi
}

install_bash_modules() {
    if [ -f "${HOME_DIR}"/.bashrc ] && [ -w "${HOME_DIR}"/.bashrc ]; then
        install_create_backup_cp "${HOME_DIR}"/.bashrc
        bash_init="${CONFIG_HOME}/shell/bash/init.sh"
        printf 'installing bash modules: '
        if printf '\n# dotfiles addition\nsource "%s" "%s"\n' "${bash_init}" "${bash_init}" >> "${HOME_DIR}"/.bashrc; then
            printf '%sok%s\n' "${GREEN}" "${RESET}"
        else
            printf '%sfailed%s\n' "${RED}" "${RESET}"
            exit 1
        fi
    fi
}

# ------------------------------------------------------------------------------
# function install
# ------------------------------------------------------------------------------

install() {
    VERSION="$(git describe --tags --dirty --always 2>/dev/null || echo "unknown")"
    echo "Installing dotfiles-${VERSION}"
    UNINSTALL_FILE=$(mktemp)
    install_dir "${STATE_HOME}"
    install_dir "${STATE_HOME}/dotfiles"
    mv "${UNINSTALL_FILE}" "${STATE_HOME}/dotfiles/uninstall"
    UNINSTALL_FILE="${STATE_HOME}/dotfiles/uninstall"
    install_dir "${STATE_HOME}/dotfiles/backup"
    install_dir "${CONFIG_HOME}"
    install_dir "${CONFIG_HOME}/dotfiles"
    echo "${VERSION}" > "${VERSION_FILE}"
    uninstall_instr rm "${VERSION_FILE}"
    for f in "${ROOT_DIR}/config"/*; do
        install_config "${f}"
    done 
    install_soft_link "${CONFIG_HOME}/tmux/tmux.conf" "${HOME_DIR}/.tmux.conf"
    install_dir "${STATE_HOME}/tmux/plugins"
    grep "^set -g @plugin" "${ROOT_DIR}/config/tmux/tmux.conf" | cut -f4 -d' ' | sed "s/'//g" | while IFS= read -r plugin; do
        install_tmux_plugin "${plugin}" "${STATE_HOME}/tmux/plugins/$(basename "${plugin}")"
    done || exit 1 # that constructs creates subshell thus we use "|| exit 1" to propagate error up
    install_bash_modules
    INSTALL_OK=1
}

# ------------------------------------------------------------------------------

install_on_exit() {
    if [ -f "${UNINSTALL_FILE}" ]; then
        # reverse the order of uninstall instructions
        sed -i '1!G;h;$!d' "${UNINSTALL_FILE}"
        if [ -z "${INSTALL_OK}" ]; then
            uninstall
        fi
    fi
}

# ------------------------------------------------------------------------------
# function uninstall
# ------------------------------------------------------------------------------

uninstall() {
    if [ -z "${UNINSTALL_FILE}" ]; then
        UNINSTALL_FILE="${STATE_HOME}/dotfiles/uninstall"
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
# main program
# ------------------------------------------------------------------------------

trap install_on_exit EXIT INT
prepare install
install
