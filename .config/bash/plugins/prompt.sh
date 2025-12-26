#!/bin/bash

if [[ "${run}" == 1 ]]; then
    . lib/term.sh
else
    dfg:lib:include "term"
fi

# ------------------------------------------------------------------------------
# Globals
# ------------------------------------------------------------------------------

declare -A dfg_prompt_config=()
dfg_prompt=()

# ------------------------------------------------------------------------------
# Configuration - content - multiline
# ------------------------------------------------------------------------------

dfg:prompt:builtin:content:multiline() {
    local branch=$(_branch)
    local result=$(_result)
    local user=$(_user)
    local prompt_class="user_prompt"
    if [[ "${user}" == "root" ]]; then
        prompt_class="root_prompt"
    fi
    dfg_prompt=(
        "%${prompt_class}"
        '╭─'
    )
    if [[ "${result}" != "0" ]]; then
        dfg_prompt+=(
            '!separator.begin'
            '%error'
            "=${result}"
            '!separator'
            '%time'
        )
    else
        dfg_prompt+=(
            '!separator.begin'
            '%time'
        )
    fi
    dfg_prompt+=(
        '=$(_time_hms)' 
        '!break.time'
        '=$(_day_of_week)'
        '!separator'
        '%user'
        '=$(_user)@$(_host)'
        '!separator'
        '%dir'
        '=$(_short_pwd)'
    )
    if [ ! -z "${branch}" ]; then
        dfg_prompt+=(
            '!separator'
            '%git'
            ''
            '!break.git'
            "=${branch}"
        )
    fi
    dfg_prompt+=(
        '!separator.end'
        '!newline'
        "%${prompt_class}"
        '╰ '
    )
}

# ------------------------------------------------------------------------------
# Configuration - color - default
# ------------------------------------------------------------------------------

dfg:prompt:builtin:color:default() {
    dfg_prompt_config['error.bg']=7
    dfg_prompt_config['error.fg']=1

    dfg_prompt_config['time.bg']=69
    dfg_prompt_config['time.fg']=7

    dfg_prompt_config['user.bg']=27
    dfg_prompt_config['user.fg']=7

    dfg_prompt_config['dir.bg']=69
    dfg_prompt_config['dir.fg']=226

    dfg_prompt_config['git.bg']=52
    dfg_prompt_config['git.fg']=202
    
    dfg_prompt_config['flames.fg']=208

    dfg_prompt_config['user_prompt.fg']=75
    dfg_prompt_config['root_prompt.fg']=7
}

# ------------------------------------------------------------------------------
# Configuration - decor - default
# ------------------------------------------------------------------------------

dfg:prompt:builtin:decor:default() {
    dfg_prompt_config['separator.begin.kind']=flames
    dfg_prompt_config['separator.begin.direction']=right
    dfg_prompt_config['separator.begin.mode']=begin
    dfg_prompt_config['separator.begin.padding_right']=1

    dfg_prompt_config['separator.end.kind']=arrow
    dfg_prompt_config['separator.end.direction']=left
    dfg_prompt_config['separator.end.mode']=end
    dfg_prompt_config['separator.end.padding_left']=1

    dfg_prompt_config['separator.kind']=flames
    dfg_prompt_config['separator.direction']=right
    dfg_prompt_config['separator.padding_left']=1
    dfg_prompt_config['separator.padding_right']=1

    dfg_prompt_config['break.time.kind']=flames
    dfg_prompt_config['break.time.direction']=right
    dfg_prompt_config['break.time.class']=flames

    dfg_prompt_config['break.kind']=flames
    dfg_prompt_config['break.direction']=right
    dfg_prompt_config['break.class']=flames

    dfg_prompt_config['break.git.kind']=space
    dfg_prompt_config['break.git.direction']=left
    dfg_prompt_config['break.git.padding']=1
}

# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------

dfg:prompt:set() {
    PS1=$(dfg:prompt:print)
}

spaces='        '

