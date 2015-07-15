# (c) 2015 Wojciech A. Koszek <wojciech@koszek.com>
NAME=$(shell basename `pwd`)
RELNAME=$(NAME)-$(CC)
TMPDIR=/tmp
SRCS_ALL:=$(wildcard *.c)
SRCS_EXCLUDED=
SRCS=$(filter-out $(SRCS_EXCLUDED),$(SRCS_ALL))
OBJECTS:=$(SRCS:.c=.prog)
MEMCHECKS:=$(SRCS:.c=.memcheck)
CACHEGRINDS:=$(SRCS:.c=.cachegrind)
CALLGRINDS:=$(SRCS:.c=.callgrind)
SUPPRESSIONS:=$(SRCS:.c=.sup)
CFLAGS+=-Wall -pedantic -std=c99
CFLAGS+=-g -ggdb -O0

all:	$(OBJECTS)
check:	memcheck cachegrind callgrind
suppression: $(SUPPRESSIONS)

memcheck:	$(MEMCHECKS)
cachegrind:	$(CACHEGRINDS)
callgrind:	$(CALLGRINDS)

%.prog: %.c
	$(CC) $(CFLAGS) $< -o $@

%.memcheck: %.prog
	valgrind -v --tool=memcheck --gen-suppressions=all --suppressions=data/${@}.sup --log-file=$@ --track-origins=yes ./$<
%.cachegrind: *.prog
	valgrind --tool=cachegrind --log-file=$@.log --cachegrind-out-file=$@ ./$<
	cg_annotate $@ >> $@.log
%.callgrind: *.prog
	valgrind --tool=callgrind --log-file=$@.log --callgrind-out-file=$@ ./$<
	callgrind_annotate $@ >> $@.log

%.sup: %.prog
	touch $@

relfilename:
	@echo $(TMPDIR)/$(RELNAME).tar.bz2

pack:
	rm -rf $(TMPDIR)/$(RELNAME)
	mkdir $(TMPDIR)/$(RELNAME)
	cp -rf * $(TMPDIR)/$(RELNAME)/
	cd $(TMPDIR) && tar cjf $(RELNAME).tar.bz2 $(RELNAME)

clean:
	rm -rf \
		*.prog		\
		$(MEMCHECKS)	\
		$(CACHEGRINDS)	\
		$(CALLGRINDS)	\
		*.dSYM		\
		*.log		\
		$(TMPDIR)/$(RELNAME)		\
		$(TMPDIR)/$(RELNAME).tar.bz2

PHONY: %.memcheck %.cachegrind %.callgrind
