.thumb
.align

.global NewFreezeIcon
.type NewFreezeIcon, %function

NewFreezeIcon:
lsl   r6, r7, #0x18         @ Seems related to blinking.
beq   Return

mov   r1, #0x10
ldsb  r1, [r4, r1]          @ X-Coordinate.
lsl   r1 ,r1 ,#0x4          @ Multiplied by 16 (tiles are 16 by 16).

sub   r1, #0x0A

ldr   r2, =0x0202BCB0       @ GameState
mov   r0, #0xC        
ldsh  r0, [r2, r0]          @ gCurrentRealCameraPos, lower short (seems X related).
sub   r3, r1, r0            @ Subtract Xcamera pos from X-coordinate.
mov   r0, #0x11
ldsb  r0, [r4, r0]          @ Y-Coordinate.
lsl   r0, r0, #0x4          @ Multiplied by 16.

sub   r0, #0x04

mov   r1, #0xE
ldsh  r1, [r2, r1]          @ gCurrentRealCameraPos, higher short (seems Y related).
sub   r2, r0, r1            @ Subtract Ycamera pos from Y-coordinate.
mov   r1, r3
add   r1, #0x10
mov   r0, #0x80
lsl   r0, r0, #0x1
cmp   r1, r0                @ Off-screen, perhaps.
bhi   Return
    mov   r0 ,r2
    add   r0, #0x10
    cmp   r0, #0xB0             @ Off screen, perhaps.
    bhi   Return
        ldr   r0, =0x08002BB9       @ PushToSecondaryOAM
        mov   r14, r0
        ldr   r0, =0x209
        add   r0, r3                @ X += #0x209 vanilla sets bit 9, despite...
        ldr   r1, =0x1FF
        and   r0, r1                @ X &= #0x1FF ...this mask zeroing it.
        ldr   r3, =0x100
        add   r1, r2                @ Y += #0x10F vanilla sets bit 8, despite...
        ldr   r2, =0xFF
        and   r1 ,r2                @ Y &= #0xFF  ...this mask zeroing it.
        ldr   r2, =0x08590F44       @ OAM 8x8
        ldr   r3, =0x850            @ Icon location and priority=2.
        .short 0xF800
        
Return:
ldr   r0, =0x080278A7
bx    r0

.ltorg
.align
