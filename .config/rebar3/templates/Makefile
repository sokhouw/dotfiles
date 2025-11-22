REBAR = rebar3

all: compile

deps:
	$(REBAR) deps

compile:
	$(REBAR) compile

eunit:
	$(REBAR) eunit

ct:
	$(REBAR) ct

dialyzer: compile
	$(REBAR) dialyzer

xref:
	$(REBAR) xref

shell:
	$(REBAR) shell

# Temporary target to generate app and be removed
app ?= myapp
gen:
	$(REBAR) new rebar.config name=$(app)
	$(REBAR) new app.src name=$(app)
	$(REBAR) new application name=$(app)
	$(REBAR) new supervisor name=$(app)
	$(REBAR) new gen_server name=$(app)_server
	$(REBAR) new module name=$(app)
	$(REBAR) new eunit name=$(app)
	$(REBAR) new ct name=$(app)
