//MULTI
//multiplekser
MAX_SPRITES	equ 8		
POSY_MIN		equ 16
POSY_MAX		equ 208
	
POSX_MIN		equ 64
POSX_MAX		equ 184

					.align
sprite_x			org *+MAX_SPRITES		;pozycja X obiektu
sprite_dx			org *+MAX_SPRITES		;pozycja X po przecinku
sprite_y			org *+MAX_SPRITES
sprite_dy			org *+MAX_SPRITES	
sprite_shape		org *+MAX_SPRITES		;ksztalt obiektu (obecny)
sprite_shape0		org *+MAX_SPRITES		;  -II-         początkowy
sprite_c0			org *+MAX_SPRITES		;kolor 0 obiektu
sprite_c1			org *+MAX_SPRITES		;kolor 1 obiektu
sprite_anim			org *+MAX_SPRITES		;liczba klatek animacji obiektu	(dowolna liczba)
sprite_anim_speed 	org *+MAX_SPRITES		;szybkość animacji obiektu  (1,3,7...)
sprite_mask 		org *+MAX_SPRITES		;maska potrzebna do animacji
sprite_typ			org *+MAX_SPRITES
tab_nr_pary			org *+MAX_SPRITES
tab_duch_dy			org *+MAX_SPRITES
sprite_licznik		org *+MAX_SPRITES

