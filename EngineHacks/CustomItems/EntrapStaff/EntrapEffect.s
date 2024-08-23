.thumb

.macro _blh to, reg=r3
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.macro _blr to, reg
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

.set GetUnitStruct,                     0x08019430

.set GetStaffAccuracy,                  0x0802CCDC
.set gActiveBattleUnit,                 0x0203A4EC @attacker
.set Roll1RN,                           0x08000CA0

.set gpCurrentRound,                    0x0203A608
.set Something,                         0xFFF80000

.set GetRescueStaffeePosition,          0x0802ECD0
.set gTargetBattleUnit,                 0x0203A56C @defender

.align

push {r4-r6,lr}                         @ ExecRescueStaff
sub sp, #0x8

ldrb r0, [r4, #0xC]                     @ pointer:0203A964 (ActionData@gActionData.subjectIndex )
_blh GetUnitStruct                      @ GetUnitStruct RET=RAM Unit:@Unit
mov r5,r0
ldrb r0, [r4, #0xD]                     @ pointer:0203A965 (ActionData@gActionData.targetIndex ) r0=RAM
_blh GetUnitStruct                      @ GetUnitStruct RET=RAM Unit:@Unit
mov r1,r0
add r3,sp,#0x4
mov r0,r5

push {r0-r6}
_blh GetStaffAccuracy
ldr r4, =gActiveBattleUnit              @ pointer:0802F090 -> 0203A4EC (BattleUnit@gBattleActor Copy unit data of Right.CopyUnit )
mov r1 ,r4
add r1, #0x64
strh r0, [r1, #0x0]                     @ Right side with battle animation (AttackerHit - DefinerAvoid)
_blh Roll1RN
lsl r0 ,r0 ,#0x18
cmp r0, #0x0
bne Hit

pop {r0-r6}
ldr r0, =gpCurrentRound                 @ pointer:0802F094 -> 0203A608 (gpCurrentRound )
ldr r3, [r0, #0x0]                      @ pointer:0203A608 (gpCurrentRound )
ldr r2, [r3, #0x0]
lsl r1,r2 ,#0xD
lsr r1,r1 ,#0xD
mov r0, #0x2
orr r1,r0
ldr r0, =Something                      @ pointer:0802F098 -> FFF80000
and r0,r2
orr r0,r1
str r0, [r3, #0x0]

ldrb r0, [r4, #0xD]                     @ pointer:0203A965 (ActionData@gActionData.targetIndex )
_blh GetUnitStruct                      @ GetUnitStruct RET=RAM Unit:@Unit
ldrb      r1, [r0, #0x10]
ldr       r3, =gTargetBattleUnit
mov       r2,r3
add 	  r2, #0x73
strb      r1, [r2, #0x0]
ldrb      r1, [r0, #0x11]
add       r3, #0x74
strb      r1, [r3, #0x0]
b Miss

Hit:
pop {r0-r6}

mov r2, sp
push {r5}
_blr GetRescueStaffeePosition, r5
pop {r5}
ldrb r0, [r4, #0xD]                     @ pointer:0203A965 (ActionData@gActionData.targetIndex )
_blh GetUnitStruct                      @ GetUnitStruct RET=RAM Unit:@Unit
ldr r1,[sp, #0x0]                       @ r1=RAM
strb r1, [r0, #0x10]
ldrb r0, [r4, #0xD]                     @ pointer:0203A965 (ActionData@gActionData.targetIndex ) r0=RAM
_blh GetUnitStruct                      @ GetUnitStruct RET=RAM Unit:@Unit
ldr r1,[sp, #0x4]                       @ r1=RAM
strb r1, [r0, #0x11]
ldr r0, =gTargetBattleUnit              @ pointer:0802EF6C -> 0203A56C (BattleUnit@gBattleTarget Copy unit data of Left.CopyUnit ) r0=RAM
ldr r1,[sp, #0x0]                       @ r1=RAM
mov r2 ,r0
add r2, #0x73
strb r1, [r2, #0x0]                     @ BattleUnit@gBattleTarget Copy unit data of Left.changeHP
ldr r1,[sp, #0x4]                       @ r1=RAM
add r0, #0x74
strb r1, [r0, #0x0]                     @ BattleUnit@gBattleTarget Copy unit data of Left.changePow

Miss:
add sp, #0x8
pop {r4-r6}
pop {r0}
bx r0

.align
.ltorg
