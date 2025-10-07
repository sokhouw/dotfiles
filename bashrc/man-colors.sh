# see https://unix.stackexchange.com/questions/119/colors-in-man-pages

# Get color support for 'less'
export LESS='--RAW-CONTROL-CHARS'

# colors
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 202) # orange
export LESS_TERMCAP_me=$(tput sgr0) 
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yelow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

# For Konsole and Gnome terminal
export GROFF_NO_SGR=1
