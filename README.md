# Dotfiles

Personal collection of configuration files and scripts to automate and standardise my development environment.
This repo primarily covers Vim/Neovim, tmux, rebar3 templates, shell environment customisations, and utility scripts.

## Table of Contents

1. [Inspiration](#inspiration)
2. [Installation](#installation)
3. [Uninstallation](#uniinstallation)
3. [Usage](#usage)

## Inspiration

After tinkering with my [old solution](https://github.com/sokhouw/dotfiles.old)
I have come to the conclusion that it was bloated, over-engineered, fragile and hardly maintainable.

So I started looking for an existing solution and came across [Dotfiles: Best way to store in a bare git repository](https://www.atlassian.com/git/tutorials/dotfiles).
This was apparently inspired by a [Hacker News thread](https://news.ycombinator.com/item?id=11070797)

That was exactly what I needed.

## Installation

```shell
git clone --bare https://github.com/sokhouw/dotfiles/ $HOME/.dotfiles
echo 'alias dfg="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"' >> $HOME/.bashrc
source $HOME/.bashrc
dfg reset
for f in $(dfg diff --name-status --no-color --no-renames main | grep --colour=never "^M" | sed "s/\s\+/:/" | cut -c3-); do
    [ ! -d "$HOME/.dotfiles/backup/$(dirname $f)" ] && mkdir -p "$HOME/.dotfiles/backup/$(dirname $f)" 
    mv $HOME/$f $HOME/.dotfiles/backup/$f
done
dfg checkout .
echo "*" > $HOME/.gitignore
rm $HOME/README.md
```

## Uninstallation

```shell
dfg ls-files | xargs rm -f
dfg ls-tree --name-only -d -r main | sort -r | xargs -I{} rmdir {} 2>/dev/null
for f in $(find $HOME/.dotfiles/backup -type f 2>/dev/null); do 
    t=$(realpath -s --relative-to="$HOME/.dotfiles/backup" $f)
    [ ! -d "$HOME/$(dirname $t)" ] && mkdir -p "$HOME/$(dirname $t)"
    mv $f $HOME/$t
done
rm -rf $HOME/.dotfiles
rm $HOME/.gitignore
sed -i "/^alias dfg=/d" $HOME/.bashrc
unalias dfg
```

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

