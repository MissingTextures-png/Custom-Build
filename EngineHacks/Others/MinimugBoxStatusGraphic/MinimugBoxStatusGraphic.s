.thumb
.align

.global NewMinimugBoxGraphicIndexer
.type NewMinimugBoxGraphicIndexer, %function


NewMinimugBoxGraphicIndexer: @r3 hook at 8C39C
cmp r0,#0
beq MinimugBoxGfx_NoStatus

sub r0,#1
mov r1,#0xA0
mul r0,r1
ldr r1,=NewMinimugBoxLabelNames
add r0,r1
ldr r3,=#0x808C421 @return point
bx r3


MinimugBoxGfx_NoStatus:
pop {r4-r6}
pop {r0}
bx r0


.ltorg
.align
