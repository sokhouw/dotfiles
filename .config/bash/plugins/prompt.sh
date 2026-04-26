#!/bin/bash

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    dfg_mode=sourced
else
    dfg_mode=executed
fi

if [[ "${dfg_mode}" == "executed" ]]; then
    . lib/core.sh
fi

dfg:lib:include "term"
dfg:lib:include "color"

# ------------------------------------------------------------------------------
# Globals
# ------------------------------------------------------------------------------

dfg_prompt_config_theme='builtin/ribbon'
dfg_prompt_config_separators_prefix='builtin/round'
dfg_prompt_config_palette='builtin/celestial_voyage'

declare dfg_prompt_theme=()
declare -A dfg_prompt_color=()

dfg_separators_arrows_out=(  'R'  'L'  'L▌'  'L'  'L ')
dfg_separators_arrows_in=(   'L'  'R'  'L▌'  'L'  'L ')
dfg_separators_arrows_left=( 'R'  'R'  'R'  'R'  'L ')
dfg_separators_arrows_right=('L'  'L'  'L'  'L'  'L ')
dfg_separators_flames_out=(  'R ' 'L ' 'L▌'  'L'  'L ')
dfg_separators_flames_in=(   'L ' 'R ' 'L▌'  'L'  'L ')
dfg_separators_flames_left=( 'R ' 'R ' 'R ' 'R ' 'L ')
dfg_separators_flames_right=('L ' 'L ' 'L ' 'L ' 'L ')
dfg_separators_round_out=(   'R< ' 'L>'  'L|'  'L/'  'L ')
dfg_separators_round_in=(    'L>'  'R<'  'L|'  'L\'  'L ')
dfg_separators_round_left=(  'R<'  'R<'  'R<'  'R<'  'L ')
dfg_separators_round_right=( 'L>'  'L>'  'L>'  'L>'  'L ')

# ------------------------------------------------------------------------------
# Built-In - Themes
# ------------------------------------------------------------------------------

dfg:prompt:builtin:theme:ribbon() {
    local branch=$(_branch)
    local result=$(_result)
    dfg_prompt_theme=(
        '%f3'
        '╭─'
    )
    if [[ "${result}" != "0" ]]; then
        dfg_prompt_theme+=(
            '%|0'
            '%b4' '%f0'
            "=${result}"
            '%|2'
            '%b0' '%f4'
        )
    else
        dfg_prompt_theme+=(
            '%|0'
            '%b0' '%f4'
        )
    fi
    dfg_prompt_theme+=(
        '=$(_time_hms)' 
        '%_4'
        '=$(_day_of_week)'
        '%|2'
        '%b1' '%f4'
        '=$(_user)@$(_host)'
        '%|2'
        '%b2' '%f0'
        '=$(_short_pwd)'
    )
    if [ ! -z "${branch}" ]; then
        dfg_prompt_theme+=(
            '%|3'
            '%b3'
            '%f0'
            ''
            '%_4'
            "=${branch}"
        )
    fi
    dfg_prompt_theme+=(
        '%|1'
        '%nl'
        '%f3'
        '╰ '
    )
}

# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------

dfg:prompt:set() {
    PS1=$(dfg:prompt:print)
}

spaces='        '

dfg:prompt:print() {
    case ${dfg_prompt_config_theme} in
        'builtin/'*) dfg:prompt:builtin:theme:${dfg_prompt_config_theme:8} ;;
        *)           ${dfg_prompt_config_theme} ;;
    esac
    case ${dfg_prompt_config_separators} in
        'builtin/'*) declare -n separators="dfg_separators_${dfg_prompt_config_separators:8}" ;;
        *)           exit 0 ;;
    esac
    case ${dfg_prompt_config_palette} in
        'builtin/'*) declare -n palette="dfg_palette_${dfg_prompt_config_palette:8}" ;;
        *)           exit 0 ;;
    esac
    for (( i = 0; i < ${#dfg_prompt_theme[@]}; i++ )); do
        local v="${dfg_prompt_theme[${i}]}"
        case "${v}" in
            '%b'[0-9]) # background
                dfg:term:bg "${palette[${v:2}]}"
                ;;
            '%f'[0-9]) # foreground
                dfg:term:fg "${palette[${v:2}]}"
                ;;
            '%|'[0-9]) # separator
                local separator="${separators[${v:2}]}"
                local separator_bg=''
                local separator_fg=''
                local prev_fg="${dfg_term_fg}"
                local prev_bg="${dfg_term_bg}"
                case "${separator:0:1}" in
                    'L')
                        if [[ "${debug}" == "1" ]]; then
                            dfg:term:debug "[left-sticky,prev_bg=${dfg_term_bg}]"
                        fi
                        local next_v="${dfg_prompt_theme[$((i + 1))]}"
                        local next_bg=''
                        case ${next_v} in
                            '%b'[0-9])
                                next_bg="${palette[${next_v:2}]}"
                                ;;
                            *)
                                next_bg=''
                                ;;
                        esac
                        if [[ "${dfg_term_bg}" == "" ]]; then
                            # no background, need to apply 'negative' trick
                            dfg:term:reset
                            dfg:term:negative
                            dfg:term:fg "${next_bg}"
                            printf '%s' "${separator:1}"
                            dfg:term:positive
                            dfg:term:reset
                            dfg:term:bg "${prev_bg}"
                            dfg:term:fg "${prev_fg}"
                        elif [[ "${next_bg}" == "" ]]; then
                            dfg:term:reset
                            dfg:term:fg "${prev_bg}"
                            printf '%s' "${separator:1}"
                            dfg:term:reset
                        else
                            dfg:term:bg "${next_bg}"
                            dfg:term:fg "${prev_bg}"
                            printf '%s' "${separator:1}"
                            dfg:term:reset
                            dfg:term:bg "${prev_bg}"
                            dfg:term:fg "${prev_fg}"
                        fi
                        ;;
                    'R')
                        if [[ "${debug}" == "1" ]]; then
                            dfg:term:debug "[right-sticky,prev_bg=${dfg_term_bg}]"
                        fi
                        local next_v="${dfg_prompt_theme[$((i + 1))]}"
                        local next_bg=''
                        case ${next_v} in
                            '%b'[0-9])
                                next_bg="${palette[${next_v:2}]}"
                                ;;
                            *)
                                next_bg=''
                                ;;
                        esac
                        if [[ "${next_bg}" == "" ]]; then
                            # no background, need to apply 'negative' trick
                            dfg:term:reset
                            dfg:term:negative
                            dfg:term:fg "${prev_bg}"
                            printf '%s' "${separator:1}"
                            dfg:term:positive
                            dfg:term:reset
                        else
                            dfg:term:bg "${prev_bg}"
                            dfg:term:fg "${next_bg}"
                            printf '%s' "${separator:1}"
                            dfg:term:reset
                            dfg:term:bg "${prev_bg}"
                            dfg:term:fg "${prev_fg}"
                        fi
                        ;;
                    *)
                        dfg:term:error "[bad separator '${separator}']"
                        ;;
                esac
                ;;
            '%_'[0-9]) # break
                printf '%s' "${separators[${v:2}]}"
                ;;
            '%nl')
                printf '\n'
                ;;
            '%'*)
                dfg:term:error "[invalid directove '${v}']"
                ;;
            =*)
                printf '%s' "${v:1}"
                ;;
            *)
                printf '%s' "${v}"
                ;;
        esac
    done
    dfg:term:reset
}