tab_sortowanie	
				:8 dta b(#)
				dta b(8)

blok_status		org *+32	;tablica pomocnicza do ustalenia zajętości duszków
blok_x01		org *+32	;pozycje pary duszków 0 i 1
blok_x23		org *+32	;pozycje pary duszków 2 i 3
blok_c0			org *+32	;kolor duszka 0

				.align
blok_c1			org *+32
blok_c2			org *+32
blok_c3			org *+32	
			
tab_nr_bloku		
				:9 dta b(255)

.local multi
spr_flag	equ pom0a
nr_duszka	equ pom0b
;poz_y		equ pom0c
duch_dy		equ pom0d


animuj
		lda ramka
		sta _em2+1

		ldx #MAX_SPRITES-1
@		lda sprite_x,x
		bne @+
next	dex
		bpl @-
		rts
@				
		lda sprite_anim_speed,x
		bmi next
		beq @+
_em2	and #$ff
		bne next
		
		inc sprite_shape,x
		lda sprite_shape,x
		and sprite_mask,x
		cmp sprite_anim,x
		bcc *+4
		lda #0
		ora sprite_shape0,x
		sta sprite_shape,x
		jmp next
		
@		dec sprite_licznik,x				;czy bonus ma już zniknac?
		beq @+
		ldy sprite_anim,x
		lda ramka
		and #16								;co 4 ramki zmieniamy ksztalt
		beq *+5				
		ldy sprite_mask,x
		tya
		sta sprite_shape,x
		jmp next
	
@			
		mva #0 sprite_x,x		;zakoncz animacje, usun duszka
		jmp next		
		
//inicjalizacja spritów
init_sprite
		lda #1
		tax
@		sta bit0-1,x
		inx
		asl
		bne @-
		mva #%110 bit12
		
init_sprite1	

		mva #MAX_SPRITES-1 start
		
init_sprite2
		ldx #$f9
		lda #0
@		sta sprites+$300,x			;wyczysc duszki
		sta sprites+$400,x
		sta sprites+$500,x
		sta sprites+$600,x
		sta sprites+$700,x
		dex
		bne @-	
			
		rts
		
hide_sprite
		lda #0
		sta hposp0s
		sta hposp0
		sta hposp1s
		sta hposp1
		sta hposp2s
		sta hposp2
		sta hposp3s
		sta hposp3
		sta hposm0s
		sta hposm0
		sta hposm1s
		sta hposm1
		sta hposm2s
		sta hposm2
		sta hposm3s
		sta hposm3
		rts

ile_zmian	dta b(4)

prepare_sprites

		lda #255
		:7 sta tab_nr_bloku+1+#
		ldy #0
		:32 sty blok_status+#

		sty spr_flag
		jsr print_sprite1

		ldy start
@		lda sprite_x,y
		beq @+	
		jsr print_sprite1
@		dey
		bne *+4
		ldy #MAX_SPRITES-1
start	equ *+1		
		cpy #$ff
		bne @-1
		
		ldy klawisz
		lda spr_flag
		beq @+
		dec ile_zmian
		ldy ile_zmian
		bne @+
		sta start
		ldy klawisz
		
@		sty ile_zmian		
		
//sortowanie od najmniejszego do najwyższego
@		mva #0 pom0a
		ldx #6
		
@		ldy tab_sortowanie+1,x
		lda tab_nr_bloku,y
		ldy tab_sortowanie,x
		cmp tab_nr_bloku,y
		bcs @+
		lda tab_sortowanie+1,x
		ldy tab_sortowanie,x
		sta tab_sortowanie,x
		tya
		sta tab_sortowanie+1,x
		inc pom0a
		dex
		
@		dex
		bpl @-1
		lda pom0a
		bne @-2

		rts


//tylko przygotowuje rysowanie
print_sprite1
		lda sprite_y,y		;juz odczytane
		:3 lsr
		tax				;nr pierwszego bloku
		lda sprite_y,y
		and #%111
		sta tab_duch_dy,y

		cmp #2
		bcs *+3
		dex				;jesli dy=0 to zmniejsz nr pierwszego bloku

		lda blok_status,x
		ora blok_status+1,x
		ora blok_status+2,x
		lsr
		bcc @+
		lsr
		bcc @+1
		
		lda spr_flag
		bne *+4
		sty spr_flag
		lda #-1
		sta tab_nr_bloku,y		;nr_bloku=-1(255) oznacza nie rysuj
		
		rts			;nie można narysować duszka
		
		//duszki01
@		inc blok_status,x
		inc blok_status+2,x
		txa
		sta tab_nr_bloku,y
		mva #0 tab_nr_pary,y
		rts
		//duszki23
@       lda #2
		sta tab_nr_pary,y
		ora blok_status,x
		sta blok_status,x
		lda #2
		ora blok_status+2,x
		sta blok_status+2,x
		txa
		sta tab_nr_bloku,y
		rts

//narysuj wszystkie duszki
show_sprites	
		ldy gracz_y1 
		cpy sprite_y
		beq @+
		lda #0
		:16 sta sprites+$300+#,y
		mva sprite_y gracz_y1
	
@		
		clc
		lda sprite_x 
		;sta hposm3			;gracz ma dodatkowy kolor z pocisków
		sta hposm3s
		adc #2
		;sta hposm2
		sta hposm2s
		adc #2
		;sta hposm1
		sta hposm1s
		adc #2
		;sta hposm0
		sta hposm0s
		
		lda #0	
		sta blok_x01+1
		sta blok_x23+1
		sta hposp1s
		sta hposp0s
		sta hposp3s
		sta hposp2s
		
		mva #-1 pom0a
@		inc pom0a
		ldx pom0a
		ldy tab_sortowanie,x
		ldx tab_nr_bloku,y
		bpl *+3
		rts
		lda tab_nr_pary,y
		bne @+
		
		jsr print_sprite01
		lda tab_nr_bloku,y
		cmp #1
		bne @-
		lda blok_x01+1			;player 0 i 1
		sta hposp1s
		sta hposp0s
		lda blok_c0+1
		sta colpm0s
		lda blok_c1+1
		sta colpm1s		
		jmp @-
		
		
@		jsr print_sprite23
		lda tab_nr_bloku,y
		cmp #1
		bne @-1
		
		lda blok_x23+1			;player 2 i 3
		sta hposp3s
		sta hposp2s
		lda blok_c2+1
		sta colpm2s
		lda blok_c3+1
		sta colpm3s
		jmp @-1
		
		




print_sprite01
		lda blok_x01+3,x	
		bne *+5
		inc blok_x01+3,x
				
		lda sprite_x,y		;sprite 0 i 1
		sta blok_x01,x

		lda sprite_c0,y
		sta blok_c0,x
		lda sprite_c1,y
		sta blok_c1,x
		
		ldx sprite_shape,y
		
		lda shape_bank,x
		sta portb

		lda shape_tab01,x
		sta _psp1+1
		lda shape_tab01+128,x
		sta _psp1+2		

		ldx sprite_y,y
_psp1	equ *		
		jsr $ffff

		mva #BANK_off portb
		
		ldx tab_duch_dy,y
		lda tab_skok01,x
		ldx sprite_y,y
		
		sta l01
		lda #0
l01	equ *+1		
		jmp dy0 

print_sprite23
		lda #2
		ora blok_status,x			;zajmij wybranego duszka w statusie
		sta blok_status,x
		lda #2
		ora blok_status+2,x		
		sta blok_status+2,x


		lda blok_x23+3,x
		bne *+5
		inc blok_x23+3,x
						
		lda sprite_x,y			;sprite 2 i 3
		sta blok_x23,x

		lda sprite_c0,y
		sta blok_c2,x
		lda sprite_c1,y
		sta blok_c3,x	
		
		ldx sprite_shape,y
		
		lda shape_bank,x
		sta portb

		lda shape_tab23,x
		sta _psp2+1
		lda shape_tab23+128,x
		sta _psp2+2
		

		ldx sprite_y,y
_psp2	equ *		
		jsr $ffff	

		mva #BANK_off portb
		

		ldx tab_duch_dy,y
		lda tab_skok23,x
		ldx sprite_y,y

		
		sta l23
		lda #0
l23	equ *+1		
		jmp dy0b
/*
//narysuj sprite nr w Y
print_sprite
		lda sprite_y,y		;juz odczytane
		;sta poz_y
		:3 lsr
		tax				;nr pierwszego bloku
		;lda poz_y
		lda sprite_y,y
		and #%111
		sta duch_dy

		cmp #2
		bcs *+3
		dex				;jesli dy=0 to zmniejsz nr pierwszego bloku

		lda blok_status,x
		ora blok_status+1,x
		ora blok_status+2,x
		lsr
		bcc @+
		lsr
		bcc duszki23
		
		lda spr_flag
		bne *+4
		sty spr_flag
		rts			;nie można narysować duszka
		
		
@		inc blok_status,x
		inc blok_status+2,x
		
//ustawienie pozycji i koloru duszków w bloku	
		lda blok_x01+3,x	
		bne *+5
		inc blok_x01+3,x
				
		lda sprite_x,y		;sprite 0 i 1
		sta blok_x01,x

		lda sprite_c0,y
		sta blok_c0,x
		lda sprite_c1,y
		sta blok_c1,x
		
		ldx sprite_shape,y
		
		lda shape_bank,x
		sta portb

		lda shape_tab01,x
		sta _psp1+1
		lda shape_tab01+128,x
		sta _psp1+2		

		ldx sprite_y,y
_psp1	equ *		
		jsr $ffff

		mva #BANK_off portb
		
		ldx duch_dy
		lda tab_skok01,x
		ldx sprite_y,y
		
		sta l01
		lda #0
l01	equ *+1		
		jmp dy0 
		
duszki23
		lda #2
		ora blok_status,x			;zajmij wybranego duszka w statusie
		sta blok_status,x
		lda #2
		ora blok_status+2,x		
		sta blok_status+2,x


		lda blok_x23+3,x
		bne *+5
		inc blok_x23+3,x
						
		lda sprite_x,y			;sprite 2 i 3
		sta blok_x23,x

		lda sprite_c0,y
		sta blok_c2,x
		lda sprite_c1,y
		sta blok_c3,x	
		
		ldx sprite_shape,y
		
		lda shape_bank,x
		sta portb

		lda shape_tab23,x
		sta _psp2+1
		lda shape_tab23+128,x
		sta _psp2+2
		

		;ldx poz_y
		ldx sprite_y,y
_psp2	equ *		
		jsr $ffff	

		mva #BANK_off portb
		

		ldx duch_dy
		lda tab_skok23,x
		;ldx poz_y
		ldx sprite_y,y

		
		sta l23
		lda #0
l23	equ *+1		
		jmp dy0b  */


		.align	
//ksztalty dla duszków		
shape_tab01
		dta b(<bird0a,<bird1a,<bird2a,<bird1a)								;0 ptaszek w lewo
		dta b(<bird3a,<bird4a,<bird5a,<bird4a)								;4 ptaszek góra/dol
		dta b(<bird6a,<bird7a,<bird8a,<bird7a)								;8 ptaszek w prawo
		dta b(<jack_left0a,<jack_left1a,<jack_left2a,<jack_left3a)			;12 jack idzie w lewo
		dta b(<jack_right0a,<jack_right1a,<jack_right2a,<jack_right3a)		;16 jack idzie w prawo
		dta b(<jack_stoi0a,<jack_dol0a,<jack_dol1a,<jack_dol2a)				;20 jack stoi w miejscu,21 dol_srodek,22 dol_prawo,23 dol_lewo
		dta b(<jack_gora0a,<jack_gora1a,<jack_gora2a,0)					;24 jack gora_srodek,25 fora_prawo,26_gora_lewo
		dta b(<jack_spada0a,<jack_spada1a,<jack_upada0a,<jack_upada1a)		;28 jack spada w dol, 30 jack upada na platforme
		dta b(<jack_taniec0a,<jack_taniec1a,<jack_taniec2a,<jack_taniec3a)	;32 jack tanczy,lewo,prawo,gora,dol
		dta b(<radar0a,<radar1a,<radar2a,<radar3a)							;36 radar
		dta b(<ufo0a,<ufo1a,<ufo2a,<ufo3a)									;40 ufo
		dta b(<globus0a,<globus1a,<globus2a,<globus3a)						;44 globus
		dta b(<explo0a,<explo1a,<explo2a,<explo3a)							;48 explo
		dta b(<mumia_spada0a,<mumia_spada1a,0,0)						;52 mumia spada
		dta b(<mumia_lewo0a,<mumia_lewo1a,<mumia_lewo2a,0)				;56 mumia_lewo
		dta b(<mumia_prawo0a,<mumia_prawo1a,<mumia_prawo2a,0)				;60 mumia_prawo
		dta b(<przemiana0a,<przemiana1a,<przemiana2a,<przemiana3a)			;64 przemiana
		dta b(<bonus0a,<bonus1a,<bonus2a,<bonus3a)							;68 bonus B
		dta b(<extra0a,<extra1a,<extra2a,<extra3a)							;72 extra_life E
		dta b(<paraliz0a,<paraliz1a,<paraliz2a,<paraliz3a)					;76 paraliż P
		dta b(<buzka3a,<buzka2a,<buzka1a,<buzka0a)							;80 buzki
		dta b(<oko0a,<oko1a,<oko2a,<oko3a)									;84 oko			
		dta b(<punkty0a,<punkty1a,<punkty2a,<punkty3a,<punkty4a,<punkty5a,<punkty6a,<punkty7a,<punkty8a,<punkty9a,<punkty10a,<punkty11a,<punkty12a)  ;88=100,200,300,500,800,1200,1000,2000,3000 97=x2,x3,x4,x5	
		:3 dta b(0)			;wyrównanie
		dta b(<czapka_lewo0a,<czapka_lewo1a,<czapka_lewo2a,<czapka_lewo1a)		;104 czapka_lewo
		dta b(<czapka_prawo0a,<czapka_prawo1a,<czapka_prawo2a,<czapka_prawo1a)	;108 czapka_prawo
		:16 dta b(0)  

		
;shape_tab
		dta b(>bird0a,>bird1a,>bird2a,>bird1a)								;0 ptaszek w lewo
		dta b(>bird3a,>bird4a,>bird5a,>bird4a)								;4 ptaszek góra/dol
		dta b(>bird6a,>bird7a,>bird8a,>bird7a)								;8 ptaszek w prawo
		dta b(>jack_left0a,>jack_left1a,>jack_left2a,>jack_left3a)			;12 jack idzie w lewo
		dta b(>jack_right0a,>jack_right1a,>jack_right2a,>jack_right3a)		;16 jack idzie w prawo
		dta b(>jack_stoi0a,>jack_dol0a,>jack_dol1a,>jack_dol2a)				;20 jack stoi w miejscu,21 dol_srodek,22 dol_prawo,23 dol_lewo
		dta b(>jack_gora0a,>jack_gora1a,>jack_gora2a,0)					;24 jack gora_srodek,25 fora_prawo,26_gora_lewo
		dta b(>jack_spada0a,>jack_spada1a,>jack_upada0a,>jack_upada1a)		;28 jack spada w dol, 30 jack upada na platforme
		dta b(>jack_taniec0a,>jack_taniec1a,>jack_taniec2a,>jack_taniec3a)	;32 jack tanczy,lewo,prawo,gora,dol
		dta b(>radar0a,>radar1a,>radar2a,>radar3a)							;36 radar
		dta b(>ufo0a,>ufo1a,>ufo2a,>ufo3a)									;40 ufo
		dta b(>globus0a,>globus1a,>globus2a,>globus3a)						;44 globus
		dta b(>explo0a,>explo1a,>explo2a,>explo3a)							;48 explo
		dta b(>mumia_spada0a,>mumia_spada1a,0,0)						;52 mumia spada
		dta b(>mumia_lewo0a,>mumia_lewo1a,>mumia_lewo2a,0)				;56 mumia_lewo
		dta b(>mumia_prawo0a,>mumia_prawo1a,>mumia_prawo2a,0)				;60 mumia_prawo
		dta b(>przemiana0a,>przemiana1a,>przemiana2a,>przemiana3a)			;64 przemiana
		dta b(>bonus0a,>bonus1a,>bonus2a,>bonus3a)							;68 bonus B
		dta b(>extra0a,>extra1a,>extra2a,>extra3a)							;72 extra_life E
		dta b(>paraliz0a,>paraliz1a,>paraliz2a,>paraliz3a)					;76 paraliż P
		dta b(>buzka3a,>buzka2a,>buzka1a,>buzka0a)							;80 buzki
		dta b(>oko0a,>oko1a,>oko2a,>oko3a)									;84 oko	
		dta b(>punkty0a,>punkty1a,>punkty2a,>punkty3a,>punkty4a,>punkty5a,>punkty6a,>punkty7a,>punkty8a,>punkty9a,>punkty10a,>punkty11a,>punkty12a)  ;88=100,200,300,500,800,1200,1000,2000,3000 97=x2,x3,x4,x5		
		:3 dta b(0)			;wyrownanie
		dta b(>czapka_lewo0a,>czapka_lewo1a,>czapka_lewo2a,>czapka_lewo1a)		;104 czapka_lewo
		dta b(>czapka_prawo0a,>czapka_prawo1a,>czapka_prawo2a,>czapka_prawo1a)	;108 czapka_prawo
		:16 dta b(0) 

shape_tab23
		dta b(<bird0b,<bird1b,<bird2b,<bird1b)								;0 ptaszek w lewo
		dta b(<bird3b,<bird4b,<bird5b,<bird4b)								;4 ptaszek góra/dol
		dta b(<bird6b,<bird7b,<bird8b,<bird7b)								;8 ptaszek w prawo
		dta b(0,0,0,0)			;12 jack idzie w lewo
		dta b(0,0,0,0)		;16 jack idzie w prawo
		dta b(0,0,0,0)				;20 jack stoi w miejscu,21 dol_srodek,22 dol_prawo,23 dol_lewo
		dta b(0,0,0,0)					;24 jack gora_srodek,25 fora_prawo,26_gora_lewo
		dta b(0,0,0,0)		;28 jack spada w dol, 30 jack upada na platforme
		dta b(0,0,0,0)						;32 jack tanczy
		dta b(<radar0b,<radar1b,<radar2b,<radar3b)							;36 radar
		dta b(<ufo0b,<ufo1b,<ufo2b,<ufo3b)									;40 ufo
		dta b(<globus0b,<globus1b,<globus2b,<globus3b)						;44 globus
		dta b(<explo0b,<explo1b,<explo2b,<explo3b)							;48 explo
		dta b(<mumia_spada0b,<mumia_spada1b,0,0)						;52 mumia spada
		dta b(<mumia_lewo0b,<mumia_lewo1b,<mumia_lewo2b,0)				;56 mumia_lewo
		dta b(<mumia_prawo0b,<mumia_prawo1b,<mumia_prawo2b,0)				;60 mumia_prawo
		dta b(<przemiana0b,<przemiana1b,<przemiana2b,<przemiana3b)			;64 przemiana
		dta b(<bonus0b,<bonus1b,<bonus2b,<bonus3b)							;68 bonus B
		dta b(<extra0b,<extra1b,<extra2b,<extra3b)							;72 extra_life E
		dta b(<paraliz0b,<paraliz1b,<paraliz2b,<paraliz3b)					;76 paraliż P
		dta b(<buzka3b,<buzka2b,<buzka1b,<buzka0b)							;80 buzki
		dta b(<oko0b,<oko1b,<oko2b,<oko3b)									;84 oko				
		dta b(<punkty0b,<punkty1b,<punkty2b,<punkty3b,<punkty4b,<punkty5b,<punkty6b,<punkty7b,<punkty8b,<punkty9b,<punkty10b,<punkty11b,<punkty12b) ;88=100,200,300,500,800,1200,1000,2000,3000 97=x2,x3,x4,x5	
		:3 dta b(0)			;wyrównanie
		dta b(<czapka_lewo0b,<czapka_lewo1b,<czapka_lewo2b,<czapka_lewo1b)		;104 czapka_lewo
		dta b(<czapka_prawo0b,<czapka_prawo1b,<czapka_prawo2b,<czapka_prawo1b)	;108 czapka_prawo
		:16 dta b(0) 
		
		
		dta b(>bird0b,>bird1b,>bird2b,>bird1b)								;0 ptaszek w lewo
		dta b(>bird3b,>bird4b,>bird5b,>bird4b)								;4 ptaszek góra/dol
		dta b(>bird6b,>bird7b,>bird8b,>bird7b)								;8 ptaszek w prawo
		dta b(0,0,0,0)			;12 jack idzie w lewo
		dta b(0,0,0,0)		;16 jack idzie w prawo
		dta b(0,0,0,0)				;20 jack stoi w miejscu,21 dol_srodek,22 dol_prawo,23 dol_lewo
		dta b(0,0,0,0)					;24 jack gora_srodek,25 fora_prawo,26_gora_lewo
		dta b(0,0,0,0)		;28 jack spada w dol, 30 jack upada na platforme
		dta b(0,0,0,0)						;32 jack tanczy
		dta b(>radar0b,>radar1b,>radar2b,>radar3b)							;36 radar
		dta b(>ufo0b,>ufo1b,>ufo2b,>ufo3b)									;40 ufo
		dta b(>globus0b,>globus1b,>globus2b,>globus3b)						;44 globus
		dta b(>explo0b,>explo1b,>explo2b,>explo3b)							;48 explo
		dta b(>mumia_spada0b,>mumia_spada1b,0,0)								;52 mumia spada
		dta b(>mumia_lewo0b,>mumia_lewo1b,>mumia_lewo2b,0)					;56 mumia_lewo
		dta b(>mumia_prawo0b,>mumia_prawo1b,>mumia_prawo2b,0)				;60 mumia_prawo
		dta b(>przemiana0b,>przemiana1b,>przemiana2b,>przemiana3b)			;64 przemiana
		dta b(>bonus0b,>bonus1b,>bonus2b,>bonus3b)							;68 bonus B
		dta b(>extra0b,>extra1b,>extra2b,>extra3b)							;72 extra_life E
		dta b(>paraliz0b,>paraliz1b,>paraliz2b,>paraliz3b)					;76 paraliż P
		dta b(>buzka3b,>buzka2b,>buzka1b,>buzka0b)							;80 buzki
		dta b(>oko0b,>oko1b,>oko2b,>oko3b)									;84 oko			
		dta b(>punkty0b,>punkty1b,>punkty2b,>punkty3b,>punkty4b,>punkty5b,>punkty6b,>punkty7b,>punkty8b,>punkty9b,>punkty10b,>punkty11b,>punkty12b)  ;88=100,200,300,500,800,1200,1000,2000,3000 97=x2,x3,x4,x5	
		:3 dta b(0)			;wyrównanie
		dta b(>czapka_lewo0b,>czapka_lewo1b,>czapka_lewo2b,>czapka_lewo1b)		;104 czapka_lewo
		dta b(>czapka_prawo0b,>czapka_prawo1b,>czapka_prawo2b,>czapka_prawo1b)	;108 czapka_prawo		
		:16 dta b(0)  

		
shape_bank
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK1,BANK1,BANK1,BANK1)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK1,BANK1,BANK1,BANK1)
		dta b(BANK1,BANK1,BANK1,BANK1)
		:13 dta b(BANK1)
		:3 dta b(0)
		:8 dta b(BANK1)
		
		.align
		
		
