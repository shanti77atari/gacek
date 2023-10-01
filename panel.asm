//obsluga panelu

.local panel

init	
		ldx #6
_podkol		
@		lda #$f8
		sta sprites+$4e2,x
		sta sprites+$6e2,x
		lda #$3d
		sta sprites+$3e2,x
		lda #$fe
		sta sprites+$7e2,x
		dex
		bpl @-
		rts

bonus_tab	dta 8,17,26,35,44

bonus_shape	
		.he 06,06,fe,66,66,66,f6,06,0f		;1
		.he 06,0f,f3,63,66,64,fc,0d,0f		;2
		.he 06,0f,f3,63,66,63,f3,0f,06		;3
		.he 03,07,f7,6f,6f,6f,f3,03,03		;4
		.he 0f,0c,fc,6e,63,63,f3,0f,06		;5


print_bonus
		lda bonus
		asl
		ora #$80
		adc #3
		sta panel_adr+15
		adc #1
		sta panel_adr+48+15
		
		ldx bonus
		ldy bonus_tab,x
		
		ldx #8
@		lda bonus_shape,y			;podkolorowanie
_pb0	sta sprites+$5e6,x
		dey
		dex
		bpl @-
		rts		
		
		rts

print_round
_round	ldy #18+3
		lda round
		jmp print


czy_bonus
		lda score+1
		cmp score1
		bcs tak
		rts
tak	
		inc bonus_flag			;może pokazać się B
		clc
		lda score1
		sed
		adc #$05				;następne B za kolejne 5000punktów
		sta score1				
		cld
		rts  
		
print_score		
		jsr czy_bonus
print_score1
		ldy #10
		lda score
		jsr print
		lda score+1
		jsr print
		lda score+2
		jsr print	
		
		jmp czy_hscore
		
print_lives
_lives	ldy #28+1
		lda lives
		cmp #10
		bcc *+4
		lda #9
		jmp print
		
czy_hscore
		sec
		lda hscore
		sbc score
		lda hscore+1
		sbc score+1
		lda hscore+2
		sbc score+2
		bcc *+3
		rts	
		lda score
		sta hscore
		lda score+1
		sta hscore+1
		lda score+2
		sta hscore+2
		
print_hscore
		ldy #41
		lda hscore
		jsr print
		lda hscore+1
		jsr print
		lda hscore+2
		jmp print
		


print	
		pha
		and #$0f
		ora #$90
		sta panel_adr+48,y
		pla
		:4 lsr
		dey
		ora #$90
		sta panel_adr+48,y
		dey
		rts

.endl