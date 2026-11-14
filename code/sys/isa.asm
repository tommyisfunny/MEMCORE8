
#ruledef {
    ldr {reg: u8}, #{val: i8}                   => $01`8 @ reg @ val
    ldr {reg: u8}, [{adr: u16}]                 => $02`8 @ reg @ $le(adr)
    ldr {dst: u8}, [{basereg: u8}]+{offset: u8} => $03`8 @ dst @ basereg  @ offset
    lrw {reg: u8}, #{val: i16}                  => $04`8 @ reg @ $le(val)
    lrw {reg: u8}, [{adr: u16}]                 => $05`8 @ reg @ $le(adr)
    lrw {dst: u8}, [{basereg: u8}]+{offset: u8} => $06`8 @ dst @ basereg  @ offset

    str {reg: u8}, [{adr: u16}]                 => $07`8 @ reg @ $le(adr)
    str {src: u8}, [{basereg: u8}]+{offset: u8} => $08`8 @ src @ basereg  @ offset
    stw {reg: u8}, [{adr: u16}]                 => $09`8 @ reg @ $le(adr)
    stw {src: u8}, [{basereg: u8}]+{offset: u8} => $0A`8 @ src @ basereg  @ offset

    mov {src: u8}, {dst: u8}                    => $0B`8 @ src @ dst
    mvw {src: u8}, {dst: u8}                    => $0C`8 @ src @ dst

    inc {reg: u8}                               => $0D`8 @ reg
    inw {reg: u8}                               => $0E`8 @ reg

    dec {reg: u8}                               => $0F`8 @ reg
    dew {reg: u8}                               => $10`8 @ reg

    add {dst: u8}, {src: u8}                    => $11`8 @ dst @ src
    adw {dst: u8}, {src: u8}                    => $12`8 @ dst @ src
}


#bankdef code {
    bits =  8
    addr = 0x100
    addr_end = 0x10000
    outp = 8 * 0x100
}


pc = 4
pcl = 4
pch = 5

sp = 6
spl = 6
sph = 7

fp = 8
fpl = 8
fph = 9

a0 = $a
a1 = $b
a2 = $c
a3 = $d
a4 = $e
a5 = $f
a6 = $10
a7 = $11

t0 = $12
t1 = $13
t2 = $14
t3 = $15
t4 = $16
t5 = $17
t6 = $18
t7 = $19

s0 = $1a
s1 = $1b
s2 = $1c
s3 = $1d
s4 = $1e
s5 = $1f
s6 = $20
s7 = $21

#bank code
;jmp main
