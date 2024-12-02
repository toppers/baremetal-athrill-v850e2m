#include "serial_api.h"
#include "pointer.h"

void pointer_init(void)
{
    test_print("INFO: INITIALIZE POINTER\n");
    global_value = 0x12345678;
    global_value_pointer = &global_value;
}

void pointer_write(void)
{
    test_print("INFO: WRITE POINTER\n");
    *global_value_pointer = 0x87654321;
}

void pointer_read(void)
{
    test_print("INFO: READ POINTER\n");
    int value = *global_value_pointer;
    test_print("global_value = ");
    test_serial_hex(value);
    test_print("\n");
}
