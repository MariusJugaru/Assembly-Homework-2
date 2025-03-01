section .text
    global inorder_fixing

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_fixing(struct node *node, struct node *parent)
;       functia va parcurge in inordine arborele binar de cautare, modificand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista.
;
;       Unde este nevoie de modificari se va aplica algoritmul:
;           - daca nodul actual este fiul stang, va primi valoare tatalui - 1,
;                altfel spus: node->value = parent->value - 1;
;           - daca nodul actual este fiul drept, va primi valoare tatalui + 1,
;                altfel spus: node->value = parent->value + 1;

;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;

; ATENTIE: DOAR in frunze pot aparea valori gresite! 
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

inorder_fixing:
    enter 0, 0
    pusha

    xor esi, esi
    mov esi, [ebp + 8]  ;  *node

    xor edx, edx
    mov edx, [ebp + 12]  ;  *parent


    ;;left node
    xor eax, eax
    mov eax, [esi + 4]  ;  *left
    cmp eax, 0
    jz next

    push esi
    push eax
    call inorder_fixing
    add esp, 8
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

    mov dword [esi], eax  ;  introducem in nod valoarea parintelui
    dec dword [esi]       ;  si o decrementam
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

    mov dword [esi], eax  ;  introducem in nod valoarea parintelui
    inc dword [esi]       ;  si o incrementam
    jmp end


skip:
    ;;right node
    xor eax, eax
    mov eax, [esi + 8]  ;  *right
    cmp eax, 0
    jz end
    
    push esi
    push eax
    call inorder_fixing
    add esp, 8

end:

    popa
    leave
    ret
