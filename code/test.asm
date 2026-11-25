#include "sys/isa.asm"

#bank code
main:
    ldr a0, #$00
    ldr a2, #$00
    sub a0, a2
#addr $01FF
test: #res 6