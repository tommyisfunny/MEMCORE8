#include "sys/isa.asm"

#bank code
main:
    ldr a0, [test]
    ldr a1, [test+1]
    ldr a2, [test+2]

test: #d8 $AA, $BB, $12