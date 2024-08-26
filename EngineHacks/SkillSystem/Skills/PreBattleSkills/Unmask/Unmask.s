.thumb
.equ UnmaskID, SkillTester+4
.equ gBattleData, 0x203A4D4

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

ldrb r3, =gBattleData
ldrb r3, [r3]
cmp r3, #4
beq End

ldr r0, SkillTester
mov lr, r0
mov r0, r4 @Attacker data
ldr r1, UnmaskID
.short 0xf800
cmp r0, #0
beq End

ldr r0, [r5] @char
ldr r0, [r0, #0x28] @char abilities
ldr r3, [r5,#4] @class
ldr r3, [r3,#0x28] @class abilities
orr r0, r3
mov r3, #0x40
lsl r3, #8 @0x4000 IsFemale
tst r0, r3
beq End @skip if Male

mov r1, #0x5A
ldrh r2, [r4, r1]
add r2, #0x4 @4 Damage
strh r2, [r4,r1]

mov r1, #0x66
ldrh r2, [r4, r1]
add r2, #20 @20 Crit
strh r2, [r4,r1]

End:
pop {r4-r7, r15}

.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD UnmaskID
