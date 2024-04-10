# chARM v3 Technical Reference

For CS 350C

[Find any mistakes? Contribute here](https://github.com/nickorlow/charmv3-reference)


## Instructions

---

### LDUR

[LoaD Unscaled Register](https://developer.arm.com/documentation/dui0801/g/A64-Data-Transfer-Instructions/LDUR)

###### Usage
```
    LDUR Xt, [Xn|SP{,#simm9}] 
```

Read 64 bit word at memory address stored in `Xn|SP` optionally offset by `#simm9` into `Xt`. 

---

### LDP

[LoaD Pair of registers](https://developer.arm.com/documentation/dui0801/g/A64-Data-Transfer-Instructions/LDP)
[ISA Reference Page](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/LDP--Load-Pair-of-Registers-?lang=en)

##### Usage (Post Index)
```
    LDP Xt1, Xt2, [Xn|SP], #simm7
```

Read 2 64 bit words at memory address `[Xn|SP]` into `Xt1` and `Xt2`. 
The word at `[Xn|SP]` is loaded into `Xt1`, and the word immediately after`[Xn|SP]`
is loaded into `Xt2`. `Xn|SP` is then incremented by `#simm7`

*Note: ARM supports multiple addressing modes, chARMv3 only supports Post-Index Addressing*

---

### STUR 

[STore Unscaled Register](https://developer.arm.com/documentation/dui0801/g/A64-Data-Transfer-Instructions/STUR)

#### Usage
```
    STUR Xt, [Xn|SP{, #simm9}]
```

Write 64 bit word stored in `Xt` into the memory address stored in `Xn|SP`, offset 
by `#simm9`

---

###  STP

[STore Pair of registers](https://developer.arm.com/documentation/dui0801/h/A64-Data-Transfer-Instructions/STP)

[ISA Reference Page](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/STP--Store-Pair-of-Registers-)

#### Usage 
```
    STP Xt1, Xt2, [Xn|SP], #simm7
```

Write 2 64 bit words to memory address stored at memory address `[Xn|SP]` from 
`Xt1` and `Xt2`. The data in `Xt1` is written at memory address `[Xn|SP]`, and 
the data in `Xt2` is written at the next word in memory after `[Xn|SP]`.

*Note: ARM supports multiple addressing modes, chARMv3 only supports Post-Index Addressing*

---

### MOVK 

[MOVe 16 bit immediate, Keep other bits unchanged](https://developer.arm.com/documentation/dui0802/b/MOVK)

[ISA Reference Page](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/MOVK--Move-wide-with-keep-)

#### Usage
```
    MOVK Xd, #imm16{, LSL #hw*16} 
```

Move the 16 bits specified in `#imm16` into `Xd` without replacing any of the other bits. 
The bits are placed at `Xd[hw*16 +: 16]` (verilog syntax) (i.e. if hw is zero, replace 
the lsb 16 bits, if it is one, replace the next most significant bits etc..).

---

## MOVZ

[MOVe with Zero](https://developer.arm.com/documentation/dui0801/g/A64-General-Instructions/MOVZ)

[ISA Reference Page](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/MOVZ--Move-wide-with-zero-)

#### Usage
```
    MOVZ Xd, #imm16{, LSL #hw*16}
```

Same as MOVK, except all other bits in register are zeroed out.

---

## ADR 

[form pc-relative ADdRess](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/ADR--Form-PC-relative-address-)

#### Usage
```
    ADR Xd, #simm19
```

Load address `PC + #simm19` into register `Xd`

---

## ADRP

[form pc-relative ADdRess to 4kb Page](https://developer.arm.com/documentation/dui0801/h/A64-General-Instructions/ADRP)

#### Usage
```
    ADRP Xd, #simm19
```

Loads the base address of the page for address `PC + #simm19`. Same as `{{PC + #simm19}[63:12], 12'h000}` (verilog syntax).

---

### CSINC

[Conditional Select INCrement](https://developer.arm.com/documentation/dui0802/b/A64-General-Instructions/CSINC)

#### Usage
```
    CSINC Xd, Xn, Xm, cond
```

Copy data from either `Xn` or `Xm + 1` to `Xd` based on `cond`. `Xn` is copied
if `cond` evaluates to true, otherwise `Xm + 1` is copied. 
Same as `Xd = cond ? Xn : Xm + 1`.


---

### CINC

[Conditional INCrement](https://developer.arm.com/documentation/dui0802/b/A64-General-Instructions/CINC)

Alias to CSINC where `CINC Xd, Xn, cond` maps to `CSINC Xd, Xn, Xn, cond`

---

### CSET

[Conditional SET](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/CSET--Conditional-Set--an-alias-of-CSINC-)

Alias to CSINC where `CSET Xd, cond` maps to `CSINC Xd, XZR, XZR, !cond`.

---

### CSINV

[Conditional Select INVert](https://developer.arm.com/documentation/ddi0602/2023-09/Base-Instructions/CSINV--Conditional-Select-Invert-)

#### Usage
```
    CSINV Xd, Xn, Xm, cond
```

Copy data from either `Xn` or `~Xm` to `Xd` based on `cond`. `Xn` is copied 
if `cond` evaluates to true, and `~Xm` is copied otherwise.
Same as `Xd = cond ? Xn : ~Xm`.

---

### CINV 

[Conditional INVert](https://developer.arm.com/documentation/dui0802/a/A64-General-Instructions/CINV?lang=en)

Alias to CSINV where `CINV Xd, Xn, cond` maps to `CSINV Xd, Xn, Xn, cond`;

--- 

### CSETM

[Conditional SET Mask](https://developer.arm.com/documentation/dui0801/l/A64-General-Instructions/CSETM--A64-?lang=en)

Alias to CSINV where `CSETM Xd, cond` maps to `CSINV Xd, XZR, XZR, !cond` (`XZR` is the zero register)

---

### CSNEG

[Conditional Select NEGation (2's Compliment)](https://developer.arm.com/documentation/dui0801/h/A64-General-Instructions/CSNEG)

#### Usage 
```
    CSNEG Xd, Xn, Xm, cond
```

Copy data from either `Xn` or `~Xm + 1` to `Xd` based on `cond`. `Xn` is copied if 
`cond` evaluates to true, and `Xm` is copied otherwise.
Same as `Xd = cond ? Xn : (~Xm+1)`

---

### CNEG

[Conditional Negate](https://developer.arm.com/documentation/dui0801/g/A64-General-Instructions/CNEG)

Alias to CSNEG where `CNEG Xd, Xn, cond` maps to `CSNEG Xd, Xn, Xn, cond`

---

### CSEL

[Conditional SELect](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/CSEL--Conditional-Select-)

#### Usage
```
    CSEL Xd, Xn, Xm, cond
```

Copy data from either `Xn` or `Xm` to `Xd` based on `cond`. `Xn` is copied if 
`cond` evaluates to true, otherwise `Xm` is copied.
Same as `Xd = cond ? Xn : Xm`

---

### ADD

[ADD immediate](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/ADD--immediate---Add--immediate--)

#### Usage
```
    ADD Xd, Xn, #imm12 
```

Adds the values of `Xn` and `#imm12` and stores them in `Xd`

**Does not update condition code flags**

*Note: ARM allows an optional shift to be specified, but chARMv3 does not*

---


### SUB

[SUBtract immediate](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/SUB--immediate---Subtract--immediate--)

#### Usage
```
    SUB Xd, Xn, #imm12
```

Subtracts the values of `Xn` and `#imm12` and stores them in `Xd`

**Does not update condition code flags**

*Note: ARM allows an optional shift to be specified, but chARMv3 does not*

---

### ADDS 

[ADD Set condition flags](https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference/ARM-general-data-processing-instructions/ADD--SUB--RSB--ADC--SBC--and-RSC)

#### Usage
```
    ADDS Xd, Xn, Xm
```

Adds the values of `Xn` and `Xm` and stores them in `Xd`. Updates condition code flags.

---

### SUBS 

[ADD Set condition flags](https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference/ARM-general-data-processing-instructions/ADD--SUB--RSB--ADC--SBC--and-RSC)

#### Usage
```
    SUBS Xd, Xn, Xm
```

Subtracts the value of `Xm` from `Xn` and stores them in `Xd`. Updates condition code flags.

---

### CMP 

[CoMPare](https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference/ARM-general-data-processing-instructions/CMP-and-CMN)

Alias to SUBS where `CMP Xn, FSO` maps to `SUBS XZR, Xn, FSO` *?*

---

### MVN

[MoVe Not](https://developer.arm.com/documentation/dui0068/b/ARM-Instruction-Reference/ARM-general-data-processing-instructions/MOV-and-MVN)

### Usage
```
    MVN Xd, Xm
```

Copies `~Xm` into `Xd`

**Does not update condition code flags**

---

### ORR

[logical ORR](https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/orr)

#### Usage
```
    ORR Xd, Xn, Xm
```

Copies `Xm | Xn` to `Xd`

**Does not update condition code flags**

---

### EOR

[logical Exclusive OR](https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/eor)

#### Usage
```
    EOR Xd, Xn, Xm
```

Copies `Xm ^ Xn` to `Xd`

**Does not update condition code flags**

---

### AND 

[AND](https://developer.arm.com/documentation/dui0068/latest/Thumb-Instruction-Reference/Thumb-general-data-processing-instructions/AND--ORR--EOR--and-BIC)

#### Usage
```
    AND Xd, Xm
```
Stores the value of `Xd & Xm` in `Xd`


**Does not update condition code flags**

---

### ANDS

[AND (Set condition flags)](https://developer.arm.com/documentation/dui0802/b/A64-General-Instructions/ANDS--shifted-register-)

#### Usage
```
    ANDS Xd, Xn, Xm
```

Sets `Xd` to the value of `Xn & Xm`. Updates condition code flags.

*Note: ARM allows an optional shift to be specified, but chARMv3 does not*

---

### TST 

[TeST](https://developer.arm.com/documentation/dui0802/a/A64-General-Instructions/TST--shifted-register-)

#### Usage
```
    TST Xn, Xm
```

Alias for ANDS, `TST Xn, Xm` gets mapped to `ANDS XZR, Xn, Xm`

---

### UBFM

[Unsigned BitField Move (immediate)](https://developer.arm.com/documentation/dui0801/g/A64-General-Instructions/UBFM)

#### Usage *(?)*
```
    UBFM Xd, Xn, #imm12r, #imm12s
```

`#imm12r` is the high 6 bits of `#imm12`, and `#imm6s` is the lower 6 bits of `#imm12`.

If `#imm12s >= #imm12r`, then `#imm12s-#imm12r+1` bits are copied starting from 
bit position `#imm12r` in `Xn` to the least significant bits of `Xd`.

If `#imm12s < #imm12r`, then the `#imm12s+1` least significant bits of `Xn` 
are copied to bit position `64-#imm12r` of `Xd` 

All bits outside the bitfield in both cases are set to 0.

---

### LSL

[Logical Shift Left (immediate)](https://developer.arm.com/documentation/dui0473/m/arm-and-thumb-instructions/lsl)

Alias for `UBFM`, `LSL Xd, Xn, #imm12` is mapped to `UBFM Xd, Xn, #(-#imm6r % 64), #(63 - #imm6r)`

---

### LSR

[Logical Shift Right (immediate)](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/LSR--immediate---Logical-Shift-Right--immediate---an-alias-of-UBFM-)

Alias for `UBFM`, `LSR Xd, Xn, #imm12` is mapped to `UBFM Xd, Xn, #imm6r, #63`

---

### SBFM

[Signed BitField Move (immediate)](https://developer.arm.com/documentation/ddi0602/2024-03/Base-Instructions/SBFM--Signed-Bitfield-Move-)

#### Usage *(?)*
```
    UBFM Xd, Xn, #imm12r, #imm12s
```

`#imm12r` is the high 6 bits of `#imm12`, and `#imm6s` is the lower 6 bits of `#imm12`.

If `#imm12s >= #imm12r`, then `#imm12s-#imm12r+1` bits are copied starting from 
bit position `#imm12r` in `Xn` to the least significant bits of `Xd`.

If `#imm12s < #imm12r`, then the `#imm12s+1` least significant bits of `Xn` 
are copied to bit position `64-#imm12r` of `Xd` 

All bits below the bitfield are set to 0, and the bits above the bitfield are 
all set to the MSB of the bitfield

---

### ASR 

[Arithmetic Shift Right (immediate)](https://developer.arm.com/documentation/ddi0602/2023-09/Base-Instructions/ASR--immediate---Arithmetic-Shift-Right--immediate---an-alias-of-SBFM-)

Alias of `SBFM`, `ASR Xd, Xn, #imm12` maps to `SBFM Xd, Xn, #imm12r, #63`

---

### B

[Branch (unconditional)](https://developer.arm.com/documentation/ddi0596/2020-12/Base-Instructions/B--Branch-)

#### Usage
```
    B #simm26
```

Set `PC` to `PC + #simm26*4`

---

### BR

[Branch to Register (unconditional)](https://developer.arm.com/documentation/ddi0596/2020-12/Base-Instructions/BR--Branch-to-Register-)

#### Usage
```
    BR Xn
```

Set `PC` to `Xn`

---

### B.cond

[Branch CONDitionally](https://developer.arm.com/documentation/ddi0596/2020-12/Base-Instructions/B-cond--Branch-conditionally-)

#### Usage
```
    B.cond #simm19
```

If `cond` evaluates to true, set `PC` equal to `PC + #simm19*4`

---

### BL 

[Branch with Link](https://developer.arm.com/documentation/ddi0596/2020-12/Base-Instructions/BL--Branch-with-Link-)

#### Usage 
```
    BL #simm26
```

Set `PC = PC + #simm26*4` and set `X30` to `PC + 4`. Note that the `PC` value used in 
the computation of `X30`'s value is *before* `#simm26` is added. Hint is provided 
that this is a subroutine call.

---

### BLR 

[Branch with Link to Register](https://developer.arm.com/documentation/ddi0596/2020-12/Base-Instructions/BLR--Branch-with-Link-to-Register-)

#### Usage 
```
    BLR Xn
```

Set `PC = Xn` and set `X30` to `PC + 4`. Note that the `PC` value used in 
the computation of `X30`'s value is *before* `PC` is set to `Xn`. Hint is provided 
that this is a subroutine call.

---

### CBNZ

[Compare and Branch NonZero](https://developer.arm.com/documentation/ddi0596/2020-12/Base-Instructions/CBNZ--Compare-and-Branch-on-Nonzero-)

#### Usage
```
    CBNZ Xd, #simm19
```

If the value of `Xd` is nonzero, set `PC` to `PC + #imm19*4`

---

### CBZ

[Compare and Branch Zero](https://developer.arm.com/documentation/ddi0596/2020-12/Base-Instructions/CBZ--Compare-and-Branch-on-Zero-)

#### Usage
```
    CBZ Xd, #simm19
```

If the value of `Xd` is zero, set `PC` to `PC + #imm19*4`

---

### RET 

[RETurn from subroutine](https://developer.arm.com/documentation/ddi0596/2020-12/Base-Instructions/RET--Return-from-subroutine-)

#### Usage 
```
    RET Xn
```

Set `PC` to `Xn`. When branching, a hint is specified that this is a subroutine return.

---

### HLT

[HaLT](https://developer.arm.com/documentation/dui0802/b/A32-and-T32-Instructions/HLT)

#### Usage
```
    HLT
```

Stops the processor. Optionally can kick the processor into a debugging state.

---

### NOP

[No OPeration](https://developer.arm.com/documentation/dui0068/latest/ARM-Instruction-Reference/ARM-pseudo-instructions/NOP-ARM-pseudo-instruction)

#### Usage
```
    NOP
```

Does the same thing as Nick's hook throw most of the time (Nothing).
