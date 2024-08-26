.thumb
.equ ProdigyID, SkillTester+4
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
ldr	r1, ProdigyID
.short	0xf800
cmp	r0, #0
beq	End

mov	r0, #0x14
ldrb	r0, [r4,r0] @Unit Str
mov	r1, #0x3A
ldrb	r1, [r4,r1] @Unit Mag
add r0, r1 @Unit Str+Mag

mov	r1, #0x14
ldrb	r1, [r5,r1] @Enemy Str
mov	r2, #0x3A
ldrb	r2, [r5,r2] @Enemy Mag
add r1, r2 @Enemy Str+Mag

cmp r0, r1
bgt End @If Unit > Enemy, skip

mov	r0, #0x5A
ldrh	r1, [r4,r0]	@load hit
add	r1, #0x04 @4 Damage
strh	r1, [r4,r0]     @store

End:
pop	{r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD ProdigyID
