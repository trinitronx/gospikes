BINARY_NAME=$(shell grep module go.mod | sed -e 's/module \(.*\)\/\(.*\)$$/\2/')
SOURCE_FILES := $(wildcard src/*.go)
PLATFORMS ?= amd64 arm64 ppc64le riscv64
OS_LIST ?= darwin linux windows

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
project_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
top_builddir := $(basename $(patsubst %/,%,$(dir $(mkfile_path))))
src_dir := $(top_builddir)/src


build_aux := $(top_builddir)/build-aux
include $(build_aux)/main.mk

.PHONY: debug-mk build run clean

debug-mk: ## Debug Makefile variables
	@echo mkfile_path=$(mkfile_path)
	@echo project_dir=$(project_dir)
	@echo top_builddir=$(top_builddir)
	@echo build_aux=$(build_aux)
	@echo BINARY_NAME=$(BINARY_NAME)
	@echo SOURCE_FILES=$(SOURCE_FILES)


$(BINARY_NAME)-%: build
build: $(SOURCE_FILES) ## no-help

#xplatform: $(PLATFORMS) ## Build cross-platform Docker images
#$(PLATFORMS): $(SOURCE_FILES)
#	GOARCH=$@ GOOS=darwin go build -o $(BINARY_NAME)-darwin.$@

build: ## Create cross-platform builds
	go build -o $(BINARY_NAME)-$(GOOS)-$(GOARCH) $(src_dir)
#	GOARCH=amd64 GOOS=darwin  go build -o $(BINARY_NAME)-darwin
#	GOARCH=amd64 GOOS=linux   go build -o $(BINARY_NAME)-linux
#	GOARCH=amd64 GOOS=windows go build -o $(BINARY_NAME)-windows

run: $(BINARY_NAME)-$(PLATFORM)-$(TARGET_ARCH) ## no-help
run: ## Run the built binary
	./${BINARY_NAME}

clean: ## Clean all generated files
	go clean
	rm -f $(BINARY_NAME)
	rm -f $(BINARY_NAME)-darwin-*
	rm -f $(BINARY_NAME)-linux-*
	rm -f $(BINARY_NAME)-windows-*
