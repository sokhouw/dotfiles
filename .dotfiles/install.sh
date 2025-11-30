echo 'alias dfg="git --git-dir=$HOME/.dotfiles/repo --work-tree=$HOME" # sokhouw/dotfiles' >> $HOME/.bashrc
source $HOME/.bashrc
if ! dfg checkout; then
    for f in $(dfg checkout 2>&1 | grep -E "^\s" | sed "s/\s\+//"); do 
        [ ! -d "$HOME/.dotfiles/backup/$(dirname $f)" ] && mkdir -p "$HOME/.dotfiles/backup/$(dirname $f)" 
        mv $HOME/$f $HOME/.dotfiles/backup/$f
    done
    dfg checkout
fi
