set -e

git clone https://github.com/LazyVim/starter "$HOME/.config/nvim-lazy/starter"

for f in lua init.lua; do
    mv "$HOME/.config/nvim-lazy/starter/$f" .config/nvim-lazy
done

rm -rf "$HOME/.config/nvim-lazy/starter"

echo "alias nvim-lazy='NVIM_APPNAME=nvim-lazy nvim'" >> "$HOME/.bashrc"
