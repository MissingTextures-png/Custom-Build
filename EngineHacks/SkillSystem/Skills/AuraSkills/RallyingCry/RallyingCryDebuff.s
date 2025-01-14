.equ RallyingCryID, AuraSkillCheck+4
.thumb
push {r4-r7,lr}
@goes in the battle loop.
@r0 is the attacker
@r1 is the defender
mov r4, r0
mov r5, r1

CheckSkill:
@now check for the skill
ldr r0, AuraSkillCheck
mov lr, r0
mov r0, r4 @attacker
ldr r1, RallyingCryID
mov r2, #3 @are enemies
mov r3, #4 @range
.short 0xf800
cmp r0, #0
beq Done

@Apply penalties to enemies
mov r0, r4
add r0, #0x5A 	@Move to the defender's damage.
ldrh r3, [r0]	@Load the defender's damage into r3.
sub r3, #2	@sub 2 damage.
strh r3, [r0]	@Store dmg.

Done:
pop {r4-r7}
pop {r0}
bx r0
.align
.ltorg
AuraSkillCheck:
@ POIN AuraSkillCheck
@ WORD RallyingCryID
