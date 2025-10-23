# shellcheck shell=sh source=/dev/null

# ------------------------------------------------------------------------------
# colors
# ------------------------------------------------------------------------------

RED=$(printf '\033[1;31m')
GREEN=$(printf '\033[1;32m')
BLUE=$(printf '\033[1;34m')
RESET=$(printf '\033[0;m')

# ------------------------------------------------------------------------------
# actions
# ------------------------------------------------------------------------------

execute() {
    if result=$(eval "$* 2>&1"); then
        printf '%s %sOK%s\n' "$*" "${GREEN}" "${RESET}"
    else
        printf '%s %s%s%s\n' "$*" "${RED}" "${result}" "${RESET}"
        exit 1
    fi
}

run_script() {
    if [ -x "${1}" ]; then
        echo "${2}"
        cat "${1}" | while IFS= read -r cmd; do
            execute "${cmd}"
        done
    fi
}

header() {
    printf '%s==> %s%s\n' "${BLUE}" "$@" "${RESET}"
}

timestamp() {
    date +'%Y%m%d_%H%M%S'
}

run_install_actions() {
    tmp_uninstall_file="tmp_uninstall.sh"
    a_plugin=
    a_descr=
    a_install=
    a_uninstall=
    cat "${JOURNAL_FILE}" | while IFS= read -r line; do
        if [ ! -z "${line}" ]; then
            l_action="$(echo "${line}" | cut -f1 -d:)"
            l_plugin="$(echo "${line}" | cut -f2 -d:)"
            l_text="$(echo "${line}" | cut -f3- -d:)"
            case "${l_action}" in
                descr)
                    a_install=
                    a_uninstall=
                    a_plugin="${l_plugin}"
                    a_descr="${l_text}"
                    ;;
                install)
                    a_install="${l_text}"
                    ;;
                uninstall)
                    a_uninstall="${l_text}"
                    ;;
                *)
                    echo "Invalid action: ${l_action}"
                    exit 1
                    ;;
            esac
        else
            if [ ! -z "${a_install}" ]; then
                printf '%s%s%s %s\n' "${BLUE}" "[${a_plugin}]" "${RESET}" "${a_descr}"
                if result=$(eval "${a_install} 2>&1"); then
                    printf '%s %s%s%s\n' "${a_install}" "${GREEN}" "OK" "${RESET}"
                    if [ ! -z "${a_uninstall}" ]; then
                        echo "${a_uninstall} # install was: [${a_plugin}] ${a_descr}" >> "${tmp_uninstall_file}"
                    fi
                else
                    printf '%s %s%s%s\n' "${a_install}" "${RED}" "${result}" "${RESET}"
                    exit 1
                fi
            else
                if [ ! -z "${a_uninstall}" ]; then
                    echo "${a_uninstall} # install was: [${a_plugin}] ${a_descr}" >> "${tmp_uninstall_file}"
                fi
            fi
            a_plugin=
            a_descr=
            a_install=
            a_uninstall=
        fi
    done
    sed '1!G;h;$!d' "${tmp_uninstall_file}" > "${UNINSTALL_FILE}"
    chmod a+x "${UNINSTALL_FILE}"
    rm "${tmp_uninstall_file}"
}

init_action() {
    eval "${3}"
    eval "${2}"
    {
        echo "descr:dotfiles:${1}"
        echo "uninstall:dotfiles:${3}"
        echo
    } >> "${JOURNAL_FILE}"
}

action() {
    if ! grep "^descr:.*:${1}\$" "${JOURNAL_FILE}" 1>/dev/null 2>/dev/null; then
        {
            echo "descr:${PLUGIN}:${1}"
            if [ ! -z "${2}" ]; then
                echo "install:${PLUGIN}:${2}"
            fi
            if [ ! -z "${3}" ]; then
                echo "uninstall:${PLUGIN}:${3}"
            fi
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
        backup_path="${BACKUP_DIR}/$(echo "${orig_path}" | sed "s|${HOME_DIR}/||")"
        mkdir -p "$(dirname "${backup_path}")"
        action "${action_descr}" \
            "${backup_cmd} \"${orig_path}\" \"${backup_path}\"" \
            "rm -rf \"${orig_path}\" && mv \"${backup_path}\" \"${orig_path}\""
    fi
}


# ------------------------------------------------------------------------------
# command line
# ------------------------------------------------------------------------------

parse_cmdline() {
    COMMAND="${1}"
    shift

    while [ ! -z "${1}" ]; do
        case "${1}" in
            --plugins)
                PLUGINS="${2}"
                shift 2
                ;;
            --home)
                HOME_DIR="${2}"
                shift 2
                ;;
            *)
                printf '%sbad arg: %s%s\n' "${RED}" "${1}" "${RESET}"
                exit 1
                ;;
        esac
    done
}

