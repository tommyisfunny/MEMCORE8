#include "sys/isa.asm"

#bank code
main:
    lrw a0, #test

    stw a0, [test]

    lrw a2, #$DE
    lrw a3, #$AD
    lrw a4, #$12
    
    str a2, [a0]+0
    str a3, [a0]+1
    str a4, [a0]+2

#addr $01FF
test: #res 6