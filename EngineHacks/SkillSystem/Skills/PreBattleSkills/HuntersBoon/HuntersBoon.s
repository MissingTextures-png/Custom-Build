.thumb
.equ HuntersBoonID, SkillTester+4
.equ gBattleData, 0x203A4D4
push {r3-r7, lr}

mov		r4, r0 @atkr
mov		r5, r1 @dfdr

ldrb	r3, =gBattleData
ldrb	r3, [r3]
cmp		r3, #4
beq		End

ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, HuntersBoonID
.short 0xf800
cmp r0, #0
beq End

ldrb	r0, [r5, #0x12] @Enemy Max HP
lsr		r0, #1 @Half MHP
ldrb	r1, [r5, #0x13] @Enemy Current HP
cmp		r1,r0
bgt		End @If CHP> MHP, skip

mov		r1, #0x66
ldrh	r0, [r4, r1]
add		r0, #20	@20 Crit
strh	r0, [r4,r1]

End:
pop		{r3-r7}
pop		{r0}
bx		r0

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD HuntersBoonID
