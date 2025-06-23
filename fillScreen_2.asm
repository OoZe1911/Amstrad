	org &1000

	ld a,0		; Mode 0
	call &BC0E

	ld hl,&c000		; Adresse frame buffer
	ld de,&4000		; DE -> taille de l'�cran (HL + DE = $FFFF)

fill	ld (hl),&30		; Ecrit 2 pixels blancs d'un coup (mode 0)
	inc hl		; Passe � l'octet suivant
	dec de
	ld a,d		; V�rifie si DE est �gale � 0
	or e			; en faisant D or E (qui ne donne 0 que si D et E sont nuls)
	jp nz,fill
	ret