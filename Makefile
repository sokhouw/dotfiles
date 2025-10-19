RED := \033[1;31m
RESET := \033[0;m

ifndef plugin
	all_plugins := $(strip dotfiles $(sort $(filter-out dotfiles,$(notdir $(wildcard plugins/*)))))
else
coma := ,
	all_plugins := $(strip dotfiles $(filter-out dotfiles,$(subst $(coma), ,$(plugins))))
endif

ifdef test
	test_arg := --test $(test)
	app_tests := $(test)
else
	app_tests := $(sort $(notdir $(wildcard test/app/*)))
endif

ifeq "$(dryrun)" "1"
	dryrun_arg := --dry-run
endif

ifeq "$(debug)" "1"
	debug_arg := --debug
endif

all_args := $(test_arg) $(debug_arg) $(dryrun_arg)

# ------------------------------------------------------------------------------
#  user land - install
# ------------------------------------------------------------------------------

install: -install-prepare -install-plugins -install-commit

-install-prepare:
	scripts/make-app.sh prepare $(all_args) --plugins "$(all_plugins)"

-install-plugins: $(addprefix -install-plugin-,$(all_plugins)) -install-commit

-install-plugin-%:
	scripts/make-app.sh install-plugin $(all_args) --plugin $*

-install-commit:
	scripts/make-app.sh commit $(all_args)

# ------------------------------------------------------------------------------
#  user land - uninstall
# ------------------------------------------------------------------------------

uninstall:
	scripts/make-app.sh uninstall $(all_args)

# ------------------------------------------------------------------------------
#  developer land - shellcheck
# ------------------------------------------------------------------------------

shellcheck:
	@if shellcheck $$(grep -Rl "^# shellcheck" .); then echo "ok"; fi

shellcheck-%:
	@echo $*
	shellcheck $*

# ------------------------------------------------------------------------------
#  developer land - test-install
# ------------------------------------------------------------------------------

test: test-install test-uninstall test-verify

test-install: $(addprefix test-install-,$(app_tests))

test-uninstall: $(addprefix test-uninstall-,$(app_tests))

test-verify: $(addprefix test-verify-,$(app_tests))

test-install-%: 
	mkdir -p _build/test/app/
	cp -a test/app/$*/HOME/. _build/test/app/$*
	$(MAKE) install debug=$(debug) dryrun=$(dryrun) test="$*"
	@if [ -x "test/app/$*/test-runner.sh" ]; then \
	    ( cd _build/test/app/$* ; ../../../../test/app/$*/test-runner.sh after-install ); \
	fi

test-uninstall-%:
	$(MAKE) uninstall debug=$(debug) dryrun=$(dryrun) test="$*"

test-verify-%:
	@if [ -x "test/app/$*/test-runner.sh" ]; then \
	    ( cd _build/test/app/$* ; ../../../../test/app/$*/test-runner.sh before-verify ); \
	fi
	@printf "$(RED)"; if ! diff -qr test/app/$*/HOME _build/test/app/$*; then printf "$(RESET)"; exit 1; fi; printf "$(RESET)"

# ------------------------------------------------------------------------------
#  developer land
# ------------------------------------------------------------------------------

clean:
	rm -rf _build
