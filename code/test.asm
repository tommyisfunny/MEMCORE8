#include "sys/isa.asm"

#bank code
main:
    lrw a0, #$01F2
    lrw a2, #$0313
    adw a0, a2
#addr $01FF
test: #res 6