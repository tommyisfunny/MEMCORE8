#include "sys/isa.asm"

#bank code
main:
    ldr a0, #$12
    dec a0
    dec a2
#addr $01FF
test: #res 6