tab_skok01	dta <dy0,<dy1,<dy2,<dy3,<dy4,<dy5,<dy6,<dy7		

		
dy0		
		sta sprites+$400+$11,x
		sta sprites+$500+$11,x

		sta sprites+$400+$10,x
		sta sprites+$500+$10,x
			
		sta sprites+$400-8,x
		sta sprites+$400-7,x
		sta sprites+$400-6,x
		sta sprites+$400-5,x
		sta sprites+$400-4,x
		sta sprites+$400-3,x
		sta sprites+$400-2,x
		sta sprites+$400-1,x
		
		sta sprites+$500-8,x		
		sta sprites+$500-7,x
		sta sprites+$500-6,x
		sta sprites+$500-5,x
		sta sprites+$500-4,x
		sta sprites+$500-3,x
		sta sprites+$500-2,x
		sta sprites+$500-1,x
		
		rts
		
dy1		
		sta sprites+$400-9,x
		sta sprites+$500-9,x
		jmp dy0+6
		
dy2	
		sta sprites+$400+$13,x
		sta sprites+$500+$13,x
		sta sprites+$400+$14,x
		sta sprites+$500+$14,x
		sta sprites+$400+$15,x
		sta sprites+$500+$15,x
		sta sprites+$400+$16,x
		sta sprites+$500+$16,x
		sta sprites+$400+$17,x
		sta sprites+$500+$17,x
		jmp dy7+30
		
