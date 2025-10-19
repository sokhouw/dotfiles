
case "${1}" in
    after-install)
        # some changes that should be removed
        mkdir -p .cache/nvim-base
        mkdir -p .local/share/nvim-base
        mkdir -p .local/share/nvim-main
        mkdir -p .local/state/nvim-base
        mkdir -p .local/state/nvim-main

        # some other changes that should stay
        mkdir -p .cache/another
        mkdir -p .config/another
        mkdir -p .local/share/another
        mkdir -p .local/state/another
        ;;

    before-verify1)
        true
        ;;
esac
