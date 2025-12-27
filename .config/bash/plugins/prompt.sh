#!/bin/bash

if [[ "${run}" == "1" || "${debug}" == "1" ]]; then
    . lib/term.sh
else
    dfg:lib:include "term"
fi

# ------------------------------------------------------------------------------
# Globals
# ------------------------------------------------------------------------------

declare -A dfg_prompt_config=()
dfg_prompt=()

dfg_prompt_config['prompt.content']='dfg:prompt:builtin:content:multiline'
dfg_prompt_config['prompt.palette']='ocean_slate'
dfg_prompt_config['prompt.decor']='dfg:prompt:builtin:decor:multiline none left 1 lean right 1 arrow right 1'

dim() { dfg_prompt_palette=( "#001133" "#aaaaff" "#002244" "#ccccff" "#331100" "#ffaaaa" "#884400" "#ffcccc" "#ff8888" "#ffff88" ); }
anduino() { dfg_prompt_palette=( "#000a1f" "#b3bbff" "#001433" "#dde0ff" "#0a0a2a" "#aaaaff" "#111144" "#ccccff" "#1a1a55" "#eeeeff"); }
soft_periwinkle() { dfg_prompt_palette=( "#1a1a33" "#d6d6ff" "#2a2a55" "#f0f0ff" "#3a3a77" "#b3b3ff" "#222244" "#ccccff" "#111133" "#ffffff"); }
warm_sepa_glow() { dfg_prompt_palette=( "#2a1400" "#ffd1b3" "#3d1f00" "#ffe6d6" "#5c2e00" "#ffb388" "#331100" "#ffcccc" "#1f0a00" "#fff0e6"); }
autumn_ember() { dfg_prompt_palette=( "#331a00" "#ffd199" "#4d2600" "#ffebcc" "#663300" "#ffb366" "#884400" "#ffcccc" "#261300" "#fff2dd"); }
rose_ash() { dfg_prompt_palette=( "#330011" "#ffcce0" "#4d001a" "#ffe6f0" "#660022" "#ff99bb" "#22000b" "#fff0f6" "#110006" "#ffffff"); }
dusty_lavender() { dfg_prompt_palette=( "#221133" "#e0ccff" "#331a55" "#f2e6ff" "#442277" "#ccb3ff" "#1a0f2a" "#eeeeff" "#0f081a" "#ffffff"); }
ocean_slate() { dfg_prompt_palette=( "#001f26" "#ccefff" "#003340" "#e6f9ff" "#004d66" "#99e6ff" "#002933" "#dff6ff" "#00151a" "#ffffff"); }
copper_bush() { dfg_prompt_palette=( "#331100" "#ffd6cc" "#4d1a00" "#ffede6" "#662200" "#ffad99" "#2a0e00" "#fff2ee" "#1a0800" "#ffffff"); }
solar_pastel() { dfg_prompt_palette=( "#332b00" "#fff7cc" "#4d4000" "#fffce6" "#665500" "#fff199" "#261f00" "#fff9dd" "#1a1400" "#ffffff"); }

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

dfg:prompt:builtin:color:multiline() {
    dfg_prompt_config['time.bg']="${dfg_prompt_palette[0]}"
    dfg_prompt_config['time.fg']="${dfg_prompt_palette[1]}"

    dfg_prompt_config['user.bg']="${dfg_prompt_palette[2]}"
    dfg_prompt_config['user.fg']="${dfg_prompt_palette[3]}"

    dfg_prompt_config['dir.bg']="${dfg_prompt_palette[4]}"
    dfg_prompt_config['dir.fg']="${dfg_prompt_palette[5]}"

    dfg_prompt_config['git.bg']="${dfg_prompt_palette[6]}"
    dfg_prompt_config['git.fg']="${dfg_prompt_palette[7]}"
    
    dfg_prompt_config['error.bg']="${dfg_prompt_palette[8]}"
    dfg_prompt_config['error.fg']="${dfg_prompt_palette[9]}"

    dfg_prompt_config['prompt.fg']="${dfg_prompt_palette[2]}"
}

# ------------------------------------------------------------------------------
# Configuration - decor - default
# ------------------------------------------------------------------------------

dfg:prompt:builtin:decor:multiline() {
    dfg_prompt_config['separator.begin.kind']=${1}
    dfg_prompt_config['separator.begin.direction']=${2}
    dfg_prompt_config['separator.begin.padding_right']=${3}
    dfg_prompt_config['separator.begin.mode']=begin

    dfg_prompt_config['separator.kind']=${4}
    dfg_prompt_config['separator.direction']=${5}
    dfg_prompt_config['separator.padding_left']=${6}
    dfg_prompt_config['separator.padding_right']=${6}

    dfg_prompt_config['separator.end.kind']=${7}
    dfg_prompt_config['separator.end.direction']=${8}
    dfg_prompt_config['separator.end.padding_left']=${9}
    dfg_prompt_config['separator.end.mode']=end

    dfg_prompt_config['break.time.kind']=space

    dfg_prompt_config['break.git.kind']=space
}

# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------

dfg:prompt:set() {
    PS1=$(dfg:prompt:print)
}

spaces='        '

dfg:prompt:print() {
    eval ${dfg_prompt_config['prompt.content']}
    eval ${dfg_prompt_config['prompt.palette']}
    dfg:prompt:builtin:color:multiline
    eval ${dfg_prompt_config['prompt.decor']}

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
                                end)
                                    local bg=${dfg_term_bg}
                                    dfg:term:reset
                                    dfg:term:fg ${bg}
                                    printf '%s' "${char}"
                                    dfg:term:reset
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
                    printf '%s' "${v:1}"
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
                full)     printf '█' ;; # 2588
                half)     printf '▐' ;; # 2590
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
        right)
            case ${1} in
                block)    printf '▀' ;; # 2580
                full)     printf '█' ;; # 2588
                half)     printf '▌' ;; # 258c
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
            case ${1} in
                space)    printf ' ' ;;
                none) ;;
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

dfg:prompt:set
# if [[ "${run}" == "1" ]]; then
#     local ps1=$(dfg:prompt:print
#     eval "printf '\"%b\"\\n' \"$(dfg:prompt:print)\""
# elif [[ "${debug}" == "1" ]]; then
#     dfg:prompt:print
# else
#     dfg:prompt:set
# fi
