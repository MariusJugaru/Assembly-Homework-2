section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here

section .text
	global pwd

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
	enter 0, 0
	pusha

	xor esi, esi
	mov esi, [ebp + 8]  ;  directories

	xor ecx, ecx
	mov ecx, [ebp + 12]  ;  n

	xor edi, edi
	mov edi, [ebp + 16]  ;  output

	xor ebx, ebx
	mov byte [edi + ebx], '/'
	inc ebx

	xor edx, edx
main_loop:
	xor eax, eax
	mov eax, [esi + edx * 4]
	inc edx

	cmp word [eax], '.'
	jz main_loop

	cmp word [eax], '..'
	jnz next

;	stergem caracterele de la final pana la intalnirea lui '/'
	cmp ebx, 1
	jz main_loop
	dec ebx
back_dir:
	mov byte [edi + ebx], 0x00
	dec ebx
	cmp byte [edi + ebx], '/'
	jnz back_dir

	inc ebx
	mov byte [edi + ebx], 0x00
	jmp main_loop

next:
	push ecx
	xor ecx, ecx
	push edx

;	copiem caracter cu caracter in output
copy:
	mov dl, byte [eax + ecx]
	mov byte [edi + ebx], dl
	inc ebx

	inc ecx
	cmp byte [eax + ecx], 0x00
	jnz copy

	mov byte [edi + ebx], '/'
	inc ebx

	pop edx
	pop ecx
	cmp edx, ecx
	jnz main_loop


	popa
	leave
	ret