dy3	
		sta sprites+$400+$13,x
		sta sprites+$500+$13,x
		sta sprites+$400+$14,x
		sta sprites+$500+$14,x
		sta sprites+$400+$15,x
		sta sprites+$500+$15,x
		sta sprites+$400+$16,x
		sta sprites+$500+$16,x
		jmp dy7+24
		
dy4
		sta sprites+$400+$13,x
		sta sprites+$500+$13,x
		sta sprites+$400+$14,x
		sta sprites+$500+$14,x
		sta sprites+$400+$15,x
		sta sprites+$500+$15,x
		jmp dy7+18		
		
		
dy5	
		cpx #POSY_MAX-32
		bcs dy7+12
		sta sprites+$400+$13,x
		sta sprites+$500+$13,x
		sta sprites+$400+$14,x
		sta sprites+$500+$14,x
		jmp dy7+12		
		
dy6		
		sta sprites+$400+$13,x
		sta sprites+$500+$13,x
		jmp dy7+6
		
dy7
		sta sprites+$400-7,x
		sta sprites+$500-7,x
		sta sprites+$400-6,x
		sta sprites+$500-6,x
		sta sprites+$400-5,x
		sta sprites+$500-5,x
		sta sprites+$400-4,x
		sta sprites+$500-4,x		
		sta sprites+$400-3,x
		sta sprites+$500-3,x
		sta sprites+$400-2,x
		sta sprites+$500-2,x
		sta sprites+$400-1,x		
		sta sprites+$500-1,x
		
		sta sprites+$400+$10,x		
		sta sprites+$400+$11,x
		sta sprites+$400+$12,x
		sta sprites+$500+$10,x		
		sta sprites+$500+$11,x
		sta sprites+$500+$12,x
		rts

		
		.align
		
