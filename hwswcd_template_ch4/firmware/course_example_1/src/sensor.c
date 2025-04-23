#include "sensor.h"

unsigned int SENSOR_fetch(void) {
    unsigned int pixeldata;
    pixeldata = SENSOR_PIXELDATA;
    SENSOR_CR |= SENSOR_CR_RE; 
    SENSOR_CR &= ~SENSOR_CR_RE; 
    return pixeldata;
}

static unsigned char SENSOR_get_width(void) {
    return (unsigned char)((SENSOR_SR>>16) & 0xff);
}
static unsigned char SENSOR_get_height(void) {
    return (unsigned char)((SENSOR_SR>>8) & 0xff);
}
