//obsluga przeciwnikow

//typy przeciwnikow
t_oko=0
t_czapka=1			;lewo i prawo
t_radar=2
t_ufo=3
t_globus=4
t_ptak=5
t_bonus=6
t_extra=7
t_paraliz=8
t_mumia=10
t_none=11


.local ai

//stałe
explo_anim=4
explo_anim_speed=15



ai_explo=1
ai_spada=2
ai_chodzi=3
ai_przemiana=4
ai_wylosuj=5

ai_oko=6
ai_czapka=7
ai_radar=8
ai_ufo=9
ai_globus=10
ai_ptak=11
ai_bonus=12
ai_extra=13
ai_paraliz=14

//zmienne
czekanie	dta b(0)			;kiedy pierwszy enemy
czekanie1	dta b(150)			;kiedy nastepny

mumia_speed	dta b(96)
mumia_kolor	dta b($08)
ile_chodzenia	dta b(150)		;ile czasu mumia chodzi po rampie zanim spadnie


//tablice
ruch		org *+8			;typ ai
ruch_x		org *+8
ruch_dx		org *+8
ruch_y		org *+8
ruch_dy		org *+8
ruch_p0		org *+8			;tablica pomocnicza
ruch_p1		org *+8
ruch_p2		org *+8


prepare_tab dta a(0),a(prepare_explo),a(prepare_spada),a(prepare_chodzi),a(prepare_przemiana),a(prepare_wylosuj)
			dta a(prepare_oko),a(prepare_czapka),a(prepare_radar),a(prepare_ufo),a(prepare_globus)
			dta a(prepare_ptak),a(prepare_bonus),a(prepare_extra),a(prepare_paraliz)
ai_tab		dta a(0),a(ruch_explo),a(ruch_spada),a(ruch_chodzi),a(ruch_przemiana),a(ruch_wylosuj)
			dta a(ruch_oko),a(ruch_czapka),a(ruch_radar),a(ruch_ufo),a(ruch_globus)
			dta a(ruch_ptak),a(ruch_bonus),a(ruch_extra),a(ruch_paraliz)

;paraliz_tab	dta 14,2,0		;przy ilu bombach pojawi sie paraliz

//pojawianie sie nowych przeciwników
new_enemy
		lda ramka
		and #63
		bne @+

		lda czy_extra
		bne @+
		lda random
		and random_extra
		cmp #1
		bne @+
		sta czy_extra
@		equ *

		lda ramka
		and #3
		bne @+1		;co czwartą ramkę
		lda sprite_x+7
		bne @+1
		
		dec licznik_bonus
		bne @+1
		mva next_bonus licznik_bonus
		
		
		lda czy_extra
		beq @+		
		;lda random								;extra przeniesione wyzej
		;and random_extra
		;cmp #2
		;bne @+
		mva #0 czy_extra
		lda random_extra
		asl
		ora #1
		sta random_extra
		lda #ai_extra
		ldx #7
		jsr add_ai
		;lda random_extra
		;sec
		;rol
		;and #31
		;sta random_extra
		jmp @+1
	
@		lda paraliz_flag
		beq ne0
		
		dec paraliz_flag
		lda #ai_paraliz
		ldx #7
		jsr add_ai				;przy opowiedniej liczbie bomb pojawi sie paraliz
		
		ldy #fx_paraliz
		jsr sfx.add_fx1
		
		
		jmp @+
		
ne0		
		lda bonus_flag
		beq @+					;teraz nie może być B
		
		
		lda bonus
		cmp #4
		bcs @+
		lda #ai_bonus
		ldx #7
		jsr add_ai
		
		mva #0 bonus_flag

@		lda ile_ptakow
		cmp max_ptakow
		bcs @+	
		
		dec licznik_ptak
		bne @+
		inc ile_ptakow
_ptak60		
		mva #60 licznik_ptak
		
		
		ldx #6
		lda sprite_x,x
		beq *+3
		dex
		
		lda #ai_ptak
		jsr add_ai
