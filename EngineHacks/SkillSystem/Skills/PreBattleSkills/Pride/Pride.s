.thumb
.equ PrideID, SkillTester+4
.equ gBattleData, 0x203A4D4

push	{r4-r7, lr}
mov	r4, r0 @attacker
mov	r5, r1 @defender

ldrb	r3, =gBattleData
ldrb	r3, [r3]
cmp		r3, #4
beq		End

ldr	r0, SkillTester
mov	lr, r0
mov	r0, r4
ldr	r1, PrideID
.short	0xf800
cmp	r0, #0
beq	End

ldrb r0, [r4, #0x08]
ldr r1, [r4,#4] @class
mov r2,#41
ldrb r1,[r1,r2] @Load Class Ability
mov r2,#0x1 @Check for Promotion
and r1,r2
cmp r1,r2
bne Next1 @If not promoted, skip +20
add r0, #0x14 @add 20 levels
Next1:

ldrb r1, [r5, #0x08]
ldr r2, [r5,#4] @class
mov r3,#41
ldrb r2,[r2,r3] @Load Class Ability
mov r3,#0x1 @Check for Promotion
and r2,r3
cmp r2,r3
bne Next2 @If not promoted, skip +20
add r1, #0x14 @add 20 levels
Next2:

cmp r0, r1
bgt End @If unit level is higher, skip bonus

mov	r0, #0x5A
ldrh	r1, [r4,r0]	@load hit
add	r1, #0x04	@4 Damage
strh	r1, [r4,r0]     @store

End:
pop	{r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD PrideID
