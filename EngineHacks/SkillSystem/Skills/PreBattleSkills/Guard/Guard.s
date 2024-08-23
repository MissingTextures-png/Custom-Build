.thumb
.equ GuardID, SkillTester+4

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@over 50% hp
ldrb r0, [r4, #0x12]
lsr r0, #1 @max hp/2
ldrb r1, [r4, #0x13] @currhp
cmp r1, r0
blt End

@has Guard
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @defender data
ldr r1, GuardID
.short 0xf800
cmp r0, #0
beq End

@add 10 crit evade
mov r1, #0x68
ldrh r0, [r4, r1] @crit evade
add r0, #10
strh r0, [r4,r1]

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD GuardID
