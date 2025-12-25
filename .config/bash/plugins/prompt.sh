#!/bin/bash

dfg:lib:include "term"

# ------------------------------------------------------------------------------
# Defaults
# ------------------------------------------------------------------------------

dfg_config['prompt.begin.type']=none
dfg_config['prompt.separator.type']=lean
dfg_config['prompt.separator.side']=right
dfg_config['prompt.separator.padding']=1
dfg_config['prompt.break.type']=space
dfg_config['prompt.end.type']=arrow

# ------------------------------------------------------------------------------
# Content - multiline
# ------------------------------------------------------------------------------

dfg:prompt:builtin:content:multiline() {
    local branch=$(_branch)
    dfg_prompt=(
        '%prompt' '╭─'
        '!begin'
        '%time' '$(_time_hms)' '!break' '$(_day_of_week)'
        '!separator'
        '%user' '$(_user)@$(_host)'
        '!separator'
        '%dir' '$(_short_pwd)'
    )
    if [ ! -z "${branch}" ]; then
        dfg_prompt+=(
            '!separator'
            '%git' '' '!break' "${branch}"
        )
    fi
    dfg_prompt+=(
        '!end'
        '!newline'
        '%prompt' '╰ '
    )
}

dfg:prompt:builtin:decorations:default() {
    dfg_config['prompt.begin.type']='space'
    dfg_config['prompt.separator.type']='lean'
    dfg_config['prompt.separator.side']='right'
    dfg_config['prompt.break.type']='space'
    dfg_config['prompt.end.type']='arrow'
    dfg_config['prompt.end.side']='right'
}

dfg:prompt:builtin:palette:default() {
    dfg_config['prompt.class.time.bg']=69
    dfg_config['prompt.class.time.fg']=7

    dfg_config['prompt.class.user.bg']=27
    dfg_config['prompt.class.user.fg']=7

    dfg_config['prompt.class.dir.bg']=69
    dfg_config['prompt.class.dir.fg']=226

    dfg_config['prompt.class.git.bg']=52
    dfg_config['prompt.class.git.fg']=202

    dfg_config['prompt.class.prompt.fg']=75
}

# ------------------------------------------------------------------------------
# Overrides
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Utilities
# ------------------------------------------------------------------------------

shorten() {
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

next_bg() {
    local i=${1}
    local next_part="${dfg_prompt[$((i + 1))]}"
    case "${next_part}" in
        "%"*)
            printf '%s' "$(dfg:config:get "prompt.class.${next_part:1}.bg")"
            ;;
        *)
            ;;
    esac
}

dfg:prompt:begin() {
    local -n element="${1}"
    local prev_bg="${2}"
    local next_bg="${3}"
    local str="$(dfg:prompt:element:get "element" "type"),$(dfg:prompt:element:get "element" "side")"
    case "${str}" in
        lean,left)   dfg:term:fg "${next_bg}"; printf ''  ;; # e0be
        lean,right)  dfg:term:fg "${next_bg}"; printf ''  ;; # e0ba
        arrow,left)  dfg:term:fg "${next_bg}"; printf ''  ;; # e0b2
        arrow,right) dfg:term:fg "${next_bg}"; printf ''  ;; # e0d7
        step,left)   dfg:term:fg "${next_bg}"; printf '▜'  ;; # 259c
        step,right)  dfg:term:fg "${next_bg}"; printf '▗'  ;; # 2596
        block,left)  dfg:term:fg "${next_bg}"; printf '▀'  ;; # 2584
        block,right) dfg:term:fg "${next_bg}"; printf '▄'  ;; # 2584
        round,*)     dfg:term:fg "${next_bg}"; printf ''  ;; # e0b6
        straight,*)  dfg:term:fg "${next_bg}"; printf '▐'  ;; # 2590
        flames,*)    dfg:term:fg "${next_bg}"; printf ' ' ;; # e0c2
        spikes,*)    dfg:term:fg "${next_bg}"; printf ' ' ;; # e0ca
        tiles,*)     dfg:term:fg "${next_bg}"; printf ' ' ;; # e0c4
        bricks,*)    dfg:term:fg "${next_bg}"; printf ' ' ;; # e0c2
        space,*)     dfg:term:bg "${next_bg}"; printf ' '  ;;
        none,*) ;;
        *)           dfg:term:fg "${next_bg}"; printf '?(%s)' "${str}"; dfg:term:bg "${next_bg}";;
    esac
    dfg:term:bg "${next_bg}"
    dfg:prompt:padding "$(dfg:prompt:element:get "element" "padding")"
}

