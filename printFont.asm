	org #1000

start:
	ld a,1
	call #BC0E		; mode 1

	LD HL, palette      ; adresse de la palette
	LD A,0              ; On commence à la couleur 0

boucle_palette
	push AF
	push HL
	LD B,(HL)       ; lire la couleur physique dans B
	LD C,(HL)       ; et C (je sais pas pourquoi)
	CALL #BC32      ; changer la couleur de A
	pop HL
	INC HL
	pop AF
	INC A
	CP 4
	JR NZ,boucle_palette

; Paste a font

; Look for the correct font
	ld b,"D"
	ld de,fonts

search_font:
	ld a,(de)         ; lire la lettre courante
	cp b              ; comparer avec la lettre recherchée
	jr z,font_found   ; si trouvée, sortir de la boucle
	
	; Avancer DE de 17 octets (1 lettre + 16 octets de données)
	push bc           ; sauvegarder B
	ld bc,17          ; 1 + 16 = 17 octets par font
   
	; Solution : utiliser HL temporairement
	ld h,d
	ld l,e            ; HL = DE
	add hl,bc         ; HL = HL + 17
	ld d,h
	ld e,l            ; DE = HL
	pop bc            ; restaurer B
	
	jr search_font    ; continuer la recherche

font_found:
	inc de          ; DE pointe maintenant sur les données graphiques (après la lettre)
					; ici DE pointe sur les données de la font trouvée

paste_font:
	ld hl,#C050 	; adresse de départ écran
	ld b,8		; 8 lignes à copier

copy_font:
	ld a,(de)		; 1er octet (4 pixels)
	ld (hl),a
	inc hl
	inc de
	ld a,(de)		; 2eme octet (4 pixels suivants)
	ld (hl),a
	inc de

	push de
	ld de,#07FF
	add hl,de		; passer à la ligne suivante
	pop de

	djnz copy_font

	ret

palette:
	db 1,22,10,26

