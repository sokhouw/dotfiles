# ------------------------------------------------------------------------------
#  arguments
# ------------------------------------------------------------------------------

ifndef plugins
all_plugins := $(notdir $(wildcard plugins/*))
else
coma := ,
all_plugins := $(subst $(coma), ,$(plugins))
endif

args := --plugins "$(all_plugins)"

ifdef plugin
args += --plugin "$(plugin)"
endif

ifdef home
args += --home "$(home)"
endif

DOTFILES_DIR := $(CURDIR)
DOTFILES := ./dotfiles.sh

# ------------------------------------------------------------------------------
#  user land - install/unnstall/clean
# ------------------------------------------------------------------------------

install: 
	$(DOTFILES) install $(args)

uninstall:
	$(DOTFILES) uninstall $(args)

# ------------------------------------------------------------------------------
#  dev land - tests
# ------------------------------------------------------------------------------

RED := \033[1;31m
GREEN := \033[1;32m
BLUE := \033[1;34m
RESET := \033[0;m

.SECONDEXPANSION:

test-%: test-%-prep test-%-install test-%-usage test-%-uninstall test-%-verify
	@true

test-%-prep: 
	@printf '$(BLUE)==> TEST $*/prep$(RESET)\n'
	rm -rf _build/test/$*
	mkdir -p _build/test/$*/HOME
	cp -a test/$*/HOME/. _build/test/$*/HOME

test-%-install: test-%-prep
	@printf '$(BLUE)==> TEST $*/install$(RESET)\n'
	$(DOTFILES) install $(args) --home "_build/test/$*/HOME"

test-%-usage:
	@if [ -x "test/$*/test-runner.sh" ]; then \
	    printf '$(BLUE)==> TEST $*/usage$(RESET)\n'; \
	    ( cd _build/test/$*/HOME ; $(DOTFILES_DIR)/test/$*/test-runner.sh changes-dotfiles ); \
 	fi

test-%-uninstall:
	@printf '$(BLUE)==> TEST $*/uninstall$(RESET)\n'
	$(DOTFILES) uninstall $(args) --home "_build/test/$*/HOME"

test-%-verify:
	@printf '$(BLUE)==> TEST $*/verify$(RESET)\n'
	@if diff -qr test/$*/HOME _build/test/$*/HOME; then \
	    touch _build/test/$*/result.pass; \
	    printf '$(BLUE)==> TEST $*: $(GREEN)PASS$(RESET)\n'; \
	else \
	    touch _build/test/$*/result.fail; \
	    printf '$(BLUE)==> TEST $*: $(RED)FAIL$(RESET)\n'; \
	fi

test: $(addprefix test-,$(notdir $(wildcard test/*))) report

report-header:
	@printf '$(BLUE)==> TEST REPORT$(RESET)\n'

report: report-header $(addprefix report-,$(notdir $(wildcard test/*)))

report-%:
	@if [ -f "_build/test/$*/result.pass" ]; then \
	    printf 'test $*: $(GREEN)PASS$(RESET)\n'; \
	else \
	    printf 'test $*: $(RED)FAIL$(RESET)\n'; \
	fi

clean:
	rm -rf _build

# ------------------------------------------------------------------------------
#  developer land - shellcheck
# ------------------------------------------------------------------------------

shellcheck:
	shellcheck dotfiles.sh $(shell find -name "*.sh")
