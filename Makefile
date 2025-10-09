checkhealth:
	bin/dotfiles checkhealth

install:
	bin/dotfiles install

uninstall:
	bin/dotfiles uninstall

test: test-shellcheck-shell test-shellcheck-bin

test-shellcheck-shell: test-shellcheck-shell-bash

test-shellcheck-shell-bash:
	shellcheck config/shell/bash/*

test-shellcheck-bin:
	shellcheck bin/colors
	shellcheck bin/dotfiles
