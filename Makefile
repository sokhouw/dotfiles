# ------------------------------------------------------------------------------
#  user land
# ------------------------------------------------------------------------------

install:
	scripts/cmd-install.sh

uninstall:
	scripts/cmd-uninstall.sh

is-installed:
	scripts/cmd-is-installed.sh

# ------------------------------------------------------------------------------
#  developer land
# ------------------------------------------------------------------------------

version:
	git describe --tags --dirty --always 2>/dev/null || echo "unknown"

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

# ------------------------------------------------------------------------------
#  developer land - shellcheck
# ------------------------------------------------------------------------------

shellcheck:
	shellcheck scripts/*
	shellcheck bin/*
	shellcheck config/shell/bash/*

# ------------------------------------------------------------------------------
#  developer land - testing
# ------------------------------------------------------------------------------

.PHONY: test
test: run-prep run-all-tests run-report 

test-%:
	$(MAKE) run-prep run-test-$* run-report

run-prep:
	@scripts/cmd-test.sh report-clean

run-all-tests: $(addprefix run-test-,$(notdir $(wildcard test/*)))

run-report:
	@scripts/cmd-test.sh report-show

# ------------------------------------------------------------------------------

run-test-%:
	@scripts/cmd-test.sh test-run $*

# ------------------------------------------------------------------------------
#  developer land
# ------------------------------------------------------------------------------

clean:
	rm -rf _build
