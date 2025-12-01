# Dotfiles

Personal collection of configuration files and scripts to automate and standardise my development environment.
This repo primarily covers Vim/Neovim, tmux, rebar3 templates, shell environment customisations, and utility scripts.

## Table of Contents

1. [Inspiration](#inspiration)
2. [Installation](#installation)
3. [Uninstallation](#uniinstallation)
4. [Usage](#usage)
5. [Contributing](#contributing)

## Inspiration

After tinkering with my [old solution](https://github.com/sokhouw/dotfiles.old)
I have come to the conclusion that it was bloated, over-engineered, fragile and hardly maintainable.

So I started looking for an existing solution and came across [Dotfiles: Best way to store in a bare git repository](https://www.atlassian.com/git/tutorials/dotfiles).
This was apparently inspired by a [Hacker News thread](https://news.ycombinator.com/item?id=11070797)

That was exactly what I needed.

## Installation

Copy and run script below. Update values of DOTFILES\_DIR and DOTFILES\_BRANCH when needed.

```shell
DOTFILES_DIR=$HOME/.dotfiles
DOTFILES_BRANCH=main
git clone --bare -b $BRANCH https://github.com/sokhouw/dotfiles/ $DOTFILES_DIR
echo "alias dfg=\"git --git-dir=$DOTFILES_DIR --work-tree=\$HOME\"" >> $HOME/.bashrc
source $HOME/.bashrc
dfg reset
for f in $(dfg diff --name-status --no-color --no-renames main | grep --colour=never "^M" | sed "s/\s\+/:/" | cut -c3-); do
    [ ! -d "$DOTFILES_DIR/backup/$(dirname $f)" ] && mkdir -p "$DOTFILES_DIR/backup/$(dirname $f)" 
    mv $HOME/$f $DOTFILES_DIR/backup/$f
done
dfg checkout .
echo "*" > $HOME/.gitignore
```

In case only parts of the repo are needed, it is possible to checkout only some files.

Below sample if all is needed is NeoVim config

```shell
dfg checkout .config/nvim 
```

### in a nutshell

1. Clones bare sokhouw/dotfiles repo
2. Sets up dfg alias to work with dotfiles
3. Backup conflicting files
4. Checkout dotfiles (creates dotfiles in $HOME)
5. Have "\*" in .gitignore so that each new dotfile has to be added forcibly (-f git flag)

## Uninstallation

Copy and run script below. Update values of DOTFILES\_DIR when needed.

```shell
DOTFILES_DIR=$HOME/.dotfiles
dfg ls-files | xargs rm -f
dfg ls-tree --name-only -d -r main | sort -r | xargs -I{} rmdir {} 2>/dev/null
for f in $(find $DOTFILES_DIR/backup -type f 2>/dev/null); do 
    t=$(realpath -s --relative-to="$DOTFILES_DIR/backup" $f)
    [ ! -d "$HOME/$(dirname $t)" ] && mkdir -p "$HOME/$(dirname $t)"
    mv $f $HOME/$t
done
rm -rf $DOTFILES_DIR
rm $HOME/.gitignore
sed -i "/^alias dfg=/d" $HOME/.bashrc
unalias dfg
```

### In a nutshell

1. Remove all dotfiles 
2. Remove all empty dotfiles dirs
3. Resore backed up files
4. Remove .dotfiles and .gitignore
5. Restore .bashrc
6. Remove dfg alias

## Usage

dfg alias can be used as git command.
It just adds location of the repo (--git-dir=$HOME/.dotfiles/repo) and "target dir" (--work-tree=$HOME").

### Adding files

```shell
dfg add -f <PATH_TO_FILE>
dfg commit -m <COMMIT_MSG>
dfg push
```

argument -f is really needed when adding new files becuase .gitignore contains "*"

### Showing untracked files in current dir

```shell
dfg ls-files --others | tree --fromfile
```

### Showing all dotfiles in current dir

```shell
dfg ls-files | tree --fromfile
```

## Contributing

### Working with branches

Default branch is main. To keep other branches up-to-date with main use rebase.

In case branch \<BRANCH\_NAME\> needs a rebae:

```shell
dfg checkout main
dfg pull
dfg checkout -
dfg pull --rebase origin main
dfg push origin <BRANCH_NAME> -f
```
