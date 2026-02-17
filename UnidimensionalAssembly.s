.data
    buffer: .long 0
    f_id: .space 4
    f_d: .space 4
    nr_op: .space 4
    nr_fisiere: .space 4
    operatia: .space 4
    interval_s: .space 4
    interval_d: .space 4
    stanga_defrag: .space 4
    dreapta_defrag: .space 4
    formatscanf1: .asciz "%d \n"
    formatprintf1: .asciz "%d: (%d, %d)\n"
    formatprintf2:  .asciz "(%d, %d)\n"
    formattest: .asciz "%d \n"
    v: .space 4096

.text
.extern scanf
.extern printf
.global main

main:
    lea v, %edi

    lea buffer, %eax
    push %eax
    push $formatscanf1
    call scanf
    add $8, %esp

    mov buffer, %eax
    mov %eax, nr_op

    xor %ecx, %ecx
    xor %ebx, %ebx

citirea_operatiei:
    mov nr_op, %eax
    cmp $0, %eax
    je et_exit

    sub $1, %eax
    mov %eax, nr_op

    lea buffer, %eax
    push %eax
    push $formatscanf1
    call scanf 
    add $8, %esp

    mov buffer, %eax

    cmp $1, %eax # ADD
    je citirea_numar_fisiere

    cmp $2, %eax # GET
    je citire_f_id_get

    cmp $3, %eax # DEL
    je citire_f_id_del

    cmp $4, %eax # DEFRAG
    je pregatire_defrag

citirea_numar_fisiere:
    lea buffer, %eax
    push %eax
    push $formatscanf1
    call scanf
    add $8, %esp
    
    mov buffer, %eax
    mov %eax, nr_fisiere
    
    
citire_f_id_d:
    xor %esi, %esi
    xor %ecx, %ecx
    xor %ebx, %ebx

    mov %ecx, interval_d
    mov %ecx, interval_s

    mov nr_fisiere, %eax
    cmp $0, %eax
    jle resetare_registrii

    sub $1, %eax
    mov %eax, nr_fisiere

    lea buffer, %eax
    push %eax
    push $formatscanf1
    call scanf
    add $8, %esp

    mov buffer, %eax
    mov %eax, f_id

    lea buffer, %eax
    push %eax
    push $formatscanf1
    call scanf
    add $8, %esp

    mov buffer, %eax

    xor %edx, %edx
    add $7, %eax
    mov $8, %esi
    div %esi

    mov %eax, f_d

cautarea_spatiului:
    cmp $1024, %ebx
    je eroare_add

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    je continuare

    inc %ebx
    jmp cautarea_spatiului

resetare_contor:
    xor %ecx, %ecx
    jmp cautarea_spatiului

continuare:
    cmp $1024, %ebx   
    je eroare_add                   # TESTEAZA!!!!!!!!!!!!!!!!!
    inc %ecx

    mov f_d, %eax
    cmp %ecx, %eax
    jle resetare_index

    inc %ebx

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    jne resetare_contor

    jmp continuare

resetare_index:
    sub $1, %ecx
    sub %ecx, %ebx
    mov %ebx, interval_s

adaugare_efectiva:
    mov f_d, %ecx
    cmp $0, %ecx
    jle print_add

    sub $1, %ecx
    mov %ecx, f_d

    mov f_id, %eax
    mov %eax, (%edi, %ebx, 4)
    mov %ebx, interval_d

    inc %ebx

    jmp adaugare_efectiva

print_add:
    push interval_d
    push interval_s
    push f_id
    push $formatprintf1
    call printf
    pop interval_d
    add $12, %esp

    jmp citire_f_id_d


    # AM MUTAT INITIALIZAREA LUI %EBX CU 0 IN MAIN DIN CITIREA_F_ID_D, IAR ACUM DUPA CE PRINTEZ ADD-UL
    # PARCURGEA PENTRU URMATORUL ADD VA PORNI DE LA POZITIA URM IN ARRAY

eroare_add:
    xor %esi, %esi
    xor %ebx, %ebx

    push %ebx
    push %esi
    push f_id
    push $formatprintf1
    call printf
    add $16, %esp

    jmp citire_f_id_d

citire_f_id_get:
    lea buffer, %eax
    push %eax
    push $formatscanf1
    call scanf
    add $8, %esp

    mov buffer, %eax
    mov %eax, f_id

    mov $0, %ebx

parcurgere_get:
    cmp $1024, %ebx
    je eroare_get

    mov (%edi, %ebx, 4), %eax
    mov f_id, %ecx
    mov %ebx, interval_s

    cmp %ecx, %eax
    je index_interval_d

    inc %ebx

    jmp parcurgere_get

