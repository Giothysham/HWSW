#define OUTPORT 0x80000000


int main(void) {
	int i = 0;
	for (;;) {
		for(int j = 0 ; j <= 40000000; j++){
			if(j == 40000000){
				i = i + 1;
				*((volatile unsigned int *)OUTPORT) = i;
			}
		}
		
	}
	return 0;
}
