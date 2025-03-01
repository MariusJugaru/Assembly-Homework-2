section .data
	; declare global vars here
	vocale db "aeiou", 0

section .text
	global reverse_vowels

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	push ebp  ; initializam stiva
	push esp
	pop ebp
	push ecx  
	push ebx

	xor eax, eax
	push dword [ebp + 8]
	pop dword eax  ;  copiem adresa string-ului in eax

;   atunci cand gasim o vocala o adaugam pe stiva
;   parcurgem fiecare caracter pana la intalnirea terminatorului null
	xor ecx, ecx
check_string:
	cmp byte [eax + ecx], 'a'
	jnz check_e
	push 'a'

check_e:
	cmp byte [eax + ecx], 'e'
	jnz check_i
	push 'e'

check_i:
	cmp byte [eax + ecx], 'i'
	jnz check_o
	push 'i'

check_o:
	cmp byte [eax + ecx], 'o'
	jnz check_u
	push 'o'

check_u:
	cmp byte [eax + ecx], 'u'
	jnz next
	push 'u'

next:
	; PRINTF32 `%c\n\x0`, [eax + ecx]

	add ecx, 1
	cmp byte [eax + ecx], 0x00
	jnz check_string

;   schimbam vocalele cu cele de pe stiva
	xor ecx, ecx
change_string:
	cmp byte [eax + ecx], 'a'
	jz switch
	
	cmp byte [eax + ecx], 'e'
	jz switch

	cmp byte [eax + ecx], 'i'
	jz switch

	cmp byte [eax + ecx], 'o'
	jz switch

	cmp byte [eax + ecx], 'u'
	jnz next_second

switch:
	pop dword ebx
	push dword [eax + ecx + 1]
	push dword ebx
	pop dword [eax + ecx]
	pop dword [eax + ecx + 1]

next_second:

	add ecx, 1
	cmp byte [eax + ecx], 0x00
	jnz change_string
	

	pop ebx
	pop ecx

;   restauram stiva
	push esp
	pop ebp
	pop ebp
	ret