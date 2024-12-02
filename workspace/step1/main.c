#include "test_serial.h"
#include "serial_api.h"
#include "pointer.h"

unsigned char stack_data[1024];

extern void test_suite(void);

unsigned int test_data_uint32;

void test_print(const char *str)
{
	int i;
	for (i = 0; str[i] != '\0'; i++) {
		*(SERIAL_OUT_ADDR) = str[i];
	}
	//*(SERIAL_OUT_ADDR) = '\n';
}
void test_serial_hex(unsigned int data)
{
	int i;
	unsigned int mask = 0xF0000000;
	unsigned int shift = 28;
	unsigned int hex_data;
	*(SERIAL_OUT_ADDR) = '0';
	*(SERIAL_OUT_ADDR) = 'x';
	for (i = 0; i < 8; i++) {
		hex_data = (data & mask) >> shift;
		if (hex_data < 10) {
			*(SERIAL_OUT_ADDR) = '0' + hex_data;
		} else {
			*(SERIAL_OUT_ADDR) = 'A' + hex_data - 10;
		}
		mask = mask >> 4;
		shift -= 4;
	}
}

int main(void)
{
	pointer_init();
	pointer_write();
	pointer_read();

	test_print("\n");
	test_print("Hello World!\n");

	test_suite();
	while (1) {
		;
	}
}
