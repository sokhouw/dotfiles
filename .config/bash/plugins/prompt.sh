#!/bin/bash

if [[ "${run}" == "1" ]]; then
    . lib/term.sh
else
    dfg:lib:include "term"
fi

# ------------------------------------------------------------------------------
# Globals
# ------------------------------------------------------------------------------

dfg_prompt_config_theme='builtin/ribbon'
dfg_prompt_config_decor='builtin/basic'
dfg_prompt_config_palette='builtin/neptune'

declare dfg_prompt_theme=()
declare -A dfg_prompt_decor=()
declare -A dfg_prompt_color=()

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
            '!separator.begin'
            '%b4' '%f0'
            "=${result}"
            '!separator'
            '%b0' '%f4'
        )
    else
        dfg_prompt_theme+=(
            '!separator.begin'
            '%b0' '%f4'
        )
    fi
    dfg_prompt_theme+=(
        '=$(_time_hms)' 
        '!break.one'
        '=$(_day_of_week)'
        '!separator.one'
        '%b1' '%f4'
        '=$(_user)@$(_host)'
        '!separator.one'
        '%b2' '%f0'
        '=$(_short_pwd)'
    )
    if [ ! -z "${branch}" ]; then
        dfg_prompt_theme+=(
            '!separator.two'
            '%b3'
            '%f0'
            ''
            '!break.two'
            "=${branch}"
        )
    fi
    dfg_prompt_theme+=(
        '!separator.end'
        '!newline'
        '%f3'
        '╰ '
    )
}

# ------------------------------------------------------------------------------
# Built-In - Decors
# ------------------------------------------------------------------------------

#                                    |begin---| |sep1-----| |sep2----| |end-------| |break1---| |break2---| |padding|
dfg:prompt:builtin:decor:straight()    { dfg:prompt:builtin:decor_builder straight ''  straight '' lean right straight '' space '' '' space '' '' 1; }

dfg:prompt:builtin:decor:arrows_ll()   { dfg:prompt:builtin:decor_builder arrow  left  straight '' lean right arrow    left  space '' '' space '' '' 1; }
dfg:prompt:builtin:decor:arrows_lr()   { dfg:prompt:builtin:decor_builder arrow  left  straight '' lean right arrow    right space '' '' space '' '' 1; }
dfg:prompt:builtin:decor:arrows_rl()   { dfg:prompt:builtin:decor_builder arrow  right straight '' lean right arrow    left  space '' '' space '' '' 1; }
dfg:prompt:builtin:decor:arrows_rr()   { dfg:prompt:builtin:decor_builder arrow  right straight '' lean right arrow    right space '' '' space '' '' 1; }

dfg:prompt:builtin:decor:round_ll()    { dfg:prompt:builtin:decor_builder round  left  straight '' lean right round    left  space '' '' space '' '' 1; }
dfg:prompt:builtin:decor:round_lr()    { dfg:prompt:builtin:decor_builder round  left  straight '' lean right round    right space '' '' space '' '' 1; }
dfg:prompt:builtin:decor:round_rl()    { dfg:prompt:builtin:decor_builder round  right straight '' lean right round    left  space '' '' space '' '' 1; }
dfg:prompt:builtin:decor:round_rr()    { dfg:prompt:builtin:decor_builder round  right straight '' lean right round    right space '' '' space '' '' 1; }

dfg:prompt:builtin:decor:flames_ll()   { dfg:prompt:builtin:decor_builder flames left  straight '' lean right flames   left  space '' '' space '' '' 1; }
dfg:prompt:builtin:decor:flames_lr()   { dfg:prompt:builtin:decor_builder flames left  straight '' lean right flames   right space '' '' space '' '' 1; }
dfg:prompt:builtin:decor:flames_rl()   { dfg:prompt:builtin:decor_builder flames right straight '' lean right flames   left  space '' '' space '' '' 1; }
dfg:prompt:builtin:decor:flames_rr()   { dfg:prompt:builtin:decor_builder flames right straight '' lean right flames   right space '' '' space '' '' 1; }

