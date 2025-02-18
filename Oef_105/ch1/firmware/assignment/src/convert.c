#include "convert.h"

unsigned int convert(unsigned int x) {
    unsigned int y = (x - 32) * 5 / 9;
    return y;
}