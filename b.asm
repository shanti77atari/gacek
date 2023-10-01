//bomb jack new version

		
			icl 'atari.hea'

NTSCGTIA=$d014

//stale

;znaki
ch_rampa=64
ch_bomb0=64+2		;niebieskie tlo
ch_bomb1=64+18		;brazowe tlo
ch_bomb2=64+34		;biala+niebieskie tlo
ch_bomb3=64+38		;biala+brazowe tlo

ch_bonus=64+42		;znaki z bonusem

//ksztalty
shp_ptak_lewo=0
shp_ptak_pion=4
shp_ptak_prawo=8
shp_jgora_srodek=24
shp_jgora_prawo=25
shp_jgora_lewo=26
shp_jdol_srodek=21
shp_jdol_prawo=22
shp_jdol_lewo=23
shp_jlewo=12
shp_jprawo=16
shp_jstoi=20
shp_jspada=28
shp_jupada=30
shp_jtanczy=32

shp_czapka=104			;lewo
shp_czapka1=108			;prawo
shp_radar=36
shp_ufo=40
shp_globus=44
shp_explo=48
shp_mumia_spada=52
shp_mumia_lewo=56
shp_mumia_prawo=60
shp_przemiana=64
shp_bonus=68
shp_extra=72
shp_paraliz=76
shp_buzka=80
shp_oko=84	

//BANKI
BANK_off	equ %11111110
BANK0		equ %11000010
BANK1		equ %11000110
BANK2		equ %11001010
BANK3		equ %11001110

//STALE
LICZNIK_EXTRA_START=10

//tablice
znaki		equ $e000		;6 zestawów
obraz		equ $da00		;pamiec obrazu 48x26=$600
sprites		equ $f800
znaki1		equ $c000		;znaki w panelu

.rept		6,#
zn:1		equ >(znaki+:1*$400)			;6 zestawów znaków
.endr



			opt h-
			org $80			

zegar		equ $14		;zegar systemowy	

regA		org *+1
regX		org *+1
licznik		org *+1
bit12		org *+1
bit0		org *+1
bit1		org *+1
bit2		org *+1
bit3		org *+1
bit4		org *+1
bit5		org *+1
bit6		org *+1
bit7		org *+1
	
pom			org *+2
pom1		org *+2
pom2		org *+2
pom3		org *+2
pom4		org *+2
pom0		org *+1
pom0a		org *+1
pom0b		org *+1
pom0c		org *+1
pom0d		org *+1
pom0e		org *+1
pom0f		org *+1
pom0g		org *+1
pom0h		org *+1

gracz_y1	org *+1		;poprzednia pozycja Y gracza
ile_enemy	org *+1
max_enemy	org *+1
ile_ptakow	org *+1
licznik_ptak org *+1
max_ptakow	org *+1
musicNTSC	org *+1

kanal_audf1			org *+2	
kanal_audf2			org *+2	
kanal_audf3			org *+2	
kanal_audf4			org *+2
kanal_audc1			org *+2	
kanal_audc2			org *+2	
kanal_audc3			org *+2					
kanal_audc4			org *+2
ile_score			org *+1		;ile jest wyświetlanych punktów na planszy

prio		org *+1
death		org *+1

level_melody org *+1
muza0		org *+1

score1		org *+1
bonus_flag	org *+1
paraliz_flag	org *+1
licznik1_paraliz	org *+1
licznik_extra		org *+1
czy_zapalona	org *+1
ile_zapalonych	org *+1
kolor_P			org *+1
ile_paraliz		org *+1		;ile zebrano przeciwników
random_extra	org *+1
klawisz			org *+1

			org $d800
			
level		org *+1	
kolor_tlo	org *+1	
kolor0		org *+1
kolor1		org *+1
kolor2		org *+1
kolor3		org *+1
trig0s		org *+1
last_shape	org *+1
ile_bomb	org *+1
predkosc_spadanie	org *+1
ramka		org *+1
poziom		org *+1
ruch_poziom	org *+1
round		org *+1
score		org *+3
ile_ramp	org *+1
spadanie	org *+1
wysokosc_lotu	org *+1
bonus		org *+1
licznik_bonus	org *+1
lives		org *+1