# ------------------------------------------------------------------------------
# Separators
# ------------------------------------------------------------------------------

dfg:prompt:decor:char() {
    case ${2} in
        left)
            case ${1} in
                block)    printf '▀' ;; # 2580
                full)     printf '█' ;; # 2588
                straight) printf '▐' ;; # 2590
                shade1)   printf '░' ;; # 2591
                shade2)   printf '▒' ;; # 2592
                shade3)   printf '▓' ;; # 2593
                step)     printf '▜' ;; # 259c
                arrow)    printf '' ;; # e0b2
                round)    printf '' ;; # e0b6
                lean)     printf '' ;; # e0be
                flames)   printf ' ';; # e0c2
                cracks1)  printf ' ';; # e0c5
                cracks2)  printf ' ';; # e0c7
                spikes)   printf ' ';; # e0ca
                space)    printf ' ' ;; #   20
                none) ;;
                *)        printf '%s' "${1}" ;;
            esac
            ;;
        right|'')
            case ${1} in
                block)    printf '▀' ;; # 2580
                full)     printf '█' ;; # 2588
                straight) printf '▌' ;; # 258c
                shade1)   printf '░' ;; # 2591
                shade2)   printf '▒' ;; # 2592
                shade3)   printf '▓' ;; # 2593
                step)     printf '▛' ;; # 259b
                lean)     printf '' ;; # e0bc
                arrow)    printf '' ;; # e0b0
                round)    printf '' ;; # e0b4
                flames)   printf ' ';; # e0c0
                cracks1)  printf ' ';; # e0c4
                cracks2)  printf ' ';; # e0c6
                spikes)   printf ' ';; # e0c8
                space)    printf ' ' ;; #   20
                none) ;;
                *)        printf '%s' "${1}" ;;
            esac
            ;;
        *)
            printf '%s' "${1}"
            ;;
    esac
}

