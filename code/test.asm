#include "sys/isa.asm"

#bank code
main:
    lrw a0, #test
    lrw a2, [a0]+0
    lrw a4, [a0]+2
    lrw a6, [a0]+4

#addr $2CFD
test: #d16 $le($1234), $le($DEAD), $le($BEEF)