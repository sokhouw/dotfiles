DOTFILES_DIR="${HOME}/.local/share/dotfiles"
REPO_DIR="${DOTFILES_DIR}/repo"
BACKUP_DIR="${DOTFILES_DIR}/backup"
git clone --bare -b main https://github.com/sokhouw/dotfiles/ ${REPO_DIR}
for f in $(git --git-dir ${REPO_DIR} --work-tree=${HOME} diff --name-only --no-color --no-renames main); do 
    if [ -f "${f}" ]; then
        echo "Backing up ${f}"
        [ ! -d "${BACKUP_DIR}/$(dirname ${f})" ] && mkdir -p "${BACKUP_DIR}/$(dirname ${f})" 
        mv $HOME/$f ${BACKUP_DIR}/${f}
    fi; 
done
git --git-dir ${REPO_DIR} --work-tree=${HOME} reset
git --git-dir ${REPO_DIR} --work-tree=${HOME} checkout .
echo ". ~/.config/bash/main.sh" >> $HOME/.bashrc
source ${HOME}/.bashrc
