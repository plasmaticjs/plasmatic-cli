SHELL := /bin/bash
BIN = ./node_modules/.bin

JS_SOURCE = $(shell find lib/ -type f -name '*.js')
JS_BUILD = $(JS_SOURCE:lib/%.js=bin/%.js)

CONFIGS_SOURCE = $(shell find lib/ -type f -name '.*' -not -name '*.js' -not -name '.' -not -name '..')
CONFIGS_BUILD = $(CONFIGS_SOURCE:lib/%=bin/%)

BLUEPRINTS_SOURCE = $(shell find lib/ -type f -name '*.ejs')
BLUEPRINTS_BUILD = $(BLUEPRINTS_SOURCE:lib/%=bin/%)

DEST = bin

default: build

clean:
	@printf "\n\033[36mCleaning build ...\033[0m \n\n"
	@rm -rf $(JS_BUILD) $(CONFIGS_BUILD) $(BLUEPRINTS_BUILD)

bin/%.js: lib/%.js
	@mkdir -p $(@D)
	@$(BIN)/babel $< > $@
	@chmod 755 $@
	@printf "Compiling \t\033[35m$(patsubst bin//%, %, $@)\033[0m \n"

$(CONFIGS_BUILD): $(CONFIGS_SOURCE)
	@printf "Copy config \t\033[36m$(patsubst bin//%, %, $@)\033[0m \n"
	@mkdir -p $(@D)
	@cp "$<" "$@"

$(BLUEPRINTS_BUILD): $(BLUEPRINTS_SOURCE)
	@printf "Copy blueprint \t\033[36m$(patsubst bin//%, %, $@)\033[0m \n"
	@mkdir -p $(@D)
	@cp "$<" "$@"

build: clean $(JS_BUILD) $(CONFIGS_BUILD) $(BLUEPRINTS_BUILD)
	@printf "\n\033[33mLibrary succesfully installed\033[0m \n\n"

.PHONY: clean
