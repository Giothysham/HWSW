#include "print.h"


int convert(unsigned int x)
{
	unsigned int y = 0;
	unsigned int buffer = 0;
	buffer = x - 32;
	
    unsigned int mul_buffer = 0;
	for(int i = 0; i < 5; i++)
	{
		mul_buffer = mul_buffer + buffer;
	}

	while(mul_buffer >= 9)
	{
		mul_buffer = mul_buffer - 9;
		y = y + 1;
	}
	
	return y;
}

int main(void) {
    unsigned int c = 0;

    c = convert(212);
    print_dec(212);
	print_chr('\n');
    c = convert(100);
    print_dec(15);
	print_chr('\n');
    c =convert(32);
    print_dec(c);
    c = convert(359);
    print_dec(c);
	print_chr('\n');
    c = convert(500);
    print_dec(c);
}
