.thumb

.macro blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.equ StatBoostItem, StatBoostTable+4
.equ StatBoostTextTable, StatBoostItem+4

.equ RemoveUnitBlankItems, 0x8017984
.equ ValidateUnitItem, 0x08018994
.equ GetItemStatBonusesPtr, 0x080176E8
.equ CheckForStatCaps, 0x080181C8
.equ GetItemIndex, 0x080174EC

push	{r4-r7,lr}
mov		r4, r0
mov		r7, r1
mov		r5, #0x00
lsl		r0, r7, #0x01
mov		r1, r4
add		r1, #0x1E
add		r1, r1, r0
ldrh	r6, [r1, #0x00]
mov		r0, r6
mov		r1, #0xFF
and		r0, r1
cmp		r0, #0x89 @Methis Tome
bne		NotMethisTome

ldr		r0, [r4, #0x0C]
mov		r1, #0x80
lsl		r1, r1, #0x06
orr		r0, r1
str		r0, [r4, #0x0C]
mov		r0, r4
mov		r1, r7
blh		ValidateUnitItem, r2
mov		r0, #0x1D
b		End

NotMethisTome:
ldrb	r1, StatBoostItem
cmp		r1, r0
beq		GetBonusFromTable

mov		r0, r6
blh		GetItemStatBonusesPtr, r2
b		ApplyBonus

GetBonusFromTable:
mov		r0, r6
lsr		r0, #0x08
mov		r1, #0x14
mul		r0, r1
ldr		r1, StatBoostTable
add		r1, r0
mov		r0, r1

ApplyBonus:
ldrb	r1, [r0, #0x00]
ldrb	r2, [r4, #0x12]
add		r1, r1, r2
strb	r1, [r4, #0x12]
ldrb	r1, [r0, #0x00]
ldrb	r2, [r4, #0x13]
add		r1, r1, r2
strb	r1, [r4, #0x13]
ldrb	r1, [r0, #0x01]
ldrb	r2, [r4, #0x14]
add		r1, r1, r2
strb	r1, [r4, #0x14]
ldrb	r1, [r0, #0x02]
ldrb	r2, [r4, #0x15]
add		r1, r1, r2
strb	r1, [r4, #0x15]
ldrb	r1, [r0, #0x03]
ldrb	r2, [r4, #0x16]
add		r1, r1, r2
strb	r1, [r4, #0x16]
ldrb	r1, [r0, #0x04]
ldrb	r2, [r4, #0x17]
add		r1, r1, r2
strb	r1, [r4, #0x17]
ldrb	r1, [r0, #0x05]
ldrb	r2, [r4, #0x18]
add		r1, r1, r2
strb	r1, [r4, #0x18]
ldrb	r1, [r0, #0x06]
ldrb	r2, [r4, #0x19]
add		r1, r1, r2
strb	r1, [r4, #0x19]
ldrb	r1, [r0, #0x07]
ldrb	r2, [r4, #0x1D]
add		r1, r1, r2
strb	r1, [r4, #0x1D]
ldrb	r1, [r0, #0x08]
ldrb	r2, [r4, #0x1A]
add		r1, r1, r2
strb	r1, [r4, #0x1A]
mov		r1, r4
add		r1, #0x3A
ldrb	r2, [r1, #0x00]
ldrb	r3, [r0, #0x09]
add		r2, r2, r3
strb	r2, [r1, #0x00]
mov		r0, r4
blh		CheckForStatCaps, r2

mov		r1, r7
mov 	r2, r4 @get char struct
add 	r2, #0x1E @get start of inventory data
lsl 	r1, r1, #1 @multiply item slot by 2, for length of inventory entry
add 	r2, r1 @r2 = offset of item entry

@delete the item from the inventory

mov		r0, #0
strh	r0, [r2] @store 0x0000 to the item entry in question, thus removing it
mov		r0, r4 @r0 = char struct
blh		RemoveUnitBlankItems, r3 @move everything else up

blh		ValidateUnitItem, r2

mov		r0, r6
blh		GetItemIndex, r2

mov		r0, r1
lsr		r0, #0x08
mov		r1, #0x02
mul		r0, r1
ldr		r1, StatBoostTextTable
add		r1, r0
ldrh	r0, [r1,#0x0]

End:
pop {r4-r7}
pop {r1}
bx r1

.align

.ltorg
.align
StatBoostTable:
@POIN StatBoostTable
@WORD StatBoostItem
@POIN StatBoostTextTable
