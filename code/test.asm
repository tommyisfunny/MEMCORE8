#include "sys/isa.asm"

#bank code
main:
    ldr a0, #$AA
    mov a0, a3
    mov a3, s7

    lrw a2, #$DEAD
    lrw a4, #$BEEF
    lrw a6, #$C0DE
    
    stw a2, [a0]+0
    stw a4, [a0]+2
    stw a6, [a0]+4

#addr $01FF
test: #res 6