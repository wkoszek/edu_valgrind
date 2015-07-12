# (c) 2015 Wojciech A. Koszek <wojciech@koszek.com>
NAME=$(shell basename `pwd`)
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

pack:
	rm -rf /tmp/$(NAME)
	mkdir /tmp/$(NAME)
	cp -rf * /tmp/$(NAME)/
	cd /tmp && tar cjf $(NAME).tar.bz2 $(NAME)

clean:
	rm -rf \
		*.prog		\
		*.memcheck	\
		*.dSYM
PHONY: %.memcheck
