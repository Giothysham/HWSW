#define OUTPORT 0x80000000


int main(void) {
	int i = 0;
	for (;;) {
		if(i = 0x00000000) {
			*((volatile unsigned int *)OUTPORT) = 0;
			i = 1;
		}
		else {
			*((volatile unsigned int *)OUTPORT) = 3;
			i = 0;
		}
		
	}
	return 0;
}
