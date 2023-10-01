//poziomy

rampa_x		org *+16
rampa_dx	org *+16
rampa_y		org *+16
rampa_dy	org *+16

.local POZ
;typ planszy dla danego level'u
poziom_tab 
		.he 00,01,02,03,04,00,01,02,03,04
		.he 00,01,02,03,04,00,01,02,03,04
		.he 00,01,02,03,04,02,02,01,00,04
		.he 00,02,03,00,01,03,01,02,00,00
		.he 02,02,01,03,01,02,02,03,01,03
		.he 00,00,01,03,01,00,01,00,02,02
		.he 02,01,03							;63 poziomy
		
;układ ramp dla danego poziomu		
rampa_tabx
		.he 00,01,02,03,04,05,06,07
		.he 08,04,09,0a,0b,0c,04,0d
		.he 0e,0f,01,04,0a,06,03,0b
		.he 04,0f,07,0e,09,04,05,02
		.he 0c,0d,06,08,0b,0e,05,05
		.he 07,0f,06,03,0a,02,0b,08
		.he 01,08,09,0d,0a,0c,06,00
		.he 0e,05,07,02,0f,06,03
		
		
		

last_char_tab	.he ff,ff,ff,ff,ff

level_tab0	dta 0,1*26,2*26,3*26,4*26
level_zestawy_tab 																												;zestawy znaków w danej linii
		dta zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn1,zn1,zn1,zn0,zn1,zn1,zn2,zn2,zn2,zn3,zn3,zn4,zn3			;plansza ze sfinksem poziom=0
		dta zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn1,zn1,zn2,zn2,zn3,zn3,zn4,zn4,zn4,zn1			;akropol
		dta zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn1,zn1,zn1,zn2,zn2,zn3,zn3,zn4,zn4,zn5,zn5,zn2,zn3			;zamek
		dta zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0			;plansza z miastem
		dta zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn0,zn1,zn1,zn2,zn2,zn3,zn3,zn4,zn4,zn2,zn4,zn4,zn4			;droga
		
		

level_color_change_tab
		.he 1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e		;sfinks
		.he 1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,16,1a,16,1e,17,16,1e,1a,1e,1e,1e		;akropol
		.he 1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1a,1e,1e,18,1e,1e,1e,1e,1e,1e,1e,1e,1e		;zamek
		.he 1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1e,1a,1e,1e,1e,1e,1e,1e		;miasto
		.he 1e,1e,1e,1a,1e,1e,1e,1a,1e,1e,1e,1a,1e,1e,1e,1e,1e,16,1e,17,1a,1e,1e,1e,1e,1e		;droga
		
		
level_color_value_tab
		.he 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00		;sfinks
		.he 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,e2,34,32,00,b6,b2,00,24,00,00,00		;akropol
		.he 00,00,00,00,00,00,00,00,00,00,00,00,00,c6,00,00,24,00,00,00,00,00,00,00,00,00		;zamek
		.he 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,84,00,00,00,00,00,00		;miasto
		.he 00,00,00,76,00,00,00,74,00,00,00,54,00,00,00,00,00,b6,00,c2,24,00,00,00,00,00		;droga
		
		
level_tab1	dta 0,5,2*5,3*5,4*5
level_colors_tab						;kolory startowe
		.he 76,18,24,0e,00					;poziom=0 ze sfinksem
		.he 68,14,e8,1e,00				;akropol
		.he 00,0c,06,7a,00				;zamek
		.he 86,06,0a,0f,00				;miasto
		.he 78,36,ec,0f,00				;droga
		
		
level_rampa_tab 
			dta a(rampa_lev0),a(rampa_lev1),a(rampa_lev2),a(rampa_lev3),a(rampa_lev4),a(rampa_lev5),a(rampa_lev6),a(rampa_lev7) ;A,B,C,D,E,F,G,H
			dta a(rampa_lev8),a(rampa_lev9),a(rampa_lev10),a(rampa_lev11),a(rampa_lev12),a(rampa_lev13),a(rampa_lev14),a(rampa_lev15)	;I,J,K,L,M,N,O,P
						

//1 bajt ile ramp
//2 LLKXXXXX		,LL-dwa najstarsze bity dlugosci/szerokosci rampy,K- 0=pion i 1=poziom
//3 LLLYYYYY 		,LLL- trzy mlodsz bity dlugosci/szerokosci rampy
S_2=$00
M_2=$40
S_3=$00
M_3=$60
S_4=$00
M_4=$80
S_5=$00
M_5=$a0
S_6=$00
M_6=$c0
S_7=$00
M_7=$e0
S_8=$40
M_8=$00
S_9=$40
M_9=$20
S_10=$40
M_10=$40
S_11=$40
M_11=$60
S_12=$40
M_12=$80
S_13=$40
M_13=$a0
S_14=$40
M_14=$c0
S_15=$40
M_15=$e0
_POZIOM=$20
_PION=$00


			
rampa_lev0		;A							;opis ramp dla danego poziomu
		dta 5
		dta S_5+_POZIOM+6,M_5+8
		dta S_7+_POZIOM+18,M_7+5	
		dta S_9+_POZIOM+20,M_9+23		;poziom=0 ze sfinksem
		dta S_6+_POZIOM+15,M_6+16
		dta S_5+_POZIOM+2,M_5+20
				