kanal1			org *+1
petla1			org *+1
kanal2			org *+1
petla2			org *+1
kanal3			org *+1
petla3			org *+1
kanal4			org *+1
petla4			org *+1

kanal1s			org *+2		;2 bajty , uzywamy tylko 1
kanal2s			org *+2
kanal3s			org *+2
kanal4s			org *+2

hscore			org *+3
licznik_death	org *+1
licznik_paraliz	org *+2
after_paraliz	org *+1
czy_extra		org *+1


		
			opt h+
			
			org $2000
			
			ins './gfx/game_font.fnt'

cyfry		
			dta 0,60,102,102,102,102,60,0	;0 małe
			dta 0,24,56,24,24,24,126,0
			dta 0,60,102,12,24,48,126,0
			dta 0,126,12,24,12,102,60,0
			dta 0,12,28,60,108,126,12,0
			dta 0,126,96,124,6,102,60,0
			dta 0,60,96,124,102,102,60,0
			dta 0,126,6,12,24,48,48,0
			dta 0,60,102,60,102,102,60,0
			dta 0,60,102,62,6,12,56,0		;9  
			
			dta 24,24,48,48,0,0,0,0			;'
			
_z_bonus	
			dta 0,0,0,0,0,0,0,0			;pusty znak
			
			dta 0,0,0,0,0,0
			dta b(%01100110)
			dta b(%00111100)
			dta b(%00011000)
			dta b(%00111100)
			dta b(%01100110)
			:9 dta 0
			.he 18,38,78,18,18,18,18,18,7e	;1
			:7 dta 0
			.he 3c,66,06,06,1c,30,60,62,7e		;2
			:7 dta 0
			.he 3c,66,06,06,18,06,06,66,3c	;3
			:7 dta 0
			.he 0e,1e,36,66,66,7f,06,06,06		;4
			:7 dta 0
			.he 7e,60,60,7c,06,06,06,66,3c	;5
			:3 dta 0
			
			
			;:8 dta b(0)
			.he 00,18,18,7e,7e,18,18,00
			.he 00,00,00,00,00,30,30,00
			.he 00,3c,3c,18,18,00,18,00
			
init
			
			lda 20
@			cmp 20
			beq @-
			
			sei
			mva #0 nmien
			sta dmactl
			sta 559
			mva #$fe portb
			
			ldx #0
			lda vcount
			beq *-3
@			tay
			lda vcount
			bne @-
			cpy #$84
			bcs *+4
			ldx #4
			stx musicNTSC	;=0 ->PAL,=4 -> NTSC
			
			
			ldx #0
@			lda $2000,x
			sta $c100,x
			dex
			bne @-
			
			ldx #11*8-1
@			lda cyfry,x
			sta $c080,x
			dex
			bpl @-
			
			ldx #127	;#103
@			lda _z_bonus,x
			sta $c000,x		;pusty znak
			dex
			bpl @-
			
			mva #$ff portb
			mva #64 nmien
			cli
			
			rts
			
			ini init
			
			org portb
			dta (BANK0+1)
			
			icl 'shapes.asm'
			
			org portb
			dta (BANK1+1)
			
			icl 'shapes1.asm'
			
			org portb
			dta (BANK2+1)
			
			org $4000
			ins 'ingame1.rmt'
			
			
			org portb
			dta (BANK_off+1)
			
		
			org $2000
dlist0		dta $44+$80,a(pusta_linia),$44+$80,a(obraz)			;24 linie antic 4
			:25 .he 84
			dta $10,$42,a(panel_adr),$02			;dolny panel
			dta $41,a(dlist0)
			
dlist1		
			:10 dta $70
			dta $42,a(obraz)
			.he 70,02,70,70,02,70,02
			:8 dta $70
			dta $70+$80
			dta $10,$42,a(panel_adr),$02			;dolny panel
			dta $41,a(dlist1)
				
