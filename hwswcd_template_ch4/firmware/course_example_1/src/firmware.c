//#include <stdio.h>

#include "tcnt.h"
#include "sensor.h"

#define LED_BASEAxDDRESS 0x80000000

#define LED_REG0_ADDRESS (LED_BASEAxDDRESS + 0*4)

#define LED (*(volatile unsigned int *) LED_REG0_ADDRESS)

void irq_handler(unsigned int cause) {

        LED = 0x00FF00FF;

}

int main(void) {

    unsigned char number;

    number = SENSOR_get_width();

    LED = number;

    number = SENSOR_get_height();

    LED = number;

    return 0;
}

    
