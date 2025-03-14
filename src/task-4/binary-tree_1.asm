extern array_idx_1      ;; int array_idx_1

section .text
    global inorder_parc

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_parc(struct node *node, int *array);
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor in vectorul array.
;    @params:
;        node  -> nodul actual din arborele de cautare;
;        array -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!
; HINT: folositi variabila importata array_idx_1 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test.

inorder_parc:
    enter 0, 0
    pusha

    xor esi, esi
    mov esi, [ebp + 8]  ;  *node

    xor edi, edi
    mov edi, [ebp + 12]  ;  *array

    ;;left node
    xor eax, eax
    mov eax, [esi + 4]  ;  *left
    cmp eax, 0
    jz next

    push edi
    push eax
    call inorder_parc
    add esp, 8

next:
    ;;value
    xor ecx, ecx
    mov ecx, [array_idx_1]
    xor edx, edx
    mov edx, [esi]  ;  value

    mov [edi + ecx * 4], edx
    inc ecx
    mov [array_idx_1], ecx

    ;;right node
    xor eax, eax
    mov eax, [esi + 8]  ;  *right
    cmp eax, 0
    jz end

    push edi
    push eax
    call inorder_parc
    add esp, 8

end:

    popa
    leave
    ret
