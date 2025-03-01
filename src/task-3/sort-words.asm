global get_words
global compare_func
global sort

section .data
    cmp_val dd 0

section .text
extern qsort
extern strcmp

;; cmp_funct(void *a, void *b)
cmp_funct:
    enter 0,0
    pusha

    xor esi, esi
    mov esi, [ebp + 8]
    mov esi, [esi]

    xor edi, edi
    mov edi, [ebp + 12]
    mov edi, [edi]

    xor ecx, ecx
len_first:
    inc ecx
    cmp byte [esi + ecx], 0x00
    jnz len_first
    mov eax, ecx

    xor ecx, ecx
len_second:
    inc ecx
    cmp byte [edi + ecx], 0x00
    jnz len_second
    mov ebx, ecx

    cmp eax, ebx
    jg greater
    jl lower
    jz equal

greater:
    xor eax, eax
    mov eax, 1
    jmp end_cmp

lower:
    xor eax, eax
    mov eax, -1
    jmp end_cmp

equal:
    xor eax, eax
    push edi
    push esi
    call strcmp
    add esp, 8

end_cmp:

    mov [cmp_val], eax
    popa

    mov eax, [cmp_val]
    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    pusha

    xor eax, eax
    mov eax, [ebp + 8]  ;  words
    xor ebx, ebx
    mov ebx, [ebp + 12]  ;  num_words
    xor ecx, ecx
    mov ecx, [ebp + 16]  ;  size

    push cmp_funct
    push ecx
    push ebx
    push eax
    call qsort
    add esp, 16

    popa
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    pusha

    xor esi, esi
    mov esi, [ebp + 8]  ;  s - textul de unde extragem cuvintele

    xor edi, edi
    mov edi, [ebp + 12]  ;  words - vectorul de cuvinte

    xor edx, edx
    mov edx, [ebp + 16]  ;  num_of_words

    xor ecx, ecx
    xor ebx, ebx
    jmp main_loop
inc_punctuation:
    inc ebx
    cmp byte [esi + ebx], '.'
    jz inc_punctuation
    cmp byte [esi + ebx], ','
    jz inc_punctuation
inc_reg:
    inc ebx
    pop edx
    pop ecx
    inc ecx
    cmp ecx, edx
    jz end
main_loop:
    xor eax, eax
    mov eax, [edi + ecx * 4]
    push ebx
    xor ebx, ebx
clean_reg:
    mov [eax + ebx], byte 0
    inc ebx
    cmp ebx, 100
    jnz clean_reg
    pop ebx
    
    push ecx
    push edx
    xor ecx, ecx
    xor edx, edx
copy:
    mov dl, byte [esi + ebx]
    inc ebx
    mov byte [eax + ecx], dl
    inc ecx

    cmp byte [esi + ebx], 0x00
    jz inc_reg
    cmp byte [esi + ebx], 0x20
    jz inc_reg
    cmp byte [esi + ebx], ','
    jz inc_punctuation
    cmp byte [esi + ebx], '.'
    jz inc_punctuation
    cmp byte [esi + ebx], 0x0a
    jz inc_reg
    jnz copy
end:

    xor ebx, ebx
    mov ebx, [ebp + 16]
    xor ecx, ecx
    mov eax, eax
printloop:
    mov eax, [edi + ecx * 4]
    inc ecx
    cmp ebx, ecx  
    jnz printloop
    

    popa
    leave
    ret
