# sellsheck shell=sh

version=$(git describe --tags --dirty --always 2>/dev/null || echo "unknown")
info_file="${CONFIG_HOME}/${PLUGIN}/info"

action "create info file \"${info_file}\"" \
    "touch \"${info_file}\"" \
    "rm \"${info_file}\""

action "info - DOTFILES_VERSION" \
       "echo \"DOTFILES_VERSION=${version}\" >> \"${info_file}\""

for var in UNINSTALL_FILE CONFIG_HOME DATA_HOME STATE_HOME ALL_PLUGINS; do
    action "info - DOTFILES_${var}" \
           "echo \"DOTFILES_${var}=${var}\" >> \"${info_file}\""
done

marker=" # dotfiles alias"
action "create dotfiles alias" \
       "echo \"alias dotfiles='${CONFIG_HOME}/dotfiles/dotfiles.sh ${1}'${marker}\" >> \"${HOME_DIR}/.profile\"" \
       "sed -i \"/${marker}/d\" \"${HOME_DIR}/.profile\""
