# shellcheck shell=sh source=/dev/null

. "$(dirname "${0}")/lib-dotfiles.sh"
init "$@"

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
    plugin_xdg_dir="${1}"
    target_xdg_dir="${2}"
    parent_xdg="$(dirname "${target_xdg_dir}")"
    if [ -e "${target_xdg_dir}" ]; then
        backup_move "${target_xdg_dir}"
    else
        action "remove '${target_xdg_dir}'" \
               "" \
               "rm -rf \"${target_xdg_dir}\""
    fi
    if [ -e "${plugin_xdg_dir}" ]; then
        dotfiles_init_xdg "${parent_xdg}"
        action "install XDG dir '${plugin_xdg_dir}'" \
               "cp -r '${plugin_xdg_dir}' '${target_xdg_dir}'" \
               "rm -rf '${target_xdg_dir}'"
    fi
}

dotfiles_install_xdg_files() {
    plugin_xdg_dir="${1}"
    target_xdg_dir="${2}"

    if [ -e "${PLUGIN_DIR}/XDG/bin" ]; then
        dotfiles_init_xdg "${BIN_HOME}"
        for plugin_xdg_file in "${plugin_xdg_dir}"/*; do
            target_xdg_file="${target_xdg_dir}/$(basename "${plugin_xdg_file}")"
            if [ -e "${target_xdg_file}" ]; then
                backup_move "${target_xdg_file}"
            fi
            action "install XDG file '${plugin_xdg_file}'" \
                   "cp '${plugin_xdg_file}' '${target_xdg_file}'" \
                   "rm '${target_xdg_file}'"
        done
    fi
}

case "${TASK}" in
    prepare)
        if [ ! -e "${CONFIG_HOME}/dotfiles" ]; then
            mkdir -p "$(dirname "${JOURNAL_FILE}")" && rm -f "${JOURNAL_FILE}"
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
        dotfiles_install_xdg_files "${PLUGIN_DIR}/XDG/bin" "${BIN_HOME}"
        dotfiles_source_file "${PLUGIN_DIR}/XDG/config/profile" "${CONFIG_HOME}/${PLUGIN}/profile" "${PROFILE_FILE}"
        install_file="${PLUGIN_DIR}/install.sh"
        msg_info "Installing plugin '${PLUGIN}' in '${HOME_DIR}'"
        if [ -x "${install_file}" ]; then
            msg_info "Install file '${install_file}'"
            if ! . "${install_file}"; then
                exit 1
            fi
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
