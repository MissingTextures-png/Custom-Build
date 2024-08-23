.thumb
.org 0x0
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

@branched to 25298
@checks if the rescued person can be traded with, and sets flags, r1=char data, r2=allegiance byte
@r0=char data of rescuee

push	{r6,r14}
mov		r6, r0			@rescuee enemy ramunit
ldrb	r0, [r6,#0xB]
ldr		r1, [r5]
ldrb	r1, [r1,#0xB]	@myself
blh		0x08024DA4	@IsSameAllegience
cmp		r0,#0x1
beq		TrueReturn

@Check Enemy
ldrb	r0, [r6,#0xB]	@rescuee enemy ramunit
ldr		r1, [r5]
ldrb	r1, [r1,#0xB]	@myself
blh		0x08024D8C   @AreUnitsAllied
cmp		r0,#0x1
beq		FalseReturn			@Target units is NPC

@Check Enemy HP <= 1
ldrb	r0,[r6,#0x13]
cmp		r0,#0x1		@HP 1 <=
bgt		FalseReturn

ldrb	r1, [r6,#0x1B] @Enemy->Trv
cmp		r1, #0x0
beq		FalseReturn


TrueReturn:
mov		r0,#0x1
b		Exit

FalseReturn:
mov		r0,#0x0

Exit:
mov		r1, r6       @Restore r1

mov		r2, #0xb     @Set the troop table to r2
ldsb	r2, [r1, r2]

pop		{r6}
cmp		r0,#0x0   @I will only check for success or failure due to the immediate beq
pop		{r3}
bx		r3
