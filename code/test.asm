#include "sys/isa.asm"

#bank code
main:
    ldr a0, #$1
    ldr a1, #$2
    add a0, a1
#addr $01FF
test: #res 6