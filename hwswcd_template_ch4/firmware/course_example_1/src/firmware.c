#include "tcnt.h"

#define LED_BASEAxDDRESS 0x80000000

#define LED_REG0_ADDRESS (LED_BASEAxDDRESS + 0*4)

#define LED              (*(volatile unsigned int *) LED_REG0_ADDRESS)




void irq_handler(unsigned int cause) {

    LED = 0xFFFFFFFF;

    TCNT_CR = 0x17;
    TCNT_CR = 0x7;

}


void main(void) {
    
    unsigned int i=1, j;

    TCNT_CMP = 0xfff;
    TCNT_start();
    

    while(1) {
        for(i=1;i<8;i++) {
            LED = i;
        }
    }
}
