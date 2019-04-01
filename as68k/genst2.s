
		bra.s	l3c
		dc.b	$5a,$d5,$47,$f2,$50,$80
		dc.b	"GenST (C) HiSoft 1985-91"
	l3c:	bsr.w	L7120
		bsr.w	L57e4
		moveq	#0,d0
		bsr.w	L5558
		lea	L6ee2(pc),a0
		lea	-2(a6),a1
		moveq	#63,d0
	l54:	move.l	(a0)+,(a1)+
		dbra	d0,l54
		lea	254(a6),a0
		move.w	#$61,d0
	l62:	clr.w	(a0)+
		dbra	d0,l62
		sf	466(a6)
		sf	464(a6)
		bsr.w	L578e
		lea	500(a6),a1
		clr.l	(a1)
		move.l	a1,358(a6)
		lea	496(a6),a1
		clr.l	(a1)
		move.l	a1,350(a6)
		bsr.w	L34d6
		bsr.w	L3a96
		clr.l	426(a6)
		clr.b	1616(a6)
		clr.w	1780(a6)
		sf	457(a6)
		clr.w	452(a6)
		move.b	#$64,466(a6)
		bsr.w	L7182
		bne.w	L23a
		sf	466(a6)
		move.l	456(a6),254(a6)
		move.l	426(a6),d0
		beq.s	lf2
		movea.l	d0,a0
		bsr.w	L5222
		beq.s	lf2
		moveq	#10,d0
		bsr.w	L5558
		movea.l	426(a6),a0
		moveq	#0,d0
		move.b	5(a0),d0
		clr.b	5(a0,d0.w)
		addq.w	#6,a0
		bsr.w	L5980
		bsr.w	L556a
		move.b	#$64,466(a6)
		bra.w	L23a
	lf2:	bsr.w	L25a
		lea	1328(a6),a0
		move.l	a0,504(a6)
		moveq	#1,d0
		bsr.w	L5558
		move.b	23098(a6),23099(a6)
		tst.l	330(a6)
		beq.s	l122
		bsr.w	L468
		bne.s	l132
		bsr.w	L63a
		bsr.w	L5ee
		bsr.w	L1f86
	l122:	bsr.w	L468
		bne.s	l132
		bsr.w	L63a
		bsr.w	L5ee
		bra.s	l122
	l132:	tst.b	268(a6)
		bne.w	L1ac
		bsr.w	L316
		sf	23099(a6)
		moveq	#2,d0
		bsr.w	L5558
		tst.b	277(a6)
		bgt.w	l462
		move.b	23098(a6),23099(a6)
		bsr.w	L7518
		st	464(a6)
		bsr.w	L25a
		tst.b	23098(a6)
		beq.s	l170
		sf	18284(a6)
		st	257(a6)
	l170:	tst.l	426(a6)
		beq.s	l182
		movea.l	426(a6),a0
		bsr.w	L5222
		bne.w	L4fa0
	l182:	bsr.w	L468
		bne.s	l192
		bsr.w	L63a
		bsr.w	L5ee
		bra.s	l182
	l192:	bsr.w	L308
		bsr.w	L4758
		bsr.w	L4766
		bsr.w	L5e20
		tst.b	256(a6)
		beq.s	L1ac
		bsr.w	L563e

L1ac:
		sf	23099(a6)
		bsr.w	L5836
		bsr.w	L5e3c
		bsr.w	L5382
		bsr.w	L556a
		moveq	#0,d1
		move.b	268(a6),d1
		bsr.w	L55e2
		moveq	#3,d0
		cmpi.b	#$1,268(a6)
		bne.s	l1d6
		addq.b	#1,d0
	l1d6:	bsr.w	L5558
		moveq	#0,d1
		move.w	468(a6),d1
		bsr.w	L55e2
		moveq	#5,d0
		bsr.w	L5558
		move.l	472(a6),d1
		bsr.w	L55e2
		moveq	#12,d0
		bsr.w	L5558
		bsr.w	L5c2c
		moveq	#22,d0
		tst.b	274(a6)
		bne.s	l20e
		moveq	#18,d0
		tst.b	276(a6)
		beq.s	l20e
		moveq	#17,d0
	l20e:	bsr.w	L5558
		moveq	#19,d0
		bsr.w	L5558
		moveq	#0,d1
		move.w	434(a6),d1
		beq.s	L23a
		bsr.w	L55e2
		moveq	#13,d0
		bsr.w	L5558
		moveq	#0,d0
		move.w	436(a6),d1
		bsr.w	L55e2
		moveq	#14,d0
		bsr.w	L5558

L23a:
		bsr.w	L5848
		bsr.w	L754a
		move.l	422(a6),d3
		beq.s	l252
		jsr	L7846
		clr.l	422(a6)
	l252:	bsr.w	L57c4
		bsr.w	L7642

L25a:
		moveq	#0,d0
		move.w	d0,468(a6)
		move.w	d0,470(a6)
		move.l	480(a6),484(a6)
		move.l	d0,472(a6)
		move.l	d0,476(a6)
		move.l	d0,334(a6)
		move.l	d0,342(a6)
		move.l	d0,430(a6)
		move.w	d0,18298(a6)
		move.w	d0,18300(a6)
		move.l	d0,18302(a6)
		move.b	d0,264(a6)
		move.b	d0,274(a6)
		move.b	d0,18285(a6)
		move.w	d0,270(a6)
		move.w	#$ffff,272(a6)
		move.b	d0,265(a6)
		move.l	d0,18316(a6)
		move.w	d0,18324(a6)
		move.w	d0,18326(a6)
		move.l	d0,288(a6)
		move.l	d0,18294(a6)
		moveq	#1,d0
		move.l	d0,18290(a6)
		st	18284(a6)
		st	263(a6)
		move.w	#$80,454(a6)
		bsr.w	L5460
		sf	276(a6)
		sf	277(a6)
		sf	280(a6)
		sf	279(a6)
		sf	259(a6)
		sf	281(a6)
		sf	285(a6)
		st	286(a6)
		move.b	#$2e,278(a6)
		move.b	#$1,266(a6)
		bsr.w	L466c
		lea	1780(a6),a0
		clr.w	(a0)
		rts

L308:
		tst.w	18298(a6)
		bne.s	l310
		rts
	l310:	moveq	#48,d0
		bra.w	L4fb6

L316:
		bsr.s	L308
		bsr.w	L4758
		bsr.w	L4766
		bsr.w	L5382
		bsr.s	L330
		bsr.w	L5c6c
		clr.l	406(a6)
		rts

L330:
		moveq	#0,d2
		tst.b	255(a6)
		beq.s	l33e
		tst.w	452(a6)
		seq	d2
	l33e:	movea.l	358(a6),a3
		movea.l	(a3),a3
		lea	366(a6),a1
		bsr.s	L376
		lea	370(a6),a0
		bsr.s	L366
		lea	382(a6),a0
		bsr.s	L366
		lea	394(a6),a0
		bsr.s	L366
		move.l	378(a6),d0
		add.l	d0,390(a6)
		rts

L366:
		btst	#$0,3(a0)
		beq.s	l374
		addq.l	#1,(a0)
		addq.l	#1,8(a0)
	l374:	rts

L376:
		tst.l	(a3)
		beq.s	l382
		move.l	a3,-(a7)
		movea.l	(a3),a3
		bsr.s	L376
		movea.l	(a7)+,a3
	l382:	cmpi.b	#$9,13(a3)
		bne.s	l390
		movea.l	8(a3),a2
		bsr.s	L3a2
	l390:	tst.l	4(a3)
		beq.s	l3a0
		move.l	a3,-(a7)
		movea.l	4(a3),a3
		bsr.s	L376
		movea.l	(a7)+,a3
	l3a0:	rts

L3a2:
		tst.l	(a2)
		beq.s	l3ae
		move.l	a2,-(a7)
		movea.l	(a2),a2
		bsr.s	L3a2
		movea.l	(a7)+,a2
	l3ae:	clr.l	8(a2)
		tst.l	4(a2)
		beq.s	l3c2
		move.l	a2,-(a7)
		movea.l	4(a2),a2
		bsr.s	L3a2
		movea.l	(a7)+,a2
	l3c2:	rts

L3c4:
		tst.l	18316(a6)
		bne.s	l3ea
		tst.b	259(a6)
		bne.s	l40e
		tst.l	410(a6)
		bne.s	l42a
		movea.l	484(a6),a0
		cmpa.l	488(a6),a0
		bge.s	l3e6
	l3e0:	move.b	(a0),d0
		cmp.b	d0,d0
		rts
	l3e6:	moveq	#-1,d0
		rts
	l3ea:	tst.b	259(a6)
		beq.s	l3fa
		move.w	18324(a6),d0
		cmp.w	18326(a6),d0
		bhi.s	l40e
	l3fa:	movea.l	18316(a6),a1
		movea.l	18320(a6),a0
		cmpa.l	4(a1),a0
		bne.s	l3e0
		movea.l	8(a1),a0
		bra.s	l3e0
	l40e:	movea.l	18302(a6),a2
		movea.l	4(a2),a1
		movea.l	16(a2),a0
		cmpa.l	4(a1),a0
		bne.s	l3e0
		movea.l	8(a1),a1
		movea.l	0(a1),a0
		bra.s	l3e0
	l42a:	movea.l	410(a6),a1
		movea.l	8(a1),a2
		movea.l	0(a2),a0
		cmpa.l	8(a2),a0
		bcc.s	l446
		cmpi.b	#$a,(a0)+
		beq.s	l3e0
		subq.l	#1,a0
		bra.s	l3e0
	l446:	moveq	#68,d0
		bra.w	L4fa0
		dc.b	$4a,$fb
		dc.b	"include_longmac"
		dc.b	$0
	l45e:	bpl.s	l462
		rts
	l462:	moveq	#78,d0
		bra.w	L4fa0

L468:
		tst.b	277(a6)
		bne.s	l45e
		addq.w	#1,468(a6)
		tst.b	259(a6)
		bne.w	l36bc
		tst.l	18316(a6)
		bne.w	L3a44

L482:
		tst.b	277(a6)
		bne.s	l45e
		moveq	#13,d1
		move.w	#$fe,d2
		addq.w	#1,470(a6)
		tst.l	410(a6)
		bne.s	l4c0
		movea.l	484(a6),a4
		cmpa.l	488(a6),a4
		bge.s	l4bc
		movea.l	a4,a0
		move.l	a4,492(a6)
	l4a8:	cmp.b	(a0)+,d1
		bne.s	l4a8
	l4ac:	cmpi.b	#$a,(a0)+
		beq.s	l4ac
		subq.l	#1,a0
		move.l	a0,484(a6)
		moveq	#0,d0
		rts
	l4bc:	moveq	#-1,d0
		rts
	l4c0:	movea.l	410(a6),a1
		movea.l	8(a1),a0
		movea.l	0(a0),a4
	l4cc:	cmpa.l	8(a0),a4
		bcc.w	l55c
		cmpi.b	#$a,(a4)
		bne.s	l4de
		addq.l	#1,a4
		bra.s	l4cc
	l4de:	move.w	#$fc,d0
		moveq	#13,d2
		move.l	a4,492(a6)
		movea.l	a4,a2
	l4ea:	cmp.b	(a2)+,d2
		dbeq	d0,l4ea
		beq.s	l50a
		cmpa.l	8(a0),a2
		bhi.s	l520
		move.b	#$2a,-(a2)
		move.b	#$d,-1(a2)
		move.l	a2,0(a0)
		moveq	#0,d0
		rts
	l50a:	moveq	#10,d0
	l50c:	cmpa.l	8(a0),a2
		bhi.s	l520
		cmp.b	(a2)+,d0
		beq.s	l50c
		subq.l	#1,a2
		move.l	a2,0(a0)
		moveq	#0,d0
		rts
	l520:	move.l	4(a0),d1
		lea	14(a0,d1.l),a2
		cmpa.l	8(a0),a2
		bne.s	l57e
		move.l	8(a0),d2
		sub.l	a4,d2
		beq.s	l55c
		movem.l	a1/d2,-(a7)
		subq.l	#1,d2
		movea.l	a4,a1
		lea	14(a0),a2
		move.l	a2,0(a0)
	l546:	move.b	(a1)+,(a2)+
		dbra	d2,l546
		movem.l	(a7)+,d2/a1
		move.l	4(a0),d1
		sub.l	d2,d1
		bsr.w	L531a
		bra.s	l576
	l55c:	lea	14(a0),a2
		move.l	a2,0(a0)
		move.l	4(a0),d1
		lea	14(a0,d1.l),a2
		cmpa.l	8(a0),a2
		bne.s	l57e
		bsr.w	L5326
	l576:	beq.w	l4c0
		bra.w	L4fa0
	l57e:	move.w	12(a0),470(a6)
		clr.w	12(a0)
		move.l	152(a1),d2
		beq.s	l59a
		move.l	a1,-(a7)
		bsr.w	L7810
		movea.l	(a7)+,a1
		clr.l	152(a1)
	l59a:	move.l	16(a1),410(a6)
		bra.w	L482
		dc.b	$50,$ee,$1,$13,$4a,$2e,$1,$d0,$67,$14,$b2,$3c,$0,$2b,$67,$18
		dc.b	$b2,$3c,$0,$2d,$67,$c,$72,$d,$50,$ee,$1,$1,$4e,$75,$72,$d
		dc.b	"NuS.Gl`"
		dc.b	$4
		dc.b	"R.GlZ"
		dc.b	$ee,$1,$1,$12,$1c,$4e,$75,$50,$ee,$1,$13,$72,$d,$4a,$2e,$1
		dc.b	$d0,$67,$8,$51,$ee,$1,$1,$50,$ee,$47,$6c,$4e,$75

L5ee:
		tst.b	260(a6)
		bne.s	l62e
		tst.b	464(a6)
		bne.s	l602
		tst.b	450(a6)
		beq.s	l620
		bra.s	l62e
	l602:	tst.b	257(a6)
		beq.s	l620
		tst.b	275(a6)
		bne.s	l620
		tst.b	259(a6)
		beq.s	l62e
		tst.b	280(a6)
		bne.s	l62e
		tst.b	279(a6)
		bne.s	l62e
	l620:	sf	275(a6)
		clr.b	18285(a6)
		sf	280(a6)
		rts
	l62e:	sf	260(a6)
		bsr.w	L598e
		bra.s	l620
	l638:	rts

L63a:
		move.l	a7,460(a6)
		movea.l	504(a6),a5
		move.l	a5,508(a6)
		clr.l	414(a6)
		sf	269(a6)
		move.b	(a4)+,d1
		cmp.b	#$d,d1
		beq.s	l638
		cmp.b	#$9,d1
		beq.s	l662
		cmp.b	#$20,d1
		bne.s	l66a
	l662:	clr.l	918(a6)
		bra.w	L68c
	l66a:	st	d2
		lea	918(a6),a0
		clr.b	4(a0)
		bsr.w	L4444
		bne.s	l6b6
		cmp.b	#$3a,d1
		bne.s	l68e

L680:
		move.b	(a4)+,d1
		cmp.b	#$3a,d1
		bne.s	l68e
		st	922(a6)

L68c:
		move.b	(a4)+,d1
	l68e:	cmp.b	#$9,d1
		beq.s	L68c
		cmp.b	#$20,d1
		beq.s	L68c
		cmp.b	#$d,d1
		beq.w	L85a
		ext.w	d1
		lea	L6e62(pc),a0
		tst.b	0(a0,d1.w)
		beq.s	l6ca
		cmp.b	#$3d,d1
		beq.w	l4274
	l6b6:	cmp.b	#$3b,d1
		beq.w	L85a
		cmp.b	#$2a,d1
		beq.w	L85a
		bra.w	L4f64
	l6ca:	lea	-1(a4),a2
		lea	1328(a6),a1
		move.l	#$20202020,-(a1)
		move.l	#$20202020,-(a1)
		ext.w	d1
		move.b	126(a6,d1.w),d1
		moveq	#7,d2
		move.b	d1,(a1)+
	l6e8:	move.b	(a4)+,d1
		cmp.b	#$d,d1
		beq.s	l71c
		ext.w	d1
		move.b	126(a6,d1.w),d1
		cmp.b	#$41,d1
		bcs.s	l70a
		cmp.b	#$5b,d1
		bcc.s	l70a
		move.b	d1,(a1)+
		dbra	d2,l6e8
		bra.s	l720
	l70a:	cmp.b	#$2e,d1
		beq.s	l71c
		cmp.b	#$9,d1
		beq.s	l71c
		cmp.b	#$20,d1
		bne.s	l720
	l71c:	bsr.w	L427a
	l720:	movea.l	a2,a4
		move.b	(a4)+,d1
		lea	784(a6),a0
		bsr.w	L440c
		bne.w	L4f64
		movea.l	358(a6),a2
		move.l	a1,d4
		movem.l	a3-5/d2,-(a7)
		bsr.w	L7da
		movem.l	(a7)+,d2/a3-5
		beq.w	l34f0
		movea.l	d4,a4
		move.b	-1(a4),d1
		cmp.b	#$3a,d1
		bne.w	l4f78
		lea	918(a6),a1
		tst.l	(a1)
		bne.w	l4f78
		move.b	d2,5(a0)
		bsr.s	L76e
		movea.l	a1,a0
		clr.b	4(a0)
		bra.w	L680

L76e:
		move.b	5(a0),5(a1)
		tst.b	254(a6)
		bne.s	l784
		move.l	(a0),(a1)
		move.b	6(a0),6(a1)
		rts
	l784:	move.b	5(a0),d0
		lea	6(a1),a2
		move.l	a2,(a1)
		addq.w	#6,a0
	l790:	move.b	(a0)+,(a2)+
		subq.b	#1,d0
		bne.s	l790
		rts

L798:
		dc.b	"?RA?rl??????O"
		dc.b	$0

L7a6:
		movem.l	a3-5,-(a7)
		move.l	334(a6),d0
		beq.s	l7ba
		movea.l	d0,a2
		bsr.s	L7da
		beq.s	l7d4
		move.l	a1,338(a6)
	l7ba:	movea.l	342(a6),a2
		bsr.s	L7da
		beq.s	l7d4
		move.l	a1,346(a6)
		movea.l	350(a6),a2
		bsr.s	L7da
		beq.s	l7d4
		move.l	a1,354(a6)
		moveq	#-1,d0
	l7d4:	movem.l	(a7)+,a3-5
		rts

L7da:
		move.l	(a2),d0
		beq.w	l81c
		movea.l	d0,a1
		move.b	5(a0),d2
		movea.l	(a0),a5
		bra.s	l7f0
	l7ea:	move.l	(a1),d0
		beq.s	l818
		movea.l	d0,a1
	l7f0:	cmp.b	22(a1),d2
		bcs.s	l7ea
		bhi.s	l80c
		move.b	d2,d3
		lea	23(a1),a3
		movea.l	a5,a4
	l800:	cmpm.b	(a3)+,(a4)+
		bcs.s	l7ea
		bhi.s	l80c
		subq.b	#1,d3
		bne.s	l800
		rts
	l80c:	move.l	4(a1),d0
		beq.s	l816
		movea.l	d0,a1
		bra.s	l7f0
	l816:	addq.w	#4,a1
	l818:	moveq	#3,d0
		rts
	l81c:	movea.l	a2,a1
		moveq	#3,d0
		rts
	l822:	bsr.s	L7a6
		bne.w	l4f6c
		bset	#$6,12(a1)
		bne.w	l4f68
		move.b	266(a6),d3
		cmp.b	13(a1),d3
		bne.w	l4f68
		cmp.l	8(a1),d4
		bne.w	l4f70
		move.b	23(a1),d0
		cmp.b	278(a6),d0
		beq.s	l858

L850:
		lea	16(a1),a0
		move.l	a0,334(a6)
	l858:	rts

L85a:
		move.l	476(a6),d4
		lea	918(a6),a0
		tst.l	(a0)
		bne.s	l892
		rts
	l868:	btst	#$0,479(a6)
		bne.w	L5db0
		rts

L874:
		lea	918(a6),a0
		tst.l	(a0)
		beq.s	l868
		move.l	476(a6),d4
		btst	#$0,d4
		beq.s	l892
		bsr.w	L5db0
		lea	918(a6),a0
		move.l	476(a6),d4
	l892:	tst.b	464(a6)
		bne.s	l822
		bsr.w	L7a6
		beq.w	l4f68
		move.b	266(a6),d3
		move.b	6(a0),d0
		cmp.b	278(a6),d0
		beq.s	l8b8
		pea	L850(pc)
		lea	342(a6),a2
		bra.s	L8c2
	l8b8:	lea	334(a6),a2
		tst.l	(a2)
		beq.w	l4f74

L8c2:
		movea.l	4(a2),a1

L8c6:
		cmpi.w	#$98,318(a6)
		bcc.s	l8da
		movem.l	a0-1/d3,-(a7)
		bsr.w	L578e
		movem.l	(a7)+,d3/a0-1
	l8da:	movea.l	304(a6),a2
		move.l	a2,(a1)
		movea.l	a2,a1
		moveq	#0,d0
		move.l	d0,(a2)
		move.l	d0,4(a2)
		move.l	d4,8(a2)
		move.b	d3,13(a2)
		move.w	d0,20(a2)
		move.b	d0,12(a2)
		move.b	316(a6),14(a2)
		move.l	d0,16(a2)
		lea	22(a2),a2
		move.b	5(a0),d0
		movea.l	(a0),a0
		move.b	d0,(a2)+
	l910:	move.b	(a0)+,(a2)+
		subq.b	#1,d0
		bne.s	l910
		move.l	a2,d0
		sub.l	a1,d0
		addq.l	#1,d0
		bclr	#$0,d0
		sub.w	d0,318(a6)
		add.l	d0,304(a6)
		rts

L92a:
		cmp.w	318(a6),d0
		bcs.s	l93c
		movem.l	a0-1/d3/d0,-(a7)
		bsr.w	L578e
		movem.l	(a7)+,d0/d3/a0-1
	l93c:	move.l	d0,-(a7)
		bsr.s	L8c6
		sub.l	d0,304(a6)
		add.w	d0,318(a6)
		move.l	(a7)+,d0
		sub.w	d0,318(a6)
		add.l	d0,304(a6)
		rts

L954:
		bsr.w	L47c4
		lea	1456(a6),a0
		clr.w	(a0)
		lea	1496(a6),a0
		clr.w	(a0)
		moveq	#0,d4
		movem.l	d5-7,-(a7)
		bsr.s	L9e2
		movem.l	(a7)+,d5-7
		tst.w	1456(a6)
		bne.s	L97e
		tst.w	1496(a6)
		bne.s	L97e
		rts

L97e:
		moveq	#18,d0
		bra.w	L4fb2

L984:
		dc.b	$11,$2b,$12,$2d,$4,$2a,$5,$2f,$2,$28,$3,$29,$13,$7e,$8,$3d
		dc.b	$e,$26,$ea,$21,$10,$5e,$f,$7c,$fe,$24,$fa,$25,$f8,$40,$f4,$27
		dc.b	$f4,$22,$0

L9a7:
		ds.b	4
		dc.b	$4,$4,$16,$16,$14,$14,$14,$14,$14,$14,$12,$12,$12,$2,$2,$1d
		dc.b	$1e,$1e,$0

L9be:
		dc.b	$2,$3a,$2,$56,$2,$7a,$2,$7e,$2,$82,$2,$aa,$2,$b0,$2,$b6
		dc.b	$2,$bc,$2,$c2,$2,$6e,$2,$72,$2,$76,$1,$ca,$2,$8,$2,$c8
		dc.b	$2,$d4,$2,$d2

L9e2:
		lea	1456(a6),a0
		move.w	(a0),d0
		addq.w	#2,(a0)+
		move.w	#$0,0(a0,d0.w)
		moveq	#1,d5
		bsr.w	Ld20

L9f6:
		cmp.b	#$2,d5
		bne.s	la0c
		cmp.b	#$4,d7
		bcs.w	laf6
		cmp.b	#$16,d7
		bcc.w	laf6
	la0c:	cmp.b	#$1,d7
		bne.s	la26
	la12:	lea	1496(a6),a0
		move.w	(a0),d0
		addq.w	#8,(a0)+
		move.l	d2,0(a0,d0.w)
		move.l	d3,4(a0,d0.w)
		bra.w	Laec
	la26:	cmp.b	#$2,d7
		beq.w	lac0
		cmp.b	#$4,d7
		bcs.w	lb02
		cmp.b	#$16,d7
		bcc.w	lb02
		cmp.b	#$1,d5
		bne.s	la96
		cmp.b	#$11,d7
		beq.s	la90
		cmp.b	#$12,d7
		beq.s	la94
		cmp.b	#$4,d7
		beq.s	la60
		cmp.b	#$13,d7
		bne.w	L97e
		bra.s	la96
	la60:	move.l	476(a6),d2
		moveq	#0,d3
		move.b	266(a6),d3
		cmp.b	#$1,d3
		bne.s	la74
		addq.b	#1,267(a6)
	la74:	tst.b	255(a6)
		bne.s	la12
		tst.b	464(a6)
		beq.s	la12
		moveq	#0,d0
		move.b	316(a6),d0
		lea	366(a6),a0
		add.l	0(a0,d0.w),d2
		bra.s	la12
	la90:	moveq	#21,d7
		bra.s	la96
	la94:	moveq	#20,d7
	la96:	lea	L9a7(pc),a2
		lea	1456(a6),a0
		move.w	(a0),d0
		move.w	0(a0,d0.w),d6
		move.b	0(a2,d6.w),d6
		cmp.b	0(a2,d7.w),d6
		bge.s	lab6
		addq.w	#2,(a0)+
		move.w	d7,0(a0,d0.w)
		bra.s	labc
	lab6:	bsr.w	Lb32
		bra.s	la96
	labc:	moveq	#0,d5
		bra.s	Laec
	lac0:	bsr.w	L9e2
		lea	1496(a6),a0
		move.w	(a0),d0
		addq.w	#8,(a0)+
		move.l	d2,0(a0,d0.w)
		move.l	d3,4(a0,d0.w)
		tst.w	d3
		bpl.s	lade
		moveq	#41,d0
		bsr.w	L4fb6
	lade:	cmp.b	#$3,d7
		beq.s	laea
		moveq	#19,d0
		bra.w	L4fb2
	laea:	moveq	#1,d5

Laec:
		addq.w	#1,d5
		bsr.w	Ld20
		bra.w	L9f6
	laf6:	cmp.b	#$3,d7
		beq.s	lb02
		movea.l	a0,a4
		move.b	-1(a4),d1
	lb02:	lea	L9a7(pc),a2
	lb06:	lea	1456(a6),a0
		move.w	(a0),d0
		tst.w	0(a0,d0.w)
		beq.s	lb18
		bsr.w	Lb32
		bra.s	lb06
	lb18:	subq.w	#2,1456(a6)
		lea	1496(a6),a0
		subq.w	#8,(a0)
		move.w	(a0)+,d0
		move.l	0(a0,d0.w),d2
		move.l	4(a0,d0.w),d3
		rts
	lb2e:	bra.w	L97e

Lb32:
		lea	1496(a6),a0
		subq.w	#8,(a0)
		bcs.s	lb2e
		move.w	(a0)+,d0
		move.l	0(a0,d0.w),d2
		move.l	4(a0,d0.w),d3
		move.w	d1,-(a7)
		lea	1456(a6),a1
		subq.w	#2,(a1)
		move.w	(a1)+,d1
		move.w	0(a1,d1.w),d1
		cmp.b	#$13,d1
		bcc.s	lb6a
		subq.w	#8,-(a0)
		bcs.s	lb2e
		move.w	(a0)+,d0
		move.l	4(a0,d0.w),d6
		move.l	0(a0,d0.w),d0
		exg	d0,d2
		exg	d6,d3
	lb6a:	lea	L9be(pc),a1
		add.w	d1,d1
		move.w	-8(a1,d1.w),d1
		jsr	0(a1,d1.w)
		move.w	(a7)+,d1
		move.w	-(a0),d0
		addq.w	#8,(a0)+
		move.l	d2,0(a0,d0.w)
		move.l	d3,4(a0,d0.w)
		rts
		dc.b	$d4,$80,$b6,$3c,$0,$1,$67,$e,$bc,$3c,$0,$1,$67,$e,$2,$46
		dc.b	$ff,$0,$86,$46,$4e,$75,$bc,$3c,$0,$1,$67,$6,$16,$3c,$0,$1
		dc.b	$60,$ec,$4a,$2e,$1,$9,$66,$e,$4a,$2e,$1,$d0,$67,$6,$70,$15
		dc.b	$61,$0,$43,$fc,$50,$c4,$76,$2,$4e,$75,$70,$14,$60,$f2,$94,$80
		dc.b	$30,$3,$80,$46,$2,$40,$80,$0,$4a,$46,$6b,$1e,$bc,$3c,$0,$1
		dc.b	$66,$4,$55,$2e,$1,$b,$bc,$3,$67,$8,$bc,$3c,$0,$1,$66,$6
		dc.b	$61,$c0,$16,$3c,$0,$2,$86,$40,$4e,$75,$61,$0,$3c,$a,$60,$e6
		dc.b	$61,$8,$61,$0,$0,$9a,$76,$2,$4e,$75,$bc,$3c,$0,$1,$67,$a2
		dc.b	$8c,$43,$6b,$b6,$b6,$3c,$0,$1,$67,$98,$4e,$75,$61,$ec,$2f,$7
		dc.b	$61,$0,$0,$b0,$4c,$df,$0,$80,$66,$2,$4e,$75,$4a,$2e,$1,$d0
		dc.b	$66,$8e,$60,$90,$c4,$80,$60,$d2,$84,$80,$60,$ce,$b1,$82,$60,$ca
		dc.b	$e1,$aa,$60,$c6,$e0,$aa,$60,$c2,$b4,$80,$57,$c2,$48,$82,$48,$c2
		dc.b	$30,$3,$80,$46,$6b,$0,$ff,$74,$bc,$3,$67,$10,$b6,$3c,$0,$1
		dc.b	$67,$0,$ff,$50,$bc,$3c,$0,$1,$67,$0,$ff,$48,$76,$2,$4e,$75
		dc.b	$b4,$80,$56,$c2,$60,$d6,$b4,$80,$5d,$c2,$60,$d0,$b4,$80,$5e,$c2
		dc.b	$60,$ca,$b4,$80,$5f,$c2,$60,$c4,$b4,$80,$5c,$c2,$60,$be,$46,$82
		dc.b	$b6,$7c,$0,$1,$67,$0,$ff,$1c,$4e,$75,$44,$82,$60,$f2,$2c,$2
		dc.b	$b1,$86,$4a,$82,$6e,$2,$44,$82,$4a,$80,$6e,$2,$44,$80,$26,$2
		dc.b	$48,$43,$c4,$c0
		dc.b	"H@JCg"
		dc.b	$4,$48,$40,$60,$6,$4a,$40,$67,$8,$48,$43,$c0,$c3,$48,$40,$d4
		dc.b	$80,$4a,$86,$6a,$2,$44,$82,$4e,$75,$4a,$80,$67,$4a,$2c,$2,$b1
		dc.b	$86,$2f,$6,$2f,$2,$4a,$80,$6a,$2,$44,$80,$4a,$82,$6a,$2,$44
		dc.b	$82,$7c,$1f,$2e,$0,$70,$0,$de,$87,$55,$ce,$ff,$fc,$e2,$97,$4
		dc.b	$46,$0,$1f,$44,$46,$d0,$80,$b4,$87,$65,$4,$52,$80,$94,$87,$e2
		dc.b	$8f,$51,$ce,$ff,$f2,$2c,$1f,$6a,$2,$44,$82,$2c,$1f,$6a,$2,$44
		dc.b	$80,$c1,$42,$b0,$0
		dc.b	"Nup;Nu"
	ld1c:	movea.l	a4,a0
		rts

Ld20:
		moveq	#22,d7
		cmp.b	#$d,d1
		beq.s	ld1c
		cmp.b	#$9,d1
		beq.s	ld1c
		cmp.b	#$20,d1
		beq.s	ld1c
		cmp.b	#$2c,d1
		beq.s	ld1c
		movem.l	a1-2/d5-6,-(a7)
		move.l	a4,-(a7)
		moveq	#0,d7
		cmp.b	#$41,d1
		bcs.s	ld5a
		cmp.b	#$5b,d1
		bcs.s	ld88
		cmp.b	#$61,d1
		bcs.s	ld5a
		cmp.b	#$7b,d1
		bcs.s	ld88
	ld5a:	lea	L984(pc),a0
	ld5e:	move.b	(a0)+,d7
		beq.s	ld6e
		cmp.b	(a0)+,d1
		bne.s	ld5e
		tst.b	d7
		bmi.w	le62
		bra.s	ldd0
	ld6e:	cmp.b	#$3c,d1
		beq.s	lda4
		cmp.b	#$3e,d1
		beq.s	ldba
		moveq	#0,d2
		cmp.b	#$3a,d1
		bcc.s	ld88
		cmp.b	#$30,d1
		bcc.s	ldda
	ld88:	lea	1052(a6),a0
		bsr.w	L4444
		beq.w	lfd4
		moveq	#22,d7
		bra.s	Ldd2
		dc.b	$12,$1c,$b2,$3c,$0,$3d,$67,$16,$7e,$f,$60,$2e
	lda4:	moveq	#10,d7
		move.b	(a4)+,d1
		cmp.b	#$3c,d1
		beq.s	ldce
		cmp.b	#$3e,d1
		beq.s	ldb6
		bra.s	ldc4
	ldb6:	moveq	#9,d7
		bra.s	ldd0
	ldba:	moveq	#11,d7
		move.b	(a4)+,d1
		cmp.b	#$3e,d1
		beq.s	ldce
	ldc4:	cmp.b	#$3d,d1
		bne.s	Ldd2
		addq.w	#2,d7
		bra.s	ldd0
	ldce:	subq.w	#4,d7
	ldd0:	move.b	(a4)+,d1

