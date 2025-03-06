#define OUTPORT 0x80000000


int main(void) {
	int i = 0;
	for (;;) {
		for(int j = 0 ; j <= 4000000; j++){
			if(j == 4000000){
				if(i == 7){
					i = 0;
					*((volatile unsigned int *)OUTPORT) = i;
				} else if(i == 0) {
					i = 7;
					*((volatile unsigned int *)OUTPORT) = i;
				}
			}
		}
	}
	return 0;
}
