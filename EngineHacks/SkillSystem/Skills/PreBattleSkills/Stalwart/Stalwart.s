.thumb

.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ ItemTable, SkillTester+4
.equ StalwartID, ItemTable+4

@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data

push	{r4-r7,lr}
mov		r4, r0 		@attacker
mov		r5, r1 		@defender

@check for skill
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, StalwartID
.short 0xf800
cmp r0, #0
beq End  

@check if the defending unit has a staff
mov r3,#0x4A    @equipped item and uses before battle     
ldrb r2,[r5,r3] 
mov r3,#0x24     @size of item struct (per entry)
mul r2,r3
ldr r3,ItemTable
add r2,r3
mov r3,#0x7     @weapon type
ldrb r6,[r2,r3] @load the weapon type
cmp r6,#4       @check if staff
beq SetHitToZero
mov r3,#0x1F    @weapon effect ID
ldrb r0,[r2,r3] @load the value
cmp r0,#1       @check if it's 1 (poison effect)
beq SetHitToZero
cmp r0,#5       @check if it's 5 (stone effect)
beq SetHitToZero
b   End

SetHitToZero:
mov r0,#0x60    @get hit rate short
ldrh r1,[r5,r0] @load its value
mov r1,#0       @set it to 0
strh r1,[r5,r0] @store it

End:
pop		{r4-r7}
pop		{r0}
bx		r0
.align
.ltorg
SkillTester:
@ItemTable
@StalwartID