Ldd2:
		movea.l	(a7)+,a0
		movem.l	(a7)+,d5-6/a1-2
		rts
	ldda:	lea	-1(a4),a0
	ldde:	add.l	d2,d2
		move.l	d2,d0
		add.l	d0,d0
		add.l	d0,d0
		add.l	d0,d2
		subi.b	#$30,d1
		andi.l	#$f,d1
		add.l	d1,d2
		move.b	(a4)+,d1
		cmp.b	#$3a,d1
		bcc.s	le02
		cmp.b	#$30,d1
		bcc.s	ldde
	le02:	moveq	#1,d7
		moveq	#2,d3
		cmp.b	#$24,d1
		bne.s	Ldd2
		bra.w	L1116
		dc.b	$70,$4,$16,$1,$12,$1c,$b2,$3c,$0,$d,$67,$0,$0,$c2,$b2,$3
		dc.b	$66,$a,$12,$1c,$b2,$3,$67,$4,$76,$2,$60,$a6,$53,$0,$65,$0
		dc.b	$0,$b8,$e1,$8a,$14,$1,$60,$dc,$12,$1c,$4,$1,$0,$30,$65,$0
		dc.b	$0,$9e,$b2,$3c,$0,$2,$64,$0,$0,$96,$d4,$82,$65,$0,$0,$9a
		dc.b	$84,$1,$12,$1c,$4,$1,$0,$30,$65,$7c,$b2,$3c,$0,$2,$65,$ea
		dc.b	$60,$74
	le62:	neg.b	d7
		ext.w	d7
		moveq	#0,d2
		moveq	#2,d3
		moveq	#1,d0
		exg	d0,d7
		jmp	Le70(pc,d0.w)
		dc.b	$60,$0,$0,$44,$60,$c0,$60,$0,$0,$16,$60,$92,$60,$0,$ff,$24
		dc.b	$60,$0,$ff,$36,$60,$0,$ff,$10,$72,$40,$60,$0,$fe,$fa,$10,$14
		dc.b	$4,$0,$0,$30,$65,$f2,$b0,$3c,$0,$9,$64,$ec,$12,$0,$52,$8c
		dc.b	$e7,$8a,$65,$42,$84,$1,$12,$1c,$4,$1,$0,$30,$65,$26,$b2,$3c
		dc.b	$0,$9,$65,$ec,$60,$1e,$41,$fa,$0,$32,$72,$0,$12,$1c,$6b,$1c
		dc.b	$12,$30,$10,$0,$6b,$16,$e9,$8a,$84,$1,$12,$1c,$6b,$6,$12,$30
		dc.b	$10,$0,$6a,$f2,$12,$2c,$ff,$ff,$60,$0,$fe,$f6,$70,$16,$61,$0
		dc.b	$40,$d4,$50,$c4,$60,$ee,$70,$17,$60,$f4,$ff,$ff,$ff,$ff,$ff,$ff
		dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
		dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
		dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$0,$1,$2,$3,$4,$5
		dc.b	$6,$7,$8,$9,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$a,$b,$c,$d,$e
		dc.b	$f,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
		dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$a,$b,$c,$d,$e
		dc.b	$f,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
		dc.b	$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

Lf6c:
		movea.l	(a0),a1
		subq.l	#4,a7
		move.b	(a1)+,2(a7)
		move.b	(a1)+,3(a7)
		move.b	(a1)+,(a7)
		move.b	(a1)+,1(a7)
		move.l	(a7)+,d0
		cmp.l	#$52474e41,d0
		beq.s	lfc2
		cmp.w	#$5f5f,d0
		bne.s	lfc0
		swap	d0
		cmp.w	#$5253,d0
		beq.s	lfba
		cmp.w	#$4732,d0
		beq.s	lfb4
		cmp.w	#$4c4b,d0
		beq.s	lfa4
		bne.s	lfc0
	lfa4:	moveq	#0,d2
		tst.b	255(a6)
		beq.s	lfb6
		move.w	452(a6),d2
		addq.w	#1,d2
		bra.s	lfb6
	lfb4:	moveq	#42,d2
	lfb6:	moveq	#0,d0
		rts
	lfba:	move.l	18294(a6),d2
		bra.s	lfb6
	lfc0:	rts
	lfc2:	moveq	#0,d2
		tst.b	259(a6)
		beq.s	lfc0
		movea.l	18302(a6),a1
		move.w	8(a1),d2
		bra.s	lfb6
	lfd4:	moveq	#1,d7
		cmp.b	#$23,d1
		seq	4(a0)
		bne.s	lfea
		move.b	(a4)+,d1
		tst.b	255(a6)
		sne	4(a0)
	lfea:	cmpi.b	#$4,5(a0)
		bne.s	Lffc
		bsr.w	Lf6c
		bne.s	Lffc
		moveq	#2,d3
		bra.s	l104c

Lffc:
		tst.b	464(a6)
		bne.w	l1090
		bsr.w	L7a6
		beq.s	l1018
		moveq	#0,d2
		st	d4
		moveq	#2,d3
		tst.b	4(a0)
		beq.s	l104c
		bra.s	l104c
	l1018:	move.l	8(a1),d2
		moveq	#0,d3
		move.b	13(a1),d3
		btst	#$4,12(a1)
		bne.s	l1054
	l102a:	cmp.b	#$2,d3
		beq.s	l104c
		cmp.b	#$d,d3
		beq.s	l104c
		cmp.b	#$1,d3
		beq.s	l1076
		cmp.b	#$5,d3
		bne.w	l1142
		moveq	#2,d3
		moveq	#7,d0
		bsr.w	L506a
	l104c:	move.b	-1(a4),d1
		bra.w	Ldd2
	l1054:	st	d4
		swap	d3
		move.w	20(a1),d3
		bsr.w	L47d4
		swap	d3
		move.b	-1(a4),d1
		tst.b	464(a6)
		beq.w	Ldd2
		ori.w	#$8000,d3
		bra.w	Ldd2
	l1076:	tst.b	255(a6)
		bne.s	l1082
		tst.b	14(a1)
		beq.s	l104c
	l1082:	move.b	316(a6),d0
		cmp.b	14(a1),d0
		beq.s	l104c
		st	d4
		bra.s	l104c
	l1090:	bsr.w	L7a6
		sne	d0
		move.b	-1(a4),d1
		cmp.b	#$23,d1
		bne.s	l10a2
		move.b	(a4)+,d1
	l10a2:	tst.b	d0
		bne.w	l1150
		btst	#$7,12(a1)
		beq.s	l10ba
		btst	#$6,12(a1)
		beq.w	l1150
	l10ba:	move.l	8(a1),d2
		moveq	#0,d3
		move.b	13(a1),d3
		tst.b	255(a6)
		bne.s	l10e4
		cmp.b	#$1,d3
		bne.w	l102a
		moveq	#0,d0
		move.b	14(a1),d0
		lea	366(a6),a0
		add.l	0(a0,d0.w),d2
		bra.w	Ldd2
	l10e4:	btst	#$4,12(a1)
		bne.w	l1054
		cmp.b	#$1,d3
		bne.w	l102a
		move.b	316(a6),d0
		cmp.b	14(a1),d0
		bne.s	l1108
		addq.b	#1,267(a6)
		bra.w	Ldd2
	l1108:	ori.w	#$8000,d3
		st	d4
		bsr.w	L47ea
		bra.w	Ldd2

L1116:
		movea.l	a0,a1
		lea	1052(a6),a0
		lea	6(a0),a2
		move.l	a2,(a0)
		sf	4(a0)
		move.b	278(a6),(a2)+
		move.l	a4,d0
		sub.l	a1,d0
		move.b	d0,5(a0)
		subq.b	#1,d0
	l1134:	move.b	(a1)+,(a2)+
		subq.b	#1,d0
		bne.s	l1134
		move.b	(a4)+,d1
		moveq	#1,d7
		bra.w	Lffc
	l1142:	moveq	#24,d0
	l1144:	moveq	#2,d3
		st	d4
		bsr.w	L4fb6
		bra.w	Ldd2
	l1150:	moveq	#3,d0
		bra.s	l1144
		dc.b	$61,$0,$f7,$fe,$4a,$2e,$0,$ff,$67,$4,$4a,$43,$6b,$2,$4e,$75
		dc.b	$50,$c4,$70,$14,$60,$0,$3e,$4c,$61,$e6,$b6,$3c,$0,$1,$66,$8
		dc.b	$4a,$2e,$1,$9,$67,$0,$3e,$a,$70,$0
		dc.b	"Nu WT"
		dc.b	$97,$60,$6,$20,$57,$54,$97,$3a,$c6,$30,$10,$3f,$0,$8,$0,$0
		dc.b	$6,$67,$8,$61,$0,$1,$76,$30,$1f,$60,$6,$61,$0,$1,$7a,$30
		dc.b	$1f,$20,$6e,$1,$f8,$8b,$50,$ba,$3c,$0,$30,$65,$28,$ba,$3c,$0
		dc.b	$3a,$65,$14,$ba,$3c,$0,$3c,$67,$16,$8,$5,$0,$6,$66,$26,$8
		dc.b	$0,$0,$6,$67,$1a,$4e,$75,$8,$0,$0,$5,$67,$12,$4e,$75,$4a
		dc.b	$0,$6a,$c,$4e,$75,$14,$5,$e6,$a,$5,$0,$67,$2,$4e,$75,$70
		dc.b	$11,$60,$0,$3d,$d0,$2,$45,$0,$bf,$34,$5,$e1,$5a,$c0,$42,$67
		dc.b	$ee,$20,$5f,$4e,$e8,$0,$2,$70,$24,$60,$0,$3d,$b4,$61,$1a,$66
		dc.b	$f6,$4a,$0,$66,$f2,$4e,$75,$61,$10,$66,$c,$4a,$0,$66,$6,$70
		dc.b	$10,$61,$0,$3d,$a0,$b0,$0,$4e,$75,$10,$1,$20,$4c,$48,$80,$10
		dc.b	$36,$0,$7e,$b0,$3c,$0,$41,$67,$28,$b0,$3c,$0,$44,$67,$22,$b0
		dc.b	$3c,$0,$52,$67,$48,$b0,$3c,$0,$53,$66,$0,$0,$78,$10,$18,$48
		dc.b	$80,$10,$36,$0,$7e,$b0,$3c,$0,$50,$66,$68,$70,$1,$74,$7,$60
		dc.b	$14,$14,$18,$b4,$3c,$0,$37,$62,$5a,$4,$2,$0,$30,$65,$54,$b0
		dc.b	$3c,$0,$41,$57,$c0,$2,$0,$0,$1,$72,$0,$12,$18,$43,$fa,$5d
		dc.b	$70,$4a,$31,$10,$0,$67,$3c,$28,$48,$b0,$0,$4e,$75,$14,$18,$b4
		dc.b	$3c,$0,$39,$62,$2e,$b4,$3c,$0,$30,$65,$28,$b4,$3c,$0,$31,$66
		dc.b	$16,$10,$10,$b0,$3c,$0,$36,$64,$e,$b0,$3c,$0,$30,$65,$8,$6
		dc.b	$0,$0,$a,$14,$0,$52,$88,$4,$2,$0,$30,$b4,$3c,$0,$8,$54
		dc.b	$c0,$60,$b2,$41,$ee,$4,$1c,$48,$e7,$0,$28,$12,$2c,$ff,$ff,$61
		dc.b	$0
		dc.b	"1Hf:$n"
		dc.b	$1,$5e,$48,$e7,$50,$1c,$61,$0,$f5,$8,$4c,$df,$38,$a,$66,$28
		dc.b	$c,$29,$0,$4,$0,$d,$66,$20,$10,$29,$0,$9,$14,$29,$0,$b
		dc.b	$4a,$2e,$1,$d0,$67,$8,$8,$29,$0,$6,$0,$c,$67,$a,$4c,$df
		dc.b	$5,$0,$24,$48,$b0,$0,$4e,$75,$4c,$df,$14,$0,$12,$2c,$ff,$ff
		dc.b	$70,$ff,$4e,$75,$4a,$2e,$1,$19,$67,$6,$50,$ee,$1,$1a,$60,$4
		dc.b	$51,$ee,$1,$1a,$61,$0,$fe,$fc,$66,$18,$7a,$0,$8a,$2,$4a,$0
		dc.b	$67,$e,$0,$5,$0,$8,$c,$2e,$0,$1,$1,$d1,$67,$0
		dc.b	"<DNu$L"
		dc.b	$b2,$3c,$0,$28,$67,$0,$1,$88,$b2,$3c,$0,$2d,$67,$0,$1,$b4
		dc.b	$b2,$3c,$0,$23,$67,$0,$1,$ce,$48,$81,$12,$36,$10,$7e,$b2,$3c
		dc.b	$0,$43,$67,$42,$b2,$3c,$0,$53,$67,$28,$b2,$3c,$0,$55,$66,$58
		dc.b	$12,$1c,$48,$81,$12,$36,$10,$7e,$b2,$3c,$0,$53,$66,$4a,$12,$1c
		dc.b	$48,$81,$12,$36,$10,$7e,$b2,$3c,$0,$50,$66,$3c,$7a,$4,$60,$0
		dc.b	$3,$dc,$12,$1c,$48,$81,$12,$36,$10,$7e,$b2,$3c,$0,$52,$66,$28
		dc.b	$7a,$2,$60,$0,$3,$c8,$12,$1c,$48,$81,$12,$36,$10,$7e,$b2,$3c
		dc.b	$0,$43,$66,$14,$12,$1c,$48,$81,$12,$36,$10,$7e,$b2,$3c,$0,$52
		dc.b	$66,$6,$7a,$1,$60,$0,$3,$a6,$28,$4a,$12,$2c,$ff,$ff,$61,$0
		dc.b	$f5,$86,$b2,$3c,$0,$28,$67,$0,$1,$c0,$b2,$3c,$0,$2e,$67,$46
		dc.b	$b2,$3c,$0
		dc.b	"\g@J."
		dc.b	$1,$1c,$66,$52,$8,$2e,$0,$2,$1,$f,$67,$28,$30,$42,$b1,$c2
		dc.b	$66,$22,$4a,$4,$66,$1e,$b6,$3c,$0,$1,$67,$18,$61,$0,$40,$a8
		dc.b	$66,$12,$3a,$c2,$8,$c4,$0,$f,$61,$0,$0,$82,$7a,$38,$70,$a
		dc.b	$60,$0,$3d,$d4,$4a,$2e,$1,$1a,$67,$4a,$60,$0,$2,$70,$10,$14
		dc.b	$48,$80,$10,$36,$0,$7e,$b0,$3c,$0,$4c,$67,$2e,$b0,$3c,$0,$57
		dc.b	$66,$32,$52,$8c,$12,$1c,$7a,$38,$4a,$2e,$1,$d0,$67,$18,$4a,$2e
		dc.b	$0,$ff,$67,$6,$4a,$43,$6b,$0,$4a,$5c,$61,$0,$31,$f0,$8,$84
		dc.b	$0,$e,$61,$0,$0,$38,$3a,$c2,$4e,$75,$52,$8c,$12,$1c,$8,$84
		dc.b	$0,$f,$60,$4,$8,$c4,$0,$f,$7a,$39,$4a,$2e,$1,$d0,$67,$18
		dc.b	$4a,$2e,$0,$ff,$67,$6,$4a,$43,$6b,$0,$4a,$6,$61,$e,$b6,$3c
		dc.b	$0,$1,$66,$4,$61,$0,$4a,$4e,$2a,$c2,$4e,$75,$4a,$2e,$1,$d3
		dc.b	$66,$2c,$c,$2e,$0,$1,$1,$d1,$67,$c,$4a,$2e,$1,$1e,$67,$6
		dc.b	$8,$2,$0,$0,$66,$1a,$8,$4,$0,$f,$67,$12,$b6,$3c,$0,$2
		dc.b	$66,$c,$4a,$2e,$1,$1d,$67,$6,$70,$50,$61,$0,$3a,$f4
		dc.b	"Nup""`"
		dc.b	$0,$3a,$ec,$12,$1c,$61,$0,$fd,$3a,$66,$0,$fe,$f2,$18,$2,$b2
		dc.b	$3c,$0,$29,$67,$10,$b2,$3c,$0,$2c,$66,$0,$3a,$ac,$42,$a7,$76
		dc.b	$2,$60,$0,$1,$14,$12,$1c,$7a,$10,$b2,$3c,$0,$2b,$66,$4,$7a
		dc.b	$18,$12,$1c,$8a,$4,$4e,$75,$c,$1c,$0,$28,$66,$0,$fe,$c0,$12
		dc.b	$1c,$61,$0,$fc,$fe,$66,$0,$fe,$b6,$b2,$3c,$0,$29,$66,$0,$3a
		dc.b	$78,$12,$1c,$7a,$20,$8a,$2,$4e,$75,$12,$1c,$61,$0,$f4,$2e,$7a
		dc.b	$3c,$10,$2e,$1,$d1,$67,$28,$53,$0,$67,$3e,$53,$0,$67,$20,$4a
		dc.b	$2e,$1,$d0,$67,$16,$4a,$2e,$0,$ff,$67,$6,$4a,$43,$6b,$0,$49
		dc.b	$3e,$b6,$3c,$0,$1,$66,$4,$61,$0,$49,$88,$2a,$c2,$4e,$75,$4a
		dc.b	$2e,$1,$d0,$67,$10,$4a,$2e,$0,$ff,$67,$6,$4a,$43,$6b,$0,$49
		dc.b	$4e,$61,$0,$30,$bc,$3a,$c2,$4e,$75,$4a,$2e,$1,$d0,$67,$f6,$4a
		dc.b	$2e,$0,$ff,$67,$4,$4a,$43,$6b,$c,$61,$0,$30,$94,$2,$42,$0
		dc.b	$ff,$3a,$c2,$4e,$75,$1a,$fc,$0,$0,$60,$0,$49,$3a,$12,$1c,$2f
		dc.b	$2,$61,$0,$fc,$80,$66,$0,$0,$c8,$61,$0,$fc,$6a,$b2,$3c,$0
		dc.b	$29,$66,$4c,$8,$2e,$0,$1,$1,$f,$67,$24,$4a,$4,$66,$20,$4a
		dc.b	$97,$66,$1c,$7a,$10,$8a,$2,$24,$1f,$61,$0,$3e,$e8,$66,$8,$12
		dc.b	$1c,$70,$9,$60,$0,$3c,$1e,$2f,$2,$14,$5,$2,$2,$0,$7,$7a
		dc.b	$28,$8a,$2,$24,$1f,$12,$1c,$4a,$2e,$0,$ff,$67,$6,$4a,$43,$6b
		dc.b	$0,$48,$c0,$3a,$c2,$4a,$2e,$1,$d0,$66,$0,$30,$4e,$4e,$75,$b2
		dc.b	$3c,$0,$2c,$66,$0,$39,$96,$7a,$30,$8a,$2,$12,$1c,$61,$0,$fc
		dc.b	$14,$66,$0,$39,$84,$e7,$8,$80,$2,$e9,$8,$48,$43,$16,$0,$24
		dc.b	$1f,$b2,$3c,$0,$2e,$67,$6,$b2,$3c,$0,$5c,$66,$1c,$12,$1c,$48
		dc.b	$81,$12,$36,$10,$7e,$b2,$3c,$0,$57,$67,$c,$b2,$3c,$0,$4c,$66
		dc.b	$0,$39,$5e,$0,$3,$0,$8,$12,$1c,$b2,$3c,$0,$29,$66,$0,$f4
		dc.b	$9c,$12,$1c,$1a,$c3,$48,$43,$4a,$2e,$0,$ff,$67,$6,$4a,$43,$6b
		dc.b	$0,$48,$68,$1a,$c2,$4a,$2e,$1,$d0,$66,$0,$2f,$d8,$4e,$75,$48
		dc.b	$81,$12,$36,$10,$7e,$b2,$3c,$0,$50,$66,$0,$39,$1c,$12,$1c,$48
		dc.b	$81,$12,$36,$10,$7e,$b2,$3c,$0,$43,$66,$0,$39,$c,$24,$1f,$12
		dc.b	$1c,$b2,$3c,$0,$29,$66,$46,$12,$1c,$7a,$3a,$4a,$2e,$1,$d0,$67
		dc.b	$38,$4a,$2e,$0,$ff,$67,$6,$4a,$43,$6b,$0,$47,$d6,$b6,$3c,$0
		dc.b	$2,$67,$1a,$8,$84,$0,$f,$61,$0,$fd,$e0,$94,$ae,$1,$dc,$20
		dc.b	$d,$90,$ae,$1,$f8,$94,$80,$3a,$c2,$60,$0,$2f,$84,$4a,$2e,$1
		dc.b	$9,$66,$e0,$70,$20,$61,$0,$38,$e6,$3a,$c2,$4e,$75,$b2,$3c,$0
		dc.b	$2c,$66,$0,$38,$b4,$7a,$3b,$2f,$2,$12,$1c,$61,$0,$fb,$36,$66
		dc.b	$0,$38,$a6,$e7,$8,$80,$2,$e9,$8,$18,$0,$b2,$3c,$0,$2e,$67
		dc.b	$6,$b2,$3c,$0,$5c,$66,$1c,$12,$1c,$48,$81,$12,$36,$10,$7e,$b2
		dc.b	$3c,$0,$57,$67,$c,$b2,$3c,$0,$4c,$66,$0,$38,$84,$0,$4,$0
		dc.b	$8,$12,$1c,$24,$1f,$1a,$c4,$4a,$2e,$1,$d0,$67,$36,$4a,$2e,$0
		dc.b	$ff,$67,$4
		dc.b	"JCk J."
		dc.b	$1,$9,$66,$6,$b6,$3c,$0,$2,$67,$1a,$94,$ae,$1,$dc,$20,$d
		dc.b	$90,$ae,$1,$f8,$94,$80,$52,$82,$61,$0,$2e,$f0,$60,$c,$61,$0
		dc.b	$47,$1c,$60,$8,$70,$20,$61,$0,$38,$5c,$1a,$c2,$b2,$3c,$0,$29
		dc.b	$66,$0,$f3,$80,$12,$1c,$4e,$75,$72,$0,$12,$1c,$43,$fa,$58,$72
		dc.b	$4a,$31,$10,$0,$67,$0,$fc,$4e,$8,$c5,$0,$6,$4e,$75,$61,$0
		dc.b	$19,$5a,$60,$4,$61,$0,$3,$66,$61,$0,$fb,$8e,$10,$5,$2,$40
		dc.b	$0,$78,$67,$c,$b0,$3c,$0,$20,$66,$0,$fa,$46,$0,$6,$0,$8
		dc.b	$2,$45,$0,$7,$8c,$45,$b2,$3c,$0,$2c,$66,$0,$37,$e6,$12,$1c
		dc.b	$3f,$0,$61,$0,$fb,$64,$10,$5,$2,$40,$0,$78,$b0,$5f,$66,$0
		dc.b	$fa,$20,$2,$45,$0,$7,$ee,$5d,$8c,$45,$3a,$c6,$4e,$75,$12,$1c
		dc.b	$61,$0,$f1,$80,$b2,$3c,$0,$2c,$66,$64,$4a,$4,$66,$60,$b6,$3c
		dc.b	$0,$2,$66,$5a,$b4,$bc,$0,$0,$0,$9,$64,$52,$4a,$82,$6f,$4e
		dc.b	$55,$8d,$61,$0,$3c,$b6,$66,$44,$2,$46,$40,$0,$8,$46,$0,$e
		dc.b	$ec,$4e,$0,$46,$50,$0,$61,$0,$18,$d2,$b4,$3c,$0,$8,$66,$2
		dc.b	$74,$0,$ee,$5a,$8c,$42,$12,$1c,$61,$0,$f9,$6a,$0,$3f,$4a,$2e
		dc.b	$1,$d0,$67,$e,$70,$0,$10,$2e,$1,$d1,$10,$3b,$0,$c,$d1,$6e
		dc.b	$1,$b4,$70,$c,$60,$0,$39,$b4,$2,$2,$2,$4,$54,$8d,$12,$1c
		dc.b	$61,$0,$fc,$e4,$60,$0,$0,$2c,$8,$6,$0,$e,$66,$f0,$44,$82
		dc.b	$60,$ec,$54,$8d,$b2,$3c,$0,$23,$66,$a,$8,$2e,$0,$4,$1,$f
		dc.b	$66,$0,$ff,$6c,$61,$0,$fa,$a6,$b2,$3c,$0,$2c,$66,$0,$37,$24
		dc.b	$12,$1c,$3f,$5,$61,$0,$fa,$a2,$38,$1f,$20,$6e,$1,$f8,$14,$5
		dc.b	$2,$2,$0,$78,$b4,$3c,$0,$8,$67,$0,$0,$4c,$b8,$3c,$0,$3c
		dc.b	$67,$30,$61,$0,$18,$46,$30,$86,$4a,$2,$66,$10,$da,$5,$8b,$18
		dc.b	$b8,$3c,$0,$40,$64,$0,$f9,$3a,$89,$10,$4e,$75,$10,$4,$2,$0
		dc.b	$0,$78,$66,$0,$f9,$2c,$d8,$4,$52,$4,$89,$18,$8b,$10,$70,$3c
		dc.b	$60,$10,$ea,$5e,$2,$46,$7,$0,$61,$0,$18,$10,$8c,$5,$30,$86
		dc.b	$70,$3d,$60,$0,$f8,$d4,$0,$6,$0,$c0,$8c,$4,$2,$45,$0,$7
		dc.b	$ee,$5d,$8c,$45,$c,$2e,$0,$3,$1,$d1,$66,$4,$8,$c6,$0,$8
		dc.b	$30,$86,$3a,$4,$ba,$3c,$0,$40,$64,$0,$f8,$e6,$c,$2e,$0,$1
		dc.b	$1,$d1,$67,$0,$36,$76,$4e,$75,$c,$2e,$0,$3,$1,$d1,$66,$4
		dc.b	$0,$46,$1,$0,$61,$0,$f8,$6e,$0,$ff,$b2,$3c,$0,$2c,$66,$0
		dc.b	$36,$72,$12,$1c,$61,$0,$f8,$e2,$66,$0,$f8,$e6,$d4,$2,$20,$6e
		dc.b	$1,$f8,$85,$10,$60,$c6,$61,$0,$17,$a2,$3a,$c6,$b2,$3c,$0,$23
		dc.b	$66,$0,$36,$58,$12,$1c,$61,$0,$fb,$da,$b2,$3c,$0,$2c,$66,$0
		dc.b	$36,$42,$12,$1c,$61,$0,$f8,$28,$0,$3d,$4e,$75,$10,$2e,$1,$d1
		dc.b	$67,$0,$0,$8e,$b0,$3c,$0,$1,$67,$16,$b0,$3c,$0,$2,$67,$0
		dc.b	$0,$62,$70,$5,$61,$0,$36,$f2
		dc.b	"`Xp!`"
		dc.b	$0,$36,$36,$61,$0,$0,$c6,$67,$34,$e0,$4e,$1a,$c6,$4a,$2e,$0
		dc.b	$ff,$67,$6,$4a,$43,$6b,$0,$44,$d8,$4a,$82,$66,$30,$bc,$3c,$0
		dc.b	$61,$67,$20,$8,$2e,$0,$6,$1,$f,$66,$8,$70,$51,$61,$0,$36
		dc.b	$8,$60,$6,$70,$e,$61,$0,$38,$36,$2a,$6e,$1,$f8,$3a,$fc,$4e
		dc.b	$71,$4e,$75,$1a,$fc,$0,$ff,$70,$3d,$60,$0,$35,$ec,$61,$0,$2c
		dc.b	$6e,$1a,$c2
		dc.b	"Nuatg"
		dc.b	$16,$3a,$c6,$4a,$2e,$0,$ff,$67,$6,$4a,$43,$6b,$0,$44,$96,$61
		dc.b	$0,$2c,$60,$3a,$c2,$4e,$75,$58,$8d,$4e,$75,$8,$2e,$0,$0,$1
		dc.b	$f,$67,$da,$61,$0,$ef,$58,$4a,$4,$66,$42,$4a,$2e,$1,$9,$66
		dc.b	$6,$b6,$3c,$0,$2,$67,$36,$2f,$2,$94,$ae,$1,$dc,$55,$82,$67
		dc.b	$2a,$10,$2,$48,$80,$48,$c0,$b4,$80,$66,$20,$61,$0,$3a,$88,$66
		dc.b	$c,$58,$8f,$8c,$2,$3a,$c6,$70,$8,$60,$0,$37,$ba,$8,$2e,$0
		dc.b	$5,$1,$f,$67,$6,$70,$d,$61,$0,$37,$ac,$24,$1f,$48,$7a,$ff
		dc.b	$90,$60,$4,$61,$0,$ef,$8,$4a,$2e,$1,$d0,$66,$10,$4a,$4,$66
		dc.b	$34,$b6,$3c,$0,$2,$66,$2e,$4a,$2e,$1,$9,$66,$28,$4a,$2e,$0
		dc.b	$ff,$67,$4,$4a,$43,$6b,$1e,$4a,$2e,$1,$9,$66,$6,$b6,$3c,$0
		dc.b	$2,$67,$18,$8,$2,$0,$0,$67,$6,$70,$22,$61,$0,$35,$32,$94
		dc.b	$ae,$1,$dc,$55,$82,$4a,$2e,$1,$d0
		dc.b	"Nup a"
		dc.b	$0,$35,$20,$4a,$2e,$1,$d0,$4e,$75,$50,$ee,$1,$d3,$b2,$3c,$0
		dc.b	$23,$67,$1e,$61,$0,$f7,$56,$b2,$3c,$0,$2c,$66,$0,$34,$e2,$12
		dc.b	$1c,$d4,$2,$52,$2,$1a,$c2,$1a,$c6,$61,$0,$f6,$c0,$0,$fd,$60
		dc.b	$1c,$3a,$c6,$12,$1c,$61,$0,$ee,$88,$61,$0,$fa,$a2,$b2,$3c,$0
		dc.b	$2c,$66,$0,$34,$bc,$12,$1c,$61,$0,$f6,$a2,$0,$7d,$2,$45,$0
		dc.b	$38,$66,$6,$70,$3,$60,$0,$8,$aa,$70,$1,$60,$0,$8,$a4,$50
		dc.b	$ee,$1,$d3,$b2,$3c,$0,$23,$67,$1e,$61,$0,$f7,$0,$b2,$3c,$0
		dc.b	$2c,$66,$0,$34,$8c,$12,$1c,$d4,$2,$52,$2,$1a,$c2,$1a,$c6,$61
		dc.b	$0,$f6,$6a,$0,$3d,$60,$c6,$3a,$c6,$12,$1c,$61,$0,$ee,$32,$61
		dc.b	$0,$fa,$4c,$b2,$3c,$0,$2c,$66,$0,$34,$66,$12,$1c,$61,$0,$f6
		dc.b	$4c,$0,$3d,$60,$a8,$61,$0,$f6,$4a,$0,$fd,$b2,$3c,$0,$2c,$66
		dc.b	$0,$34,$4e,$12,$1c,$61,$0,$f6,$b4,$20,$6e,$1,$f8,$d4,$2,$85
		dc.b	$10,$70,$2,$60,$0,$8,$3c,$61,$0,$15,$7e,$3a,$c6,$61,$0,$f7
		dc.b	$aa,$b2,$3c,$0,$2c,$66,$0,$34,$28,$12,$1c,$3f,$5,$61,$0,$f7
		dc.b	$a6,$38,$1f,$20,$6e,$1,$f8,$30,$5,$2,$0,$0,$78,$67,$4a,$b0
		dc.b	$3c,$0,$8,$67,$54,$b8,$3c,$0,$3c,$67,$74,$10,$4,$2,$0,$0
		dc.b	$78,$b0,$3c,$0,$18,$66,$2e,$10,$5,$2,$0,$0,$78,$b0,$3c,$0
		dc.b	$18,$66,$22,$3c,$3c,$b1,$8,$61,$0,$15,$2e,$10,$4,$2,$0,$0
		dc.b	$7,$8c,$0,$10,$5,$2,$40,$0,$7,$ee,$58,$8c,$40,$20,$6e,$1
		dc.b	$f8,$30,$86,$4e,$75,$60,$0,$f6,$16,$da,$5,$8b,$10,$3a,$4,$8b
		dc.b	$50,$30,$3c,$0,$ff,$60,$0,$f5,$ce,$2,$5,$0,$7,$da,$5,$c
		dc.b	$2e,$0,$3,$1,$d1,$66,$2,$52,$5,$8b,$10,$3a,$4,$0,$44,$0
		dc.b	$c0,$89,$50,$30,$3c,$0,$ff,$61,$0,$f5,$ac,$60,$0,$fc,$fc,$3c
		dc.b	$3c,$c,$0,$61,$0,$14,$d2,$8c,$45,$30,$86,$70,$3d,$60,$0,$f5
		dc.b	$96,$61,$0,$14,$c4,$61,$16,$8c,$5,$b2,$3c,$0,$2c,$66,$0,$33
		dc.b	$70,$12,$1c,$61,$8,$ee,$5d,$8c,$45,$3a,$c6,$4e,$75,$61,$0,$f6
		dc.b	$e6,$10,$5,$2,$0,$0,$78,$b0,$3c,$0,$18,$66,$0,$f5,$a0,$2
		dc.b	$45,$0,$7,$4e,$75,$61,$0,$15,$76,$b2,$3c,$0,$2c,$66,$0,$33
		dc.b	$40,$12,$1c,$2a,$2,$61,$0,$15,$66,$20,$2,$67,$18,$6b,$3c,$2f
		dc.b	$2,$24,$2e,$1,$dc,$20,$17,$61,$0,$f0,$5c,$24,$1f,$4a,$80,$67
		dc.b	$4,$90,$82,$44,$80,$d0,$85,$28,$0,$67,$10,$b0,$bc,$0,$0,$0
		dc.b	$80,$64,$18,$1a,$fc,$0,$0,$53,$0,$66,$f8,$d8,$ae,$1,$dc,$41
		dc.b	$ee,$3,$96,$4a,$90,$66,$0,$eb,$f6,$4e,$75,$70,$1c,$60,$0,$33
		dc.b	$12,$43,$ec,$ff,$ff,$b2,$3c,$0,$d,$67,$1a,$12,$1c,$b2,$3c,$0
		dc.b	$d,$66,$f8,$24,$c,$94,$89,$53,$42,$4a,$2e,$1,$d0,$67,$6,$61
		dc.b	$0,$40,$12,$72,$d,$4e,$75,$61,$0,$f5,$32,$8c,$2,$b2,$3c,$0
		dc.b	$2c,$66,$0,$32,$bc,$12,$1c,$61,$0,$fe,$78,$60,$0,$fc,$f2,$3f
		dc.b	$1,$10,$2e,$1,$d1,$67,$6,$b0,$3c,$0,$1,$67,$10,$61,$0,$eb
		dc.b	$80,$10,$2e,$1,$d1,$66,$2,$70,$2,$32,$1f,$4e,$75,$41,$ee,$3
		dc.b	$96,$4a,$90,$67,$8,$28,$2e,$1,$dc,$61,$0,$eb,$82,$10,$2e,$1
		dc.b	$d1,$60,$e6,$61,$ca,$61,$0,$14,$a6,$b2,$3c,$0,$2c,$67,$6,$2f
		dc.b	$2,$74,$0,$60,$8,$12,$1c,$2f,$2,$61,$0,$14,$92,$76,$0,$41
		dc.b	$fa,$1,$6e,$22,$2,$16,$2e,$1,$d1,$16,$30,$30,$0,$28,$1f,$42
		dc.b	$ae,$1,$9e,$4a,$2e,$1,$5,$67,$6,$4a,$2e,$1,$d0,$66,$16,$e7
		dc.b	$ac,$6a,$0,$0,$8,$70,$52,$60,$0,$32,$54,$2d,$44,$1,$ae,$12
		dc.b	$2c,$ff,$ff,$4e,$75,$1d,$7c,$0,$ff,$47,$6d,$2d,$6e,$1,$dc,$47
		dc.b	$6e,$61,$0,$3f,$b4,$67,$d8,$42,$ae,$1,$ae,$53,$84,$65,$e0,$48
		dc.b	$7a,$ff,$de,$53,$3,$65,$2a,$67,$14,$2a,$c1,$7a,$4,$61,$36,$51
		dc.b	$cc,$ff,$f8,$4,$84,$0,$1,$0,$0,$64,$ee,$4e,$75,$3a,$c1,$7a
		dc.b	$2,$61,$22,$51,$cc,$ff,$f8,$4,$84,$0,$1,$0,$0,$64,$ee,$4e
		dc.b	$75,$1a,$c1,$7a,$1,$61,$e,$51,$cc,$ff,$f8,$4,$84,$0,$1,$0
		dc.b	$0,$64,$ee,$4e,$75,$2f,$1,$22,$5,$24,$2e,$1,$dc,$d4,$ae,$1
		dc.b	$ae,$61,$0,$3f,$2e,$db,$ae,$1,$ae,$22,$1f,$2a,$6e,$1,$f8,$4e
		dc.b	$75,$61,$0,$fe,$fc,$b0,$3c,$0,$1,$67,$38,$b0,$3c,$0,$3,$67
		dc.b	$c,$61,$0,$eb,$5c,$61,$0,$f7,$5c,$61,$e,$60,$f4,$61,$0,$eb
		dc.b	$50,$61,$0,$f7,$30,$61,$2,$60,$f4,$b2,$3c,$0,$2c,$66,$10,$12
		dc.b	$1c,$b2,$3c,$0,$9,$67,$f8,$b2,$3c,$0,$20,$67,$f2,$4e,$75,$58
		dc.b	$8f,$4e,$75,$b2,$3c,$0,$27,$67,$2a,$b2,$3c,$0,$22,$67,$24,$61
		dc.b	$0,$eb,$1e,$4a,$2e,$1,$d0,$67,$e,$4a,$2e,$0,$ff,$67,$4,$4a
		dc.b	$43,$6b,$a,$61,$0,$27,$ce,$1a,$c2,$61,$be,$60,$d6,$61,$0,$40
		dc.b	$7a,$60,$f6,$16,$1,$48,$e7,$0,$c,$12,$1c,$b2,$3c,$0,$d,$67
		dc.b	$36,$b2,$3,$66,$6,$12,$1c,$b6,$1,$66,$4,$1a,$c1,$60,$ea,$b2
		dc.b	$3c,$0,$d,$67,$1a,$b2,$3c,$0,$9,$67,$14,$b2,$3c,$0,$20,$67
		dc.b	$e,$b2,$3c,$0,$2c,$67,$8,$4c,$df,$30,$0,$12,$3,$60,$a0,$50
		dc.b	$8f,$61,$0,$ff,$76,$60,$8c,$50,$8f,$70,$35,$60,$0,$31,$14,$1
		dc.b	$0,$1,$2,$61,$0,$fe,$3a,$48,$80,$1c,$3b,$0,$f4,$61,$0,$13
		dc.b	$e,$4a,$82,$67,$a,$28,$2,$16,$6,$72,$0,$60,$0,$fe,$82,$4e
		dc.b	$75,$50,$ee,$1,$15,$72,$d,$4e,$75,$41,$ee,$3,$96,$4a,$90,$67
		dc.b	$c,$10,$28,$0,$6,$b0,$2e,$1,$16,$67,$8
		dc.b	"Nup(`"
		dc.b	$0,$30,$cc,$70,$7,$60,$0,$30,$c6,$61,$de,$4a,$2e,$1,$d0,$66
		dc.b	$36,$2f,$8,$61,$0,$f2,$5a,$20,$5f,$4a,$4,$66,$0,$0,$82,$48
		dc.b	$e7,$30,$0,$61,$0,$e8,$9c,$4c,$df,$0,$30,$67,$0,$30,$56,$16
		dc.b	$5,$48,$7a,$0,$5e,$45,$ee,$1,$5e,$55,$5,$67,$0,$e9,$a0,$45
		dc.b	$ee,$1,$56,$60,$0,$e9,$98,$61,$0,$e8,$78,$66,$0,$30,$4e,$8
		dc.b	$29,$0,$6,$0,$c,$66,$0,$30,$2c,$2f,$9,$61,$0,$f2,$12,$22
		dc.b	$5f,$b6,$3c,$0,$1,$66,$14,$4a,$2e,$0,$ff,$66,$e,$70,$0,$10
		dc.b	$2e,$1,$3c,$41,$ee,$1,$6e,$94,$b0,$0,$0,$b4,$a9,$0,$8,$66
		dc.b	$0,$30,$a,$b6,$29,$0,$d,$66,$0,$2f,$fa,$8,$e9,$0,$6,$0
		dc.b	$c,$12,$2c,$ff,$ff,$1d,$7c,$0
		dc.b	"=Gm-BGnNu"

