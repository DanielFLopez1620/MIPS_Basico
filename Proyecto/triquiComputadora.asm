#--------- DATOS DEL PROGRAMA ----------------------------------------
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
#--------- DESARROLLO DEL PROGRAMA -----------------------------------
.text
    #-----------------DESARROLLO DEL MAIN-----------------------------
    .globl main
    main:
        la $k0, tabla_numeros
        jal MostrarTablero
        # --Preparación para finalizar ejecución-----
        li $v0, 10  
        syscall      
    #-----------------DEFINICION DE FUNCIONES-------------------------
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
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        jal Tabla
        lw $ra, 0($sp)
        lb $t0, 0($k0)
        lb $t1, 1($k0)
        lb $t2, 2($k0)
        lb $t3, 3($k0)
        lb $t4, 4($k0)
        lb $t5, 5($k0)
        lb $t6, 6($k0)
        lb $t7, 7($k0)
        lb $t8, 8($k0)
        #beq $s0, 2, Maquina
        jr $ra
    Jugada:
   	    la $a0, MensajeJuga
    	li $v0,4
    	syscall
    	li $v0,5
    	syscall 
    	addi $t9,$v0,-1
    	sb $s1, tabla_numeros($t9)
    	jal Comprobacion
    Comprobacion:
    	addi $s3, $zero, 3
    	div $t9, $s3
    	mflo $s2
    	mul $s2, $s2, $s3
    	sub $s4, $t9, $s2
    	addi $s5,$s4,1
    	addi $s6,$s4,2
    	div $s5, $s3
    	mfhi $s5
    	div $s6, $s3
    	mfhi $s6
    	add $s5,$s5,$s2
    	add $s6,$s6,$s2
        
    	beq tabla_numeros($t9),tabla_numeros($s5),primeroHBien
    	jr $ra
    	primeroHBien:
    		beq  tabla_numeros($t9),tabla_numeros($s6),ganador
    		jr $ra
    	div $t9, $s3
    	mflo $s2
    	addi $s5, $s2,1
    	addi $s6, $s2, 2
    	div $s5, $s3
    	mfhi $s5
    	div $s6, $s3
    	mfhi $s6
    	mul $s5, $s5, $s3
    	mul $s6, $s6, $s3
    	add $s5, $s5, $s4
    	add $s6, $s6, $s4
    	beq tabla_numeros($t9),tabla_numeros($s5),primeroVBien
    	jr $ra

    	primeroVBien:
    		beq  tabla_numeros($t9),tabla_numeros($s6),ganador
    		jr $ra
    	lw $s2, 0
    	beq $t9, $s2, diagoD1
    	lw $s2, 4
    	beq $t9, $s2, diagoD2
    	lw $s2, 8
    	beq $t9, $s2, diagoD3
    	lw $s2, 2
    	beq $t9, $s2, diagoI1
    	lw $s2, 4
    	beq $t9, $s2, diagoI2
    	lw $s2, 6
    	beq $t9, $s2, diagoI3
    	jr $ra
    	diagoD1:
    		addi $s3, $t9, 4
    		beq tabla_numeros($s3), tabla_numeros($s2),diagoD11
    		jr $ra
    		diagoD11:
    			addi $s3, $s3, 4
    			beq tabla_numeros($s3), tabla_numeros($s2),ganador
    			jr $ra
    	diagoD2:
    		addi $s3, $t9, 4
    		beq tabla_numeros($s3), tabla_numeros($s2),diagoD21
    		jr $ra
    		diagoD21:
    			subi $s3, $s3, 8
    			beq tabla_numeros($s3), tabla_numeros($s2),ganador
    			jr $ra
    	diagoD3:
    		subi $s3, $t9, 4
    		beq tabla_numeros($s3), tabla_numeros($s2),diagoD31
    		jr $ra
    		diagoD31
    			subi $s3, $s3, 4
    			beq tabla_numeros($s3), tabla_numeros($s2),ganador
    			jr $ra
    	diagoI1:
    		addi $s3, $t9, 2
    		beq tabla_numeros($s3), tabla_numeros($s2),diagoI11
    		jr $ra
    		diagoI11
    			addi $s3, $s3, 2
    			beq tabla_numeros($s3), tabla_numeros($s2),ganador
    			jr $ra
    	diagoI2:
    		addi $s3, $t9, 2
    		beq tabla_numeros($s3), tabla_numeros($s2),diagoI21
    		jr $ra
    		diagoI21
    			subi $s3, $s3, 2
    			beq tabla_numeros($s3), tabla_numeros($s2),ganador
    			jr $ra
    	diagoI3:
    		subi $s3, $t9, 2
    		beq tabla_numeros($s3), tabla_numeros($s2),diagoI31
    		jr $ra
    		diagoI31
    			subi $s3, $s3, 2
    			beq tabla_numeros($s3), tabla_numeros($s2),ganador
    			jr $ra