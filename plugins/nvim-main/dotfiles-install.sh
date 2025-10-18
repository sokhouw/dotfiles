# sellsheck shell=sh

action "creating soft-link 'after'" \
       "ln -s ../nvim-base/after \"${CONFIG_HOME}/${PLUGIN}/after\"" \
       "rm \"${CONFIG_HOME}/${PLUGIN}/after\""

action "creating soft-link 'lsp'" \
       "ln -s ../nvim-base/lsp \"${CONFIG_HOME}/${PLUGIN}/lsp\"" \
       "rm \"${CONFIG_HOME}/${PLUGIN}/lsp\""

action "creating soft-link 'lua/base'" \
       "ln -s ../../nvim-base/lua/base \"${CONFIG_HOME}/${PLUGIN}/lua/base\"" \
       "rm \"${CONFIG_HOME}/${PLUGIN}/lua/base\""