L1f86:
		move.l	a4,-(a7)
		clr.w	470(a6)
		bsr.s	L1f9a
		movea.l	(a7)+,a4
		addq.w	#1,470(a6)
		sf	260(a6)
		rts

L1f9a:
		move.l	a7,460(a6)
		movea.l	330(a6),a4
	l1fa2:	move.b	(a4)+,d1
	l1fa4:	tst.b	d1
		beq.s	l200e
		cmp.b	#$d,d1
		beq.s	l200e
		cmp.b	#$9,d1
		beq.s	l1fa2
		cmp.b	#$20,d1
		beq.s	l1fa2
		cmp.b	#$2c,d1
		beq.s	l1fa2
		st	d2
		lea	918(a6),a0
		clr.b	4(a0)
		bsr.w	L4444
		bne.s	l2008
		cmp.b	#$3d,d1
		bne.s	l2008
		move.b	(a4)+,d1
		bsr.w	L954
		tst.b	d4
		bne.s	l2008
		cmp.b	#$2,d3
		bne.s	l2008
		lea	918(a6),a0
		movem.l	d1-2,-(a7)
		bsr.w	L7a6
		movem.l	(a7)+,d1/d4
		beq.s	l2008
		lea	350(a6),a2
		moveq	#2,d3
		move.w	d1,-(a7)
		bsr.w	L8c2
		move.w	(a7)+,d1
		bra.s	l1fa4
	l2008:	moveq	#79,d0
		bra.w	L4fb6
	l200e:	rts
		dc.b	$70,$2d,$60,$0,$2f,$a2,$61,$0,$fe,$b6,$61,$0,$f2,$0,$66,$f0
		dc.b	$48,$42,$34,$0,$48,$42,$2,$82,$0,$ff,$0,$ff,$24,$6e,$1,$5e
		dc.b	$41,$ee,$3,$96,$48,$e7,$20,$1c,$4a,$2e,$1,$d0,$66,$16,$61,$0
		dc.b	$e7,$9a,$4c,$df,$38,$10,$67,$0,$2f,$20,$76,$4,$61,$0,$e8,$78
		dc.b	$72,$d,$4e,$75,$61,$0,$e7,$84,$4c,$df,$38,$10,$66,$0,$2f,$e
		dc.b	$c,$29,$0,$4,$0,$d,$66,$0,$2f,$0,$b8,$a9,$0,$8,$66,$0
		dc.b	$2e,$f8,$8,$e9,$0,$6,$0,$c,$66,$0,$2e,$ee,$72,$d,$4e,$75
		dc.b	$4a,$2e,$1,$d1,$66,$0,$2e,$f6,$32,$3c,$0,$d,$4e,$75,$61,$0
		dc.b	$fa,$58,$61,$0,$f1,$88,$66,$44,$b2,$3c,$0,$2c,$66,$0,$2e,$f6
		dc.b	$12,$1c,$48,$a7,$a0,$0,$61,$0,$f1,$74,$4c,$9f,$0,$18,$66,$2c
		dc.b	$b6,$0,$67,$18,$0,$6,$0,$88,$4a,$3,$67,$2,$c9,$42,$8c,$2
		dc.b	$2,$44,$0,$7,$ee,$5c,$8c,$44,$3a,$c6,$4e,$75,$0,$6,$0,$40
		dc.b	$4a,$0,$67,$ea,$0,$6,$0,$8,$c9,$42,$60,$e2,$54,$8d,$70,$2d
		dc.b	$60,$0,$2e,$d4,$61,$0,$f8,$18,$c,$2e,$0,$3,$1,$d1,$66,$4
		dc.b	$0,$6,$0,$40,$61,$0,$f1,$a,$8c,$2,$3a,$c6,$4e,$75,$72,$d
		dc.b	$70,$36,$60,$0,$2e,$b2,$41,$ee,$5d,$a,$b2,$3c,$0,$d,$67,$3c
		dc.b	$b2,$3c,$0,$9,$67,$36,$b2,$3c,$0,$20,$67,$30,$4,$1,$0,$30
		dc.b	$65,$2c,$b2,$3c,$0,$8,$64,$26,$70,$7,$90,$1,$12,$1c,$b2,$3c
		dc.b	$0,$2b,$67,$a,$b2,$3c,$0,$2d,$66,$14,$1,$90,$60,$2,$1,$d0
		dc.b	$12,$1c,$b2,$3c,$0,$2c,$66,$4,$12,$1c,$60,$be
		dc.b	"NupJ`"
		dc.b	$0,$2e,$64,$61,$0,$10,$6c,$4a,$82,$67,$0,$e6,$fe,$b2,$3c,$0
		dc.b	$9,$67,$6,$b2,$3c,$0,$20,$66,$4,$12,$1c,$60,$f0,$61,$0,$e5
		dc.b	$5a,$41,$fa,$0,$8,$2d,$48,$1,$96,$72,$d,$4e,$75,$4a,$2e,$1
		dc.b	$1b,$66,$0,$2e,$8,$41,$ee,$3,$96,$76,$0,$61,$0,$24,$16,$41
		dc.b	$ee,$3,$9c,$61,$0,$56,$9c,$66,$4e,$2d,$43,$1,$a6,$2d,$42,$1
		dc.b	$ae,$67,$34,$4a,$2e,$1,$d0,$67,$2e,$4a,$2e,$1,$5,$67,$28,$22
		dc.b	$2,$61,$0,$35,$be,$2f,$8,$22,$2e,$1,$ae,$26,$2e,$1,$a6,$61
		dc.b	$0,$56,$90,$22,$2e,$1,$ae,$20,$57,$24,$2e,$1,$dc,$61,$0
		dc.b	";z _a"
		dc.b	$0,$35,$a8,$26,$2e,$1,$a6,$42,$ae,$1,$a6,$61,$0,$56,$64,$72
		dc.b	$d,$4e,$75,$70,$1a,$60,$0,$2d,$ca,$47,$ee,$6,$f4,$24,$b,$4a
		dc.b	$1b,$66,$fc,$4a,$1b,$66,$f8,$26,$b,$96,$82,$53,$8b,$74,$0,$b2
		dc.b	$3c,$0,$22,$67,$6,$b2,$3c,$0,$27,$66,$4,$14,$1,$12,$1c,$b2
		dc.b	$3c,$0,$d,$67,$3e,$b2,$3c,$0,$20,$66,$6,$4a,$2,$66,$16,$60
		dc.b	$32,$b2,$3c,$0,$9,$67,$2c,$b2,$2,$67,$18,$b2,$3c,$0,$2c,$66
		dc.b	$4,$4a,$2,$67,$10,$52,$43,$b6,$7c,$1,$f4,$64,$1c,$16,$c1,$12
		dc.b	$1c,$60,$cc,$12,$1c,$52,$43,$b6,$7c,$1,$f4,$64,$c,$42,$1b,$12
		dc.b	$1c,$60,$aa,$42,$1b,$42,$1b,$4e,$75,$42,$6e,$6,$f4,$70,$4d,$60
		dc.b	$0,$2d,$50,$41,$ee,$3,$96,$76,$b,$61,$0,$23,$34,$61,$0,$2f
		dc.b	$ae,$66,$0,$2d,$28,$72,$d,$4e,$75,$61,$0,$ef,$6,$0,$64,$4a
		dc.b	$2e,$1,$d1,$66,$0,$2c,$f2,$4e,$75,$50,$ee,$1,$d3,$61,$0,$ee
		dc.b	$f2,$0,$64,$51,$ee,$1,$d3,$b2,$3c,$0,$2c,$66,$0,$2c,$f2,$12
		dc.b	$1c,$61,$0,$ef,$74,$66,$0,$ef,$66,$4a,$0,$67,$0,$ef,$60,$20
		dc.b	$6e,$1,$f8,$d4,$2,$85,$10,$61,$0,$f8
		dc.b	"*NuJ."
		dc.b	$1,$d1,$66,$0,$2c,$b4,$61,$0,$ef,$3e,$8c,$2,$3a,$c6,$b2,$3c
		dc.b	$0,$2c,$66,$0,$2c,$bc,$12,$1c,$b2,$3c,$0,$23,$66,$0,$2c,$ba
		dc.b	$12,$1c,$61,$0,$e6,$6c,$61,$0,$f2,$6c,$8,$2,$0,$0,$66,$6
		dc.b	$4a,$42,$6e,$2,$4e,$75,$70,$3,$60,$0,$2d,$6c,$12,$1c,$61,$0
		dc.b	$ee,$68,$61,$0,$23,$10,$4a,$2e,$1,$d0,$67,$10
		dc.b	"J.Z;g"
		dc.b	$a,$3f,$1,$12,$2,$61,$0,$35,$3e,$32,$1f,$b2,$3c,$0,$2c,$67
		dc.b	$da,$50,$ee,$1,$13,$4e,$75,$61,$0,$e,$94,$b4,$bc,$0,$0,$0
		dc.b	$26,$65,$0,$8,$d4,$b4,$bc,$0,$0,$0,$ff,$64,$0,$8,$ca
		dc.b	"=B\HP"
		dc.b	$ee,$1,$13,$4e,$75,$b2,$3c,$0,$23,$66,$0,$2c,$48,$12,$1c,$61
		dc.b	$0,$d,$82,$3a,$c6,$61,$0,$f1,$c4,$b2,$3c,$0,$2c,$66,$0,$2c
		dc.b	$2c,$12,$1c,$61,$0,$ee,$12,$3
		dc.b	"=Nu n"
		dc.b	$1,$f8,$52,$88,$53,$5,$67,$8,$10,$bc,$0,$7c,$70,$2,$60,$10
		dc.b	$10,$fc,$0,$3c,$c,$2e,$0,$3,$1,$d1,$67,$0,$2b,$ea,$4e,$75
		dc.b	$b0,$2e,$1,$d1,$67,$8,$4a,$2e,$1,$d1,$66,$0,$2b,$da,$4e,$75
		dc.b	$12,$1c,$30,$6,$3c,$3c,$2,$0,$b0,$7c,$c0,$0,$67,$a4,$7c,$0
		dc.b	$b0,$7c,$80,$0,$67,$9c,$3c,$3c,$a,$0,$60,$96,$b2,$3c,$0,$23
		dc.b	$67,$de,$61,$0,$d,$12,$3a,$c6,$61,$0,$ef,$3e,$b2,$3c,$0,$2c
		dc.b	$66,$0,$2b,$bc,$12,$1c,$10,$5,$2,$0,$0,$78,$66,$0,$0,$42
		dc.b	$da,$5,$52,$5,$8b,$2d,$ff,$fe,$61,$0,$ef,$2a,$20,$6e,$1,$f8
		dc.b	$30,$3c,$0,$3c,$14,$5,$2,$2,$0,$78,$66,$1e,$30,$3c,$0,$fd
		dc.b	$8,$6,$0,$d,$66,$14,$10,$10,$e2,$8,$2,$40,$0,$7,$81,$50
		dc.b	$da,$5,$2,$50,$f0,$ff,$8b,$10,$4e,$75,$8b,$50,$60,$0,$ed,$86
		dc.b	$8,$6,$0,$d,$66,$0,$ed,$b6,$30,$3c,$0,$fd,$61,$0,$ed,$70
		dc.b	$61,$0,$ed,$c8,$20,$6e,$1,$f8,$d4,$2,$85,$10,$4e,$75,$61,$0
		dc.b	$c,$96,$b2,$3c,$0,$23,$66,$0,$2b,$4e,$12,$1c,$61,$0,$ed,$18
		dc.b	$61,$16,$ee,$5a,$8c,$42,$b2,$3c,$0,$2c,$66,$0,$2b,$32,$12,$1c
		dc.b	$61,$0,$ed,$1e,$0
		dc.b	"?NuJ."
		dc.b	$1,$d0,$67,$10,$4a,$82,$67,$e,$b4,$bc,$0,$0,$0,$8,$62,$6
		dc.b	$66,$2,$74,$0,$4e,$75,$70,$1c,$60,$0,$2b,$2c,$61,$0,$b,$60
		dc.b	$34,$2e,$1,$c4,$4a,$42,$66,$12,$61,$0,$22,$cc,$20,$4c,$12,$2c
		dc.b	$ff,$ff,$61,$0,$21,$d0,$72,$d,$4e,$75,$70,$6,$60,$0,$2b,$bc
		dc.b	$12,$1c,$61,$0,$e4,$a0,$4a,$4,$66,$0,$0,$56,$b6,$3c,$0,$2
		dc.b	$66,$4e,$b2,$3c,$0,$2c,$66,$48,$28,$2,$2f,$c,$12,$1c,$61,$0
		dc.b	$ed,$4c,$66,$36,$4a,$0,$66,$32,$20,$4,$48,$80,$48,$c0,$b8,$80
		dc.b	$66,$28,$8,$2e,$0,$3,$1,$f,$67,$0,$0,$20,$55,$8d,$61,$0
		dc.b	$2f,$bc,$66,$14,$58,$8f,$0,$2,$0,$38,$d4,$2,$e1,$4a,$84,$4
		dc.b	$3a,$c2,$70,$b,$60,$0,$2c,$e6,$54,$8d
		dc.b	"(_r,$"
		dc.b	$4,$61,$0,$f0,$16,$60,$30,$30,$0,$10,$0,$30,$0,$20,$0,$70
		dc.b	$0,$10,$2e,$1,$d1,$d0,$0,$8c,$7b,$0,$ee,$3a,$c6,$b0,$3c,$0
		dc.b	$6,$66,$10,$b2,$3c,$0,$23,$66,$a,$8,$2e,$0,$3,$1,$f,$66
		dc.b	$0,$ff,$70,$61,$0,$ed,$ca,$b2,$3c,$0,$2c,$66,$0,$2a,$48,$12
		dc.b	$1c,$8,$5,$0,$6,$66,$0,$0,$94,$20,$6e,$1,$f8,$8b,$50,$61
		dc.b	$0,$ed,$ba,$20,$6e,$1,$f8,$8,$5,$0,$6,$66,$26,$34,$5,$30
		dc.b	$5,$2,$0,$0,$7,$d0,$0,$81,$10,$2,$45,$0,$38,$da,$45,$da
		dc.b	$45,$da,$45,$8b,$50,$2,$42,$0,$3f,$b4,$7c,$0,$3a,$64,$0,$ec
		dc.b	$54,$4e,$75,$38,$10,$e2,$d,$65,$20,$e2,$d,$65,$44,$10,$4,$2
		dc.b	$0,$0,$38,$b0,$3c,$0,$8,$66,$0,$ec,$3a,$2,$44,$0,$7,$0
		dc.b	$44,$4e,$60,$30,$84,$60,$0,$f5,$32,$3c,$3c,$44,$c0,$c,$2e,$0
		dc.b	$3,$1,$d1,$66,$4,$61,$0,$29,$b6,$2,$44,$0,$3f,$10,$4,$2
		dc.b	$0,$0,$38,$b0,$3c,$0,$8,$67,$0,$ec,$a,$8c,$44,$30,$86,$4e
		dc.b	$75,$61,$0,$f5,$74,$3c,$3c,$46,$c0,$60,$de,$24,$6e,$1,$f8,$e2
		dc.b	$d,$65,$22,$e2,$d,$65,$10,$61,$0,$ec,$12,$3c,$3c,$4e,$68,$8c
		dc.b	$2,$34,$86,$60,$0,$f4,$e4,$34,$bc,$40,$c0,$61,$0,$eb,$74,$0
		dc.b	$3d,$60,$0,$f5,$44,$61,$f0,$70,$4,$60,$0,$2a,$50,$10,$2e,$1
		dc.b	$d1,$67,$12,$b0,$3c,$0,$2,$67,$c,$b0,$3c,$0,$3,$66,$0,$29
		dc.b	$4e,$0,$6,$0,$40,$61,$72,$66,$0,$0,$4a,$b2,$3c,$0,$2c,$66
		dc.b	$0,$29,$54,$12,$1c,$3a,$c6,$3a,$c4,$61,$0,$ec,$d0,$ba,$7c,$0
		dc.b	$40,$64,$0,$eb,$90,$14,$5,$2,$2,$0,$38,$b4,$3c,$0,$20,$66
		dc.b	$1c,$4a,$2e,$1,$d0,$67,$16,$20,$6e,$1,$f8,$20,$10,$74,$0,$76
		dc.b	$f,$e3,$48,$e2,$52,$51,$cb,$ff,$fa,$31,$42,$0,$2,$70,$34,$60
		dc.b	$0,$eb,$24,$0,$46,$4,$0,$3a,$c6,$54,$8d,$61,$0,$ea,$f4,$0
		dc.b	$6c,$b2,$3c,$0,$2c,$66,$0,$28,$fe,$12,$1c,$61,$c,$66,$78,$20
		dc.b	$6e,$1,$f8,$31,$44,$0,$2,$4e,$75,$78,$0,$61,$0,$eb,$70,$67
		dc.b	$48,$41,$ee,$4,$1c,$48,$e7,$40,$8,$61,$0,$1d,$8a,$66,$34,$24
		dc.b	$6e,$1,$5e,$48,$e7,$50,$1c,$61,$0,$e1,$12,$4c,$df,$38,$a,$66
		dc.b	$22,$c,$29,$0,$5,$0,$d,$66,$1a,$28,$29,$0,$8,$4a,$2e,$1
		dc.b	$d0,$67,$8,$8,$29,$0,$6,$0,$c,$67,$6,$50,$8f,$70,$0,$4e
		dc.b	$75,$70,$ff,$4c,$df,$10,$2,$4e,$75,$e7,$8,$d0,$2,$b2,$3c,$0
		dc.b	$2d,$67,$1a,$1,$c4,$b2,$3c,$0,$2f,$67,$4,$70,$0,$4e,$75,$12
		dc.b	$1c,$61,$0,$eb,$a,$67,$e2,$70,$37,$60,$0,$28,$98,$12,$1c,$b2
		dc.b	$3c,$0,$38,$64,$16,$b2,$3c,$0,$30,$65,$10,$16,$0,$2,$0,$0
		dc.b	$8,$4,$1,$0,$30,$d0,$1,$12,$1c,$60,$e,$3f,$0,$61,$0,$ea
		dc.b	$de,$66,$d4,$e7,$8,$d0,$2,$36,$1f,$b0,$3,$65,$ca,$52,$0,$7
		dc.b	$c4,$52,$3,$b6,$0,$66,$f8,$60,$ac,$61,$0,$ea,$2c,$0,$ff,$b2
		dc.b	$3c,$0,$2c,$66,$0,$28,$30,$12,$1c,$61,$0,$ea,$a0,$d4,$2,$20
		dc.b	$6e,$1,$f8,$85,$10,$10,$2e,$1,$d1,$67,$e,$b0,$3c,$0,$3,$67
		dc.b	$c,$b0,$3c,$0,$2,$66,$0,$27,$f6,$0,$10,$0,$10,$4e,$75,$10
		dc.b	$2e,$1,$d1,$b0,$3c,$0,$1,$67,$0,$27,$e4,$b0,$3c,$0,$3,$66
		dc.b	$4,$0,$6,$0,$40,$61,$0,$ea,$76,$66,$4a,$4a,$0,$66,$0,$0
		dc.b	$86,$0,$6,$0,$80,$2,$42,$0,$7,$ee,$5a,$8c,$42,$b2,$3c,$0
		dc.b	$2c,$66,$0,$27,$d2,$12,$1c,$74,$0,$b2,$3c,$0,$28,$67,$e,$61
		dc.b	$0,$e9,$84,$61,$0,$1e,$6e,$b2,$3c,$0,$28,$66,$58,$12,$1c,$36
		dc.b	$2,$61,$0,$ea,$28,$8c,$2,$b2,$3c,$0,$29,$66,$48,$12,$1c,$3a
		dc.b	$c6,$3a,$c3,$4e,$75,$74,$0,$b2,$3c,$0,$28,$67,$e,$61,$0,$e9
		dc.b	$56,$61,$0,$1e,$40,$b2,$3c,$0,$28,$66,$2a,$12,$1c,$36,$2,$61
		dc.b	$0,$e9,$fa,$8c,$2,$b2,$3c,$0,$29,$66,$1a,$12,$1c,$b2,$3c,$0
		dc.b	$2c,$66,$0,$27,$72,$12,$1c,$61,$0,$e9,$d8,$2,$42,$0,$7,$ee
		dc.b	$5a,$8c,$42,$60,$ba,$70,$2e,$60,$0,$27,$7e,$b2,$3c,$0,$23,$66
		dc.b	$0,$27,$5c,$12,$1c,$61,$0,$e1,$e,$4a,$2e,$1,$d0,$67,$34,$61
		dc.b	$0,$1e,$14,$4a,$2e,$0,$ff,$67,$4,$4a,$43,$6b,$42,$10,$2,$48
		dc.b	$80,$48,$c0,$b4,$80,$67,$1c,$b4,$bc,$0,$0,$1,$0,$65,$6,$61
		dc.b	$0,$27,$18,$60,$e,$c,$2e,$0,$3,$1,$d1,$67,$6,$70,$1,$61
		dc.b	$0,$27,$ea,$1c,$2,$b2,$3c,$0,$2c,$66,$0,$27,$a,$12,$1c,$61
		dc.b	$0,$e9,$70,$d4,$2,$70,$70,$80,$2,$1a,$c0,$1a,$c6,$4e,$75,$2f
		dc.b	$2,$b2,$3c,$0,$2c,$66,$0,$26,$ee,$12,$1c,$61,$0,$e9,$54,$d4
		dc.b	$2,$70,$70,$80,$2,$1a,$c0,$24,$1f,$60,$0,$36,$14,$61,$0,$f2
		dc.b	$30,$61,$0,$e8,$c4,$0,$3d,$4e,$75,$b2,$3c,$0,$9,$67,$6,$b2
		dc.b	$3c,$0,$20,$66,$4,$12,$1c,$60,$f0,$74,$0,$b2,$3c,$0,$d,$67
		dc.b	$10,$b2,$3c,$0,$2a,$67,$a,$b2,$3c,$0,$3b,$67,$4,$61,$0,$8
		dc.b	$d4,$2f,$2,$61,$0,$1e,$64,$24,$1f,$43,$ee,$2,$0,$2d,$49,$1
		dc.b	$38,$23,$42,$0,$8,$42,$29,$0,$e,$2d,$42,$1,$dc,$41,$ee,$5
		dc.b	$30,$2d,$48,$1,$f8,$1d,$7c,$0,$2,$1,$a,$50,$ee,$1,$1b,$12
		dc.b	$2c,$ff,$ff,$4e,$75,$61,$0,$8,$9c,$2f,$2,$61,$0,$35,$f0,$4c
		dc.b	$df,$0,$4,$66,$30,$2d,$42,$1,$dc,$41,$fa,$34,$cc,$2d,$48,$1
		dc.b	$96,$12,$2c,$ff,$ff,$50,$ee,$1,$12,$51,$ee,$1,$1c,$1d,$7c,$0
		dc.b	$d,$1,$a,$10,$2e,$1,$d1,$67,$a,$b0,$3c,$0,$3,$67,$4,$50
		dc.b	$ee,$1,$1c
		dc.b	"NupC`"
		dc.b	$0,$26,$4e,$12,$1c,$b2,$3c,$0,$d,$67,$b0,$b2,$3c,$0,$9,$67
		dc.b	$0,$ff,$aa,$b2,$3c,$0,$20,$67,$0,$ff,$a2,$48,$81,$12,$36,$10
		dc.b	$7e,$4,$1,$0,$41,$65,$1e,$b2,$3c,$0,$1a,$64,$18,$48,$81,$d2
		dc.b	$41,$30,$3b,$10,$18,$67,$e,$12,$1c,$4e,$bb,$0,$10,$b2,$3c,$0
		dc.b	$2c,$67,$c0
		dc.b	"Nup8`"
		dc.b	$0,$26,$2,$0,$8c,$0,$0,$0,$b2,$0,$4e,$0,$9c,$0,$0,$0
		ds.b	4
		dc.b	$94,$0,$0,$0,$0,$0,$e4,$0,$64,$0,$0,$1,$4e,$0,$6c,$0
		ds.b	4
		dc.b	$74,$0,$5c,$0,$a4,$0,$0,$0,$7c,$0,$84,$0,$0,$0,$0,$70
		dc.b	$3e,$60,$0,$25,$cc,$10,$1c,$c1,$41,$b0,$3c,$0,$2b,$67,$8,$b0
		dc.b	$3c,$0,$2d,$66,$b0,$4a,$0,$4e,$75,$61,$ea,$57,$c0,$2,$0,$0
		dc.b	$1,$1d,$40,$1,$6,$4e,$75,$61,$dc,$56,$ee,$1,$9,$4e,$75,$61
		dc.b	$d4,$57,$ee,$1,$17,$4e,$75,$61,$cc,$57,$ee,$1,$8,$4e,$75,$61
		dc.b	$c4,$57,$ee,$1,$0,$4e,$75,$61,$bc,$57,$ee,$1,$7,$4e,$75,$61
		dc.b	$b4,$57,$ee,$1,$6,$4e,$75,$61,$ac,$57,$ee,$1,$19,$4e,$75,$61
		dc.b	$a4,$57,$ee,$1,$1d,$4e,$75,$61,$9c,$57,$ee,$1,$1e
		dc.b	"Nut_a"
		dc.b	$92,$67,$2,$74,$2e,$1d,$42,$1,$16,$4e,$75,$61,$0,$0,$f0,$66
		dc.b	$16,$b4,$7c,$0,$8,$65,$0,$ff,$3c,$b4,$7c,$0,$80,$64,$0,$ff
		dc.b	"4RB=B"
		dc.b	$1,$c6,$b2,$3c,$0,$2b,$67,$8,$b2,$3c,$0,$2d,$66,$8,$4a,$1
		dc.b	$56,$ee,$0,$fe,$12,$1c,$4e,$75,$4a,$ae,$1,$d8,$66,$0,$ff,$4a
		dc.b	$10,$1,$12,$1c,$4a,$2e,$1,$d0,$66,$56,$b0,$3c,$0,$2b,$67,$34
		dc.b	$b0,$3c,$0,$2d,$67,$28,$4,$0,$0,$30,$65,$0,$fe,$f2,$48,$80
		dc.b	$67,$1c,$53,$40,$b0,$7c,$0,$7,$64,$0,$fe,$e4,$1,$3c,$0,$3
		dc.b	$67,$0,$fe,$dc,$50,$ee,$0,$ff,$3d,$40,$1,$c4,$60,$e,$51,$ee
		dc.b	$0,$ff,$60,$8,$50,$ee,$0,$ff,$42,$6e,$1,$c4,$22,$6e,$1,$38
		dc.b	$20,$6e,$1,$34,$42,$ae,$1,$b6,$61,$0,$1c,$3a,$12,$2c,$ff,$ff
		dc.b	$4e,$75,$43,$ee,$1,$e,$48,$81,$12,$36,$10,$7e,$b2,$3c,$0,$57
		dc.b	$66,$6,$43,$ee,$1,$10,$12,$1c,$b2,$3c,$0,$2d,$67,$2e,$b2,$3c
		dc.b	$0,$2b,$67,$2c,$61,$0,$0,$32,$53,$42,$6b,$0,$fe,$82,$b4,$7c
		dc.b	$0,$6,$62,$0,$fe,$7a,$61,$0,$fe,$b6,$67,$8,$30,$11,$5,$80
		dc.b	$32,$80,$4e,$75,$30,$11,$5,$c0,$32,$80
		dc.b	"NuBQ`"
		dc.b	$4,$32,$bc,$ff,$ff,$12,$1c,$4e,$75,$b2,$3c,$0,$30,$65,$2e,$b2
		dc.b	$3c,$0,$39,$62,$28,$74,$0,$4,$1,$0,$30,$14,$1,$12,$1c,$b2
		dc.b	$3c,$0,$30,$65,$16,$b2,$3c,$0,$3a,$64,$10,$c4,$fc,$0,$a,$4
		dc.b	$1,$0,$30,$2,$41,$0,$f,$d4,$41,$60,$e2,$70,$0,$4e,$75,$41
		dc.b	$ee,$6,$50,$74,$0,$4a,$10,$67,$4,$72,$d,$4e,$75,$b2,$3c,$0
		dc.b	$d,$67,$1a,$b2,$3c,$0,$9,$67,$14,$b2,$3c,$0,$20,$67,$e,$10
		dc.b	$c1,$12,$1c,$52,$2,$b4,$3c,$0,$52,$66,$e2,$72,$d,$42,$10,$4e
		dc.b	$75,$61,$0,$ef,$28,$50,$ee,$1,$d3,$61,$0,$e5,$be,$0
		dc.b	"dNuJ."
		dc.b	$1,$d0,$67,$a,$8,$ee,$0,$0,$5d,$a,$61,$0,$49,$3c,$72,$d
		dc.b	$50,$ee,$1,$13,$4e,$75,$8,$ae,$0,$0,$5d,$a,$4e,$75,$61,$0
		dc.b	$5,$d2,$b4,$bc,$0,$0,$0,$c,$65,$12,$b4,$bc,$0,$0,$0,$ff
		dc.b	$64,$a
		dc.b	"=B\JP"
		dc.b	$ee,$1,$13
		dc.b	"NupI`"
		dc.b	$0,$23,$a6,$61,$0,$f2,$ba,$61,$0,$fa,$90,$66,$0,$fa,$fa,$74
		dc.b	$0,$34,$4,$24,$6e,$1,$5e,$41,$ee,$3,$96,$48,$e7,$20,$1c,$4a
		dc.b	$2e,$1,$d0,$66,$18,$61,$0,$db,$a4,$4c,$df,$38,$10,$67,$0,$23
		dc.b	$2a,$76,$5,$61,$0,$dc,$82,$12,$2c,$ff,$ff,$4e,$75,$61,$0,$db
		dc.b	$8c,$4c,$df,$38,$10,$66,$0,$23,$16,$c,$29,$0,$5,$0,$d,$66
		dc.b	$0,$23,$8,$b8,$a9,$0,$8,$66,$0,$23,$0,$8,$e9,$0,$6,$0
		dc.b	$c,$66,$0,$22,$f6,$60,$d0,$1,$0,$1,$2,$41,$ee,$3,$96,$70
		dc.b	$0,$10,$2e,$1,$d1,$b0,$3c,$0,$1,$67,$10,$8,$2e,$0,$0,$47
		dc.b	$79,$67,$8,$24,$2e,$47,$72,$d5,$ae,$47,$76,$4a,$90,$66,$26,$61
		dc.b	$0,$e4,$cc,$70,$0,$10,$2e,$1,$d1,$10,$3b,$0,$cc,$e1,$aa
		dc.b	"J.Grj"
		dc.b	$2,$44,$82,$20,$2e,$47,$76,$d5,$ae,$47,$76,$24,$0,$60,$0,$f2
		dc.b	$b8,$4a,$2e,$1,$d0,$66,$2e,$2f,$8,$61,$0,$e4,$9e
		dc.b	" _fTJ"
		dc.b	$4,$66,$50,$2a,$2,$61,$0,$da,$ca,$67,$0,$22,$88,$45,$ee,$1
		dc.b	$5e,$76,$2
		dc.b	"(.Gva"
		dc.b	$0,$db,$d4,$24,$5,$12,$2c,$ff,$ff,$60,$aa,$61,$0,$da,$ac,$66
		dc.b	$0,$22,$82,$c,$29,$0,$2,$0,$d,$66,$0,$22,$78,$20,$29,$0
		dc.b	$8,$b0,$ae,$47,$76,$66,$0,$22,$5c,$8,$e9,$0,$6,$0,$c,$66
		dc.b	$0,$22,$4a,$61,$0,$e4,$4a,$60,$0,$ff,$7c,$4e,$75,$61,$0,$4
		dc.b	$7c,$4a,$82,$6b,$0,$fc,$32,$2f,$2,$61,$0,$32,$4,$4c,$df,$0
		dc.b	$4,$66,$0,$fc,$24,$42,$ae,$1,$9e,$94,$ae,$1,$dc,$2d,$42,$1
		dc.b	$ae,$12,$2c,$ff,$ff,$4e,$75,$94,$81,$65,$e,$67,$a,$28,$2,$76
		dc.b	$0,$72,$0,$61,$0,$ef,$e2,$70,$0,$4e,$75,$42,$ae,$47,$76,$72
		dc.b	$d,$4e,$75,$61,$0,$e3,$fa,$66,$f2,$4a,$4,$66,$ee
		dc.b	"-BGv`"
		dc.b	$0,$f1,$fa,$61,$0,$ed,$6a,$50,$ee,$1,$d3,$61,$0,$e3,$fa,$0
		dc.b	$3d,$4e,$75,$61,$14,$44,$41,$54,$41,$0,$0,$61,$c,$42,$53,$53
		dc.b	$0,$61,$6,$54,$45,$58,$54,$0,$0,$20,$5f,$43,$ee,$4,$1c,$61
		dc.b	$0,$2e,$a8,$12,$fc,$0,$d,$48,$e7,$40,$8,$49,$ee,$4,$1c,$12
		dc.b	$1c,$61,$6,$4c,$df,$10,$2,$4e,$75,$61,$0,$19,$8e,$12,$2c,$ff
		dc.b	$ff,$76,$1,$61,$0,$19,$16,$72,$d,$4e,$75,$61,$0,$f0,$f2,$4a
		dc.b	$2e,$1,$d0,$66,$4c,$2f,$8,$61,$0,$e3,$6c,$20,$5f,$4a,$4,$66
		dc.b	$70,$48,$e7,$30,$0,$61,$0,$d9,$b0,$4c,$df,$0,$30,$66,$10,$8
		dc.b	$29,$0,$7,$0,$c,$67,$0,$21,$62,$16,$5,$24,$4,$60,$42,$48
		dc.b	$7a,$0,$16,$16,$5,$45,$ee,$1,$5e,$55,$5,$67,$0,$da,$a6,$45
		dc.b	$ee,$1,$56,$60,$0,$da,$9e,$8,$e9,$0,$7,$0,$c,$60,$0,$f1
		dc.b	$48,$61,$0,$d9,$74,$66,$0,$21,$4a,$8,$29,$0,$7,$0,$c,$67
		dc.b	$0,$21,$40,$2f,$9,$61,$0,$e3,$e,$22,$5f,$8,$e9,$0,$6,$0
		dc.b	$c,$23,$42,$0,$8,$b6,$29,$0,$d,$66,$0,$21,$e,$60,$0,$f1
		dc.b	$1c,$70,$3,$60,$0,$21,$52,$b2,$3c,$0,$23,$67,$5c,$54,$8d,$61
		dc.b	$0,$e4,$9e,$10,$5,$2,$0,$0,$78,$67,$2c,$34,$6,$2,$42,$0
		dc.b	$18,$ed,$4a,$2,$46,$ff,$0,$0,$46,$0,$c0,$8c,$42,$20,$6e,$1
		dc.b	$f8,$30,$86,$61,$0,$ec,$c2,$70,$3c,$60,$0,$e3,$a,$0,$46,$2
		dc.b	$0,$8c,$5,$3a,$c6,$4e,$75,$2a,$6e,$1,$f8,$61,$0,$2,$30,$b2
		dc.b	$3c,$0,$2c,$66,$e8,$0,$6,$0,$20,$3a,$86,$da,$5,$8b,$1d,$12
		dc.b	$1c,$61,$0,$e3,$3e,$85,$1d,$4e,$75,$12,$1c,$61,$0,$e2,$a0,$61
		dc.b	$0,$f5,$9e,$ee,$5a,$8c,$42,$61,$0,$2,$4,$b2,$3c,$0,$2c,$66
		dc.b	$0,$20,$b4,$12,$1c,$61,$0,$e3,$1a,$8c,$2,$3a,$c6,$4e,$75,$61
		dc.b	$0,$e2,$7c,$b4,$bc,$0,$0,$0,$ff,$64,$0,$fd,$12,$4a,$2e,$1
		dc.b	$d0,$67,$10
		dc.b	"J.Z;g"
		dc.b	$a,$38,$2,$61,$0
		dc.b	"&^SDf"
		dc.b	$f8,$12,$2c,$ff,$ff,$50,$ee,$1,$13,$4e,$75,$3a,$c6,$b2,$3c,$0
		dc.b	$23,$66,$0,$20,$78,$12,$1c,$61,$0,$da,$2a,$61,$0,$e6,$2a,$4a
		dc.b	$2e,$1,$d1,$66,$0
		dc.b	" FNua"
		dc.b	$0,$ec,$1a,$61,$0,$e2,$c0,$8c,$2,$3a,$c6,$4e,$75,$61,$0,$eb
		dc.b	$a4,$61,$0,$e2,$38,$0
		dc.b	"=NuJ."
		dc.b	$1,$d1,$66,$0,$20,$22,$b2,$3c,$0,$23,$66,$0,$20,$3a,$12,$1c
		dc.b	$61,$0,$e1,$ec,$61,$0,$16,$f8,$8c,$2,$3a,$c6,$b4,$bc,$0,$0
		dc.b	$0,$10,$64,$2,$4e,$75,$70,$1c,$60,$0,$20,$36,$61,$0,$1,$58
		dc.b	$61,$0,$e1,$fe,$0,$3d,$4e,$75,$45,$ee,$5c,$68,$74,$0,$50,$ee
		dc.b	$1,$13,$76,$d,$4a,$2e,$1,$d0,$66,$8,$4a,$12,$67,$4,$72,$d
		dc.b	$4e,$75,$b2,$3c,$0,$27,$66,$4,$76,$27,$12,$1c,$b6,$1,$67,$14
		dc.b	$b2,$3c,$0,$d,$67,$16,$14,$c1,$52,$2,$b4,$3c,$0,$50,$66,$ea
		dc.b	$72,$d,$60,$8,$b6,$3c,$0,$d,$67,$2,$12,$1c,$42,$12,$4e,$75
		dc.b	$45,$ee,$5c,$b9,$60,$b6,$61,$0,$e2,$2c,$8c,$2,$3a,$c6,$4a,$2e
		dc.b	$1,$d1,$66,$0,$1f,$92,$4e,$75,$4a,$2e,$0,$ff,$66,$4,$58,$8f
		dc.b	$72,$d,$4e,$75,$12,$1c,$61,$f0,$41,$ee,$3,$96,$61,$0,$14,$40
		dc.b	$66,$0,$1f,$ae,$3f,$1,$61,$a,$32,$1f,$b2,$3c,$0,$2c,$67,$e4
		dc.b	$4e,$75,$10,$28,$0,$6,$b0,$2e,$1,$16,$67,$0,$1f,$52,$4a,$2e
		dc.b	$1,$d0,$67,$1a,$61,$0,$d7,$7a,$66,$16,$10,$29,$0,$c,$2,$0
		dc.b	$0,$90,$66,$c,$8,$e9,$0,$5,$0,$c,$67,$0,$2c,$82
		dc.b	"Nup+`"
		dc.b	$0,$1f,$6c,$70,$2a,$60,$0,$1f,$62,$12,$1c,$61,$98,$41,$ee,$3
		dc.b	$96,$61,$0,$13,$e8,$66,$0,$1f,$56,$10,$28,$0,$6,$b0,$2e,$1
		dc.b	$16,$67,$e0,$76,$1,$c,$2e,$0,$3,$1,$d1,$66,$2,$76,$2,$3f
		dc.b	$1,$3f,$3,$61,$0,$d7,$28,$4c,$9f,$0,$8,$67,$a,$22,$6e,$1
		dc.b	$5a,$78,$0,$61,$0,$d8,$38,$61,$a,$32,$1f,$b2,$3c,$0,$2c,$67
		dc.b	$b8,$4e,$75,$b6,$29,$0,$d,$66,$32,$8,$29,$0,$5,$0,$c,$66
		dc.b	$2a,$8,$29,$0,$7,$0,$c,$66,$22,$10,$29,$0,$17,$b0,$2e,$1
		dc.b	$16,$67,$18,$8,$e9,$0,$4,$0,$c,$66,$e,$20,$6e,$1,$34,$52
		dc.b	$68,$0,$14,$33,$68,$0,$14,$0,$14,$4e,$75,$30,$3c,$0,$2a,$60
		dc.b	$0,$1e,$dc,$70,$0,$10,$2e,$1,$d1,$8c,$3b,$0,$4,$4e,$75,$40
		dc.b	$0,$40,$80,$70,$35,$60,$0,$1e,$c2,$14,$1,$b2,$3c,$0,$22,$67
		dc.b	$6,$b2,$3c,$0,$27,$66,$ec,$24,$4c,$12,$1c,$b2,$3c,$0,$d,$67
		dc.b	$e2,$b2,$2,$66,$f4,$12,$1c,$b2,$2,$67,$ee,$28,$c,$98,$8a,$53
		dc.b	$44,$b2,$3c,$0,$2c,$66,$0,$1e,$74,$12,$1c,$16,$1,$b2,$3c,$0
		dc.b	$27,$67,$6,$b2,$3c,$0,$22,$66,$ba,$53,$44,$65,$6,$b5,$c,$67
		dc.b	$f8,$4e,$75,$70,$d,$c1,$41,$b0,$3,$66,$6,$52,$8c,$12,$1c,$70
		dc.b	$0,$4e,$75,$61,$a4,$57,$c0,$60,$0,$0,$ce,$61,$9c,$56,$c0,$60
		dc.b	$0,$0,$c6,$61,$0,$de,$e,$67,$1e,$61,$0,$d6,$42,$66,$18,$4a
		dc.b	$2e,$1,$d0,$67,$12,$10,$29,$0,$c,$8,$0,$0,$7,$67,$8,$2
		dc.b	$0,$0,$40,$b0,$3c,$0,$40,$4e,$75,$41,$ee,$3,$96,$61,$0,$12
		dc.b	$bc,$66,$0,$1e,$2a,$61,$cc,$57,$c0,$60,$0,$0,$8c,$41,$ee,$3
		dc.b	$96,$61,$0,$12,$a8,$66,$0,$1e,$16,$61,$b8,$56,$c0,$60,$78,$61
		dc.b	$0,$d7,$aa,$4a,$2e,$0,$ff,$67,$4,$4a,$43,$6b,$26,$b6,$3c,$0
		dc.b	$2,$67,$20,$4a,$4,$66,$1c,$4e,$75,$61,$0,$d7,$90,$4a,$2e,$0
		dc.b	$ff,$67,$4,$4a,$43,$6b,$c,$b6,$3c,$0,$1,$67,$6,$4a,$4,$66
		dc.b	$2
		dc.b	"Nup<`"
		dc.b	$0,$1d,$d2,$61,$de,$1d,$7c,$0
		dc.b	"=Gm-BGnNup1`"
		dc.b	$0,$1d,$be
	l31f6:	move.w	#$32,d0
		bra.w	L4fa0
		dc.b	$61,$e2,$5e,$c0,$60,$1c,$61,$dc,$5c,$c0,$60,$16,$61,$d6,$5d,$c0
		dc.b	$60,$10,$61,$d0,$5f,$c0,$60,$a,$61,$ca,$57,$c0,$60,$4,$61,$c4
		dc.b	$56,$c0
		dc.b	"RnGzJ"
		dc.b	$0,$67,$4,$72,$d,$4e,$75,$61,$0,$d3,$c0
		dc.b	">.Gza"
		dc.b	$0,$d2,$32,$66,$bc
		dc.b	"axgpJ"
		dc.b	$82,$67,$18,$b2,$bc
		dc.b	"ELSEfd"
		dc.b	$b4,$bc,$49,$46,$0,$0,$66,$5c,$be,$6e,$47,$7a,$67,$d0,$60,$54
		dc.b	$b2,$bc
		dc.b	"ELSEg"
		dc.b	$f0,$b2,$bc
		dc.b	"ENDCg"
		dc.b	$1c,$b2,$bc
		dc.b	"ENDMf""J."
		dc.b	$1,$3
		dc.b	"g6 nG~"
		dc.b	$be,$68,$0,$e,$63,$2c,$60,$0,$6
		dc.b	".0.GzSnGz"
		dc.b	$be,$40,$66,$1c,$60,$94,$48,$41,$b2,$7c,$49,$46,$66,$12,$48,$41
		dc.b	$41,$fa,$8,$36,$30,$18,$67,$8,$b2,$40,$66,$f8
		dc.b	"RnGza"
		dc.b	$0,$d3,$3e,$60,$80,$12,$1c,$b2,$3c,$0,$d,$67,$0,$0,$94,$b2
		dc.b	$3c,$0,$9,$67,$2e,$b2,$3c,$0,$20,$67,$28,$b2,$3c,$0,$2a,$67
		dc.b	$0,$0,$80,$b2,$3c,$0,$3b,$67,$78,$12,$1c,$b2,$3c,$0,$d,$67
		dc.b	$70,$b2,$3c,$0,$9,$67,$c,$b2,$3c,$0,$20,$67,$6,$b2,$3c,$0
		dc.b	$3a,$66,$e6,$12,$1c,$b2,$3c,$0,$d,$67,$56,$b2,$3c,$0,$9,$67
		dc.b	$f2,$b2,$3c,$0,$20,$67,$ec,$b2,$3c,$0,$2a,$67,$44,$b2,$3c,$0
		dc.b	$3b,$67,$3e,$41,$ee,$5,$30,$42,$a0,$42,$a0,$70,$7,$60,$1a,$12
		dc.b	$1c,$b2,$3c,$0,$d,$67,$22,$b2,$3c,$0,$9,$67,$1c,$b2,$3c,$0
		dc.b	$20,$67,$16,$b2,$3c,$0,$2e,$67,$10,$48,$81,$12,$36,$10,$7e,$10
		dc.b	$c1,$51,$c8,$ff,$dc,$70,$0,$4e,$75,$4c,$ee,$0,$6,$5,$28,$70
		dc.b	$ff
		dc.b	"NuJnGzg"
		dc.b	$8
		dc.b	"SnGzr"
		dc.b	$d
		dc.b	"Nup/`"
		dc.b	$0,$1c,$52,$60,$0,$fe,$c4,$22,$3c,$0,$0,$13,$88,$3d,$41,$1
		dc.b	$44,$61,$0,$24,$2a,$2d,$48,$1
		dc.b	"@Nup4`"
		dc.b	$0,$1c,$34,$4a,$2e,$1,$3,$66,$f4,$4a,$ae,$47,$8c,$66,$ee,$61
		dc.b	$0,$eb,$3c,$24,$6e,$1,$66,$48,$e7,$0,$c,$61,$0,$d4,$3c,$56
		dc.b	$c0,$4c,$df,$30,$0,$4a,$2e,$1,$d0,$66,$0,$0,$ee,$4a,$0,$67
		dc.b	$0,$1b,$b6,$76,$8,$42,$84,$61,$0,$d5,$c,$48,$69,$0,$8,$10
		dc.b	$2e,$1,$d1,$67,$c,$b0,$3c,$0,$1,$67,$6,$8,$e9,$0,$3,$0
		dc.b	$c,$20,$6e,$1,$40,$c,$6e,$1,$10,$1,$44,$64,$2,$61,$8a,$22
		dc.b	$5f,$22,$88,$42,$a8,$0,$8,$43,$e8,$0,$10,$20,$89,$21,$49,$0
		dc.b	$4,$21,$48,$0,$c,$2d,$49,$1,$40,$4,$6e,$0,$10,$1,$44,$26
		dc.b	$48,$61,$0,$d1,$ea,$61,$0,$d0,$7a,$66,$0,$fd,$ea,$61,$30,$61
		dc.b	$0,$fe,$a2,$67,$ec,$b2,$bc
		dc.b	"ENDMf"
		dc.b	$e4,$4a,$82,$66,$e0,$20,$6b,$0,$c,$21,$6e,$1,$40,$0,$4,$72
		dc.b	$d,$8,$2e,$0,$0,$1,$43,$67,$8,$53,$6e,$1,$44,$52,$ae,$1
		dc.b	$40,$4e,$75,$c,$6e,$1,$2,$1
		dc.b	"Dd4 k"
		dc.b	$0,$c,$21,$6e,$1,$40,$0,$4,$61,$0,$ff,$16,$22,$6b,$0,$c
		dc.b	$23,$48,$0,$8,$27,$48,$0,$c,$43,$e8,$0,$c,$20,$89,$42,$a8
		dc.b	$0,$4,$42,$a8,$0,$8,$70,$c,$d0,$c0,$d1,$ae,$1,$40,$91,$6e
		dc.b	$1,$44,$20,$6e,$1,$40,$22,$4c,$72,$d,$10,$19,$10,$c0,$b2,$0
		dc.b	$66,$f8,$2d,$48,$1,$40,$24,$9,$94,$8c,$95,$6e,$1,$44,$4e,$75
		dc.b	$4a,$0,$66,$0,$1a,$ce,$c,$29,$0,$8,$0,$d,$66,$0,$1a,$c0
		dc.b	$8,$e9,$0,$6,$0,$c,$66,$0,$1a,$b6,$61,$0,$d1,$38,$61,$0
		dc.b	$cf,$c8,$66,$0,$fd,$38,$61,$0,$fd,$f2,$67,$ee,$b2,$bc
		dc.b	"ENDMf"
		dc.b	$e6,$4a,$82,$66,$e2,$72,$d,$4e,$75

