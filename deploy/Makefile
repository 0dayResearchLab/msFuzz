# Copyright (C) Intel Corporation, 2022
# SPDX-License-Identifier: MIT
#
# Makefile recipies for managing kAFL workspace

# declare all targets in this variable
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
ALL_TARGETS:=deploy clean
LOCALHOST_INVENTORY:=$(shell grep 'localhost ansible_connection=local' $(ROOT_DIR)/inventory > /dev/null 2>&1; echo $$?)
# declare all target as PHONY
.PHONY: $(ALL_TARGETS)

# This small chunk of code allows us to pass arbitrary arguments to our make targets
# see the solution on SO:
# https://stackoverflow.com/a/14061796/3017219
# If the first argument is contained in ALL_TARGETS
ifneq ($(filter $(firstword $(MAKECMDGOALS)), $(ALL_TARGETS)),)
  # use the rest as arguments to create a new variable ADD_ARGS
  EXTRA_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(EXTRA_ARGS):;@:)
endif

all: deploy

deploy: venv
	venv/bin/ansible-galaxy install -r requirements.yml --force
ifeq ($(LOCALHOST_INVENTORY),0)
	$(eval ASK_BECOME_PASS := -K)
	@echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
	@echo "┃ Ansible BECOME password: if you are using a passwordless SUDO, skip by pressing enter.┃"
	@echo "└━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┘"
endif
	venv/bin/ansible-playbook -i $(ROOT_DIR)/inventory $(ROOT_DIR)/site.yml $(ASK_BECOME_PASS) $(EXTRA_ARGS)

venv:
	python3 -m venv venv
	venv/bin/pip install wheel
	venv/bin/pip install -r requirements.txt

clean:
	rm -rf "$(ROOT_DIR)/venv"