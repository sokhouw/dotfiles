install:
	@scripts/cmd-install.sh

uninstall:
	@scripts/cmd-uninstall.sh

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

test-install: $(addprefix test-install-,$(notdir $(wildcard test/*)))

test-install-%:
	@scripts/cmd-install.sh $*
	@scripts/cmd-install-verify.sh $*
	@scripts/cmd-uninstall.sh $*
	@scripts/cmd-uninstall-verify.sh $*


test-shellcheck:
	shellcheck scripts/*
	shellcheck bin/*
	shellcheck config/shell/bash/*

clean:
	rm -rf _build
