.thumb
.equ DominateID, SkillTester+4
.equ GetUnit,0x8019430
.equ ActionStruct, 0x203A958

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@not at stat screen
ldr r1, [r5,#4] @class data ptr
cmp r1, #0 @if 0, this is stat screen
beq End

@not broken movement map
ldr r0,=ActionStruct
add r0, #0x10   @squares moved this turn
ldrb r0,[r0]
cmp r0,#0x80
bge End

@check for CarefulAim
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @Attacker data
ldr r1, DominateID
.short 0xf800
cmp r0, #0
beq End

@check squares moved
ldr r3,=ActionStruct
add r3, #0x10   @squares moved this turn
ldrb r2,[r3]    @load how many squares the unit moved
cmp r2,#0       @check if 0
bne End         @if not, branch to the end

@add hit
mov r1, #0x60       @get hit short
ldrh r0, [r4, r1]   @load its value
mov r2,#0x1E        @get 30
add r0, r2          @add it to the hit rate of the attacker
strh r0, [r4,r1]    @store the final value

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD DominateID
