.data
    buffer: .long 0
    mat: .space 16777216
    f_id: .space 4
    f_d: .space 4
    nr_op: .space 4
    nr_fisiere: .space 4
    operatia: .space 4
    interval_s: .space 4
    interval_d: .space 4
    linie: .space 4
    coloana: .space 4
    stanga_defrag: .space 4
    dreapta_defrag: .space 4
    index: .space 4
    contor: .space 4
    final: .space 4
    formatscanf1: .asciz "%d \n"
    formatprintf1: .asciz "%d: ((%d, %d), (%d, %d))\n"
    formatprintf2: .asciz "((%d, %d), (%d, %d))\n"

.text
.extern scanf
.extern printf
.global main

main:
    lea mat, %edi

    lea buffer, %eax
    push %eax
    push $formatscanf1
    call scanf
    add $8, %esp

    mov buffer, %ebx
    mov %ebx, nr_op

    xor %ecx, %ecx
    xor %ebx, %ebx

    mov %ecx, final

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

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

cautare_spatiu:
    mov linie, %esi
    cmp $1024, %esi
    je eroare_add

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    je gasire_interval

    inc %ebx
    jmp cautare_spatiu

resetare_contor:
    xor %ecx, %ecx
    jmp cautare_spatiu

gasire_interval:
    inc %ecx 
    inc %ebx

    mov f_d, %eax
    cmp %ecx, %eax
    jle resetare_index

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    jne resetare_contor

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov coloana, %esi
    cmp $0,%esi
    je resetare_contor

    jmp gasire_interval

resetare_index:
    # sub $1, %ecx
    sub %ecx, %ebx
    
    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA
    mov %edx, interval_s

adaugare_efectiva:
    mov f_d, %esi
    cmp $0, %esi
    jle print_add

    sub $1, %esi
    mov %esi, f_d

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA
    mov %edx, interval_d

    mov f_id, %eax
    mov %eax, (%edi, %ebx, 4)

    inc %ebx
    jmp adaugare_efectiva

print_add:
    push interval_d
    push linie
    push interval_s
    push linie
    push f_id
    push $formatprintf1
    call printf
    add $24, %esp

    jmp citire_f_id_d

eroare_add:
    xor %esi, %esi

    push %esi
    push %esi
    push %esi
    push %esi
    push f_id
    push $formatprintf1
    call printf
    add $24, %esp

    jmp citire_f_id_d

eroare_get:
    xor %esi, %esi

    push %esi
    push %esi
    push %esi
    push %esi
    push $formatprintf2
    call printf
    add $20, %esp

    jmp resetare_registrii

resetare_registrii:
    xor %eax, %eax
    xor %ebx, %ebx
    xor %ecx, %ecx
    xor %edx, %edx
    xor %esi, %esi

    jmp citirea_operatiei

citire_f_id_get:
    lea buffer, %eax
    push %eax
    push $formatscanf1
    call scanf
    add $8, %esp

    mov buffer, %eax
    mov %eax, f_id

    mov $0, %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

parcurgere_get:
    mov linie, %esi
    cmp $1024, %esi
    je eroare_get

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov (%edi, %ebx, 4), %eax
    mov f_id, %esi
    mov %edx, interval_s

    cmp %esi, %eax
    je index_interval_d

    inc %ebx

    jmp parcurgere_get

index_interval_d:
    cmp %eax, %esi
    jne print_get

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA
    mov %edx, interval_d
    mov f_id, %esi

    inc %ebx

    mov (%edi, %ebx, 4), %eax

    jmp index_interval_d

print_get:
    push interval_d
    push linie
    push interval_s
    push linie
    push $formatprintf2
    call printf
    add $24, %esp

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

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

parcurgere_del:
    mov linie, %esi
    cmp $1024, %esi
    je reparcurgere_del_print

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

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

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov (%edi, %ebx, 4), %eax

    jmp stergere_f_id

reparcurgere_del_print:
    mov $0, %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

parcurgere_print_del:
    mov linie, %esi
    cmp $1024, %esi
    je resetare_registrii

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    jne print_del_pe_rand

    inc %ebx

    jmp parcurgere_print_del

print_del_pe_rand:
    mov %eax, f_id
    mov %edx, interval_s

continuare_print_del:
    mov f_id, %ecx
    cmp %eax, %ecx
    jne print_del

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA
    mov %edx, interval_d

    inc %ebx
    mov (%edi, %ebx, 4), %eax

    jmp continuare_print_del

print_del:
    push interval_d
    push linie
    push interval_s
    push linie
    push f_id
    push $formatprintf1
    call printf
    add $24, %esp

    jmp parcurgere_print_del   