dfg:prompt:builtin:decor_builder() {
    dfg_prompt_decor=()

    local padding="${15}"

    dfg_prompt_decor['separator.begin.kind']="${1}"
    dfg_prompt_decor['separator.begin.direction']="${2:-right}"
    dfg_prompt_decor['separator.begin.padding_right']=${padding}
    dfg_prompt_decor['separator.begin.padding_right']=${padding}
    dfg_prompt_decor['separator.begin.mode']=begin

    dfg_prompt_decor['separator.one.kind']="${3}"
    dfg_prompt_decor['separator.one.direction']="${4:-right}"
    dfg_prompt_decor['separator.one.padding_left']="${padding}"
    dfg_prompt_decor['separator.one.padding_right']="${padding}"

    dfg_prompt_decor['separator.two.kind']="${5}"
    dfg_prompt_decor['separator.two.direction']="${6:-right}"
    dfg_prompt_decor['separator.two.padding_left']="${padding}"
    dfg_prompt_decor['separator.two.padding_right']="${padding}"

    dfg_prompt_decor['separator.end.kind']="${7}"
    dfg_prompt_decor['separator.end.direction']="${8:-right}"
    dfg_prompt_decor['separator.end.padding_left']="${padding}"
    dfg_prompt_decor['separator.end.mode']=end

    dfg_prompt_decor['break.one.kind']="${9}"
    dfg_prompt_decor['break.one.direction']="${10:-right}"
    dfg_prompt_decor['break.one.class']="${11}"

    dfg_prompt_decor['break.two.kind']="${12}"
    dfg_prompt_decor['break.two.direction']="${13:-right}"
    dfg_prompt_decor['break.two.class']="${14}"
}

# # ------------------------------------------------------------------------------
# # Built-In - Colors
# # ------------------------------------------------------------------------------
# #                                                           |head1| |head2| |text1| |text2| |error| |prompt|
# dfg:prompt:builtin:color:basic() { dfg:prompt:color_builder 003 001 004 003 006 008 012 000 009 010 '' 001  ; }
# dfg:prompt:builtin:color:basic() { dfg:prompt:color_builder 003 001 004 003 006 008 012 000 009 010 '' 001  ; }
# --deep-crimson: #931f1dff;
# --faded-copper: #937b63ff;
# --palm-leaf: #8a9b68ff;
# --dry-sage: #b6c197ff;
# --beige: #d5ddbcff;
#
# dfg:prompt:color_builder() {
#     dfg_prompt_color=()
#
#     dfg_prompt_color['head1.bg']="${1}"
#     dfg_prompt_color['head1.fg']="${2}"
#
#     dfg_prompt_color['head2.bg']="${3}"
#     dfg_prompt_color['head2.fg']="${4}"
#
#     dfg_prompt_color['text1.bg']="${5}"
#     dfg_prompt_color['text1.fg']="${6}"
#
#     dfg_prompt_color['text2.bg']="${7}"
#     dfg_prompt_color['text2.fg']="${8}"
#
#     dfg_prompt_color['error.bg']="${9}"
#     dfg_prompt_color['error.fg']="${10}"
#
#     dfg_prompt_color['prompt.bg']="${11}"
#     dfg_prompt_color['prompt.fg']="${12}"
# }
#
#
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
    case ${dfg_prompt_config_decor} in
        'builtin/'*) dfg:prompt:builtin:decor:${dfg_prompt_config_decor:8} ;;
        *)           ${dfg_prompt_config_decor} ;;
    esac
    case ${dfg_prompt_config_palette} in
        'builtin/'*) declare -n palette="dfg_palette_${dfg_prompt_config_palette:8}" ;;
        *)           exit 0; palette_var=${dfg_prompt_config_palette} ;;
    esac
    if [[ "${debug}" == "1" ]]; then
        for k in ${!dfg_prompt_theme[@]}; do
            echo "dfg_config_theme[${k}]=${dfg_prompt_theme[${k}]}"
        done
        for k in ${!dfg_prompt_decor[@]}; do
            echo "dfg_config_decor[${k}]=${dfg_prompt_decor[${k}]}"
        done
    fi
    for (( i = 0; i < ${#dfg_prompt_theme[@]}; i++ )); do
        local v="${dfg_prompt_theme[${i}]}"
        case "${v}" in
            '%b'[0-9])
                dfg:term:bg "${palette[${v:2}]}"
                ;;
            '%f'[0-9])
                dfg:term:fg "${palette[${v:2}]}"
                ;;
            '!separator'*)
                local prefix="${v:1}"
                local mode=${dfg_prompt_decor["${prefix}.mode"]}
                local kind=${dfg_prompt_decor["${prefix}.kind"]}
                local direction=${dfg_prompt_decor["${prefix}.direction"]}
                local padding_left=${dfg_prompt_decor["${prefix}.padding_left"]}
                local padding_right=${dfg_prompt_decor["${prefix}.padding_right"]}
                local char=$(dfg:prompt:decor:char ${kind} ${direction})
                local next_bg=''
                local next_fg=''
                case ${mode} in
                    end)
                        ;;
                    *)
                        # skip next class item, we will set bg & fg
                        # (( i += 1 ))

                        local next_v="${dfg_prompt_theme[$((i + 1))]}"
                        case ${next_v} in
                            '%b'[0-9])
                                next_bg="${palette[${next_v:2}]}"
                                ;;
                            *)
                                dfg:term:error "[background expected: '${next_v}']"
                                ;;
                        esac
                esac
                if [[ "${padding_left}" != "" ]]; then
                    printf '%s' "${spaces:0:${padding_left}}"
                fi
                case ${direction} in
                    left|'')
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
                        ;;
                esac
                if [[ "${padding_right}" != "" ]]; then
                    printf '%s' "${spaces:0:${padding_right}}"
                fi
                if [[ "${direction}" == 'end' ]]; then
                    printf '\n'
                fi
                ;;
            '!break'*)
                local prefix="${v:1}"
                local break_kind=${dfg_prompt_decor["${prefix}.kind"]}
                local break_direction=${dfg_prompt_decor["${prefix}.direction"]}
                local break_fg="${palette[${dfg_prompt_decor["${prefix}.fg"]}]}"
                local break_char="$(dfg:prompt:break:char ${break_kind} ${break_direction})"
                if [[ "${break_fg}" != "" ]]; then
                    local fg="${dfg_term_fg}"
                    dfg:term:fg "${break_fg}"
                    printf '%s' "${break_char}"
                    dfg:term:fg "${fg}"
                else
                    printf '%s' "${break_char}"
                fi
                ;;
            '!newline')
                printf '\n'
                ;;
            '!'*)
                printf '[unknown command "%s"]' "${v:1}"
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