@		equ *

		lda czekanie		;czy na cos czekamy?
		bne *+3
@		rts
		
		dec czekanie
		bne @-
		
		inc ile_enemy
		
		ldx #1
@		lda sprite_x,x
		beq @+
		inx
		bne @-
		rts
@		equ *					;poszukaj pustego duszka
		
		jsr add_enemy0
		lda ile_enemy
		cmp max_enemy
		bcc @+
		
		mva #0 czekanie			;wszyscy na ekranie
		rts
		
@		lda czekanie1
		ldy ile_ramp
		bne *+4
		lda #30
		sta czekanie
		rts
		
rampa_tab	org *+4
tab_maska
		.he fc,00,ff
tab_maska1
		.he 00,00,03
		
//dodajemy mumię, na początku sam wybuch		
add_enemy0		
			
		mva #t_none sprite_typ,x
		mva #$12 sprite_y,x
		mva #shp_explo	sprite_shape,x
		sta sprite_shape0,x
		mva #explo_anim_speed sprite_anim_speed,x
		mva explo_c0 sprite_c0,x
		mva explo_c1 sprite_c1,x
		mva #explo_anim sprite_anim,x
		mva #%11 sprite_mask,x

		
		lda ile_ramp
		beq @+
		
		ldy #2
		lda sprite_x
		bpl *+4
		ldy #0
		
		lda tab_maska,y
		sta pom0a
		lda tab_maska1,y
		sta pom0b
		
		
ade0	lda random
		and rampa_tab,y
		clc
		adc rampa_tab+1,y
		and pom0a
		ora pom0b
		sta pom0
		sec
		sbc sprite_x
		bcs *+6
		eor #255
		adc #1
		cmp #10
		bcc ade0
		lda pom0
		
		jmp @+1
		
		
@		lda random
		and #%01101111
		clc
		adc #70
		sta pom0
		
		sec
		sbc sprite_x
		bcs *+6
		eor #255
		adc #1
		cmp #30
		bcc @-
		lda pom0
		
@		;sta mumia_x
		cmp #POSX_MAX
		bcc @+
		lda #POSX_MAX
@		sta sprite_x,x

		lda #ai_explo	
		jmp add_ai

//dodaje nowe ai
add_ai
		sta ruch,x
		asl
		tay
		lda prepare_tab,y
		sta _adi+1
		lda prepare_tab+1,y
		sta _adi+2

_adi	jmp $ffff

prepare_explo
		mva #20 ruch_p0,x			;czas wybuchu
		rts

prepare_spada
		
		mva #shp_mumia_spada sprite_shape,x
		sta sprite_shape0,x
		mva #7 sprite_anim_speed,x
		mva #2 sprite_anim,x
		mva #1 sprite_mask,x
		mva #$02 sprite_c0,x
		mva mumia_kolor sprite_c1,x
mumia_spada		
		mva #$ff ruch_dy,x			
		rts
		
prepare_chodzi
		lda sprite_y,x
		cmp #POSY_MAX
		bne @+
		
		lda #ai_przemiana	;na samym dole, włącz przemianę
		jmp add_ai
	

@		lda random
		and #4
		ora #shp_mumia_lewo
		sta sprite_shape,x
		;mva #shp_mumia_lewo sprite_shape,x
		sta sprite_shape0,x
		mva #3 sprite_anim,x
		mva #%11 sprite_mask,x
		mva #7 sprite_anim_speed,x
		mva mumia_speed ruch_dx,x
		mva ile_chodzenia ruch_p0,x
		rts
		
prepare_przemiana
		mva #t_none sprite_typ,x
		mva #shp_przemiana sprite_shape,x
		sta sprite_shape0,x
		mva #4 sprite_anim,x
		mva #%11 sprite_mask,x
		mva #15 sprite_anim_speed,x
		mva #$64 sprite_c0,x
		mva #$38 sprite_c1,x
		mva #35 ruch_p0,x					;czas przemiany
		rts
	
