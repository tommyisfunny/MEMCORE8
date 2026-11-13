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
jmp ALW, lrw_adr
jmp ALW, lrw_reg_offset
jmp ALW, str_adr
jmp ALW, str_reg_offset
jmp ALW, stw_adr
jmp ALW, stw_reg_offset
jmp ALW, mov_byte
jmp ALW, mov_word
jmp ALW, inc_byte
jmp ALW, inc_word
jmp ALW, dec_byte

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

; load a word from memory into a register
lrw_adr:
    mov MEM[ADRREG], A / INCADR ; get register number
    mov A, MEM[TMP0]            ; save register number
    mov MEM[ADRREG], A / INCADR ; get address value low byte
    mov A, MEM[TMP1]            ; save address value low byte
    mov MEM[ADRREG], A / INCADR ; get address value high byte

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP1], ADRL         ; put address value low byte into address register
    mov A, ADRH                 ; put address value high byte into address register

    mov MEM[ADRREG], A / INCADR ; get value low byte from memory
    mov A, MEM[TMP2]            ; save value low byte
    mov MEM[ADRREG], A          ; get value high byte from memory
    mov A, MEM[TMP3]            ; save value high byte

    mov MEM[TMP0], ADRL         ; put register number into address register
    mov 0, ADRH                 ;

    mov MEM[TMP2], A            ; get value low byte
    mov A, MEM[ADRREG] / INCADR ; save value low byte into register

    mov MEM[TMP3], A            ; get value high byte
    mov A, MEM[ADRREG]          ; save value high byte into register

    jmp ALW, fetch

; load a word from memory, specified by a register + offset, into a register
lrw_reg_offset:
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

    mov MEM[ADRREG], A / INCADR ; get value low byte from memory
    mov A, MEM[TMP2]            ; save value low byte
    mov MEM[ADRREG], A          ; get value high byte from memory
    mov A, MEM[TMP3]            ; save value high byte

    mov MEM[TMP0], ADRL         ; put target register number into address register
    mov 0, ADRH                 ;

    mov MEM[TMP2], A            ; get value low byte
    mov A, MEM[ADRREG] / INCADR ; save value low byte into target register
    mov MEM[TMP3], A            ; get value high byte
    mov A, MEM[ADRREG]          ; save value high byte into target register
    
    jmp ALW, fetch

    .crossed_page:
    clc APLUSB, 1               ; add 1 to higher base address byte
    mov Y, ADRH                 ; put higher final address byte into address register
    jmp ALW, .get_value

; store a byte from a register into memory
str_adr:
    mov MEM[ADRREG], A / INCADR ; get register number
    mov A, MEM[TMP0]            ; save register number
    mov MEM[ADRREG], A / INCADR ; get address value low byte
    mov A, MEM[TMP1]            ; save address value low byte
    mov MEM[ADRREG], A / INCADR ; get address value high byte   
    mov A, MEM[TMP2]            ; save address value high byte

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP0], ADRL         ; put register number into address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A          ; get value

    mov MEM[TMP1], ADRL         ; put address low byte into address register
    mov MEM[TMP2], ADRH         ; put address high byte into address register

    mov A, MEM[ADRREG]          ; save value into memory

    jmp ALW, fetch

; store a byte from a register into memory, specified by a register + offset
str_reg_offset:
    mov MEM[ADRREG], A / INCADR ; get source register number
    mov A, MEM[TMP0]            ; save source register number
    mov MEM[ADRREG], A / INCADR ; get base address register number
    mov A, MEM[TMP1]            ; save base address register number
    mov MEM[ADRREG], A / INCADR ; get offset value
    mov A, MEM[TMP3]            ; save offset value

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP0], ADRL         ; put source register number into address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A          ; get value from register
    mov A, MEM[TMP0]            ; save value

    mov MEM[TMP1], ADRL         ; put base address register number into address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A / INCADR ; get lower base address byte from base address register
    clc APLUSB, MEM[TMP3]       ; add offset to lower base address byte
    
    mov MEM[ADRREG], A          ; get higher base address byte from base address register

    mov Y, ADRL                 ; put lower final address byte into address register
    
    jmp CAR, .crossed_page      ; check if adding the offset caused a page crossing

    mov A, ADRH                 ; put higher final address byte into address register

    .store_value:
    mov MEM[TMP0], A            ; get value
    mov A, MEM[ADRREG]          ; save value into memory

    jmp ALW, fetch

    .crossed_page:
    clc APLUSB, 1               ; add 1 to higher base address byte
    mov Y, ADRH                 ; put higher final address byte into address register
    jmp ALW, .store_value

; store a word from a register into memory
stw_adr:
    mov MEM[ADRREG], A / INCADR ; get register number
    mov A, MEM[TMP0]            ; save register number
    mov MEM[ADRREG], A / INCADR ; get address value low byte
    mov A, MEM[TMP2]            ; save address value low byte
    mov MEM[ADRREG], A / INCADR ; get address value high byte   
    mov A, MEM[TMP3]            ; save address value high byte

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP0], ADRL         ; put register number into address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A / INCADR ; get value low byte
    mov A, MEM[TMP0]            ; save value low byte

    mov MEM[ADRREG], A           ; get value high byte
    mov A, MEM[TMP1]            ; save value high byte

    mov MEM[TMP2], ADRL         ; put address low byte into address register
    mov MEM[TMP3], ADRH         ; put address high byte into address register
    
    mov MEM[TMP0], A            ; get value low byte
    mov A, MEM[ADRREG] / INCADR ; store value low byte

    mov MEM[TMP1], A            ; get value high byte
    mov A, MEM[ADRREG]          ; store value high byte

    jmp ALW, fetch

