BUILD_ROOT ?= build
CMD_OUTPUT ?= $(BUILD_ROOT)/cmd
COMPLETION_OUTPUT ?= $(BUILD_ROOT)/completion
MKDIR = mkdir -p
TEMPLATE_DIR = templates
SOURCES = $(shell find templates -type f -name *.m4 -exec basename {} \;)
COMMAND_SOURCES = $(SOURCES:%.m4=$(CMD_OUTPUT)/%.sh)
COMP_SOURCES = $(SOURCES:%.m4=$(COMPLETION_OUTPUT)/%.sh)
BINS = $(SOURCES:%.m4=$(INSTALL_PREFIX)/bin/%)
COMPS = $(SOURCES:%.m4=$(INSTALL_PREFIX)/etc/bash_completion.d/%.sh)

INSTALL_PREFIX ?= /usr/local

.PHONY: all
all: commands completions

.PHONY: commands
commands: $(COMMAND_SOURCES)

.PHONY: completions
completions: $(COMP_SOURCES)

.PHONY: install
install: all $(BINS) $(COMPS)

$(CMD_OUTPUT):
	@$(MKDIR) $(CMD_OUTPUT)

$(COMPLETION_OUTPUT):
	@$(MKDIR) $(COMPLETION_OUTPUT)

$(CMD_OUTPUT)/%.sh: $(CMD_OUTPUT)
	@echo "Building: $@"
	@argbash "$(TEMPLATE_DIR)/$(notdir $(@:.sh=.m4))" -o "$@"

$(COMPLETION_OUTPUT)/%.sh: $(COMPLETION_OUTPUT)
	@echo "Building: $@"
	@argbash --type completion "$(TEMPLATE_DIR)/$(notdir $(@:.sh=.m4))" -o "$@"

$(INSTALL_PREFIX)/bin/%:
	@echo "Creating symlink for $@"
	@ln -f -s $(shell pwd)/$(CMD_OUTPUT)/$(notdir $@).sh $@

$(INSTALL_PREFIX)/etc/bash_completion.d/%.sh:
	@echo "Creating symlink for $@"
	@ln -f -s $(shell pwd)/$(COMPLETION_OUTPUT)/$(notdir $@) $@

.PHONY: clean
clean:
	@rm -rf $(BUILD_ROOT)
