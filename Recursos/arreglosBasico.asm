.data
    tabla_numeros:   .byte  1, 2, 3, 4, 5
    hola: .asciiz "Hola"
.text
    .globl main
    main: 
        la $k0, tabla_numeros
        lb $t0, 0($k0)
        lb $t1, 1($k0)
        li $v0, 1
        add $a0, $zero , $t0 
        syscall
        li $v0, 1
        add $a0, $zero , $t1 
        syscall
        bne $t0, $t1, imprimir
        syscall
        # --Preparación para finalizar ejecución-----
        li $v0, 10  
        syscall 
    imprimir:
        li $v0, 4
        la $a0, hola
        syscall
