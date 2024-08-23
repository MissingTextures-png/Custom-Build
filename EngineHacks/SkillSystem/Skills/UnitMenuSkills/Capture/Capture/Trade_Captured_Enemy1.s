.thumb
.org 0x0
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

@branched to from 25224
@return true if the two people can trade
@r5 has a pointer to the target's char data ptr, r4=current char's data ptr

push	{r14}
@ldr	r0, [r5]
ldrb	r0,[r0,#0xB]
ldrb	r1,[r4,#0xB]
blh		0x08024DA4	@IsSameAllegience
cmp		r0,#0x1
beq		TrueReturn			@if they're already on the same side, no need to check if captured

@Check Enemy
ldr		r0, [r5]
ldrb	r0, [r0,#0xB]
ldrb	r1, [r4,#0xB]
blh		0x08024D8C   @AreUnitsAllied
cmp		r0,#0x1
beq		FalseReturn			@Target units is NPC

ldrb	r2, [r4,#0x13] @Enemy->HP
cmp		r2, #0x1		@HP 1 <=
bgt		FalseReturn

ldrb	r1, [r4,#0x1B] @Enemy->Trv
cmp		r1, #0x0
beq		FalseReturn

@Check Trv is PlayerUnit
ldr		r0, [r5]
ldrb	r0, [r0,#0xB]
blh		0x08024DA4	@IsSameAllegience
cmp		r0, #0x0
beq		FalseReturn


TrueReturn:
mov		r0,#0x1
b		Exit

FalseReturn:
mov		r0,#0x0

Exit:
pop		{r1}
bx		r1