rampa_lev1	;B
		dta 6
		dta S_5+_POZIOM+0,M_5+8
		dta S_5+_POZIOM+27,M_5+8
		dta S_5+_POZIOM+4,M_5+14
		dta S_5+_POZIOM+24,M_5+14
		dta S_5+_POZIOM+9,M_5+20
		dta S_5+_POZIOM+20,M_5+20
		
rampa_lev2		;C
		dta 5
		dta S_5+_POZIOM+6,M_5+5
		dta S_5+_POZIOM+21,M_5+5
		dta S_6+_POZIOM+13,M_6+18
		dta S_4+_POZIOM+2,M_4+21
		dta S_4+_POZIOM+26,M_4+21
		
		
rampa_lev3		;D
		dta 4
		dta S_5+_POZIOM+3,M_5+5
		dta S_5+_POZIOM+24,M_5+5
		dta S_5+_POZIOM+3,M_5+19
		dta S_5+_POZIOM+24,M_5+19		
		
rampa_lev4		;E
		dta 0
		
rampa_lev5		;F
		dta 5
		dta S_9+_POZIOM+0,M_9+8
		dta S_5+_POZIOM+18,M_5+5		
		dta S_6+_POZIOM+23,M_6+11
		dta S_15+_POZIOM+8,M_15+18
		dta S_7+_PION+23,M_7+12
		
rampa_lev6		;G
		dta 6
		dta S_7+_POZIOM+7,M_7+11
		dta S_7+_POZIOM+19,M_7+11
		dta S_5+_POZIOM+14,M_5+5
		dta S_7+_POZIOM+7,M_7+15
		dta S_7+_POZIOM+19,M_7+15
		dta S_5+_POZIOM+14,M_5+20
		
rampa_lev7		;H	
		dta 8
		dta S_6+_POZIOM+3,M_6+8
		dta S_6+_POZIOM+23,M_6+8
		dta S_6+_POZIOM+3,M_6+17
		dta S_6+_POZIOM+23,M_6+17		
		dta S_6+_PION+9,M_6+3
		dta S_6+_PION+22,M_6+3
		dta S_6+_PION+9,M_6+17
		dta S_6+_PION+22,M_6+17
		
rampa_lev8	;I
		dta 10
		dta S_5+_POZIOM+11,M_5+4
		dta S_10+_POZIOM+11,M_10+14
		
		dta S_4+_POZIOM+11-2,M_5+8
		
		dta S_2+_PION+11,M_2+9
		dta S_6+_POZIOM+8,M_6+11
		dta S_2+_PION+14,M_2+15
		dta S_4+_POZIOM+11,M_4+17
		
		dta S_13+_POZIOM+2,M_13+20
		dta S_2+_PION+11,M_2+21
		dta S_4+_POZIOM+11,M_4+23
		
rampa_lev9	;J
		dta 6
		dta S_13+_POZIOM+5,M_13+5
		dta S_5+_POZIOM+22,M_5+5
		dta S_14+_PION+5,M_14+6
		dta S_14+_PION+26,M_14+6
		dta S_5+_POZIOM+5,M_5+20
		dta S_13+_POZIOM+14,M_13+20
		
rampa_lev10	;K	
		dta 6
		dta S_6+_POZIOM+0,M_6+8
		dta S_6+_POZIOM+26,M_6+5
		dta S_6+_POZIOM+0,M_6+14
		dta S_6+_POZIOM+0,M_6+20
		dta S_6+_POZIOM+26,M_6+11
		dta S_6+_POZIOM+26,M_6+17
		
rampa_lev11	;L	
		dta 5
		dta S_11+_POZIOM+5,M_11+5
		dta S_11+_POZIOM+16,M_11+5
		dta S_12+_PION+5,M_12+6
		dta S_12+_PION+26,M_12+6
		dta S_4+_POZIOM+14,M_4+18
		
rampa_lev12	;M	
		dta 12
		dta S_5+_POZIOM+7,M_5+3
		dta S_5+_POZIOM+20,M_5+3
		dta S_5+_POZIOM+7,M_5+22
		dta S_5+_POZIOM+20,M_5+22
		
		dta S_6+_POZIOM+13,M_6+8
		dta S_6+_POZIOM+13,M_6+16
		dta S_4+_PION+9,M_4+11
		dta S_4+_PION+22,M_4+11
		
		dta S_5+_PION+2,M_5+6
		dta S_5+_PION+2,M_5+15
		
		dta S_5+_PION+29,M_5+6
		dta S_5+_PION+29,M_5+15
		
rampa_lev13	;N
		dta 8
		dta S_10+_POZIOM+9,M_10+3
		dta S_7+_POZIOM+23,M_7+14
		dta S_7+_POZIOM+2,M_7+11
		dta S_10+_POZIOM+13,M_10+22
		
		dta S_7+_PION+18,M_7+4
		dta S_8+_PION+29,M_8+6
		dta S_8+_PION+2,M_8+12
		dta S_7+_PION+13,M_7+15
		
rampa_lev14	;O
		dta 4
		dta S_8+_POZIOM+12,M_8+5
		dta S_8+_POZIOM+12,M_8+20
		dta S_10+_PION+4,M_10+9
		dta S_10+_PION+28,M_10+9
		
