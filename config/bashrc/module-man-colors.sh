# shellcheck shell=sh

# see https://unix.stackexchange.com/questions/119/colors-in-man-pages

# Get color support for 'less'
export LESS='--RAW-CONTROL-CHARS'

# colors
LESS_TERMCAP_mb="$(tput bold; tput setaf 2)" # green
LESS_TERMCAP_md="$(tput bold; tput setaf 202)" # orange
LESS_TERMCAP_me="$(tput sgr0)" 
LESS_TERMCAP_so="$(tput bold; tput setaf 3; tput setab 4)" # yelow on blue
LESS_TERMCAP_se="$(tput rmso; tput sgr0)"
LESS_TERMCAP_us="$(tput smul; tput bold; tput setaf 7)" # white
LESS_TERMCAP_ue="$(tput rmul; tput sgr0)"
LESS_TERMCAP_mr="$(tput rev)"
LESS_TERMCAP_mh="$(tput dim)"
LESS_TERMCAP_ZN="$(tput ssubm)"
LESS_TERMCAP_ZV="$(tput rsubm)"
LESS_TERMCAP_ZO="$(tput ssupm)"
LESS_TERMCAP_ZW="$(tput rsupm)"

export LESS_TERMCAP_mb
export LESS_TERMCAP_md
export LESS_TERMCAP_me
export LESS_TERMCAP_so
export LESS_TERMCAP_se
export LESS_TERMCAP_us
export LESS_TERMCAP_ue
export LESS_TERMCAP_mr
export LESS_TERMCAP_mh
export LESS_TERMCAP_ZN
export LESS_TERMCAP_ZV
export LESS_TERMCAP_ZO
export LESS_TERMCAP_ZW

# For Konsole and Gnome terminal
GROFF_NO_SGR=1
export GROFF_NO_SGR
