//napisy Start i Game over

.local napisy
zestaw0	equ $400
pozycja	dta b(-8)

shape_start	
		.he ff,ff,ff,f0,c0,cf,cf,c3,f0,fc,ff,cf,c0,f0,ff,ff
		.he ff,ff,ff,f0,30,3c,fc,fc,fc,3c,3c,3c,3c,fc,ff,ff
		.he ff,ff,ff,3c,30,f3,f3,f3,f0,f0,f3,f3,f3,f3,ff,ff
		.he ff,ff,ff,3c,0c,cc,cc,cc,0c,0c,cc,cc,cc,cc,ff,ff
		
		.he ff,ff,ff,0f,03,f3,f3,f3,0f,0f,f3,f3,f3,f3,ff,ff
		.he ff,ff,ff,03,03,cf,cf,cf,cf,cf,cf,cf,cf,cf,ff,ff
		.he ff,ff,ff,f3,f3,f3,f3,f3,f3,f3,ff,ff,f3,f3,ff,ff
		.he ff,ff,ff,33,33,33,33,33,33,33,ff,ff,33,33,ff,ff


		
bufor0	equ sprites+$500	;org *+64
bufor1	equ sprites+$540	;org *+64


		
		
//przygotowuje napis start
init_start
		mva #3 sizep2s
		sta sizep3s
		sta sizep0s
		
		jsr multi.hide_sprite
		jsr bomb.zgas_bombe
		
		mva #$00 colpm0s
		mva #$0f colpm2s
		sta colpm3s
		
		mva #2 gtiactls

		lda zestaw+12
		sta pom0a				;jaki zestaw w 1 linii
		lda zestaw+13	
		sta pom0b				;jaki zestaw w 2 linii
		
		ldx #7
		lda #$ff
@		sta $7f8,x
		dex
		bpl @-	
		
		ldx #31
@		txa
		asl
		tay
		lda obraz+12*48+8,x		;skopiuj dane z dwoch linii
		sta bufor0,y
		lda obraz+13*48+8,x
		sta bufor0+1,y
		dex
		bpl @-
		
		mva pom0a _ad1+1
		ldx #62	
@		lda bufor0,x
		jsr skopiuj
		dex
		dex
		bpl @-
		
		mva pom0b _ad1+1
		ldx #63
@		lda bufor0,x
		jsr skopiuj
		dex
		dex
		bpl @-	

		ldx #127
@		lda shape_start,x
		sta zestaw0+$280,x
		dex
		lda shape_start,x
		sta zestaw0+$200,x			;przygotowuje znaki z napisem lewy i prawy
		dex
		bpl @-
		
		lda #$ff
		ldx #15
@		sta sprites+$770,x			;podkolorowujemy napis duszkami
		dex
		sta sprites+$670,x
		dex
		bpl @-
		sta sprites+$480	

		jsr wait_vbl
		
		mva #>zestaw0 zestaw+12		;ustaw nowe znaki
		sta zestaw+13		
		
		ldx #31
@		txa
		asl
		tay		
		lda bufor0,y
		and #128
		sta pom0
		tya
		ora pom0
		sta obraz+12*48+8,x		;i wpisz nowe znaki		
		lda bufor0+1,y
		and #128
		sta pom0
		tya
		ora #1
		ora pom0
		sta obraz+13*48+8,x
		dex
		bpl @-
		
		
		ldx #31
@		lda obraz+12*48+8,x			;zapamietaj znaki przed narysowanie napisu
		sta bufor1,x
		lda obraz+13*48+8,x
		sta bufor1+32,x
		dex
		bpl @-
		
		rts
		
		
		
skopiuj
		pha
		asl
		asl
		rol
		rol
		and #3
_ad1	ora #0
		sta pom+1
		pla
		:3 asl
		sta pom
		
		txa
		:3 asl
		sta _ad0+1
		txa
		:2 asl
		:2 rol
		and #1
		ora #>zestaw0
		sta _ad0+2		
		
		ldy #7
@		lda (pom),y
_ad0	sta zestaw0,y			
		dey
		bpl @-
		
		rts
		
		
rysuj
		mwa #(obraz+12*48+8) pom1

		ldx #7
		
rj0		txa
		clc
		adc pozycja
		cmp #32
		bcs next			;poza ekranem
		
		tay
		lda (pom1),y			;odczytuje znak pod literą		(pom1)=obraz+8+nrlinii*48
		
		:3 asl
		sta pom					
		lda (pom1),y
		:2 asl
		:2 rol
		and #3
		ora #>zestaw0
		sta pom+1				;adres ksztaltu znaku pod literą
		
		txa
		ora pom0c				;=8 dla prawej strony
		:4 asl
		sta pom2				
		lda >(zestaw0+$200)
		sta pom2+1				;adres ksztaltu nowego znaku
		
		txa
		ora pom0c
		asl
		ora #$c0				
		sta (pom1),y			;wstawiamy nowy znak
		ora #1
		pha
		tya
		clc
		adc #48
		tay
		pla
		sta (pom1),y
						
		ldy #14
kier	nop		
@		lda (pom),y				;kopiujemy stary ksztalt do nowego znaku
		sta (pom2),y
		dey
		dey
		bpl @-
			
next
		dex
		bpl rj0
		rts
		
clear
		ldx #31
@		lda bufor1,x
		sta obraz+12*48+8,x
		lda bufor1+32,x
		sta obraz+13*48+8,x
		dex
		bpl @-
		rts
		
przywroc
		jsr multi.hide_sprite
		
		ldx #31
		ldy #63
@		lda bufor0,y
		sta obraz+13*48+8,x		;skopiuj dane z dwoch linii
		dey
		lda bufor0,y
		sta obraz+12*48+8,x
		dey
		dex
		bpl @-
		
		mva pom0a zestaw+12
		mva pom0b zestaw+13
		lda #1+32+16	
		sta gtiactls	
		mva #0 sizep0s
		sta sizep2s
		sta sizep3s
		
		rts
		
start
			jsr wait_vbl
			jsr init_start
			jsr wait_vbl

@			mva #-8 pom0d
			mva #32 pom0e
			mva #21 pom0f

			
@			mva pom0d pozycja
			mva #0 pom0c
			mva #{iny} kier
			jsr rysuj
			
			mva pom0e pozycja
			mva #8 pom0c
			mva #{nop} kier
			jsr rysuj
			
			
			jsr wait_vbl			
			dec pom0f
			beq @+
			
			jsr clear
			
			inc pom0d
			dec pom0e
			
			lda pom0d
			asl
			asl
			adc #$40
			sta hposp2s
			sta hposp2
			sta hposp0s
			sta hposp0
			lda pom0e
			asl
			asl
			adc #$40
			sta hposp3s
			
			jmp @-
			
			
@			ldx #50
@			jsr wait_vbl
			dex
			bne @-
			
			jmp przywroc

.endl
		