L34d6:
		move.l	#$1f40,d1
		move.w	d1,18306(a6)
		bsr.w	L57a0
		move.l	a0,18308(a6)
		rts
	l34ea:	moveq	#76,d0
		bra.w	L4fa0
	l34f0:	cmpi.w	#$244,18306(a6)
		bcs.s	l34ea
		movem.l	a1/d1,-(a7)
		btst	#$3,12(a1)
		beq.s	l350a
		bsr.w	L874
		bra.s	l350e
	l350a:	bsr.w	L85a
	l350e:	movem.l	(a7)+,d1/a1
		tst.b	464(a6)
		beq.s	l3522
		btst	#$6,12(a1)
		beq.w	l4f80
	l3522:	moveq	#87,d0
		cmp.b	#$d,d1
		beq.s	l3540
		cmp.b	#$9,d1
		beq.s	l3540
		cmp.b	#$20,d1
		beq.s	l3540
		cmp.b	#$2e,d1
		bne.w	l4f78
		moveq	#0,d0
	l3540:	movea.l	18308(a6),a0
		sf	12(a0)
		move.l	18302(a6),(a0)
		move.l	a0,18302(a6)
		move.w	18300(a6),10(a0)
		movea.l	8(a1),a1
		move.l	a1,4(a0)
		move.l	(a1),16(a0)
		move.w	18298(a6),14(a0)
		lea	8(a0),a1
		clr.w	(a1)
		lea	278(a0),a0
		move.b	d0,(a0)+
		bne.s	l3592
		subq.l	#1,a0
	l3578:	move.b	(a4)+,d1
		cmp.b	#$d,d1
		beq.s	l3592
		cmp.b	#$9,d1
		beq.s	l3590
		cmp.b	#$20,d1
		beq.s	l3590
		move.b	d1,(a0)+
		bra.s	l3578
	l3590:	move.b	(a4)+,d1
	l3592:	clr.b	(a0)+
	l3594:	cmp.b	#$d,d1
		beq.w	l361c
		cmp.b	#$2a,d1
		beq.s	l361c
		cmp.b	#$3b,d1
		beq.s	l361c
		cmp.b	#$9,d1
		beq.s	l35b4
		cmp.b	#$20,d1
		bne.s	L35b8
	l35b4:	move.b	(a4)+,d1
		bra.s	l3594

L35b8:
		addq.w	#1,(a1)
		cmp.b	#$2c,d1
		beq.s	l3606
		cmp.b	#$d,d1
		beq.s	l3606
		cmp.b	#$3c,d1
		bne.s	l35e8
	l35cc:	move.b	(a4)+,d1
		beq.s	l35cc
		cmp.b	#$d,d1
		beq.s	l3606
		cmp.b	#$3e,d1
		bne.s	l35e4
		move.b	(a4)+,d1
		cmp.b	#$3e,d1
		bne.s	l3606
	l35e4:	move.b	d1,(a0)+
		bra.s	l35cc
	l35e8:	move.b	d1,(a0)+
	l35ea:	move.b	(a4)+,d1
		beq.s	l35ea
		cmp.b	#$d,d1
		beq.s	l3606
		cmp.b	#$9,d1
		beq.s	l3606
		cmp.b	#$20,d1
		beq.s	l3606
		cmp.b	#$2c,d1
		bne.s	l35e8
	l3606:	clr.b	(a0)+
		cmp.b	#$2c,d1
		bne.s	l361c
		move.b	(a4)+,d1
		cmp.b	#$d,d1
		bne.s	L35b8
		bra.s	l3648
	l3618:	move.l	(a7)+,18302(a6)
	l361c:	move.l	a0,d0
		addq.l	#1,d0
		bclr	#$0,d0
		move.l	18308(a6),-(a7)
		move.l	d0,18308(a6)
		sub.l	(a7)+,d0
		sub.w	d0,18306(a6)
		move.w	18324(a6),d0
		beq.s	l363c
		st	280(a6)
	l363c:	st	259(a6)
		addq.w	#1,d0
		move.w	d0,18324(a6)
		rts
	l3648:	movea.l	18302(a6),a2
		move.l	a2,-(a7)
		move.l	(a2),18302(a6)
		movem.l	a0-1,-(a7)
		bsr.w	L3c4
		movem.l	(a7)+,a0-1
		bne.s	l3618
		cmp.b	#$26,d0
		bne.s	l3618
		movem.l	a0-1,-(a7)
		bsr.w	L5ee
		bsr.w	L468
		movem.l	(a7)+,a0-1
		movea.l	(a7)+,a2
		bne.w	l31f6
		move.l	a2,18302(a6)
		move.b	(a4)+,d1
		cmp.b	#$26,d1
		beq.s	l368e
		moveq	#68,d0
		bsr.w	L4fb6
	l368e:	move.b	(a4)+,d1
		cmp.b	#$9,d1
		beq.s	l368e
		cmp.b	#$20,d1
		beq.s	l368e
		bra.w	L35b8
	l36a0:	move.w	18324(a6),d0
		cmp.w	18326(a6),d0
		bhi.s	l36c2
		bsr.w	L3a44
		movea.l	a4,a0
		movea.l	18302(a6),a2
		lea	20(a2),a1
		moveq	#0,d2
		bra.s	l3726
	l36bc:	tst.l	18316(a6)
		bne.s	l36a0
	l36c2:	movea.l	18302(a6),a2
		movea.l	4(a2),a1
		movea.l	16(a2),a0
		cmpa.l	4(a1),a0
		bne.s	l36de
		movea.l	8(a1),a1
		move.l	a1,4(a2)
		movea.l	(a1),a0
	l36de:	moveq	#13,d0
		movea.l	a0,a4
		moveq	#92,d2
	l36e4:	move.b	(a0)+,d1
		cmp.b	d0,d1
		beq.s	L36f0
		cmp.b	d2,d1
		bne.s	l36e4
		bra.s	l370c

L36f0:
		tst.l	18316(a6)
		beq.s	l3700
		move.w	18324(a6),d0
		cmp.w	18326(a6),d0
		bls.s	l3704
	l3700:	move.l	a0,16(a2)
	l3704:	move.l	a4,492(a6)
		moveq	#0,d0
		rts
	l370c:	lea	20(a2),a1
		move.l	a0,d2
		sub.l	a4,d2
		subq.w	#1,d2
		beq.s	l3726
		move.l	a0,d1
		move.w	d2,d0
		movea.l	a4,a0
	l371e:	move.b	(a0)+,(a1)+
		subq.w	#1,d0
		bne.s	l371e
		movea.l	d1,a0
	l3726:	move.b	(a0)+,d1
		cmp.b	#$d,d1
		beq.s	l37ac
		cmp.b	#$40,d1
		beq.w	l37c2
		cmp.b	#$3c,d1
		beq.w	l3824
		moveq	#48,d0
		cmp.b	d0,d1
		bcs.s	l37b8
		cmp.b	#$3a,d1
		bcs.s	l3766
		moveq	#55,d0
		cmp.b	#$41,d1
		bcs.s	l378e
		cmp.b	#$5b,d1
		bcs.s	l3766
		moveq	#87,d0
		cmp.b	#$61,d1
		bcs.s	l378e
		cmp.b	#$7b,d1
		bcc.s	l378e
	l3766:	sub.b	d0,d1
		move.l	a0,-(a7)
		lea	278(a2),a0
		ext.w	d1
		beq.s	l3780
		cmp.w	8(a2),d1
		bgt.s	l378a
	l3778:	tst.b	(a0)+
		bne.s	l3778
		subq.w	#1,d1
		bne.s	l3778
	l3780:	addq.b	#1,d2
		beq.s	l37a4
		move.b	(a0)+,(a1)+
		bne.s	l3780
		subq.l	#1,a1
	l378a:	movea.l	(a7)+,a0
		bra.s	L3794
	l378e:	addq.b	#1,d2
		beq.s	l37a6
		move.b	d1,(a1)+

L3794:
		move.b	(a0)+,d1
		cmp.b	#$d,d1
		beq.s	l37ac
		cmp.b	#$5c,d1
		bne.s	l378e
		bra.s	l3726
	l37a4:	movea.l	(a7)+,a0
	l37a6:	cmpi.b	#$d,(a0)+
		bne.s	l37a6
	l37ac:	move.b	#$d,(a1)+
		lea	20(a2),a4
		bra.w	L36f0
	l37b8:	cmp.b	#$23,d1
		beq.w	l389e
		bra.s	l378e
	l37c2:	tst.b	12(a2)
		bne.s	l37d4
		st	12(a2)
		addq.w	#1,18300(a6)
		addq.w	#1,10(a2)
	l37d4:	cmp.b	#$f9,d2
		bcc.s	l37a6
		addq.b	#1,d2
		move.b	#$5f,(a1)+
		move.l	a0,-(a7)
		moveq	#0,d1
		move.w	10(a2),d1
		cmp.w	#$a,d1
		bcs.s	l3810
		cmp.w	#$64,d1
		bcs.s	l3816

L37f4:
		movem.l	a2-3/d4,-(a7)
		movea.l	a1,a3
		move.w	d2,d4
		lea	L381e(pc),a2
		bsr.w	L55e6
		movea.l	a3,a1
		move.w	d4,d2
		movem.l	(a7)+,d4/a2-3
		movea.l	(a7)+,a0
		bra.s	L3794
	l3810:	addq.b	#1,d2
		move.b	#$30,(a1)+
	l3816:	addq.b	#1,d2
		move.b	#$30,(a1)+
		bra.s	L37f4

L381e:
		dc.b	$52,$4,$16,$c1,$4e,$75
	l3824:	cmp.b	#$f5,d2
		bcc.w	l37a6
		move.b	(a0)+,d1
		movem.l	a0-4/d4/d2,-(a7)
		cmp.b	#$24,d1
		seq	d4
		bne.s	l3842
		move.b	(a0)+,d1
		bra.s	l3842
	l383e:	move.l	d2,d1
		bra.s	l3864
	l3842:	movea.l	a0,a4
		lea	918(a6),a0
		bsr.w	L4444
		bne.s	l3890
		cmp.b	#$3e,d1
		bne.s	l3890
		bsr.w	Lf6c
		beq.s	l383e
		bsr.w	L7a6
		bne.s	l3890
		move.l	8(a1),d1
	l3864:	movea.l	12(a7),a3
		lea	L381e(pc),a2
		tst.b	d4
		beq.s	l3878
		move.l	(a7),d4
		bsr.w	L55b6
		bra.s	l387e
	l3878:	move.l	(a7),d4
		bsr.w	L55e6
	l387e:	move.l	a3,d1
		move.w	d4,d2
		move.l	a4,d3
		movem.l	(a7)+,d0/d4/a0-4
		movea.l	d1,a1
		movea.l	d3,a0
		bra.w	L3794
	l3890:	movem.l	(a7)+,d2/d4/a0-4
		moveq	#71,d0
		bsr.w	L4fb6
		bra.w	L3794
	l389e:	cmp.b	#$fc,d2
		bcc.w	l37a6
		moveq	#0,d1
		move.w	8(a2),d1
		move.l	a0,-(a7)
		bra.w	L37f4
		dc.b	$4a,$2e,$1,$3,$67,$3e,$4a,$2e,$1,$17,$66,$4,$50,$ee,$1,$13
		dc.b	$53,$6e,$47,$94
		dc.b	"$nG~ "
		dc.b	$a,$90,$ae,$47,$84,$91,$6e,$47,$82,$2d,$4a,$47,$84,$30,$2a,$0
		dc.b	$e,$b0,$6e,$47,$7a,$6e,$1a
		dc.b	"=@Gz "
		dc.b	$12
		dc.b	"-@G~f"
		dc.b	$4,$51,$ee,$1,$3,$72,$d
		dc.b	"Nup3`"
		dc.b	$0,$16,$bc,$70,$39,$60,$0,$16,$a0,$4a,$ae,$47,$8c,$66,$0,$0
		dc.b	$36,$61,$0,$f8,$b6,$2d,$42,$47,$88,$6e,$30,$61,$0,$cc,$d8,$61
		dc.b	$0,$cb,$68,$66,$0,$f8,$d8,$61,$0,$f9,$92,$67,$ee,$4a,$82,$66
		dc.b	$ea,$b2,$bc
		dc.b	"REPTg"
		dc.b	$c,$b2,$bc
		dc.b	"ENDRf"
		dc.b	$da,$72,$d
		dc.b	"NupE`"
		dc.b	$0,$16,$70,$20,$6e,$1,$40,$c,$6e,$1,$10,$1,$44,$64,$4,$61
		dc.b	$0,$fa,$18,$2d,$48,$47,$8c,$3f,$2e,$1,$44,$42,$a8,$0,$8,$43
		dc.b	$e8,$0,$10,$20,$89,$21,$49,$0,$4,$21,$48,$0,$c,$2d,$49,$1
		dc.b	$40,$4,$6e,$0,$10,$1,$44,$26,$48,$61,$0,$cc,$72,$42,$ae,$47
		dc.b	$8c,$61,$0,$ca,$e4,$66,$0,$f8,$6e,$2d,$4b,$47,$8c,$61,$0,$fa
		dc.b	$b0,$61,$0,$f9,$20,$67,$e2,$b2,$bc
		dc.b	"ENDRf"
		dc.b	$da,$4a,$82,$66,$d6,$61,$0,$cc,$48,$50,$ee,$1,$13,$20,$6b,$0
		dc.b	$c,$21,$6e,$1,$40,$0,$4,$8,$2e,$0,$0,$1,$43,$67,$14,$53
		dc.b	$6e,$1,$44,$52,$ae,$1,$40,$4a,$2e,$1,$3,$67,$6,$3d,$6e,$47
		dc.b	$94,$47,$96,$53,$ae,$47,$88
		dc.b	"e<-KG"
		dc.b	$8c,$43,$eb,$0,$10,$2d,$49,$47,$90,$61,$0,$ca,$82,$66,$0,$f8
		dc.b	$c,$48,$e7,$0,$18,$61,$0,$f8,$c2,$4c,$df,$18,$0,$67,$c,$b2
		dc.b	$bc
		dc.b	"ENDRf"
		dc.b	$4,$4a,$82,$67,$cc,$50,$ee,$1,$13,$2f,$b,$61,$0,$cc,$2c,$26
		dc.b	$5f,$60,$d0,$30,$1f,$34,$2e,$1,$44,$4a,$ab,$0,$8,$67,$2,$70
		dc.b	$0,$94,$40,$95,$6e,$1,$44,$48,$c2,$d5,$ae,$1,$40,$42,$ae,$47
		dc.b	$8c,$41,$fa,$23,$d2,$2d,$48,$1,$96,$72,$d
		dc.b	"NupF`"
		dc.b	$0,$15,$74

