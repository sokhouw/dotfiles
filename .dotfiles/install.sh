cat >> $HOME/.bashrc <<- "EOF"
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME" # sokhouw/dotfiles
alias dfg=dotfiles                                               # sokhouw/dotfiles
alias dfg-tree="dfg ls-files | tree --fromfile ."                # sokhouw/dotfiles
alias dfg-other="dfg ls-files --other"                           # sokhouw/dotfiles
EOF
source $HOME/.bashrc
if ! dfg checkout; then
    for f in $(dfg checkout 2>&1 | grep -E "^\s" | sed "s/\s\+//"); do 
        [ ! -d "$HOME/.dotfiles-backup/$(dirname $f)" ] && mkdir -p "$HOME/.dotfiles-backup/$(dirname $f)" 
        mv $HOME/$f $HOME/.dotfiles-backup/$f
    done
    dfg checkout
fi
