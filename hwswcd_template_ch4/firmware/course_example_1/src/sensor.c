#include "sensor.h"

unsigned int SENSOR_fetch(void) {
    unsigned int pixeldata;
    pixeldata = SENSOR_PIXELDATA;
    SENSOR_CR |= SENSOR_CR_RE; 
    SENSOR_CR &= ~SENSOR_CR_RE; 
    return pixeldata;
}

unsigned int SENSOR_get_width() {
    return (unsigned char)((SENSOR_SR >> 16) & 0xff);
}

unsigned int SENSOR_get_height() {
    return (unsigned char)((SENSOR_SR >> 8) & 0xff);
}