L3a44:
		movea.l	18316(a6),a1
		movea.l	18320(a6),a0
		cmpa.l	4(a1),a0
		bne.s	l3a5c
		movea.l	8(a1),a1
		move.l	a1,18316(a6)
		movea.l	(a1),a0
	l3a5c:	movea.l	a0,a4
		moveq	#13,d0
	l3a60:	cmp.b	(a0)+,d0
		bne.s	l3a60
		move.l	a0,18320(a6)
		move.l	a4,492(a6)
		moveq	#0,d0
		rts

L3a70:
		moveq	#31,d0
		move.l	#$91f,d1
	l3a78:	add.l	d1,d1
		dbcs	d0,l3a78
		roxr.l	#1,d1
		subi.w	#$1f,d0
		neg.w	d0
	l3a86:	cmp.l	d1,d3
		bcs.s	l3a8c
		sub.l	d1,d3
	l3a8c:	lsr.l	#1,d1
		dbra	d0,l3a86
		add.w	d3,d3
		rts

L3a96:
		lea	L3aec(pc),a0
		move.w	#$91e,d1
		lea	18328(a6),a1
		moveq	#-1,d2
	l3aa4:	move.w	d2,(a1)+
		dbra	d1,l3aa4
		move.w	#$9d,d4
		lea	18328(a6),a1
		moveq	#0,d2
	l3ab4:	move.l	(a0),d3
		bsr.s	L3a70
		tst.w	0(a1,d3.w)
		bpl.s	l3ad0
		move.w	d2,0(a1,d3.w)
		addi.w	#$a,d2
		adda.w	#$a,a0
		dbra	d4,l3ab4
		rts
	l3ad0:	moveq	#8,d0
		bra.w	L4fa0
		dc.b	"NEEQC"
		dc.b	$0,$4e,$43,$44,$0
		dc.b	"NDGTGLLTLE"
		dc.b	$0,$0

L3aec:
		dc.b	"LEA A"
		dc.b	$c0,$e7,$9c,$80,$0
		dc.b	"RTS Nu"
		dc.b	$8,$8e,$80,$0
		dc.b	"BRA `"
		dc.b	$0,$de,$58,$80,$0
		dc.b	"BSR a"
		dc.b	$0,$de,$4e,$80,$0
		dc.b	"TST J"
		dc.b	$0,$f4,$68,$80,$0
		dc.b	"JMP N"
		dc.b	$c0,$e7,$5a,$80,$0
		dc.b	"JSR N"
		dc.b	$80,$e7,$50,$80,$0,$45,$51,$55,$20

L3b36:
		dc.b	$0,$0,$e3,$b6,$0,$0
		dc.b	"ADDQP"
		dc.b	$0,$e9,$2,$80,$0
		dc.b	"SUBQQ"
		dc.b	$0,$e8,$f8,$80,$0,$41,$44,$44,$20,$d0,$0,$dc,$fe,$80,$0,$53
		dc.b	$55,$42,$20,$90,$0,$dc,$f4,$80,$0,$43,$4d,$50,$20,$b0,$0,$df
		dc.b	$f2,$80,$0,$41,$4e,$44,$20,$c0,$0,$e8,$4e,$80,$0,$4f,$52,$20
		dc.b	$20,$80,$0,$e8,$44,$80,$0,$45,$4f,$52,$20,$b0,$0,$e8,$3a,$80
		dc.b	$0
		dc.b	"CLR B"
		dc.b	$0,$f3,$f0,$80,$0
		dc.b	"NOT F"
		dc.b	$0,$f3,$e6,$80,$0
		dc.b	"DBF Q"
		dc.b	$c8,$e1,$26,$80,$0
		dc.b	"DBRAQ"
		dc.b	$c8,$e1,$1c,$80,$0
		dc.b	"TRAPN@"
		dc.b	$f3,$9a,$80,$0
		dc.b	"BEQ g"
		dc.b	$0,$dd,$9a,$80,$0
		dc.b	"BNE f"
		dc.b	$0,$dd,$90,$80,$0
		dc.b	"BCC d"
		dc.b	$0,$dd,$86,$80,$0
		dc.b	"BCS e"
		dc.b	$0,$dd,$7c,$80,$0
		dc.b	"BPL j"
		dc.b	$0,$dd,$72,$80,$0
		dc.b	"BMI k"
		dc.b	$0,$dd,$68,$80,$0
		dc.b	"BHI b"
		dc.b	$0,$dd,$5e,$80,$0
		dc.b	"BLS c"
		dc.b	$0,$dd,$54,$80,$0,$44,$43,$20,$20,$0,$0,$e1,$d2,$0,$0,$45
		dc.b	$58,$47,$20,$c1,$0,$e4,$70,$80,$0
		dc.b	"EXT H"
		dc.b	$80,$e4,$bc,$80,$0
		dc.b	"NEG D"
		dc.b	$0,$f3,$50,$80,$0,$41,$44,$44,$49,$6,$0,$dc,$fc,$80,$0,$53
		dc.b	$55,$42,$49,$4,$0,$dc,$f2,$80,$0,$43,$4d,$50,$49,$c,$0,$dc
		dc.b	$e8,$80,$0,$41,$44,$44,$41,$d0,$c0,$dc,$b0,$80,$0,$53,$55,$42
		dc.b	$41,$90,$c0,$dc,$a6,$80,$0,$43,$4d,$50,$41,$b0,$c0,$dc,$9c,$80
		dc.b	$0,$41,$4e,$44,$49,$2,$0,$e6,$d6,$80,$0,$4f,$52,$49,$20,$0
		dc.b	$0,$e6,$cc,$80,$0,$45,$4f,$52,$49,$a,$0,$e6,$c2,$80,$0
		dc.b	"LINKNP"
		dc.b	$e6,$2c,$80,$0
		dc.b	"UNLKNX"
		dc.b	$f3,$3c,$80,$0,$42,$54,$53,$54,$8,$0,$dd,$f4,$80,$0,$42,$43
		dc.b	$4c,$52,$8,$80,$de,$40,$80,$0,$42,$53,$45,$54,$8,$c0,$de,$36
		dc.b	$80,$0,$42,$43,$48,$47,$8,$40,$de,$2c,$80,$0,$41,$53,$4c,$20
		dc.b	$e1,$0,$f1,$94,$80,$0,$41,$53,$52,$20,$e0,$0,$f1,$8a,$80,$0
		dc.b	$4c,$53,$4c,$20,$e1,$8,$f1,$80,$80,$0,$4c,$53,$52,$20,$e0,$8
		dc.b	$f1,$76,$80,$0,$52,$4f,$58,$4c,$e1,$10,$f1,$6c,$80,$0,$52,$4f
		dc.b	$58,$52,$e0,$10,$f1,$62,$80,$0,$52,$4f,$4c,$20,$e1,$18,$f1,$58
		dc.b	$80,$0,$52,$4f,$52,$20,$e0,$18,$f1,$4e,$80,$0
		dc.b	"SWAPH@"
		dc.b	$f2,$18,$80,$0
		dc.b	"DBEQW"
		dc.b	$c8,$df,$a0,$80,$0
		dc.b	"DBNEV"
		dc.b	$c8,$df,$96,$80,$0
		dc.b	"DBCCT"
		dc.b	$c8,$df,$8c,$80,$0
		dc.b	"DBCSU"
		dc.b	$c8,$df,$82,$80,$0
		dc.b	"DBPLZ"
		dc.b	$c8,$df,$78,$80,$0
		dc.b	"DBMI["
		dc.b	$c8,$df,$6e,$80,$0
		dc.b	"DBHIR"
		dc.b	$c8,$df,$64,$80,$0
		dc.b	"DBLSS"
		dc.b	$c8,$df,$5a,$80,$0,$41,$44,$44,$58,$d1,$0,$da,$4,$80,$0,$53
		dc.b	$55,$42,$58,$91,$0,$d9,$fa,$80,$0
		dc.b	"NEGX@"
		dc.b	$0,$f1,$f2,$80,$0
		dc.b	"BVC h"
		dc.b	$0,$db,$c4,$80,$0
		dc.b	"BVS i"
		dc.b	$0,$db,$ba,$80,$0
		dc.b	"BGE l"
		dc.b	$0,$db,$b0,$80,$0
		dc.b	"BLT m"
		dc.b	$0,$db,$a6,$80,$0
		dc.b	"BGT n"
		dc.b	$0,$db,$9c,$80,$0
		dc.b	"BLE o"
		dc.b	$0,$db,$92,$80,$0
		dc.b	"DBVCX"
		dc.b	$c8,$de,$f6,$80,$0
		dc.b	"DBVSY"
		dc.b	$c8,$de,$ec,$80,$0
		dc.b	"DBGE\"
		dc.b	$c8,$de,$e2,$80,$0
		dc.b	"DBLT]"
		dc.b	$c8,$de,$d8,$80,$0
		dc.b	"DBGT^"
		dc.b	$c8,$de,$ce,$80,$0
		dc.b	"DBLE_"
		dc.b	$c8,$de,$c4,$80,$0
		dc.b	"DBT P"
		dc.b	$c8,$de,$ba,$80,$0
		dc.b	"STOPNr"
		dc.b	$f1,$0,$80,$0
		dc.b	"ST  P"
		dc.b	$c0,$ef,$5c,$80,$0
		dc.b	"SF  Q"
		dc.b	$c0,$ef,$52,$80,$0
		dc.b	"SNE V"
		dc.b	$c0,$ef,$48,$80,$0
		dc.b	"SEQ W"
		dc.b	$c0,$ef,$3e,$80,$0
		dc.b	"SCC T"
		dc.b	$c0,$ef,$34,$80,$0
		dc.b	"SCS U"
		dc.b	$c0,$ef,$2a,$80,$0
		dc.b	"SPL Z"
		dc.b	$c0,$ef,$20,$80,$0
		dc.b	"SMI ["
		dc.b	$c0,$ef,$16,$80,$0
		dc.b	"SVC X"
		dc.b	$c0,$ef,$c,$80,$0
		dc.b	"SVS Y"
		dc.b	$c0,$ef,$2,$80,$0
		dc.b	"SGE \"
		dc.b	$c0,$ee,$f8,$80,$0
		dc.b	"SLT ]"
		dc.b	$c0,$ee,$ee,$80,$0
		dc.b	"SGT ^"
		dc.b	$c0,$ee,$e4,$80,$0
		dc.b	"SLE _"
		dc.b	$c0,$ee,$da,$80,$0
		dc.b	"SHI R"
		dc.b	$c0,$ee,$d0,$80,$0
		dc.b	"SLS S"
		dc.b	$c0,$ee,$c6,$80,$0
		dc.b	"CHK A"
		dc.b	$80,$dc,$74,$80,$0,$4d,$55,$4c,$55,$c0,$c0,$dc,$6a,$80,$0,$4d
		dc.b	$55,$4c,$53,$c1,$c0,$dc,$60,$80,$0,$44,$49,$56,$55,$80,$c0,$dc
		dc.b	$56,$80,$0,$44,$49,$56,$53,$81,$c0,$dc,$4c,$80,$0,$41,$42,$43
		dc.b	$44,$c1,$0,$d8,$8e,$80,$0,$53,$42,$43,$44,$81,$0,$d8,$84,$80
		dc.b	$0
		dc.b	"NBCDH"
		dc.b	$0,$e9,$b0,$80,$0
		dc.b	"NOP Nq"
		dc.b	$4,$74,$80,$0
		dc.b	"RTE Ns"
		dc.b	$4,$6a,$80,$0,$43,$4d,$50,$4d,$b1,$8,$dc,$ec,$80,$0
		dc.b	"RTR Nw"
		dc.b	$4,$56,$80,$0
		dc.b	"PEA H@"
		dc.b	$ec,$80,$80,$0
		dc.b	"TAS J"
		dc.b	$c0,$f0,$0,$80,$0,$45,$4e,$44,$4d,$0,$0,$f9,$60,$0,$0,$49
		dc.b	$46,$45,$51,$0,$0,$f2,$ba,$0,$0,$49,$46,$4e,$45,$0,$0,$f2
		dc.b	$b6,$0,$0,$45,$4e,$44,$43,$0,$0,$f3,$e2,$0,$0,$49,$46,$44
		dc.b	$20,$0,$0,$f2,$8,$0,$0,$49,$46,$4e,$44,$0,$0,$f2,$12,$0
		dc.b	$0,$44,$53,$20,$20,$0,$0,$df,$1a,$0,$0,$52,$53,$20,$20,$0
		dc.b	$0,$ec,$e2,$0,$0,$4c,$49,$53,$54,$0,$0,$c6,$2,$40,$0,$45
		dc.b	$4e,$44,$20,$0,$0,$df,$1a,$40,$0,$45,$51,$55,$52,$0,$0,$e0
		dc.b	$60,$0,$0,$53,$45,$54,$20,$0,$0,$ee,$1a,$0,$0,$4f,$50,$54
		dc.b	$20,$0,$0,$e9,$a2,$40,$0,$45,$56,$45,$4e,$0,$0,$e0,$ac,$80
		dc.b	$0,$49,$46,$47,$54,$0,$0,$f2,$20,$0,$0,$49,$46,$47,$45,$0
		dc.b	$0,$f2,$1c,$0,$0,$49,$46,$4c,$54,$0,$0,$f2,$18,$0,$0,$49
		dc.b	$46,$4c,$45,$0,$0,$f2,$14,$0,$0,$49,$46,$43,$20,$0,$0,$f1
		dc.b	$46,$0,$0,$49,$46,$4e,$43,$0,$0,$f1,$44,$0,$0,$53,$50,$43
		dc.b	$20,$0,$0,$ee,$d4,$40,$0,$50,$4c,$45,$4e,$0,$0,$eb,$ca,$40
		dc.b	$0,$4c,$4c,$45,$4e,$0,$0,$e2,$fe,$40,$0,$54,$54,$4c,$20,$0
		dc.b	$0,$ef,$56,$40,$0,$46,$41,$49,$4c,$0,$0,$e0,$bc,$40,$0,$43
		dc.b	$4e,$4f,$50,$0,$0,$db,$fe,$0,$0,$58,$44,$45,$46,$0,$0,$ef
		dc.b	$a6,$40,$0,$58,$52,$45,$46,$0,$0,$ef,$f4,$40,$0,$50,$41,$47
		dc.b	$45,$0,$0,$eb,$64,$40,$0,$4f,$52,$47,$20,$0,$0,$e8,$b0,$0
		dc.b	$0,$49,$44,$4e,$54,$0,$0,$e4,$e,$0,$0,$44,$43,$42,$20,$0
		dc.b	$0,$dc,$90,$0,$0,$52,$45,$47,$20,$0,$0,$eb,$80,$0,$0,$52
		dc.b	$4f,$52,$47,$0,$0,$ec,$8e,$0,$0,$52,$45,$50,$54,$0,$0,$f8
		dc.b	$5c,$80,$0,$45,$4e,$44,$52,$0,$0,$f9,$8e,$0,$0
		dc.b	"BHS d"
		dc.b	$0,$d8,$a4,$80,$0
		dc.b	"BLO e"
		dc.b	$0,$d8,$9a,$80,$0
		dc.b	"DBHST"
		dc.b	$c8,$db,$fe,$80,$0
		dc.b	"DBLOU"
		dc.b	$c8,$db,$f4,$80,$0
		dc.b	"SHS T"
		dc.b	$c0,$ec,$a0,$80,$0
		dc.b	"SLO U"
		dc.b	$c0,$ec,$96,$80,$0,$49,$49,$46,$20,$0,$0,$e0,$5e,$0,$0,$54
		dc.b	$45,$58,$54,$0,$0,$ec,$a0,$0,$0,$44,$41,$54,$41,$0,$0,$ec
		dc.b	$88,$0,$0,$42,$53,$53,$20,$0,$0,$ec,$86,$0,$0,$41,$4d,$50
		dc.b	$21

L411c:
		dc.b	$0,$0,$e4,$0,$80,$0

L4122:
		dc.b	"MOVEQ   p"
		dc.b	$0,$e7,$e,$80,$0
		dc.b	"MOVEM   H"
		dc.b	$80,$e4,$e2,$80,$0
		dc.b	"MACRO   "
		dc.b	$0,$0,$f2,$3c,$0,$0
		dc.b	"MOVEA    @"
		dc.b	$e6,$2,$80,$0
		dc.b	"MOVEP   "
		dc.b	$1,$8,$e6,$2a,$80,$0
		dc.b	"INCLUDE "
		dc.b	$0,$0,$e0,$f6,$40,$0
		dc.b	"RESET   Np"
		dc.b	$2,$a,$80,$0
		dc.b	"TRAPV   Nv"
		dc.b	$1,$fc,$80,$0
		dc.b	"NOLIST  "
		dc.b	$0,$0,$c4,$3c,$40,$0
		dc.b	"MEXIT   "
		dc.b	$0,$0,$f7,$8,$0,$0
		dc.b	"MODULE  "
		dc.b	$0,$0,$e2,$d4,$80,$0
		dc.b	"SECTION "
		dc.b	$0,$0,$ec,$2,$0,$0
		dc.b	"LISTCHAR"
		dc.b	$0,$0,$e1,$2e,$40,$0
		dc.b	"RSRESET "
		dc.b	$0,$0,$eb,$86,$40,$0
		dc.b	"RSSET   "
		dc.b	$0,$0,$eb,$80,$40,$0
		dc.b	"INCBIN  "
		dc.b	$0,$0,$df,$80,$80,$0
		dc.b	"ILLEGAL J"
		dc.b	$fc,$1,$7e,$80,$0
		dc.b	"ELSEIF  "
		dc.b	$0,$0,$f1,$4c,$40,$0
		dc.b	"OFFSET  "
		dc.b	$0,$0,$e6,$a0,$0,$0
		dc.b	"OUTPUT  "
		dc.b	$0,$0,$e9,$56,$40,$0
		dc.b	"COMMENT "
		dc.b	$0,$0,$da,$62,$40,$0
		dc.b	"SUBTTL  "
		dc.b	$0,$0,$ed,$84,$40,$0
		dc.b	"FORMAT  "
		dc.b	$0,$0,$de,$a6,$40,$0
		dc.b	"INCDIR  "
		dc.b	$0,$0,$df,$80,$40,$0

L4272:
		rts
	l4274:	lea	L3b36(pc),a0
		bra.s	l42ae

L427a:
		cmp.b	#$4,d2
		bcs.w	l4364
		move.l	1320(a6),d3
		lea	L411c(pc),a0
		cmp.l	#$4d4f5645,d3
		beq.s	L42ac
		move.l	d3,d4
		bsr.w	L3a70
		lea	18328(a6),a0
		move.w	0(a0,d3.w),d0
		bmi.s	L4272
		lea	L3aec(pc),a0
		adda.w	d0,a0
		cmp.l	(a0)+,d4
		bne.s	L4272

L42ac:
		addq.l	#4,a7
	l42ae:	tst.b	255(a6)
		beq.s	l42be
		tst.b	464(a6)
		beq.s	l42be
		bsr.w	L5cf2
	l42be:	move.b	-1(a4),d1
		moveq	#0,d0
		cmp.b	#$2e,d1
		bne.s	l431e
		move.b	(a4)+,d1
		ext.w	d1
		move.b	126(a6,d1.w),d1
		moveq	#1,d0
		cmp.b	#$42,d1
		beq.s	l4308
		moveq	#2,d0
		cmp.b	#$57,d1
		beq.s	l4308
		moveq	#3,d0
		cmp.b	#$4c,d1
		beq.s	l4308
		moveq	#1,d0
		cmp.b	#$53,d1
		beq.s	l4308
		cmp.b	#$9,d1
		beq.s	l4300
		cmp.b	#$20,d1
		bne.w	l4f7c
	l4300:	bne.w	l4f7c
		moveq	#2,d0
		subq.l	#1,a4
	l4308:	move.b	(a4)+,d1
		cmp.b	#$9,d1
		beq.s	l431e
		cmp.b	#$20,d1
		beq.s	l431e
		cmp.b	#$d,d1
		bne.w	l4f7c
	l431e:	cmp.b	#$d,d1
		beq.s	l4332
		move.b	(a4)+,d1
		cmp.b	#$9,d1
		beq.s	l431e
		cmp.b	#$20,d1
		beq.s	l431e
	l4332:	move.b	d0,465(a6)
		sf	467(a6)
		move.w	(a0)+,d6
		move.w	(a0)+,d3
		pea	L439a(pc)
		pea	-2(a0,d3.w)
		move.w	(a0)+,d2
		move.w	d1,-(a7)
		btst	#$f,d2
		beq.s	l4356
		bsr.w	L874
		bra.s	l4360
	l4356:	btst	#$e,d2
		beq.s	l4360
		bsr.w	L85a
	l4360:	move.w	(a7)+,d1
		rts
	l4364:	movem.l	1320(a6),d0-1
		lea	L4122(pc),a0
		moveq	#10,d2
		moveq	#23,d3
	l4372:	cmp.l	(a0)+,d0
		beq.s	l4380
	l4376:	adda.l	d2,a0
		dbra	d3,l4372
		bra.w	L4272
	l4380:	cmp.l	(a0),d1
		bne.s	l4376
		addq.l	#4,a0
		bra.w	L42ac
		dc.b	$3a,$c6,$72,$d,$4e,$75,$20,$6e,$1,$96,$42,$ae,$1,$96,$4e,$d0

L439a:
		dc.b	$b2,$3c,$0,$d,$67,$1e,$b2,$3c,$0,$9,$67,$18,$b2,$3c,$0,$20
		dc.b	$67,$12,$b2,$3c,$0,$2a,$67,$c,$b2,$3c,$0,$3b,$67,$6,$70,$e
		dc.b	$61,$0,$b,$fa,$4a,$ae,$1,$96,$66,$cc,$4a,$ae,$1,$ae,$67,$1a
		dc.b	$22,$2e,$1,$ae,$42,$ae,$1,$ae,$d3,$ae,$1,$dc,$4a,$81,$6b,$4
		dc.b	$d3,$ae,$1,$d8,$42,$ae,$1,$9e,$4e,$75,$22,$d,$92,$ae,$1,$f8
		dc.b	$2d,$41,$1,$9e,$67,$1a,$24,$2e,$1,$dc,$d3,$ae,$1,$dc,$d3,$ae
		dc.b	$1,$d8,$4a,$2e,$1,$d0,$67,$8,$4a,$2e,$1,$5,$66,$0,$18,$fe
		dc.b	$4e,$75

L440c:
		bsr.s	L4444
		bne.s	l442c
		movea.l	(a0),a1
		move.b	5(a0),d0
		moveq	#46,d2
		addq.l	#1,a1
		bra.s	l4420
	l441c:	cmp.b	(a1)+,d2
		beq.s	l442e
	l4420:	subq.b	#1,d0
		bne.s	l441c
		move.b	5(a0),d2
		movea.l	a4,a1
		moveq	#0,d0
	l442c:	rts
	l442e:	movea.l	a4,a1
		move.b	5(a0),d2
		sub.b	d0,5(a0)
		ext.w	d0
		suba.w	d0,a4
		move.b	-1(a4),d1
		moveq	#0,d0
		rts

L4444:
		andi.w	#$ff,d1
		lea	L6fe2(pc),a2
		tst.b	0(a2,d1.w)
		beq.s	l4480
		bpl.s	l44c2
		move.b	(a4),d1
		ext.w	d1
		move.b	126(a6,d1.w),d1
		cmp.b	#$57,d1
		beq.s	l446e
		cmp.b	#$42,d1
		beq.s	l446e
		cmp.b	#$4c,d1
		bne.s	l447c
	l446e:	move.b	1(a4),d1
		tst.b	0(a2,d1.w)
		ble.s	l447c
		moveq	#46,d1
		bra.s	l44c2
	l447c:	moveq	#46,d1
		bra.s	l44c8
	l4480:	cmp.b	#$3a,d1
		bcc.s	l44c8
		lea	-1(a4),a1
		movea.l	a4,a2
	l448c:	move.b	(a2)+,d1
		cmp.b	#$24,d1
		beq.s	l44a0
		cmp.b	#$3a,d1
		bcc.s	l44c2
		cmp.b	#$30,d1
		bcc.s	l448c
	l44a0:	movea.l	a2,a4
		move.l	a2,d0
		sub.l	a1,d0
		move.b	d0,5(a0)
		lea	6(a0),a2
		move.l	a2,(a0)
		move.b	278(a6),(a2)+
		subq.b	#1,d0
	l44b6:	move.b	(a1)+,(a2)+
		subq.b	#1,d0
		bne.s	l44b6
		move.b	(a4)+,d1
		moveq	#0,d0
		rts
	l44c2:	clr.l	(a0)
		moveq	#40,d0
		rts
	l44c8:	tst.b	254(a6)
		bne.w	l453c
		move.b	d1,6(a0)
		lea	-1(a4),a1
		move.l	a1,(a0)
		moveq	#0,d1
		moveq	#0,d2
	l44de:	move.b	(a4)+,d1
		tst.b	0(a2,d1.w)
		beq.s	l44de
		bpl.s	l4520
		move.l	a4,d2
		bra.s	l44de
	l44ec:	sub.l	a4,d2
		addq.l	#2,d2
		bne.s	l4524
		move.b	-2(a4),d2
		cmp.b	#$4c,d2
		beq.s	l451a
		cmp.b	#$6c,d2
		beq.s	l451a
		cmp.b	#$57,d2
		beq.s	l451a
		cmp.b	#$77,d2
		beq.s	l451a
		cmp.b	#$42,d2
		beq.s	l451a
		cmp.b	#$62,d2
		bne.s	l4524
	l451a:	subq.l	#2,a4
		moveq	#46,d1
		bra.s	l4524
	l4520:	tst.l	d2
		bne.s	l44ec
	l4524:	move.l	a4,d0
		sub.l	(a0),d0
		cmp.w	454(a6),d0
		bcs.s	l4532
		move.w	454(a6),d0
	l4532:	subq.b	#1,d0
		move.b	d0,5(a0)
		moveq	#0,d0
		rts
	l453c:	lea	6(a0),a1
		move.l	a1,(a0)
		moveq	#1,d2
		moveq	#0,d0
	l4546:	ext.w	d1
		move.b	126(a6,d1.w),d1
		move.b	d1,(a1)+
		moveq	#0,d1
		move.b	(a4)+,d1
		tst.b	0(a2,d1.w)
		bgt.s	l4570
		bmi.s	l4562
		addq.b	#1,d2
		bpl.s	l4546
		moveq	#127,d2
		bra.s	l4568
	l4562:	move.l	a4,d0
		addq.b	#1,d2
		bpl.s	l4546
	l4568:	move.b	(a4)+,d1
		tst.b	0(a2,d1.w)
		ble.s	l4568
	l4570:	tst.l	d0
		beq.s	l459c
		sub.l	a4,d0
		addq.l	#2,d0
		bne.s	l459c
		move.b	-2(a4),d0
		cmp.b	#$4c,d0
		beq.s	l4596
		cmp.b	#$6c,d0
		beq.s	l4596
		cmp.b	#$57,d0
		beq.s	l4596
		cmp.b	#$77,d0
		bne.s	l459c
	l4596:	moveq	#46,d1
		subq.l	#2,a4
		subq.b	#2,d2
	l459c:	move.b	d2,5(a0)
		moveq	#0,d0
		rts

L45a4:
		moveq	#0,d0
		move.b	d1,d2
		cmp.b	#$22,d1
		beq.s	l45b8
		cmp.b	#$27,d1
		beq.s	l45b8
		moveq	#0,d2
		subq.l	#1,a4
	l45b8:	move.b	(a4)+,d1
		cmp.b	#$d,d1
		beq.s	l45fc
		cmp.b	d1,d2
		beq.s	l460c
		cmp.b	#$9,d1
		beq.s	l45d0
		cmp.b	#$20,d1
		bne.s	l45d4
	l45d0:	tst.b	d2
		beq.s	l45fc
	l45d4:	cmp.b	#$2c,d1
		bne.s	l45e6
		btst	#$10,d3
		beq.s	l45e6
	l45e0:	move.l	a4,438(a6)
		bra.s	l45fc
	l45e6:	btst	#$11,d3
		bne.s	l45f2
		ext.w	d1
		move.b	126(a6,d1.w),d1
	l45f2:	move.b	d1,6(a0,d0.w)
		addq.b	#1,d0
		bpl.s	l45b8
		moveq	#126,d0
	l45fc:	lea	5(a0),a1
		addq.b	#1,d0
		move.b	d0,(a1)+
		move.b	d3,5(a0,d0.w)
		move.l	a1,(a0)
		rts
	l460c:	cmpi.b	#$2c,(a4)+
		bne.s	l45fc
		bra.s	l45e0
		dc.b	$ff,$ff,$ff,$0,$20,$2,$c0,$ba,$ff,$f8,$67,$44,$b0,$ba,$ff,$f2
		dc.b	"g>`* "
		dc.b	$2
		dc.b	"H@J@g4R@g0`"
		dc.b	$1c,$b6,$3c,$0,$1,$67,$1c,$10,$2,$48,$80,$60,$8,$b6,$3c,$0
		dc.b	$1,$67,$10,$30,$2,$48,$c0,$b4,$80,$66,$2,$4e,$75,$70,$1c,$60
		dc.b	$0,$9,$60,$70,$1d,$4a,$2e,$1,$9,$67,$0,$9,$56,$4e,$75,$b6
		dc.b	$3c,$0,$1,$67,$ee,$4e,$75

L466c:
		movea.l	a4,a0
		lea	L4688(pc),a4
		move.b	(a4)+,d1
		move.l	a0,-(a7)
		bsr.s	L469a
		lea	L4694(pc),a4
		move.b	(a4)+,d1
		moveq	#1,d3
		bsr.w	L46ea
		movea.l	(a7)+,a4
		rts

L4688:
		dc.b	"ANON_MODULE"
		dc.b	$d

L4694:
		dc.b	$54,$45,$58,$54,$d,$0

L469a:
		clr.l	334(a6)
		lea	918(a6),a0
		moveq	#9,d3
		bsr.w	L45a4
		movea.l	358(a6),a2
		movem.l	a3-5,-(a7)
		bsr.w	L7da
		sne	d0
		movem.l	(a7)+,a3-5
		tst.b	464(a6)
		bne.s	l46da
		tst.b	d0
		beq.s	l46da
		moveq	#0,d4
		moveq	#9,d3
		bsr.w	L8c6

L46cc:
		move.l	a1,308(a6)
		lea	16(a1),a1
		move.l	a1,342(a6)
		rts
	l46da:	tst.b	d0
		bne.s	l46e4
		bsr.s	L46cc
		bra.w	L5c86
	l46e4:	moveq	#11,d0
		bra.w	L4fa0

L46ea:
		sf	283(a6)
		sf	284(a6)
		move.b	d3,266(a6)
		lea	918(a6),a0
		clr.l	438(a6)
		bset	#$10,d3
		bsr.w	L45a4
		movea.l	308(a6),a2
		addq.w	#8,a2
		movem.l	a3-5/d3,-(a7)
		bsr.w	L7da
		sne	d0
		movem.l	(a7)+,d3/a3-5
		tst.b	464(a6)
		bne.s	l4752
		tst.b	d0
		beq.s	l473e
		moveq	#0,d4
		bsr.w	L8c6
		movea.l	308(a6),a0
		subq.b	#1,12(a0)
		move.b	12(a0),d0
		bsr.w	L4770
		move.b	d0,14(a1)
	l473e:	move.l	a1,312(a6)
		move.l	8(a1),476(a6)
		move.b	14(a1),316(a6)
		bra.w	L5e0c
	l4752:	tst.b	d0
		beq.s	l473e
		bra.s	l46e4

L4758:
		movea.l	312(a6),a1
		move.l	476(a6),8(a1)
		bra.w	L5de0

L4766:
		tst.b	464(a6)
		bne.w	l5ca6
		rts

