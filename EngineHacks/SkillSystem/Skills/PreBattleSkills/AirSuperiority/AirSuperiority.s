.thumb
.org 0x0
.equ AirSuperiorityID, SkillTester+4
.equ FlierList, AirSuperiorityID+4

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@check if foe is a flier
ldr	r0,FlierList
ldr	r1,[r5,#0x4]
ldrb	r1,[r1,#0x4]	@class id
ldrb	r2,[r0]
cmp	r2,r1
bne	End

@has AirSuperiority
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @defender data
ldr r1, AirSuperiorityID
.short 0xf800
cmp r0, #0
beq End

@add 30 to hit and avoid
mov	r0, #0x60
ldrh	r1, [r4,r0]	@load hit
add	r1, #0x1E	@add 30 to hit
strh	r1, [r4,r0]     @store

mov	r0, #0x62
ldrh	r1, [r4,r0]	@load avoid
add	r1, #0x1E	@add 30 to avoid
strh	r1, [r4,r0]     @store

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD AirSuperiorityID
