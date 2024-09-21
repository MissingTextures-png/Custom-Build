.thumb
.align

.global Circlet_Renewal
.type Circlet_Renewal, %function

Circlet_Renewal:
push {r4-r5,r14}
mov r4,r0 @r4 = unit
mov r5,r1 @r5 = heal %

ldr r0,=SkillTester
mov r14,r0
mov r0,r4
ldr r1,=Circlet_IDLink
ldrb r1,[r1]
.short 0xF800
cmp r0,#0
beq GoBack

add r5,#30

GoBack:
mov r0,r5
pop {r4-r5}
pop {r1}
bx r1

.ltorg
.align


