# ------------------------------------------------------------------------------
#  user land
# ------------------------------------------------------------------------------

install:
	@scripts/cmd-install.sh

uninstall:
	@scripts/cmd-uninstall.sh

is-installed:
	@scripts/cmd-is-installed.sh

# ------------------------------------------------------------------------------
#  developer land
# ------------------------------------------------------------------------------

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

test: -test-prep $(addprefix test-,$(notdir $(wildcard test/*))) -test-report

-test-prep:
	rm -f _build/test/report
	touch _build/test/report

-test-report:
	@echo "Results: pass($$(grep PASS _build/test/report | wc -l)) fail($$(grep FAIL _build/test/report | wc -l))"
	@cat _build/test/report
	@rm _build/test/report

test-%: 
	@scripts/cmd-install.sh $*
	@scripts/cmd-install-verify.sh $*
	@scripts/cmd-uninstall.sh $*
	@scripts/cmd-uninstall-verify.sh $*

test-install-%:
	@scripts/cmd-install.sh $*
	@scripts/cmd-install-verify.sh $*

test-uninstall-%:
	@scripts/cmd-uninstall.sh $*
	@scripts/cmd-uninstall-verify.sh $*

shellcheck:
	shellcheck scripts/*
	shellcheck bin/*
	shellcheck config/shell/bash/*

clean:
	rm -rf _build
