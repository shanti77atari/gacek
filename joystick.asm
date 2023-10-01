//obsługa sterowania

.local joy

			
tab_spadanie	dta a(246),a(246),a(215),a(215),a(160),a(160),a(160),a(160),a(80),a(80),a(40),a(40),a(20),a(20),a(10),a(10)
	
end_spadanie	equ *
LEN_SPADANIE=(end_spadanie-tab_spadanie)/2-1	
			
move_jack
			lda spadanie
			bne @+			
			lda sprite_y
			cmp #POSY_MAX
			bcc *+3			
			rts
//jack chodzi po rampie	
			;clc
			adc #1
			sta cl.sprite0y
			lda sprite_x
			sta cl.sprite0x

			jsr cl.sprawdz_pod_gackiem
			bcc *+4
			bne *+3
			rts

			
			mva #1 spadanie			;jack zszedł z rampy
			mva #LEN_SPADANIE predkosc_spadanie
			mva #-1 sprite_anim_speed
			mva #shp_jstoi sprite_shape
			mva #0 ruch_poziom
			rts
				
@			lda predkosc_spadanie
			beq @+
			lda ramka
			and #1
			bne @+
			dec predkosc_spadanie			;zwieksza predkosc spadania
			
@			lda spadanie
			jmi movej_gora
			
movej_dol	
			mva #3 pom0			;jak szybko spadamy
			

mvd0		lda predkosc_spadanie
			asl
			tax
			clc 
			lda sprite_dy
			adc tab_spadanie,x
			sta pom0a
			lda sprite_y
			adc tab_spadanie+1,x
			sta cl.sprite0y
			lda sprite_x
			sta cl.sprite0x

			jsr cl.sprawdz_pod_gackiem
			bcc @+
			bne @+

mvd1			
			mva #0 spadanie		;koniec spadania
			sta ruch_poziom
			mva #shp_jstoi sprite_shape
			
			lda #1
			ldy #fx_ladowanie
			jsr sfx.add_fx
			
			rts

@
			lda pom0a
			sta sprite_dy
			lda cl.sprite0y
			sta sprite_y
			
			
			dec pom0
			bne mvd0
			rts
			
tab_lot		dta a(12),a(24),a(48),a(48),a(96),a(96),a(192),a(340)
			


joystick_down
			lda porta
			and #15
			cmp #13
			beq @+1
@			rts
@		    
			lda spadanie
			bmi mvg1b
			lda predkosc_spadanie
			beq @+	
			dec predkosc_spadanie
@			rts		
			
			
mvg1					
			lda #1
			jsr score_add			;punkty po uderzeniu
			jsr zmien_kolor_P
			
			
			lda #1
			ldy #fx_uderzenie
			jsr sfx.add_fx
mvg1b			
			mva #1 spadanie		;koniec ekranu , zaczyna się spadanie
			mva #LEN_SPADANIE	predkosc_spadanie
			mva #shp_jdol_srodek sprite_shape
			mva #0 ruch_poziom
			
			rts

movej_gora	mva #3 pom0	
mvg0		
@			dec wysokosc_lotu
			beq mvg1b
			lda wysokosc_lotu
_lot16		cmp #LOT_START-16
			bcc @+
			eor #255
_lot1		adc #LOT_START-1
			lsr
			jmp @+1
			
			
@			lsr
			lsr
			lsr
			cmp #8
			bcc @+
			lda #7				
@			asl
			tax
			
			
			sec 
			lda sprite_dy
			sbc tab_lot,x
			sta pom0a
			lda sprite_y
			sbc tab_lot+1,x
			sta cl.sprite0y
			lda sprite_x
			sta cl.sprite0x
			

			jsr cl.sprawdz_nad_gackiem		
			beq mvg1
			
			
			mva cl.sprite0y sprite_y
			mva pom0a sprite_dy
			
			dec pom0
			bne mvg0
			rts

fire		
			lda trig0
			cmp trig0s
			beq @+
			cmp #0
			sta trig0s
			beq @+1
			
			lda spadanie
			bpl @+
			
			lda wysokosc_lotu
			cmp #120-40
			bcc @+
			mva #120-40 wysokosc_lotu
			
@			rts
			
@			lda spadanie
			beq lot_w_gore1
			
			mva #LEN_SPADANIE predkosc_spadanie		;zmniejsz poczatkowa predkosc spadania
			mva #0 ruch_poziom
			mva #1 spadanie
			
			rts

