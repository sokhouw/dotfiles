install:
	scripts/install.sh

uninstall:
	scripts/uninstall.sh

version:
	@git describe --tags --dirty --always 2>/dev/null || echo "unknown"

release:
	@if [ -z "$(version)" ]; then \
		echo "Missing version argument"; \
		exit 1; \
	fi
	@if [ ! -z "$$(git status --porcelain)" ]; then \
		echo "Not ready for release"; \
		git status --porcelain; \
		exit 1; \
	fi
	git tag -a v$(version) -m "version $(version)"

test: test-shellcheck-shell test-shellcheck-bin

test-shellcheck-shell: test-shellcheck-shell-bash

test-shellcheck-shell-bash:
	shellcheck config/shell/bash/*

test-shellcheck-bin:
	shellcheck bin/colors
	shellcheck bin/dotfiles
