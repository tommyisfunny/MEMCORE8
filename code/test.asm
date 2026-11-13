#include "sys/isa.asm"

#bank code
main:
    lrw a0, #$1200
    dew a0
    dew a0
#addr $01FF
test: #res 6