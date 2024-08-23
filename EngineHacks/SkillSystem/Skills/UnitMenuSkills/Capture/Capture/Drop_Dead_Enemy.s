.thumb
.org 0x0
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm


@jumped to from 32234
@r4=action struct
@r5=char data of droppee
@r6=this proc

@r0 = Unit Struct
push {r0} @ramunit
ldrb r1, [r4, #0x13] @ pointer:0203A96B (ActionData@gActionData.xOther )
ldrb r2, [r4, #0x14] @ pointer:0203A96C (ActionData@gActionData.yOther )
blh 0x08018370   @UpdateRescuingData
pop {r3} @ramunit

ldrb	r0,[r5,#0x13]
cmp		r0,#0x1		@HP 1 <=
bgt		GoBack

@ldr		r3, =0x03004E50 @CurrentUnit @FE8U
@ldr		r3, [r3]
ldrb	r0,[r3,#0xB]	@myself
ldrb	r1,[r5,#0xB]	@target
blh 0x08024D8C   @AreUnitsAllied
cmp		r0, #0x1
beq		GoBack

ldr r0, [r5]
ldrb r0, [r0, #0x4] @EnemyUnitID
blh 0x080835dc   @DisplayDeathQuoteForChar

ldr		r0,[r5,#0xC]
mov		r1,#0xD @make them dead
orr		r0,r1
str		r0,[r5,#0xC]

mov     r0, #0x0
str		r0, [r5]			@Clear EnemyStruct
strb	r0, [r5, #0x13]		@HP=0

@Exit ActionDrop function
ldr		r3, =0x08032262|1
bx		r3

GoBack:
ldr r3, =0x0803223C|1
bx  r3