tab0	dta shp_oko,shp_czapka,shp_radar,shp_ufo,shp_globus
tab1	.he 62,04,02,04,02
tab2	.he 38,78,38,b8,98
tab3	dta 3,7,7,3,7
tab4	dta t_oko,t_czapka,t_radar,t_ufo,t_globus
tab5	dta ai_oko,ai_czapka,ai_radar,ai_ufo,ai_globus

//losuje typ przeciwnika
prepare_wylosuj		
		lda random
		and #3
		cmp #3
		beq @+
		
		lda random
		and #3
		cmp #2
		beq @+
		
		lda random
		and #3
		cmp #1			;czapka
		beq @+
		
		lda random
		and #4
@		
		tay
		lda tab0,y
		sta sprite_shape,x
		sta sprite_shape0,x
		mva #4 sprite_anim,x
		mva #%11 sprite_mask,x
		lda tab3,y
		sta sprite_anim_speed,x
		lda tab1,y
		sta sprite_c0,x
		lda tab2,y
		sta sprite_c1,x
		lda tab4,y
		sta sprite_typ,x
		
		lda random
		and #3
		sta ruch_p0,x
		
		lda tab5,y
		jmp add_ai

prepare_czapka
		mva #0 ruch_p2,x
		lda random
		and #4
		sta ruch_p0,x
		bne prep3
		mva #shp_czapka1 sprite_shape,x		;prawo
		jmp prep3
		
prepare_radar
		lda #0
		sta ruch_p2,x
		jmp prep2		
		
prepare_ufo		
prepare_oko
prepare_globus
		lda random
		and #3
		sta ruch_p2,x
prep2
		lda random
		and #4
		sta ruch_p0,x		;kierunek w poziomie
prep3		
		lda random
		lsr
		and #4
		sta ruch_p1,x		;kierunek w pionie
		
		

		rts
		
ptak_tab2	dta shp_ptak_prawo,shp_ptak_pion,shp_ptak_lewo,shp_ptak_pion	

prepare_ptak
		lda #$b0
		ldy sprite_x
		bpl @+
		lda #$48
@		sta sprite_x,x
		and #$08
		:2 lsr
		tay
		
		mva #1 ruch_p2,x
		lda #$10
		cpx #5
		bne @+
		mva #3 ruch_p2,x
		lda #$d0
		ldy #3
@		sta sprite_y,x
				
		mva #t_ptak sprite_typ,x


		txa					;każdy ptak zaczyna w innej osi
		lsr
		and #1
		sta ruch_p0,x		;kierunek poszukiwania, 0=poziom, 1=pion	
		tya
		and #2
		sta ruch_p1,x		;kierunek poruszania sie ptaka 0=prawo,1=dol,2=lewo,3=gora
		
		tay
		lda ptak_tab2,y
		sta sprite_shape,x
		sta sprite_shape0,x
		mva #7 sprite_anim_speed,x
		mva #3 sprite_anim,x			;ilosc klatek animacji
		mva #%11 sprite_mask,x
		mva #$04 sprite_c0,x
		lda #$e8
		cpx #5
		bne @+
		lda #$48				;inny kolor drugiego ptaka
@		sta sprite_c1,x
		
		rts
		
//przygotowuje pojawienie się literki B	
prepare_bonus		
		mva #shp_bonus sprite_shape,x
		sta sprite_shape0,x
		mva #$d6 sprite_c0,x
		mva #$ba sprite_c1,x
		
		mva #t_bonus sprite_typ,x		
			
prepare_bonus1	
		mva #110 ruch_p1,x		;czas trwania literki
		mva #7 sprite_anim_speed,x
		mva #4 sprite_anim,x
		mva #%11 sprite_mask,x

		mva #$14 sprite_y,x
		
		mva #1 ruch_p0,x
		ldy #$48
		lda sprite_x
		cmp #$74
		bcs *+7
		ldy #$b0
		dec ruch_p0,x
		tya
		sta sprite_x,x
		
		rts
		
