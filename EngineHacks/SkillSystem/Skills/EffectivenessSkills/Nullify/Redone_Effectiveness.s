.thumb

@r0=attacker's item id, r1=defender battle struct

.equ NullifyID, SkillTester+4
.equ ShieldSkillList, NullifyID+4

push	{r4-r7,r14}
mov		r4,r0
mov		r5,r1
ldr		r0,[r5,#0x4]
cmp		r0,#0
beq		RetFalse
mov		r0,r4
ldr		r3,=#0x80176D0		@get effectiveness pointer
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		RetFalse			@if weapon isn't effective, end
ldr		r1,[r5,#0x4]
mov		r6,#0x50
ldr		r6,[r1,r6]			@class weaknesses


@ used with Dragz's Effectiveness Items
/*
push 	{r0-r3}
mov 	r0,r5
bl 		GetUnitDebuffEntry 
ldr 	r1, =FlammableBitOffset_Link
ldr 	r1, [r1] 
bl 		CheckBit 
cmp		r0,#0
beq		DousedCheck
mov		r2, #0x40
orr		r6, r2

DousedCheck:
mov 	r0,r5
bl 		GetUnitDebuffEntry 
ldr 	r1, =DousedBitOffset_Link
ldr 	r1, [r1] 
bl 		CheckBit 
cmp		r0,#0
beq		LevitatingCheck
mov		r2, #0x80
orr		r6, r2

LevitatingCheck:
mov 	r0,r5
bl 		GetUnitDebuffEntry 
ldr 	r1, =LevitatingBitOffset_Link
ldr 	r1, [r1] 
bl 		CheckBit 
cmp		r0,#0
beq		DebuffEnd
mov		r2, #0x04
orr		r6, r2
DebuffEnd:
pop 	{r0-r3}
*/

cmp		r6,#0
beq		RetFalse			@if class has no weaknesses, end

mov		r4,r0				@save effectiveness ptr
mov		r7,#0				@inventory slot counter
ProtectiveItemsLoop:
lsl		r0,r7,#1
add		r0,#0x1E
ldrh	r0,[r5,r0]
cmp		r0,#0
beq		EffectiveWeaponLoop
mov		r1,#0xFF
and		r0,r1
ldr		r3,=#0x80177B0		@get_item_data
mov		r14,r3
.short	0xF800
ldr		r1,[r0,#0x8]		@weapon abilities
mov		r2,#0x80
lsl		r2,#0x7				@delphi shield bit, aka 'protector item'
tst		r1,r2
beq		NextItem
ldr		r1,[r0,#0x10]		@pointer to classes it protects
cmp		r1,#0
beq		NextItem
ldrh	r1,[r1,#2]
bic		r6,r1				@remove bits that are protected from the class weaknesses bitfield
cmp		r6,#0
beq		RetFalse
NextItem:
add		r7,#1
cmp		r7,#4
ble		ProtectiveItemsLoop

EffectiveWeaponLoop:
ldrh	r1,[r4,#2]			@bitfield of types this weapon is effective against
cmp		r1,#0
beq		RetFalse
and		r1,r6				@see if they have bits in common
cmp		r1,#0
bne		NullifyCheck
add		r4,#4
b		EffectiveWeaponLoop

NullifyCheck:
mov		r0,r5
ldr		r1,NullifyID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
bne		RetFalse

mov		r7,#0				@shield skill counter

ShieldSkillLoop:
ldr     r1,ShieldSkillList  @Load in the list of Shield skills
ldrh    r1,[r1,r7]          @Load in the shield skill to check
cmp     r1,#0               @Have we reached the end of the list?
beq     RetCoefficient      @Yes, so we exit the loop

mov     r0,r5               @Copy over the defender
ldr		r3,SkillTester      @Load the address for skill tester
mov		r14,r3              @Load the skill tester address into the link register
.short	0xF800              @Navigate to the skill tester address
cmp		r0,#0               @Check if the user has the skill (0 means no, 1 means yes)
beq     NextSkill

mov     r1, #2
add     r1, r7
ldr     r0,ShieldSkillList  @Load in the list of Shield skills
ldrh    r0,[r0,r1]          @Load in the type protected by the shield skill we just checked
bic		r6,r0				@Remove bits that are protected from the class weaknesses bitfield
cmp		r6,#0               @Does the class have any weaknesses left?
beq		RetFalse            @No, so the effective damage gets nullified

ldrh    r0,[r4,#2]          @Bitfield of types this weapon is effective against
tst     r0, r6              @After removing the type protected by the shield's skill, do class and weapon still share any type?
beq     EffectiveWeaponLoop @No, so we go back to EffectiveWeaponLoop in case we're dealing with something like Nidhogg

NextSkill:
add     r7,#4               @Prepare to load the next entry of ShieldSkillList
b       ShieldSkillLoop

RetCoefficient:
ldrb	r0,[r4,#0x1]		@coefficient
b		GoBack
RetFalse:
mov		r0,#0
GoBack:
pop		{r4-r7}
pop		{r1}
bx		r1

.ltorg
SkillTester:
@POIN SkillTester
@WORD NullifyID
@POIN ShieldSkillList
