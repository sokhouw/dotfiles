# sellsheck shell=sh

version=$(git describe --tags --dirty --always 2>/dev/null || echo "unknown")
DOTFILES_INFO_FILE="${CONFIG_HOME}/${PLUGIN}/info"

action "create info file \"${DOTFILES_INFO_FILE}\"" \
    "touch \"${DOTFILES_INFO_FILE}\"" \
    "rm \"${DOTFILES_INFO_FILE}\""

action "info - DOTFILES_VERSION" \
       "echo \"DOTFILES_VERSION=${version}\" >> \"${DOTFILES_INFO_FILE}\""

for var in UNINSTALL_FILE BIN_HOME CONFIG_HOME DATA_HOME STATE_HOME ALL_PLUGINS; do
    eval value="\$${var}"
    action "info - DOTFILES_${var}" \
           "echo \"DOTFILES_${var}='${value}'\" >> \"${DOTFILES_INFO_FILE}\""
done

action "set info file" \
       "sed -i \"s|\\\${DOTFILES_INFO_FILE}|${CONFIG_HOME}/dotfiles/info|\" \"${BIN_HOME}/dotfiles\""
