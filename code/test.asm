#include "sys/isa.asm"

#bank code
main:
    lrw a0, #$12FE
    inw a0
    inw a0
#addr $01FF
test: #res 6