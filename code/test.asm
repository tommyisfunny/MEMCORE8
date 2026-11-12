#include "sys/isa.asm"

#bank code
main:
    lrw a0, #$12FF
    inw a0
    inw a2
#addr $01FF
test: #res 6