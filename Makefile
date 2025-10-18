RED := \033[1;31m
RESET := \033[0;m

ifndef plugins
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

test: test-install test-changes test-uninstall

test-install: $(addprefix test-install-,$(app_tests))

test-changes: $(addprefix test-changes-,$(app_tests))

test-uninstall: $(addprefix test-uninstall-,$(app_tests))

test-install-%: 
	mkdir -p _build/test/app/
	cp -a test/app/$*/. _build/test/app/$*
	$(MAKE) install debug=$(debug) dryrun=$(dryrun) test="$*"

test-changes-%:
	for plugin in $(all_plugins); do \
	    if [ ! -d "_build/test/app/$*/.local/share/$${plugin}" ]; then \
	        mkdir -p "_build/test/app/$*/.local/share/$${plugin}"; \
	    fi; \
	    if [ ! -d "_build/test/app/$*/.local/state/$${plugin}" ]; then \
	        mkdir -p "_build/test/app/$*/.local/state/$${plugin}"; \
	    fi \
	done
	
test-uninstall-%:
	$(MAKE) uninstall debug=$(debug) dryrun=$(dryrun) test="$*"
	@printf "$(RED)"; if ! diff -qr test/app/$* _build/test/app/$*; then printf "$(RESET)"; exit 1; fi; printf "$(RESET)"

# ------------------------------------------------------------------------------
#  developer land
# ------------------------------------------------------------------------------

clean:
	rm -rf _build
