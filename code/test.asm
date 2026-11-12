#include "sys/isa.asm"

#bank code
main:
    ldr a0, #$FF
    ldr a1, #$2C

    ldr a2, [a0]+0
    ldr a3, [a0]+1
    ldr a4, [a0]+2

#addr $2CFF
test: #d8 $AA, $BB, $12