prepare_extra
		mva #shp_extra sprite_shape,x
		sta sprite_shape0,x
		mva #$d6 sprite_c0,x
		mva #$ba sprite_c1,x
		
		mva #t_extra sprite_typ,x		
		jmp prepare_bonus1
		
prepare_paraliz
		mva #shp_paraliz sprite_shape,x
		sta sprite_shape0,x
		mva paraliz_tab0+1 sprite_c0,x
		mva paraliz_tab1+1 sprite_c1,x
		mva #1 kolor_P
		
		mva #3 sprite_anim_speed,x
		mva #4 sprite_anim,x
		mva #%11 sprite_mask,x
		
		mva #4+3 ruch_p0,x
		mva #6+1 ruch_p1,x
		
		ldy #$48
		lda sprite_x
		cmp #$74
		bcs @+
		ldy #$b0
		mva #2+1 ruch_p0,x
@		sty pom0
		lda random
		and #7
		ora pom0
		sta sprite_x,x
		mva #$14 sprite_y,x
		
		mva #t_paraliz sprite_typ,x		
		rts	

//wykonuje ai wszystkich duszków, odpowiednie dla danego obiektu		
play
		ldx #7
@		lda ruch,x
		bne @+
play_next		
		dex
		bne @-
		rts
		
@		asl
		tay
		lda ai_tab,y
		sta _play+1
		lda ai_tab+1,y
		sta _play+2		
_play	jsr $ffff
		jmp play_next


ruch_explo
		dec ruch_p0,x
		beq *+3
		rts
		lda #ai_spada
		jmp add_ai

		;rts

ruch_spada
		mva #t_mumia sprite_typ,x
		lda sprite_x,x
		sta cl.sprite0x
		clc
		lda sprite_dy,x
		adc ruch_dy,x
		sta pom0a
		lda sprite_y,x
		adc #0
		sta cl.sprite0y
		
		jsr cl.sprawdz_pod_gackiem
		bne @+

		;jsr cl.sprite_vs_rampa
		;bmi @+
		lda #ai_chodzi			;mumia laduje 
		jmp add_ai
	
@		lda pom0a
		sta sprite_dy,x
		lda cl.sprite0y
		sta sprite_y,x

		rts
		
ruch_chodzi
		lda ruch_p0,x
		beq *+5
		dec ruch_p0,x

		lda sprite_shape0,x
		cmp #shp_mumia_lewo
		bne mumia_prawo
		
//mumia idzie w lewo
		lda sprite_y,x
		sta cl.sprite0y
		sec
		lda sprite_dx,x
		sbc ruch_dx,x
		sta pom0a
		lda sprite_x,x
		sbc #0
sprawdz_mumia_dol		
		sta cl.sprite0x
		
		jsr cl.sprawdz_lewo_gacek
sprawdz_mumia_dol1		
		beq @+
		
		;jsr cl.sprite_vs_rampa
		;bpl @+				;uderzyl w sciane, wiec nie moze spasc
				
		lda pom0a
		sta sprite_dx,x
		lda cl.sprite0x
		sta sprite_x,x
		
		inc cl.sprite0y
		
		jsr cl.sprawdz_pod_gackiem
		bne obroc_mumie
		
		rts
		
obroc_mumie
		lda ruch_p0,x
		bne @+
		lda #ai_spada
		jmp add_ai
		
@		lda sprite_shape0,x
		eor #4
		sta sprite_shape0,x
		sta sprite_shape,x
		rts
		
mumia_prawo
		lda sprite_y,x
		sta cl.sprite0y
		clc
		lda sprite_dx,x
		adc ruch_dx,x
		sta pom0a
		lda sprite_x,x
		adc #0
		sta cl.sprite0x
		
		jsr cl.sprawdz_prawo_gacek
		jmp sprawdz_mumia_dol1
		