; store a word from a register into memory, specified by a register + offset
stw_reg_offset:
    mov MEM[ADRREG], A / INCADR ; get source register number
    mov A, MEM[TMP0]            ; save source register number
    mov MEM[ADRREG], A / INCADR ; get base address register number
    mov A, MEM[TMP2]            ; save base address register number
    mov MEM[ADRREG], A / INCADR ; get offset value
    mov A, MEM[TMP3]            ; save offset value

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP0], ADRL         ; put source register number into address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A / INCADR ; get value low byte from register
    mov A, MEM[TMP0]            ; save value low byte 
    mov MEM[ADRREG], A          ; get value high byte from register
    mov A, MEM[TMP1]            ; save value high byte


    mov MEM[TMP2], ADRL         ; put base address register number into address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A / INCADR ; get lower base address byte from base address register
    clc APLUSB, MEM[TMP3]       ; add offset to lower base address byte
    
    mov MEM[ADRREG], A          ; get higher base address byte from base address register

    mov Y, ADRL                 ; put lower final address byte into address register
    
    jmp CAR, .crossed_page      ; check if adding the offset caused a page crossing

    mov A, ADRH                 ; put higher final address byte into address register

    .store_value:
    mov MEM[TMP0], A            ; get value low byte
    mov A, MEM[ADRREG] / INCADR ; save value low byte into memory
    mov MEM[TMP1], A            ; get value high bye
    mov A, MEM[ADRREG]          ; save value high byte into memory

    jmp ALW, fetch

    .crossed_page:
    clc APLUSB, 1               ; add 1 to higher base address byte
    mov Y, ADRH                 ; put higher final address byte into address register
    jmp ALW, .store_value

; copies a byte from one register to another
mov_byte:
    mov MEM[ADRREG], A / INCADR ; get source register number
    mov A, MEM[TMP0]            ; save source register number
    mov MEM[ADRREG], A / INCADR ; get target address register number
    mov A, MEM[TMP1]            ; save target address register number

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP0], ADRL         ; put source register number in address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A          ; get value

    mov MEM[TMP1], ADRL         ; put target register number into address register
    mov 0, ADRH                 ;

    mov A, MEM[ADRREG]          ; save value to memory

    jmp ALW, fetch

; copies a word from one register to another
mov_word:
    mov MEM[ADRREG], A / INCADR ; get source register number
    mov A, MEM[TMP0]            ; save source register number
    mov MEM[ADRREG], A / INCADR ; get target address register number
    mov A, MEM[TMP1]            ; save target address register number

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov MEM[TMP0], ADRL         ; put source register number in address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A / INCADR ; get value low byte
    mov A, MEM[TMP2]            ; save value low byte
    mov MEM[ADRREG], A          ; get value high byte
    mov A, MEM[TMP3]            ; save value high byte

    mov MEM[TMP1], ADRL         ; put target register number into address register
    mov 0, ADRH                 ;

    mov MEM[TMP2], A            ; get value low byte
    mov A, MEM[ADRREG] / INCADR ; save value low byte to memory

    mov MEM[TMP3], A            ; get value high byte
    mov A, MEM[ADRREG]          ; save value high byte to memory

    jmp ALW, fetch

; increment byte in reg
inc_byte:
    mov MEM[ADRREG], A / INCADR ; get register number

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov A, ADRL                 ; put register number into address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A          ; get the value
    clc APLUSB, 1               ; add 1
    mov Y, MEM[ADRREG]          ; save value back into register

    jmp ALW, fetch

; increment word in register
inc_word:
    mov MEM[ADRREG], A / INCADR ; get register number
    mov A, MEM[TMP0]            ; save register number

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov A, ADRL                 ; put register number into address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A / INCADR ; get value low byte
    mov A, MEM[TMP1]            ; save value low byte

    mov MEM[ADRREG], ADRH       ; get value high byte and store in address register
    mov MEM[TMP1], ADRL         ; put value low byte into address register

    INCADR                      ; increment value in the address register

    mov ADRL, MEM[TMP1]         ; save value low byte
    mov ADRH, MEM[TMP2]         ; save value high byte

    mov MEM[TMP0], ADRL         ; put register number into addresss register
    mov 0, ADRH                 ;

    mov MEM[TMP1], A            ; get value low byte
    mov A, MEM[ADRREG] / INCADR ; store value low nyte in register
    mov MEM[TMP2], A            ; get value high byte
    mov A, MEM[ADRREG]          ; store value high byte in register

    jmp ALW, fetch

; decrement word in register
dec_byte:
    mov MEM[ADRREG], A / INCADR ; get register number

    mov ADRL, MEM[PCL]          ; save program counter
    mov ADRH, MEM[PCH]          ;

    mov A, ADRL                 ; put register number into address register
    mov 0, ADRH                 ;

    mov MEM[ADRREG], A          ; get the value
    clc AMINUSB, 0              ; sub 1
    mov Y, MEM[ADRREG]          ; save value back into register

    jmp ALW, fetch