dfg:prompt:separator() {
    local -n element="${1}"
    local prev_bg="${2}"
    local next_bg="${3}"
    dfg:prompt:padding "$(dfg:prompt:element:get "element" "padding_left" "padding")"
    local str="$(dfg:prompt:element:get "element" "type"),$(dfg:prompt:element:get "element" "side")"
    case "${str}" in
        lean,left)    dfg:term:fg "${next_bg}"; printf '' ;; # e0be
        lean,right)   dfg:term:fg "${next_bg}"; printf '' ;; # e0ba
        arrow,left)   dfg:term:fg "${next_bg}"; printf '' ;; # e0b2
        arrow,right)  dfg:term:fg "${next_bg}"; printf '' ;; # e0d7
        step,left)    dfg:term:fg "${next_bg}"; printf '▜' ;; # 259c
        step,right)   dfg:term:fg "${next_bg}"; printf '▟' ;; # 259f
        block,left)   dfg:term:fg "${next_bg}"; printf '▀' ;; # 2584
        block,right)  dfg:term:fg "${next_bg}"; printf '▄' ;; # 2584
        round,left)   dfg:term:fg "${next_bg}"; printf ''  ;; # e0b6
        round,right)  dfg:term:fg "${prev_bg}"; dfg:term:bg "${next_bg}"; printf '' ;; # e0b4
        straight,*)   dfg:term:fg "${next_bg}"; printf '▐' ;; # 2590
        flames,left)  dfg:term:fg "${next_bg}"; printf ' ';; # e0c2
        flames,right) dfg:term:fg "${prev_bg}"; dfg:term:bg "${next_bg}"; printf ' ';; # e0c0
        spikes,left)  dfg:term:fg "${next_bg}"; printf ' ';; # e0c2
        spikes,right) dfg:term:fg "${prev_bg}"; dfg:term:bg "${next_bg}"; printf ' ';; # e0c8
        tiles,left)   dfg:term:fg "${next_bg}"; printf ' ';; # e0c2
        tiles,right)  dfg:term:fg "${prev_bg}"; dfg:term:bg "${next_bg}"; printf ' ';; # e0c4
        bricks,left)  dfg:term:fg "${next_bg}"; printf ' ';; # e0c2
        bricks,right) dfg:term:fg "${prev_bg}"; dfg:term:bg "${next_bg}"; printf ' ';; # e0c6
        none,*) ;;
        *) dfg:term:fg "${next_bg}"; printf '?(%s)' "${str}"; dfg:term:bg "${next_bg}";;
    esac
    dfg:term:bg "${next_bg}"
    dfg:prompt:padding "$(dfg:prompt:element:get "element" "padding_right" "padding")"
}

