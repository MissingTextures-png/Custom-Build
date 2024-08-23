.thumb

@r0=char data
push	{r14}

ldr		r1, Trade_Portrait_Getter
mov		r14,r1
.short	0xF800
mov		r1,r0

mov		r0,#0x2
pop		{r2}
str		r0,[sp]
mov		r0,#0x1
bx		r2


.ltorg
.align 4
Trade_Portrait_Getter:
