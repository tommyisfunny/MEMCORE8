#include "sys/isa.asm"

#bank code
main:
    lrw a0, [test]


#addr $2CFF
test: #d16 $le($1234)