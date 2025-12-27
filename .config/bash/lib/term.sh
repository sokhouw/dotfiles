# ------------------------------------------------------------------------------
# Globals
# ------------------------------------------------------------------------------

dfg_term_bg=''
dfg_term_fg=''
dfg_term_mode='positive'

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
    if [[ "${debug}" == "1" ]]; then
        dfg:term:debug "[fg=${1}]"
    fi
    if [[ "${1}" != "" ]]; then
        dfg:term:esc 48 "${1}"
        dfg_term_bg="${1}"
    fi
}

dfg:term:fg() {
    if [[ "${debug}" == "1" ]]; then
        dfg:term:debug "[bg=${1}]"
    fi
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
    if [[ "${debug}" == "1" ]]; then
        dfg:term:debug "[negitive]"
    fi
    dfg_term_mode=negative
    printf '\033[7m'
}

dfg:term:positive() {
    if [[ "${debug}" == "1" ]]; then
        dfg:term:debug "[positive]"
    fi
    dfg_term_mode=positive
    printf '\033[27m'
}

dfg:term:reset() {
    if [[ "${debug}" == "1" ]]; then
        dfg:term:debug "[reset]"
    fi
    printf '\033[0m'
}

dfg:term:debug() {
    dfg:term:info 9 7 "${1}"
}

dfg:term:error() {
    dfg:term:info 1 7 "${1}"
}

dfg:term:info() {
    local prev_debug=${debug}
    debug=0
    printf '\033[0m\033[27m\033[48;5;%sm\033[38;5;%sm%s\033[0m' "${1}" "${2}" "${3}"
    if [[ "${term_bg}" != "" ]]; then
        dfg:term:bg "${term_bg}"
    fi
    if [[ "${term_fg}" != "" ]]; then
        dfg:term:fg "${term_fg}"
    fi
    if [[ "${dfg_term_mode}" == negative ]]; then
        dfg:term:negative
    fi
    debug=${prev_debug}
}

