#!/bin/bash

# ------------------------------------------------------------------------------
# Core - global variables
# ------------------------------------------------------------------------------

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}

# libs array
declare -A dfg_libs=()

# define dfg command (alias is not available here)
DFG="git --git-dir ${dfg_repo_dir} --work-tree ${HOME}"

# main dfg configuration
declare -A dfg_config=()

# ------------------------------------------------------------------------------
# Core - dfg:lib
# ------------------------------------------------------------------------------

dfg:lib:path() {
    printf '%s/bash/lib/%s.sh' "${XDG_CONFIG_HOME}" "${1}"
}

dfg:lib:include() {
    if [ -z "${dfg_libs[${1}]}" ]; then
        local path="$(dfg:lib:path ${1})"
        if [ -f "${path}" ]; then
            if source "${path}"; then
                dfg_libs[${1}]=${path}
            fi
        fi
    fi
}

dfg:lib:show() {
    for k in "${!dfg_libs[@]}"; do
        echo "${k}=${dfg_libs[${k}]}"
    done | sort
}

# ------------------------------------------------------------------------------
# Core - dfg:config
# ------------------------------------------------------------------------------

dfg:config:set() {
    dfg_config["${1}"]="${2}"
}

dfg:config:get() {
    printf '%s' "${dfg_config["${1}"]}"
}

dfg:config:show() {
    for k in "${!dfg_config[@]}"; do
        echo "${k}=${dfg_config[${k}]}"
    done
}

# ------------------------------------------------------------------------------
# Core
# ------------------------------------------------------------------------------

dfg_libs['core']="$(dfg:lib:path core)"
