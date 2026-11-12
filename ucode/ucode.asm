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
jmp ALW, ldr_reg_offset
jmp ALW, lrw_const

; ucode for the instructions
#bank ucode

; executed when the CPU is reset
reset:
    mov 0, A        ; initialize the program counter to $0100
    mov A, MEM[PCL] ;
    mov 1, A        ;
    mov A, MEM[PCH] ;

    jmp ALW, fetch


; executed after each instruction to fetch the next instruction
fetch:
    mov MEM[PCL], ADRL          ; get the program counter into the address register
    mov MEM[PCH], ADRH          ;

    lir 0:MEM[ADRREG] / INCADR  ; load the instruction from memory into the instruction register
                                ; increment the program counter in the address register
                                ; the program counter is left in the address register for the instructions to use for
                                ; fetching any additional bytes they need


; load a byte constant into a register
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

; load a byte from memory into a register
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

; load a byte from memory, specified by a register + offset, into a register
ldr_reg_offset:
    mov MEM[ADRREG], A / INCADR ; get target register number
    mov A, MEM[TMP0]            ; save target register number
    mov MEM[ADRREG], A / INCADR ; get base address register number
    mov A, MEM[TMP1]            ; save base address register number
    mov MEM[ADRREG], A / INCADR ; get offset value
    mov A, MEM[TMP3]            ; save offset value

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP1], ADRL         ; put base address register number into address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A / INCADR ; get lower base address byte from base address register
    clc APLUSB, MEM[TMP3]       ; add offset to lower base address byte
    
    mov MEM[ADRREG], A          ; get higher base address byte from base address register

    mov Y, ADRL                 ; put lower final address byte into address register
    
    jmp CAR, .crossed_page      ; check if adding the offset caused a page crossing

    mov A, ADRH                 ; put higher final address byte into address register

    .get_value:
    mov MEM[ADRREG], A          ; get value from memory

    mov MEM[TMP0], ADRL         ; put target register number into address register
    mov 0, ADRH                 ;
    mov A, MEM[ADRREG]          ; save value into target register

    jmp ALW, fetch

    .crossed_page:
    clc APLUSB, 1               ; add 1 to higher base address byte
    mov Y, ADRH                 ; put higher final address byte into address register
    jmp ALW, .get_value

; load a word constant into a register
lrw_const:
    mov MEM[ADRREG], A / INCADR ; get register number
    mov A, MEM[TMP0]            ; save register number
    mov MEM[ADRREG], A / INCADR ; get constant value low byte
    mov A, MEM[TMP1]            ; save constant value low byte
    mov MEM[ADRREG], A / INCADR ; get constant value high byte
    mov A, MEM[TMP2]            ; save constant value high byte

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP0], ADRL         ; put register number into address register
    mov 0, ADRH                 ;
    
    mov MEM[TMP1], A            ; get constant value low byte
    mov A, MEM[ADRREG] / INCADR ; save constant value low byte into register
    mov MEM[TMP2], A            ; get constant value high byte
    mov A, MEM[ADRREG]          ; save constant value high byte into register

    jmp ALW, fetch