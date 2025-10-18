# shellcheck shell=sh source=/dev/null

. "$(dirname "${0}")/lib-dotfiles.sh"
init "$@"

# action_init_dir() {
#     if [ ! -e "${1}" ]; then
#         action_init_dir "$(dirname "${1}")"
#         mkdir "${1}"
#         {
#             echo "[D:] init dir \"${1}\""
#             echo "[U:] rmdir \"${1}\""
#             echo
#         } >> "${JOURNAL_FILE}"
#     fi
# }

action_init_file() {
    if [ ! -e "${1}" ]; then
        {
            echo "[D:] init file \"${1}\""
            echo "[I:] touch \"${1}\""
            echo "[U:] rm \"${1}\""
            echo
        } >> "${JOURNAL_FILE}"
    fi
}

action() {
    if ! grep "\[D:.*${1}\$" "${JOURNAL_FILE}" 1>/dev/null 2>/dev/null; then
        msg_debug "make-app:action" "${1}"
        {
            echo "[D:${PLUGIN}] ${1}"
            if [ ! -z "${2}" ]; then
                echo "[I:${PLUGIN}] ${2}"
            fi
            if [ ! -z "${3}" ]; then
                echo "[U:${PLUGIN}] ${3}"
            fi
            echo
        } >> "${JOURNAL_FILE}"
    else
        {
            echo "[D:${PLUGIN}] duplicate ${1}"
            echo
        } >> "${JOURNAL_FILE}"
    fi
}

backup_copy() {
    do_backup "${1}" "cp -r"
}

backup_move() {
    do_backup "${1}" "mv"
}

do_backup() {
    orig_path="${1}"
    backup_cmd="${2}"
    action_descr="backing up '${orig_path}'"
    if [ -e "${orig_path}" ]; then
        backup_path="${1}.bak.$(timestamp)"
        action "${action_descr}" \
            "${backup_cmd} \"${orig_path}\" \"${backup_path}\"" \
            "rm -rf \"${orig_path}\" && mv \"${backup_path}\" \"${orig_path}\""
    fi
}

dotfiles_source_file() {
    source_path="${1}"
    target_path="${2}"
    parent_path="${3}"
    if [ -f "${source_path}" ]; then
        marker=" # dotfiles include: ${PLUGIN}"
        action "sourcing \"${target_path}\" in \"${parent_path}\"" \
               "echo \". ${target_path}${marker}\" >> \"${parent_path}\"" \
               "sed -i \"/${marker}/d\" \"${parent_path}\""
    fi
}

dotfiles_init_xdg() {
    if [ ! -e "${1}" ]; then
        dotfiles_init_xdg "$(dirname "${1}")"
        mkdir "${1}"
        {
            echo "[D:] init XDG dir \"${1}\""
            echo "[U:] rmdir \"${1}\" || true"
            echo
        } >> "${JOURNAL_FILE}"
    fi
}

dotfiles_install_xdg_dir() {
    plugin_xdg="${1}"
    target_xdg="${2}"
    parent_xdg="$(dirname "${target_xdg}")"
    if [ -e "${target_xdg}" ]; then
        backup_move "${target_xdg}"
    else
        action "cleanup of '${target_xdg}'" \
               "" \
               "rm -rf \"${target_xdg}\""
    fi
    if [ -e "${plugin_xdg}" ]; then
        dotfiles_init_xdg "${parent_xdg}"
        action "install XDG '${plugin_xdg}'" \
               "cp -r '${plugin_xdg}' '${target_xdg}'" \
               "rm -rf '${target_xdg}'"
    fi
}

case "${TASK}" in
    prepare)
        if [ ! -e "${CONFIG_HOME}/dotfiles" ]; then
            mkdir -p "$(dirname "${JOURNAL_FILE}")" && rm -f "${JOURNAL_FILE}"
            # action_init_dir "${CONFIG_HOME}"
            # action_init_dir "${DATA_HOME}"
            # action_init_dir "${STATE_HOME}"
            # action_init_file "${HOME_DIR}/.profile"
        else
            msg_error "make-app:prepare" "dotfiles already installed"
            exit 1
        fi
        ;;
    install-plugin)
        # default install actions
        dotfiles_install_xdg_dir "${PLUGIN_DIR}/XDG/config" "${CONFIG_HOME}/${PLUGIN}"
        dotfiles_install_xdg_dir "${PLUGIN_DIR}/XDG/share" "${DATA_HOME}/${PLUGIN}"
        dotfiles_install_xdg_dir "${PLUGIN_DIR}/XDG/state" "${STATE_HOME}/${PLUGIN}"
        dotfiles_install_xdg_dir "${PLUGIN_DIR}/XDG/cache" "${CACHE_HOME}/${PLUGIN}"
        dotfiles_source_file "${PLUGIN_DIR}/XDG/config/profile" "${CONFIG_HOME}/${PLUGIN}/profile" "${HOME_DIR}/.profile"
        # per plugin install actions
        install_file="${PLUGIN_DIR}/dotfiles-install.sh"
        eff_install_file=$(mktemp)
        msg_info "Installing plugin '${PLUGIN}' in '${HOME_DIR}'"
        if [ -x "${install_file}" ]; then
            cat "${install_file}" | sed "s/\${PLUGIN}/${PLUGIN}/g" > "${eff_install_file}"
            msg_info "Install file '${install_file}'"
            . "${eff_install_file}"
            rm "${eff_install_file}"
        else
            msg_info "No install file '${install_file}'"
        fi
        ;;
    commit)
        if [ -z "${DRY_RUN}" ]; then
            grep '\[I:' "${JOURNAL_FILE}" | cut -f2- -d' ' | while IFS= read -r cmd; do
                execute "make-app:install" "${cmd}"
            done
            {
                echo "set -e"
                grep '\[U:' "${JOURNAL_FILE}" | cut -f2- -d' ' | sed '1!G;h;$!d'
                echo "echo \"dotfiles succesfully uninstalled.\""
            } > "${UNINSTALL_FILE}"
            chmod a+x "${UNINSTALL_FILE}"
        else
            echo "That was dry run. Check out journal file: ${JOURNAL_FILE}"
        fi
        ;;
    uninstall)
        if [ ! -f "${UNINSTALL_FILE}" ]; then
            msg_error "make-app:prepare" "dotfiles not installed"
            exit 1
        fi
        ${UNINSTALL_FILE}
        ;;
    *)
        msg_error "make-app" "Bad task: '${COMMAND}:${TASK}'"
        exit 1
        ;;
esac
