//--------- DATOS
.data
    tablero: .space 36
    tabla_numeros:   .byte   '1', '2', '3', '4', '5', '6', '7', '8', '9'
    nume_joc:      .asciiz   " \n\n Las señales seran X y O \n"
    descripcion:     .asciiz   " P 1 (X)  -  Maquina (O) \n\n"
    parte1:       .asciiz   "     |     |     \n"
    parte2:       .asciiz   "  "
    parte3:       .asciiz   "  |  "
    parte4:       .asciiz   "_____|_____|_____\n"
    parte5:       .asciiz   "  \n"
    MensajeJuga:   .asciiz   "Ingrese su movimiento (1-9) : "
.text
    .globl main
    main:
        la $k0, tabla_numeros     

Tabla:

    lb $t0, 0($k0)
    lb $t1, 1($k0)
    lb $t2, 2($k0)
    lb $t3, 3($k0)
    lb $t4, 4($k0)
    lb $t5, 5($k0)
    lb $t6, 6($k0)
    lb $t7, 7($k0)
    lb $t8, 8($k0)

    la $a0, nume_joc
    addi $v0, $zero, 4
    syscall

    la $a0, descripcion
    syscall

    la $a0, parte1
    syscall

    la $a0, parte2
    syscall

Primerafila:

    while:
        bgt	$t0, $t1, exit
        addi $a0, $t0, 0
        addi $v0, $zero, 11
        syscall
        la $a0, parte3
        addi $v0, $zero, 4
        syscall
        addi $t0, $t0, 1
        b while        
    exit: 
        addi $a0, $t2, 0
        addi $v0, $zero, 11
        syscall

        la $a0, parte5
        addi $v0, $zero, 4
        syscall

        la $a0, parte4
        syscall

        la $a0, parte1
        syscall

        la $a0, parte2
        syscall

Segunda2fila:

    while1:
        bgt	$t3, $t4, exit1
        addi $a0, $t3, 0
        addi $v0, $zero, 11
        syscall
        la $a0, parte3
        addi $v0, $zero, 4
        syscall
        addi $t3, $t3, 1
        b while1        
    exit1: 
    addi $a0, $t5, 0
    addi $v0, $zero, 11
    syscall

    la $a0, parte5
    addi $v0, $zero, 4
    syscall

    la $a0, parte4
    syscall

    la $a0, parte1
    syscall

    la $a0, parte2
    syscall

Tercerafila:

    while2:
        bgt	$t6, $t7, exit2
        addi $a0, $t6, 0
        addi $v0, $zero, 11
        syscall
        la $a0, parte3
        addi $v0, $zero, 4
        syscall
        addi $t6, $t6, 1
        b while2        
    exit2: 
    addi $a0, $t8, 0
    addi $v0, $zero, 11
    syscall

    la $a0, parte5
    addi $v0, $zero, 4
    syscall

    la $a0, parte1
    syscall

    jr $ra

MostrarTablero:

    jal Tabla
        lb $t0, 0($k0)
        lb $t1, 1($k0)
        lb $t2, 2($k0)
        lb $t3, 3($k0)
        lb $t4, 4($k0)
        lb $t5, 5($k0)
        lb $t6, 6($k0)
        lb $t7, 7($k0)
        lb $t8, 8($k0)
        beq $s0, 2, Maquina

Jugador1:

        addi $s0, $zero, 2
        la $a0, MensajeJuga
        addi $v0, $zero, 4
        syscall

        addi $s6, $zero, 88
        j Verificarprimero

    condition:
        addi $v0, $zero, 12
        syscall
        addi $a3, $v0, 0
        beq $a3, $s3, m9
        beq $a3, $s4, m9
        bne $a3, $t0, m1
        sb  $s6, 0($k0)
        j m10