dfg:prompt:print() {
    dfg:prompt:builtin:content:multiline
    dfg:prompt:builtin:color:default
    dfg:prompt:builtin:decor:default

    local class=''

    for (( i = 0; i < ${#dfg_prompt[@]}; i++ )) do
        local v="${dfg_prompt[${i}]}"
        if [[ "${debug}" == "1" ]]; then
            dfg:term:reset
            dfg:term:fg 2
            printf '[%s] ' "${v}"
            dfg:term:reset
        fi
        case ${v} in
            '%'*)
                class=${v:1}
                local next_bg=${dfg_prompt_config["${class}.bg"]}
                local next_fg=${dfg_prompt_config["${class}.fg"]}
                if [[ "${debug}" == "1" ]]; then
                    printf 'class %s' "${class}"
                    if [[ "${next_bg}" != "" ]]; then
                        printf ' bg=%s' "${next_bg}"
                    fi
                    if [[ "${next_fg}" != "" ]]; then
                        printf ' fg=%s' "${next_fg}"
                    fi
                    printf '\n'
                else
                    if [[ "${next_bg}" != "" ]]; then
                        dfg:term:bg "${next_bg}"
                    fi
                    if [[ "${next_fg}" != "" ]]; then
                        dfg:term:fg "${next_fg}"
                    fi
                fi
                ;;

            '!separator'*)
                local prefix=${v:1}
                local mode=${dfg_prompt_config["${prefix}.mode"]}
                local kind=${dfg_prompt_config["${prefix}.kind"]}
                local direction=${dfg_prompt_config["${prefix}.direction"]}
                local padding_left=${dfg_prompt_config["${prefix}.padding_left"]}
                local padding_right=${dfg_prompt_config["${prefix}.padding_right"]}
                local char=$(dfg:prompt:decor:char ${kind} ${direction})
                local next_bg=''
                local next_fg=''
                case ${mode} in
                    end)
                        ;;
                    *)
                        # skip next class item, we will set bg & fg
                        (( i += 1 ))
                        local next_v="${dfg_prompt[${i}]}"
                        case ${next_v} in
                            '%'*)
                                local next_class=${next_v:1}
                                next_bg=${dfg_prompt_config["${next_class}.bg"]}
                                next_fg=${dfg_prompt_config["${next_class}.fg"]}
                                ;;
                            *)
                                printf '[class expected: %s]' "${next_v}"
                                ;;
                        esac
                esac
                if [[ "${debug}" == "1" ]]; then
                    printf '%s,mode=%s,char=%s,next_class=(%s),next_bg=%s,next_fg=%s\n' \
                        "${prefix}" "${mode}" "${char}" "${next_class}" "${next_bg}" "${next_fg}"
                else
                    if [[ "${padding_left}" != "" ]]; then
                        printf '%s' "${spaces:0:${padding_left}}"
                    fi
                    case ${direction} in
                        left)
                            case ${mode} in
                                end)
                                    local bg=${dfg_term_bg}
                                    dfg:term:reset
                                    dfg:term:fg ${bg}
                                    dfg:term:negative
                                    printf '%s' "${char}"
                                    dfg:term:positive
                                    dfg:term:reset
                                    ;;
                                *)
                                    dfg:term:fg ${next_bg}
                                    printf '%s' "${char}"
                                    dfg:term:bgfg ${next_bg} ${next_fg}
                                    ;;
                            esac
                            ;;
                        right)
                            case ${mode} in
                                begin)
                                    dfg:term:negative
                                    dfg:term:fg ${next_bg}
                                    printf '%s' "${char}"
                                    dfg:term:positive 
                                    dfg:term:bgfg ${next_bg} ${next_fg}
                                    ;;
                                *)
                                    dfg:term:bgfg ${next_bg} ${dfg_term_bg}
                                    printf '%s' "${char}"
                                    dfg:term:fg ${next_fg}
                                    ;;
                            esac
                    esac
                    if [[ "${padding_right}" != "" ]]; then
                        printf '%s' "${spaces:0:${padding_right}}"
                    fi
                    if [[ "${direction}" == 'end' ]]; then
                        printf '\n'
                    fi
                fi
                ;;
            '!break'*)
                local prefix="${v:1}"
                local break_kind=${dfg_prompt_config["${prefix}.kind"]}
                local break_direction=${dfg_prompt_config["${prefix}.direction"]}
                local break_class=${dfg_prompt_config["${prefix}.class"]}
                if [[ "${break_class}" != "" ]]; then
                    local break_fg=${dfg_prompt_config["${break_class}.fg"]}
                else
                    local break_fg=""
                fi
                local break_char=$(dfg:prompt:break:char ${break_kind} ${break_direction})
                if [[ "${debug}" == "1" ]]; then
                    printf '%s,char=%s,char_class=%s,char_fg=%s\n' \
                        "${prefix}" "${break_char}" "${break_class}" "${break_fg}"
                else
                    if [[ "${break_fg}" != "" ]]; then
                        local fg=${dfg_term_fg}
                        dfg:term:fg ${break_fg}
                        printf '%s' "${break_char}"
                        dfg:term:fg ${fg}
                    else
                        printf '%s' "${break_char}"
                    fi
                fi
                ;;
            '!newline'*)
                local s="${v:7}"
                local next_class=${s#*:}
                local next_bg=${dfg_prompt_config["${next_class}.bg"]}
                local next_fg=${dfg_prompt_config["${next_class}.fg"]}
                if [[ "${debug}" == "1" ]]; then
                    printf 'newline,next_class=(%s)\n' "${next_class}"
                else
                    printf '\n'
                fi
                ;;
            '!'*)
                if [[ "${debug}" == "1" ]]; then
                    printf "unknown command '${v:1}'\n"
                fi
                ;;
            =*)
                if [[ "${debug}" == "1" ]]; then
                    eval printf '\"%s\"\\n' "${v:1}"
                else
                    eval printf '%s' "${v:1}"
                fi
                ;;
            *)
                if [[ "${debug}" == "1" ]]; then
                    printf '"%s"\n' "${v}"
                else
                    printf '%s' "${v}"
                fi
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
                *)        printf '%s' ${1} ;;
            esac
            ;;
        right)
            case ${1} in
                block)    printf '▀' ;; # 2580
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
                *)        printf '%s' ${1} ;;
            esac
            ;;
        *)
            case ${1} in
                space)    printf ' ' ;;
                *)        printf '%s' ${1} ;;
            esac
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
                *)        printf '%s' ${1} ;;
            esac
            ;;
        right)
            case ${1} in
                striaght) printf '│'  ;; # 2502
                lean)     printf '╱'  ;; # 2571
                arrow)    printf ''  ;; # e0b3
                round)    printf ''  ;; # e0b5
                flames)   printf ' ' ;; # e0c1
                space)    printf ' '  ;; #   20
                *)        printf '%s' ${1} ;;
            esac
            ;;
        *)
            case ${1} in
                space)    printf ' ' ;;
                *)        printf '%s' ${1} ;;
            esac
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
    printf "${prefix}${path}"
}

