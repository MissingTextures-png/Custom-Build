.thumb

.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ StalwartID, SkillTester+4

@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data

push	{r4-r7,lr}
mov		r4, r0 		@attacker
mov		r5, r1 		@defender

@check for skill
mov		r0,r4
ldr		r1,StalwartID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		End

@check if status is healthy
CheckStatus:
mov r0,#0x30
ldrb r1,[r4,r0]
cmp r1,#0
beq End

@if not, set it to healthy
mov r1,#0
strb r1,[r4,r0]

End:
pop		{r4-r7}
pop		{r0}
bx		r0
.align
.ltorg
SkillTester:
@ItemTable
@StalwartID