# ------------------------------------------------------------------------------
# initialization
# ------------------------------------------------------------------------------

init_variables() {
    if [ -z "${HOME_DIR}" ]; then
        HOME_DIR="${HOME}"
    fi
    if [ -z "${XDG_BIN_HOME}" ] || [ ! -z "${HOME_DIR}" ]; then
        BIN_HOME="${HOME_DIR}/.local/bin"
    else
        BIN_HOME="${XDG_BIN_HOME}"
    fi
    if [ -z "${XDG_CONFIG_HOME}" ] || [ ! -z "${HOME_DIR}" ]; then
        CONFIG_HOME="${HOME_DIR}/.config"
    else
        CONFIG_HOME="${XDG_CONFIG_HOME}"
    fi
    if [ -z "${XDG_DATA_HOME}" ] || [ ! -z "${HOME_DIR}" ]; then
        DATA_HOME="${HOME_DIR}/.local/share"
    else
        DATA_HOME="${XDG_DATA_HOME}"
    fi
    if [ -z "${XDG_STATE_HOME}" ] || [ ! -z "${HOME_DIR}" ]; then
        STATE_HOME="${HOME_DIR}/.local/state"
    else
        STATE_HOME="${XDG_STATE_HOME}"
    fi
    if [ -z "${XDG_CACHE_HOME}" ] || [ ! -z "${HOME_DIR}" ]; then
        CACHE_HOME="${HOME_DIR}/.cache"
    else
        CACHE_HOME="${XDG_CACHE_HOME}"
    fi
    JOURNAL_FILE="${CACHE_HOME}/dotfiles/journal"
    BACKUP_DIR="${CACHE_HOME}/dotfiles/backup"
    UNINSTALL_FILE="${CACHE_HOME}/dotfiles/uninstall.sh"
    PROFILE_FILE="${HOME_DIR}/.bashrc"
    export HOME_DIR BACKUP_DIR
    export BIN_HOME CONFIG_HOME DATA_HOME STATE_HOME CACHE_HOME
    export JOURNAL_FILE BACKUP_FILE UNINSTALL_FILE PROFILE_FILE
    export PLUGINS
}

install_profile() {
    if [ -f "${PLUGIN_DIR}/XDG/config/profile" ]; then
        if [ ! -f "${PROFILE_FILE}" ]; then
            action "clean up \"${PROFILE_FILE}\"" \
                   "" \
                   "[ ! -s \"${PROFILE_FILE}\" ] && rm \"${PROFILE_FILE}\""
        fi
        comment="# dotfiles include: ${PLUGIN}"
        action "source '${CONFIG_HOME}/${PLUGIN}/profile' in '${PROFILE_FILE}'" \
               "echo '. ${CONFIG_HOME}/${PLUGIN}/profile ${comment}' >> '${PROFILE_FILE}'" \
               "sed -i \"/${comment}/d\" \"${PROFILE_FILE}\""
    fi
}

init_xdg() {
    if [ ! -e "${1}" ]; then
        init_xdg "$(dirname "${1}")"
        action "init XDG dir '${1}'" \
               "mkdir '${1}'" \
               "rmdir '${1}' || true"
    fi
}

