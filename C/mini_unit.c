#include <stdio.h>

int process_results(char *result, int tests_run)
{
	if (result != 0)
		printf("%s\n", result);

	else
		printf("ALL TESTS PASSED\n");

	printf("Tests run: %d\n", tests_run);

	return result != 0;
}
