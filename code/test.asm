#include "sys/isa.asm"

#bank code
main:
    ldr a0, #2
    inc a0
    inc a1
#addr $01FF
test: #res 6