L4770:
		tst.b	255(a6)
		beq.s	l477e
		cmpi.w	#$1,452(a6)
		bne.s	l47c2
	l477e:	move.b	22(a1),d0
		move.l	22(a1),d1
		cmp.b	#$4,d0
		beq.s	l479c
		cmp.b	#$5,d0
		beq.s	l47a8
	l4792:	moveq	#13,d0
		bsr.w	L4fb6
		moveq	#0,d0
		rts
	l479c:	cmp.l	#$4425353,d1
		bne.s	l4792
		moveq	#24,d0
		rts
	l47a8:	lsl.l	#8,d1
		move.b	26(a1),d1
		moveq	#0,d0
		cmp.l	#$54455854,d1
		beq.s	l47c2
		cmp.l	#$44415441,d1
		bne.s	l4792
		moveq	#12,d0
	l47c2:	rts

L47c4:
		lea	23002(a6),a0
		clr.w	(a0)
		move.l	a0,22998(a6)
		sf	267(a6)
		rts

L47d4:
		move.l	a0,-(a7)
		movea.l	22998(a6),a0
		move.w	#$2b2b,(a0)+
		move.w	d3,(a0)+
	l47e0:	move.l	a0,22998(a6)
		clr.w	(a0)
		movea.l	(a7)+,a0
		rts

L47ea:
		move.l	a0,-(a7)
		move.b	14(a1),d0
		movea.l	22998(a6),a0
		move.w	#$2b2b,(a0)+
		st	(a0)+
		move.b	d0,(a0)+
		bra.s	l47e0
		dc.b	$2f,$8,$20,$6e,$59,$d6,$31,$7c,$2d,$2d,$ff,$fc,$20,$5f,$4e,$75

L480e:
		dc.b	"line malformed"
		dc.b	$0
		dc.b	"out of memory"
		dc.b	$0
		dc.b	"undefined symbol"
		dc.b	$0
		dc.b	"additional symbol on pass 2"
		dc.b	$0
		dc.b	"symbol defined twice"
		dc.b	$0
		dc.b	"phasing error"
		dc.b	$0
		dc.b	"local not allowed"
		dc.b	$0
		dc.b	"INTERNAL:invalid hashing"
		dc.b	$0
		dc.b	"instruction not recognised"
		dc.b	$0
		dc.b	"invalid size"
		dc.b	$0
		dc.b	"duplicate MODULE name"
		dc.b	$0
		dc.b	"forward reference"
		dc.b	$0
		dc.b	"invalid section name, TEXT assumed"
		dc.b	$0
		dc.b	"garbage following instruction"
		dc.b	$0
		dc.b	"addressing mode not recognised"
		dc.b	$0
		dc.b	"address register expected"
		dc.b	$0
		dc.b	"addressing mode not allowed"
		dc.b	$0
		dc.b	"expression mismatch"
		dc.b	$0
		dc.b	"missing close bracket"
		dc.b	$0
		dc.b	"imported label not allowed"
		dc.b	$0
		dc.b	"illegal type combination"
		dc.b	$0
		dc.b	"invalid number"
		dc.b	$0
		dc.b	"number too large"
		dc.b	$0
		dc.b	"misuse of label"
		dc.b	$0
		dc.b	"include file read error"
		dc.b	$0
		dc.b	"file not found"
		dc.b	$0
		dc.b	"repeated include file"
		dc.b	$0
		dc.b	"data too large"
		dc.b	$0
		dc.b	"relative not allowed"
		dc.b	$0
		dc.b	"comma expected"
		dc.b	$0
		dc.b	".W or .L expected as index size"
		dc.b	$0
		dc.b	"absolute not allowed"
		dc.b	$0
		dc.b	"wrong processor"
		dc.b	$0
		dc.b	"odd address"
		dc.b	$0
		dc.b	"immediate data expected"
		dc.b	$0
		dc.b	"data register expected"
		dc.b	$0
		dc.b	"BSS or OFFSET section cannot contain data"
		dc.b	$0
		dc.b	"during writing binary file"
		dc.b	$0
		dc.b	"cannot create binary file"
		dc.b	$0
		dc.b	"symbol expected"
		dc.b	$0
		dc.b	"XREFs not allowed within brackets"
		dc.b	$0
		dc.b	"cannot import symbol"
		dc.b	$0
		dc.b	"cannot export symbol"
		dc.b	$0
		dc.b	"not yet implemented"
		dc.b	$0
		dc.b	"register expected"
		dc.b	$0
		dc.b	"invalid MOVEP addressing mode"
		dc.b	$0
		dc.b	"spurious ENDC"
		dc.b	$0
		dc.b	"missing ENDC"
		dc.b	$0
		dc.b	"invalid IF expression, ignored"
		dc.b	$0
		dc.b	"source expired prematurely"
		dc.b	$0
		dc.b	"spurious ENDM or MEXIT"
		dc.b	$0
		dc.b	"cannot nest MACRO definitions or define in REPTs"
		dc.b	$0
		dc.b	"missing quote"
		dc.b	$0
		dc.b	"user error"
		dc.b	$0
		dc.b	"invalid register list"
		dc.b	$0
		dc.b	"invalid option"
		dc.b	$0
		dc.b	"fatally bad conditional"
		dc.b	$0
		dc.b	"relocation not allowed"
		dc.b	$0
		dc.b	"division by zero"
		dc.b	$0
		dc.b	"absolute expression MUST evaluate"
		dc.b	$0
		dc.b	"illegal BSR.S"
		dc.b	$0
		dc.b	"option must be at start"
		dc.b	$0
		dc.b	"INTERNAL:invalid optimisation"
		dc.b	$0
		dc.b	"executable code only"
		dc.b	$0
		dc.b	"program buffer full"
		dc.b	$0
		dc.b	"linker format restriction"
		dc.b	$0
		dc.b	"ORG/RORG not allowed"
		dc.b	$0
		dc.b	"INTERNAL:invalid multi-line macro call"
		dc.b	$0
		dc.b	"cannot nest repeat loops"
		dc.b	$0
		dc.b	"spurious ENDR"
		dc.b	$0
		dc.b	"invalid numeric expansion"
		dc.b	$0
		dc.b	"during listing output"
		dc.b	$0
		dc.b	"invalid printer parameter"
		dc.b	$0
		dc.b	"invalid FORMAT parameter"
		dc.b	$0
		dc.b	"INTERNAL:bad section"
		dc.b	$0
		dc.b	"INTERNAL:macro memory"
		dc.b	$0
		dc.b	"invalid INCDIR"
		dc.b	$0
		dc.b	"assembly interrupted"
		dc.b	$0
		dc.b	"in command-line symbol"
		dc.b	$0
		dc.b	"# probably missing"
		dc.b	$0
		dc.b	"short branch cannot be 0 bytes"
		dc.b	$0
		dc.b	"DCB or DS count must not be negative"
		dc.b	$0,$70,$27,$60,$4c

L4f54:
		bsr.w	L78ae
		bne.s	l4f5c
		rts
	l4f5c:	bsr.w	L5e3c
		moveq	#38,d0
		bra.s	L4fa0

L4f64:
		moveq	#1,d0
		bra.s	L4fb6
	l4f68:	moveq	#5,d0
		bra.s	L4fb6
	l4f6c:	moveq	#4,d0
		bra.s	L4fb6
	l4f70:	moveq	#6,d0
		bra.s	L4fb6
	l4f74:	moveq	#7,d0
		bra.s	L4fb6
	l4f78:	moveq	#9,d0
		bra.s	L4fb6
	l4f7c:	moveq	#10,d0
		bra.s	L4fb6
	l4f80:	moveq	#12,d0
		bra.s	L4fb6
		dc.b	"p `.p"
		dc.b	$1c,$60,$2a

L4f8c:
		moveq	#37,d0
		bra.s	L4fb6
		dc.b	$70,$f,$60,$1e,$70,$1e,$60,$1a,$70,$1f,$60,$16,$70,$23,$60,$12

L4fa0:
		sf	23099(a6)
		move.b	#$14,466(a6)
		bsr.s	L4fb6
		bra.w	L1ac
	l4fb0:	rts

L4fb2:
		movea.l	460(a6),a7

L4fb6:
		tst.b	269(a6)
		bne.s	l4fb0
		st	269(a6)
		cmpi.b	#$a,466(a6)
		bcc.s	l4fce
		move.b	#$a,466(a6)
	l4fce:	movem.l	a0-3/d1-3,-(a7)
		move.w	d0,-(a7)
		moveq	#6,d0
		bsr.w	L5558
		lea	L480e(pc),a0
		addq.b	#1,268(a6)
		moveq	#0,d2

L4fe4:
		move.w	(a7)+,d0
		tst.l	326(a6)
		beq.s	l5020
		tst.l	410(a6)
		bne.s	l5020
		movea.l	326(a6),a1
		move.w	(a1)+,d3
		move.w	d3,d1
	l4ffa:	tst.w	(a1)+
		beq.s	l5004
		subq.w	#1,d1
		bne.s	l4ffa
		bra.s	l5020
	l5004:	cmp.w	d1,d3
		beq.s	l5014
		move.w	-6(a1),d3
		bmi.s	l5014
		cmp.w	470(a6),d3
		beq.s	l5020
	l5014:	move.w	470(a6),-2(a1)
		move.w	d0,(a1)
		or.w	d2,(a1)+
		clr.w	(a1)
	l5020:	subq.w	#1,d0
		bsr.w	L555e
		moveq	#9,d0
		bsr.w	L5558
		moveq	#0,d1
		move.w	470(a6),d1
		bsr.w	L55e2
		tst.l	410(a6)
		beq.s	l505c
		moveq	#11,d0
		bsr.w	L5558
		movea.l	410(a6),a1
		moveq	#0,d2
		move.b	22(a1),d2
		subq.b	#2,d2
		lea	23(a1),a1
	l5052:	move.b	(a1)+,d1
		bsr.w	L5576
		dbra	d2,l5052
	l505c:	bsr.w	L556a
		st	260(a6)
		movem.l	(a7)+,d1-3/a0-3
	l5068:	rts

L506a:
		tst.b	464(a6)
		beq.s	l5068
		tst.b	263(a6)
		beq.s	l5068
		cmpi.b	#$5,466(a6)
		bcc.s	l5084
		move.b	#$5,466(a6)
	l5084:	movem.l	a0-3/d1-3,-(a7)
		move.w	d0,-(a7)
		moveq	#8,d0
		bsr.w	L5558
		lea	L509c(pc),a0
		move.w	#$8000,d2
		bra.w	L4fe4

L509c:
		dc.b	"sign extended operand"
		dc.b	$0
		dc.b	"relative cannot be relocated"
		dc.b	$0
		dc.b	"invalid LINK displacement"
		dc.b	$0
		dc.b	"68010 instruction, converted to MOVE SR"
		dc.b	$0
		dc.b	"size should be .W"
		dc.b	$0
		dc.b	"directive ignored"
		dc.b	$0
		dc.b	"misuse of register list"
		dc.b	$0
		dc.b	"branch made short"
		dc.b	$0
		dc.b	"offset removed"
		dc.b	$0
		dc.b	"short word addressing used"
		dc.b	$0
		dc.b	"MOVEQ substituted"
		dc.b	$0
		dc.b	"quick form used"
		dc.b	$0
		dc.b	"branch could be short"
		dc.b	$0
		dc.b	"short branch converted to NOP"
		dc.b	$0,$0,$2,$2,$2,$4,$0,$ff,$0,$2,$2,$0,$2,$2,$4a,$2e
		dc.b	$1,$d0,$67,$28,$48,$a7,$c0,$0,$51,$40,$10,$3b,$0,$e6,$6b,$a
		dc.b	$48,$80,$d1,$6e,$1,$b4,$52,$6e,$1,$b2,$30,$17,$51,$40,$32,$2e
		dc.b	$1,$10,$1,$1,$4c,$9f,$0,$3,$66,$0,$fe,$52,$4e,$75
	l521c:	moveq	#65,d0
		bra.w	L4fa0

L5222:
		movea.l	358(a6),a2
		movem.l	a3-5,-(a7)
		bsr.w	L7da
		sne	d0
		movem.l	(a7)+,a3-5
		tst.b	464(a6)
		bne.w	L52c6
		tst.b	d0
		bne.s	l5254
		move.l	a0,-(a7)
		movea.l	8(a1),a0
		tst.w	12(a0)
		movea.l	(a7)+,a0
		bne.w	l537e
		bra.w	L52c6
	l5254:	moveq	#0,d4
		moveq	#11,d3
		moveq	#118,d0
		add.l	d0,d0
		bsr.w	L92a
		clr.l	152(a1)
		move.l	a1,-(a7)
		bsr.w	L7762
		movea.l	(a7)+,a1
		bne.w	l537a
		move.l	d4,152(a1)
		move.l	410(a6),16(a1)
		move.l	a1,410(a6)
		addq.l	#3,d1
		bclr	#$0,d1
		move.l	#$1200,d2
		bsr.w	L78e6
		move.l	a1,-(a7)
		move.l	d1,d3
		addi.l	#$e,d1
		bsr.w	L57a0
		movea.l	(a7),a1
		move.l	a0,8(a1)
		lea	14(a0),a1
		move.l	d3,4(a0)
		adda.l	d3,a1
		move.l	a1,8(a0)
		move.l	a1,(a0)
		move.w	470(a6),12(a0)
		clr.w	470(a6)
		movea.l	(a7)+,a1
		st	14(a1)
		bra.w	L5326

L52c6:
		tst.b	d0
		bne.w	l537e
		move.l	410(a6),16(a1)
		move.l	a1,410(a6)
		tst.b	14(a1)
		beq.s	l5302
		move.l	a1,-(a7)
		bsr.w	L7762
		movea.l	(a7)+,a1
		bne.w	l537a
		move.l	d4,152(a1)
		movea.l	8(a1),a0
		move.w	470(a6),12(a0)
		clr.w	470(a6)
		lea	14(a0),a2
		move.l	a2,(a0)
		bra.s	L5326
	l5302:	movea.l	8(a1),a0
		move.w	470(a6),12(a0)
		clr.w	470(a6)
		lea	14(a0),a2
		move.l	a2,(a0)
		moveq	#0,d0
		rts

L531a:
		move.l	a0,(a0)
		addi.l	#$e,(a0)
		movea.l	a2,a0
		bra.s	l5336

L5326:
		move.l	a0,(a0)
		addi.l	#$e,(a0)
		move.l	4(a0),d1
		lea	14(a0),a0
	l5336:	move.l	152(a1),d2
		movem.l	a0-1/d1,-(a7)
		bsr.w	L781c
		movem.l	(a7)+,d2/a0-1
		bne.s	l5376
		lea	0(a0,d1.l),a2
		cmp.l	d1,d2
		beq.s	l5366
		clr.b	(a2)
		cmpi.b	#$a,-1(a2)
		bne.s	l5362
		cmpi.b	#$d,-2(a2)
		beq.s	l5366
	l5362:	move.b	#$d,(a2)+
	l5366:	movea.l	8(a1),a0
		move.l	a2,8(a0)
		addq.b	#1,14(a1)
		moveq	#0,d0
		rts
	l5376:	moveq	#25,d0
		rts
	l537a:	moveq	#26,d0
		rts
	l537e:	moveq	#27,d0
		rts

L5382:
		moveq	#11,d3
		lea	L538a(pc),a2
		bra.s	L53a2

L538a:
		dc.b	$24,$28,$0,$98,$67,$10,$42,$a8,$0,$98,$48,$e7,$0,$a0,$61,$0
		dc.b	$24,$76,$4c,$df,$5,$0
	l53a0:	rts

L53a2:
		move.l	358(a6),d0
		beq.s	l53a0
		movea.l	d0,a0
		move.l	(a0),d0
		beq.s	l53a0
		movea.l	d0,a0

L53b0:
		tst.l	(a0)
		beq.s	l53bc
		move.l	a0,-(a7)
		movea.l	(a0),a0
		bsr.s	L53b0
		movea.l	(a7)+,a0
	l53bc:	tst.b	d3
		beq.s	l53c6
		cmp.b	13(a0),d3
		bne.s	l53c8
	l53c6:	jsr	(a2)
	l53c8:	tst.l	4(a0)
		beq.s	l53d8
		move.l	a0,-(a7)
		movea.l	4(a0),a0
		bsr.s	L53b0
		movea.l	(a7)+,a0
	l53d8:	rts

L53da:
		tst.l	16(a1)
		beq.s	l5402
		movea.l	16(a1),a1

L53e4:
		tst.l	(a1)
		beq.s	l53f0
		move.l	a1,-(a7)
		movea.l	(a1),a1
		bsr.s	L53e4
		movea.l	(a7)+,a1
	l53f0:	jsr	(a2)
		tst.l	4(a1)
		beq.s	l5402
		move.l	a1,-(a7)
		movea.l	4(a1),a1
		bsr.s	L53e4
		movea.l	(a7)+,a1
	l5402:	rts
		dc.b	$2f,$b,$26,$4a,$45,$fa,$0,$14,$61,$cc,$22,$6e,$1,$5e,$4a,$91
		dc.b	$67,$4,$22,$51,$61,$ca,$26,$5f,$4e,$75,$8,$29,$0,$5,$0,$c
		dc.b	$67,$2,$4e,$93,$4e,$75,$4a,$a9,$0,$10,$67,$22,$22,$69,$0,$10
		dc.b	$4a,$91,$67,$8,$2f,$9,$22,$51,$61,$f6,$22,$5f,$61,$12,$4a,$a9
		dc.b	$0,$4,$67,$a,$2f,$9,$22,$69,$0,$4,$61,$e4,$22,$5f,$4e,$75
		dc.b	$8,$29,$0,$4,$0,$c,$67,$2,$4e,$92,$4e,$75

L5460:
		tst.b	464(a6)
		bne.s	l547e
		move.l	#$196,d1
		bsr.w	L57a0
		move.l	a0,23086(a6)
		move.l	a0,23090(a6)
		clr.l	(a0)+
		clr.w	(a0)
		rts
	l547e:	movea.l	23090(a6),a0
		move.w	4(a0),d0
		lea	6(a0,d0.w),a0
		move.l	a0,23094(a6)
		movea.l	23086(a6),a0
		move.l	a0,23090(a6)
		moveq	#-1,d0
		tst.w	4(a0)
		beq.s	l54a6
		clr.w	4(a0)
		move.l	6(a0),d0
	l54a6:	move.l	d0,23082(a6)
		rts
		dc.b	$20,$d,$90,$ae,$1,$f8,$d0,$ae,$1,$d8,$4a,$2e,$1,$d0,$66,$44
		dc.b	$2f,$0
		dc.b	" nZ2X"
		dc.b	$88,$30,$18,$b0,$7c,$1,$90,$67,$10,$21,$9f,$0,$0,$21,$82,$0
		dc.b	$4,$50,$40,$31,$0,$70,$0,$4e,$75,$48,$e7,$60,$60,$22,$3c,$0
		dc.b	$0,$1,$96,$61,$0,$2,$b8
		dc.b	"""nZ2"""
		dc.b	$88
		dc.b	"-HZ2B"
		dc.b	$98,$42,$58,$70,$0,$4c,$df,$6,$6,$60,$cc,$b0,$ae
		dc.b	"Z*f2 nZ2X"
		dc.b	$88,$30,$18,$b4,$b0,$0,$4,$67,$a,$3f,$0,$70,$3f,$61,$0,$fa
		dc.b	$9c,$30,$1f,$50,$40,$b0,$7c,$1,$90,$67,$14,$31,$40,$ff,$fe,$d0
		dc.b	$c0,$b1,$ee,$5a,$36,$67,$1c
		dc.b	"-PZ*p"
		dc.b	$0
		dc.b	"Nu nZ2J"
		dc.b	$90,$67,$c
		dc.b	" P-HZ2\Hp"
		dc.b	$0,$60,$d8,$70,$ff
		dc.b	"-@Z*p"
		dc.b	$0,$4e,$75

L5558:
		lea	L5aa2(pc),a0
		tst.w	d0

L555e:
		beq.w	L5980
	l5562:	tst.b	(a0)+
		bne.s	l5562
		subq.w	#1,d0
		bra.s	L555e

L556a:
		moveq	#13,d1
		bra.w	L596c

L5570:
		bsr.w	L5574

L5574:
		moveq	#32,d1

L5576:
		movem.l	a0-2/d0-2,-(a7)
		bsr.w	L596c
		movem.l	(a7)+,d0-2/a0-2
		rts

L5584:
		move.w	d1,-(a7)
		swap	d1
		bsr.s	L558c
		move.w	(a7)+,d1

L558c:
		move.w	d1,-(a7)
		lsr.w	#8,d1
		bsr.s	L5594
		move.w	(a7)+,d1

L5594:
		move.w	d1,-(a7)
		lsr.w	#4,d1
		bsr.s	L559c
		move.w	(a7)+,d1

L559c:
		andi.w	#$f,d1
		move.b	L55a6(pc,d1.w),d1
		bra.s	L5576

L55a6:
		dc.b	"0123456789ABCDEF"

L55b6:
		moveq	#6,d3
		moveq	#0,d2
	l55ba:	rol.l	#4,d1
		move.l	d1,-(a7)
		andi.w	#$f,d1
		bne.s	l55c8
		tst.b	d2
		beq.s	l55d0
	l55c8:	st	d2
		move.b	L55a6(pc,d1.w),d1
		jsr	(a2)
	l55d0:	move.l	(a7)+,d1
		dbra	d3,l55ba
		rol.l	#4,d1
		andi.w	#$f,d1
		move.b	L55a6(pc,d1.w),d1
		jmp	(a2)

L55e2:
		lea	L5576(pc),a2

L55e6:
		lea	L561a(pc),a0
		moveq	#1,d2
		moveq	#8,d0
	l55ee:	moveq	#0,d3
		cmp.l	(a0)+,d1
		bcs.s	l5600
		sub.l	-(a0),d1
	l55f6:	addq.b	#1,d3
		sub.l	(a0),d1
		bcc.s	l55f6
		add.l	(a0)+,d1
		bra.s	l5604
	l5600:	tst.b	d2
		bpl.s	l5610
	l5604:	st	d2
		addi.b	#$30,d3
		exg	d3,d1
		jsr	(a2)
		exg	d3,d1
	l5610:	dbra	d0,l55ee
		addi.b	#$30,d1
		jmp	(a2)

L561a:
		dc.b	$3b,$9a,$ca,$0,$5,$f5,$e1,$0,$0,$98,$96,$80,$0,$f,$42,$40
		dc.b	$0,$1,$86,$a0,$0,$0,$27,$10,$0,$0,$3,$e8,$0,$0,$0,$64
		dc.b	$0,$0,$0,$a

L563e:
		moveq	#20,d0
		bsr.w	L5558
		movea.l	350(a6),a2
		lea	L566e(pc),a4
		bsr.w	L56b0
		moveq	#9,d3
		lea	L5676(pc),a2
		lea	L565e(pc),a4
		bra.w	L53a2

L565e:
		dc.b	$c,$2b,$0,$2,$0,$d,$67,$8,$10,$2b,$0,$e,$60,$0,$6,$f8

L566e:
		dc.b	$61,$0,$ff,$4,$60,$0,$fe,$fc

L5676:
		dc.b	$48,$e7,$10,$a0,$2f,$8,$70,$15,$61,$0,$fe,$d8,$4a,$2e,$0,$ff
		dc.b	$67,$12,$20,$57,$41,$e8,$0,$16,$14,$18,$12,$18,$61,$0,$fe,$e2
		dc.b	$53,$2,$6e,$f6,$61,$0,$fe,$ce,$61,$0,$fe,$ca,$20,$5f,$45,$e8
		dc.b	$0,$10,$61,$6,$4c,$df,$5,$8,$4e,$75

L56b0:
		move.l	a2,d0
		beq.s	l5724
		move.l	(a2),d0
		beq.s	l5724
		movea.l	d0,a2
		suba.l	a3,a3
		lea	1350(a6),a0
		moveq	#127,d0
		move.b	d0,(a0)+
	l56c4:	st	(a0)+
		dbra	d0,l56c4
	l56ca:	lea	1328(a6),a3
		move.b	23(a3),d3
		bsr.s	L5726
		lea	1328(a6),a0
		cmpa.l	a3,a0
		beq.s	l5724
		bset	#$0,12(a3)
		btst	#$4,12(a3)
		bne.s	l56ca
		move.l	8(a3),d1
		bsr.w	L5584
		bsr.w	L5570
		jsr	(a4)
		moveq	#0,d1
		move.b	13(a3),d1
		lea	L798(pc),a0
		move.b	0(a0,d1.w),d1
		bsr.w	L5576
		bsr.w	L5570
		lea	22(a3),a0
		move.b	(a0)+,d4
	l5714:	move.b	(a0)+,d1
		bsr.w	L5576
		subq.b	#1,d4
		bne.s	l5714
		bsr.w	L556a
		bra.s	l56ca
	l5724:	rts

L5726:
		tst.l	(a2)
		beq.s	l5732
		move.l	a2,-(a7)
		movea.l	(a2),a2
		bsr.s	L5726
		movea.l	(a7)+,a2
	l5732:	btst	#$0,12(a2)
		bne.s	l5760
		cmp.b	23(a2),d3
		bcs.s	l5760
		lea	22(a3),a0
		lea	22(a2),a1
		move.b	(a0)+,d0
		move.b	(a1)+,d1
	l574c:	cmpm.b	(a1)+,(a0)+
		bcs.s	l5760
		bne.s	l575a
		subq.b	#1,d0
		beq.s	l5760
		subq.b	#1,d1
		bne.s	l574c
	l575a:	movea.l	a2,a3
		move.b	23(a3),d3
	l5760:	tst.l	4(a2)
		beq.s	l5770
		move.l	a2,-(a7)
		movea.l	4(a2),a2
		bsr.s	L5726
		movea.l	(a7)+,a2
	l5770:	rts
		dc.b	$61,$0,$1f,$b8,$67,$46,$2d,$48,$1,$2c,$4e,$75

L577e:
		dc.b	$20,$2e,$1,$2c,$67,$f8,$42,$ae,$1,$2c,$20,$40,$60,$0,$1f,$c6

L578e:
		move.l	#$2800,d1
		move.w	d1,318(a6)
		bsr.s	L57a0
		move.l	a0,304(a6)
		rts

L57a0:
		lea	296(a6),a0
		bra.s	l57a8
	l57a6:	movea.l	d0,a0
	l57a8:	move.l	(a0),d0
		bne.s	l57a6
		addq.l	#4,d1
		move.l	a0,-(a7)
		bsr.w	L772c
		movea.l	(a7)+,a1
		beq.s	l57be
		move.l	a0,(a1)
		clr.l	(a0)+
		rts
	l57be:	moveq	#2,d0
		bra.w	L4fa0

L57c4:
		pea	L577e(pc)
		move.l	296(a6),d0
		movea.l	d0,a3
		bne.s	L57d2
		rts

L57d2:
		tst.l	(a3)
		beq.s	l57de
		move.l	a3,-(a7)
		movea.l	(a3),a3
		bsr.s	L57d2
		movea.l	(a7)+,a3
	l57de:	movea.l	a3,a0
		bra.w	L7752

L57e4:
		sf	23098(a6)
		sf	23099(a6)
		clr.l	23100(a6)
		lea	23104(a6),a0
		lea	23616(a6),a1
		move.l	a0,(a1)
		move.l	a1,23620(a6)
		move.w	#$84,23624(a6)
		move.w	#$3c,23626(a6)
		clr.w	23628(a6)
		move.w	#$ffff,23630(a6)
		clr.w	23632(a6)
		clr.b	23656(a6)
		clr.b	23737(a6)
		st	23818(a6)
		move.w	#$8,23634(a6)
		lea	23636(a6),a3
		bsr.w	L7682
		clr.b	(a3)
		rts

L5836:
		tst.l	23100(a6)
		beq.s	l5846
		bsr.w	L751e
		bsr.w	L587c
		bsr.s	L5848
	l5846:	rts

L5848:
		tst.l	23100(a6)
		beq.s	l5846
		move.l	23100(a6),d3
		clr.l	23100(a6)
		bra.w	L710a

L585a:
		movea.l	23616(a6),a0
		cmpa.l	23620(a6),a0
		beq.s	l586c
		move.b	d1,(a0)+
		move.l	a0,23616(a6)
		rts
	l586c:	move.w	d1,-(a7)
		bsr.s	L587c
		bne.s	l5876
		move.w	(a7)+,d1
		bra.s	L585a
	l5876:	moveq	#72,d0
		bra.w	L4fa0

L587c:
		move.l	d3,-(a7)
		move.l	23100(a6),d3
		lea	23104(a6),a0
		move.l	23616(a6),d1
		sub.l	a0,d1
		beq.s	l589a
		lea	23104(a6),a1
		move.l	a1,23616(a6)
		bsr.w	L70f2
	l589a:	movem.l	(a7)+,d3
		rts

L58a0:
		btst	#$0,23818(a6)
		bne.s	l58aa
		rts
	l58aa:	addq.w	#1,23632(a6)
		moveq	#16,d0
		bsr.w	L5558
		lea	23636(a6),a0
		bsr.w	L5980
		moveq	#15,d0
		bsr.w	L5558
		moveq	#0,d1
		move.w	23632(a6),d1
		move.l	d3,-(a7)
		bsr.w	L55e2
		move.l	(a7)+,d3
		bsr.w	L556a
		lea	23656(a6),a0
		tst.b	(a0)
		beq.s	l58e2
		bsr.w	L5980
		bra.s	l5902
	l58e2:	tst.l	410(a6)
		beq.s	l5902
		movea.l	410(a6),a1
		moveq	#0,d2
		move.b	22(a1),d2
		subq.b	#2,d2
		lea	23(a1),a1
	l58f8:	move.b	(a1)+,d1
		bsr.w	L5576
		dbra	d2,l58f8
	l5902:	bsr.w	L556a
		lea	23737(a6),a0
		bsr.w	L5980
		bsr.w	L556a
		bra.w	L556a
	l5916:	tst.w	23630(a6)
		bpl.s	l5928
		clr.w	23630(a6)
		move.w	d1,-(a7)
		bsr.w	L58a0
		move.w	(a7)+,d1
	l5928:	cmp.b	#$d,d1
		bne.s	l5950

L592e:
		clr.w	23628(a6)
		move.w	23630(a6),d0
		addq.w	#1,23630(a6)
		cmp.w	23626(a6),d0
		beq.w	L751e
		moveq	#13,d1
		bsr.w	L585a
		moveq	#10,d1
		bsr.w	L585a
		rts
	l5950:	move.w	23628(a6),d0
		cmp.w	23624(a6),d0
		blt.s	l5962
		move.w	d1,-(a7)
		bsr.s	L592e
		move.w	(a7)+,d1
		bra.s	l5916
	l5962:	bsr.w	L585a
		addq.w	#1,23628(a6)
		rts

L596c:
		tst.b	23099(a6)
		bne.s	l5916
		cmp.b	#$d,d1
		bne.s	L597c
		bsr.s	L597c
		moveq	#10,d1

L597c:
		bra.w	L70e2

L5980:
		move.b	(a0)+,d1
		beq.s	l598c
		move.l	a0,-(a7)
		bsr.s	L596c
		movea.l	(a7)+,a0
		bra.s	L5980
	l598c:	rts

L598e:
		movem.l	a3/d7,-(a7)
		move.b	23818(a6),d7
		add.b	d7,d7
		bcc.s	l59d2
		move.w	470(a6),d2
		cmp.w	#$2710,d2
		bcc.s	l59c6
		bsr.w	L5574
		cmp.w	#$3e8,d2
		bcc.s	l59c6
		bsr.w	L5574
		cmp.w	#$64,d2
		bcc.s	l59c6
		bsr.w	L5574
		cmp.w	#$a,d2
		bcc.s	l59c6
		bsr.w	L5574
	l59c6:	moveq	#0,d1
		move.w	d2,d1
		bsr.w	L55e2
		bsr.w	L5574
	l59d2:	move.l	414(a6),d4
		add.b	d7,d7
		bcc.s	l5a1e
		move.b	316(a6),d0
		move.b	18285(a6),d1
		beq.s	l5a08
		cmp.b	#$ff,d1
		beq.s	l5a02
		bsr.w	L5570
		move.b	18285(a6),d1
		bsr.w	L596c
	l59f6:	move.l	18286(a6),d1
		bsr.w	L5584
		moveq	#0,d4
		bra.s	l5a1e
	l5a02:	bsr.w	L5d5e
		bra.s	l59f6
	l5a08:	bsr.w	L5d5e
		move.l	414(a6),d4
		movea.l	508(a6),a3
		move.l	476(a6),d1
		sub.l	d4,d1
		bsr.w	L5584
	l5a1e:	moveq	#32,d1
		tst.b	259(a6)
		beq.s	l5a2e
		tst.b	280(a6)
		bne.s	l5a2e
		moveq	#43,d1
	l5a2e:	bsr.w	L596c
		add.b	d7,d7
		bcc.s	l5a5c
		moveq	#5,d3
		cmpi.w	#$51,23624(a6)
		bcs.s	l5a42
		moveq	#9,d3
	l5a42:	tst.l	d4
	l5a44:	beq.s	l5a54
		move.b	(a3)+,d1
		bsr.w	L5594
		subq.l	#1,d4
		dbra	d3,l5a44
		bra.s	l5a5c
	l5a54:	bsr.w	L5570
		dbra	d3,l5a54
	l5a5c:	bsr.w	L5574
		movea.l	492(a6),a3
		moveq	#0,d2
	l5a66:	move.b	(a3)+,d1
		cmp.b	#$d,d1
		beq.s	l5a98
		cmp.b	#$9,d1
		bne.s	l5a90
		moveq	#0,d0
		move.w	d2,d0
		divu	23634(a6),d0
		swap	d0
		sub.w	23634(a6),d0
		neg.w	d0
	l5a84:	bsr.w	L5574
		addq.w	#1,d2
		subq.w	#1,d0
		bne.s	l5a84
		bra.s	l5a66
	l5a90:	addq.w	#1,d2
		bsr.w	L5576
		bra.s	l5a66
	l5a98:	bsr.w	L596c
		movem.l	(a7)+,d7/a3
		rts