tab_skok23	dta <dy0b,<dy1b,<dy2b,<dy3b,<dy4b,<dy5b,<dy6b,<dy7b		

		
dy0b	
		

		sta sprites+$600+$11,x
		sta sprites+$700+$11,x 
	
		sta sprites+$600+$10,x
		sta sprites+$700+$10,x
		
		sta sprites+$600-8,x
		sta sprites+$600-7,x
		sta sprites+$600-6,x
		sta sprites+$600-5,x
		sta sprites+$600-4,x
		sta sprites+$600-3,x
		sta sprites+$600-2,x
		sta sprites+$600-1,x
		
		sta sprites+$700-8,x		
		sta sprites+$700-7,x
		sta sprites+$700-6,x
		sta sprites+$700-5,x
		sta sprites+$700-4,x
		sta sprites+$700-3,x
		sta sprites+$700-2,x
		sta sprites+$700-1,x
		
		rts
		
dy1b		
		sta sprites+$600-9,x
		sta sprites+$700-9,x
		jmp dy0b+6
		
		
dy2b	
		sta sprites+$600+$13,x
		sta sprites+$700+$13,x
		sta sprites+$600+$14,x
		sta sprites+$700+$14,x
		sta sprites+$600+$15,x
		sta sprites+$700+$15,x
		sta sprites+$600+$16,x
		sta sprites+$700+$16,x
		sta sprites+$600+$17,x
		sta sprites+$700+$17,x
		jmp dy7b+30
		