_result() {
    printf '0'
}

_short_pwd() {
    maxlen="${1}"
    local pwd="$(pwd)"
    case "${pwd}" in
        "${HOME}")
            printf "~"
            ;;
        "${HOME}"*)
            printf "~/$(__shorten "${pwd/${HOME}\///}" $((maxlen - 2)))"
            ;;
        *)
            printf "/$(__shorten "${pwd:1}" $((maxlen - 1)))"
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
    # echo $DFG
    # echo $pwd
    # for s in $(${DFG} ls-files --full-name 2>/dev/null | cut -d'/' -f1,2 | sort -u); do
    #     if [ "${s}" = "${pwd}" ]; then
    #         ${DFG} branch --show-current 2>/dev/null
    #         return
    #     fi
    # done
    # git rev-parse --show-current 2>/dev/null
}

_time_hm() {
    printf "$(date +'%H:%M')"
}

_time_hms() {
    printf "$(date +'%H:%M:%S')"
}

_day_of_week() {
    printf "$(date +'%A')"
}

_day_of_week_short() {
    printf "$(date +'%a')"
}

_user() {
    printf "$(whoami)"
}

_host() {
    printf "$(hostname -s)"
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------

if [[ "${run}" == "1" ]]; then
    dfg:prompt:print
else
    dfg:prompt:set
fi
