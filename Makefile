#
# Makefile responsible for building the EC-PostgreSQL plugin
#
# Copyright (c) 2005-2012 Electric Cloud, Inc.
# All rights reserved

SRCTOP=..
include $(SRCTOP)/build/vars.mak

build: buildJavaPlugin
unittest:

systemtest: test-setup test-run

NTESTFILES  ?= systemtest

test-setup:
	$(EC_PERL) systemtest/setup.pl $(TEST_SERVER) $(PLUGINS_ARTIFACTS)

test-run: systemtest-run

include $(SRCTOP)/build/rules.mak
