# shellcheck shell=sh

# add my home bin to the path
PATH=${HOME}/bin:${PATH}

# Remove duplicates
PATH="$(echo "${PATH}" | tr ':' '\n' | awk '!seen[$0]++' | paste -sd:)"

# .. and export
export PATH