ruch_przemiana
		dec ruch_p0,x
		bne @+
		
		lda #ai_wylosuj
		jmp add_ai
		
@		rts


ruch_wylosuj
		rts

		
glob_speed0=47	;64
glob_speed1=67	;96
glob_speed2=87	;128
glob_speed3=125	;160
		

tab_globus2 dta <(-glob_speed0*2),<(-glob_speed1*2),<(-glob_speed2*2),<(-glob_speed3*2),<(glob_speed0*2),<(glob_speed1*2),<(glob_speed2*2),<(glob_speed3*2)
tab_globus0 dta <-glob_speed0,<-glob_speed1,<-glob_speed2,<-glob_speed3,<glob_speed0,<glob_speed1,<glob_speed2,<glob_speed3
			dta <(-glob_speed0*2),<(-glob_speed1*2),<(-glob_speed2*2),<(-glob_speed3*2),<(glob_speed0*2),<(glob_speed1*2),<(glob_speed2*2),<(glob_speed3*2)
			
ptak_tabX0 dta <speed_ptak,0,<-speed_ptak,0,<speed_ptak1,0,<-speed_ptak1,0
ptak_tabY0 dta 0,<(2*speed_ptak),0,<-(2*speed_ptak),0,<(2*speed_ptak1),0,<-(2*speed_ptak1)

tab_globus3	dta >(-glob_speed0*2),>(-glob_speed1*2),>(-glob_speed2*2),>(-glob_speed3*2),>(glob_speed0*2),>(glob_speed1*2),>(glob_speed2*2),>(glob_speed3*2)	
tab_globus1 dta >-glob_speed0,>-glob_speed1,>-glob_speed2,>-glob_speed3,>glob_speed0,>glob_speed1,>glob_speed2,>glob_speed3
			dta >(-glob_speed0*2),>(-glob_speed1*2),>(-glob_speed2*2),>(-glob_speed3*2),>(glob_speed0*2),>(glob_speed1*2),>(glob_speed2*2),>(glob_speed3*2)	
			
speed_ptak=95	
speed_ptak1=115


ptak_tabX1 dta >speed_ptak,0,>-speed_ptak,0,>speed_ptak1,0,>-speed_ptak1,0			
ptak_tabY1 dta 0,>(2*speed_ptak),0,>-(2*speed_ptak),0,>(2*speed_ptak1),0,>-(2*speed_ptak1)			
			
			
tab_globus_def	org *+80
		
ruch_globus1
		ldy #3
		lda sprite_typ,x
		cmp #t_paraliz
		beq @+
		cmp #t_radar
		beq @+
		cmp #t_czapka
		bne	czp0
		ldy #1			;czapka ma 2 predkosci
		lda pom
		bne czp0
		lda #0
		sta ruch_p2,x
		rts						
czp0		
		tya
		and random
		sta ruch_p2,x
@		rts



ruch_czapka
ruch_paraliz
ruch_ufo
ruch_oko
ruch_globus
ruch_radar
		mva #0 pom
		
		
		lda ruch_p2,x
		ora ruch_p0,x
		ldy sprite_typ,x
		cpy #t_ufo
		bne *+4
		ora #8
		tay
		clc
		lda sprite_dx,x
		adc tab_globus0,y
		sta pom0
		lda tab_globus1,y
		sta pom0h
		adc sprite_x,x
		;lda sprite_x,x
		;adc tab_globus1,y
		sta pom0a
		sta cl.sprite0x

		lda sprite_y,x
		sta cl.sprite0y
		
		jsr cl.sprawdz_osX
		bne @+
		
		//jsr cl.sprite_vs_rampa			;sprawdz po osi X
		//bmi @+
		inc pom
		lda ruch_p0,x
		eor #4
		sta ruch_p0,x
		
