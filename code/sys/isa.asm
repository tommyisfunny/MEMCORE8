
#ruledef {
    ldr {reg: u8}, #{val: i8} =>  1`8 @ reg @ val
    ldr {reg: u8}, [{adr: u16}] =>  2`8 @ reg @ $le(adr)
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