index_interval_d:
    cmp $1024, %ebx
    je print_get

    cmp %eax, %ecx
    jne print_get

    mov %ebx, interval_d
    inc %ebx

    mov (%edi, %ebx, 4), %eax

    jmp index_interval_d

print_get:
    push interval_d
    push interval_s
    push $formatprintf2
    call printf
    add $12, %esp

    jmp resetare_registrii

eroare_get:
    xor %ecx, %ecx
    xor %ebx, %ebx

    push %ecx
    push %ebx
    push $formatprintf2
    call printf
    add $12, %esp

    jmp resetare_registrii

citire_f_id_del:
    lea buffer, %eax

    push %eax
    push $formatscanf1
    call scanf
    add $8, %esp

    mov buffer, %eax
    mov %eax, f_id

    mov $0, %ebx

parcurgere_del:
    cmp $1024, %ebx
    je reparcurgere_del_print

    mov (%edi, %ebx, 4), %eax
    mov f_id, %ecx
    cmp %eax, %ecx
    je stergere_f_id

    inc %ebx
    jmp parcurgere_del

stergere_f_id:
    cmp %eax, %ecx
    jne reparcurgere_del_print

    mov $0, %eax
    mov %eax, (%edi, %ebx, 4)

    inc %ebx
    mov (%edi, %ebx, 4), %eax

    jmp stergere_f_id

reparcurgere_del_print:
    mov $0, %ebx

parcurgere_print_del:
    cmp $1024, %ebx
    je resetare_registrii

    mov (%edi,%ebx,4), %eax
    
    cmp $0, %eax
    jne print_del_pe_rand

    inc %ebx
    jmp parcurgere_print_del

print_del_pe_rand:
    mov %eax, f_id
    mov %ebx, interval_s

continuare_print_del:
    cmp $1024, %ebx
    je print_del

    mov f_id, %ecx
    cmp %eax, %ecx
    jne print_del

    mov %ebx, interval_d
    inc %ebx
    
    mov (%edi, %ebx, 4), %eax

    jmp continuare_print_del

print_del:
    push interval_d
    push interval_s
    push f_id
    push $formatprintf1
    call printf
    add $16, %esp

    jmp parcurgere_print_del

pregatire_defrag:
    xor %ebx, %ebx
    xor %ecx, %ecx
    xor %edx, %edx

parcurgere_defrag:
    cmp $1024, %ebx
    je pregatire_print_defrag

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax 
    je setare_stanga

    inc %ebx
    jmp parcurgere_defrag

setare_stanga:
    mov %ebx, stanga_defrag

cauta_f_id:
    cmp $1024, %ebx
    je pregatire_print_defrag

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    jne tinere_minte_nr

    inc %ebx
    jmp cauta_f_id

tinere_minte_nr:    
    mov %eax, f_id
    xor %ecx, %ecx

numara_f_id_si_stergere:
    cmp $1024, %ebx
    je mutare_pe_vector

    mov (%edi, %ebx, 4), %eax
    mov f_id, %esi
    cmp %eax, %esi
    jne mutare_pe_vector

    mov $0, %eax
    mov %eax, (%edi, %ebx, 4)

    inc %ecx
    inc %ebx
    jmp numara_f_id_si_stergere

mutare_pe_vector:
    mov stanga_defrag, %ebx

mutare:
    cmp $1024, %ebx
    je pregatire_print_defrag

    cmp $0, %ecx
    je parcurgere_defrag

    mov f_id, %esi
    mov %esi, (%edi, %ebx, 4)

    inc %ebx
    dec %ecx
    jmp mutare

pregatire_print_defrag:
    xor %ebx, %ebx
    xor %ecx, %ecx

parcurgere_print_defrag:
    cmp $1024, %ebx
    je resetare_registrii

    mov (%edi,%ebx,4), %eax
    
    cmp $0, %eax
    jne print_defrag_pe_rand

    inc %ebx
    jmp parcurgere_print_defrag

print_defrag_pe_rand:
    mov %eax, f_id
    mov %ebx, interval_s

continuare_print_defrag:
    cmp $1024, %ebx
    je resetare_registrii

    mov f_id, %ecx
    cmp %eax, %ecx
    jne print_defrag

    mov %ebx, interval_d

    inc %ebx
    mov (%edi, %ebx, 4), %eax

    jmp continuare_print_defrag

print_defrag:
    push interval_d
    push interval_s
    push f_id
    push $formatprintf1
    call printf
    add $16, %esp

    jmp parcurgere_print_defrag

resetare_registrii:
    xor %eax, %eax
    xor %ebx, %ebx
    xor %ecx, %ecx
    xor %edx, %edx
    xor %esi, %esi

    jmp citirea_operatiei

et_exit:
    pushl $0
    call fflush
    popl %eax

    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
