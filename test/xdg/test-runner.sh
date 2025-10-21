
case "${1}" in
    changes-dotfiles)
        # nvim-base
        mkdir -p .cache/nvim-main/1
        mkdir -p .local/share/nvim-main/2
        mkdir -p .local/state/nvim-main/3
        ;;
    changes-other)
        # some unknown app using XDG (dotfiles should leave that after uninstall
        mkdir -p .cache/another/1" "
        mkdir -p .config/another/2
        mkdir -p .local/share/another/3
        mkdir -p .local/state/another/4
        ;;
esac
