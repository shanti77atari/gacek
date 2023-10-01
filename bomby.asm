//obsługuje bomby
bomba_x				org *+24
bomba_y				org *+24
bomba_anim_licznik	org *+24
bomba_anim_licznik1	org *+24
bomba_m_scr			org *+24
bomba_s_scr			org *+24
bomba_anim_faza		org *+24
bomba_anim_typ		org *+24
bomba_zapalona		org *+24
bomba_ch0			org *+24
bomba_ch1			org *+24
bomba_ch2			org *+24
bomba_ch3			org *+24
bomba_score_licznik	org *+24


BOMBA_ANIM_SPEED=8
MAX_BOMB=24-1

//tablica z nr znaków, po 4 na kazda faze animacji
tab_anim0		
				dta ch_bomb0,ch_bomb0+1,ch_bomb0+2,ch_bomb0+3,ch_bomb0+4,ch_bomb0+5,ch_bomb0+6,ch_bomb0+7,ch_bomb0+8,ch_bomb0+9,ch_bomb0+10,ch_bomb0+11,ch_bomb0+12,ch_bomb0+13,ch_bomb0+14,ch_bomb0+15		;zwykła bomba 4fazy x 4znaki na niebieskim tle
				dta ch_bomb1,ch_bomb1+1,ch_bomb1+2,ch_bomb1+3,ch_bomb1+4,ch_bomb1+5,ch_bomb1+6,ch_bomb1+7,ch_bomb1+8,ch_bomb1+9,ch_bomb1+10,ch_bomb1+11,ch_bomb1+12,ch_bomb1+13,ch_bomb1+14,ch_bomb1+15		;zwykła bomba 4fazy x 4znaki na brazowym tle
				dta ch_bomb0,ch_bomb0+1,ch_bomb0+2,ch_bomb0+3,ch_bomb2,ch_bomb2+1,ch_bomb2+2,ch_bomb2+3,ch_bomb0,ch_bomb0+1,ch_bomb0+2,ch_bomb0+3,ch_bomb0,ch_bomb0+1,ch_bomb0+2,ch_bomb0+3					;biala bomba na niebieskim tle
				dta ch_bomb1,ch_bomb1+1,ch_bomb1+2,ch_bomb1+3,ch_bomb3,ch_bomb3+1,ch_bomb3+2,ch_bomb3+3,ch_bomb1,ch_bomb1+1,ch_bomb1+2,ch_bomb1+3,ch_bomb1,ch_bomb1+1,ch_bomb1+2,ch_bomb1+3					;biala bomba na brazowym tle
				
			

.local bomb			

//gasi bonus po pewnym czasie
zgas_bonus
				ldx #MAX_BOMB
@				lda bomba_score_licznik,x
				beq @+
				dec bomba_score_licznik,x
				bne @+ 
				jsr zmaz_bombe
				dec ile_score
@				dex
				bpl @-1
				rts
				
zgas_bombe
				ldx #MAX_BOMB
@				lda bomba_x,x
				beq @+
				lda bomba_zapalona,x
				beq @+
				
				lda bomba_m_scr,x
				sta pom
				lda bomba_s_scr,x
				sta pom+1
				
				mva #0 bomba_zapalona,x
				sta bomba_anim_faza,x				
				lda bomba_anim_typ,x
				eor #$20
				sta bomba_anim_typ,x
				mva #BOMBA_ANIM_SPEED bomba_anim_licznik,x
				
				lda bomba_anim_typ,x
				tax
				ldy #0
				lda tab_anim0,x
				sta (pom),y
				iny
				lda tab_anim0+1,x
				sta (pom),y
				ldy #48
				lda tab_anim0+2,x
				sta (pom),y
				iny
				lda tab_anim0+3,x
				sta (pom),y
								
				rts
				
@				dex
				bpl @-1
				rts
				
animuj_bomby
				ldx #MAX_BOMB
@				lda bomba_x,x
				bne @+
ab0				dex
				bpl @-
				rts

@				ldy bomba_zapalona,x
				bne @+
				dec bomba_anim_licznik1,x
				lda bomba_anim_licznik1,x
				cmp #32
				bcs ab0
@				dec bomba_anim_licznik,x			;czy animujemy ta bombke
				bne ab0
				lda #BOMBA_ANIM_SPEED
				cpy #0
				beq *+3
				lsr
				sta bomba_anim_licznik,x		;ustaw ponownie licznik
				lda bomba_m_scr,x
				sta pom
				lda bomba_s_scr,x
				sta pom+1
						
				dec bomba_anim_faza,x
				lda bomba_anim_faza,x
				asl
				asl
				and #%1100
				ora bomba_anim_typ,x		;typ animacji 0=zwykly,16-inne tlo, 32=migajaca bomba
				stx pom0			;zapamietaj indeks bomby
				tax
				ldy #0
				lda tab_anim0,x
				sta (pom),y
				iny
				lda tab_anim0+1,x
				sta (pom),y
				ldy #48
				lda tab_anim0+2,x
				sta (pom),y
				iny
				lda tab_anim0+3,x
				sta (pom),y
				ldx pom0
				jmp ab0
				

				

