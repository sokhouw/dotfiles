# Dotfiles

Personal collection of configuration files and scripts to automate and standardise my development environment.
This repo primarily covers Vim/Neovim, tmux, rebar3 templates, shell environment customisations, and utility scripts.

## Table of Contents

1. [Inspiration](#inspiration)
2. [Installation](#installation)
3. [De-Installation](#de-installation)
3. [Usage](#usage)

## Inspiration

After tinkering with my [old solution](https://github.com/sokhouw/dotfiles.old)
I have come to the conclusion that it was bloated, over-engineered, fragile and hardly maintainable.

So I started looking for an existing solution and came across [Dotfiles: Best way to store in a bare git repository](https://www.atlassian.com/git/tutorials/dotfiles).
This was apparently inspired by a [Hacker News thread](https://news.ycombinator.com/item?id=11070797)

That was exactly what I needed.

## Installation

### Clone bare repo

```shell
git clone --bare https://github.com/sokhouw/dotfiles/ $HOME/.dotfiles
```

### Modify ~/.bashrc

```shell
cat >> $HOME/.bashrc <<- "EOF"
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias dfg=dotfiles
alias dfg-tree="dfg ls-files | tree --fromfile ."
alias dfg-other="dfg ls-files --other"
EOF
source $HOME/.bashrc
echo "*" > $HOME/.gitignore
```

### Start tracking files in $HOME dir

```shell
dfg checkout
```

Step above might fail woth a message like that:

```shell
error: The following untracked working tree files would be overwritten by checkout:
        .vimrc
Please move or remove them before you switch branches.
Aborting
```

In such case create backup of these files:

```shell
for f in $(dfg checkout 2>&1 | grep -E "^\s" | sed "s/\s\+//"); do 
    [ ! -d "$HOME/.dotfiles-backup/$(dirname $f)" ] && mkdir -p "$HOME/.dotfiles-backup/$(dirname $f)" 
    mv $HOME/$f $HOME/.dotfiles-backup/$f
done
```

and run `dfg checkout` command again.

## De-Installation

### Remove all tracked files

```shell
dfg ls-files | xargs rm -f
```

### Bring back backup dotfiles

```
for f in $(find $HOME/.dotfiles-backup -mindepth 1); do 
    mv $f $HOME/$(realpath -s --relative-to="$HOME/.dotfiles-backup" $f); 
done;
```

## Usage
