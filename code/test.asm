#include "sys/isa.asm"

#bank code
main:
    ldr a0, #$AA
    str a0, [test]

#addr $0212
test: #res 1