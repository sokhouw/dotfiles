#!/bin/sh

backup_move "${HOME_DIR}/.vimrc"
action "Soft-linking .vimrc" \
       "ln -s \"${CONFIG_HOME}/${PLUGIN}/vimrc\" ${HOME_DIR}/.vimrc" \
       "rm ${HOME_DIR}/.vimrc" 
