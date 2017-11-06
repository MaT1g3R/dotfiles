#include <stdio.h>
#include "mini_unit.h"


int process_results(char *result, int tests_run)
{
	char *red = "\x1b[31m";
	char *green = "\x1b[32m";
	char *cyan = "\x1b[36m";
	char *reset = "\x1b[0m";

	if (result != 0)
		printf("%s%s%s\n", red, result, reset);

	else
		printf("%sALL TESTS PASSED%s\n", green, reset);

	printf("%sTests run: %d%s\n", cyan, tests_run, reset);

	return result != 0;
}
