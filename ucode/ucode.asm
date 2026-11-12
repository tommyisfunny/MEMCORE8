#include "ruledef.asm"


TMP0 = 0
TMP1 = 1
TMP2 = 2
TMP3 = 3

PCL = 4
PCH = 5
SPL = 6
SPH = 7
FPL = 8
FPH = 9


; entry points for each instruction
#bank entrypoints
jmp ALW, reset
jmp ALW, ldr_const
jmp ALW, ldr_adr

; ucode for the instructions
#bank ucode
fetch:
    mov MEM[PCL], ADRL
    mov MEM[PCH], ADRH
    lir 0:MEM[ADRREG] / INCADR


; executed when the CPU is reset
reset:
    mov 0, A
    mov A, MEM[PCL]
    mov 1, A
    mov A, MEM[PCH]

    jmp ALW, fetch

; load a constant into a register
ldr_const:
    mov MEM[ADRREG], A / INCADR ; get register number
    mov A, MEM[TMP0]            ; save register number
    mov MEM[ADRREG], A / INCADR ; get constant value

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP0], ADRL         ; put register number into address register
    mov 0, ADRH                 ;
    mov A, MEM[ADRREG]          ; save constant into register
    
    jmp ALW, fetch

; load a value from memory into a register
ldr_adr:
    mov MEM[ADRREG], A / INCADR ; get register number
    mov A, MEM[TMP0]            ; save register number
    mov MEM[ADRREG], A / INCADR ; get address value low byte
    mov A, MEM[TMP1]            ; save address value low byte
    mov MEM[ADRREG], A / INCADR ; get address value high byte

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP1], ADRL         ; put address value low byte into address register
    mov A, ADRH                 ; put address value high byte into address register

    mov MEM[ADRREG], A          ; get value from memory
    mov MEM[TMP0], ADRL         ; put register number into address register
    mov 0, ADRH                 ;

    mov A, MEM[ADRREG]          ; save value into register

    jmp ALW, fetch