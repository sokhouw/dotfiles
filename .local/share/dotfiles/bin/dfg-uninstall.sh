DOTFILES_DIR=${HOME}/.local/share/dotfiles
BACKUP_DIR=${DOTFILES_DIR}/backup
dfg ls-files | xargs rm -f
dfg ls-tree --name-only -d -r main | sort -r | xargs -I{} rmdir {} 2>/dev/null
for f in $(find ${BACKUP_DIR} -type f 2>/dev/null); do 
    t=$(realpath -s --relative-to="$DOTFILES_DIR/backup" $f)
    [ ! -d "${HOME}/$(dirname ${t})" ] && mkdir -p "${HOME}/$(dirname ${t})"
    mv $f ${HOME}/${t}
done
rm -rf ${DOTFILES_DIR}
rm ${HOME}/.gitignore
# grep "^alias" ~/.config/bash/include.d/aliases | sed "s/^alias\s\+//" | cut -f1 -d= | xargs unalias
