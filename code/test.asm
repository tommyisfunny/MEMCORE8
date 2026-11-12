#include "sys/isa.asm"

#bank code
main:
    lrw a0, #test

    lrw a2, #$DEAD
    lrw a4, #$BEEF
    lrw a6, #$C0DE
    
    stw a2, [a0]+0
    stw a4, [a0]+2
    stw a6, [a0]+4

#addr $01FF
test: #res 6