install_xdg_dir() {
    plugin_xdg_dir="${1}"
    target_xdg_dir="${2}"
    parent_xdg="$(dirname "${target_xdg_dir}")"
    if [ -e "${plugin_xdg_dir}" ]; then
        # we're installing
        if [ -e "${target_xdg_dir}" ]; then
            # .. but target exists so let's backup
            backup_move "${target_xdg_dir}"
            # .. and then just install
            action "install XDG dir '${plugin_xdg_dir}'" \
                   "cp -r '${plugin_xdg_dir}' '${target_xdg_dir}'"
        else
            # .. but target does not exist so lets create structure
            init_xdg "${parent_xdg}"
            # .. and then install and remove when uninstalling
            action "install XDG dir '${plugin_xdg_dir}'" \
                   "cp -r '${plugin_xdg_dir}' '${target_xdg_dir}'" \
                   "rm -rf '${target_xdg_dir}'"
        fi
    fi
}

install_xdg_files() {
    plugin_xdg_dir="${1}"
    target_xdg_dir="${2}"

    if [ -e "${PLUGIN_DIR}/XDG/bin" ]; then
        init_xdg "${BIN_HOME}"
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

parse_cmdline "$@"
init_variables

case "${COMMAND}" in
    install)
        if [ ! -e "${CACHE_HOME}/dotfiles" ] && [ ! -e "${CONFIG_HOME}/dotfiles" ]; then
            header "preparing install actions"
            VERSION="$(git describe --tags --dirty --always 2>/dev/null || echo unknown)"
            init_action "init dotfiles cache" \
                        "mkdir -p '${CACHE_HOME}/dotfiles/backup'" \
                        "rm -rf '${CACHE_HOME}/dotfiles'"
            init_action "init dotfiles config" \
                        "mkdir -p '${CONFIG_HOME}/dotfiles'" \
                        "rm -rf '${CONFIG_HOME}/dotfiles'"
            for name in VERSION UNINSTALL_FILE BIN_HOME CONFIG_HOME DATA_HOME STATE_HOME PLUGINS; do
                eval "value=\"\$${name}\""
                echo "${name}='${value}'" >> "${CONFIG_HOME}/dotfiles/info"
            done
        else
            printf '%s%s%s\n' "${RED}" "Dotfiles already installed." "${RESET}" && exit 1
        fi

        for PLUGIN in ${PLUGINS}; do
            PLUGIN_DIR="plugins/${PLUGIN}"
            header "preparing install actions - ${PLUGIN} - default"
            install_xdg_dir "${PLUGIN_DIR}/XDG/config" "${CONFIG_HOME}/${PLUGIN}"
            install_xdg_dir "${PLUGIN_DIR}/XDG/share" "${DATA_HOME}/${PLUGIN}"
            install_xdg_dir "${PLUGIN_DIR}/XDG/state" "${STATE_HOME}/${PLUGIN}"
            install_xdg_dir "${PLUGIN_DIR}/XDG/cache" "${CACHE_HOME}/${PLUGIN}"
            install_xdg_files "${PLUGIN_DIR}/XDG/bin" "${BIN_HOME}"
            install_profile #"${PLUGIN_DIR}/profile" "${CONFIG_HOME}/${PLUGIN}/profile" "${PROFILE_FILE}"
            if [ -x "${PLUGIN_DIR}/install.sh" ]; then
                header "preparing install actions - ${PLUGIN} - '${PLUGIN_DIR}/install.sh'" 
                if ! . "${PLUGIN_DIR}/install.sh"; then
                    exit 1
                fi
            fi
        done

        header "running install actions"
        run_install_actions

        header "running postinstall scripts"
        for PLUGIN in ${PLUGINS}; do
            PLUGIN_DIR="plugins/${PLUGIN}"
            postinstall="${PLUGIN_DIR}/postinstall.sh"
            if [ -x "${postinstall}" ]; then
                printf '%s%s%s %s\n' "${BLUE}" "[${PLUGIN}]" "${RESET}" "post-install script '${postinstall}'"
                if . "${postinstall}"; then
                    printf '%s%s%s\n' "${GREEN}" "OK" "${RESET}"
                else
                    printf '%s%s%s\n' "${RED}" "FAILED" "${RESET}"
                    exit 1
                fi
            fi
        done
        ;;
    uninstall)
        if [ -x "${UNINSTALL_FILE}" ]; then
            run_script "${UNINSTALL_FILE}"
        else
            printf '%s%s%s\n' "${RED}" "Dotfiles not installed." "${RESET}" >&2 && exit 1
        fi
        ;;
esac
