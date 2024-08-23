@Concentration: If unit is not adjacent to a foe, grants +2 damage dealt.
.equ AuraSkillCheck, SkillTester+4
.equ ConcentrationID, AuraSkillCheck+4
.thumb
push {r4-r7,lr}
@goes in the battle loop.
@r0 is the attacker
@r1 is the defender
mov r4, r0
mov r5, r1

CheckSkill:
@now check for the skill
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker
ldr r1, ConcentrationID
.short 0xf800
cmp r0, #0
beq Done

@Check if there are adjacent foes
ldr r0, AuraSkillCheck
mov lr, r0
mov r0, r4 @attacker
mov r1, #0
mov r2, #3 @can_trade
mov r3, #1 @range
.short 0xf800
cmp r0, #0
bne Done

mov r0, r4
add     r0,#0x5A    @Move to the attacker's dmg.
ldrh    r3,[r0]     @Load the attacker's dmg into r3.
add     r3,#2    @add 2 to the attacker's dmg.
strh    r3,[r0]     @Store.

Done:
pop {r4-r7}
pop {r0}
bx r0
.align
.ltorg
SkillTester:
@ POIN SkillTester
@ POIN AuraSkillCheck
@ WORD ConcentrationID
