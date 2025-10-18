# shellcheck shell=sh

RED=$(printf '\033[1;31m')
GREEN=$(printf '\033[1;32m')
BLUE=$(printf '\033[1;34m')
#YELLOW=$(printf '\033[1;33m')
RESET=$(printf '\033[0;m')

wait_at_the_end=""

if [ -z "${TMUX_PLUGIN_MANAGER_PATH}" ]; then
    printf '%s%s%s\n' "${RED}" "Environment variable TMUX_PLUGIN_MANAGER_PATH is not set." "${RESET}"
    printf '%s%s%s\n' "${RED}" "See https://github.com/sokhouw/dotfiles" "${RESET}"
    wait_at_the_end=1
else
    if [ ! -d "${TMUX_PLUGIN_MANAGER_PATH}/tpm" ]; then
        printf '%s%s%s\n' "${BLUE}" "Cloning tmux-plugins/tpm" "${RESET}"
        if ! git clone https://github.com/tmux-plugins/tpm "${TMUX_PLUGIN_MANAGER_PATH}/tpm"; then
            printf '%s%s%s\n' "${RED}" "Failed." "${RESET}"
        else
            printf '%s%s%s\n' "${GREEN}" "Done." "${RESET}"
        fi
        wait_at_the_end=1
    fi

    # clone tmux-tokyo-night
    if [ ! -d "${TMUX_PLUGIN_MANAGER_PATH}/tmux-tokyo-night" ]; then
        printf '%s%s%s\n' "${BLUE}" "Clonging fabioluciano/tmux-tokyo-night" "${RESET}"
        if ! git clone https://github.com/fabioluciano/tmux-tokyo-night "${TMUX_PLUGIN_MANAGER_PATH}/tmux-tokyo-night"; then
            printf '%s%s%s\n' "${RED}" "Failed." "${RESET}"
        else
            printf '%s%s%s\n' "${GREEN}" "Done." "${RESET}"
        fi
        wait_at_the_end=1
    fi

    "${TMUX_PLUGIN_MANAGER_PATH}"/tpm/tpm
fi

if [ ! -z "${wait_at_the_end}" ]; then
    printf "Press ENTER to continue..."
    read -r "wait_at_the_end"
fi
