	.import __COMRAM_LOAD__
	.import __COMRAM_RUN__
	.import __COMRAM_SIZE__



	.segment "STARTUP"

	.word basicstub		; load address

; SYS(PEEK(57532)-219)*256+30
basicstub:
	.word nextline
	.word 2024
	.byte $9e	; SYS
	.byte "("
	.byte $c2	; PEEK
	.byte "("
	.byte "57532"
	.byte ")"
	.byte $ab	; -
	.byte "219"
	.byte ")"
	.byte $ac	; *
	.byte "256"
	.byte $aa	; +
	.byte "30"
	.byte 0
nextline:
	.word 0


picstart:
	; Get PC hi in A
	ldx #$ba
	stx $0180
	ldx #$bd
	stx $0181
	ldx #$02
	stx $0182
	dex
	stx $0183
	ldx #$60
	stx $0184
	jsr $0180

	.assert >__COMRAM_LOAD__ = >picstart, error, "comram load is in another page"

	sta $fe
	lda #<__COMRAM_LOAD__
	sta $fd

	lda #<__COMRAM_RUN__
	sta $fb
	lda #>__COMRAM_RUN__
	sta $fc

	.assert __COMRAM_SIZE__ <= 256, error, "comram size > 256"

	ldy #0
@copy:
	lda ($fd),y
	sta ($fb),y
	iny
	cpy #<__COMRAM_SIZE__
	bne @copy

	jmp __COMRAM_RUN__


	.segment "COMRAM"

main:
:	inc $d020
	jmp :-