rampa_lev15	;P	
		dta 10
		dta S_4+_POZIOM+2,M_4+5
		dta S_4+_POZIOM+26,M_4+5
		dta S_4+_POZIOM+14,M_4+5
		
		dta S_4+_POZIOM+8,M_4+11
		dta S_4+_POZIOM+20,M_4+11
		
		dta S_4+_POZIOM+2,M_4+17
		dta S_4+_POZIOM+14,M_4+17
		dta S_4+_POZIOM+26,M_4+17
		
		dta S_4+_POZIOM+8,M_4+23
		dta S_4+_POZIOM+20,M_4+23
	
		
level_tab2	
		//pozytyw/negatyw,rampa,bomb0,bomb1,bomb2,bomb3
		dta %11100000,$e4,%11010100,%11010110,%11110100,%11110110		;sfinks
		dta %11100000,%11100110,$e4,$e4,%11110100,%11110100					;akropol
		dta %10100000,%11100101,%00010111,%11010110,%01110111,%01100110			;zamek
		dta %11100000,%11100110,$e4,$e4+1,%11110100,%11110101						;miasto
		dta %11100000,$e4,%11100100,%11010100,%11110100,%11110100						;droga
		
		
		


bomby_levels	dta a(bomb_levA),a(bomb_levB),a(bomb_levC),a(bomb_levD),a(bomb_levE),a(bomb_levF),a(bomb_levG),a(bomb_levH)
				dta a(bomb_levI),a(bomb_levA),a(bomb_levJ),a(bomb_levK),a(bomb_levL),a(bomb_levM),a(bomb_levE),a(bomb_levN)	
				dta a(bomb_levO),a(bomb_levP),a(bomb_levB1),a(bomb_levN),a(bomb_levK1),a(bomb_levG),a(bomb_levD1),a(bomb_levL1)
				dta a(bomb_levM),a(bomb_levP),a(bomb_levH),a(bomb_levO),a(bomb_levJ),a(bomb_levA),a(bomb_levF),a(bomb_levC)
				dta a(bomb_levM),a(bomb_levN),a(bomb_levG),a(bomb_levI),a(bomb_levL),a(bomb_levO1),a(bomb_levF),a(bomb_levF)
				dta a(bomb_levH),a(bomb_levP),a(bomb_levG),a(bomb_levD),a(bomb_levK),a(bomb_levC),a(bomb_levL),a(bomb_levI)
				dta a(bomb_levB),a(bomb_levI),a(bomb_levJ),a(bomb_levN),a(bomb_levK),a(bomb_levM),a(bomb_levG),a(bomb_levA)
				dta a(bomb_levO),a(bomb_levF),a(bomb_levH),a(bomb_levC),a(bomb_levP),a(bomb_levG),a(bomb_levD)
				
_PRAWO	equ $00
_LEWO	equ $20
_DOL	equ $40
_GORA	equ $60
_TYP0	equ $00
_TYP1	equ $80
_1		equ $20
_2		equ $40
_3		equ $60
_4		equ $80
_5		equ $a0
_6		equ $c0
_7		equ $e0


// 1=255 to koniec			
//  TKKXXXXX  T=typ tla, KK=kierunek linii, X=pozycja X		
//  IIIYYYYY  III=ile bomb w linii, Y=pozycja Y,

bomb_levA	;15b egipt
			dta _TYP0+_PRAWO+24,_3+0 
			dta _TYP1+_PRAWO+4,_3+24
			dta _TYP1+_PRAWO+20,_3+21
			dta _TYP0+_LEWO+10,_3+0
			dta _TYP1+_GORA+0,_4+18
			dta _TYP0+_GORA+30,_4+18
			dta _TYP0+_LEWO+25,_4+6					
			
			
bomb_levB	;17b rome
			dta _TYP0+_LEWO+25,_3+18
			dta _TYP0+_LEWO+12,_3+18
			dta _TYP0+_LEWO+10,_3+12
			dta _TYP0+_LEWO+6,_3+3
			dta _TYP0+_PRAWO+12,_3+0
			dta _TYP0+_PRAWO+12,_3+6	
			dta _TYP0+_LEWO+30,_3+3
			dta _TYP0+_LEWO+27,_3+12	
			
bomb_levB1	;17b new york
			dta _TYP1+_LEWO+25,_3+18
			dta _TYP1+_LEWO+12,_3+18
			dta _TYP0+_LEWO+10,_1+12
			dta _TYP1+_LEWO+7,_2+12
			dta _TYP0+_LEWO+6,_3+3
			dta _TYP0+_PRAWO+12,_3+0
			dta _TYP0+_PRAWO+12,_3+6	
			dta _TYP0+_LEWO+30,_3+3
			dta _TYP1+_LEWO+27,_3+12				
			
bomb_levC	;21b
			dta _TYP1+_LEWO+6,_3+19
			dta _TYP1+_LEWO+24,_2+24
			dta _TYP1+_LEWO+9,_2+24
			dta _TYP0+_PRAWO+0,_2+0
			dta _TYP0+_PRAWO+6,_2+3
			dta _TYP0+_LEWO+30,_2+0
			dta _TYP0+_LEWO+24,_2+3
			dta _TYP1+_LEWO+30,_3+19
			dta _TYP1+_GORA+21,_3+15
			dta _TYP1+_DOL+9,_3+9
						
