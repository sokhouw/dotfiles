# shellcheck shell=sh source=/dev/null

if [ ! -f "${1}" ]; then
    exit 1
fi

show_plugin_dir() {
    if [ -d "${2}" ]; then
        echo "${1}=\"${2}\""
    fi
}

. "${1}"

case "${2}" in
    version)
        echo "dotfiles-${DOTFILES_VERSION}"
        ;;
    show-plugins)
        for plugin in ${DOTFILES_PLUGINS}; do
            echo "==== PLUGIN ${plugin}"
            show_plugin_dir "CONFIG" "${DOTFILES_CONFIG_HOME}/${plugin}"
            show_plugin_dir "SHARE" "${DOTFILES_DATA_HOME}/${plugin}"
            show_plugin_dir "STATE" "${DOTFILES_STATE_HOME}/${plugin}"
        done
        ;;
    show-install)
        cat "${DOTFILES_INSTALL_FILE}"
        ;;
    show-uninstall)
        cat "${DOTFILES_UNINSTALL_FILE}"
        ;;
    uninstall)
        ${DOTFILES_UNINSTALL_FILE}
        ;;
    *)
        cmds=$(grep "    [a-z\-]\+)" "${0}" | sed "s/^    //" | sed "s/)\$//" | tr '\n' '|' | sed "s/|$//")
        echo "dotfiles-${DOTFILES_VERSION}"
        echo "usage:"
        echo "  dotfiles ${cmds}"
        ;;
esac
