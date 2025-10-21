# shellcheck shell=sh

set -e

TMUX_PLUGIN_MANAGER_PATH=${DATA_HOME}/tmux/plugins

grep -E "^[[:space:]]*set -g @plugin" ~/.tmux.conf | sed -E "s/^[[:space:]]*set -g @plugin[[:space:]]+'([^']+)'/\1/" | while IFS= read -r plugin; do
    printf "==> ${plugin}"
    git clone https://github.com/${plugin} "${TMUX_PLUGIN_MANAGER_PATH}/$(basename "${plugin}")"
done