bomb_levD	;17b new york
			dta _TYP0+_LEWO+30,_3+24	
			dta _TYP0+_LEWO+6,_3+24
			dta _TYP0+_PRAWO+0,_3+3
			dta _TYP0+_LEWO+30,_3+3
			dta _TYP1+_PRAWO+0,_3+11
			dta _TYP1+_LEWO+30,_3+11
			dta _TYP1+_PRAWO+3,_3+17
			dta _TYP1+_LEWO+27,_3+17
			
bomb_levD1	;17b germany
			dta _TYP1+_LEWO+30,_3+24	
			dta _TYP1+_LEWO+6,_3+24
			dta _TYP0+_PRAWO+0,_3+3
			dta _TYP0+_LEWO+30,_3+3
			dta _TYP0+_PRAWO+0,_3+11
			dta _TYP0+_LEWO+30,_3+11
			dta _TYP1+_PRAWO+3,_3+17
			dta _TYP1+_LEWO+27,_3+17			

bomb_levE	;17b
			dta _TYP1+_GORA+11,_3+21
			dta _TYP0+_GORA+4,_3+8
			dta _TYP1+_GORA+4,_3+21
			dta _TYP1+_GORA+19,_3+21	
			dta _TYP0+_GORA+11,_3+8
			dta _TYP0+_GORA+27,_3+8
			dta _TYP1+_GORA+27,_3+21
			dta _TYP0+_GORA+19,_3+8
			
bomb_levF			
			dta _TYP0+_LEWO+30,_2+0
			dta _TYP0+_PRAWO+0,_2+0
			dta _TYP0+_PRAWO+18,_2+3
			dta _TYP1+_PRAWO+9,_2+19
			dta _TYP1+_PRAWO+20,_2+19
			dta _TYP0+_PRAWO+24,_3+9
			dta _TYP0+_DOL+30,_4+12
			dta _TYP1+_GORA+0,_4+21
			dta _TYP1+_PRAWO+0,_3+9
			
bomb_levG
			dta _TYP1+_GORA+12,_3+24
			dta _TYP1+_LEWO+25,_3+13
			dta _TYP1+_GORA+19,_3+24
			dta _TYP1+_GORA+30,_3+24 
			dta _TYP1+_GORA+0,_3+24
			dta _TYP0+_LEWO+25,_3+3
			dta _TYP0+_LEWO+12,_3+3
			dta _TYP1+_PRAWO+6,_3+13
			
bomb_levH		
			dta _TYP1+_PRAWO+23,_3+15
			dta _TYP1+_DOL+23,_3+18
			dta _TYP0+_GORA+20,_3+9
			dta _TYP0+_GORA+27,_3+6
			dta _TYP0+_GORA+3,_3+6
			dta _TYP0+_GORA+10,_3+9
			dta _TYP1+_DOL+7,_3+18
			dta _TYP1+_PRAWO+1,_3+15
			
bomb_levI
			dta _TYP1+_LEWO+9,_3+18
			dta _TYP1+_GORA+3,_3+12
			dta _TYP1+_DOL+6,_3+6
			dta _TYP0+_PRAWO+18,_3+0
			dta _TYP1+_GORA+30,_3+24
			dta _TYP0+_PRAWO+24,_3+5
			dta _TYP1+_GORA+22,_3+24
			dta _TYP1+_LEWO+24,_3+12
			
bomb_levJ			
			dta _TYP1+_GORA+6,_3+12
			dta _TYP1+_GORA+24,_3+18
			dta _TYP0+_GORA+19,_3+9
			dta _TYP1+_GORA+0,_3+24
			dta _TYP0+_GORA+3,_3+6
			dta _TYP1+_GORA+30,_3+24
			dta _TYP0+_GORA+27,_3+6
			dta _TYP1+_GORA+10,_3+21
			
bomb_levK	;rzym
			dta _TYP0+_GORA+3,_3+15
			dta _TYP0+_GORA+0,_3+6
			dta _TYP0+_PRAWO+12,_3+6
			dta _TYP0+_DOL+30,_2+6
			dta _TYP0+_PRAWO+27,_1+9
			dta _TYP0+_LEWO+30,_3+0
			dta _TYP1+_PRAWO+0,_3+24
			dta _TYP1+_GORA+30,_3+24
			dta _TYP1+_LEWO+27,_1+18
			dta _TYP1+_GORA+27,_2+15
			
bomb_levK1	;egipt	
			dta _TYP1+_GORA+3,_3+15
			dta _TYP0+_GORA+0,_3+6
			dta _TYP0+_PRAWO+12,_3+6
			dta _TYP0+_DOL+30,_2+6
			dta _TYP0+_PRAWO+27,_1+9
			dta _TYP0+_LEWO+30,_3+0
			dta _TYP1+_PRAWO+0,_3+24
			dta _TYP1+_GORA+30,_2+24
			dta _TYP0+_LEWO+30,_2+18
			dta _TYP0+_GORA+27,_2+15			
			
bomb_levL	;germany			
			dta _TYP1+_GORA+27,_3+22		
			dta _TYP0+_GORA+30,_3+12
			dta _TYP0+_PRAWO+3,_3+3
			dta _TYP1+_GORA+3,_3+22
			dta _TYP0+_GORA+0,_3+12
			dta _TYP0+_LEWO+27,_3+3
			dta _TYP1+_GORA+12,_3+16
			dta _TYP1+_DOL+18,_3+10
			
