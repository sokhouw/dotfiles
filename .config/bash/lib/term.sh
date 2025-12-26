# ------------------------------------------------------------------------------
# Globals
# ------------------------------------------------------------------------------

dfg_term_bg=''
dfg_term_fg=''

dfg:term:h2d() {
    printf '%d' "$((16#${1}))"
}

dfg:term:esc() {
    case "${2}" in
        '#'*)
            printf '\033[%s;2;%s;%s;%sm' "${1}" "$(dfg:term:h2d ${2:1:2})" "$(dfg:term:h2d ${2:3:2})" "$(dfg:term:h2d ${2:5:2})"
            ;;
        *)
            printf '\033[%s;5;%sm' "${1}" "${2}"
            ;;
    esac
}

dfg:term:bg() {
    if [[ "${1}" != "" ]]; then
        dfg:term:esc 48 "${1}"
        dfg_term_bg="${1}"
    fi
}

dfg:term:fg() {
    if [[ "${1}" != "" ]]; then
        dfg:term:esc 38 "${1}"
        dfg_term_fg="${1}"
    fi
}

dfg:term:bgfg() {
    dfg:term:bg "${1}"
    dfg:term:fg "${2}"
}

dfg:term:negative() {
    printf '\033[7m'
}

dfg:term:positive() {
    printf '\033[27m'
}

dfg:term:reset() {
    printf '\033[0m'
}
