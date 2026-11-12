#subruledef cond {
    ALW => 0`3
    NEG => 1`3
    CAR => 2`3
    OVR => 3`3
    GRT => 4`3
    LST => 5`3
    EQU => 6`3
    INT => 7`3
}

#subruledef alufnct {
    ZERO    => 0`3
    BMINUSA => 1`3
    AMINUSB => 2`3
    APLUSB  => 3`3
    AXORB   => 4`3
    AORB    => 5`3
    AANDB   => 6`3
    MAX     => 7`3
}

#subruledef source {
    ADRH => 0`3
    ADRL => 1`3
    A    => 2`3
    Y    => 3`3
    ;MEM  => 4`3 to read from memory use MEM[] syntax
    CNST => 5`3
}

#subruledef destination {
    ADRH => 0`3
    ADRL => 1`3
    A    => 2`3
    ;Y    => 3`3 to write to Y use calc instruction
    ;MEM  => 4`3 to write to memory use MEM[] syntax
    ;IR   => 5`3 to write to IR use lir instruction
}


#subruledef instruction {
    ;                                          1     aluf   const   src   dst   adrsrc
    mov {src: source},   {dst: destination} => 1`1 @  0`3 @   0`4 @ src @ dst @    0`1
    mov {val: i4},       {dst: destination} => 1`1 @  0`3 @   val @ 5`3 @ dst @    0`1
    mov {src: source},   MEM[ADRREG]        => 1`1 @  0`3 @   0`4 @ src @ 4`3 @    0`1
    mov {val: i4},       MEM[ADRREG]        => 1`1 @  0`3 @   val @ 5`3 @ 4`3 @    0`1
    mov {src: source},   MEM[{adr: u4}]     => 1`1 @  0`3 @   adr @ src @ 4`3 @    1`1
    mov MEM[ADRREG],     {dst: destination} => 1`1 @  0`3 @   0`4 @ 4`3 @ dst @    0`1
    mov MEM[{adr: u4}],  {dst: destination} => 1`1 @  0`3 @   adr @ 4`3 @ dst @    1`1
    clc {aluf: alufnct}, {src: source}      => 1`1 @ aluf @   0`4 @ src @ 3`3 @    0`1
    clc {aluf: alufnct}, {val: i4}          => 1`1 @ aluf @   val @ 5`3 @ 3`3 @    0`1
    clc {aluf: alufnct}, MEM[ADRREG]        => 1`1 @ aluf @   0`4 @ 4`3 @ 3`3 @    0`1
    clc {aluf: alufnct}, MEM[{adr: u4}]     => 1`1 @ aluf @   adr @ 4`3 @ 3`3 @    1`1
    lir {val: u4}:{src: source}             => 1`1 @  0`3 @   val @ src @ 5`3 @    0`1
    lir {val: u4}:MEM[ADRREG]               => 1`1 @  0`3 @   val @ 4`3 @ 5`3 @    0`1 
}

#ruledef {
    jmp {condition: cond}, {addr: u12} => 0`1 @ condition @ addr
    {instruction: instruction}         => instruction @ 0`1
    {instruction: instruction} / INCADR => instruction @ 1`1
    INCADR                             => asm {
        mov A, A / INCADR
    } 
}

#bankdef entrypoints {
    bits = 16
    addr = 0
    addr_end = 0x100
    outp = 0
    fill = true
}

#bankdef ucode {
    bits = 16
    addr = 0x100
    addr_end = 0x1000
    outp = 16 * 256
    fill = true
}