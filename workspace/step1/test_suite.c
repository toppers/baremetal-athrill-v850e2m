#include "test_check.h"
#include "serial_api.h"

extern int do_test_add1_1(void);


void test_suite(void)
{
    DO_TEST(do_test_add1_1);

	return;
}
