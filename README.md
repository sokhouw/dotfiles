# dotfiles

Personal collection of configuration files and scripts to automate and standardise my development environment. This repo primarily covers Vim/Neovim, shell environment customisations, and utility scripts.

## Table of Contents

- [Features](#features)
- [File Structure](#file-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Customisation](#customisation)
- [Contributing](#contributing)
- [License](#license)

## Features

- Modular Bash customisations (aliases, color schemes, path management, Neovim helpers)
- Neovim and tmux configuration scaffolding
- Utility scripts for environment setup and color previews
- Easy install/uninstall via one command

## File Structure

```
dotfiles/
├── bashrc/
│   ├── bashrc.sh
│   ├── man-colors.sh
│   ├── nvim-aliases.sh
│   └── path.sh
├── bin/
│   ├── colors
│   └── dotfiles
├── config/
│   ├── nvim-base/
│   ├── nvim-main/
│   ├── rebar3/
│   └── tmux/
```

- **bashrc/**: Bash configuration modules (e.g., color setup, Neovim aliases, PATH management)
- **bin/colors**: Script for color previews or terminal color configuration
- **bin/dotfiles**: Main management script for installing, updating, or uninstalling dotfiles
- **config/**: Subdirectories for various app configs (e.g. Neovim, tmux, rebar3)

## Installation

Clone the repository and run the install command:

```sh
git clone https://github.com/sokhouw/dotfiles.git
cd dotfiles
bin/dotfiles install
```

**Note:** Review the scripts before running, and back up any existing configuration you wish to preserve.

## Usage

- **Install/Update:**  
  Run `bin/dotfiles install` to set up or refresh symlinks and environment.
- **Uninstall:**  
  (If supported) Run `bin/dotfiles uninstall` to revert changes.

## Customization

- Modify files under `bashrc/` to tailor your shell experience.
- Add or change scripts in `bin/` for custom utilities.
- Place or edit app-specific config in `config/` subdirectories.
- Symlink only the components you want for a partial setup.

## Contributing

Improvements, suggestions, and PRs are welcome! Open an issue or submit a pull request.

## License

MIT License. See [LICENSE](LICENSE) for details.

---

**Enjoy your streamlined and portable developer setup!**
