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

    int number;

    // number = SENSOR_fetch();

    number = SENSOR_SR;

    number = 0xaabbccdd;

    number = SENSOR_get_width();

    number = 0xbbbbccdd;

    number = SENSOR_get_height();

    return 0;
}

    