@		lda ruch_p2,x
		ora ruch_p1,x
		ldy sprite_typ,x
		cpy #t_ufo
		bne *+4
		ora #8
		tay
		clc
		lda sprite_dy,x
		adc tab_globus2,y
		sta pom0b
		lda tab_globus3,y
		sta pom0h
		adc sprite_y,x
		;lda sprite_y,x
		;adc tab_globus3,y
		sta pom0c
		sta cl.sprite0y
		lda sprite_x,x
		sta cl.sprite0x
		
		jsr cl.sprawdz_osY
		bne @+
		
		;jsr cl.sprite_vs_rampa			;sprawdz po osi Y
		;bmi @+
		
		inc pom
		lda ruch_p1,x
		eor #4
		sta ruch_p1,x
		
@		lda pom
		jne ruch_globus1
		
				
@		lda pom0
		sta sprite_dx,x
		lda pom0a
		sta sprite_x,x
		
		lda pom0b
		sta sprite_dy,x
		lda pom0c
		sta sprite_y,x
		
poprawki
		lda ramka
		and #31
		beq *+3
		rts
		
//POPRAWKI dla KULI,globusa i radaru	
		lda sprite_typ,x
		cmp #t_oko
		bne z4				;inny typ
//KULKA		
		sec
		lda sprite_y,x
		sbc sprite_y
		bcs @+
		eor #255
		adc #1
@		cmp #24
		bcc z0
		
		lda sprite_y,x
		cmp sprite_y
		bcs z2		;pod gackiem
		
//jest wyzej niz jack
		lda ruch_p1,x		;jaki mamy kierunek
		beq z3
z0		rts
		//zly kierunek
z3		dec ruch_p2,x		;zmniejsz speed
		bpl z0
		//zmiana kierunku
		lda ruch_p1,x
		eor #4
		sta ruch_p1,x		;w dol	
		jmp ruch_globus1
//jest pod gackiem	
z2
		lda ruch_p1,x
		bne z3
		rts
//GLOBUS		
z4		
		cmp #t_globus
		bne z8
		
		sec
		lda sprite_x,x
		sbc sprite_x
		bcs @+
		eor #255
		adc #1
@		cmp #12
		bcc z5
		
		lda sprite_y,x
		cmp sprite_y
		bcs z6		;po prawo od gacka
		
//jest po lewo od  jack
		lda ruch_p0,x		;jaki mamy kierunek
		beq z7
z5		rts
		//zly kierunek
z7		dec ruch_p2,x		;zmniejsz speed
		bpl z5
		//zmiana kierunku
		lda ruch_p0,x
		eor #4
		sta ruch_p0,x		;w dol	
		jmp ruch_globus1
//jest po prawo od gacka	
z6
		lda ruch_p0,x
		bne z7
		rts
//RADAR
z8		cmp #t_radar
		bne z9
		
		lda ramka
		and #127
		bne @+
		
		lda random
		and #4
		sta ruch_p0,x			;losowy kierunek ruchu
		lda random
		and #4
		sta ruch_p1,x
@		rts

z9		cmp #t_czapka
		bne cz1
//CZAPKA
		lda random
		and #3
		tay
		lda tab_czapka,y
		and ramka
		;lda ramka
		;and #127
		bne cz0
		
		ldy #0
		sec
		lda sprite_x,x
		sbc sprite_x
		bcs *+4
		ldy #4
		tya
		sta pom0
		sta ruch_p0,x		;ustaw kierunek X
		
@		ldy #0
		sec
		lda sprite_y,x
		sbc sprite_y
		beq cz0
		bcs *+4
		ldy #4
		tya
		sta ruch_p1,x		;ustaw kierunek y
		mva #0 ruch_p2,x		;zwolnij
		jmp cz0a
cz0
		ldy #0
		sec
		lda sprite_x,x
		sbc sprite_x
		bcs *+4
		ldy #4
		sty pom0
