dfg ls-files | xargs rm -f
if [ -d $HOME/.dotfiles/backup ]; then
    for f in $(find $HOME/.dotfiles-backup -mindepth 1); do 
        mv $f $HOME/$(realpath -s --relative-to="$HOME/.dotfiles/backup" $f)
    done
    rmdir $HOME/.dotfiles/backup
fi
