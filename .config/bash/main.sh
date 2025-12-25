#!/bin/bash

# Ensure XDG vars do exist
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

# Here's where raw dotfiles repo is located
dfg_repo_dir="${XDG_DATA_HOME}/dotfiles/repo"

. ${XDG_CONFIG_HOME}/bash/lib/core.sh

# Include user's configuration
source ${XDG_CONFIG_HOME}/bash/config.sh

# include all configured plugins
for plugin in ${dfg_config[plugins]}; do
# ------------------------------------------------------------------------------
    source ${XDG_CONFIG_HOME}/bash/plugins/${plugin}.sh
done