LOT_START=246

zmien_kolor_P
			lda kolor_P
			beq @+			;=0 nie ma paralizu
			clc
			adc #1
			cmp #8
			bne *+4
			lda #1
			sta kolor_P			;od 1 do 7
			tax
			lda paraliz_tab0,x
			sta sprite_c0+7
			lda paraliz_tab1,x
			sta sprite_c1+7
@			rts
		
lot_w_gore1
			lda #1
			jsr score_add			;punkty po uderzeniu
			jsr zmien_kolor_P
		
lot_w_gore
			ldx sprite_y
			dex
			stx cl.sprite0y
			mva sprite_x cl.sprite0x
			
			jsr cl.sprawdz_nad_gackiem
			beq @+

			;jsr cl.sprite_vs_rampa				;sprawdz czy mozna lecieć w górę.
			;bpl @+

_lot0		mva #LOT_START wysokosc_lotu
			mva sprite_shape last_shape
			mva #-1 spadanie		
			mva #-1 sprite_anim_speed		;nie animuj postaci
			mva #shp_jgora_srodek	sprite_shape	
			mva #0 ruch_poziom

@			rts

joy_tab0	dta shp_jgora_srodek,shp_jstoi,shp_jdol_srodek



		

joystick
			lda porta
			and #$0c
			cmp #$0c
			bne @+1
			mva #-1 sprite_anim_speed
			mva #0 ruch_poziom
			ldy spadanie
			beq @+
			iny
			lda joy_tab0,y
			sta sprite_shape
			sta sprite_shape0
@			rts

			
@			bit bit2		;lewo
			jne @+1
			
			lda ruch_poziom
			cmp #1
			beq @+

			lda spadanie
			beq j0
			bpl j2
			mva #shp_jgora_lewo sprite_shape
			sta sprite_shape0
			mva #-1 sprite_anim_speed
			jmp j1
j2			mva #shp_jdol_lewo sprite_shape
			sta sprite_shape0
			mva #-1 sprite_anim_speed
			jmp j1
			
j0			mva #shp_jlewo sprite_shape
			sta sprite_shape0
			mva #3 sprite_anim_speed
			mva #%11 sprite_mask
j1			mva #1 ruch_poziom
			
@			
			sec
			lda sprite_dx
jlewo_m		sbc #0
			sta pom0a
			lda sprite_x
jlewo_s		sbc #1
			sta cl.sprite0x
			
			lda sprite_y
			sta cl.sprite0y
			
			jsr cl.sprawdz_lewo_gacek
			beq j10
			
			lda pom0a
			sta sprite_dx
			lda cl.sprite0x
			sta sprite_x
			
			
			lda sprite_shape0
			cmp #shp_jlewo
			bne j10
			
			ldy #fx_krok
			lda #0
			jsr sfx.add_fx
			
j10			rts
			
			
@			bit bit3
			beq *+3
			rts
			lda ruch_poziom				;prawo
			cmp #2
			beq @+
			
			lda spadanie
			beq j3
			bpl j4
			mva #shp_jgora_prawo sprite_shape
			sta sprite_shape0
			mva #-1 sprite_anim_speed
			jmp j5
j4			mva #shp_jdol_prawo sprite_shape
			sta sprite_shape0
			mva #-1 sprite_anim_speed
			jmp j5			
			
j3			mva #shp_jprawo sprite_shape
			sta sprite_shape0
			mva #3 sprite_anim_speed
			mva #%11 sprite_mask
			
j5			mva #2 ruch_poziom
		
@			
			clc
			lda sprite_dx
jprawo_m	adc #0
			sta pom0a
			lda sprite_x
jprawo_s	adc #1
			sta cl.sprite0x
			;ldy sprite_x
			;iny
			;sty cl.sprite0x
			lda sprite_y
			sta cl.sprite0y
			
			jsr cl.sprawdz_prawo_gacek
			beq j50
			;jsr cl.sprite_vs_rampa
			;bpl j50
			
			lda pom0a
			sta sprite_dx
			lda cl.sprite0x
			sta sprite_x
					
			;inc sprite_x
			
			lda sprite_shape0
			cmp #shp_jprawo
			bne j50
			
			ldy #fx_krok
			lda #0
			jsr sfx.add_fx
			
j50			rts

.endl
