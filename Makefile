#
# MIT License
#
# (C) Copyright 2021-2022 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#

NAME ?= ${GIT_REPO_NAME}
ifeq ($(VERSION),)
VERSION := $(shell git describe --tags | tr -s '-' '~' | tr -d '^v')
endif

SPEC_FILE ?= ${NAME}.spec
SOURCE_NAME ?= ${NAME}
BUILD_DIR ?= $(PWD)/dist/rpmbuild
SOURCE_PATH := ${BUILD_DIR}/SOURCES/${SOURCE_NAME}-${VERSION}.tar.bz2

MDFILES := $(shell find . -name "*.md" -type f)

all:
	@echo "Tell me what to make"
	@echo ""
	@echo "Cray default does: make prepare; make rpm"
	@echo ""
	@echo "For Jekyll rendering, we have:"
	@echo ""
	@echo " jekyll-cmds    Echo Jekyll commands"
	@echo " jekyll-clean   Removes Jekyll-created files"
	@echo "                Restores modified dot-md files"
	@echo ""
	@echo " jekyll-add-def-header    Modify dot-md files"
	@echo ""
	@echo " jekyll-replace-md-links  Modify dot-md files"
	@echo ""
	@echo " jekyll-show-brace_percent_str  Identify files to edit"
	@echo ""
	@echo " jekyll-protect-code-blocks     Modify dot-md files"
	@echo ""

was_all: prepare rpm

rpm: prepare rpm_package_source rpm_build_source rpm_build

prepare:
	rm -rf $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/SPECS $(BUILD_DIR)/SOURCES
	cp $(SPEC_FILE) $(BUILD_DIR)/SPECS/

rpm_package_source:
	tar --transform 'flags=r;s,^,/${NAME}-${VERSION}/,' --exclude .git --exclude dist -cvjf $(SOURCE_PATH) .

rpm_build_source:
	rpmbuild -ts $(SOURCE_PATH) --define "_topdir $(BUILD_DIR)"

rpm_build:
	BUILD_METADATA=$(BUILD_METADATA) rpmbuild -ba $(SPEC_FILE) --define "_topdir $(BUILD_DIR)"

rpm_latest: 
	cp $(wildcard $(BUILD_DIR)/RPMS/noarch/docs-csm-$(VERSION)-*.noarch.rpm) "$(BUILD_DIR)/RPMS/noarch/docs-csm-latest.noarch.rpm" 

jekyll-cmds:
	@echo "You'll probably want one of"
	@echo ""
	@echo 'PATH=/path/to/.gem/ruby/x.y.z/bin:$$PATH jekyll build'
	@echo ""
	@echo 'PATH=/path/to/.gem/ruby/x.y.z/bin:$$PATH jekyll serve'
	@echo ""

jekyll-clean:
	@rm -fr _site .jekyll-cache
	find . -name \*.md -print | xargs git restore

jekyll-add-def-header:
	./scripts/add_layout_header_default.sh

jekyll-replace-md-links:
	for f in $(MDFILES) ; do ./scripts/replace_page_links.sh $$f ; ./scripts/replace_anchor_links.sh $$f ; done

jekyll-show-brace_percent_str:
	@./scripts/identify_quotable_strings.sh

jekyll-protect-code-blocks:
	for f in $(MDFILES) ; do \
	awk -f ./scripts/add_raw_sentinals.awk $$f > $$f.tmp ; \
	mv $$f.tmp $$f ; \
	done