L5aa2:
		dc.b	"GenST Macro Assembler Copyright "
		dc.b	$bd
		dc.b	" HiSoft 1985-91"
		dc.b	$d
		dc.b	"All Rights Reserved - version 2.25"
		dc.b	$d,$d,$0
		dc.b	"Pass 1"
		dc.b	$d,$0
		dc.b	"Pass 2"
		dc.b	$d,$0
		dc.b	" errors found"
		dc.b	$d,$0
		dc.b	" error found"
		dc.b	$d,$0
		dc.b	" lines assembled into "
		dc.b	$0
		dc.b	"Error "
		dc.b	$0
		dc.b	"Locals:"
		dc.b	$d,$0
		dc.b	"Warning "
		dc.b	$0
		dc.b	" at line "
		dc.b	$0
		dc.b	"Could not open file "
		dc.b	$0
		dc.b	" in file "
		dc.b	$0
		dc.b	" bytes, "
		dc.b	$0
		dc.b	" optimisations saving "
		dc.b	$0
		dc.b	" bytes"
		dc.b	$d,$0
		dc.b	"  Page "
		dc.b	$0
		dc.b	"HiSoft GenST 680x0 Macro Assembler v2.25   "
		dc.b	$0
		dc.b	" relocatable"
		dc.b	$0
		dc.b	" position-independent"
		dc.b	$0
		dc.b	" code"
		dc.b	$d,$0,$d,$9
		dc.b	"GLOBAL SYMBOLS"
		dc.b	$d,$d,$0,$d,$9
		dc.b	"MODULE "
		dc.b	$0
		dc.b	" absolute"
		dc.b	$0,$0

L5c2c:
		pea	L5980(pc)
		tst.b	255(a6)
		beq.w	l6596
		tst.w	452(a6)
		beq.w	l6a60
		bra.w	L6dae

L5c44:
		tst.b	255(a6)
		beq.w	l659c
		tst.w	452(a6)
		beq.w	l6a66
		bra.w	L6dbe
		dc.b	$4a,$2e,$0,$ff,$67,$0,$9,$54,$4a,$6e,$1,$c4,$67,$0,$9,$4c
		dc.b	$60,$0,$9,$48

L5c6c:
		tst.b	255(a6)
		beq.w	l5f8c
		tst.w	452(a6)
		beq.w	l65ba
		bra.w	L6a7e
	l5c80:	moveq	#64,d0
		bra.w	L4fa0

L5c86:
		tst.b	261(a6)
		beq.s	l5ca4
		movea.l	308(a6),a1
		tst.b	255(a6)
		beq.w	l5f5a
		tst.w	452(a6)
		beq.w	l65e8
		bra.w	L6b14
	l5ca4:	rts
	l5ca6:	tst.b	261(a6)
		beq.s	l5ca4
		movea.l	308(a6),a1
		tst.b	255(a6)
		beq.w	l5f5a
		tst.w	452(a6)
		beq.w	l66f0
		bra.w	L6b14
		dc.b	$4a,$2e,$1,$5,$67,$c,$4a,$6e,$1,$c4,$67,$0,$9,$a6,$60,$0
		dc.b	$e,$40
	l5cd6:	rts
		dc.b	$4a,$2e,$1,$5,$67,$f8,$4a,$2e,$0,$ff,$67,$0,$2,$78,$4a,$6e
		dc.b	$1,$c4,$67,$0,$a,$e6,$60,$0,$e,$2a

L5cf2:
		tst.b	255(a6)
		beq.w	l5f5a
		tst.w	452(a6)
		beq.w	l676e
		bra.w	L6b14

L5d06:
		tst.b	283(a6)
		bne.s	l5d26
		tst.b	261(a6)
		beq.s	l5cd6
		tst.b	255(a6)
		beq.w	l60f4
		tst.w	452(a6)
		beq.w	l686a
		bra.w	L6b0e
	l5d26:	moveq	#37,d0
		bra.w	L4fb6

L5d2c:
		cmpi.b	#$ff,283(a6)
		beq.s	l5d48
		tst.b	255(a6)
		beq.w	L605e
		tst.w	452(a6)
		beq.w	l67ce
		bra.w	L605e
	l5d48:	rts
		dc.b	$4a,$2e,$0,$ff,$67,$0,$3,$16,$4a,$6e,$1,$c4,$67,$0,$a,$d6
		dc.b	$60,$0,$d,$a6

L5d5e:
		tst.b	283(a6)
		bne.s	l5d78
		tst.b	255(a6)
		beq.w	L657e
		tst.w	452(a6)
		beq.w	l6a54
		bra.w	L657e
	l5d78:	moveq	#79,d1
		bsr.w	L596c
		bra.w	L5570
	l5d82:	moveq	#39,d0
		jmp	L4fa0

L5d8a:
		tst.l	442(a6)
		bne.w	l521c
		tst.l	418(a6)
		bne.s	l5dae
		movem.l	a0-2/d1-2,-(a7)
		lea	1616(a6),a0
		bsr.w	L7864
		bne.s	l5d82
		move.l	d2,418(a6)
		movem.l	(a7)+,d1-2/a0-2
	l5dae:	rts

L5db0:
		move.l	476(a6),d2
		moveq	#1,d1
		clr.b	(a5)+
		add.l	d1,476(a6)
		add.l	d1,472(a6)
		tst.b	464(a6)
		beq.s	l5dd6
		tst.b	261(a6)
		beq.s	l5dd6
		bsr.w	L5d2c
		beq.s	l5dd6
		bsr.w	L5d06
	l5dd6:	movea.l	504(a6),a5
		move.l	a5,508(a6)
		rts

L5de0:
		lea	L5e06(pc),a0
		move.l	a0,406(a6)
		move.l	504(a6),d1
		tst.b	283(a6)
		bne.s	l5e0a
		tst.b	255(a6)
		beq.w	L61ee
		tst.w	452(a6)
		beq.w	l676c
		bra.w	L61ee

L5e06:
		dc.b	$42,$ae,$1,$9e
	l5e0a:	rts

L5e0c:
		tst.b	255(a6)
		beq.w	L6216
		tst.w	452(a6)
		beq.w	l674c
		bra.w	L6216

L5e20:
		tst.b	261(a6)
		beq.s	l5e3a
		tst.b	255(a6)
		beq.w	l623a
		tst.w	452(a6)
		beq.w	l6946
		bra.w	L6c04
	l5e3a:	rts

L5e3c:
		move.l	418(a6),d2
		beq.s	l5e4a
		bsr.w	L7810
		clr.l	418(a6)
	l5e4a:	rts

L5e4c:
		move.l	d2,-(a7)
	l5e4e:	move.l	#$62fc,d0
		sub.l	d0,d1
		bcc.s	l5e5c
		add.l	d1,d0
		moveq	#0,d1
	l5e5c:	movea.l	a6,a0
		move.l	d1,-(a7)
		move.l	d0,d1
		bsr.w	L4f54
		move.l	(a7)+,d1
		bne.s	l5e4e
		move.l	(a7)+,d2
		rts
		dc.b	$4a,$6e,$1,$c4,$67,$0,$a,$f0,$60,$0,$c,$ca,$4a,$6e,$1,$c4
		dc.b	$67,$0,$a,$ea,$60,$0,$d,$2c,$4a,$2e,$1,$12,$67,$6,$4a,$6e
		dc.b	$1,$c4,$66,$16,$b6,$3c,$0,$1,$66,$4,$50,$ee,$1,$14,$4a,$6e
		dc.b	$1,$c4,$67,$0,$a,$a6,$60,$0,$c,$d6,$4e,$75,$4a,$6e,$1,$c4
		dc.b	$67,$0,$a,$b0,$60,$0,$c,$ec,$4a,$6e,$1,$c4,$67,$0,$a,$a0
		dc.b	$60,$0,$c,$e0,$4a,$6e,$1,$c4,$67,$0,$a,$90,$60,$0,$c,$76
		dc.b	$4a,$6e,$1,$c4,$67,$0,$a,$80,$60,$0,$c,$6a,$4a,$2e,$1,$8
		dc.b	$67,$6,$70,$3a,$60,$0,$f0,$d2,$4a,$2e,$1,$12,$66,$2e,$48,$e7
		dc.b	$60,$0,$50,$ee,$1,$14,$20,$d,$90,$ae,$1,$f8,$d0,$ae,$1,$dc
		dc.b	$48,$7a,$0,$16,$4a,$2e,$0,$ff,$67,$0,$5,$cc,$4a,$6e,$1,$c4
		dc.b	$67,$0,$8,$72,$60,$0,$b,$ca,$4c,$df,$0,$6,$4e,$75,$70,$0
		dc.b	$10,$2e,$1,$3c,$22,$2,$92,$ae,$1,$dc,$4a,$2e,$0,$ff,$67,$0
		dc.b	$6,$20,$4a,$6e,$1,$c4,$67,$0,$8,$cc,$60,$0,$b,$dc,$70,$0
		dc.b	$10,$2e,$1,$3c,$22,$2e,$1,$dc,$4a,$2e,$0,$ff,$67,$0,$ce,$8
		dc.b	$4a,$6e,$1,$c4,$67,$0,$8,$9a,$60,$0,$cd,$fc
	l5f5a:	rts
		dc.b	$41,$fa,$0,$28,$b3,$8,$66,$20,$b3,$8,$66,$1c,$b3,$8,$66,$18
		dc.b	$b3,$8,$66,$14,$b3,$8,$66,$10,$2f,$c,$28,$49,$12,$1c,$61,$0
		dc.b	$b1,$f0
		dc.b	"-B]<(_NuHEAD="
		dc.b	$0
	l5f8c:	tst.l	442(a6)
		bne.s	l6000
		move.l	#$104,d1
		add.l	370(a6),d1
		move.l	#$1200,d2
		bsr.w	L78e6
		move.l	d1,23824(a6)
		move.l	d1,23828(a6)
		bsr.w	L57a0
		move.l	a0,23820(a6)
		move.l	a0,23832(a6)
		move.l	a0,504(a6)
		move.l	#$82,d1
		add.l	382(a6),d1
		move.l	#$1200,d2
		bsr.w	L78e6
		move.l	d1,23844(a6)
		move.l	d1,23848(a6)
		bsr.w	L57a0
		move.l	a0,23840(a6)
		move.l	a0,23852(a6)
		moveq	#0,d0
		move.l	d0,23860(a6)
		moveq	#28,d0
		move.l	d0,23836(a6)
		add.l	370(a6),d0
		move.l	d0,23856(a6)
		clr.l	23868(a6)
		rts
	l6000:	moveq	#28,d1
		add.l	442(a6),d1
		move.l	d1,23820(a6)
		move.l	d1,23832(a6)
		move.l	d1,504(a6)
		move.l	370(a6),d2
		move.l	d1,23824(a6)
		move.l	d1,23828(a6)
		add.l	d2,d1
		move.l	382(a6),23844(a6)
		move.l	382(a6),23848(a6)
		move.l	d1,23840(a6)
		move.l	d1,23852(a6)
		moveq	#28,d1
		add.l	370(a6),d1
		add.l	382(a6),d1
		cmp.l	446(a6),d1
		bcc.w	l521c
		movea.l	442(a6),a1
		clr.w	(a1)+
		move.l	370(a6),(a1)+
		move.l	382(a6),(a1)+
		move.l	394(a6),(a1)+
		clr.l	(a1)+
		clr.b	(a1)+
		rts

L605e:
		cmpi.b	#$18,316(a6)
		rts
		dc.b	$10,$2e,$1,$3c,$67,$3c,$b0,$3c,$0,$c,$66,$0,$ef,$1a,$20,$2
		dc.b	$d0,$81,$b0,$ae
		dc.b	"](o4H"
		dc.b	$e7,$60,$80,$61,$0,$fd,$6,$43,$ee
		dc.b	"] "".]0a"
		dc.b	$0,$0,$ea,$4c,$df,$1,$6,$d0,$81,$b0,$ae,$5d,$34,$6f,$4,$2d
		dc.b	$40,$5d,$34,$d3,$ae
		dc.b	"]0`> "
		dc.b	$2,$d0,$81,$b0,$ae,$5d,$14,$6e,$c,$d3,$ae,$1,$f8,$1a,$d8,$53
		dc.b	$81,$66,$fa,$4e,$75,$48,$e7,$60,$80,$61,$0,$fc,$c6,$43,$ee,$5d
		dc.b	$c,$22,$2e,$5d,$1c,$61,$0,$0,$aa,$4c,$df,$1,$6,$d0,$81,$b0
		dc.b	$ae,$5d,$34,$6f,$4,$2d,$40,$5d,$34,$d3,$ae,$5d,$1c,$8,$0,$0
		dc.b	$0,$67,$4,$52,$ae,$1,$f8,$60,$0,$ee,$62
	l60f4:	moveq	#0,d0
		move.b	316(a6),d0
		beq.s	l6106
		cmp.b	#$c,d0
		beq.s	l6134
		bra.w	L4f8c
	l6106:	move.l	d2,d0
		addi.l	#$100,d0
		cmp.l	23828(a6),d0
		bcc.s	l611a
	l6114:	add.l	d1,504(a6)
		rts
	l611a:	tst.l	442(a6)
		bne.s	l6114
		bsr.w	L5d8a
		lea	23820(a6),a1
		move.l	23836(a6),d1
		bsr.s	L6162
		add.l	d1,23828(a6)
		rts
	l6134:	move.l	d2,d0
		addi.l	#$100,d0
		cmp.l	23848(a6),d0
		bcc.s	l6148
	l6142:	add.l	d1,504(a6)
		rts
	l6148:	tst.l	442(a6)
		bne.s	l6142
		bsr.w	L5d8a
		lea	23840(a6),a1
		move.l	23856(a6),d1
		bsr.s	L6162
		add.l	d1,23848(a6)
		rts

L6162:
		move.l	a5,d0
		andi.b	#$1,d0
		beq.s	L617a
		move.b	-(a5),-(a7)
		bsr.s	L617a
		movea.l	504(a6),a0
		move.b	(a7)+,(a0)+
		move.l	a0,504(a6)
		rts

L617a:
		tst.l	442(a6)
		bne.w	l521c
		move.l	a1,-(a7)
		cmp.l	23860(a6),d1
		ble.s	l619a
		move.l	d1,-(a7)
		sub.l	23860(a6),d1
		add.l	d1,23860(a6)
		bsr.w	L5e4c
		move.l	(a7)+,d1
	l619a:	movea.l	(a7),a1
		move.l	d1,16(a1)
		move.l	d1,d2
		bsr.w	L78d2
		movea.l	(a7)+,a1
		movea.l	(a1),a0
		move.l	a5,d1
		move.l	a0,504(a6)
		sub.l	a0,d1
		add.l	d1,16(a1)
		move.l	16(a1),-(a7)
		move.l	d1,-(a7)
		bsr.w	L4f54
		move.l	(a7)+,d1
		move.l	(a7)+,d0
		cmp.l	23860(a6),d0
		ble.s	l61ce
		move.l	d0,23860(a6)
	l61ce:	rts
	l61d0:	lea	366(a6),a0
		moveq	#0,d0
		move.b	316(a6),d0
		move.l	472(a6),d2
		sub.l	23872(a6),d2
		add.l	d2,4(a0,d0.w)
		move.l	476(a6),12(a0,d0.w)
		rts

L61ee:
		tst.b	464(a6)
		beq.s	l61d0
		move.b	316(a6),d0
		beq.s	l6202
		cmp.b	#$c,d0
		beq.s	l6208
		rts
	l6202:	move.l	d1,23832(a6)
		rts
	l6208:	move.l	d1,23852(a6)
		rts
	l620e:	move.l	472(a6),23872(a6)
		rts

L6216:
		tst.b	464(a6)
		beq.s	l620e
		move.b	316(a6),d0
		beq.s	l622a
		cmp.b	#$c,d0
		beq.s	l6232
		rts
	l622a:	move.l	23832(a6),504(a6)
		rts
	l6232:	move.l	23852(a6),504(a6)
		rts
	l623a:	tst.l	442(a6)
		bne.w	l6466
		bsr.w	L5d8a
		lea	23820(a6),a1
		move.l	23836(a6),d1
		movea.l	23832(a6),a5
		bsr.w	L617a
		lea	23840(a6),a1
		move.l	23856(a6),d1
		movea.l	23852(a6),a5
		bsr.w	L617a
		btst	#$0,23863(a6)
		beq.s	l627a
		moveq	#1,d1
		lea	1328(a6),a0
		clr.b	(a0)
		bsr.w	L4f54
	l627a:	clr.l	23864(a6)
		tst.b	262(a6)
		beq.w	L6374
		movea.l	23820(a6),a4
		move.l	23824(a6),d4
		lea	L62a2(pc),a2
		movea.l	308(a6),a1
		bsr.w	L53da
		bsr.w	L633a
		bra.w	L6374

L62a2:
		dc.b	$10,$29,$0,$d,$b0,$3c,$0,$1,$66,$0,$0,$8c,$32,$3c,$a2,$0
		dc.b	$10,$29,$0,$e,$67,$e,$32,$3c,$a1,$0,$b0,$3c,$0,$18,$67,$4
		dc.b	$32,$3c,$a4,$0,$10,$29,$0,$16,$41,$e9,$0,$17,$4a,$2e,$1,$6
		dc.b	$6a,$40,$b0,$3c,$0,$9,$65,$3a,$74,$1c,$b8,$82,$6c,$2,$61,$58
		dc.b	$98,$82,$74,$7,$18,$d8,$51,$ca,$ff,$fc,$12,$3c,$0,$48,$38,$c1
		dc.b	$28,$e9,$0,$8,$4,$0,$0,$9,$48,$80,$49,$ec,$0,$e,$2f,$c
		dc.b	$42,$a4,$42,$a4,$42,$a4,$42,$64,$18,$d8,$51,$c8,$ff,$fc
		dc.b	"(_Nut"
		dc.b	$e,$b8,$82,$6c,$2,$61,$1e,$98,$82,$74,$7,$18,$d8,$53,$0,$57
		dc.b	$ca,$ff,$fa,$53,$42,$6b,$6,$42,$1c,$51,$ca,$ff,$fc,$38,$c1,$28
		dc.b	$e9,$0,$8,$4e,$75

L633a:
		tst.l	442(a6)
		bne.w	l521c
		movem.l	a0-3/d0-3,-(a7)
		move.l	23824(a6),d1
		sub.l	d4,d1
		beq.s	l635c
		add.l	d1,23864(a6)
		movea.l	23820(a6),a0
		movea.l	a0,a4
		bsr.w	L4f54
	l635c:	movem.l	(a7)+,d0-3/a0-3
		move.l	23824(a6),d4
		rts
		dc.b	$26,$6e,$5d,$c,$28,$2e,$5d,$10,$42,$9b,$60,$0,$0,$c2

L6374:
		movea.l	23820(a6),a3
		move.l	23824(a6),d4
		bsr.s	L6382
		bra.w	L6434

L6382:
		move.l	374(a6),d0
		or.l	386(a6),d0
		bne.s	l6390
		clr.l	(a3)+
		rts
	l6390:	moveq	#0,d3
		sf	d6
		lea	374(a6),a1
		tst.l	(a1)
		bne.s	l63a6
		lea	386(a6),a1
		st	d6
		move.l	370(a6),d3
	l63a6:	movea.l	(a1),a1
		lea	10(a1),a0
		moveq	#50,d2
		sub.w	8(a1),d2
		move.l	(a0)+,d0
		add.l	d3,d0
		move.l	d0,(a3)+
		subq.l	#4,d4
	l63ba:	subq.w	#1,d2
		beq.s	l63e2
	l63be:	move.l	(a0)+,d1
		add.l	d3,d1
		move.l	d1,d5
		sub.l	d0,d1
	l63c6:	cmp.l	#$fe,d1
		ble.s	l63dc
		move.l	d1,-(a7)
		moveq	#1,d1
		bsr.s	L6408
		moveq	#-127,d1
		add.l	d1,d1
		add.l	(a7)+,d1
		bra.s	l63c6
	l63dc:	bsr.s	L6408
		move.l	d5,d0
		bra.s	l63ba
	l63e2:	tst.l	(a1)
		beq.s	l63f4
		movea.l	(a1),a1
		lea	10(a1),a0
		moveq	#50,d2
		sub.w	8(a1),d2
		bra.s	l63be
	l63f4:	tst.b	d6
		bne.s	l6406
		st	d6
		lea	386(a6),a1
		move.l	370(a6),d3
		tst.l	(a1)
		bne.s	l63e2
	l6406:	moveq	#0,d1

L6408:
		move.b	d1,(a3)+
		subq.l	#1,d4
		beq.s	L6410
		rts

L6410:
		tst.l	442(a6)
		bne.w	l521c
		movem.l	a0-2/d0-2,-(a7)
		movea.l	23820(a6),a0
		move.l	a3,d1
		sub.l	a0,d1
		movea.l	a0,a3
		bsr.w	L4f54
		move.l	23824(a6),d4
		movem.l	(a7)+,d0-2/a0-2
		rts

L6434:
		bsr.s	L6410
		moveq	#0,d2
		bsr.w	L78d2
		lea	1328(a6),a0
		move.w	#$601a,(a0)+
		move.l	370(a6),(a0)+
		move.l	382(a6),(a0)+
		move.l	394(a6),(a0)+
		move.l	23864(a6),(a0)+
		clr.l	(a0)+
		move.l	23868(a6),(a0)+
		clr.w	(a0)+
		lea	1328(a6),a0
		moveq	#28,d1
		bra.w	L4f54
	l6466:	moveq	#0,d2
		move.l	446(a6),d4
		sub.l	370(a6),d4
		sub.l	382(a6),d4
		subi.l	#$1e,d4
		tst.b	262(a6)
		beq.s	l64b4
		movea.l	442(a6),a4
		lea	28(a4),a4
		adda.l	370(a6),a4
		adda.l	382(a6),a4
		move.l	d4,-(a7)
		lea	L62a2(pc),a2
		movea.l	308(a6),a1
		bsr.w	L53da
		move.l	(a7)+,d2
		sub.l	d4,d2
		beq.s	l64b4
		movea.l	442(a6),a0
		addq.l	#2,d2
		subq.l	#2,d4
		bcs.w	l521c
		move.l	d2,14(a0)
	l64b4:	movea.l	442(a6),a3
		lea	28(a3),a3
		adda.l	370(a6),a3
		adda.l	382(a6),a3
		adda.l	d2,a3
		bsr.w	L6382
		movea.l	442(a6),a0
		move.w	#$601a,(a0)
		rts
		dc.b	$24,$0,$22,$6e,$1,$38,$70,$0,$10,$29,$0,$e,$b0,$3c,$0,$18
		dc.b	$67,$0,$f9,$fa,$4a,$2e,$1,$5,$66,$2,$4e,$75,$2f,$a,$43,$ee
		dc.b	$1,$76,$d2,$c0,$24,$51,$4a,$91,$66,$28,$61,$8,$24,$48,$25,$48
		dc.b	$0,$4,$60,$30,$48,$e7,$0,$60,$22,$3c,$0,$0,$0,$d2,$61,$0
		dc.b	$f2,$8c,$4c,$df,$6,$0,$22,$88,$42,$90,$31,$7c,$0,$32,$0,$8
		dc.b	$4e,$75,$20,$6a,$0,$4,$4a,$68,$0,$8,$66,$8,$22,$48,$61,$d4
		dc.b	$25,$48,$0,$4,$70,$32,$90,$68,$0,$8,$d0,$40,$d0,$40,$53,$68
		dc.b	$0,$8,$21,$82,$0,$a
		dc.b	"$_NuJ."
		dc.b	$1,$d0,$67,$1c,$4a,$2e,$1,$5,$67,$16,$b0,$3c,$0,$18,$67,$10
		dc.b	$b0,$3c,$0,$c,$67,$6,$d3,$ae,$5d,$14,$60,$e,$d3,$ae,$5d,$28
		dc.b	$b0,$3c,$0,$18,$66,$4,$70,$ff,$4e,$75,$70,$0,$4e,$75

L657e:
		moveq	#84,d1
		tst.b	d0
		beq.s	l658e
		moveq	#68,d1
		cmp.b	#$c,d0
		beq.s	l658e
		moveq	#66,d1
	l658e:	bsr.w	L596c
		bra.w	L5570
	l6596:	lea	L65a2(pc),a0
		rts
	l659c:	lea	L65ad(pc),a0
		rts

L65a2:
		dc.b	"executable"
		dc.b	$0

L65ad:
		dc.b	$2e,$50,$52,$47,$0,$12,$d8,$66,$fc,$53,$89,$4e,$75
	l65ba:	tst.l	442(a6)
		bne.w	l5c80
		move.l	#$4000,d1
		move.l	#$400,d2
		bsr.w	L78e6
		move.l	d1,23876(a6)
		move.l	d1,23884(a6)
		bsr.w	L57a0
		move.l	a0,23880(a6)
		move.l	a0,23888(a6)
		rts
	l65e8:	movea.l	23888(a6),a2
		moveq	#1,d1
		bsr.w	L68da
		lea	22(a1),a0
		move.b	(a0)+,d1
		subq.b	#1,d1
		bsr.w	L6902
		move.l	a2,23888(a6)
		lea	L66b4(pc),a2
		moveq	#0,d3
		moveq	#0,d4
	l660a:	subq.b	#1,d4
		move.l	a7,780(a6)
		movea.l	8(a1),a0
		bsr.w	L53b0
		trap	#15
		cmp.b	12(a1),d4
		bne.s	l660a
		movea.l	342(a6),a1
		movea.l	(a1),a1
		movea.l	23888(a6),a2
		move.l	a1,d0
		beq.s	l6630
		bsr.s	L6636
	l6630:	move.l	a2,23888(a6)
		rts

L6636:
		tst.l	(a1)
		beq.s	l6642
		move.l	a1,-(a7)
		movea.l	(a1),a1
		bsr.s	L6636
		movea.l	(a7)+,a1
	l6642:	btst	#$4,12(a1)
		beq.s	l664c
		bsr.s	L665e
	l664c:	tst.l	4(a1)
		beq.s	l665c
		move.l	a1,-(a7)
		movea.l	4(a1),a1
		bsr.s	L6636
		movea.l	(a7)+,a1
	l665c:	rts

L665e:
		moveq	#16,d1
		bsr.w	L68da
		move.w	20(a1),d1
		bsr.w	L68ee
		lea	22(a1),a0
		move.b	(a0)+,d1
		bra.w	L6902
		dc.b	"$n]Pr"
		dc.b	$6,$61,$0,$2,$5c,$41,$e9,$0,$16,$12,$18,$61,$0,$2,$7a,$32
		dc.b	$29,$0,$8,$61,$0,$2,$5e,$32,$29,$0,$a,$61,$0,$2,$56,$12
		dc.b	$29,$0,$e,$48,$81,$c,$29,$0,$1,$0,$d,$67,$2,$72,$0,$61
		dc.b	$0,$2
		dc.b	"B-J]PNu"

L66b4:
		dc.b	$b8,$28,$0,$e,$67,$2,$4e,$75,$48,$e7,$0,$a0
		dc.b	"$n]Pr"
		dc.b	$10,$61,$0,$2,$12,$12,$28,$0,$e,$48,$81,$61,$0,$2,$1c,$41
		dc.b	$e8,$0,$16,$12,$18,$53,$1,$61,$0,$2
		dc.b	"$-J]PL"
		dc.b	$df,$5,$0,$2e,$6e,$3,$c,$60,$0,$ff,$2c
	l66f0:	move.l	23876(a6),d1
		sub.l	23884(a6),d1
		cmp.l	#$1b,d1
		bne.s	l6714
		tst.l	418(a6)
		bne.s	l6714
		move.l	23880(a6),23888(a6)
		move.l	23876(a6),23884(a6)
		rts
	l6714:	tst.b	262(a6)
		beq.s	l6722
		lea	L6732(pc),a2
		bsr.w	L53da
	l6722:	movea.l	23888(a6),a2
		moveq	#19,d1
		bsr.w	L68da
		move.l	a2,23888(a6)
		rts

L6732:
		dc.b	$c,$29,$0,$1,$0,$d,$66,$10,$70,$b0,$c0,$29,$0,$c,$66,$8
		dc.b	$2f,$a,$61,$0,$ff
		dc.b	"0$_Nu"
	l674c:	tst.b	464(a6)
		beq.s	l676c
		movea.l	23888(a6),a2
		moveq	#4,d1
		bsr.w	L68da
		move.b	316(a6),d1
		ext.w	d1
		bsr.w	L68ee
		move.l	a2,23888(a6)
		rts
	l676c:	rts
	l676e:	lea	23900(a6),a1
		move.l	a1,23892(a6)
		clr.l	(a1)
		lea	24348(a6),a1
		move.l	a1,23896(a6)
		rts
		dc.b	$4a,$2e,$1,$5
		dc.b	"gD n]T "
		dc.b	$cd,$20,$ee,$5d,$58,$30,$fc,$0,$4
		dc.b	"-H]TB"
		dc.b	$90,$20,$6e,$5d,$58,$10,$fc,$0,$fb,$10,$fc,$0,$7,$2f,$2,$22
		dc.b	$4f,$10,$d9,$10,$d9,$10,$d9,$10,$d9,$10,$fc,$0,$54,$10,$fc,$0
		dc.b	$2b,$50,$d8,$10,$ee,$1,$3c,$10,$fc,$0,$fb
		dc.b	"-H]XX"
		dc.b	$8f,$4e,$75
	l67ce:	moveq	#-1,d0
		rts
		dc.b	"$n]Pr"
		dc.b	$2,$61,$0,$1,$0,$2,$2,$0,$7f,$12,$2,$20,$49,$61,$0,$1
		dc.b	$1c
		dc.b	"-J]PNuJ."
		dc.b	$1,$d0,$67,$38,$4a,$2e,$1,$5
		dc.b	"g2$n]Pr"
		dc.b	$5,$60,$12,$4a,$2e,$1,$d0,$67,$24,$4a,$2e,$1,$5,$67,$1e
		dc.b	"$n]Pr"
		dc.b	$3,$61,$0,$0,$c4,$22,$2,$48,$41,$61,$0,$0,$d0,$48,$41,$61
		dc.b	$0,$0,$ca
		dc.b	"-J]Pp"
		dc.b	$0
		dc.b	"Nu$n]P&.]LS"
		dc.b	$81,$65,$e,$10,$18,$61,$14,$b0,$3c,$0,$fb,$66,$f2,$61,$c,$60
		dc.b	$ee
		dc.b	"-C]L-J]PNuS"
		dc.b	$83,$65,$4,$14,$c0,$4e,$75,$52,$83
		dc.b	"-C]La"
		dc.b	$0,$0,$bc
		dc.b	"&.]L`"
		dc.b	$e8
	l686a:	movea.l	23888(a6),a2
		movea.l	504(a6),a1
		move.l	23884(a6),d3
		moveq	#-5,d2
		tst.l	23900(a6)
		bne.w	l69ea

L6880:
		subq.l	#1,d3
		bcs.s	l68b2
		move.b	(a1)+,d0
		move.b	d0,(a2)+
		cmp.b	d2,d0
		beq.s	l689a
	l688c:	subq.l	#1,d1
		bne.s	L6880
		move.l	d3,23884(a6)
		move.l	a2,23888(a6)
		rts
	l689a:	subq.l	#1,d3
		bne.s	l68ae
		addq.l	#1,d3
		move.l	d3,23884(a6)
		bsr.w	L691e
		move.l	23884(a6),d3
		subq.l	#1,d3
	l68ae:	move.b	d2,(a2)+
		bra.s	l688c
	l68b2:	addq.l	#1,d3
		move.l	d3,23884(a6)
		bsr.w	L691e
		move.l	23884(a6),d3
		bra.s	L6880
		dc.b	$52,$ae
		dc.b	"]LaVS"
		dc.b	$ae,$5d,$4c,$65,$f4,$14,$fc,$0,$fb,$4e,$75
	l68d4:	addq.l	#2,23884(a6)
		bsr.s	L691e

L68da:
		subq.l	#2,23884(a6)
		bcs.s	l68d4
		move.b	#$fb,(a2)+
		move.b	d1,(a2)+
		rts
	l68e8:	addq.l	#2,23884(a6)
		bsr.s	L691e

L68ee:
		subq.l	#2,23884(a6)
		bcs.s	l68e8
		move.w	d1,-(a7)
		move.b	(a7),(a2)+
		move.b	1(a7),(a2)+
		addq.l	#2,a7
		rts
	l6900:	bsr.s	L691e

L6902:
		ext.w	d1
		ext.l	d1
		cmp.l	23884(a6),d1
		bge.s	l6900
		sub.l	d1,23884(a6)
		subq.l	#1,23884(a6)
		move.b	d1,(a2)+
	l6916:	move.b	(a0)+,(a2)+
		subq.b	#1,d1
		bne.s	l6916
		rts

