.thumb
.align

@ Arguments:
    @ r0 = RAM unit pointer
    @ r1 = Item ID
    @ r2 = Heal value without bonus
@ Returns
    @ r0 = Final heal value

push    {lr}

mov r1, #0x2C
ldrb r0,[r0,r1] @ Unit's Staff Rank
mov r1, #251    @ S Rank
cmp r0, r1
blt NoBonus

add r2, #5      @ Heal value +5

NoBonus:
mov    r0, r2
pop    {r3}
bx	r3

.align
