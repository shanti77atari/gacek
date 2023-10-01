//przerwania
zestaw		org *+32
level_cn	
			:32 .he 1e
level_cv	org *+32
			
			.align
dli			sta regA
			stx regX

			ldx licznik
			cpx #28
			bcc @+
			
dli_std
			lda #0
			sta colbak
			sta wsync
			
			sta colpf1
			mva #>znaki1 chbase
			;mva #0 colpf1			;kolory belki
			mva #1+32+16 gtiactl
			mva #$0f colpf2
			mva #$58 hposp1
_posp0		mva #$70 hposp0
_posp2		mva #$90 hposp2
			mva #$b0 hposp3
			mva #$30 hposm0
			mva #$38 hposm1
			mva #$40 hposm2
			mva #3 sizep0
			sta sizep2
			sta sizep3
			mva #$ff sizem
			lda zegar
			and #$f4
			ora #$08
			sta colpm1
_colpm0		mva #$36 colpm0
_colpm2		mva #$e6 colpm2
			mva #$86 colpm3
_colscore	mva #$98 colpf3
			jmp dli_end	
			
@			
			lda zestaw-2,x
			sta chbase			
_dl0		lda #$ff
_dl1		sta colpf0
					
			
@			lda blok_x01,x			;player 0 i 1
			beq @+
			sta hposp1
			sta hposp0
			lsr
			beq @+
			lda blok_c1,x
			sta colpm1
			lda blok_c0,x
			sta colpm0
			
			
			
@			lda blok_x23,x			;player 2 i 3
			beq @+
			sta hposp3
			sta hposp2
			lsr
			beq @+
			lda blok_c3,x
			sta colpm3	
			lda blok_c2,x
			sta colpm2
						

@			lda #0	
			sta blok_x01,x
			sta blok_x23,x
			;sta blok_status,x
		
			inc licznik
			lda level_cn-2,x
			sta _dl1+1
			lda level_cv-2,x
			sta _dl0+1
			
dli_end	
			ldx regX
			lda regA
irq			rti

nmi			bit nmist
			bpl *+5
			jmp (dliv)
			jmp (vbiv)

vblk		pha

			lda #>znaki
			sta chbase
licznik_start			
			mva #2 licznik
			mva kolor_tlo colbak
 			mva kolor0 colpf0
			mva kolor1 colpf1
			mva kolor2 colpf2
			mva kolor3 colpf3		;#$0f colpf3
			lda #$1e
			sta _dl1+1
			
			
			mva #0 hposp1
sizep0s		equ *+1
			lda #0
			sta sizep0
sizep1s		equ *+1
			lda #0
			sta sizep1			
sizep2s		equ *+1
			lda #0
			sta sizep2
sizep3s		equ *+1
			lda #0
			sta sizep3	
sizems		equ *+1			
			mva #0 sizem
			
hposp0s		equ *+1			
			mva #0 hposp0
hposp1s		equ *+1			
			mva #0 hposp1						
hposp2s		equ *+1
			mva #0 hposp2
hposp3s		equ *+1
			mva #0 hposp3
			
colpm0s		equ *+1			
			lda #0
			sta colpm0
colpm1s		equ *+1			
			lda #0
			sta colpm1			
colpm2s		equ *+1			
			lda #0
			sta colpm2
colpm3s		equ *+1
			lda #0
			sta colpm3
			
hposm0s		equ *+1
			lda #0
			sta hposm0
hposm1s		equ *+1
			lda #0
			sta hposm1
hposm2s		equ *+1
			lda #0
			sta hposm2
hposm3s		equ *+1
			lda #0
			sta hposm3			
			
			
gtiactls	equ *+1
			lda #0
			sta gtiactl
			
			pla
			
			inc zegar
			rti
			
dli1		sta regA
			stx regX
			
			inc licznik
			ldx licznik
			bne @+

			lda zegar
			:2 lsr
			and #7
_col0		equ *+1			
			ora #$38
			sta colpf2
			lda zegar
			and #$1f
			bne dl0
			clc
			lda _col0
			adc #$10
			sta _col0
dl0			
			jmp dli_end
			
@			cpx #1
			bne @+
			
			mva #$ec colpf2
			jmp dli_end
			
@			cpx#2
			bne @+
			
			mva #$0e colpf2
			mva #06 colpf1
			
			jmp dli_end
			
@			cpx #3
			bne @+
			
			mva #$3c colpf2
			mva #$02 colpf1
			jmp dli_end
			
@			cpx #4
			bne @+
			mva #$02 colpf1
			mva #$0e colpf2
			jmp dli_end
			
			
@			cpx #5
			bne @+
			sta wsync
			mva #0 colbak
			mva #$9c colpf2
			mva #$94 colpf1
			sta wsync
			mva #$3b dmactl
			mva #0 colbak
			
			jmp dli_end
			
@			
			sta wsync
			mva #$39 dmactl
			mva #$06 colbak
			sta wsync
			mva #$0e colpf2
			mva #$02 colpf1
			jmp dli_end
			
dli2		sta regA
			stx regX
			
			inc licznik
			ldx licznik
			bne @+

			mva #$3b dmactl
			mva #$2c colpf2			;title
			mva #$00 colpf1
			
			jmp dli_end
			
@			cpx #1
			bne @+

			mva #>(znaki1+2) chbase
			lda zegar
			lsr 
			ora #2
			sta colpf0
			jmp dli_end
			
@			mva #$39 dmactl
			mva #>znaki1 chbase
			lda tab_dl-1,x
			sta colpf2
			lda zegar
			lsr
			and #$0c
			ora pom0e
			sta colpm0
			
			jmp dli_end			
			
			
tab_dl		.he 00,5c,6c,7c,8c,9c			
			
vblk1		pha
			inc zegar
			mva #255 licznik
vblk11			
			lda muza0
			beq @+
			txa
			pha
			tya
			pha
			jsr rmt_play0
			pla
			tay
			pla
			tax
@			equ *			

			pla
			rti

			
			