L691e:
		movem.l	a0-1/d0-2,-(a7)
		bsr.w	L5d8a
		movea.l	23880(a6),a0
		move.l	23876(a6),d1
		sub.l	23884(a6),d1
		bsr.w	L4f54
		movea.l	23880(a6),a2
		move.l	23876(a6),23884(a6)
		movem.l	(a7)+,d0-2/a0-1
		rts
	l6946:	bra.s	L691e
		dc.b	$70,$14,$b6,$3c,$0,$1
		dc.b	"f.pT`*p"
		dc.b	$1,$60,$16,$70,$9,$60,$12,$70,$2,$60,$e,$70,$a,$60,$a,$70
		dc.b	$29,$53,$82,$60,$14,$70,$2a,$60,$10,$b6,$3c,$0,$1,$66,$a,$3f
		dc.b	$0,$70,$2,$61,$0,$e6,$f0,$30,$1f
		dc.b	" n]T "
		dc.b	$cd,$36,$0,$2,$3,$0,$7,$da,$c3,$20,$ee,$5d,$58,$30,$c3
		dc.b	"-H]TB"
		dc.b	$90,$20,$6e,$5d,$58,$10,$fc,$0,$fb,$10,$fc,$0,$7,$2f,$2,$22
		dc.b	$4f,$10,$d9,$10,$d9,$10,$d9,$10,$d9,$10,$c0,$43,$ee,$59,$da,$4a
		dc.b	$2e,$1,$b,$67,$12,$6a,$6,$10,$fc,$0,$2d,$60,$4,$10,$fc,$0
		dc.b	$2b,$50,$d8,$10,$ee,$1,$3c,$30,$19,$67,$c,$10,$c0,$3e,$99,$10
		dc.b	$d7,$10,$ef,$0,$1,$60,$f0,$10,$fc,$0,$fb
		dc.b	"-H]XX"
		dc.b	$8f,$4e,$75
	l69ea:	move.l	d4,-(a7)
		lea	23900(a6),a0
	l69f0:	move.l	(a0)+,d4
		beq.s	l6a34
		sub.l	a1,d4
		bsr.s	L6a44
		movem.l	a3/a1,-(a7)
		movea.l	(a0)+,a1
		movea.l	23896(a6),a3
		move.w	(a0)+,d0
		tst.l	(a0)
		beq.s	l6a0c
		movea.l	4(a0),a3
	l6a0c:	move.l	a3,d4
		sub.l	a1,d4
		cmp.l	d3,d4
		ble.s	l6a20
		move.l	d3,23884(a6)
		bsr.w	L691e
		move.l	23884(a6),d3
	l6a20:	sub.l	d4,d3
	l6a22:	move.b	(a1)+,(a2)+
		subq.l	#1,d4
		bne.s	l6a22
		movem.l	(a7)+,a1/a3
		ext.l	d0
		adda.l	d0,a1
		sub.l	d0,d1
		bra.s	l69f0
	l6a34:	move.l	d1,d4
		bsr.s	L6a44
		move.l	d3,23884(a6)
		move.l	(a7)+,d4
		move.l	a2,23888(a6)
		rts

L6a44:
		tst.l	d4
		beq.s	l6a52
		exg	d4,d1
		sub.l	d1,d4
		bsr.w	L6880
		exg	d1,d4
	l6a52:	rts
	l6a54:	move.b	d0,d1
		bsr.w	L5594
		moveq	#46,d1
		bra.w	L596c
	l6a60:	lea	L6a6c(pc),a0
		rts
	l6a66:	lea	L6a79(pc),a0
		rts

L6a6c:
		dc.b	"GST linkable"
		dc.b	$0

L6a79:
		dc.b	$2e,$42,$49,$4e,$0

L6a7e:
		tst.l	442(a6)
		bne.w	l5c80
		move.l	370(a6),d1
		add.l	d1,d1
		addi.l	#$64,d1
		bsr.w	L57a0
		move.l	a0,23820(a6)
		move.l	a0,23832(a6)
		move.l	a0,504(a6)
		move.l	370(a6),d1
		bsr.s	L6ac4
		move.l	382(a6),d1
		add.l	d1,d1
		addi.l	#$64,d1
		bsr.w	L57a0
		move.l	a0,23840(a6)
		move.l	a0,23852(a6)
		move.l	382(a6),d1

L6ac4:
		adda.l	d1,a0
		lsr.l	#1,d1
		subq.l	#1,d1
		bcs.s	l6adc
		moveq	#0,d0
	l6ace:	move.w	d0,(a0)+
		dbra	d1,l6ace
		subi.l	#$10000,d1
		bcc.s	l6ace
	l6adc:	rts
		dc.b	$4a,$2e,$1,$5,$67,$1c,$20,$2e,$1,$72,$74,$2,$4a,$2e,$1,$3c
		dc.b	$67,$6,$20,$2e,$1,$7e,$74,$1,$3b,$bc,$0,$5,$8,$0,$3b,$82
		dc.b	$8,$2,$4e,$75,$d3,$ae,$1,$f8,$1a,$d8,$53,$81,$66,$fa,$4e,$75

L6b0e:
		add.l	d1,504(a6)
		rts

L6b14:
		rts
		dc.b	$70,$ff,$4e,$75,$b4,$7c,$0,$6,$66,$18,$41,$fa,$0,$18,$10,$19
		dc.b	$48,$80,$10,$36,$0,$7e,$b0,$18,$66,$8,$53,$42,$66,$f0,$50,$ee
		dc.b	$1
		dc.b	" NuPASCALX"
		dc.b	$8f,$70,$42,$60,$0,$e4,$70,$4a,$2e,$1,$5,$67,$2a,$24,$2e,$1
		dc.b	$72,$4a,$2e,$1,$3c,$67,$4,$24,$2e,$1,$7e,$41,$ee,$59,$da,$30
		dc.b	$18,$b0,$7c,$2b,$2b,$66,$d8,$30,$18,$6a,$2,$4e,$75,$53,$40,$d0
		dc.b	$40,$d0,$40,$d0,$40,$4e,$75,$58,$8f,$4e,$75,$2a,$c2,$61,$c8,$6b
		dc.b	$10,$3b,$bc,$0,$5,$28,$fc,$0,$0,$0,$4,$3b,$80,$28,$fe,$4e
		dc.b	$75,$3b,$bc,$0,$5,$28,$fc,$61,$26,$3b,$80,$28,$fe,$4e,$75,$3a
		dc.b	$c2,$61,$a4,$6b,$9c,$0,$0,$0,$4,$3b,$80,$28,$fe,$4e,$75,$3a
		dc.b	$c2,$61,$94,$6b,$8c,$0,$0,$0,$6,$3b,$80,$28,$fe,$4e,$75,$4a
		dc.b	$0,$67,$a,$b0,$3c,$0,$c,$67,$8,$70,$3,$4e,$75,$70,$2,$4e
		dc.b	$75,$70,$1,$4e,$75

L6bd6:
		beq.s	l6c02
		tst.b	288(a6)
		beq.s	l6c02
		movem.l	a0/d1,-(a7)
		add.l	d1,d1
		bsr.w	L57a0
		movem.l	(a7)+,d1/a1
		move.l	a0,-(a7)
		move.l	d1,d0
		lsr.l	#1,d0
		lea	0(a1,d1.l),a2
	l6bf6:	move.w	(a1)+,(a0)+
		move.w	(a2)+,(a0)+
		subq.l	#1,d0
		bne.s	l6bf6
		movea.l	(a7)+,a0
		add.l	d1,d1
	l6c02:	rts

L6c04:
		bsr.w	L5d8a
		lea	1328(a6),a0
		move.w	#$601a,(a0)+
		move.l	370(a6),(a0)+
		move.l	382(a6),(a0)+
		move.l	394(a6),(a0)+
		clr.l	(a0)+
		clr.l	(a0)+
		clr.l	(a0)+
		moveq	#0,d0
		tst.b	288(a6)
		beq.s	l6c2e
		move.w	#$4a4c,d0
	l6c2e:	move.w	d0,(a0)+
		lea	1328(a6),a0
		moveq	#28,d1
		bsr.w	L4f54
		movea.l	23820(a6),a0
		move.l	370(a6),d1
		bsr.s	L6bd6
		bsr.w	L4f54
		movea.l	23840(a6),a0
		move.l	382(a6),d1
		bsr.s	L6bd6
		bsr.w	L4f54
		clr.l	23864(a6)
		movea.l	342(a6),a1
		movea.l	(a1),a1
		move.l	a1,d0
		beq.w	l6d5a
		moveq	#0,d7
		movea.l	308(a6),a0
		move.w	20(a0),d6
	l6c70:	cmp.w	d6,d7
		beq.w	l6d5a
		addq.w	#1,d7
		move.l	a7,23876(a6)
		movea.l	342(a6),a1
		movea.l	(a1),a1
		bsr.s	L6cd2
		trap	#15
	l6c86:	move.w	#$8800,d2
		moveq	#0,d3
		bsr.s	L6c90
		bra.s	l6c70

L6c90:
		lea	1328(a6),a0
		moveq	#0,d0
		move.l	d0,(a0)
		move.l	d0,4(a0)
		move.b	22(a1),d0
		lea	23(a1),a2
		cmp.w	#$9,d0
		bcs.s	l6cae
		moveq	#7,d0
	l6cac:	move.b	(a2)+,(a0)+
	l6cae:	dbra	d0,l6cac
		lea	1328(a6),a0
		move.w	d2,8(a0)
		move.l	d3,10(a0)
		moveq	#14,d1
		add.l	d1,23864(a6)
		move.l	a1,-(a7)
		bsr.w	L78ae
		movea.l	(a7)+,a1
		bne.w	l4f5c
		rts

L6cd2:
		tst.l	(a1)
		beq.s	l6cde
		move.l	a1,-(a7)
		movea.l	(a1),a1
		bsr.s	L6cd2
		movea.l	(a7)+,a1
	l6cde:	btst	#$4,12(a1)
		beq.s	l6cf2
		cmp.w	20(a1),d7
		bne.s	l6cf2
		movea.l	23876(a6),a7
		bra.s	l6c86
	l6cf2:	tst.l	4(a1)
		beq.s	l6d02
		move.l	a1,-(a7)
		movea.l	4(a1),a1
		bsr.s	L6cd2
		movea.l	(a7)+,a1
	l6d02:	rts

L6d04:
		dc.b	$34,$3c,$20,$0,$8,$29,$0,$4,$0,$c,$66,$48,$8,$29,$0,$5
		dc.b	$0,$c,$66,$8,$74,$0,$4a,$2e,$1,$6,$67,$38,$10,$29,$0,$d
		dc.b	$b0,$3c,$0,$1,$67,$a,$b0,$3c,$0,$2,$66,$28,$76,$e,$60,$12
		dc.b	$76,$9,$10,$29,$0,$e,$67,$a,$76,$a,$b0,$3c,$0,$c,$67,$2
		dc.b	$76,$8,$7,$c2,$0,$42,$80,$0,$26,$29,$0,$8,$2f,$a,$61,$0
		dc.b	$ff
		dc.b	"<$_Nu"
	l6d5a:	movea.l	308(a6),a1
		lea	L6d04(pc),a2
		bsr.w	L53da
		movea.l	350(a6),a1
		movea.l	(a1),a1
		move.l	a1,d0
		beq.s	l6d74
		bsr.w	L53e4
	l6d74:	tst.b	288(a6)
		bne.s	l6d96
		movea.l	23820(a6),a0
		move.l	370(a6),d1
		adda.l	d1,a0
		bsr.w	L4f54
		movea.l	23840(a6),a0
		move.l	382(a6),d1
		adda.l	d1,a0
		bsr.w	L4f54
	l6d96:	tst.l	23864(a6)
		beq.s	l6dac
		moveq	#14,d2
		bsr.w	L78d2
		lea	23864(a6),a0
		moveq	#4,d1
		bsr.w	L4f54
	l6dac:	rts

L6dae:
		lea	L6dc4(pc),a0
		tst.b	288(a6)
		beq.s	l6dbc
		lea	L6dd1(pc),a0
	l6dbc:	rts

L6dbe:
		lea	L6dde(pc),a0
		rts

L6dc4:
		dc.b	"DRI linkable"
		dc.b	$0

L6dd1:
		dc.b	"OSS linkable"
		dc.b	$0

L6dde:
		dc.b	$2e,$4f,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
		ds.b	15
		dc.b	$1,$1,$1,$0,$1,$0,$0,$0,$0,$0,$0,$0,$0,$1,$1,$1
		dc.b	$1,$1,$0,$1,$1,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1

L6e62:
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$0,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
		ds.b	11
		dc.b	$1,$1,$1,$1,$0,$1,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
		ds.b	16
		dc.b	$1,$1,$1,$1,$1

L6ee2:
		dc.b	$80,$9a,$90,$83,$8e,$b6,$8f,$80,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
		dc.b	$90,$92,$92,$93,$99,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f
		dc.b	$a0,$a1,$a2,$a3,$a5,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af
		dc.b	$b7,$b8,$b2,$b2,$b4,$b4,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
		dc.b	$c1,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf
		dc.b	$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df
		dc.b	$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
		dc.b	$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff
		dc.b	$0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$a,$b,$c,$d,$e,$f
		dc.b	$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
		dc.b	" !""#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`ABCDEF"
		dc.b	"GHIJKLMNOPQRSTUVWXYZ{|}~"
		dc.b	$7f

L6fe2:
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$ff,$1
		ds.b	10
		dc.b	$1,$1,$1,$1,$1,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
		ds.b	17
		dc.b	$1,$1,$1,$1,$0,$1,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
		ds.b	16
		dc.b	$1,$1,$1,$1,$1,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
		ds.b	16
		dc.b	$1,$1,$1,$0,$1,$0,$0,$0,$0,$0,$0,$0,$0,$1,$1,$1
		dc.b	$1,$1,$0,$1,$1,$0,$0,$0,$0,$0,$0,$0,$0,$0,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1,$1
		dc.b	$1,$1,$1,$1,$1

L70e2:
		andi.w	#$ff,d1
		move.w	d1,-(a7)
		move.w	#$2,-(a7)
		trap	#1
		addq.l	#4,a7
		rts

L70f2:
		move.l	d1,-(a7)
		move.l	a0,-(a7)
		move.l	d1,-(a7)
		move.w	d3,-(a7)
		move.w	#$40,-(a7)
		trap	#1
		lea	12(a7),a7
		move.l	(a7)+,d1
		cmp.l	d0,d1
		rts

L710a:
		tst.w	d3
		bmi.s	l7114
		cmp.w	#$5,d3
		bcc.s	l711e
	l7114:	move.w	d3,-(a7)
		move.w	#$3e,-(a7)
		trap	#1
		addq.l	#4,a7
	l711e:	rts

L7120:
		movea.l	(a7)+,a3
		movea.l	4(a7),a5
		move.l	4(a5),d0
		sub.l	(a5),d0
		subi.l	#$fa0,d0
		bcs.s	l7178
		cmp.l	#$739a,d0
		bcs.s	l7178
		movea.l	24(a5),a6
		addq.w	#2,a6
		move.l	a5,24860(a6)
		lea	18280(a6),a7
		lea	0(a5,d0.l),a0
		move.l	a0,25132(a6)
		lea	25340(a6),a0
		move.l	a0,25128(a6)
		clr.l	25124(a6)
		move.l	d0,-(a7)
		move.l	a5,-(a7)
		clr.w	-(a7)
		move.w	#$4a,-(a7)
		trap	#1
		lea	12(a7),a7
		tst.l	d0
		bne.s	l7178
		sf	24864(a6)
		jmp	(a3)
	l7178:	move.w	#$ffd9,-(a7)
		move.w	#$4c,-(a7)
		trap	#1

L7182:
		clr.l	480(a6)
		clr.l	488(a6)
		movea.l	24860(a6),a0
		movea.l	36(a0),a0
		lea	128(a0),a0
		cmpi.l	#$414d50,(a0)+
		bne.s	l71c4
		move.l	(a0)+,480(a6)
		move.l	(a0)+,488(a6)
		movea.l	(a0)+,a1
		move.l	a1,326(a6)
		move.l	a1,d0
		beq.s	l71b4
		clr.w	2(a1)
	l71b4:	move.l	(a0)+,442(a6)
		beq.s	l71c0
		movea.l	442(a6),a1
		clr.w	(a1)
	l71c0:	move.l	(a0)+,446(a6)
	l71c4:	clr.l	456(a6)
		clr.b	450(a6)
		clr.b	1698(a6)
		clr.b	451(a6)
		st	261(a6)
		sf	457(a6)
		clr.w	452(a6)
		move.l	25132(a6),d0
		sub.l	25128(a6),d0
		move.l	d0,24866(a6)
		bsr.w	L75ba
		move.l	d0,25120(a6)
		movea.l	24860(a6),a0
		lea	128(a0),a0
		moveq	#0,d0
		move.b	(a0)+,d0
		bne.s	l7256
		st	24864(a6)
		move.l	a0,-(a7)
		pea	L75f3(pc)
		move.w	#$9,-(a7)
		trap	#1
		addq.l	#6,a7
		movea.l	(a7)+,a0
		move.b	#$4c,-(a0)
		move.l	a0,-(a7)
		move.w	#$a,-(a7)
		trap	#1
		addq.l	#6,a7
		pea	L7606(pc)
		move.w	#$9,-(a7)
		trap	#1
		addq.l	#6,a7
		movea.l	24860(a6),a0
		lea	129(a0),a0
		moveq	#0,d0
		move.b	(a0)+,d0
		bne.s	l7246
		sf	24864(a6)
		moveq	#-1,d0
		rts
	l7246:	movem.l	a0/d0,-(a7)
		bsr.w	L75ba
		move.l	d0,25120(a6)
		movem.l	(a7)+,d0/a0
	l7256:	clr.b	0(a0,d0.w)
		clr.b	1(a0,d0.w)
		clr.b	25038(a6)

L7262:
		move.b	(a0)+,d1
		beq.w	L7368
		cmp.b	#$20,d1
		beq.s	L7262
		cmp.b	#$2d,d1
		beq.w	L72f8
		lea	1698(a6),a1
		lea	1192(a6),a2
		move.l	a2,1186(a6)
		clr.b	1191(a6)
		lea	24874(a6),a3
	l728a:	moveq	#0,d3
	l728c:	move.b	d1,(a2)+
		move.b	d1,(a1)+
		move.b	d1,(a3)+
		addq.b	#1,1191(a6)
		move.b	(a0)+,d1
		beq.s	l72b0
		cmp.b	#$20,d1
		beq.s	l72b0
		cmp.b	#$5c,d1
		beq.s	l728a
		cmp.b	#$2e,d1
		bne.s	l728c
		move.l	a1,d3
		bra.s	l728c
	l72b0:	tst.l	d3
		bne.s	l72c4
		clr.b	(a1)
		move.b	#$2e,(a2)+
		move.b	#$73,(a2)+
		addq.b	#2,1191(a6)
		bra.s	l72c8
	l72c4:	movea.l	d3,a1
		clr.b	(a1)
	l72c8:	move.b	#$b,(a2)
		addq.b	#1,1191(a6)
		clr.b	(a3)+
		move.l	a0,-(a7)
		lea	24874(a6),a0
		bsr.w	L748a
		move.l	a0,24870(a6)
		clr.b	(a0)
		movea.l	(a7)+,a0
		lea	1186(a6),a1
		tst.l	480(a6)
		bne.w	L7262
		move.l	a1,426(a6)
		bra.w	L7262

L72f8:
		move.b	(a0)+,d1
		beq.w	L7368
		cmp.b	#$20,d1
		beq.s	L7368
		ext.w	d1
		move.b	126(a6,d1.w),d1
		cmp.b	#$50,d1
		beq.w	l744e
		cmp.b	#$53,d1
		beq.s	l737e
		cmp.b	#$4c,d1
		beq.w	l73b8
		cmp.b	#$43,d1
		beq.s	l7386
		cmp.b	#$51,d1
		beq.s	l738e
		cmp.b	#$44,d1
		beq.s	l7396
		cmp.b	#$58,d1
		beq.s	l73a0
		cmp.b	#$4d,d1
		beq.s	l73a8
		cmp.b	#$42,d1
		beq.s	l73b0
		cmp.b	#$54,d1
		beq.w	l73f0
		cmp.b	#$4f,d1
		beq.w	l7430
		cmp.b	#$45,d1
		beq.w	l7482
		cmp.b	#$5a,d1
		beq.w	l73dc
		bra.w	L73e4

L7368:
		move.l	426(a6),d0
		or.l	480(a6),d0
		beq.w	L73e4
		tst.b	23098(a6)
		bne.w	l74b2
		rts
	l737e:	st	458(a6)
		bra.w	L72f8
	l7386:	st	456(a6)
		bra.w	L72f8
	l738e:	st	24864(a6)
		bra.w	L72f8
	l7396:	move.b	#$1,262(a6)
		bra.w	L72f8
	l73a0:	st	262(a6)
		bra.w	L72f8
	l73a8:	st	451(a6)
		bra.w	L72f8
	l73b0:	sf	261(a6)
		bra.w	L72f8
	l73b8:	st	457(a6)
		move.b	(a0),d0
		subi.b	#$32,d0
		bcs.w	L72f8
		addq.b	#1,d0
		ext.w	d0
		cmp.w	#$2,d0
		bcc.w	L72f8
		move.w	d0,452(a6)
		addq.l	#1,a0
		bra.w	L72f8
	l73dc:	st	450(a6)
		bra.w	L72f8

L73e4:
		lea	L761f(pc),a0
		bsr.w	L5980
		moveq	#-1,d0
		rts
	l73f0:	moveq	#0,d2
		move.b	(a0)+,d2
		subi.b	#$30,d2
		bcs.s	L73e4
		cmp.b	#$a,d2
		bcc.s	L73e4
		move.w	d2,23634(a6)
		move.b	(a0),d1
		cmp.b	#$30,d1
		bcs.s	l7426
		cmp.b	#$3a,d1
		bcc.s	l7426
		mulu	#$a,d2
		subi.b	#$30,d1
		andi.w	#$ff,d1
		add.w	d1,d2
		move.w	d2,23634(a6)
		addq.l	#1,a0
	l7426:	tst.w	23634(a6)
		bne.w	L72f8
		bra.s	L73e4
	l7430:	st	261(a6)
		lea	1616(a6),a1
	l7438:	move.b	(a0)+,d1
		beq.s	l7446
		cmp.b	#$20,d1
		beq.s	l7446
		move.b	d1,(a1)+
		bra.s	l7438
	l7446:	clr.b	(a1)
	l7448:	subq.l	#1,a0
		bra.w	L7262
	l744e:	st	459(a6)
		move.l	#$3,23100(a6)
		st	23098(a6)
		move.b	(a0),d1
		beq.s	l7448
		cmp.b	#$20,d1
		beq.s	l7448
		lea	25038(a6),a1
	l746c:	move.b	(a0)+,d1
		beq.s	l747a
		cmp.b	#$20,d1
		beq.s	l747a
		move.b	d1,(a1)+
		bra.s	l746c
	l747a:	clr.b	(a1)
		subq.l	#1,a0
		bra.w	L7262
	l7482:	move.l	a0,330(a6)
		bra.w	L7368

L748a:
		moveq	#0,d0
		movea.l	a0,a1
	l748e:	move.b	(a0)+,d1
		beq.s	l74a2
		cmp.b	#$5c,d1
		beq.s	l749e
		cmp.b	#$3a,d1
		bne.s	l748e
	l749e:	move.l	a0,d0
		bra.s	l748e
	l74a2:	tst.l	d0
		bne.s	l74ac
		movea.l	a1,a0
		moveq	#-1,d0
		rts
	l74ac:	movea.l	d0,a0
		moveq	#0,d0
		rts
	l74b2:	lea	25038(a6),a0
		tst.b	(a0)
		bne.s	l74fe
		lea	1186(a6),a1
		moveq	#0,d2
		move.b	5(a1),d0
		subq.b	#1,d0
		movea.l	(a1),a1
	l74c8:	move.b	(a1)+,d1
		cmp.b	#$5c,d1
		beq.s	l74da
		cmp.b	#$2e,d1
		bne.s	l74dc
		move.l	a0,d2
		bra.s	l74dc
	l74da:	moveq	#0,d2
	l74dc:	move.b	d1,(a0)+
		subq.b	#1,d0
		bne.s	l74c8
		tst.l	d2
		beq.s	l74e8
		movea.l	d2,a0
	l74e8:	move.b	#$2e,(a0)+
		move.b	#$4c,(a0)+
		move.b	#$53,(a0)+
		move.b	#$54,(a0)+
		clr.b	(a0)+
		lea	25038(a6),a0
	l74fe:	clr.w	-(a7)
		move.l	a0,-(a7)
		move.w	#$3c,-(a7)
		trap	#1
		addq.l	#8,a7
		tst.l	d0
		bmi.w	L73e4
		move.l	d0,23100(a6)
		moveq	#0,d0
		rts

L7518:
		tst.b	23099(a6)
		beq.s	l7548

L751e:
		tst.w	23630(a6)
		bmi.s	l7548
		btst	#$0,23818(a6)
		beq.s	l7548
		moveq	#13,d1
		bsr.w	L585a
		moveq	#10,d1
		bsr.w	L585a
		moveq	#12,d1
		bsr.w	L585a
		clr.w	23628(a6)
		move.w	#$ffff,23630(a6)
	l7548:	rts

L754a:
		bsr.s	L75ba
		move.l	d0,-(a7)
		move.l	24866(a6),d1
		sub.l	25132(a6),d1
		add.l	25128(a6),d1
		bsr.w	L55e2
		pea	L75ce(pc)
		move.w	#$9,-(a7)
		trap	#1
		addq.l	#6,a7
		move.l	24866(a6),d1
		bsr.w	L55e2
		pea	L75e2(pc)
		move.w	#$9,-(a7)
		trap	#1
		addq.l	#6,a7
		move.l	(a7)+,d2
		sub.l	25120(a6),d2
		divu	#$c8,d2
		move.l	d2,-(a7)
		moveq	#0,d1
		move.w	d2,d1
		bsr.w	L55e2
		moveq	#46,d1
		bsr.w	L596c
		move.l	(a7)+,d2
		clr.w	d2
		swap	d2
		divu	#$14,d2
		moveq	#48,d1
		add.b	d2,d1
		bsr.w	L596c
		pea	L75ea(pc)
		move.w	#$9,-(a7)
		trap	#1
		addq.l	#6,a7
		bra.w	L556a

L75ba:
		pea	L75c8(pc)
		move.w	#$26,-(a7)
		trap	#14
		addq.l	#6,a7
		rts

L75c8:
		dc.b	$20,$38,$4,$ba,$4e,$75

L75ce:
		dc.b	" bytes used out of "
		dc.b	$0

L75e2:
		dc.b	", took "
		dc.b	$0

L75ea:
		dc.b	" seconds"
		dc.b	$0

L75f3:
		dc.b	"Enter command line:"

L7606:
		dc.b	$d,$a,$0

L7609:
		dc.b	$d,$a
		dc.b	"Press a key to exit"
		dc.b	$0

L761f:
		dc.b	"Invalid command line - see manual"
		dc.b	$d,$0

L7642:
		tst.b	24864(a6)
		beq.s	l7674
		pea	L7609(pc)
		move.w	#$9,-(a7)
		trap	#1
		addq.l	#6,a7
	l7654:	move.l	#$600ff,-(a7)
		trap	#1
		addq.l	#4,a7
		tst.w	d0
		bne.s	l7654
	l7662:	move.w	#$7,(a7)
		trap	#1
		cmp.b	#$d,d0
		beq.s	l7674
		cmp.b	#$20,d0
		bcs.s	l7662
	l7674:	move.b	466(a6),d0
		ext.w	d0
		move.w	d0,-(a7)
		move.w	#$4c,-(a7)
		trap	#1

L7682:
		moveq	#-1,d0
		move.l	d0,-(a7)
		move.l	d0,-(a7)
		move.l	d0,-(a7)
		move.w	#$10,-(a7)
		trap	#14
		lea	14(a7),a7
		movea.l	d0,a0
		movea.l	4(a0),a0
		cmpi.b	#$23,4(a0)
		seq	d0
		ext.w	d0
		move.w	d0,-(a7)
		move.w	#$2a,-(a7)
		trap	#1
		addq.l	#2,a7
		move.w	d0,d1
		andi.w	#$1f,d1
		move.w	d0,d2
		lsr.w	#5,d2
		andi.w	#$f,d2
		tst.b	(a7)+
		beq.s	l76c2
		exg	d2,d1
	l76c2:	bsr.s	L7712
		move.b	#$2f,(a3)+
		move.w	d2,d1
		bsr.s	L7712
		move.b	#$2f,(a3)+
		move.w	d0,d1
		rol.w	#7,d1
		andi.w	#$7f,d1
		addi.w	#$50,d1
		bsr.s	L7712
		move.b	#$20,(a3)+
		move.b	#$20,(a3)+
		move.w	#$2c,-(a7)
		trap	#1
		addq.l	#2,a7
		move.w	d0,d1
		rol.w	#5,d1
		andi.w	#$1f,d1
		bsr.s	L7712
		move.b	#$3a,(a3)+
		move.w	d0,d1
		lsr.w	#5,d1
		andi.w	#$3f,d1
		bsr.s	L7712
		move.b	#$3a,(a3)+
		move.w	d0,d1
		andi.w	#$1f,d1
		add.w	d1,d1

L7712:
		swap	d1
		clr.w	d1
		swap	d1
		divu	#$a,d1
		addi.b	#$30,d1
		move.b	d1,(a3)+
		swap	d1
		addi.b	#$30,d1
		move.b	d1,(a3)+
		rts

L772c:
		addq.l	#1,d1
		andi.b	#$fe,d1
		move.l	d1,d0
		add.l	25128(a6),d0
		cmp.l	25132(a6),d0
		bcc.s	l774e
		movea.l	25128(a6),a0
		add.l	d1,25128(a6)
		move.l	a0,25124(a6)
		moveq	#-1,d0
		rts
	l774e:	moveq	#0,d0
		rts

L7752:
		cmpa.l	25124(a6),a0
		bne.s	l7760
		move.l	a0,25128(a6)
		clr.l	25124(a6)
	l7760:	rts

L7762:
		lea	22(a1),a0
		moveq	#0,d0
		move.b	(a0)+,d0
		lea	-1(a0,d0.w),a1
		clr.b	(a1)
		move.l	a1,-(a7)
		bsr.s	L7782
		movea.l	(a7)+,a1
		move.b	#$b,(a1)
		tst.l	d4
		*eori	#$4,ccr
		rts

L7782:
		move.l	a0,-(a7)
		bsr.w	L748a
		movea.l	(a7)+,a0
		beq.s	L77d4
		move.l	a0,-(a7)
		movea.l	24870(a6),a1
	l7792:	move.b	(a0)+,(a1)+
		bne.s	l7792
		lea	24874(a6),a0
		bsr.s	L77d4
		movea.l	(a7)+,a0
		tst.l	d4
		beq.s	l77a4
		rts
	l77a4:	lea	1780(a6),a1
		tst.w	(a1)
		beq.s	L77d4
		addq.l	#1,a1
	l77ae:	move.l	a0,-(a7)
		lea	25136(a6),a2
	l77b4:	move.b	(a1)+,(a2)+
		bne.s	l77b4
		subq.l	#1,a2
	l77ba:	move.b	(a0)+,(a2)+
		bne.s	l77ba
		move.l	a1,-(a7)
		lea	25136(a6),a0
		bsr.s	L77d4
		movea.l	(a7)+,a1
		movea.l	(a7)+,a0
		tst.l	d4
		bne.s	l77d2
		tst.b	(a1)
		bne.s	l77ae
	l77d2:	rts

L77d4:
		clr.w	-(a7)
		move.l	a0,-(a7)
		move.w	#$3d,-(a7)
		trap	#1
		addq.l	#8,a7
		moveq	#0,d4
		tst.l	d0
		bmi.s	l780e
		move.l	d0,d4
		move.w	#$2,-(a7)
		move.w	d4,-(a7)
		clr.l	-(a7)
		move.w	#$42,-(a7)
		trap	#1
		lea	10(a7),a7
		move.l	d0,-(a7)
		clr.w	-(a7)
		move.w	d4,-(a7)
		clr.l	-(a7)
		move.w	#$42,-(a7)
		trap	#1
		lea	10(a7),a7
		move.l	(a7)+,d1
	l780e:	rts

L7810:
		move.w	d2,-(a7)
		move.w	#$3e,-(a7)
		trap	#1
		addq.l	#4,a7
		rts

L781c:
		move.l	a0,-(a7)
		move.l	d1,-(a7)
		move.w	d2,-(a7)
		move.w	#$3f,-(a7)
		trap	#1
		lea	12(a7),a7
		move.l	d0,d1
		moveq	#0,d0
		rts
		dc.b	$2f,$4,$61,$0,$ff,$4c,$24,$1,$26,$4,$4c,$df,$0,$10,$a,$3c
		dc.b	$0,$4,$4e,$75

L7846:
		move.w	d3,-(a7)
		move.w	#$3e,-(a7)
		trap	#1
		addq.l	#4,a7
		rts
		dc.b	$2f,$8,$2f,$1,$3f,$3,$3f,$3c,$0,$3f,$4e,$41,$4f,$ef,$0,$c
		dc.b	$4e,$75

L7864:
		lea	1698(a6),a1
		move.b	(a0),d0
		beq.s	l7872
		cmp.b	#$2e,d0
		bne.s	l7898
	l7872:	move.l	a1,d2
	l7874:	tst.b	(a1)+
		bne.s	l7874
		subq.l	#1,a1
		sub.l	a1,d2
		neg.l	d2
		tst.b	d0
		bne.s	l7886
		bsr.w	L5c44
	l7886:	cmp.b	#$52,d2
		beq.s	l7894
		addq.b	#1,d2
		move.b	(a0)+,d1
		move.b	d1,(a1)+
		bne.s	l7886
	l7894:	lea	1698(a6),a0
	l7898:	clr.w	-(a7)
		move.l	a0,-(a7)
		move.w	#$3c,-(a7)
		trap	#1
		addq.l	#8,a7
		tst.l	d0
		bmi.s	l78ac
		move.l	d0,d2
		moveq	#0,d0
	l78ac:	rts

L78ae:
		tst.l	d1
		beq.s	l78d0
		movem.l	d1-2,-(a7)
		move.l	418(a6),d2
		move.l	a0,-(a7)
		move.l	d1,-(a7)
		move.w	d2,-(a7)
		move.w	#$40,-(a7)
		trap	#1
		lea	12(a7),a7
		movem.l	(a7)+,d1-2
		cmp.l	d0,d1
	l78d0:	rts

L78d2:
		clr.w	-(a7)
		move.w	420(a6),-(a7)
		move.l	d2,-(a7)
		move.w	#$42,-(a7)
		trap	#1
		lea	10(a7),a7
		rts

L78e6:
		tst.b	451(a6)
		bne.s	l7902
		move.l	25132(a6),d0
		sub.l	25128(a6),d0
		cmp.l	#$7d00,d0
		bcs.s	l7902
		asr.l	#1,d0
		cmp.l	d0,d1
		bcs.s	l7904
	l7902:	move.l	d2,d1
	l7904:	rts

L7906:
		dc.b	$0,$0,$79,$6