dlist_title
			.he 70,70,70
			dta $42,a(title0)	;hscore
			.he 70,f0
			dta $4a+$10,a(title1)	;tytuł
			:7 .he 0,1a
			
			dta $F0
			dta $42,a(title1a)
			dta $90
.rept 8,#
			:3 dta $4f,a(title1b+:1*32)		;shanti77
			dta b(0)
.endr			
			;:7 .he 00,0f
			
			dta $f0
			dta $42,a(best5)
			
			dta $20+$80
			dta $42,a(highscore)
			dta $00,$02,$00,$02,$00,$02,$00,$02,$00
			
			
			dta $70,$f0,$00
			dta $42+$80,a(title2)
			dta $41,a(dlist_title)	;ABBUC
			
			
dlist_highscore
			dta $70,$70,$70+$80
			dta $42,a(great_result)
			dta $70,$70+$80,$47,a(wpis)
			dta $70,$70,$70+$80
			dta $42,a(highscore)
			.he a0,02,a0,02,a0,02,a0,02
			dta b($41),a(dlist_highscore)
			
dlist_congrat
			.he 70,70,70,70,70,70,70
			dta $47,a(congrat0)
			.he 70,70,70
			dta $46,a(congrat1)
			.he 70,06
			dta b($41),a(dlist_congrat)
			
congrat0	
			:2 dta b($80)
			dta d'CONGRATULATIONS'*	;14
			:2 dta b($80)
congrat1	dta b($80),d'YOU',b($80,$80),d'HAVE',b($80),d'COMPLETE',b($80)
			:5 dta b($80)
			dta d'ALL',b($80),d'ROUNDS'
			:5 dta b($80)
			
great_result
			:15 dta b($80)
			dta d'GREAT'*,B($80,$80),d'RESULT'*,b($80,$80,$8f,$8f,$8f)
			:15 dta b($80)
			
		
panel_adr	dta d'     SCORE    '*,b($81,$83),d'    ROUND   LIVES   HISCORE     '*
			dta d'     0000000  '*,b($82,$84),d'                    0000000     '*
			

			
title0		
			:7 .he 80
			dta d'HISCORE'*,b($80,$80,$80,$80,$80),d'0000000'*
			:6 .he 80			

title1=$400		;tytuł gry , pamiec obrazu
title1b=$600 	;shanti77 , pamiec obrazu
			
title1a		
			:10 .he 80
			dta d'CODE GFX SFX'*			
			:10 .he 80
			
title2		
			:16 dta d' '*
			dta d'FINAL-1  VERSION'*	
			:16 dta d' '*
			
best5		:13 dta b($80)
			dta d'BEST 5'*
			:13 dta b($80)
			
