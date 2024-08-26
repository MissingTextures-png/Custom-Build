.thumb
.equ FierceCounterID, SkillTester+4

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

ldr r0, =#0x0203A56C
cmp r0, r4
bne End @If not defending, skip

ldr r0, SkillTester
mov lr, r0
mov r0, r4 @Attacker data
ldr r1, FierceCounterID
.short 0xf800
cmp r0, #0
beq End

ldr r0, [r5, #0x0] @Enemy Unit Struct Pointer
mov r1, #0x28
ldr r0, [r0, r1] @Enemy Unit Struct
mov r1, #0x40
lsl r1, #8 @0x4000 IsFemale
tst r0,r1
bne End @skip if Female

mov r1, #0x5A
ldrh r2, [r4, r1]
add r2, #0x2 @2 Damage
strh r2, [r4,r1]

End:
pop {r4-r7, r15}

.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD FierceCounterID
