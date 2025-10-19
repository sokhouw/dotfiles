# shellcheck shell=sh source=/dev/null

#TEST_ONLY=1
ROOT="$(pwd)" # TODO is that good enough? safe?

# ------------------------------------------------------------------------------
# colors
# ------------------------------------------------------------------------------

RED=$(printf '\033[1;31m')
GREEN=$(printf '\033[1;32m')
BLUE=$(printf '\033[1;34m')
YELLOW=$(printf '\033[1;33m')
# GREY=$(printf '\033[1;30m')
RESET=$(printf '\033[0;m')

# ------------------------------------------------------------------------------
# Utils
# ------------------------------------------------------------------------------

timestamp() {
    date +'%Y%m%d_%H%M%S'
}

execute() {
    location="${1}" && shift
    if result=$(eval "$*") 2>&1; then
        printf '%s %sOK%s\n' "$*" "${GREEN}" "${RESET}"
    else
        printf '%s %s%s%s\n' "$*" "${RED}" "${result}" "${RESET}"
        exit 1
    fi
}

# ------------------------------------------------------------------------------
# printing messages
# ------------------------------------------------------------------------------

msg_error() {
    printf '%s[ERROR] (%s) %s %s\n' "${RED}" "${1}" "${2}" "${RESET}"
}

msg_warn() {
    printf '%s[WARN]%s %s\n' "${YELLOW}" "${RESET}" "${1}"
}

msg_info() {
    printf '%s[INFO]%s %s\n' "${BLUE}" "${RESET}" "${1}"
}

msg_debug() {
    if [ ! -z "${DEBUG}" ]; then
        printf '%s[DEBUG] (%s) %s%s\n' "${YELLOW}" "${1}" "${RESET}" "${2}"
    fi
}

# ------------------------------------------------------------------------------
# command line
# ------------------------------------------------------------------------------

parse_cmdline() {
    # pre-set DEBUG
    if echo "$@" | tr ' ' '\n' | grep "\-\-debug" >/dev/null; then DEBUG=1; fi
    msg_debug "lib_dotfiles:parse_cmdline" "cmdline='$*'"

    COMMAND="$(basename "${0}" ".sh" | cut -f2- -d-)"
    TASK="${1}"
    shift 1

    PROFILE="default"
    ALL_PLUGINS=
    PLUGIN=
    TEST=
    DRY_RUN=

    msg_debug "lib_dotfiles:parse_cmdline" "COMMAND='${COMMAND}'"
    msg_debug "lib_dotfiles:parse_cmdline" "TASK='${TASK}'"

    while [ ! -z "${1}" ]; do
        case "${1}" in
            --plugin)
                PLUGIN="${2}"
                if [ ! -d "${ROOT}/plugins/${PLUGIN}" ]; then
                    msg_error "lib_dotfiles:parse_cmdline" "Bad plugin: '${PLUGIN}'"
                fi
                shift 2
                ;;
            --plugins)
                ALL_PLUGINS="${2}"
                shift 2
                ;;
            --test)
                case "${2}" in
                    --*)
                        PROFILE="test"
                        TEST=""
                        shift 1
                        ;;
                    *)
                        if [ -z "${2}" ]; then
                            PROFILE="test"
                            TEST=""
                            shift 1
                        else
                            PROFILE="test"
                            TEST="${2}"
                            shift 2
                        fi
                        ;;
                esac
                if [ ! -z "${TEST}" ] && [ ! -d "${ROOT}/test/app/${TEST}" ]; then
                    msg_error "lib_dotfiles:parse_cmdline" "Bad test: '${TEST}'"
                fi
                ;;
            --dry-run)
                DRY_RUN=1
                shift
                ;;
            --debug)
                DEBUG=1
                shift 1
                ;;
            *)
                msg_error "lib-dotfiles:parse_cmdline" "Bad argument: '${1}'"
                exit 1
                ;;
        esac
    done

    if [ -z "${COMMAND}" ]; then
        msg_error "lib-dotfiles:parse_cmdline" "Misssing command"
        exit 1
    fi

    if [ -z "${TASK}" ]; then
        msg_error "lib-dotfiles:parse_cmdline" "Misssing task"
        exit 1
    fi
}

# ------------------------------------------------------------------------------
# initialization
# ------------------------------------------------------------------------------

init_dirs() {
    # TODO accept parapeter that can specify target home dir
    case "${PROFILE}" in
        default)
            HOME_DIR="${HOME}"
            ;;
        test)
            HOME_DIR="${ROOT}/_build/test/app/${TEST}"
            ;;
    esac
    if [ ! -z "${PLUGIN}" ]; then
        PLUGIN_DIR="${ROOT}/plugins/${PLUGIN}"
    fi
}

init_variables() {
    if [ -z "${XDG_BIN_HOME}" ] || [ "${PROFILE}" = "test" ]; then
        BIN_HOME="${HOME_DIR}/.local/bin"
    else
        BIN_HOME="${XDG_BIN_HOME}"
    fi
    if [ -z "${XDG_CONFIG_HOME}" ] || [ "${PROFILE}" = "test" ]; then
        CONFIG_HOME="${HOME_DIR}/.config"
    else
        CONFIG_HOME="${XDG_CONFIG_HOME}"
    fi
    if [ -z "${XDG_DATA_HOME}" ] || [ "${PROFILE}" = "test" ]; then
        DATA_HOME="${HOME_DIR}/.local/share"
    else
        DATA_HOME="${XDG_DATA_HOME}"
    fi
    if [ -z "${XDG_STATE_HOME}" ] || [ "${PROFILE}" = "test" ]; then
        STATE_HOME="${HOME_DIR}/.local/state"
    else
        STATE_HOME="${XDG_STATE_HOME}"
    fi
    if [ -z "${XDG_CACHE_HOME}" ] || [ "${PROFILE}" = "test" ]; then
        CACHE_HOME="${HOME_DIR}/.cache"
    else
        CACHE_HOME="${XDG_CACHE_HOME}"
    fi
    JOURNAL_FILE="${ROOT}/_build/${PROFILE}/journal"
    UNINSTALL_FILE="${CONFIG_HOME}/dotfiles/uninstall.sh"
    PROFILE_FILE="${HOME_DIR}/.bash_profile"
    export HOME_DIR
    export BIN_HOME CONFIG_HOME DATA_HOME STATE_HOME CACHE_HOME
    export JOURNAL_FILE UNINSTALL_FILE PROFILE_FILE
    export PLUGIN_DIR
    export PLUGIN ALL_PLUGINS
    export DRY_RUN
}

init() {
    parse_cmdline "$@"
    init_dirs
    init_variables
}