spaces='          '
dfg:prompt:padding() {
    while [ $# -gt 0 ]; do
        if [ ! -z "${1}" ]; then
            printf "${spaces:0:${1}}"
            return
        fi
        shift
    done
}

dfg:prompt:break() {
    local -n element="${1}"
    local prev_bg="${2}"
    local prev_fg="${3}"
    local str="$(dfg:prompt:element:get "element" "type"),$(dfg:prompt:element:get "element" "side")"
    dfg:prompt:padding "$(dfg:prompt:element:get "element" "padding")"
    dfg:term:fg "$(dfg:prompt:element:get "element" "fg")"
    case "${str}" in 
        lean,left)      printf '╲' ;; # 2572
        lean,right)     printf '╱' ;; # 2571
        arrow,left)     printf '' ;; # e0b3
        arrow,right)    printf '' ;; # e0b1
        # step,left)      printf '▖' ;; # 2596
        # step,right)     printf '▘' ;; # 2598
        # block,left)     printf '▄' ;; # 2584
        # block,right)    printf '▀' ;; # 2584
        round,left)     printf '' ;; # e0b7
        round,right)    printf '' ;; # e0b5
        straight,*)     printf '│' ;; # 2502
        flames,left)    printf ' ';; # e0c3
        flames,right)   printf ' ';; # e0c1
        # spikes,*)       printf ' ';; # e0c8
        # tiles,*)        printf ' ';; # e0c4
        # bricks,*)       printf ' ';; # e0c6
        space,*) printf ' ' ;;
        none,*) ;;
        *) printf '?(%s)' "${str}" ;;
    esac
    dfg:term:fg "${prev_fg}"
}

dfg:prompt:end() {
    local -n element="${1}"
    local prev_bg="${2}"
    dfg:prompt:padding "$(dfg:prompt:element:get "element" "padding")"
    dfg:term:reset
    local str="$(dfg:prompt:element:get "element" "type"),$(dfg:prompt:element:get "element" "side")"
    case "${str}" in 
        lean,left)      dfg:term:fg "${prev_bg}"; printf '' ;; # e0b8
        lean,right)     dfg:term:fg "${prev_bg}"; printf '' ;; # e0bc
        arrow,left)     dfg:term:fg "${prev_bg}"; printf '' ;; # e0d6
        arrow,right)    dfg:term:fg "${prev_bg}"; printf '' ;; # e0b0
        step,left)      dfg:term:fg "${prev_bg}"; printf '▖' ;; # 2596
        step,right)     dfg:term:fg "${prev_bg}"; printf '▘' ;; # 2598
        block,left)     dfg:term:fg "${prev_bg}"; printf '▄' ;; # 2584
        block,right)    dfg:term:fg "${prev_bg}"; printf '▀' ;; # 2584
        round,*)        dfg:term:fg "${prev_bg}"; printf '' ;; # e0b4
        straight,*)     dfg:term:fg "${prev_bg}"; printf '▌' ;; # 258c
        flames,*)       dfg:term:fg "${prev_bg}"; printf ' ';; # e0c0
        spikes,*)       dfg:term:fg "${prev_bg}"; printf ' ';; # e0c8
        tiles,*)        dfg:term:fg "${prev_bg}"; printf ' ';; # e0c4
        bricks,*)       dfg:term:fg "${prev_bg}"; printf ' ';; # e0c6
        none,*) ;;
        *) dfg:term:fg "${prev_bg}"; printf '?(%s)' "${str}" ; dfg:term:bg "${prev_bg}";;
    esac
}

dfg:prompt() {
    $(dfg:config:get 'prompt.decorations')
    $(dfg:config:get 'prompt.palette')
    $(dfg:config:get 'prompt.content')

    local i=0 len=${#dfg_prompt[@]}

    local prev_bg=""
    local prev_fd=""
    while ((i < len)); do
        local part="${dfg_prompt[${i}]}"
        case "${part}" in
            !newline*)
                printf '\n'
                ;;
            !*)
                local -A p_element=()
                dfg:prompt:element "p_element" "${part:1}"
                case ${part:1} in
                    begin*)
                        dfg:prompt:begin "p_element" "${prev_bg}" "$(next_bg ${i})"
                        ;;
                    separator*)
                        dfg:prompt:separator "p_element" "${prev_bg}" "$(next_bg ${i})"
                        ;;
                    break*)
                        dfg:prompt:break "p_element" "${prev_bg}" "${prev_fg}"
                        ;;
                    end*)
                        dfg:prompt:end "p_element" "${prev_bg}"
                        ;;
                esac
                ;;
            "%"*)
                local class="${part:1}"
                local bg="$(dfg:config:get "prompt.class.${class}.bg")"
                local fg="$(dfg:config:get "prompt.class.${class}.fg")"
                if [ ! -z "${bg}" ]; then
                    dfg:term:bg "${bg}"
                    prev_bg="${bg}"
                fi
                if [ ! -z "${fg}" ]; then
                    dfg:term:fg "${fg}"
                    prev_fg="${fg}"
                fi
                ;;
            *)
                eval "local str=\"${part}\""
                printf '%b' "${str}"
                ;;
        esac
        ((i++))
    done
    dfg:term:reset
}

