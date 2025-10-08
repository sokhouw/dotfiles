checkhealth:
	bin/dotfiles checkhealth

install:
	bin/dotfiles install

uninstall:
	bin/dotfiles uninstall

test: test-shellcheck-bashrc test-shellcheck-bin

test-shellcheck-bashrc:
	shellcheck bashrc/*

test-shellcheck-bin:
	shellcheck bin/colors
	shellcheck bin/dotfiles
