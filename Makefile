install:
	@scripts/install.sh

uninstall:
	@scripts/uninstall.sh

check:
	@scripts/check.sh

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

test: test-shellcheck

test-shellcheck:
	shellcheck scripts/*
	shellcheck bin/*
	shellcheck config/shell/bash/*
