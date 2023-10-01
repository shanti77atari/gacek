//kolizje

scr_ad_m
		:26 dta b(<[obraz-8+48*#])
scr_ad_s
		:26 dta b(>[obraz-8+48*#])
		
.local cl

sprite0x=pom0d
sprite0y=pom0e

sprawdzXY
		tya
		lsr
		bcs @+
		lsr
		bcs sprawdz_lewo_gacek
		bcc sprawdz_prawo_gacek
		
@		lsr
		bcs sprawdz_nad_gackiem
		jmp sprawdz_pod_gackiem		


sprawdz_osX
		lda pom0h
		bmi sprawdz_lewo_gacek

sprawdz_prawo_gacek
		lda sprite0x
		cmp #POSX_MAX+1
		bcc *+5
		lda #0
		rts
		
		adc #6
		jmp spr_l1

sprawdz_lewo_gacek
		lda sprite0x
		cmp #POSX_MIN
		bcs *+5
		lda #0
		rts
		
		adc #2-1
spr_l1		
		:2 lsr
		tay
		
		lda sprite0y
		:3 lsr
		stx pom0h
		tax
		dex
		dex
		clc
		tya
		adc scr_ad_m,x 
		sta pom4
		lda scr_ad_s,x
		adc #0
		sta pom4+1
		ldx pom0h
		
		ldy #0
		lda (pom4),y
		lsr
		cmp #$60
		bne *+3
		rts
		ldy #48
		lda (pom4),y
		lsr
		cmp #$60
		bne *+3
		rts
		lda sprite0y
		and #7				;gdy przesuniecie =0 to sprawdz 2 bajty
		bne *+5
		lda #1
		rts
		ldy #96
		lda (pom4),y
		lsr
		cmp #$60
		rts
		
		
		

sprawdz_nad_gackiem
		lda sprite0y
		cmp #POSY_MIN
		bcs *+5
		lda #0
		rts
		
		;sec
		sbc #16
		bit bit2
		bne *+5
		lda #1
		rts
		
		:3 lsr
		stx pom0h
		tax
		lda scr_ad_m,x
		sta pom4
		lda scr_ad_s,x
		sta pom4+1
		ldx pom0h
		
		clc
		lda sprite0x
		adc #2
		:2 lsr
		tay
		lda (pom4),y
		lsr
		cmp #$60
		bne *+3
		rts
		iny
		lda (pom4),y
		lsr
		cmp #$60
		rts		

sprawdz_osY
		lda pom0h
		bmi sprawdz_nad_gackiem

sprawdz_pod_gackiem
		lda sprite0y
		cmp #POSY_MAX+1
		bcc *+5
		lda #0
		rts
		sbc #0
		bit bit12			;zamiast bit012
		beq *+4
		clc
		rts		
		
		:3 lsr
		stx pom0h
		tax
		lda scr_ad_m,x
		sta pom4
		lda scr_ad_s,x
		sta pom4+1
		ldx pom0h
		
		clc
		lda sprite0x
		adc #2
		:2 lsr
		tay
		lda (pom4),y
		lsr
		cmp #$60
		bne *+3
		rts
		iny
		lda (pom4),y
		lsr
		cmp #$60
		sec
		rts
		


		
player_vs_enemy
		lda after_paraliz
		beq @+
		dec after_paraliz
@		equ *

		ldy #7
		lda sprite_x
		clc
		adc #4
		sta _pp0+1
		lda sprite_y
		adc #12+1	;bo c=0
		sta _pp1+1	
		sec
	
_pp0		
@		lda #0		;sprite_x
		sbc sprite_x,y
		;clc
		;adc #4
		cmp #9
		bcs @+
_pp1		
		lda #0		;sprite_y
		sbc sprite_y,y
		;clc
		;adc #12
		cmp #25
		bcc @+1
		
@		dey
		bne @-1
		rts

@		lda sprite_anim_speed,y
		beq @-1							;to bonus, a nie przeciwnik
		
		cpy #7
		jeq @+1	

	
		lda licznik_paraliz
		ora licznik_paraliz+1
		jeq @+
		
		
		dec licznik_extra
		bne le0
		mva #LICZNIK_EXTRA_START licznik_extra
		lda random_extra
		lsr
		ora #3
		sta random_extra
le0		equ *		
		
		
		;mva #0 sprite_x,y
		mva #80 sprite_licznik,y			;czas wyswietlania bonus
		mva #0 sprite_anim_speed,y
		sta ai.ruch,y
		
		mva #$02 sprite_c0,y
		mva #$0c sprite_c1,y
		
		lda sprite_typ,y
		cmp #t_ptak
		bne pe0
		
		dec ile_ptakow
_ptak50	mva #50 licznik_ptak
		jmp pe1
		
pe0		
		dec ile_enemy
		mva ai.czekanie1 ai.czekanie
		
pe1		
		ldx ile_paraliz
		lda paraliz_score_tab,x
		sta pom0
		inc ile_paraliz
		ldx bonus
pe10		
		lda pom0
		jsr score_add
		lda pom0
		jsr score_add
		dex
		bpl pe10
		
		lda ile_paraliz
		clc
		adc #87
		sta sprite_shape,y
		sta sprite_anim,y
		ldx bonus
		beq pe10a
		txa
		adc #96
pe10a	sta sprite_mask,y			;ustawienie animacji bonusu za paraliz		
		
		ldy #fx_literka
		lda #2
		jsr sfx.add_fx  
		
		lda ile_enemy
		ora ile_ptakow
		bne pe2
		
		lda #0
		sta licznik_paraliz
		sta licznik_paraliz+1
		
		ldx level_melody
		lda tab_melody,x
		jsr rmt_init0				

pe2		
		rts
		
@		equ *	//enemy	
		lda sprite_typ,y
		cmp #t_none						;wybuch nie zabija
		beq pe2
		lda after_paraliz				;po zakończniu paraliżu przez chwile jestesmy niesmiertelni
		bne pe2
		
		mva #1 death
		mva #shp_jspada sprite_shape
		sta sprite_shape0
		mva #2 sprite_anim
		mva #7 sprite_anim_speed
		mva #1 sprite_mask
		jsr rmt_silence
		mva #$28 audctl
		mva #$3d audf3
		mva #$ab audf4
		mva #$a1+2 audc3
		sta audc4
		rts
		
		//literka
@		;mva #0 sprite_x,y		;usuń literkę
		;sta ai.ruch,y
		;mva next_bonus licznik_bonus
		
		
		mva #80 sprite_licznik,y			;czas wyswietlania bonus
		mva #0 sprite_anim_speed,y
		sta ai.ruch,y
		mva #$02 sprite_c0,y
		mva #$0c sprite_c1,y
		
		sty pom0
		ldy #fx_literka
		lda #3
		jsr sfx.add_fx
		ldy pom0
				
		lda sprite_typ,y
		cmp #t_bonus
		bne @+
		
		//bonus
		;lda bonus
		;cmp #4
		;beq *+4
		
		
		lda #94
		sta sprite_shape,y
		sta sprite_anim,y
		sta sprite_mask,y	
		
		inc bonus
		
		jsr panel.print_bonus
		
		
		lda #$01
		jmp score_addx100		;dodatkowe 1000 pkt za zebranie literki B.
		
@		cmp #t_extra
		bne @+
		
		//extra life
		mva #255 random_extra
		mva #LICZNIK_EXTRA_START licznik_extra
		mva #0 czy_extra
		lda #96
		sta sprite_shape,y
		sta sprite_anim,y
		sta sprite_mask,y	
		lda #3
		ldy #fx_extra
		jsr sfx.add_fx
		inc lives
		jsr panel.print_lives
		
		lda #$03
		jmp score_addx100

		
@		
		//paraliż
		mva #0 kanal3
		sta audc3
		
		mva #t_none sprite_typ+7
		
		lda kolor_p
		cmp #7
		tax
		adc #87
		sta sprite_shape,y
		sta sprite_anim,y
		sta sprite_mask,y	
		lda paraliz_score0,x
		beq *+5
		jsr score_add
		lda paraliz_score1,x
		beq *+5
		jsr score_addx100
		
		ldy #6
@		lda sprite_x,y
		beq @+
		
		lda sprite_shape,y
		sta buf_shape,y
		lda sprite_shape0,y
		sta buf_shape0,y
		lda sprite_anim_speed,y
		sta buf_anim_speed,y
		lda sprite_anim,y
		sta buf_anim,y
		lda sprite_mask,y
		sta buf_mask,y
		lda sprite_c0,y
		sta buf_c0,y
		lda sprite_c1,y
		sta buf_c1,y
		
		mva #shp_buzka sprite_shape,y
		sta sprite_shape0,y
		mva #3 sprite_anim_speed,y
		mva #4 sprite_anim,y
		mva #3 sprite_mask,y
		mva #$24 sprite_c0,y
		mva #$e8 sprite_c1,y
		
@		dey
		bne @-1
		mva #0 kolor_P
		sta ile_paraliz			;ile zebrano buziek
		
_licznik_paraliz		
		mwa #255 licznik_paraliz
		
;;muzyczka w czasie paralizu

		lda #$7a
		jmp rmt_init0		

paraliz_score_tab	.he 05,10,15,25,40,60
paraliz_score0		.he 10,20,30,50,80,20,00
paraliz_score1		.he 00,00,00,00,00,01,02
		
buf_shape	org *+7
buf_shape0	org *+7
buf_anim_speed	org *+7
buf_anim	org *+7
buf_mask	org *+7
buf_c0		org *+7
buf_c1		org *+7
		
usun_paraliz
		ldy #6
		
@		lda sprite_x,y
		beq @+
		lda sprite_anim_speed,y			;pomin bonus
		beq @+		
		
		lda buf_shape,y
		sta sprite_shape,y
		lda buf_shape0,y
		sta sprite_shape0,y
		lda buf_anim_speed,y
		sta sprite_anim_speed,y
		lda buf_anim,y
		sta sprite_anim,y
		lda buf_mask,y
		sta sprite_mask,y
		lda buf_c0,y
		sta sprite_c0,y
		lda buf_c1,y
		sta sprite_c1,y
		
@		dey
		bne @-1

_after_paraliz		
		mva #40 after_paraliz
		ldx level_melody
		lda tab_melody,x
		jsr rmt_init0

		rts

animuj_death
		lda death
		cmp #1
		bne ad_1
			
		
		mva #2 pom0
		
@		lda sprite_x
		sta sprite0x
		ldy sprite_y
		iny
		sty sprite0y
		
		jsr sprawdz_pod_gackiem
		beq @+
		
		inc sprite_y
		dec pom0
		bne @-
		
		rts
		
@		inc death
		mva #50 licznik_death
		mva #shp_jupada sprite_shape
		sta sprite_shape0
		mva #15 sprite_anim_speed		;po upadku wolniejszy ruch
		mva #$39 audf3
		mva #$50 audf4
		rts

ad_1	
		dec licznik_death
		beq @+1
		lda licznik_death
		cmp #40
		bne @+
		jsr rmt_silence
@		rts

@		dec lives
		bmi ad_gameover
		
ad_2		

		jsr rmt_silence
		mva #0 audctl
		jsr init_level1
		mva #124 sprite_x
		mva #$58 sprite_y
		mva #0 ruch_poziom
		sta czy_extra
		sta ile_score
		;:4 sta hposm0+#
		mva #1 spadanie		;koniec ekranu , zaczyna się spadanie
		mva #joy.LEN_SPADANIE	predkosc_spadanie
		mva #shp_jdol_srodek sprite_shape
		mva #30 ai.czekanie
		ldx #$e0
		jsr multi.init_sprite2+2
		jmp napisy.start
		


		
ad_gameover		//game over
		pla
		pla
		
		lda #$73
		jsr rmt_init0
		
		jsr wait_vbl
		
		ldx #$e0
		jsr multi.init_sprite2+2	;czysci duszki
		mva #$ff sizems
		
		jsr bomb.zgas_bombe
		
		sec
		lda sprite_x
		sbc #12
		sta sprite_x
		
		
go1		jsr wait_vbl
		jsr rmt_play0
		
		mva sprite_x hposp0s
		sta hposm0s
		clc
		adc #8
		sta hposp1s
		sta hposm1s
		adc #8
		sta hposp2s
		sta hposm2s
		adc #8
		sta hposp3s
		sta hposm3s
		
		jsr change_colors
		
		ldx sprite_y
		ldy #0
		mva #0 sprites+$300-1,x
		
@		lda text0,y
		sta sprites+$400,x			;rysuj napis
		lda text0+16,y
		sta sprites+$500,x
		lda text0+32,y
		sta sprites+$600,x
		lda text0+48,y
		sta sprites+$700,x
		lda #$ff
		sta sprites+$300,x
		inx
		iny
		cpy #16
		bcc @-
		mva #0 sprites+$300,x
		
		lda sprite_x
		cmp #112
		beq @+
		bcc _plus
		dec sprite_x
		dec sprite_x
_plus	inc sprite_x
		jmp go2
		
@		lda sprite_y
		cmp #116
		beq go3
		bcc _plusy
		dec sprite_y
		dec sprite_y
_plusy	inc sprite_y		
		
		
go2		jmp go1
		

go3		mva #0 zegar
@		jsr wait_vbl
		jsr rmt_play0
		jsr change_colors
		lda zegar
		cmp #250
		bcc @-
		
game_over1		
		jsr wait_vbl
		mva #0 dmactl
		sta sizems
		
		
		ldy #41
@		lda panel_adr+48,y		;skopiuj hiscore
		sta title0-17,y
		dey
		cpy #35
		bne @-
		
		jsr sprawdz_wynik
		
		lda pom0a
		bpl *+5
		jmp tit0
		
		jsr wait_vbl
		mwa #dli2 dliv
		mwa #vblk1 vbiv
		jsr multi.hide_sprite
		jsr multi.init_sprite2
		
		mva #0 wpis+10
		sta wpis+11
		sta wpis+12
		
		mva #108-12 hposp0
		mva #3 sizep0
		
		ldy pom0a
		lda tab_dl+1,y
		and #$f0
		ora #$02
		sta pom0e		
		
		ldy pom0a
		ldx tab_w1,y
		
		lda #$e0
		ldy #8
@		sta sprites+$400,x
		inx
		dey
		bne @-		
		
		jsr wait_vbl
		
		lda #$8f
		jsr rmt_init0
		
		mwa #dlist_highscore dlptr
		mva #>znaki1 chbase
		mva #39 dmactl
		mva #0 colbak
		
		

		

		
		
		lda pom0a
		:5 asl
		adc #11-3
		adc #<highscore
		sta pom
		lda #>highscore
		adc #0
		sta pom+1
		
		lda pom0a
		:3 asl
		adc #<wyniki
		sta pom1
		lda #>wyniki
		adc #0
		sta pom1+1
		
		mva #1 pom0b
		ldy #0
		sty pom0d
		lda trig0
		sta pom0c
		
		
		
		mva #1 muza0
	
		
j0		
		lda pom0b
		sta (pom1),y	
		ora #$20
		sta wpis+10,y
		ora #$a0
		sta (pom),y


		jsr wait_vbl
		lda pom0d
		beq @+1

		ldx #5
@		jsr wait_vbl
		dex
		bne @-
		
@		mva #0 pom0d		
		
			
		lda porta
		and #8
		bne @+
		
		inc pom0d
		inc pom0b
		lda pom0b
		cmp #27
		bne j1
		lda #1
		sta pom0b
		jmp j1
		
@		lda porta
		and #4
		bne j1
		
		inc pom0d
		dec pom0b
		bne j1
		lda #26
		sta pom0b
		
j1		equ *
		lda trig0
		cmp pom0c
		sta pom0c
		beq j0
		cmp #0
		bne j0
		
		inc pom0d
		iny
		cpy #3
		bcc j0
		
		ldx #100
@		jsr wait_vbl
		dex
		bne @-
		
		jsr wait_vbl
		mva #0 dmactl
		sta muza0

		jmp tit0

tab_w1	.he 60,6b,76,81,8c		
tab_w	dta 32,24,16,8		
		
sprawdz_wynik
		ldx #0
		ldy #0
		
@		sec
		lda wyniki+5,x
		sbc score
		lda wyniki+4,x
		sbc score+1
		lda wyniki+3,x
		sbc score+2
		bcc @+
		iny
		tya
		:3 asl
		tax
		cpy #5
		bcc @-
		lda #255
		sta pom0a
		rts

@		cpy #4
		beq @+1
		ldx #31
		lda tab_w,y
		sta pom0
@		lda wyniki,x
		sta wyniki+8,x
		dex
		dec pom0
		bne @-
		
@		tya
		:3 asl
		tax
		lda score
		sta wyniki+5,x
		lda score+1
		sta wyniki+4,x
		lda score+2
		sta wyniki+3,x
		lda #$8f
		sta wyniki,x
		sta wyniki+1,x
		sta wyniki+2,x
		lda round
		sta wyniki+7,x
		sty pom0a
		
		jmp przepisz_highscore
		
		
		
print_wynik
		lda wyniki,x
		and #$0f
		ora #$90
		sta (pom),y
		dey
		lda wyniki,x
		:4 lsr
		ora #$90
		sta (pom),y
		dey
		dex
		rts
		
print_litera
		lda wyniki,x
		bpl @+
		lda #$8e
		bne *+4
@		ora #$a0
		sta (pom),y
		dey
		rts
		
przepisz_highscore
		mwa #(highscore+8) pom

		mva #5 pom0
		ldx #7
	
@		ldy #19
		jsr print_wynik
		dex
		ldy #12
		jsr print_wynik
		jsr print_wynik
		jsr print_wynik
		ldy #2
		jsr print_litera
		dex
		jsr print_litera
		dex
		jsr print_litera
		
		txa
		clc
		adc #8+7
		tax
		
		lda #32
		jsr add_pom

		dec pom0
		bne @-
		
		rts
		
		
		
		
		
text0	.he 00,7c,c6,c0,ce,c6,7c,00,00,7c,c6,c6,c6,c6,7c,00	;G/O
		.he 00,7c,c6,fe,c6,c6,c6,00,00,c6,c6,c6,c6,7c,38,00	;A/V
		.he 00,c6,fe,d6,d6,c6,c6,00,00,fe,c0,fc,c0,c0,fe,00	;M/E
		.he 00,fe,c0,fc,c0,c0,fe,00,00,fc,c6,fc,c6,c6,c6,00	;E/R		

change_colors	
		clc
		lda zegar
		and #$fc
		sta colpm0s			;kolor
		adc #$20
		sta colpm1s
		adc #$20
		sta colpm2s
		adc #$20
		sta colpm3s	
		rts		
		
.endl