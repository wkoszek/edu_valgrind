#include <assert.h>
#include <stdio.h>

int
main(int argc, char **argv)
{
	FILE	*fp;
	int	rv;
	char	c;

	fp = fopen("./makefile", "r");
	assert(fp != NULL);
	rv = fscanf(fp, "%c", &c);
	assert(rv == 1);
	rv = fclose(fp);
	assert(rv == 0);

	return 0;
}
