#include "print.h"

int main(void) {
	print_str("Hello, World!\n");
	print_dec(32);
	print_str("\n");
	print_dec(320);
	print_str("\n");
	print_dec(7458);
	print_str("\n");

	// print_str("buffer_string with print_str\0\n");
	// print_str(&buffer_string[0]);
	// print_str("\n");
	// print_str("buffer_number with print_str\0\n");
	// print_str(&buffer_number[0]);
	// print_str("\n");
	// print_str("buffer_string with print_chr\ n");
	// for(int i = 0; i < 4; i++) {
	// 	print_chr(buffer_string[i]);
	// }
	// print_str("\n");
	// print_str("buffer_number with print_chr\n");
	// for(int i = 0; i < 4; i++) {
	// 	print_chr(buffer_number[i]);
	// }
	// print_str("\n");

}
