//efekty dzwiekowe
fx_krok=0*2
fx_ladowanie=1*2
fx_bomba=2*2
fx_bomba1=3*2
fx_uderzenie=4*2
fx_paraliz=5*2
fx_literka=6*2
fx_extra=7*2

.local sfx

add_fx1
		lda audf_table,y
		sta kanal_audf1+2*2
		lda audf_table+1,y
		sta kanal_audf1+1+2*2
		
		lda audc_table,y
		sta kanal_audc1+2*2
		lda audc_table+1,y
		sta kanal_audc1++1+2*2
		
		lda len_table,y
		sta kanal1+2*2				;dlugosc
		sta kanal1s+2*2
		lda len_table+1,y
		sta petla1+2*2			;petla
		rts


channel=3
add_fx
		ldx kanal4
		beq @+
		cpy #fx_krok
		bne *+3
		rts
		cmp prio
		bcs @+
		rts
@		
		sta prio
		lda audf_table,y
		sta kanal_audf1+channel*2
		lda audf_table+1,y
		sta kanal_audf1+1+channel*2
		
		lda audc_table,y
		sta kanal_audc1+channel*2
		lda audc_table+1,y
		sta kanal_audc1++1+channel*2
		
		lda len_table,y
		sta kanal1+channel*2				;dlugosc
		sta kanal1s+channel*2
		lda len_table+1,y
		sta petla1+channel*2			;petla

		rts
		

play_fx
		ldy kanal3
		beq pfx4
		lda (kanal_audf3),y
		sta audf3
		lda (kanal_audc3),y
		sta audc3
		dey
		bne @+					;jeszcze nie koniec
		lda petla3			;czy zapetlony 0=nie
		beq @+
		ldy kanal3s
@		sty kanal3	


pfx4	ldy kanal4
		beq pfx0
		lda (kanal_audf4),y
		sta audf4
		lda (kanal_audc4),y
		sta audc4
		dey
		bne @+					;jeszcze nie koniec
		lda petla4			;czy zapetlony 0=nie
		beq @+
		ldy kanal4s
@		sty kanal4	

pfx0	rts	

audf_table
		dta a(krok_audf),a(ladowanie_audf),a(bomba_audf),a(bomba1_audf),a(uderzenie_audf),a(paraliz_audf),a(literka_audf),a(extra_audf)
		
audc_table
		dta a(krok_audc),a(ladowanie_audc),a(bomba_audc),a(bomba1_audc),a(uderzenie_audc),a(paraliz_audc),a(literka_audc),a(extra_audc)
		
len_table
		dta b(8),b(0)	;krok 0x2
		dta b(6),b(0)	;ladowanie 1x2
		dta b(8),b(0)	;zebranie bomby
		dta b(8),b(0)	;zebranie bomby bonusowej
		dta b(4),b(0)	;uderzenie w rampę
		dta b(4),b(1)	;paraliz
		dta b(8),b(0)	;zebranie literki
		dta b(18),b(0)	;extra life
		
		
krok_audf	.he 00,00,21,2d,35,48,40,35,b6
krok_audc	.he 00,00,64,64,67,67,36,36,33	

ladowanie_audf .he 00,00,00,10,10,20,10,20,10
ladowanie_audc .he 00,00,00,64,65,66,67,68,69	

bomba_audf	.he 00,00,86,76,66,56,46,66,86	;.he 00,00,b6,a6,96,86,76,96,b6
bomba_audc	.he 00,00,a6,a7,a8,a9,a9,a7,a6

bomba1_audf	.he 00,00,76,66,56,46,36,56,76
bomba1_audc	.he 00,00,a9,aa,a9,a8,a7,a6,a5

uderzenie_audf	.he 00,00,d8,a0,d8
uderzenie_audc	.he 00,00,a7,ab,a7

paraliz_audf	.he 00,30,50,40,20
paraliz_audc	.he 00,a4,a0,a6,c8

literka_audf	.he 00,00,40,30,20,10,06,10,30
literka_audc	.he 00,00,a7,a8,a7,a6,a5,a4,a3

extra_audf	.he 00,80,20,80,20,80,20,80,20,80,20,80,20,80,20,80,20,20,20
extra_audc	.he 00,c1,c2,c4,c4,c6,c6,c8,c8,ca,ca,cc,cc,cd,cd,cf,cf,cf,cf
.endl
		
