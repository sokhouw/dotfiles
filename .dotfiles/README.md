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

```shell
git clone --bare https://github.com/sokhouw/dotfiles/ $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout .dotfiles/install.sh
source ./dotfiles/install.sh
```

## De-Installation

```shell
./dotfiles/uninstall.sh
```

## Usage
