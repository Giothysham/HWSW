
#define OUTPORT 0x80000000

int main(void) {
    int i = 0;
    if (i == 0) {
        *((volatile unsigned int*)OUTPORT) = 3;
        i = 1;
    } else {
        *((volatile unsigned int*)OUTPORT) = 0;
        i = 0;
    }
}