fonts:
	db "A"
	db #12,#84
	db #35,#C2
	db #72,#E0
	db #60,#60
	db #70,#E8
	db #60,#60
	db #60,#60
	db #00,#00

	db "D"
	db #77,#84
	db #64,#4A
	db #64,#60
	db #60,#68
	db #70,#E0
	db #70,#C2
	db #70,#84
	db #00,#00

	db "G"
	db #13,#E0
	db #27,#00
	db #64,#E0
	db #64,#60
	db #70,#E0
	db #34,#E0
	db #12,#E0
	db #00,#00

	db "J"
	db #00,#C8
	db #00,#C0
	db #00,#C0
	db #01,#C0
	db #FC,#C0
	db #F0,#84
	db #F0,#08
	db #00,#00

	db "M"
	db #8C,#26
	db #CA,#6C
	db #E1,#E8
	db #F0,#E0
	db #F0,#E0
	db #E1,#E0
	db #E0,#E0
	db #00,#00

	db "P"
	db #76,#84
	db #64,#4A
	db #64,#68
	db #70,#E0
	db #70,#C2
	db #70,#84
	db #60,#00
	db #00,#00

	db "S"
	db #36,#E0
	db #64,#00
	db #34,#84
	db #00,#4A
	db #74,#E0
	db #70,#C2
	db #70,#84
	db #00,#00

	db "V"
	db #66,#64
	db #64,#60
	db #60,#60
	db #60,#60
	db #34,#C2
	db #12,#84
	db #01,#08
	db #00,#00

	db "Y"
	db #66,#64
	db #64,#60
	db #34,#E0
	db #00,#24
	db #76,#E0
	db #70,#C2
	db #70,#84
	db #00,#00

	db "b"
	db #66,#00
	db #64,#00
	db #74,#84
	db #60,#4A
	db #70,#E0
	db #70,#C2
	db #70,#84
	db #00,#00

	db "e"
	db #00,#00
	db #00,#00
	db #13,#E0
	db #26,#60
	db #70,#E0
	db #24,#00
	db #12,#C2
	db #00,#00

	db "h"
	db #00,#00
	db #00,#00
	db #66,#00
	db #65,#C0
	db #70,#E0
	db #61,#60
	db #60,#60
	db #00,#00

	db "k"
	db #00,#00
	db #00,#00
	db #66,#64
	db #64,#60
	db #70,#C0
	db #60,#42
	db #60,#60
	db #00,#00

	db "n"
	db #00,#00
	db #00,#00
	db #D4,#84
	db #70,#4A
	db #61,#60
	db #60,#60
	db #60,#60
	db #00,#00

	db "q"
	db #00,#00
	db #00,#00
	db #13,#E0
	db #26,#60
	db #34,#E0
	db #12,#E0
	db #00,#60
	db #00,#00

	db "t"
	db #00,#00
	db #32,#00
	db #74,#80
	db #30,#00
	db #30,#C0
	db #12,#C0
	db #01,#C0
	db #00,#00

	db "w"
	db #00,#00
	db #00,#00
	db #CC,#64
	db #C9,#60
	db #D0,#60
	db #69,#C2
	db #24,#84
	db #00,#00

	db "z"
	db #00,#00
	db #00,#00
	db #76,#C2
	db #74,#84
	db #10,#08
	db #30,#E0
	db #70,#E0
	db #00,#00

	db "3"
	db #74,#C0
	db #60,#60
	db #01,#C0
	db #00,#42
	db #76,#E0
	db #70,#C2
	db #70,#84
	db #00,#00

	db "6"
	db #12,#C2
	db #27,#00
	db #74,#84
	db #64,#4A
	db #70,#E0
	db #34,#C2
	db #12,#84
	db #00,#00

	db "9"
	db #37,#C2
	db #64,#60
	db #34,#E0
	db #00,#24
	db #74,#E0
	db #70,#C2
	db #70,#84
	db #00,#00

	db ","
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00
	db #11,#80
	db #10,#08
	db #21,#00

	db "("
	db #01,#8C
	db #13,#08
	db #32,#00
	db #32,#00
	db #30,#00
	db #12,#08
	db #01,#84
	db #00,#00

	db ";"
	db #00,#00
	db #00,#00
	db #11,#80
	db #10,#80
	db #00,#00
	db #32,#00
	db #21,#00
	db #42,#00

	db "="
	db #00,#00
	db #00,#00
	db #37,#C2
	db #00,#00
	db #00,#00
	db #35,#C2
	db #00,#00
	db #00,#00

	db "#"
	db #35,#84
	db #62,#C0
	db #30,#80
	db #78,#24
	db #D4,#C0
	db #48,#C0
	db #34,#60
	db #00,#00

	db ">"
	db #10,#00
	db #10,#80
	db #76,#C0
	db #74,#E0
	db #70,#C0
	db #10,#80
	db #10,#00
    db #00,#00

	db "B"
	db #77,#C2
	db #64,#60
	db #74,#C2
	db #60,#42
	db #70,#E0
	db #70,#E0
	db #70,#C2
	db #00,#00

	db "E"
	db #13,#E0
	db #26,#60
	db #74,#00
	db #64,#00
	db #70,#E0
	db #34,#E0
	db #12,#E0
	db #00,#00

	db "H"
	db #66,#E8
	db #64,#E0
	db #64,#E0
	db #60,#E0
	db #70,#E0
	db #60,#E0
	db #60,#E0
	db #00,#00

	db "K"
	db #66,#E8
	db #64,#E0
	db #74,#C0
	db #60,#C2
	db #60,#E0
	db #60,#E0
	db #60,#E0
	db #00,#00

	db "N"
	db #8C,#E8
	db #CA,#E0
	db #E9,#E0
	db #F0,#E0
	db #E1,#E0
	db #E0,#68
	db #E0,#24
	db #00,#00

	db "Q"
	db #36,#84
	db #4E,#4A
	db #C8,#60
	db #C8,#60
	db #E0,#28
	db #68,#84
	db #24,#C2
	db #00,#00

	db "T"
	db #77,#E0
	db #74,#E0
	db #70,#E0
	db #10,#80
	db #10,#80
	db #10,#80
	db #10,#80
	db #00,#00

	db "W"
	db #EC,#E8
	db #E8,#E0
	db #E9,#E0
	db #F0,#E0
	db #E1,#E0
	db #C2,#68
	db #84,#24
	db #00,#00

	db "Z"
	db #74,#E0
	db #60,#60
	db #00,#C2
	db #11,#84
	db #32,#E0
	db #74,#E0
	db #70,#E0
	db #00,#00

	db "c"
	db #00,#00
	db #00,#00
	db #13,#E8
	db #27,#00
	db #72,#E0
	db #34,#E0
	db #12,#E0
	db #00,#00

	db "f"
	db #00,#00
	db #00,#00
	db #13,#E0
	db #26,#60
	db #70,#00
	db #60,#00
	db #60,#00
	db #00,#00

	db "i"
	db #00,#00
	db #00,#00
	db #32,#80
	db #00,#00
	db #33,#80
	db #30,#80
	db #30,#80
	db #00,#00

	db "l"
	db #33,#00
	db #32,#00
	db #30,#00
	db #30,#00
	db #30,#C0
	db #12,#C0
	db #01,#C0
	db #00,#00

	db "o"
	db #00,#00
	db #00,#00
	db #13,#84
	db #26,#42
	db #70,#E0
	db #34,#C2
	db #12,#84
	db #00,#00

	db "r"
	db #00,#00
	db #00,#00
	db #66,#68
	db #74,#E0
	db #61,#00
	db #60,#00
	db #60,#00
	db #00,#00

	db "u"
	db #00,#00
	db #00,#00
	db #66,#64
	db #64,#60
	db #60,#68
	db #34,#E0
	db #12,#60
	db #00,#00

	db "x"
	db #00,#00
	db #00,#00
	db #CC,#6C
	db #61,#C0
	db #30,#80
	db #61,#C0
	db #C2,#60
	db #00,#00

	db "1"
	db #11,#80
	db #32,#80
	db #10,#80
	db #10,#80
	db #12,#84
	db #32,#C0
	db #30,#C0
	db #00,#00

	db "4"
	db #CC,#C8
	db #C8,#C0
	db #C0,#C0
	db #78,#C0
	db #34,#C0
	db #00,#C0
	db #00,#C0
	db #00,#00

	db "7"
	db #76,#E0
	db #74,#E0
	db #70,#C2
	db #01,#84
	db #01,#80
	db #10,#80
	db #10,#80
	db #00,#00

	db "0"
	db #36,#84
	db #4E,#4A
	db #C4,#60
	db #C2,#68
	db #F0,#E0
	db #78,#C2
	db #34,#84
	db #00,#00

	db "?"
	db #13,#84
	db #26,#42
	db #60,#60
	db #00,#C0
	db #01,#80
	db #00,#00
	db #10,#80
	db #00,#00

	db ")"
	db #13,#08
	db #01,#8C
	db #00,#C0
	db #00,#C0
	db #00,#C0
	db #01,#84
	db #12,#08
	db #00,#00

	db "/"
	db #00,#60
	db #00,#C8
	db #11,#80
	db #32,#00
	db #64,#00
	db #C0,#00
	db #80,#00
	db #00,#00

	db "#"
	db #66,#C8
	db #64,#C0
	db #F0,#E0
	db #60,#C0
	db #F0,#E0
	db #60,#C0
	db #60,#C0
	db #00,#00

	db "<"
	db #00,#80
	db #10,#80
	db #31,#E0
	db #72,#E0
	db #30,#E0
	db #10,#80
	db #00,#80
	db #00,#00

	db "'"
    db #11,#80
	db #10,#08
	db #21,#00
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00

	db "C"
	db #13,#E8
	db #27,#60
	db #64,#00
	db #65,#00
	db #70,#E0
	db #34,#E0
	db #12,#E0
	db #00,#00

	db "F"
	db #13,#E0
	db #36,#60
	db #74,#00
	db #74,#80
	db #70,#00
	db #70,#00
	db #70,#00
	db #00,#00

	db "I"
	db #33,#C0
	db #10,#80
	db #10,#80
	db #10,#80
	db #12,#84
	db #32,#C0
	db #30,#C0
	db #00,#00

	db "L"
	db #66,#00
	db #64,#00
	db #60,#00
	db #61,#00
	db #70,#E0
	db #34,#E0
	db #12,#E0
	db #00,#00

	db "O"
	db #36,#84
	db #4E,#4A
	db #C8,#60
	db #CA,#68
	db #F0,#E0
	db #78,#C2
	db #34,#84
	db #00,#00

	db "R"
	db #76,#84
	db #74,#C2
	db #74,#E0
	db #60,#60
	db #70,#C0
	db #60,#60
	db #60,#60
	db #00,#00

	db "V"
	db #66,#64
	db #64,#60
	db #60,#60
	db #60,#60
	db #70,#E0
	db #34,#C2
	db #12,#84
	db #00,#00

	db "X"
	db #E8,#E8
	db #68,#C2
	db #25,#84
	db #30,#80
	db #65,#C0
	db #E8,#E0
	db #E0,#E0
	db #00,#00

	db "a"
	db #00,#00
	db #00,#00
	db #37,#84
	db #00,#42
	db #13,#E0
	db #25,#60
	db #12,#E0
	db #00,#00

	db "d"
	db #00,#C8
	db #00,#C0
	db #36,#C0
	db #4C,#C0
	db #F0,#C0
	db #78,#C0
	db #34,#C0
	db #00,#00

	db "g"
	db #00,#00
	db #00,#00
	db #36,#E0
	db #64,#60
	db #34,#E0
	db #00,#60
	db #74,#C2
	db #70,#84

	db "j"
	db #00,#00
	db #00,#00
	db #00,#66
	db #00,#64
	db #64,#60
	db #34,#C2
	db #12,#84
	db #00,#00

	db "m"
	db #00,#00
	db #00,#00
	db #26,#84
	db #6D,#C2
	db #D0,#60
	db #C1,#60
	db #C0,#60
	db #00,#00

	db "p"
	db #00,#00
	db #00,#00
	db #76,#84
	db #64,#42
	db #70,#C2
	db #70,#84
	db #60,#00
	db #00,#00

	db "s"
	db #00,#00
	db #00,#00
	db #36,#C2
	db #64,#00
	db #34,#C2
	db #00,#60
	db #74,#C2
	db #00,#00

	db "v"
	db #00,#00
	db #00,#00
	db #66,#64
	db #60,#60
	db #25,#4A
	db #12,#84
	db #01,#08
	db #00,#00

	db "y"
	db #00,#00
	db #00,#00
	db #66,#66
	db #64,#64
	db #34,#E0
	db #00,#68
	db #76,#C2
	db #70,#84

	db "2"
	db #76,#C2
	db #00,#68
	db #12,#84
	db #26,#00
	db #74,#E0
	db #70,#E0
	db #70,#E0
	db #00,#00

	db "5"
	db #76,#C2
	db #64,#00
	db #70,#84
	db #00,#4A
	db #74,#E0
	db #70,#C2
	db #70,#84
	db #00,#00

	db "8"
	db #36,#C2
	db #64,#60
	db #34,#C2
	db #64,#60
	db #70,#E0
	db #34,#C2
	db #12,#84
	db #00,#00

	db "."
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00
	db #11,#80
	db #10,#80
	db #00,#00

	db "!"
	db #33,#C2
	db #36,#84
	db #34,#08
	db #61,#00
	db #42,#00
	db #00,#00
	db #CA,#00
	db #00,#00

	db ":"
	db #00,#00
	db #00,#00
	db #11,#80
	db #10,#80
	db #00,#00
	db #32,#00
	db #30,#00
	db #00,#00

	db "+"
	db #00,#00
	db #11,#80
	db #10,#80
	db #76,#E0
	db #10,#80
	db #10,#80
	db #00,#00
	db #00,#00

	db "-"
	db #00,#00
	db #00,#00
	db #00,#00
	db #73,#C2
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00

	db " "
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00
	db #00,#00