# ------------------------------------------------------------------------------
# Breaks
# ------------------------------------------------------------------------------

dfg:prompt:break:char() {
    case ${2} in
        left)
            case ${1} in
                striaght) printf '│'  ;; # 2502
                lean)     printf '╲'  ;; # 2572
                arrow)    printf ''  ;; # e0b3
                round)    printf ''  ;; # e0b7
                flames)   printf ' ' ;; # e0c3
                space)    printf ' '  ;; #   20
                *)        printf '%s' "${1}" ;;
            esac
            ;;
        right|'')
            case ${1} in
                striaght) printf '│'  ;; # 2502
                lean)     printf '╱'  ;; # 2571
                arrow)    printf ''  ;; # e0b3
                round)    printf ''  ;; # e0b5
                flames)   printf ' ' ;; # e0c1
                space)    printf ' '  ;; #   20
                *)        printf '%s' "${1}" ;;
            esac
            ;;
        *)
            printf '%s' "${1}"
            ;;
    esac
}

# ------------------------------------------------------------------------------
# Content - built-in functions
# ------------------------------------------------------------------------------

__shorten() {
    local path="${1}"
    local maxlen="${2}"
    local prefix=""
    while [ "${#path}" -gt "${maxlen}" ]; do
        local shorter_path="${path#*/}"
        if [ "${#shorter_path}" -eq "${#path}" ]; then
            break
        else
            path="${shorter_path}"
            prefix="../"
        fi
    done
    printf '%s' "${prefix}${path}"
}

_result() {
    printf '0'
}

_short_pwd() {
    maxlen="${1}"
    local pwd="$(pwd)"
    case "${pwd}" in
        "${HOME}")
            printf '~'
            ;;
        "${HOME}"*)
            printf '%s' "~/$(__shorten "${pwd/${HOME}\///}" $((maxlen - 2)))"
            ;;
        *)
            printf '%s' "/$(__shorten "${pwd:1}" $((maxlen - 1)))"
            ;;
    esac
}

_pwd() {
    local pwd="${PWD}"
    case "${pwd}" in
        "${HOME}")
            printf "~"
            ;;
        "${HOME}"*)
            printf "~${pwd/${HOME}\///}"
            ;;
        *)
            printf "${pwd}"
            ;;
    esac
}

_branch() {
    printf 'main'
    # local pwd="$(pwd)"
    # pwd="${pwd##${HOME}/}"
    # pwd="$(echo "${pwd}" | cut -d'/' -f1,2)"
    # for s in $(${DFG} ls-files --full-name 2>/dev/null | cut -d'/' -f1,2 | sort -u); do
    #     if [ "${s}" = "${pwd}" ]; then
    #         ${DFG} branch --show-current 2>/dev/null
    #         return
    #     fi
    # done
    # git rev-parse --show-current 2>/dev/null
}

_time_hm() {
    printf '%s' "$(date +'%H:%M')"
}

_time_hms() {
    printf '%s' "$(date +'%H:%M:%S')"
}

_day_of_week() {
    printf '%s' "$(date +'%A')"
}

_day_of_week_short() {
    printf '%s' "$(date +'%a')"
}

_user() {
    printf '%s' "$(whoami)"
}

_host() {
    printf '%s' "$(hostname -s)"
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------

if [[ "${dfg_mode}" == "executed" ]]; then
    for t in $(grep "^dfg:prompt:builtin:theme:" -r plugins/prompt.sh | cut -f5 -d: | cut -f1 -d'('); do
        if [[ "${theme}" == "" || "${theme}" == "${t}" ]]; then
            dfg_prompt_config_theme="builtin/${t}"
            # for d in $(grep "^dfg:prompt:builtin:decor:" -r plugins/prompt.sh | cut -f5 -d: | cut -f1 -d'('); do
                # if [[ "${decor}" == "" || "${decor}" == "${d}" ]]; then
                    # dfg_prompt_config_decor="builtin/${d}"
                    # for p in $(grep "^declare dfg_palette_" lib/color.sh | cut -d_ -f3- | cut -d= -f1); do
                        # if [[ "${palette}" == "" || "${palette}" == "${p}" ]]; then
            for d in "in" out left right; do
                            dfg_prompt_config_separators="${dfg_prompt_config_separators_prefix}_${d}"
                            echo "theme=${t},decor=${dfg_prompt_config_decor},palette=${dfg_prompt_config_palette}"
                            # dfg:prompt:print
                            eval "printf '%b\\n' \"$(dfg:prompt:print)\""
                        # fi
                    # done
                # fi
            done
        fi
    done
else
    dfg:prompt:set
fi


