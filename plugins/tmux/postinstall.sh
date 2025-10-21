# shellcheck shell=sh

set -e

TMUX_PLUGIN_MANAGER_PATH=${DATA_HOME}/tmux/plugins

git clone https://github.com/tmux-plugins/tpm "${TMUX_PLUGIN_MANAGER_PATH}/tpm"
git clone https://github.com/fabioluciano/tmux-tokyo-night "${TMUX_PLUGIN_MANAGER_PATH}/tmux-tokyo-night"
