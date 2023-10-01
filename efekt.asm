//efekt kolorowych liter

.local efekt
tabmaska0	dta %00000001,%00000011,%00000111,%00001111,%00011111,%00111111,%01111111
tabmaska1	dta %11111110,%11111100,%11111000,%11110000,%11100000,%11000000,%10000000

nrbitu	equ pom0b
maska	equ pom0c
linia	equ pom0d
tekst	equ pom0e
poz_duszka equ pom0g


tab0	
:128	dta b(<[#*8])
tab1	
:128	dta b(>[znaki1+#*8])
tab2	:256 BITY #

.macro BITY var
	.IF :var & 3 
		?a = 1
	.ELSE
		?a = 0
	.ENDIF	
	.IF :var & 12 
		?a = ?a + 2
	.ENDIF
	.IF :var & 48
		?a = ?a + 4
	.ENDIF
	.IF (:var & 192)
		?a = ?a + 8
	.ENDIF
	dta b(?a)
.endm


clear
		lda #0
		ldy #7
@		sta (pom1),y
		dey
		bpl @-
		rts

//w A pozycja pozioma , w X nr duszka, w "linia" pozycja pionowa duszka
print
		sta poz_duszka			;w A pozycja pozioma duszka
		txa						;ustaw adres duszka po X
		clc
		adc #3
		ora #>sprites
		sta pom1+1
		mva linia pom1
		
		mvx #255 maska
		
		lda poz_duszka
		cmp #48
		bcs p1
		cmp #41
		bcc p3			;poza ekranem
		tax
		lda tabmaska0-41,x
		jmp p0
		
p1		cmp #201
		bcc p2		;bez maski =255
		cmp #208
		bcs p3		;poza ekranem

		tax
		lda tabmaska1-201,x
		jmp p0
		
p3		lda #0
p0		sta maska
		
p2		equ *		
		
		
		lda poz_duszka
		sec
		sbc #48		;poza ekranem
		bcc clear
		
		pha
		and #3
		sta nrBitu
		pla
		:2 lsr

		tay
		lda (tekst),y
		tax
		lda tab0-128,x
		sta pom
		lda tab1-128,x
		sta pom+1

		iny
		lda (tekst),y
		tax
		lda tab0-128,x
		sta pom2
		lda tab1-128,x
		sta pom2+1

		iny
		lda (tekst),y
		tax
		lda tab0-128,x
		sta pom3
		lda tab1-128,x
		sta pom3+1	

		ldy #7
		
		ldx nrBitu
		bne @+
		
loc0	lda (pom),y
		tax
		lda tab2,x		;tablica ksztaltow
		:4 asl
		sta pom0a
		lda (pom2),y
		tax
		lda tab2,x
		ora pom0a
		and maska
		sta (pom1),y
		dey
		bpl loc0
		rts
		
@		cpx #3
		bne @+
		
loc1	lda (pom),y
		and #%00000011
		tax
		lda tab2,x
		lsr
		ror
		sta pom0a
		
		lda (pom2),y
		tax
		lda tab2,x
		:3 asl
		ora pom0a
		sta pom0a
		
		lda (pom3),y
		and #%11111100
		tax
		lda tab2,x
		lsr
		ora pom0a
		and maska
		sta (pom1),y
		dey
		bpl loc1
		rts

@		cpx #2
		bne @+
loc2	
		lda (pom),y
		and #%00001111
		tax
		lda tab2,x
		lsr
		ror
		ror
		sta pom0a
		
		lda (pom2),y
		tax
		lda tab2,x
		:2 asl
		ora pom0a
		sta pom0a
		
		lda (pom3),y
		and #%11110000
		tax
		lda tab2,x
		:2 lsr
		ora pom0a
		and maska
		sta (pom1),y
		dey
		bpl loc2
		
		rts		
		
		
		
@		
loc3	lda (pom),y
		and #%00111111
		tax
		lda tab2,x
		lsr
		ror
		ror
		ror
		sta pom0a
		
		lda (pom2),y
		tax
		lda tab2,x
		asl
		ora pom0a
		sta pom0a
		
		lda (pom3),y
		and #%11000000
		tax
		lda tab2,x
		:3 lsr
		ora pom0a
		and maska
		sta (pom1),y
		dey
		bpl loc3
		rts				
		
.endl