verificare_printare:
    mov final, %esi
    cmp $20, %esi
    je pregatire_print_defrag

    inc %esi
    mov %esi, final

pregatire_defrag:
    xor %ebx, %ebx
    xor %ecx, %ecx
    xor %edx, %edx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

parcurgere_defrag:
    mov linie, %esi
    cmp $1024, %esi
    je reluare_defrag

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    je setare_stanga

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    inc %ebx

    jmp parcurgere_defrag

setare_stanga:  
    mov %ebx, stanga_defrag

cauta_f_id:
    mov linie, %esi
    cmp $1024, %esi
    je reluare_defrag

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    jne tinere_minte_nr

    inc %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov coloana, %esi
    cmp $0, %esi
    je parcurgere_defrag

    jmp cauta_f_id

tinere_minte_nr:
    mov %eax, f_id
    xor %ecx, %ecx 

numara_f_id_si_stergere:
    mov (%edi, %ebx, 4), %eax
    mov f_id, %esi
    cmp %eax, %esi
    jne pregatire_mutare_pe_vector

    inc %ecx

    mov $0, %eax
    mov %eax, (%edi, %ebx, 4)

    inc %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov coloana, %esi
    cmp $0, %esi
    je pregatire_mutare_pe_vector

    jmp numara_f_id_si_stergere

pregatire_mutare_pe_vector:
    mov stanga_defrag, %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

mutare_pe_vector:
    cmp $0, %ecx
    je parcurgere_defrag

    mov f_id, %esi
    mov %esi, (%edi, %ebx, 4)

    sub $1, %ecx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    inc %ebx

    jmp mutare_pe_vector

reluare_defrag:
    mov $0, %ebx
    mov $0, %ecx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

cautarea_ultimelor_zerouri:
    xor %ecx, %ecx

    mov linie, %esi
    cmp $1024, %esi
    je verificare_printare

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    je numarare_ultimele_zerouri

    inc %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    jmp cautarea_ultimelor_zerouri

numarare_ultimele_zerouri:
    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    jne cautarea_ultimelor_zerouri

    inc %ecx
    inc %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov coloana, %esi
    cmp $0, %esi
    je memorare_f_id_index

    jmp numarare_ultimele_zerouri

memorare_f_id_index:
    mov (%edi, %ebx, 4), %eax
    mov %eax, f_id
    mov %ebx, index
    mov %ecx, contor

    xor %ecx, %ecx
    
numarare_primii_f_id:
    mov (%edi, %ebx, 4), %eax
    mov f_id, %esi
    cmp %eax, %esi
    jne verificare_spatiu

    inc %ecx
    inc %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov coloana, %esi
    cmp $0, %esi
    je verificare_spatiu

    jmp numarare_primii_f_id

verificare_spatiu:
    mov contor, %esi
    cmp %ecx, %esi
    jge stergerea_f_id_urilor

    jmp cautarea_ultimelor_zerouri

stergerea_f_id_urilor:
    mov index, %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

stergerea:
    mov f_id, %esi
    mov (%edi, %ebx, 4), %eax
    cmp %eax, %esi
    jne mutare_linie_anterioara

    mov $0, %eax
    mov %eax, (%edi, %ebx, 4)

    inc %ebx
    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    jmp stergerea

mutare_linie_anterioara:
    mov index, %ebx
    mov contor, %ecx
    sub %ecx, %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

mutarea:
    mov contor, %esi
    cmp $0, %esi
    je cautarea_ultimelor_zerouri

    mov f_id, %esi
    mov %esi, (%edi, %ebx, 4)

    inc %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov contor, %esi
    dec %esi
    mov %esi, contor

    jmp mutarea

pregatire_print_defrag:
    mov $0, %ebx

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

parcurgere_print_defrag:
    mov linie, %esi
    cmp $1024, %esi
    je resetare_registrii

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    jne print_defrag_pe_rand

    inc %ebx

    jmp parcurgere_print_defrag

print_defrag_pe_rand:
    mov %eax, f_id
    mov %edx, interval_s

continuare_print_defrag:
    mov (%edi, %ebx, 4), %eax
    
    mov f_id, %ecx
    cmp %eax, %ecx
    jne print_defrag

    xor %edx, %edx
    mov $1024, %esi
    mov %ebx, %eax
    div %esi
    mov %eax, linie
    mov %edx, coloana # INDICII LINIE COLOANA
    mov %edx, interval_d

    inc %ebx
    mov (%edi, %ebx, 4), %eax

    jmp continuare_print_defrag

print_defrag:
    push interval_d
    push linie
    push interval_s
    push linie
    push f_id
    push $formatprintf1
    call printf
    add $24, %esp

    jmp parcurgere_print_defrag

et_exit:
    pushl $0
    call fflush
    popl %eax

    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