bomb_levL1	;new york			
			dta _TYP0+_GORA+27,_1+22	
			dta _TYP1+_GORA+27,_2+19	
			
			dta _TYP1+_GORA+30,_2+12
			dta _TYP0+_GORA+30,_1+6
			
			
			dta _TYP0+_PRAWO+3,_3+3
			
			dta _TYP0+_GORA+3,_1+22
			dta _TYP1+_GORA+3,_2+19
			
			dta _TYP0+_GORA+0,_3+12
			dta _TYP0+_LEWO+27,_3+3
			
			
			
			dta _TYP1+_GORA+12,_1+16
			dta _TYP0+_GORA+12,_2+13
			
			dta _TYP0+_DOL+18,_2+10	
			dta _TYP1+_DOL+18,_1+16
			
bomb_levM
			dta _TYP1+_DOL+10,_3+14
			dta _TYP0+_GORA+23,_3+12
			dta _TYP0+_GORA+0,_3+15
			dta _TYP0+_PRAWO+4,_3+0
			dta _TYP0+_PRAWO+20,_3+0
			dta _TYP1+_DOL+30,_3+9
			dta _TYP1+_DOL+7,_3+6
			dta _TYP1+_GORA+20,_3+20
			
bomb_levN
			dta _TYP0+_PRAWO+0,_3+7
			dta _TYP0+_DOL+16,_3+4
			dta _TYP1+_GORA+6,_3+24
			dta _TYP1+_GORA+3,_3+18
			dta _TYP0+_GORA+27,_3+12
			dta _TYP0+_GORA+23,_3+6
			dta _TYP0+_DOL+30,_3+6
			dta _TYP1+_LEWO+23,_3+20
			
bomb_levO	;rome
			dta _TYP1+_GORA+29,_5+21
			dta _TYP0+_LEWO+18,_3+6
			dta _TYP0+_PRAWO+2,_1+3
			dta _TYP0+_PRAWO+12,_3+3
			dta _TYP0+_PRAWO+29,_1+3
			dta _TYP1+_GORA+26,_3+15
			dta _TYP1+_GORA+2,_5+21
			dta _TYP1+_DOL+5,_3+9
			
bomb_levO1	;germany
			dta _TYP1+_GORA+29,_5+21
			dta _TYP1+_LEWO+18,_3+6
			dta _TYP0+_PRAWO+2,_1+3
			dta _TYP0+_PRAWO+12,_3+3
			dta _TYP0+_PRAWO+29,_1+3
			dta _TYP1+_GORA+26,_3+15
			dta _TYP1+_GORA+2,_5+21
			dta _TYP1+_DOL+5,_3+9			
			
bomb_levP			
			dta _TYP1+_LEWO+11,_2+21
			dta _TYP1+_PRAWO+0,_3+15
			dta _TYP1+_PRAWO+24,_3+15
			dta _TYP0+_LEWO+22,_2+9
			dta _TYP0+_LEWO+11,_2+9
			dta _TYP0+_PRAWO+0,_3+3
			dta _TYP0+_PRAWO+24,_3+3
			dta _TYP1+_PRAWO+0,_2+24
			dta _TYP1+_LEWO+30,_2+24
			dta _TYP1+_LEWO+22,_2+21
			

level_tab3	dta a(level0_chars),a(level1_chars),a(level2_chars),a(level3_chars),a(level4_chars)

level0_chars
			dta a(level0_fnt),a(level0_fnt+64*8),a(level0_fnt+64*8+64*8),a(level0_fnt+64*8+64*8+53*8),a(level0_fnt+64*8+64*8+53*8+64*8),a(0)	;sfinks
level1_chars
			dta a(level1_fnt),a(level1_fnt+61*8),a(level1_fnt+61*8+63*8),a(level1_fnt+61*8+63*8+64*8),a(level1_fnt+61*8+63*8+64*8+56*8),a(0)	;akropol
level2_chars
			dta a(level2_fnt),a(level2_fnt+61*8),a(level2_fnt+61*8+63*8),a(level2_fnt+61*8+63*8+64*8),a(level2_fnt+61*8+63*8+64*8+62*8),a(level2_fnt+61*8+63*8+64*8+62*8+49*8),a(0)	;zamek			
level3_chars
			dta a(level3_fnt),a(0)	;miasto
level4_chars
			dta a(level4_fnt),a(level4_fnt+61*8),a(level4_fnt+61*8+60*8),a(level4_fnt+61*8+60*8+64*8),a(level4_fnt+61*8+60*8+64*8+60*8),a(0)	;droga
			

			
			
			
level_tab4	dta a(level0_scr),a(level1_scr),a(level2_scr),a(level3_scr),a(level4_scr)		



				

tab_bity	:4 dta b(0)
bits		dta b(0)

obroc_bity
		sty pom0a
		stx pom0c
		sta pom0
		
		ldx #0
		lda bits
@		pha
		and #%11
		sta tab_bity,x
		pla
		lsr 
		lsr 
		inx
		cpx #4
		bcc @-
		
		
		ldy #4
		
@		lda pom0
		and #%11
		tax		
		lda tab_bity,x
		lsr
		ror pom0b
		lsr 
		ror pom0b
		lsr pom0
		lsr pom0
		dey
		bne @-
		lda pom0b
		ldy pom0a
		ldx pom0c
		rts
		
neg_poz
		lda pom0d		;negatywy
