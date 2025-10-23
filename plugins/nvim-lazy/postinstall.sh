# shellcheck shell=sh

set -e

git clone https://github.com/LazyVim/starter ${CONFIG_HOME}/${PLUGIN}/starter

for f in lua init.lua; do
    mv ${CONFIG_HOME}/${PLUGIN}/starter/${f} ${CONFIG_HOME}/${PLUGIN}
done

rm -rf ${CONFIG_HOME}/${PLUGIN}/starter
