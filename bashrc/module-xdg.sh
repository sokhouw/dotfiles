# shellcheck shell=sh

# some apps (e.g. git) will only use XDG if env variables are explicitly set
if [ -z "${XDG_CONFIG_HOME}" ]; then export XDG_CONFIG_HOME="${HOME}/.config"; fi
if [ -z "${XDG_DATA_HOME}" ]; then export XDG_DATA_HOME="${HOME}/.local/share"; fi
if [ -z "${XDG_STATE_HOME}" ]; then export XDG_STATE_HOME="${HOME}/.local/state"; fi
