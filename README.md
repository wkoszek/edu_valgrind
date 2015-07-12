# Valgrind HOWTO and Examples

This repository contains several examples of Valgrind Memcheck
usage. Everything is made for my own education, but you might
find the examples and the infrastructure useful.

Valgrind sometimes gets things wrong and generates false-positives. To
suppress the warnings about those, Valgrind uses `suppression files`. In
this repository, those are named with a `.sup` extension and live in `test/`
directory.

# How to build sample programs

Just type make:

	make

You'll get a lot of programs named with `.prog` extension. Sample output:

~~~terminal
cc -Wall -pedantic -std=c99 -g -ggdb -O0 empty.c -o empty.prog
cc -Wall -pedantic -std=c99 -g -ggdb -O0 fscanf.c -o fscanf.prog
cc -Wall -pedantic -std=c99 -g -ggdb -O0 fscanf_many.c -o fscanf_many.prog
cc -Wall -pedantic -std=c99 -g -ggdb -O0 printf.c -o printf.prog
cc -Wall -pedantic -std=c99 -g -ggdb -O0 vprintf_warn.c -o vprintf_warn.prog
~~~

You can run each `.prog` file and see its result.

# How to run Valgrind checking

Just tyoe:

	make check

Sample output:

~~~terminal
valgrind -v --tool=memcheck --gen-suppressions=all --suppressions=data/empty.memcheck.sup --log-file=empty.memcheck --track-origins=yes ./empty.prog
valgrind -v --tool=memcheck --gen-suppressions=all --suppressions=data/fscanf.memcheck.sup --log-file=fscanf.memcheck --track-origins=yes ./fscanf.prog
valgrind -v --tool=memcheck --gen-suppressions=all --suppressions=data/fscanf_many.memcheck.sup --log-file=fscanf_many.memcheck --track-origins=yes ./fscanf_many.prog
valgrind -v --tool=memcheck --gen-suppressions=all --suppressions=data/printf.memcheck.sup --log-file=printf.memcheck --track-origins=yes ./printf.prog
tab_size: 20
valgrind -v --tool=memcheck --gen-suppressions=all --suppressions=data/vprintf_warn.memcheck.sup --log-file=vprintf_warn.memcheck --track-origins=yes ./vprintf_warn.prog
Going to read: 1 elements
~~~

Output sits in `.memcheck` files. They have a Valgrind output. Passed flags
mean verbose output (`-v`), use default Memcheck tool (`--tool=memcheck`),
generate suppressions without asking (`--gen-suppressions=all`), use not
only default, but also additional suppression file (`--suppressions`) log
output to the file (`--log-file`) and in case of memory problems, show
exactly where they're coming from (`--track-origin`). 