cz0a		
		lda sprite_shape,x
		and #%11111011
		ora pom0
		sta sprite_shape,x		;wybór duszka lewo/prawo
		and #$fc
		sta sprite_shape0,x
cz1
		rts

tab_czapka	dta b(127,63,31,127)

ruch_ptak
		lda ruch_p0,x
		jne ptakY					;szukamy po Y

		
@		lda sprite_x
		cmp sprite_x,x
		bne @+

		
		mva #1 ruch_p0,x		;znalazł gracza na osi X, teraz bedzie szukał po osi Y
		tay
		lda sprite_y			;w którym kierunku ma sie poruszac ?
		cmp sprite_y,x
		bcs *+4
		ldy #3
		tya
		cpx #5
		bne *+4
		ora #4
		sta ruch_p1,x
		jmp ptak_shape

@		ldy #0
		lda sprite_x
		cmp sprite_x,x
		bcs *+4
		ldy #2
		tya
		cpx #5
		bne *+4
		ora #4
		cmp ruch_p1,x
		beq ruch_ptak1		;kierunek do gracza zgodny z kierunkiem poruszania
		tay
		
		lda ruch_p1,x
		bit bit0				;jeśli ruch w poziomie
		bne @+
		clc
		adc ruch_p2,x
		and #3
		cpx #5
		bne *+4
		ora #4
		tay
		

@		sty pom0a
		
		clc
		lda sprite_dx,x
		adc ptak_tabX0,y
		sta pom0
		lda sprite_x,x
		adc ptak_tabX1,y
		sta cl.sprite0x
		clc
		lda sprite_dy,x
		adc ptak_TABY0,y
		sta pom0b
		lda sprite_y,x
		adc ptak_tabY1,y
		sta cl.sprite0y
		
		jsr cl.sprawdzXY
		beq ruch_ptak1
		
		//jsr cl.sprite_vs_rampa			;sprawdzamy czy mozna juz dotrzec do gracza najkrotsza drogą
		//bpl ruch_ptak1			;nie zmieniaj kierunku poruszania
		
		lda pom0
		sta sprite_dx,x
		lda cl.sprite0x
		sta sprite_x,x
		lda pom0b
		sta sprite_dy,x
		lda cl.sprite0y
		sta sprite_y,x
		
p0		lda pom0a
		sta ruch_p1,x
		tay
		
		jmp ptak_shape

ruch_ptak1		
@		ldy ruch_p1,x
		clc
		lda sprite_dx,x
		adc ptak_tabX0,y
		sta pom0
		lda sprite_x,x
		adc ptak_tabX1,y
		sta cl.sprite0x
		
		clc
		lda sprite_dy,x
		adc ptak_tabY0,y
		sta pom0a
		lda sprite_y,x
		adc ptak_tabY1,y
		sta cl.sprite0y
		
		jsr cl.sprawdzXY
		beq @+
		
		//jsr cl.sprite_vs_rampa
		//bpl @+
	
		lda pom0
		sta sprite_dx,x
		lda cl.sprite0x
		sta sprite_x,x
		lda pom0a
		sta sprite_dy,x
		lda cl.sprite0y
		sta sprite_y,x
		rts
	
@		clc
		lda ruch_p1,x		;po trafieniu w rampę zmień kierunek poruszania się
		adc ruch_p2,x		;1 w prawo ,255 w lewo
		and #3
		cpx #5
		bne *+4
		ora #4
		sta ruch_p1,x			
		
		tay					;zmien też ksztalt ptaka zaleznie od nowego kierunku
ptak_shape	
		tya
		and #3
		tay
		lda ptak_tab2,y
		sta sprite_shape,x
		sta sprite_shape0,x
		
		rts
		