if [[ "${run}" == "1" ]]; then
    for t in $(grep "^dfg:prompt:builtin:theme:" -r plugins/prompt.sh | cut -f5 -d: | cut -f1 -d'('); do
        if [[ "${theme}" == "" || "${theme}" == "${t}" ]]; then
            dfg_prompt_config_theme="builtin/${t}"
            for d in $(grep "^dfg:prompt:builtin:decor:" -r plugins/prompt.sh | cut -f5 -d: | cut -f1 -d'('); do
                if [[ "${decor}" == "" || "${decor}" == "${d}" ]]; then
                    dfg_prompt_config_decor="builtin/${d}"
                    for p in $(grep "^declare dfg_palette_" lib/color.sh | cut -d_ -f3- | cut -d= -f1); do
                        if [[ "${palette}" == "" || "${palette}" == "${p}" ]]; then
                            echo "theme=${t},decor=${d},palette=${p}"
                            dfg_prompt_config_palette="builtin/${p}"
                            #dfg:prompt:print
                            eval "printf '%b\\n' \"$(dfg:prompt:print)\""
                        fi
                    done
                fi
            done
        fi
    done
else
    dfg:prompt:set
fi

# dfg:prompt:builtin:palette:dim() { 
#     dfg_prompt_palette=( 
#         "#001133" "#aaaaff" 
#         "#002244" "#ccccff" 
#         "#331100" "#ffaaaa" 
#         "#884400" "#ffcccc" 
#         "#ff8888" "#ffff88" 
#     ) 
# }
#
# dfg:prompt:builtin:palette:midnight_indigo() {
#   dfg_prompt_palette=(
#         '#000a1f' '#6b7cff'
#         '#001433' '#9fb0ff'
#         '#0a0a2a' '#4f63ff'
#         '#111144' '#d2dbff'
#         '#1a1a55' '#b7c3ff'
#     )
# }
#
# dfg:prompt:builtin:palette:soft_periwinkle() {
#     dfg_prompt_palette=(
#         '#1a1a33' '#b0b4ff'
#         '#2a2a55' '#e8eaff'
#         '#3a3a77' '#8c90ff'
#         '#222244' '#6f76ff'
#         '#111133' '#cfd2ff'
#     )
# }
#
# dfg:prompt:builtin:palette:warm_sepia_glow() {
#     dfg_prompt_palette=(
#         '#2a1400' '#ff9650'
#         '#3d1f00' '#ffd9bf'
#         '#5c2e00' '#ff7a33'
#         '#331100' '#ffb08a'
#         '#1f0a00' '#ffe2cf'
#     )
# }
#
# dfg:prompt:builtin:palette:autumn_ember() {
#     dfg_prompt_palette=(
#         '#331a00' '#ff9a3d'
#         '#4d2600' '#ffe1b8'
#         '#663300' '#ff7a1a'
#         '#884400' '#ffb48f'
#         '#261300' '#ffedd9'
#     )
# }
#
# dfg:prompt:builtin:palette:rose_ash() {
#     dfg_prompt_palette=(
#         '#330011' '#ff6fa3'
#         '#4d001a' '#ffd1e4'
#         '#660022' '#ff4f8f'
#         '#22000b' '#ffb5d1'
#         '#110006' '#ffe6f0'
#     )
# }
#
# dfg:prompt:builtin:palette:dusty_lavender() {
#     dfg_prompt_palette=(
#         '#221133' '#a27bff'
#         '#331a55' '#ead9ff'
#         '#442277' '#8b5cff'
#         '#1a0f2a' '#cdb3ff'
#         '#0f081a' '#efe6ff'
#     )
# }
#
# dfg:prompt:builtin:palette:ocean_slate() {
#     dfg_prompt_palette=(
#         '#001f26' '#5fd8ff'
#         '#003340' '#d6f7ff'
#         '#004d66' '#2ecbff'
#         '#002933' '#9be9ff'
#         '#00151a' '#e0faff'
#     )
# }
#
# dfg:prompt:builtin:palette:moss_and_cream() {
#     dfg_prompt_palette=(
#         '#1a2600' '#9dff2e'
#         '#2a4000' '#ebffb8'
#         '#3d5c00' '#7fe600'
#         '#223300' '#c9ff7a'
#         '#111a00' '#f1ffe0'
#     )
# }
#
# dfg:prompt:builtin:palette:copper_blush() {
#     dfg_prompt_palette=(
#         '#331100' '#ff8a66'
#         '#4d1a00' '#ffe1d6'
#         '#662200' '#ff6a3d'
#         '#2a0e00' '#ffc1ad'
#         '#1a0800' '#ffece6'
#     )
# }
#
# dfg:prompt:builtin:palette:solar_pastel() {
#     dfg_prompt_palette=(
#         '#332b00' '#ffd11a'
#         '#4d4000' '#fff2b3'
#         '#665500' '#ffbf00'
#         '#261f00' '#ffe680'
#         '#1a1400' '#fff0c9'
#     )
# }
#
# dfg:prompt:builtin:palette:industrial() {
#     dfg_prompt_palette=(
#         '#1a1a1a' '#bfbfbf'
#         '#262626' '#e0e0e0'
#         '#333333' '#9fa6ad'
#         '#404040' '#cfd6dc'
#         '#4d4d4d' '#f0f2f4'
#     )
# }
#
# dfg:prompt:builtin:palette:old_city() {
#     dfg_prompt_palette=(
#         '#2b1d14' '#e0c2a2'
#         '#3a261a' '#f2d8bd'
#         '#4a3224' '#d4b08c'
#         '#5c4030' '#ebcfae'
#         '#6f523f' '#f7eadb'
#     )
# }
#
# dfg:prompt:builtin:palette:dark_wood() {
#     dfg_prompt_palette=(
#         '#1f140a' '#d2b48c'
#         '#2d1d12' '#e6c9a8'
#         '#3b2718' '#b9966e'
#         '#4a3220' '#dec3a1'
#         '#5a402b' '#f0e0cf'
#     )
# }
#
# dfg:prompt:builtin:palette:fire() {
#     dfg_prompt_palette=(
#         '#330000' '#ff6a00'
#         '#4d0000' '#ff9a3d'
#         '#660000' '#ff3d00'
#         '#802000' '#ffb36b'
#         '#992f00' '#ffd2a3'
#     )
# }
#
# dfg:prompt:builtin:palette:iceberg() {
#     dfg_prompt_palette=(
#         '#001a1f' '#6fe7ff'
#         '#002830' '#a6f3ff'
#         '#003d4a' '#2fd6ff'
#         '#005466' '#8feeff'
#         '#006b80' '#d9fbff'
#     )
# }
#
# dfg:prompt:builtin:palette:winter_night() {
#     dfg_prompt_palette=(
#         '#0b1020' '#8fa8ff'
#         '#121a33' '#b3c5ff'
#         '#1a244d' '#6f8cff'
#         '#232f66' '#cfd9ff'
#         '#2d3a80' '#e6ecff'
#     )
# }
#
# dfg:prompt:builtin:palette:moonlight() {
#     dfg_prompt_palette=(
#         '#0f111a' '#aab0c8'
#         '#181b26' '#d0d5f0'
#         '#22263a' '#8f97c8'
#         '#2c314d' '#bcc3ff'
#         '#373d66' '#e4e8ff'
#     )
# }
#