dfg:prompt:element:get() {
    local -n r_element="${1}"
    shift

    while [ "$#" -gt 0 ]; do
        local key="${1}"

        # check element
        local value="${r_element["${key}"]}"
        if [ ! -z "${value}" ]; then printf "${value}"; return; fi

        # check class in config
        local class="${r_element["_class"]}"
        if [ ! -z "${class}" ]; then
            value="$(dfg:config:get "prompt.${class}.${name}.${key}")"
            if [ ! -z "${value}" ]; then printf "${value}"; return; fi
        fi

        # checo name in config
        local name="${r_element["_name"]}"
        value="$(dfg:config:get "prompt.${name}.${key}")"
        if [ ! -z "${value}" ]; then printf "${value}"; return; fi

        shift
    done
}
 
# arg1: name of the associative array
# arg2: [<element>[:<class>]][(<key_value_pairs)]
dfg:prompt:element() {
    local -n out="$1" # nameref to caller's variable
    #declare -A out=()    # ensure associative array
    local str="${2}"
   
    local element="${str%(*}"
    local element_arr=(${element/:/ })
    local name="" class=""
    case "${#element_arr[@]}" in
        1)
            name="${element_arr[0]}"
            ;;
        2) 
            name="${element_arr[0]}"
            class="${element_arr[1]}"
            ;;
        *)
            return
    esac
    # remove name:class part
    local kv_pairs_str="${str#${element}}"
    # remove '(' and ')'
    if [ ! -z "${kv_pairs_str}" ]; then
        kv_pairs_str="${kv_pairs_str#(}"
        kv_pairs_str="${kv_pairs_str%)*}"
        if [ ! -z "${kv_pairs_str}" ]; then
            kv_pairs_str="${kv_pairs_str//[,;]/ }"
            kv_pairs_str="${kv_pairs_str//=/]=}"
            kv_pairs_str="[${kv_pairs_str// / [}"
        fi
    fi
    eval "out=([_name]=\"${name}\" [_class]=\"${class}\" ${kv_pairs_str})"
}


# ------------------------------------------------------------------------------
# Prompt Parts
# ------------------------------------------------------------------------------

_short_pwd() {
    maxlen="${1}"
    local pwd="$(pwd)"
    case "${pwd}" in
        "${HOME}")
            printf "~"
            ;;
        "${HOME}"*)
            printf "~/$(shorten "${pwd/${HOME}\///}" $((maxlen - 2)))"
            ;;
        *)
            printf "/$(shorten "${pwd:1}" $((maxlen - 1)))"
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
    local pwd="$(pwd)"
    pwd="${pwd##${HOME}/}"
    pwd="$(echo "${pwd}" | cut -d'/' -f1,2)"
    for s in $(${DFG} ls-files --full-name 2>/dev/null | cut -d'/' -f1,2 | sort -u); do
        if [ "${s}" = "${pwd}" ]; then
            ${DFG} branch --show-current 2>/dev/null
            return
        fi
    done
    git rev-parse --show-current 2>/dev/null
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

_result() {
    printf "?"
}

_newline() {
    printf '\n'
}


