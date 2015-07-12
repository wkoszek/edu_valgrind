#include <assert.h>
#include <stdio.h>

int
main(int argc, char **argv)
{
	FILE	*fp;
	int	rv, fi;
	float	f[100];
	
	fp = fopen("./test/floats.i", "r");
	assert(fp != NULL);
	fi = 0;
	do {
		rv = fscanf(fp, "%f", &f[fi++]);
	} while (rv == 1);
	rv = fclose(fp);
	assert(rv == 0);

	return 0;
}
