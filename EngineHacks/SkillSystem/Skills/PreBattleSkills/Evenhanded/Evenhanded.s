.thumb
.equ EvenhandedID, SkillTester+4
.equ gBattleData, 0x203A4D4

push	{r4, lr}
mov	r4, r0 @attacker
mov	r5, r1 @defender

ldrb	r3, =gBattleData
ldrb	r3, [r3]
cmp		r3, #4
beq		End

@check if turn is even
ldr	r0,=#0x202BCF0
ldrh	r0, [r0,#0x10]
mov	r1, #0x01
and	r0, r1
cmp	r0, #0x00
bne	End

ldr	r0, SkillTester
mov	lr, r0
mov	r0, r4
ldr	r1, EvenhandedID
.short	0xf800
cmp	r0, #0
beq	End

mov	r0, #0x5A
ldrh	r1, [r4,r0]
add	r1, #0x04	@4 Damage
strh	r1, [r4,r0]

End:
pop	{r4, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD EvenhandedID
