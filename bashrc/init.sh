# shellcheck shell=sh source=/dev/null

SCRIPT_PATH="${1}"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
SCRIPT_NAME="$(basename "${SCRIPT_PATH}")"

for f in "${SCRIPT_DIR}"/module-*; do
    . "${f}"
done
