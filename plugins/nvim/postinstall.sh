# shellcheck shell=sh

set -e

install_tool "tree-sitter/tree-sitter" \
             "latest" \
             'tree-sitter-${OS}-${ARCH}.gz'

install_tool "sumneko/lua-language-server" \
             "3.15.0" \
             'lua-language-server-${TAG}-${OS}-${ARCH}.tar.gz' \
             '/bin/lua-language-server'

install_tool "WhatsApp/erlang-language-platform" \
             "2025-05-13" \
             'elp-${OS}-${BASEARCH}-unknown-linux-gnu-otp-25.3.tar.gz' \
             '/elp'
