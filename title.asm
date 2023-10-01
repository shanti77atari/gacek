//strona tytułowa
.local tit
text		dta d'GACEK'
text2		dta d'MIKER'
text1		dta d'SHANTI'

bufor1=$500

tab_e		
			.he 01,03,07,0f,1f,3f,7f,ff
			.he ff,fe,fc,f8,f0,e0,c0,80
			
			
cls_txt
			ldx #0
			lda #$ff
@			sta title1b,x
			dex
			bne @-	
			rts		

tab_sha
			dta d'CODE GFX SFX'*
tab_mik	
			dta d'    MUSIC   '*

print_shanti
			ldx #11
@			lda tab_sha,x
			sta title1a+10,x
			dex
			bpl @-

			mva #>znaki1 pom1+1
			lda #$17
			ldx #7
			jsr pr_litera
			lda #$17
			dex
			jsr pr_litera
			inc pom1+1
			dex
@			lda text1,x			;shanti77
			jsr pr_litera
			dex
			bpl @-
			stx pom0h
			
			rts
			
print_miker
			ldx #11
@			lda tab_mik,x
			sta title1a+10,x
			dex
			bpl @-

			mva #>(znaki1+$100) pom1+1
			ldx #4
@			lda text2,x			;miker
			pha
			txa
			asl
			tax
			pla
			jsr pr_litera
			txa
			lsr
			tax
			dex
			bpl @-
			mva #0 pom0h
			
			rts			
			
			
			
title	
			jsr multi.hide_sprite
			jsr multi.init_sprite2
			jsr rmt_silence
			
			lda #$00
			jsr rmt_init0
			
			mva #0 sizep0
			
			jsr cl.przepisz_highscore

			mva #>(znaki1+$100) pom+1
			
			ldx #160
			lda #0
@			sta bufor1-1,x
			dex
			bne @-

			ldx #4
@			lda text,x
			:3 asl
			sta pom
			
			ldy #6
@			lda (pom),y
			jsr wpisz
			dey
			bpl @-
			
			dex
			bpl @-1
			
			
			jsr cls_txt
			jsr print_shanti
					
			
			jsr wait_vbl
			mwa #vblk1 vbiv
			mwa #dli1 dliv
			mwa #dlist_title dlptr
			mva #>znaki1 chbase
			sta colpf1
			mva #$06 colbak
			mva #$5a colpf2
			mva #$00 colpf0	
			mva #0 licznik
			
			mva #1 hscrol
			sta pom0
			sta _t0+1
			
			mva #$30 ile_enemy
			mva #$c8 ile_ptakow
			mwa #title2+4 efekt.tekst
			mva #226 efekt.linia
			mva #$6A colpm0	
			mva #$4a colpm2
			mva #$2a colpm1
			mva #$3a colpm3
			
			mva #1 gtiactl
			

t0			ldx #160
@			lda random
			and #%01010101
			ora bufor1-1,x
			sta title1-1,x
			dex
			lda random
			and #%10101010
			ora bufor1-1,x
			sta title1-1,x
			dex
			bne @-
			
			jsr rmt_play0
			jsr wait_vbl
			mva #$39 dmactl
			
			ldx #1
			lda ile_enemy
			sta hposp0
			jsr efekt.print			
			lda ile_enemy
			clc
			adc #8
			sta hposp2
			ldx #3
			jsr efekt.print
			
			lda ile_enemy
			clc
			adc #1
			cmp #$d0
			bcc *+4
			lda #$30
			sta ile_enemy
			
			ldx #2
			lda ile_ptakow
			sta hposp1
			jsr efekt.print
			lda ile_ptakow
			sec
			sbc #8
			sta hposp3
			ldx #4
			jsr efekt.print
			
			lda ile_ptakow
			sec
			sbc #1
			cmp #$30
			bcs *+4
			lda #$d0
			sta ile_ptakow
			
			ldx #7
			ldy #0
			
@			lda sprites+$4e2,x
			and tab_e,x
			sta sprites+$4e2,x
			lda sprites+$6e2,x
			and tab_e+8,x
			sta sprites+$6e2,x
			
			lda sprites+$5e2,x
			and tab_e+8,y
			sta sprites+$5e2,x
			lda sprites+$7e2,x
			and tab_e,y
			sta sprites+$7e2,x
			
			iny
			dex
			bpl @-
							
			mva pom0 hscrol
			lda zegar
			lsr
			bcc @+1
@			clc
			lda pom0
_t0			adc #1
			and #15
			sta pom0
			bne @+
			lda _t0+1
			eor #$fe
			sta _t0+1
			jmp @-
			
			
			
@			lda trig0
			beq @+
			
			lda zegar
			bne petla
			
			lda pom0h
			bne mik
			
			jsr cls_txt
			jsr print_shanti
			jmp petla		
mik
			jsr cls_txt
			jsr print_miker				
petla			
			jmp t0
			
@			jsr wait_vbl
			mva #0 dmactl
			mwa #dlist0 dlptr
			mwa #vblk vbiv
			mwa #dli dliv
			rts
			
pr_litera
			stx pom0a
			sty pom0b
			:3 asl
			sta pom1
			
			
			ldy #7
@			tya
			:5 asl
			adc pom0a
			adc #12
			tax
			lda (pom1),y
			eor #255
			sta title1b,x
			dey
			bpl @-
			
			ldx pom0a
			ldy pom0b
			rts
			
wpisz
			sta pom0
			stx pom0a
			sty pom0b

			tya
			:2 asl
			sta pom0c
			:2 asl
			adc pom0c
			sta pom0c
			txa
			asl
			adc pom0c
			adc #4
			tax

			ldy #8
@			lda pom0
			asl
			rol bufor1+1,x
			rol bufor1,x
			lda pom0
			asl
			rol bufor1+1,x
			rol bufor1,x
			sta pom0			
			dey
			bne @-
			
			ldx pom0a
			ldy pom0b
			rts

.endl			