ptakY	lda sprite_y
		cmp sprite_y,x
		bne @+
		
		mva #0 ruch_p0,x		;znalazl gracza na osi Y, teraz bedzie szukal po osi X
		tay
		lda sprite_x			;w którym kierunku najblizej do gracza?
		cmp sprite_x,x
		bcs *+4
		ldy #2
		tya
		cpx #5
		bne *+4
		ora #4
		sta ruch_p1,x
		
		jmp ptak_shape
		
@		ldy #1
		lda sprite_y
		cmp sprite_y,x
		bcs *+4
		ldy #3
		tya
		cpx #5
		bne *+4
		ora #4
		tay
		
		cmp ruch_p1,x
		jeq ruch_ptak1			;prawidlowy kierunek
		
		lda ruch_p1,x
		bit bit0
		beq @+

		clc
		lda ruch_p1,x
		adc ruch_p2,x
		and #3
		cpx #5
		bne *+4
		ora #4
		tay

@		sty pom0a
		clc
		lda sprite_dy,x
		adc ptak_tabY0,y
		sta pom0
		lda sprite_y,x
		adc ptak_tabY1,y
		sta cl.sprite0y
		clc
		lda sprite_dx,x
		adc ptak_tabX0,y
		sta pom0b
		lda sprite_x,x
		adc ptak_tabX1,y
		sta cl.sprite0x
		
		jsr cl.sprawdzXY
		jeq ruch_ptak1
		
		
		//jsr cl.sprite_vs_rampa			;sprawdzamy czy mozna juz dotrzec do gracza najkrotsza drogą
		//jpl ruch_ptak1
		
		lda pom0
		sta sprite_dy,x
		lda cl.sprite0y
		sta sprite_y,x
		lda pom0b
		sta sprite_dx,x
		lda cl.sprite0x
		sta sprite_x,x
		
		
p1		lda pom0a
		sta ruch_p1,x
		tay
		
		jmp ptak_shape

		
		

tab_bonus0	dta <-120,<120				;zmiana z 80 na 120
tab_bonus1	dta >-120,>120	

ruch_extra
ruch_bonus
		;sprawdz czy będzie spadać
		lda ramka
		and #7
		bne @+2
		dec ruch_p1,x
		beq @+1
		lda ruch_p1,x
		cmp #20
		bne @+2
@		mva #-1 ruch_p0,x		
		jmp @+1
@		mva #0 sprite_x,x
		sta ruch,x
@		equ *

		
		clc
		lda sprite_c0,x
		adc #$10
		sta sprite_c0,x
		
		lda sprite_x,x
		sta cl.sprite0x
		
		clc
		lda sprite_dy,x
literka_m		
		adc #32
		sta pom0a
		lda sprite_y,x
literka_s		
		adc #1
		sta cl.sprite0y
		
		jsr cl.sprawdz_pod_gackiem
		beq @+
		
		
		//jsr cl.sprite_vs_rampa
		//bpl @+
		
		;spada
		lda pom0a
		sta sprite_dy,x
		lda cl.sprite0y
		sta sprite_y,x
		;lda sprite_shape0,x
		;sta sprite_shape,x		;ustaw 1 faze ksztaltu podczas spadania
		rts
		
@		clc
		ldy ruch_p0,x
		bpl *+3
		rts							;zatrzymaj literke
		lda sprite_dx,x
		adc tab_bonus0,y
		sta pom0a
		lda tab_bonus1,y
		sta pom0h
		adc sprite_x,x
		//lda sprite_x,x
		//adc tab_bonus1,y
		sta cl.sprite0x
		lda sprite_y,x
		sta cl.sprite0y
		
		jsr cl.sprawdz_osX
		bne @+
		
		
		//jsr cl.sprite_vs_rampa
		//bmi @+
		
		;zmien kierunek, sciana
		lda ruch_p0,x
		eor #1
		sta ruch_p0,x
		rts
		
@		lda pom0a
		sta sprite_dx,x
		lda cl.sprite0x
		sta sprite_x,x
		rts
	

		

				
.endl
