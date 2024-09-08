.thumb
.equ SaunionID, SkillTester+4

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@has Saunion
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, SaunionID
.short 0xf800
cmp r0, #0
beq End


PlusFiveHit:
@hit
mov r0, r4
add r0,#0x60
ldrh r3,[r0]
add r3,#5
strh r3,[r0]
bal End
	
End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD SaunionID