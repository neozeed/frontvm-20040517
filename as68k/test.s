	jmp	poop
	dc.b	"\*.*"
	dc.b	0,0
poop:	cmpm.w	(a4)+,(a5)+
	rts
