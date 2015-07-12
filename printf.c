#include <stdio.h>

#define TABSIZE	20

int
main(int argc, char **argv)
{
	float	tab[TABSIZE];
	int	tab_size;

	tab_size = sizeof(tab)/sizeof(tab[0]);
	printf("tab_size: %d\n", tab_size);

	return 0;
}
