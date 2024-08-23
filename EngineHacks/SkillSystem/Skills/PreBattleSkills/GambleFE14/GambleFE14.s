@Gamble: Inflicts Hit -10, grants Crit +10.

.equ GambleFE14ID, SkillTester+4

.thumb

push {r4, lr} 

mov	r4,r0		@get user into r4 for later

@has GambleFE14
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, GambleFE14ID
.short 0xf800
cmp r0, #0
beq End

@add 10 crit
mov r1, #0x66
ldrh r0, [r4, r1] @crit
add r0, #10
strh r0, [r4,r1]

@subtract 10 from hit
mov	r0, #0x60
ldrh	r1, [r4,r0]	@load hit
sub	r1, #10	@subtract 10 from hit
strh	r1, [r4,r0]     @store

End:
pop	{r4}
pop	{r0}
bx	r0

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD GambleFE14ID
