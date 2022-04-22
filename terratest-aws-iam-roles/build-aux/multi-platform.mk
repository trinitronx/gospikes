# Define all OS + Platform build targets and vars

# OS-specific target patterns
# $(1) will evaluate to a target OS pattern string
define OS_TARGET_template
debug-mk::
	@echo "INSIDE: OS_TARGET_template($(1))"
	@echo "$(BINARY_NAME)-$(1)-%: export GOOS := $(1)"
	@echo "========================================"
endef

# Define all OS-specific targets
$(foreach os_pattern,$(OS_LIST), \
    $(eval $(call OS_TARGET_template,$(os_pattern))) \
)

# Platform-specific target patterns
# $(1) will evaluate to a target platform pattern string
define PLATFORM_TARGET_template
debug-mk::
	@echo "INSIDE: PLATFORM_TARGET_template($(1))"
	@echo ""
	@echo "%-$(1): export GOARCH := $(1)"
	@echo "========================================"
endef

# Define all platform-specific targets
$(foreach platform_pattern,$(PLATFORMS), \
    $(eval $(call PLATFORM_TARGET_template,$(platform_pattern))) \
)


# Multi-platform build targets
# $(1) will evaluate to a target OS pattern string
# $(2) will evaluate to a target platform pattern string
define OS_PLATFORM_TARGET_template
debug-mk::
	@echo "INSIDE: OS_PLATFORM_TARGET_template($(1), $(2))"
	@echo ""
	@echo "$(BINARY_NAME)-$(1)-$(2): build"
	@echo "========================================"
endef

# Define all cross-platform targets
$(foreach os_pattern,$(OS_LIST), \
    $(foreach platform_pattern,$(PLATFORMS), \
        $(eval $(call OS_PLATFORM_TARGET_template,$(os_pattern),$(platform_pattern))) \
    ))


PLATFORM_BINARY_NAMES := $(foreach os_pattern,$(OS_LIST), \
                             $(foreach platform_pattern,$(PLATFORMS), \
                                 $(BINARY_NAME)-$(os_pattern)-$(platform_pattern) \
                             ) \
			 )

build-xplatform: $(PLATFORM_BINARY_NAMES) ## Build all cross-platform binaries for $(OS_LIST) + $(PLATFORMS)