# # # ------------------------------------------------------------------------------
# # # Decorations - none
# # # ------------------------------------------------------------------------------
# #
# # dfg_prompt_decorations_none() {
# #     dfg_begin_type=none
# #     dfg_separator_type=none
# #     dfg_break_type=none
# #     dfg_end_type=none
# # }
# #
# # # ------------------------------------------------------------------------------
# # # Decorations - base
# # # ------------------------------------------------------------------------------
# #
# # dfg_prompt_decorations_() {
# #     dfg_begin_side=left
# #     dfg_begin_padding=1
# #     dfg_separator_type=none
# #     dfg_separator_padding=1
# #     dfg_break_type=space
# #     dfg_end_side=right
# #     dfg_end_padding=1
# # }
# #
# # # ------------------------------------------------------------------------------
# # # Decorations - round
# # # ------------------------------------------------------------------------------
# # #
# # dfg_prompt_decorations_round() {
# #     dfg_prompt_decorations_
# #     dfg_begin_type=round
# #     dfg_separator_type=round
# #     dfg_separator_side=right
# #     dfg_end_type=round
# # }
# #
# # dfg_prompt_decorations_round_lean_left() {
# #     dfg_prompt_decorations_round
# #     dfg_separator_type=lean
# #     dfg_separator_side=left
# # }
# #
# # dfg_prompt_decorations_round_lean_right() {
# #     dfg_prompt_decorations_round
# #     dfg_separator_type=lean
# #     dfg_separator_side=right
# # }
# #
# # # ------------------------------------------------------------------------------
# # # Decorations - pointy
# # # ------------------------------------------------------------------------------
# #
# # dfg_prompt_decorations_pointy_left() {
# #     dfg_prompt_decorations_
# #     dfg_begin_type=arrow
# #     dfg_separator_type=arrow
# #     dfg_separator_side=left
# #     dfg_end_type=arrow
# #     dfg_end_side=left
# # }
# #
# # dfg_prompt_decorations_pointy_right() {
# #     dfg_prompt_decorations_
# #     dfg_begin_type=arrow
# #     dfg_begin_side=right
# #     dfg_separator_type=arrow
# #     dfg_separator_side=right
# #     dfg_end_type=arrow
# # }
# #
# # # ------------------------------------------------------------------------------
# # # Decorations - fancy
# # # ------------------------------------------------------------------------------
# #
# # dfg_prompt_decorations_flames() {
# #     dfg_prompt_decorations_
# #     dfg_begin_type=flames
# #     dfg_separator_type=flames
# #     dfg_end_type=flames
# # }
# #
# # dfg_prompt_decorations_spikes() {
# #     dfg_prompt_decorations_
# #     dfg_begin_type=spikes
# #     dfg_separator_type=spikes
# #     dfg_end_type=spikes
# # }
# #
# # dfg_prompt_decorations_tiles() {
# #     dfg_prompt_decorations_
# #     dfg_begin_type=tiles
# #     dfg_separator_type=tiles
# #     dfg_end_type=tiles
# # }
# #
# # dfg_prompt_decorations_bricks() {
# #     dfg_prompt_decorations_
# #     dfg_begin_type=bricks
# #     dfg_separator_type=bricks
# #     dfg_end_type=bricks
# # }
# #
# # # ------------------------------------------------------------------------------
# # # Palette - default
# # # ------------------------------------------------------------------------------
# #
# # dfg_prompt_palette_blue_red() {
# #     dfg_style_time_bg="69"
# #     dfg_style_time_fg="7"
# #
# #     dfg_style_user_bg="27"
# #     dfg_style_user_fg="7"
# #
# #     dfg_style_dir_bg="69"
# #     dfg_style_dir_fg="226"
# #
# #     dfg_style_git_bg="52"
# #     dfg_style_git_fg="202"
# #
# #     dfg_style_prompt_bg=""
# #     dfg_style_prompt_fg="75"
# # }
# #
# # dfg_prompt_palette_desert() {
# #     dfg_style_time_bg="94"
# #     dfg_style_time_fg="7"
# #
# #     dfg_style_user_bg="59"
# #     dfg_style_user_fg="226"
# #
# #     dfg_style_dir_bg="94"
# #     dfg_style_dir_fg="226"
# #
# #     dfg_style_git_bg="136"
# #     dfg_style_git_fg="0"
# #
# #     dfg_style_prompt_bg=""
# #     dfg_style_prompt_fg="202"
# # }


