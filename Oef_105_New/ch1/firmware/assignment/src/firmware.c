#include "print.h"

char buffer_string[5] = {'1', '5', '6', '5', '\0'};
char *buffer_number = "8855";

int main(void) {
	// print_str("Hello, World!\n");
	// print_dec(9);
	// print_str("\n");
	// print_dec(32);
	// print_str("\n");
	// print_dec(320);
	// print_str("\n");
	// print_dec(7458);
	// print_str("\n");

	print_str("buffer_string with print_str\n");
	print_str(&buffer_string[0]);
	print_str("\n");
	print_str("buffer_number with print_str\n");
	print_str(&buffer_number[0]);
	print_str("\n");
	print_str("buffer_string with print_chr\n");
	for(int i = 0; i < 4; i++) {
		print_chr(buffer_string[i]);
	}
	print_str("\n");
	print_str("buffer_number with print_chr\n");
	for(int i = 0; i < 4; i++) {
		print_chr(buffer_number[i]);
	}
	print_str("\n");

}
