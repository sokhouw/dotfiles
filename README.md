# Dotfiles

Personal collection of configuration files and scripts to automate and standardise my development environment. This repo primarily covers Vim/Neovim, shell environment customisations, and utility scripts.

---

## Table of Contents

1. [Features](#features)  
2. [Dependencies](#dependencies) 
3. [File Structure](#file-structure)
3. [Installation](#installation)  
4. [Uninstallation](#uninstallation)  
5. [Getting Started](#getting-started)  
6. [Licence](#licence)

---

## Features

* git config
* [neovim](https://github.com/neovim/neovim) config (0.11+ compatible)
  * LSP
    * [erlang](https://github.com/WhatsApp/erlang-language-platform)
    * [lua](https://github.com/LuaLS/lua-language-server)
  * [lazy.nvim](https://github.com/folke/lazy.nvim)
  * plugins
    * [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
    * [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
    * [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
    * [nvim-notify](https://github.com/rcarriga/nvim-notify)
    * [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
    * [snacks.nvim](https://github.com/folke/snacks.nvim)
    * [themery.nvim](https://github.com/zaldih/themery.nvim)
    * [which-key.nvim](https://github.com/folke/which-key.nvim)
  * [tmux](https://github.com/tmux/tmux) config
    * [tpm](https://github.com/tmux-plugins/tpm)
    * [tmux-tokyo-night](https://github.com/fabioluciano/tmux-tokyo-night)
* [rebar3](https://github.com/erlang/rebar3) config with templates
* shell modules
  * [bash](https://www.gnu.org/software/bash)
    * man colors
    * neovim aliases
    * ~/bin path
    * XDG paths

## Dependencies

To enable full functionality (especially for Neovim LSP support), the following external tools are required:

* [elp (Erlang Language Platform)](https://github.com/WhatsApp/erlang-language-platform)
* [lua-language-server](https://github.com/LuaLS/lua-language-server)
* [rebar3](https://github.com/erlang/rebar3)

Additionally, **one of the Nerd Fonts** (e.g. *Hack Nerd Font*, *FiraCode Nerd Font*, *JetBrains Mono Nerd Font*, etc.) is required for proper rendering of icons, ligatures, and UI elements in the statusline, file explorer, etc.

Ensure those are installed and available in your `PATH` (or your system’s font registry for the Nerd Font).

## File Structure

```
dotfiles/
├── bin/ (goes into ~/bin)
│   └── colors
├── scripts/ (support scripts)
│    ├── check.sh 
│    ├── common.sh 
│    ├── install.sh 
│    └── uninstall.sh 
└── config/ (goes into ~/.config)
    ├── nvim-base/ 
    ├── nvim-main/
    ├── rebar3/
    ├── tmux/
    └── shell/ 
        └── bash/ (modules below are sourced from ~/.bashrc)
            ├── man-colors.sh
            ├── nvim-aliases.sh
            └── path.sh
```

## Installation

```bash
git clone https://github.com/sokhouw/dotfiles.git dotfiles
cd dotfiles
make install
```

**Note:** Review the scripts before running. Dotfiles does the best to back up any files that it replaces or modifies but to be 100% sure back up any existing configuration you wish to preserve.

Because the setup is XDG-compliant

* Configuration files live under ~/.config/…
* State, cache, or runtime files live under ~/.local/state/…
* Additional data (if any) under ~/.local/share/…

You may inspect the [scripts/install.sh](scripts/install.sh) to see exactly where each file or directory goes.

## Uninstallation

```bash
cd dotfiles
make uninstall
```

Uninstallation script is to be found at ~/.local/state/dotfiles/uninstall

## Contributing

Improvements, suggestions, and PRs are welcome! Open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [License](LICENSE.md) file for details.
