#!/bin/sh

backup_move "${HOME_DIR}/.tmux.conf"
action "Soft-linking .tmux.conf" \
       "ln -s \"${CONFIG_HOME}/${PLUGIN}/tmux.conf\" ${HOME_DIR}/.tmux.conf" \
       "rm ${HOME_DIR}/.tmux.conf" 

backup_move "${HOME_DIR}/.tmux"
action "Soft-linking .tmux" \
       "ln -s \"${DATA_HOME}/${PLUGIN}/\" ${HOME_DIR}/.tmux" \
       "rm ${HOME_DIR}/.tmux" 
