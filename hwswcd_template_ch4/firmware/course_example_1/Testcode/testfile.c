#include <stdio.h>
#include <stdint.h>

char compressed_image[256] = "";
unsigned char position = 0;

void print_hex(unsigned int val, int digits) {
	unsigned int index, max;
	int i; /* !! must be signed, because of the check 'i>=0' */
	char x;

	if(digits == 0)
		return;

	max = digits << 2;

	for (i = max-4; i >= 0; i -= 4) {
		index = val >> i;
		index = index & 0xF;
		x="0123456789ABCDEF"[index];
		compressed_image[position] = x;
		position++;
	}
}

int main() {



    print_hex(0x12345678, 8); // prints "12345678"
    print_hex(0xABCD, 4); // prints "ABCD"
    print_hex(0xFF, 2); // prints "FF"

    return 0;
}