dy3b	
		sta sprites+$600+$13,x
		sta sprites+$700+$13,x
		sta sprites+$600+$14,x
		sta sprites+$700+$14,x
		sta sprites+$600+$15,x
		sta sprites+$700+$15,x
		sta sprites+$600+$16,x
		sta sprites+$700+$16,x
		jmp dy7b+24
		
dy4b
		sta sprites+$600+$13,x
		sta sprites+$700+$13,x
		sta sprites+$600+$14,x
		sta sprites+$700+$14,x
		sta sprites+$600+$15,x
		sta sprites+$700+$15,x
		jmp dy7b+18
		
dy5b	
		sta sprites+$600+$13,x
		sta sprites+$700+$13,x
		sta sprites+$600+$14,x
		sta sprites+$700+$14,x
		jmp dy7b+12		
		
		
dy6b		
		sta sprites+$600+$13,x
		sta sprites+$700+$13,x
		jmp dy7b+6

dy7b
		sta sprites+$600-7,x
		sta sprites+$700-7,x
		sta sprites+$600-6,x
		sta sprites+$700-6,x
		sta sprites+$600-5,x
		sta sprites+$700-5,x
		sta sprites+$600-4,x
		sta sprites+$700-4,x		
		sta sprites+$600-3,x
		sta sprites+$700-3,x
		sta sprites+$600-2,x
		sta sprites+$700-2,x
		sta sprites+$600-1,x		
		sta sprites+$700-1,x
		
		sta sprites+$600+$10,x		
		sta sprites+$600+$11,x
		sta sprites+$600+$12,x
		sta sprites+$700+$10,x		
		sta sprites+$700+$11,x
		sta sprites+$700+$12,x
		rts	
		
.endl
		