neg_poz1		
		asl
		sta pom0d
		lda #0
		ror
		sta pom0	
		rts		
		
zwieksz_glob
		ldy #3
@		clc
		lda ai.tab_globus2,x
		adc pom0
		sta ai.tab_globus2,x
		lda ai.tab_globus3,x
		adc #0
		sta ai.tab_globus3,x
		dex
		dey
		bpl @-

		rts
		
zmniejsz_glob
		ldy #3
@		sec
		lda ai.tab_globus2,x
		sbc pom0
		sta ai.tab_globus2,x
		lda ai.tab_globus3,x
		sbc #0
		sta ai.tab_globus3,x
		dex
		dey
		bpl @-
		rts

//co poziom przyspiesza predkosc poruszania sie kulek	
speed_up=1
	
przyspiesz_kulki
		lda level
		bne @+
pe		rts
@		lsr
		bcs pe

		ldx #7
		mva #(speed_up*2) pom0
		jsr zwieksz_glob
		ldx #7+16
		jsr zwieksz_glob
		lsr pom0
		ldx #7+8
		jsr zwieksz_glob
		
		ldx #3+8
		jsr zmniejsz_glob
		asl pom0
		ldx #3
		jsr zmniejsz_glob
		ldx #3+16
		jsr zmniejsz_glob
		
		ldx #39
		ldy #255
@		jsr zmniejsz_glob+2
		dex
		jsr zwieksz_glob+2
		dex
		cpx #32
		bcs @-
		
		dex
		lsr pom0
		
@		jsr zmniejsz_glob+2
		dex
		jsr zwieksz_glob+2
		dex
		cpx #23
		bcs @-
		
		rts
		
		
nowy_poziom
		jsr wait_vbl
		mva #0 dmactl
		sta ile_ramp
		
		sta licznik_paraliz
		sta licznik_paraliz+1
		
		
		mva #$78 sprite_x
		mva #$58 sprite_y
		mva #0 ruch_poziom
		sta ile_score
		;sta ktory_paraliz
		:4 sta hposm0+#
		mva #1 spadanie		;koniec ekranu , zaczyna się spadanie
		mva #joy.LEN_SPADANIE	predkosc_spadanie
		mva #shp_jdol_srodek sprite_shape
		
		lda level_melody
		clc
		adc #1
		cmp #max_melody
		bcc *+4
		lda #0
		sta level_melody
		
		tax
		lda tab_melody,x
		jsr rmt_init0		
		
		lda level
		
		ldy #3
		cmp #3
		bcc *+3
		iny
		sty max_enemy
		
		ldy #1
		cmp #5
		bcc *+3
		iny
		sty max_ptakow
		
		lda #150
		sec
		sbc level
		sta ai.czekanie1		;przeciwnicy coraz szybciej się pojawiają
		
		jsr przyspiesz_kulki
		
		
		ldy level
		ldx poziom_tab,y
		stx poziom
		
		lda mumia_kolor_tab,x
		sta ai.mumia_kolor
		
		lda poziom
		asl
		tax
		
		lda level_tab3,x				;kopiowanie znaków planszy na swoje miejsce
		sta pom2
		lda level_tab3+1,x
		sta pom2+1
		
		mwa #znaki pom1
		mva #1 pom0
		
@		ldy pom0
		lda (pom2),y		
		beq @+1
		sta pom+1
		dey
		lda (pom2),y
		sta pom
		inc pom0
		inc pom0
		
		ldy #0
		ldx #2
@		lda (pom),y
		sta (pom1),y
		dey
		bne @-
		inc pom+1
		inc pom1+1
		dex
		bne @-
		inc pom1+1
		inc pom1+1
		jmp @-1
@		equ *		
		
		
		ldx poziom
		ldy level_tab0,x			;adres tablicy z zestawami znaków
		ldx #0						;licznik 
@		lda level_zestawy_tab,y
		sta zestaw,x
		lda level_color_change_tab,y
		sta level_cn,x
		lda level_color_value_tab,y
		sta level_cv,x
		iny
		inx
		cpx #26						;26 linii
		bcc @-
		
		ldx poziom
		ldy level_tab1,x			;kolory startowe planszy
		ldx #0
@		lda level_colors_tab,y
		sta kolor_tlo,x
		iny
		inx
		cpx #5
		bcc @-
		
		
//rampa
		lda poziom			;x6
		asl
		sta pom0
		asl
		adc pom0
		tax
		
		
		
		lda level_tab2,x		;negatywy
		jsr neg_poz1
		sta _negatyw			;potrzebny przy rysowaniu ramp
		
		lda level_tab2+1,x		;bity dla rampy
		sta bits
		
		ldy #15
@		lda stale_znaki,y
		jsr obroc_bity
		:6 sta znaki+$200+#*$400,y
		dey
		bpl @-
		
		
		
		
		
		lda level_tab2+2,x		;bity dla bomb0
		sta bits
		
		ldy #16*8-1
@		lda stale_znaki+$10,y
		jsr obroc_bity
		:6 sta znaki+$210+#*$400,y
		dey
		bpl @-
		
		jsr neg_poz
		sta bomb._negatyw0
		
		ldy #15						;ustawienie negatyw,pozytyw w animacji bomb
