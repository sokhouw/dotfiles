# Dotfiles

Personal collection of configuration files and scripts to automate and standardise my development environment.
This repo primarily covers Vim/Neovim, tmux, rebar3 templates, shell environment customisations, and utility scripts.

## Table of Contents

1. [Inspiration](#inspiration)
2. [Install](#install)
3. [Adapt](#adapt)
5. [Use](#use)
6. [Contribute](#contribute)
4. [Uninstall](#uninstall)

## Inspiration

Maintaining dotfiles that can be shared between many machines is not an easy task.
After tinkering with my old solution I have come to the conclusion that it was bloated, over-engineered, fragile and hardly maintainable.

So I started looking for an existing solution and came across [Dotfiles: Best way to store in a bare git repository](https://www.atlassian.com/git/tutorials/dotfiles).
This was apparently inspired by a [Hacker News thread](https://news.ycombinator.com/item?id=11070797)

That was exactly what I needed. Dotfiles stored in git bare repo.

## Install

### Full install 

Copy and run script below. 

```shell
DOTFILES_DIR="${HOME}/.local/share/dotfiles"
REPO_DIR="${DOTFILES_DIR}/repo"
BACKUP_DIR="${DOTFILES_DIR}/backup"
mkdir -p ${REPO_DIR}
git clone --bare -b main https://github.com/sokhouw/dotfiles/ ${REPO_DIR}
echo ". ~/.config/bash/include" >> $HOME/.bashrc
source ${HOME}/.bashrc
dfg reset
for f in $(dfg diff --name-status --no-color --no-renames main | grep --colour=never "^M" | sed "s/\s\+/:/" | cut -c3-); do
    [ ! -d "${BACKUP_DIR}/$(dirname ${f})" ] && mkdir -p "${BACKUP_DIR}/$(dirname ${f})" 
    mv $HOME/$f ${BACKUP_DIR}/${f}
done
dfg checkout .
echo "*" > $HOME/.gitignore # investigate how that impacts other repos in home dir
```

In case only parts of the repo are needed, it is possible to checkout only some files.

Below sample if all is needed is NeoVim config

```shell
dfg checkout .config/nvim 
```

### in a nutshell

1. Clones bare sokhouw/dotfiles repo
2. Add bash includes to ~/.bashrc
3. Backup conflicting files
4. Checkout dotfiles (creates dotfiles in $HOME)
5. Have "\*" in .gitignore so that each new dotfile has to be added forcibly (-f git flag)

## Adapt

See [lua/lsp.lua] and follow instructions to manually setup some LSP. Mason is not ideal for Erlang.
Any LSP that is not handled by Mason will need to be installed manually.

### In a nutshell

1. Remove all dotfiles 
2. Remove all empty dotfiles dirs
3. Resore backed up files
4. Remove .dotfiles and .gitignore
5. Restore .bashrc

## Use

dfg alias can be used as git command.
It just adds location of the repo (--git-dir=$HOME/.dotfiles/repo) and "target dir" (--work-tree=$HOME").

### Add files

```shell
dfg add -f <PATH_TO_FILE>
dfg commit -m <COMMIT_MSG>
dfg push
```

argument -f is really needed when adding new files becuase .gitignore contains "*"

### Show untracked files in current dir

```shell
dfg ls-files --others | tree --fromfile
```

### Show all dotfiles in current dir

```shell
dfg ls-files | tree --fromfile
```

## Contribute

### Branches

Default branch is main. To keep other branches up-to-date with main use rebase.

In case branch \<BRANCH\_NAME\> needs a rebase:

```shell
dfg checkout main
dfg pull
dfg checkout -
dfg pull --rebase origin main
dfg push origin <BRANCH_NAME> -f
```

## Uninstall

Copy and run script below.

```shell
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
sed -i "/^alias dfg=/d" $HOME/.bashrc
grep "^alias" ~/.config/bash/include.d/aliases | sed "s/^alias\s\+//" | cut -f1 -d= | xargs unalias
```
