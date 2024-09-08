.thumb
.equ RangeAccuracyID, SkillTester+4
.equ RangeAccuracyNegateID, SkillTester+8

.macro blh to, reg
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@has RangeAccuracy
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, RangeAccuracyID
.short 0xf800
cmp r0, #0
beq End

@has RangeAccuracyNegateID
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, RangeAccuracyNegateID
.short 0xf800
cmp r0, #0
bne End

@get the weapon type
mov r0, r4
mov r1, #0x4A
ldrh r0, [ r4, r1 ] @ Equipped item halfword.
blh 0x080174EC, r1 @ GetItemIndex. This function is such a meme tbh. r0 = item ID.
blh 0x080177B0, r1 @ GetItemData. r0 = pointer to ROM item data.
ldrb r0, [ r0, #0x07 ] @ r0 = this item's weapon type.

@are they using an axe?
cmp r0, #0x02 
beq AxeOrLance

@lance?
cmp r0, #0x01 
beq AxeOrLance

@bow?
cmp r0, #0x03
beq Bow

@if not any of these, jump to end
bal End

AxeOrLance:
@check range
@if one range, do nothing
ldr r0,=#0x203A4D4 @battle stats
ldrb r0,[r0,#2] @range
cmp r0, #1
ble End

@two range
cmp r0, #2
beq MinusFive

@three or more range
cmp r0, #3
bge MinusTen

Bow:
@check range
@one range
ldr r0,=#0x203A4D4 @battle stats
ldrb r0,[r0,#2] @range
cmp r0, #1
ble MinusFive

@two range
cmp r0, #2
beq End

@three range
cmp r0, #3
beq MinusFive

@four range
cmp r0, #4
beq MinusTen

@five range
cmp r0, #5
beq MinusFifteen

@six or more range
cmp r0, #6
bge MinusTwenty

MinusFive:
@hit
mov r0, r4
add r0,#0x60
ldrh r3,[r0]
sub r3,#5
strh r3,[r0]
bal End

MinusTen:
@hit
mov r0, r4
add r0,#0x60
ldrh r3,[r0]
sub r3,#10
strh r3,[r0]
bal End

MinusFifteen:
@hit
mov r0, r4
add r0,#0x60
ldrh r3,[r0]
sub r3,#15
strh r3,[r0]
bal End

MinusTwenty:
@hit
mov r0, r4
add r0,#0x60
ldrh r3,[r0]
sub r3,#20
strh r3,[r0]
bal End

	
End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD RangeAccuracyID
@WORD RangeAccuracyNegateID