@		lda tab_anim0,y
		and #127
		ora pom0
		sta tab_anim0,y
		lda tab_anim0+$20,y
		and #127
		ora pom0
		sta tab_anim0+$20,y
		dey
		bpl @-
		
		
		
		

		lda level_tab2+3,x		;bity dla bomb1
		sta bits
		
		ldy #16*8-1
@		lda stale_znaki+$10,y
		jsr obroc_bity
		:6 sta znaki+$290+#*$400,y
		dey
		bpl @-	

		jsr neg_poz
		sta bomb._negatyw1
		
		ldy #15						;ustawienie negatyw,pozytyw w animacji bomb
@		lda tab_anim0+$10,y
		and #127
		ora pom0
		sta tab_anim0+$10,y
		lda tab_anim0+$30,y
		and #127
		ora pom0
		sta tab_anim0+$30,y
		dey
		bpl @-		
		
		
		
		
		
		lda level_tab2+4,x		;bity dla bomb2
		sta bits
		
		ldy #4*8-1
@		lda stale_znaki+$10,y
		jsr obroc_bity
		:6 sta znaki+$310+#*$400,y
		dey
		bpl @-	
		
		ldy #8*8-1
@		lda stale_znaki+$90,y
		jsr obroc_bity
		:6 sta znaki+$350+#*$400,y
		dey
		bpl @-			
		
		jsr neg_poz			
		
		ldy #3						;ustawienie negatyw,pozytyw w animacji bomb
@		lda tab_anim0+$24,y
		and #127
		ora pom0
		sta tab_anim0+$24,y
		dey
		bpl @-	


		

		lda level_tab2+5,x		;bity dla bomb3
		sta bits
		
		ldy #4*8-1
@		lda stale_znaki+$10,y
		jsr obroc_bity
		:6 sta znaki+$330+#*$400,y
		dey
		bpl @-	

		ldy #8*8-1
@		lda stale_znaki+$90,y
		jsr obroc_bity
		:6 sta znaki+$390+#*$400,y
		dey
		bpl @-			
		
		jsr neg_poz		
				
		ldy #3						;ustawienie negatyw,pozytyw w animacji bomb
@		lda tab_anim0+$34,y
		and #127
		ora pom0
		sta tab_anim0+$34,y
		dey
		bpl @-			
		

		
		ldx poziom
		lda last_char_tab,x
		ldy #7
@		:6 sta znaki+$3f8+#*$400,y			;ostatni znak bedzie czarny
		dey
		bpl @-
		
		ldx #0
		lda #$ff
@		:5 sta obraz+#*$100,x			;czyści obraz , wypełnia go czarnymi znakami
		dex
		bne @-
		
		lda poziom							;rysuje plansze
		asl
		tax
		lda level_tab4,x
		sta _ad0+1
		lda level_tab4+1,x
		sta _ad0+2
		
		mva #26 pom0		;licznik
		ldx #0
		
		mwa #(obraz+8) pom
		
@		ldy #0
_ad0		
@		lda $ffff,x
		sta (pom),y
		inx
		bne *+5
		inc _ad0+2
		iny
		cpy #32
		bcc @-
		lda pom
		adc #48-1
		sta pom
		lda pom+1
		adc #0
		sta pom+1
		dec pom0
		bne @-1		
		
		jsr rysuj_rampe
		
		jsr dodaj_bomby
		
		jsr wait_vbl
		mva #$3b dmactl
		
		rts
		
rysuj_rampe
		mva #40 ai.czekanie			;przeciwnicy pojawiaja sie szybiej na planszy bez ramp
		ldx level
		lda rampa_tabx,x
		asl
		tax
		lda level_rampa_tab,x
		sta pom1
		lda level_rampa_tab+1,x
		sta pom1+1
		
		ldy #0
		lda (pom1),y
		sta ile_ramp
		jeq rr1
		sty pom0a
		sty pom0b
		
rr0		ldy pom0a
		iny
		lda (pom1),y
		asl
		rol
		rol
		and #3
		sta pom0			;dlugosc rampy 2 najstarsze bity

		iny
		lda (pom1),y
		asl
		rol pom0
		asl
		rol pom0
		asl 
		rol pom0			;dlugość/wysokość rampy w pom0
		:3 lsr
		tax
		lda obr_m,x
		sta pom
		lda obr_s,x
		sta pom+1			;adres linii startowej w pom
		
		txa
		asl
		asl
		asl
		adc #POSY_MIN
		ldx pom0b
		sta rampa_y,x
		dey

		lda (pom1),y
		and #%00100000
		:3 asl
		rol
		bne @+
		lda #48
		sta _ryspos+1			;w pion
		lda #ch_rampa+1
		sta _char+1
		mva #7 rampa_dx,x
		lda pom0
		:3 asl
		adc #15
		sta rampa_dy,x
		jmp @+1	
@		sta _ryspos+1			;poziom
		lda #ch_rampa
		sta _char+1
		mva #23 rampa_dy,x
		lda pom0
		:2 asl
		adc #3
		sta rampa_dx,x
		
@		lda (pom1),y
		and #%11111
		iny
		sty pom0a
		tay					;pozycja X startowa
		asl
		asl
		adc #POSX_MIN
		sta rampa_x,x

		
_char	lda #0
_negatyw equ *+1		
		ora #0
		sta pom0c		
		
@		lda pom0c			;rysuj na ekranie
		sta (pom),y