//rysuje bombe w pozycji y,x a=0->niebieskie tlo,a>0->brazowe tlo		
rysuj_bombe
			pha
			clc
			tya
			adc obr_m,x
			sta pom
			pha
			lda obr_s,x
			adc #0
			sta pom+1
			ldx pom0a
			sta bomba_s_scr,x
			pla
			sta bomba_m_scr,x

_negatyw0	equ *+1
			lda #0
			ora #ch_bomb0
			tax
			pla
			beq	*+7
_negatyw1	equ *+1			
			lda #0
			ora #ch_bomb1
			tax
						
			ldy #0
			lda (pom),y
			pha
			txa
			sta (pom),y
			inx
			iny
			lda (pom),y
			pha
			txa
			sta (pom),y
			inx
			ldy #48
			lda (pom),y
			pha
			txa
			sta (pom),y
			inx
			iny
			lda (pom),y
			pha
			txa
			sta (pom),y
			ldx pom0a
			pla
			sta bomba_ch3,x
			pla
			sta bomba_ch2,x
			pla
			sta bomba_ch1,x
			pla
			sta bomba_ch0,x
			mva #0 bomba_score_licznik,x
			
			rts

dec_paraliz
			sta _dp0+1
			lda paraliz_flag
			bne @+
			lda sprite_typ+7			
			cmp #t_paraliz
			beq @+
			lda licznik_paraliz
			ora licznik_paraliz+1
			bne @+
			sec
			lda licznik1_paraliz
_dp0		sbc #1
			sta licznik1_paraliz
			bcc @+1
@			rts

@			
			mva #1 paraliz_flag				;zezwol na paraliz
			mva #19 licznik1_paraliz		;zeruj licznik
			rts

nie_zapalona	
			lda #1
			jsr dec_paraliz
			
			lda #2
			ldy #fx_bomba
			jsr sfx.add_fx
			ldx pom0
			
			ldy bonus
			lda score_tab0,y
			jsr score_add

zmaz_bombe					
			lda bomba_m_scr,x
			sta pom
			lda bomba_s_scr,x
			sta pom+1
					
			ldy #0
			lda bomba_ch0,x
			sta (pom),y
			iny
			lda bomba_ch1,x
			sta (pom),y
			ldy #48
			lda bomba_ch2,x
			sta (pom),y
			iny
			lda bomba_ch3,x
			sta (pom),y
			
			lda ile_bomb
			beq @+			
			lda czy_zapalona
			beq *+3
@			rts
			inc czy_zapalona
			jmp zapal_bombe

			
zbieraj_bomby
			ldx #MAX_BOMB
@			lda bomba_x,x
			bne @+
nx_bmb		dex
			bpl @-
			rts
			
@			sec
			sbc sprite_x
			clc
			adc #4
			cmp #9
			bcs nx_bmb
			lda bomba_y,x
			sec
			sbc sprite_y
			clc
			adc #9
			cmp #19
			bcs nx_bmb

			
			
			dec ile_bomb
			mva #0 bomba_x,x			;nie ma juz bomby
			stx pom0
			
			lda bomba_zapalona,x
			beq nie_zapalona
			
			lda #2
			jsr dec_paraliz			
			
			inc ile_zapalonych
			ldy bonus
			lda score_tab,y
			jsr score_add
			cpy #4
			bne *+7
			lda #$50					;1000=2x500
			jsr score_add		
			
			lda bomba_m_scr,x
			sta pom
			lda bomba_s_scr,x
			sta pom+1
			
			
			lda bomba_anim_typ,x
			lsr
			and #8
			clc
			adc #ch_bonus+3
			adc bonus
			ldy #0
			sta (pom),y
			
			pha
			lda bonus
			cmp #4
			beq @+
			pla
			sbc bonus
			pha
			sbc #1
			pha
			sbc #1
			jmp @+1
			
@			pla
			sbc bonus
			sbc #2
			pha
			sbc #1
			pha
			adc #0
			
@			ldy #49
			sta (pom),y
			dey
			pla
			sta (pom),y
			ldy #1
			pla
			sta (pom),y
			
			
			mva #30 bomba_score_licznik,x
			inc ile_score
			
			lda #2
			ldy #fx_bomba1
			jsr sfx.add_fx

			lda ile_bomb
			beq @+1
			
			
;wlaczamy nastepna bombe	
zapal_bombe
			ldx pom0
@			dex
			bpl *+4
			ldx #23
			lda bomba_x,x
			beq @-
			

			
@			mva #1 bomba_zapalona,x
			sta bomba_anim_licznik,x
			mva #2 bomba_anim_faza,x
			lda bomba_anim_typ,x
			ora #32
			sta bomba_anim_typ,x
			
@			rts
			
			
			
score_tab	
			.he 20,40,60,80,50			;punkty dla zapalonej bomby
score_tab0	
			.he 10,20,30,40,50			;punkty dla zwykłej bomby

					
.endl		

score_add
			clc
			sed
			adc score
			sta score
			lda score+1
			adc #0
			sta score+1
			lda score+2
			adc #0
			cld
			sta score +2
			rts
			
score_addx100
			clc
			sed
			adc score+1
			sta score+1
			lda score+2
			adc #0
			cld
			sta score+2
			rts
				