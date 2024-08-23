.thumb

.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

.equ gProc_8A01DBC, 0x08A01DBC
.equ ProcFind, 0x08002E9C
.equ CgTextInit, 0x0808EB0C

.global ReadTextCode80
.type ReadTextCode80, %function


		ReadTextCode80:
		push	{r4,r14}
		mov		r4, r0
		
		ldr		r0, [r4,#0x2C]
		add		r1, r0, #1
		str		r1, [r4,#0x2C]
		ldrb	r0, [r0,#1]
		cmp		r0, #0x21
		beq		ToggleRedText
		
			cmp		r0, #0x23
			bne		IncrementTextReader
			
				@"Re-read" 0x80 instead of 0x23 so SetName is properly identified
				sub		r1, #1
				str		r1, [r4,#0x2C]
				
				@fix A button prompt arrow showing up one row lower
				mov		r1, #0x5A
				ldrb	r0, [r4,r1]
				cmp		r0, #0
				beq		GoToCgTextInit
				
					sub		r0, #0x10
					strb	r0, [r4,r1]
					
					GoToCgTextInit:
					mov		r0, r4
					blh		CgTextInit, r1
					
					@Add pause
					ldr		r0, =SetNamePauseLink
					ldrb	r0, [r0]
					mov		r1, #0x55
					strb	r0, [r4,r1]
					b		End
				
		ToggleRedText:
		mov		r2, #0x5E
		ldrb	r1, [r4,r2]
		mov		r0, #1
		sub		r0, r1
		strb	r0, [r4,r2]
		
		IncrementTextReader:
		ldr		r0, [r4,#0x2C]
		add		r0, #1
		str		r0, [r4,#0x2C]
		
		End:
		pop		{r4}
		pop		{r0}
		bx		r0
		
		.align
		.ltorg

