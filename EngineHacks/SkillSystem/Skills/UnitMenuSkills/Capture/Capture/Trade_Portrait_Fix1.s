.thumb

@r0=char data
push	{r14}

ldr		r1, Trade_Portrait_Getter
mov		r14,r1
.short	0xF800
mov		r1,r0

sub		r4,#0x4
mov		r0,#0x3
pop		{r2}
str		r0,[sp]
bx		r2

.ltorg
.align 4
Trade_Portrait_Getter:
