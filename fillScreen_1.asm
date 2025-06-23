	org &1000

	ld a,0		; Mode 0
	call &BC0E

	ld hl,&c000		; Adresse frame buffer

fill	ld (hl),&30		; Ecrit 2 pixels blancs d'un coup (mode 0)
	inc hl		; Passe à l'octer suivant
	ld a,h		; Compare si HL est arrivé à &FFFF
	cp &ff		; On doit comparer H à &FF
	jp nz, fill
	ld a,l
	cp &ff		; ET L à &FF
	jp nz,fill
	ret