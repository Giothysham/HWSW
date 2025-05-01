#include "hash.h"

unsigned int HASH_compute(int hash_data) {
    unsigned int hash_value;
    HASH_IN = hash_data; // Write the data to the input register
    hash_value = HASH_OUT; // Read the hash value from the output register
    return hash_value;
}