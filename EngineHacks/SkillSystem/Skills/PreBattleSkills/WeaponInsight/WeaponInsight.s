.thumb
.equ ItemTable, SkillTester+4
.equ WeaponInsightID, ItemTable+4

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr


@has skill
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, WeaponInsightID
.short 0xf800
cmp r0, #0
beq End

mov r3,#0x4A        @get the weapon ID and uses before battle byte
ldrb r2,[r4,r3]     @load the weapon ID for the attacker seperately by loading it as a byte instead of a short
mov r3,#0x24        @move the value that represents the length of the item struct into a register
mul r2,r3           @multiply both together to get the item's position in the item table
ldr r3,ItemTable    @load the item table
add r2,r3           @add both values together to obtain the exact location for the item in the table
mov r3,#0x1C        @get the weapon rank byte for attacker
ldrb r2,[r2,r3]     @load its value

mov r1,#0x4A        @get the weapon ID and uses before battle byte
ldrb r0,[r5,r1]     @load the weapon ID for the defender seperately by loading it as a byte instead of a short
mov r1,#0x24        @move the value that represents the length of the item struct into a register
mul r0,r1           @multiply both together to get the item's position in the item table
ldr r1,ItemTable    @load the item table
add r0,r1           @add both values together to obtain the exact location for the item in the table
mov r1,#0x1C        @get the weapon rank byte for defender
ldrb r0,[r0,r1]     @load its value

cmp r0, #0          @check if the defender's weapon rank is prf (0)
beq End             @branch to the end if so
cmp r2, #0          @check if the attacker's weapon rank is prf (0)
beq End             @branch to the end if so
cmp r0, r2          @now compare the weapon ranks of both units' equipped weapons
blt ApplySkill      @if the attacker's has a lower rank, branch to apply the skill
b   End             @otherwise, branch to the end

ApplySkill:
mov r0,#0x66        @get the crit short
ldrh r1,[r4,r0]     @load its value
add r1,#0x14        @add 20
strh r1,[r4,r0]     @store the final value

End:
pop {r4-r7, r15}

.align
.ltorg
SkillTester:
@POIN SkillTester
@POIN ItemTable
@WORD WeaponInsightID
