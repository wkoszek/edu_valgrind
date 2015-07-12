# (c) 2015 Wojciech A. Koszek <wojciech@koszek.com>
NAME=$(shell basename `pwd`)
RELNAME=$(NAME)-$(CC)
TMPDIR=/tmp
SRCS_ALL:=$(wildcard *.c)
SRCS_EXCLUDED=
SRCS=$(filter-out $(SRCS_EXCLUDED),$(SRCS_ALL))
OBJECTS:=$(SRCS:.c=.prog)
MEMCHECKS:=$(SRCS:.c=.memcheck)
SUPPRESSIONS:=$(SRCS:.c=.sup)
CFLAGS+=-Wall -pedantic -std=c99
CFLAGS+=-g -ggdb -O0

all:	$(OBJECTS)
check:	$(MEMCHECKS)
suppression: $(SUPPRESSIONS)

%.prog: %.c
	$(CC) $(CFLAGS) $< -o $@

%.memcheck: %.prog
	valgrind -v --tool=memcheck --gen-suppressions=all --suppressions=data/${@}.sup --log-file=$@ --track-origins=yes ./$<

%.sup: %.prog
	touch $@

relfilename:
	@echo $(TMPDIR)/$(RELNAME)

pack:
	rm -rf $(TMPDIR)/$(RELNAME)
	mkdir $(TMPDIR)/$(RELNAME)
	cp -rf * $(TMPDIR)/$(RELNAME)/
	cd $(TMPDIR) && tar cjf $(RELNAME).tar.bz2 $(RELNAME)

clean:
	rm -rf \
		*.prog		\
		*.memcheck	\
		*.dSYM		\
		$(TMPDIR)/$(RELNAME)		\
		$(TMPDIR)/$(RELNAME).tar.bz2

PHONY: %.memcheck
