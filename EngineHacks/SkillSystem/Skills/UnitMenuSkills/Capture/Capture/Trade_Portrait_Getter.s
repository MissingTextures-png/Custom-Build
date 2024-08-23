.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

@r0=char data
push	{r4, r14}

@Has Portait?
ldr		r1, [r0]		@RAMUnti
ldrh	r1, [r1, #0x6]	@RAMUnit->Unit->Portrait
cmp		r1, #0x0
bne		NormalEnd

mov		r3,	r0	@RAMUnit
ldr		r4, GenericPortraitTable
sub		r4, #0x4

Loop:
add		r4, #0x04
ldr		r0, [r4]
cmp		r0, #0x0
beq		NotFound

CheckUnit:
ldrb	r0, [r4, #0x2]	@GenericPortraitTable->UnitID
cmp		r0,	#0x0
beq		CheckClass
ldr		r1, [r3]
ldrb	r1, [r1, #0x4] @RAMUnit->Unit->ID
cmp		r0, r1
bne		Loop

CheckClass:
ldrb	r0, [r4, #0x3]	@GenericPortraitTable->UnitID
cmp		r0, #0x0
beq		Found
ldr		r1, [r3, #0x4]
ldrb	r1, [r1, #0x4] @RAMUnit->Class->ID
cmp		r0, r1
bne		Loop

Found:
ldrh	r0, [r4, #0x0]	@GenericPortraitTable->Portrait
b		Exit

NotFound:
mov		r0,	#0x01	@Portrait 1
b		Exit

NormalEnd:
blh		0x080192B8	@PortraitGetter

Exit:
pop		{r4}
pop		{r1}
bx		r1

.ltorg
.align 4
GenericPortraitTable:
@0	portrait
@2	Unit
@3	Class