obr_m		:28 dta b(<[obraz+8+#*48])
obr_s		:28 dta b(>[obraz+8+#*48])	

pusta_linia	:48 dta b(255)	

highscore	
			dta d'    1.  ...    0000000   R00    '*
			dta d'    2.  ...    0000000   R00    '*
			dta d'    3.  ...    0000000   R00    '*
			dta d'    4.  ...    0000000   R00    '*
			dta d'    5.  ...    0000000   R00    '*

wyniki		:5 .he ff,ff,ff,00,00,00,00,00

wpis		:32 dta 0
	

next_bonus	dta b(30)

		
			icl 'przerwania.asm'
			icl 'bomby.asm'
			icl 'multi.asm'		
			icl 'panel.asm'
			icl 'poziomy.asm'
			icl 'kolizje.asm'
			icl 'joystick.asm'
			icl 'ai.asm'
			icl 'sfx.asm'
			icl 'napisy.asm'
			icl 'title.asm'
			icl 'efekt.asm'

default_colors			
kolor_gacek0	dta b($64)
kolor_gacek1	dta b($18)
explo_c0		dta b($ec)
explo_c1		dta b($24)
taniec0			dta b(36)
taniec1			dta b(68)
mumia_kolor_tab	.he 08,08,28,28,08


paraliz_tab0	equ *-1
				.he 72,22,42,a2,92,e2,02
paraliz_tab1	equ *-1
				.he 7c,2c,4c,ac,9c,ec,0c

ntsc_colors
			.he 64,38,ec,24,2b,51
			.he 08,08,28,28,08
			.he 82,32,52,b2,a2,f2,02
			.he 8c,3c,5c,bc,ac,fc,0c
			
///////			
			
level_color_value_tab_ntsc
		.he 00,00,00,00,00,00,00,00,00,00,00,00,e2,44,42,00,c6,c2,00,24		;akropol
		.he 00,00,00,00,00,00,00,00,00,00,d6,00,00,34,00,00,00,00,00,00		;zamek
		.he 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,94,00,00,00		;miasto
		.he 86,00,00,00,84,00,00,00,64,00,00,00,00,00,c6,00,d2,34,00,00		;droga	

level_colors_tab_ntsc						;kolory startowe
		.he 86,28,34,0e,00					;poziom=0 ze sfinksem
		.he 78,24,f8,2e,00				;akropol
		.he 00,0c,06,8a,00				;zamek
		.he 96,06,0a,0f,00				;miasto
		.he 88,46,ec,0f,00				;droga		
		
tab_spadanie_ntsc	dta a([246-19]*5/6),a([246-19]*5/6),a([215-17]*5/6),a([215-17]*5/6),a([160-12]*5/6),a([160-12]*5/6),a([160-12]*5/6),a([160-12]*5/6),a([80-6]*5/6),a([80-6]*5/6),a([40-3]*5/6),a([40-3]*5/6),a([20*5]/6),a([20*5]/6),a([10*5]/6),a([10*5]/6)		
tab_lot.ntsc		dta a([12*5]/6),a([24*5]/6),a([48*5]/6),a([48*5]/6),a([96*5]/6),a([96*5]/6),a([192*5]/6),a([340*5]/6)
jwbok=([256*5]/6)
mumia_speed_ntsc=[96*5]/6

glob_speed0=47*5/6	;64
glob_speed1=67*5/6	;96
glob_speed2=87*5/6	;128
glob_speed3=125*5/6	;160
		

tab_globus2 dta <(-glob_speed0*2),<(-glob_speed1*2),<(-glob_speed2*2),<(-glob_speed3*2),<(glob_speed0*2),<(glob_speed1*2),<(glob_speed2*2),<(glob_speed3*2)
tab_globus0 dta <-glob_speed0,<-glob_speed1,<-glob_speed2,<-glob_speed3,<glob_speed0,<glob_speed1,<glob_speed2,<glob_speed3
			dta <(-glob_speed0*2),<(-glob_speed1*2),<(-glob_speed2*2),<(-glob_speed3*2),<(glob_speed0*2),<(glob_speed1*2),<(glob_speed2*2),<(glob_speed3*2)
			
ptak_tabX0 dta <speed_ptak,0,<-speed_ptak,0,<speed_ptak1,0,<-speed_ptak1,0
ptak_tabY0 dta 0,<(2*speed_ptak),0,<-(2*speed_ptak),0,<(2*speed_ptak1),0,<-(2*speed_ptak1)

tab_globus3	dta >(-glob_speed0*2),>(-glob_speed1*2),>(-glob_speed2*2),>(-glob_speed3*2),>(glob_speed0*2),>(glob_speed1*2),>(glob_speed2*2),>(glob_speed3*2)	
tab_globus1 dta >-glob_speed0,>-glob_speed1,>-glob_speed2,>-glob_speed3,>glob_speed0,>glob_speed1,>glob_speed2,>glob_speed3
			dta >(-glob_speed0*2),>(-glob_speed1*2),>(-glob_speed2*2),>(-glob_speed3*2),>(glob_speed0*2),>(glob_speed1*2),>(glob_speed2*2),>(glob_speed3*2)	
			
speed_ptak=95*5/6	
speed_ptak1=115*5/6


ptak_tabX1 dta >speed_ptak,0,>-speed_ptak,0,>speed_ptak1,0,>-speed_ptak1,0			
ptak_tabY1 dta 0,>(2*speed_ptak),0,>-(2*speed_ptak),0,>(2*speed_ptak1),0,>-(2*speed_ptak1)

LOT_START=256

round_text	dta d'ROUND'*
lives_text	dta d'LIVES'*

popraw_kolory
			ldx #24
@			lda ntsc_colors,x
			sta default_colors,x
			dex
			bpl @-
			
			ldx #19
@			lda level_color_value_tab_ntsc,x
			sta POZ.level_color_value_tab+26+3,x
			lda level_color_value_tab_ntsc+20,x
			sta POZ.level_color_value_tab+52+3,x
			lda level_color_value_tab_ntsc+40,x
			sta POZ.level_color_value_tab+78+3,x
			lda level_color_value_tab_ntsc+60,x
			sta POZ.level_color_value_tab+104+3,x
			dex
			bpl @-
			
			ldx #24
@			lda level_colors_tab_ntsc,x
			sta POZ.level_colors_tab,x
			dex
			bpl @-
			
			ldx #31
@			lda tab_spadanie_ntsc,x
			sta joy.tab_spadanie,x
			dex
			bpl @-
			
			ldx #15
@			lda tab_lot.ntsc,x
			sta joy.tab_lot,x
			dex
			bpl @-
			
			lda #<jwbok
			sta joy.jlewo_m+1
			sta joy.jprawo_m+1
			lda #>jwbok
			sta joy.jlewo_s+1
			sta joy.jprawo_s+1	

			mva #mumia_speed_ntsc ai.mumia_speed
			
			ldx #79
@			lda tab_globus2,x
			sta ai.tab_globus2,x
			dex
			bpl @-
			
			mva #<LOT_START joy._lot0+1
			mva #<[LOT_START-16] joy._lot16+1
			mva #<[LOT_START-1] joy._lot1+1
			
			mva #48 cl._after_paraliz+1
			mva #<306 cl._licznik_paraliz+1
			mva #>306 cl._licznik_paraliz+6
			
			mva #30*6/5 next_bonus
			mva #60*6/5 ai._ptak60+1
			mva #50*6/5 cl._ptak50+1
			mva #100*6/5 _ptak100+1
			
			mva #150*6/5 ai.ile_chodzenia
			mva #255*5/6 ai.mumia_spada+1
			
			mva #<[288*5/6] ai.literka_m+1
			mva #>[288*5/6] ai.literka_s+1
			
			//poprawiamy dolną belkę
			mva #<(panel_adr+48) dlist0+33
			sta dlist1+31
			mva #>(panel_adr+48) dlist0+34
			sta dlist1+32
			mva #0 dlist0+35
			sta dlist1+33
			
			ldx #87
@			lda $c00c,x
			sta $c010,x
			dex
			bpl @-
			
			mva #$e6-4 panel._pb0+1		;-4
			mva #$0e _colscore+1
			
			mva #21+3 panel._round+1
			mva #29+4 panel._lives+1
			
			ldx #4
@			lda round_text,x
			sta panel_adr+48+18,x
			lda lives_text,x
			sta panel_adr+48+18+9,x			
			dex
			bpl @-
			
			mva #$68 _posp0+1
			mva #$8c _posp2+1
			mva #$46 _colpm0+1
			mva #$f6 _colpm2+1
			
			rts
		
run			sei
			mva #0 nmien
			sta irqen
			sta muza0
			
			
			sta audctl			;inicjalizacja dźwięku
			mva #3 skctl
			
			mva #$fe portb
			
			mwa #nmi $fffa
			mwa #irq $fffe
			mwa #irq $fffc
		
			mwa #dli dliv
			mwa #vblk vbiv
		
		
			mva #64 nmien
			
			lda #$20
			sta RMTGLOBALVOLUMEFADE
			
			lsr NTSCGTIA
			beq *+5
			jsr popraw_kolory
		
//poczatek
				
			jsr wait_vbl

			mwa #dlist0 dlptr
			mva #192 nmien		;wlacz dli
				
			mva #3 pmcntl
			mva #0 sizem
			mva #>sprites pmbase
			
			jsr multi.init_sprite
			
			mva kolor_gacek0 sprite_c0			;64
			mva kolor_gacek1 sprite_c1			;98
			mva #20 sprite_shape
			sta sprite_shape0
			mva #3 sprite_anim_speed
			mva #4 sprite_anim
			mva #%11 sprite_mask  
			
			mva #1 klawisz
			sta multi.ile_zmian
			
			

			
			lda #0
			sta hscore
			sta hscore+1
			sta hscore+2
			
			ldx #79
@			lda ai.tab_globus2,x
			sta ai.tab_globus_def,x
			dex
			bpl @-
			
			
			
tit0			
			mva #0	level
			sta ruch_poziom
			mva #-1 level_melody

			mva #1 round
			jsr panel.print_round
			mva #0 score
			sta score+1
			sta score+2	
			sta bonus_flag
			sta paraliz_flag
			sta czy_extra
			mva #5 score1		;pierwsze bonus przy 5000 punktach
			mva #20 licznik1_paraliz
			mva #LICZNIK_EXTRA_START licznik_extra
			mva #$ff random_extra
			mva #3 lives
			jsr panel.print_lives
			jsr panel.print_score1
			
			ldx #31
@			sta blok_status,x
			sta blok_x01,x
			sta blok_x23,x
			dex
			bpl @-
			
			jsr tit.title
			
			ldx #79
@			lda ai.tab_globus_def,x		;odtwórz tablicę szybkości kulek
			sta ai.tab_globus2,x
			dex
			bpl @-
			
					
			
			jmp loop1



		
loop		
			lda vcount
			bmi loop
			cmp #$20
			bcc loop

			jsr multi.prepare_sprites
@			lda vcount
			cmp #$70
			bcc @- 
			cmp #$80
			bcs @-
			
			jsr multi.show_sprites
			jsr bomb.animuj_bomby
			
			jsr multi.animuj
			
			lda death
			bne @+
			lda ile_bomb
			beq @+
			jsr cl.player_vs_enemy
@			equ *			
			
			
			lda licznik_paraliz
			ora licznik_paraliz+1
			beq @+
			sec
			lda licznik_paraliz
			sbc #1
			sta licznik_paraliz
			lda licznik_paraliz+1
			sbc #0
			sta licznik_paraliz+1
			ora licznik_paraliz
			bne @+1

			jsr cl.usun_paraliz
			
@			lda death
			bne @+
			jsr ai.new_enemy
			jsr ai.play
@			equ *			
			
			lda ile_score
			beq *+5
			jsr bomb.zgas_bonus
			
			lda death
			beq *+8
			jsr cl.animuj_death
			jmp l0
			
			jsr bomb.zbieraj_bomby

			jsr joy.fire
			jsr joy.move_jack
			jsr joy.joystick	
			jsr joy.joystick_down

			lda ile_bomb
			bne l0
			lda prio
			beq l0a
			lda kanal4
			bne l0

l0a			jsr taniec
			lda ile_zapalonych
			cmp #20
			bcc *+5
			jsr print_bonus				;jesli zebrano 20 lub wiecej zapalonych bomb to pokaz bonus

			lda round
			cmp #$99
			beq l0aa			;zatrzymaj na 99
			
			clc
			sed
			adc #1
			sta round
			cld
l0aa			
			inc level
			lda level
			cmp #63
			bcc *+5
			jmp congrat
			jsr panel.print_round
loop1			

			
			jsr init_level
			jsr POZ.nowy_poziom	
			jsr napisy.start
l0			
			inc ramka
			lda death
			bne l0c
			
			
			
l0c1		jsr sfx.play_fx
			jsr rmt_play0
l0c			
			lda licznik_paraliz
			ora licznik_paraliz+1
			cmp #70
			bne @+
			
			lda #$7c
			jsr rmt_init0		;koncowka paralizu
@			equ *

			lda skstat
			and #4
			bne @+
			ldx kbcode
			cpx #24
			bcc @+
			cpx #32
			bcs @+
			lda kbcode_tab-24,x
			bmi @+
			sta multi.ile_zmian
			sta klawisz

@			jsr panel.print_score
			jmp loop
			
kbcode_tab	dta 4,-1,3,6,-1,5,2,1

init_level				
			jsr multi.init_sprite1
			jsr panel.init
			mva #0 bonus
			sta ile_zapalonych
			

init_level1
			jsr bomb.zgas_bombe
			mva klawisz multi.ile_zmian



			ldx #7
			lda #0
@			sta sprite_x,x
			sta ai.ruch,x
			dex
			bne @-	
			sta blok_x01+1
			sta blok_x23+1
			
			mva #t_none sprite_typ+7	;usuwa jaesli byl tam paraliz
			mva #4 sprite_anim
			mva #0 ile_enemy
			sta czy_zapalona
			sta kolor_P
			sta death
			sta licznik_death
			sta kanal4
			sta kanal3
			sta licznik_paraliz
			sta after_paraliz
			;sta ile_liter		;ile liter pojawilo sie w poziomie
			sta ile_ptakow
			mva next_bonus licznik_bonus
			mva #0 ile_ptakow
_ptak100	mva #100 licznik_ptak
			jsr panel.print_bonus
			jsr panel.print_lives
			
			
			jmp rmt_silence
			
		
wait_vbl
			lda zegar
			cmp zegar
			beq *-2
			rts
		
				
add_pom
			clc
			adc pom
			sta pom
			bcc *+4
			inc pom+1
			rts
			
congrat
			jsr wait_vbl
			mva #$3a dmactl
			mwa #vblk1 vbiv
			jsr multi.hide_sprite
			mva #0 colbak
			jsr rmt_silence
			
			mwa #dlist_congrat dlptr
			mva #>znaki1+1 chbase
			mva #$36 colpf2
			mva #$68 colpf0
			
			lda #$7e
			jsr rmt_init0
			mva #1 muza0		;wlacz muzyke
			
			
@			lda trig0
			beq @-
			
			ldx #50
@			jsr wait_vbl
			dex
			bne @-
			
@			lda trig0
			bne @-
			
@			lda trig0
			beq @-
			
			jsr wait_vbl
			mva #0 dmactl
			sta colpf3
			sta muza0
			sta level
			mwa #vblk vbiv
			mwa #dlist0 dlptr		
			jsr rmt_silence
			
			jmp loop1-3					;zapetlamy poziomy
			
			
			//jmp cl.game_over1
			
			
rmt_init0
			pha
			mva #BANK2 portb

			pla
			ldx #<MUZYKA
			ldy #>MUZYKA
			jsr rmt_init
			
			mva #BANK_off portb
			
			lda #0
			sta kanal4
			sta kanal3
			rts
			
rmt_play0
			asl musicNTSC
			bcc @+
			mva #4 musicNTSC
			rts

@
			mva #BANK2 portb
			jsr rmt_play
			
			mva #BANK_off portb
					
			rts	

wait_anim
			;sec
			;adc zegar
			sta _wa0+1 
			mva #0 zegar
			
@			jsr multi.show_sprites
			inc ramka		
			jsr multi.animuj
			jsr rmt_play0
			jsr bomb.zgas_bonus			
			
wa0			lda vcount
			cmp #$75
			bcs wa0


			jsr multi.prepare_sprites			;przesunieto tą linijke
wa1			lda vcount
			cmp #$70
			bcc wa1  			
			
			lda zegar
_wa0		cmp #0
			bcc @-
			rts	

taniec
			lda #$76
			jsr rmt_init0  ;muzyczka
			jsr rmt_silence
			mva #shp_jtanczy sprite_shape
			sta sprite_shape0
			mva #2 sprite_anim
			mva #1 sprite_mask
			mva #15 sprite_anim_speed
			lda taniec0
			jsr wait_anim
			mva #shp_jtanczy+2 sprite_shape
			sta sprite_shape0
			mva #7 sprite_anim_speed
			lda taniec1
			jsr wait_anim
			mva #shp_jtanczy sprite_shape
			sta sprite_shape0
			mva #15 sprite_anim_speed
			lda taniec0
			jsr wait_anim
			mva #shp_jtanczy+2 sprite_shape
			sta sprite_shape0
			mva #7 sprite_anim_speed
			lda taniec1
			jmp wait_anim
		
nap_bonus0	dta d'YOU'*,b(26+128),d'VE  GOTTEN'*
nap_bonus1	dta d'20 FIRE BOMBS.'*
nap_bonus2	dta d'SPECIAL  BONUS'*
nap_bonus3	dta d' 10000  POINTS'*

wait1
			sta pom0a
@			jsr wait_vbl
			jsr sfx.play_fx
			;jsr rmt_play0
			lda zegar
			and #15
			ora #$50
			sta colpm0s
	
			dec pom0a
			bne @-
			rts

tab_bonus_score
			.he 10,20,30,50
			
print_bonus
			jsr wait_vbl
			mva #0 dmactl
			mva #28 licznik_start+1
			mva #>znaki1 vblk+2
			mwa #dlist1 dlptr
			mva #0 kolor_tlo
			sta kolor1
			mva #$0f kolor2
			
			ldx #$e0
			lda #0
@			sta sprites+$300,x
			sta sprites+$400,x
			sta sprites+$500,x
			sta sprites+$600,x
			sta sprites+$700,x
			dex
			bne @-
			
			ldx #7
@			lda #$fc
			sta sprites+$658,x
			lda #$1e
			sta sprites+$668,x
			lda #$fe
			sta sprites+$680,x
			lda #$7c
			sta sprites+$690,x
			lda #$3f
			sta sprites+$758,x
			sta sprites+$768,x
			lda #$1f
			sta sprites+$780,x
			lda #$3f
			sta sprites+$790,x
			lda #$c0
			sta sprites+$468,x
			lda #$7c
			sta sprites+$490,x
			dex
			bpl @-
			
			
			
			
			
			ldx #192
			lda #$80
@			sta obraz-1,x
			dex
			bne @-
			
			ldx #13
@			lda nap_bonus0,x
			sta obraz+17,x
			lda nap_bonus1,x
			sta obraz+17+48,x
			lda nap_bonus2,x
			sta obraz+17+96,x
			lda nap_bonus3,x
			sta obraz+17+144,x
			dex
			bpl @-
			
			
			mva #$64 hposp2s
			sta hposp0s
			sta hposp1s
			mva #$7c hposp3s
			mva #$ea colpm2s
			sta colpm3s
			mva #3 sizep2s
			sta sizep3s
			sta sizep0s
			mva #$56 colpm0s
			
			lda ile_zapalonych
			sec
			sbc #20
			tay
			ora #$90
			sta obraz+66
			adc #0
			cmp #$94
			bne *+4
			lda #$95
			sta obraz+162
			
			lda tab_bonus_score,y
			sta pom0
			
			jsr wait_vbl
			mva #$3b dmactl
			
			;lda #$8e
			;jsr rmt_init0
			
			
			lda #70
			jsr wait1
			
@			sec
			lda pom0
			beq @+
			sed
			sbc #1
			sta pom0
			
			lda score1			;pomijamy wpływ bonusu na pojawienie sie B
			adc #1
			sta score1
			cld
			
			lda pom0
			and #15
			ora #$90
			sta obraz+163
			lda pom0
			:4 lsr
			ora #$90
			sta obraz+162
			
			lda #1
			jsr score_addx100
			jsr panel.print_score
			
			ldy #fx_uderzenie
			lda #2
			jsr sfx.add_fx 
			
			lda #2
			jsr wait1
			
			jmp @-
			
@			
			jsr rmt_silence
			lda #110
			jsr wait1
			
			mwa #dlist0 dlptr
			mva #0 dmactl
			sta sizep0s
			sta sizep2s
			sta sizep3s
			
			mva #2 licznik_start+1		;odtworzenie oryginalnej wartosci
			mva #>znaki vblk+2
			rts
			
			
tab_melody	.he 0f,25,42,4a,5b
max_melody=*-tab_melody			
			
			
			icl 'rmtplayr.asm'
			
			;org $b600
muzyka=$4000		
			;ins 'ingame.rmt'
		
		
			run run
			