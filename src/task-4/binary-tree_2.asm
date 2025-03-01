extern array_idx_2      ;; int array_idx_2

section .text
    global inorder_intruders

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_intruders(struct node *node, struct node *parent, int *array)
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista
;
;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;
;        array  -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: DOAR in frunze pot aparea valori gresite!
;          vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

; HINT: folositi variabila importata array_idx_2 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test al functiei inorder_intruders.      

inorder_intruders:
    enter 0, 0
    pusha

    xor esi, esi
    mov esi, [ebp + 8]  ;  *node

    xor edx, edx
    mov edx, [ebp + 12]  ;  *parent

    xor edi, edi
    mov edi, [ebp + 16]  ;  *array

    ;;left node
    xor eax, eax
    mov eax, [esi + 4]  ;  *left
    cmp eax, 0
    jz next

    push edi
    push esi
    push eax
    call inorder_intruders
    add esp, 12
    jmp skip

next:
    ;;verifica daca este frunza
    xor eax, eax
    mov eax, [esi + 8]  ;  *right
    cmp eax, 0
    jnz skip

    xor eax, eax
    mov eax, [edx + 4]
    cmp esi, eax  ;  verifica daca nodul curent este cel stang
    jnz check_right

    xor eax, eax
    mov eax, [edx]  ;  value parent
    xor ebx, ebx
    mov ebx, [esi]  ;  value child
    cmp eax, ebx  ;  verifica daca valoarea parinte > val child
    jg end

    xor ecx, ecx
    mov ecx, [array_idx_2]
    mov [edi + ecx * 4], ebx
    inc ecx
    mov [array_idx_2], ecx
    jmp end

check_right:
    xor eax, eax
    mov eax, [edx + 8]
    cmp esi, eax  ;  verifica daca nodul curent este cel drept
    jnz end

    xor eax, eax
    mov eax, [edx]  ;  value parent
    xor ebx, ebx
    mov ebx, [esi]  ;  value child
    cmp eax, ebx
    jl end

    xor ecx, ecx
    mov ecx, [array_idx_2]
    mov [edi + ecx * 4], ebx
    inc ecx
    mov [array_idx_2], ecx
    jmp end


skip:
    ;;right node
    xor eax, eax
    mov eax, [esi + 8]  ;  *right
    cmp eax, 0
    jz end
    
    push edi
    push esi
    push eax
    call inorder_intruders
    add esp, 12

end:

    popa
    leave
    ret
