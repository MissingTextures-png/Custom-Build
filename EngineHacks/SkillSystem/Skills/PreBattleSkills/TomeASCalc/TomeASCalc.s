.thumb
.equ ItemTable, SkillTester+4
.equ TomeASCalcID, ItemTable+4

.macro blh to, reg
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

SkillCheck:
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, TomeASCalcID
.short 0xf800
cmp r0, #0
beq End

mov r0, #0x50
ldrb r0, [r4, r0]
cmp		r0, #5			@Check if anima
beq		IsTome
cmp		r0, #6			@Check if light
beq		IsTome
cmp		r0, #7			@Check if dark
beq		IsTome
b		End


@Check inventory
mov	r1, #0x1E @Slot 1

CheckIfTome:
ldrb	r0, [r4, r1]	@Slot weapon type
mov		r5, #0x36
mul		r5, r0
ldr		r6, ItemTable
add		r6, r5
ldrb 	r0, [r6, #0x07]
cmp		r0, #5			@Check if anima
beq		IsTome
cmp		r0, #6			@Check if light
beq		IsTome
cmp		r0, #7			@Check if dark
beq		IsTome
b		End

IsTome:
mov r1, #0x15		@Get Attacker's skill
ldrh r0, [r4, r1]
lsr r0, #2		@Divide by 4
mov r1, #0x5E		@Get Attacker's AS
ldrh r2, [r4, r1]
add r2, r0		@Add 1/4 of unit's skill to AS
strh r2, [r4, r1]
b		End

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@POIN SkillTester
@POIN ItemTable
@WORD TomeASCalcID