_ryspos	lda #48
		jsr add_pom
		dec pom0
		bne @-
		
		inx
		stx pom0b
		cpx ile_ramp		;czy juz wszystkie rampy
		jne rr0

		lda rampa_dx
		sec
		sbc #6+4
		sta ai.rampa_tab
		clc
		lda rampa_x
		adc #2
		sta ai.rampa_tab+1
		lda rampa_dx+1
		sec
		sbc #6+4
		sta ai.rampa_tab+2
		clc
		lda rampa_x+1
		adc #2
		sta ai.rampa_tab+3
		
		mva #70 ai.czekanie		;standardowy czas do 1 przecwinika na planszy z rampami
		
		
rr1		rts		
		
		
			


db_tab		dta 3,0
			dta -3,0
			dta 0,3
			dta 0,-3
			
				
			
dodaj_bomby	
			mva #0 pom0a
			lda level
			asl
			tax
			lda bomby_levels,x
			sta pom1
			lda bomby_levels+1,x
			sta pom1+1
			ldy #$ff
			sty pom0d		;zapamiętaj indeks			

db0			
			ldy pom0d
			iny
			lda (pom1),y		;odczytaj 1 bajt
			sta pom0b
			
			:4 lsr
			and #%110			;odzytaj bity kierunku
			tax
			lda db_tab,x		;+/- w osiX
			sta _adx+1
			lda db_tab+1,x		;+/- w osiY
			sta _ady+1
			
			lda pom0b
			:3 lsr
			and #16
			sta pom0f			;typ bomby
			lda pom0b
			and #%11111
			sta pom0b
								
			iny
			lda (pom1),y		;odczytaj 2 bajt
			sty pom0d
			:5 lsr
			sta pom0e			;ile bomb w linii >0	
			lda (pom1),y
			and #%11111
			sta pom0c
			
			ldx pom0a
db1			lda pom0b
			pha	
			:2 asl
			adc #POSX_MIN
			sta bomba_x,x	
			
			lda pom0c
			pha
			:3 asl
			adc #POSY_MIN
			sta bomba_y,x	

			lda pom0f
			sta bomba_anim_typ,x	;typ tła pod bombą

			pla
			tax
			pla
			tay
			lda pom0f
			
			jsr bomb.rysuj_bombe
			mva #0 bomba_anim_faza,x
			sta bomba_zapalona,x
			mva #BOMBA_ANIM_SPEED bomba_anim_licznik,x	
@			lda random
			cmp #32
			bcc @-
			sta bomba_anim_licznik1,x		
			inx
			stx pom0a
			cpx #24
			beq db2
			
			dec pom0e
			jeq db0
			
			clc
			lda pom0b
_adx		adc #0
			sta pom0b
			clc
			lda pom0c
_ady		adc #0
			sta pom0c
			jmp db1								
			
db2			;ldx pom0a			;zapalamy ostatnią bombe
			stx ile_bomb
			dex
			stx bomb.zbieraj_bomby+1
							
@			rts				

			
stale_znaki
			.he ff,00,ff,ff,ff,ff,ff,ff			;rampa pozioma
			:2 .he cf,cf,f3,f3			;rampa pionowa
			
			.he 00,00,00,03,0f,0f,3e,3b			;czarna bomba na niebieskim tle
			.he 30,c0,00,c0,f0,f0,fc,fc			;1 faza
			.he 3b,3f,3f,3f,0f,0f,03,00
			.he fc,fc,fc,fc,f0,f0,c0,00
			
			.he 00,03,03,00,03,0f,0f,3e		;2faza
			.he 00,00,00,00,c0,f0,f0,fc
			.he 3b,3f,3f,0f,0f,03,00,00
			.he fc,fc,fc,f0,f0,c0,00,00

			
			.he 00,00,00,03,00,03,0f,0e		;3 faza
			.he 00,00,00,00,00,c0,f0,f0
			.he 0f,0f,0f,0f,03,00,00,00
			.he f0,f0,f0,f0,c0,00,00,00
			
			.he 00,00,00,00,03,0f,0f,3e		;4faza
			.he 00,c0,c0,00,c0,f0,f0,fc
			.he 3b,3f,3f,0f,0f,03,00,00
			.he fc,fc,fc,f0,f0,c0,00,00
			
			.he cc,cc,30,00,00,00,00,00
			.he 00,00,00,0c,33,33,33,0c
			.he 00,00,00,00,00,00,30,cc
			
			.he 00,3c,03,3f,30,3f,00,00		;200
			.he 00,33,33,3f,03,03,00,00		;400
			.he 00,3f,30,3f,33,3f,00,00		;600			
			.he 00,3f,33,3f,33,3f,00,00		;800			
			.he 0c,3c,0c,0c,3f,00,30,cc		;1000!
			
	
.endl

level0_fnt
			ins './levels/sfinks.fnt'
level1_fnt
			ins './levels/akropol.fnt'
level2_fnt			
			ins './levels/zamek.fnt'			
level3_fnt
			ins './levels/miasto.fnt'	
level4_fnt
			ins './levels/droga.fnt'	

			
level0_scr			
			ins '/levels/sfinks.scr'
level1_scr
			ins '/levels/akropol.scr'	
level2_scr			
			ins '/levels/zamek.scr'			
level3_scr			
			ins '/levels/miasto.scr'
level4_scr			
			ins '/levels/droga.scr'


			
			
		