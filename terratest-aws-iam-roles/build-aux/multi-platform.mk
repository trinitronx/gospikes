# Define all OS + Platform build targets and vars

# $(1) will evaluate to a target OS pattern string
# $(2) will evaluate to a target platform pattern string
define CONTAINER_TARGET_template
  # Pattern-specific variables
  $(BINARY_NAME)-$(1)-%: export GOOS := $(1)
  $(BINARY_NAME)-$(1)-$(2): export GOARCH := $(2)
  # Build multi-platform compile targets
  $(BINARY_NAME)-$(1)-$(2): build
endef

# Define all cross-platform targets
$(foreach os_pattern,$(OS_LIST),$(foreach platform_pattern,$(PLATFORMS),$(eval $(call CONTAINER_TARGET_template,$(os_pattern),$(platform_pattern)))))
