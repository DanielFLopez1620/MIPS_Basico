#--------- DATOS DEL PROGRAMA ----------------------------------------
.data
    tablero: .space 36
    tabla_numeros:   .byte   '1', '2', '3', '4', '5', '6', '7', '8', '9'
    nume_joc:      .asciiz   " \n\n Las señales seran X y O \n"
    descripcion:     .asciiz   " P 1 (X)  -  Maquina (O) \n\n"
    j1: .byte 'x'
    j2: .byte 'O'
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
        whileprincipal:
             lb $s1, j2
             jal Jugada
             jal MostrarTablero
             lb $s1, j1
             jal JugadaMaquina
             jal MostrarTablero

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
    	li $v0, 5
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

JugadaMaquina:
addi $t9, $zero, 0
addi $s3, $zero, 3
whilefila:
	lb $t7, tabla_numeros($t9)
	lb $t8, tabla_aux($t9)
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	beq $t7, $t8, salidaF	
	addi $t9, $t9, 1
	beq $t9, 9, whilecolumnas
	j whilefila
	salidaF: 
   	 	div  $t9, $s3
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
    		lb $t7, tabla_numeros($s5)
    		lb $t8, tabla_aux($s5)
    		sw $ra, 1($sp)
    		bne $t7, $t8, filaMaquina
    		lw $ra, 1($sp)
    		jr $ra
    		filaMaquina:
    			lb $t8, tabla_numeros($s6)
    			sw $ra, 2($sp)
    			beq $t7, $t8, filaMaquina1
    			lw $ra, 2($sp)
    			jr $ra
    			filaMaquina1:
    				sb $s1, tabla_numeros($t9)
    				jr $ra
    				
addi $t9, $zero, 0
whilecolumnas:
	lb $t7, tabla_numeros($t9)
	lb $t8, tabla_aux($t9)
	beq $t7, $t8, salidaC
	beq $t9, 9, diagonales
	addi $t9, $t9, 1
	addi $t8, $t8,1
	j whilecolumnas
	salidaC:
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
		lb $t7, tabla_numeros($s5)
    		lb $t8, tabla_aux($s5)
    		sw $ra,1($sp)
    		bne $t7, $t8, colMaquina
    		lw $ra, 1($sp)
    		jr $ra
    		colMaquina:
    			lb $t8, tabla_numeros($s6)
    			sw $ra,2($sp)
    			beq $t7, $t8, colMaquina1
    			lw $ra, 2($sp)
    			jr $ra
    			colMaquina1:
    				sb $s1, tabla_numeros($t9)
    				jr $ra
    diagonales:
	lw $s2, 0
    	beq $t9, $s2, DiagoD1
    	lw $s2, 4
    	beq $t9, $s2, DiagoD2
    	lw $s2, 8
    	beq $t9, $s2, DiagoD3
    	lw $s2, 2
    	beq $t9, $s2, DiagoI1
    	lw $s2, 4
    	beq $t9, $s2, DiagoI2
    	lw $s2, 6
    	beq $t9, $s2, DiagoI3
    	jal especiales
    	DiagoD1:
    		lb $t7, tabla_numeros($t9)
    		lb $t8, tabla_aux($t9)
    		sw $ra, 4($sp)
    		beq $t7, $t8, DiagoD11
    		lw $ra, 4($sp)
    		jr $ra
    		DiagoD11:
    			addi $s3, $t9, 4
    	    		lb $t8, tabla_aux($s3)
    	        	lb $t7, tabla_numeros($s3)
    	        	sw $ra,8($sp)
    			bne $t8, $t7,diagoD111
    			lw $ra, 8($sp)
    			jr $ra
    			diagoD111:
    				addi $s3, $s3, 4
    	        		lb $t8, tabla_numeros($s3)
    	        		sw $ra, 12($sp)
    				beq $t7, $t8,diagod1fin
    				lw $ra, 12($sp)
    				jr $ra
    				diagod1fin:
    					sb $s1, tabla_numeros($t9)
    					jr $ra
    	DiagoD2:
    		lb $t7, tabla_numeros($t9)
    		lb $t8, tabla_aux($t9)
    		sw $ra, 4($sp)
    		beq $t7, $t8, DiagoD21
    		lw $ra, 4($sp)
    		jr $ra
    		DiagoD21:
    			addi $s3, $t9, 4
    	    		lb $t8, tabla_aux($s3)
    	        	lb $t7, tabla_numeros($s3)
    	        	sw $ra, 8($sp)
    			bne $t8, $t7,diagoD211
    			lw $ra, 8($sp)
    			jr $ra
    			diagoD211:
    				subi $s3, $s3, 8
    	        		lb $t8, tabla_numeros($s3)
    	        		sw $ra, 12($sp)
    				beq $t7, $t8,diagod2fin
    				lw $ra, 12($sp)
    				jr $ra
    				diagod2fin:
    					sb $s1, tabla_numeros($t9)
    					jr $ra
    	DiagoD3:
    		lb $t7, tabla_numeros($t9)
    		lb $t8, tabla_aux($t9)
    		sw $ra, 4($sp)
    		beq $t7, $t8, DiagoD31
    		lw $ra, 4($sp)
    		jr $ra
    		DiagoD31:
    			subi $s3, $t9, 4
    	    		lb $t8, tabla_aux($s3)
    	        	lb $t7, tabla_numeros($s3)
    	        	sw $ra, 8($sp)
    			bne $t8, $t7,diagoD311
    			lw $ra, 8($sp)
    			jr $ra
    			diagoD311:
    				subi $s3, $s3, 4
    	        		lb $t8, tabla_numeros($s3)
    	        		sw $ra, 12($sp)
    				beq $t7, $t8,diagod3fin
    				lw $ra, 12($sp)
    				jr $ra
    				diagod3fin:
    					sb $s1, tabla_numeros($t9)
    					jr $ra
    	DiagoI1:
    		lb $t7, tabla_numeros($t9)
    		lb $t8, tabla_aux($t9)
    		sw $ra, 4($sp)
    		beq $t7, $t8, DiagoI11
    		lw $ra, 4($sp)
    		jr $ra
    		DiagoI11:
    			addi $s3, $t9, 2
    	    		lb $t8, tabla_aux($s3)
    	        	lb $t7, tabla_numeros($s3)
    	        	sw $ra, 8($sp)
    			bne $t8, $t7,diagoI111
    			lw $ra, 8($sp)
    			jr $ra
    			diagoI111:
    				addi $s3, $s3, 2
    	        		lb $t8, tabla_numeros($s3)
    	        		sw $ra, 12($sp)
    				beq $t7, $t8,diagoI1fin
    				lw $ra, 12($sp)
    				jr $ra
    				diagoI1fin:
    					sb $s1, tabla_numeros($t9)
    					jr $ra
    	DiagoI2:
    		lb $t7, tabla_numeros($t9)
    		lb $t8, tabla_aux($t9)
    		sw $ra, 4($sp)
    		beq $t7, $t8, DiagoI21
    		lw $ra, 4($sp)
    		jr $ra
    		DiagoI21:
    			addi $s3, $t9, 2
    	    		lb $t8, tabla_aux($s3)
    	        	lb $t7, tabla_numeros($s3)
    	        	sw $ra, 8($sp)
    			bne $t8, $t7,diagoI211
    			lw $ra, 8($sp)
    			jr $ra
    			diagoI211:
    				subi $s3, $s3, 4
    	        		lb $t8, tabla_numeros($s3)
    	        		sw $ra, 12($sp)
    				beq $t7, $t8,diagoI2fin
    				lw $ra, 12($sp)
    				jr $ra
    				diagoI2fin:
    					sb $s1, tabla_numeros($t9)
    					jr $ra
    	DiagoI3:
    		lb $t7, tabla_numeros($t9)
    		lb $t8, tabla_aux($t9)
    		sw $ra, 4($sp)
    		beq $t7, $t8, DiagoI21
    		lw $ra, 4($sp)
    		jr $ra
    		DiagoI31:
    			subi $s3, $t9, 2
    	    		lb $t8, tabla_aux($s3)
    	        	lb $t7, tabla_numeros($s3)
    	        	sw $ra, 8($sp)
    			bne $t8, $t7,diagoI311
    			lw $ra, 8($sp)
    			jr $ra
    			diagoI311:
    				subi $s3, $s3, 4
    	        		lb $t8, tabla_numeros($s3)
    	        		sw $ra, 12($sp)
    				beq $t7, $t8,diagoI3fin
    				lw $ra, 12($sp)
    				jr $ra
    				diagoI3fin:
    					sb $s1, tabla_numeros($t9)
    					jr $ra
    especiales:
    	addi $t6, $zero, 4 
	lb $t7, tabla_numeros($t6)
	lb $t8, tabla_aux($t6)
	beq $t7, $t8, centro
	addi $t6, $zero, 0 
	lb $t7, tabla_numeros($t6)
	lb $t8, tabla_aux($t6)
	beq $t7, $t8, esuperiori
	addi $t6, $zero, 2 
	lb $t7, tabla_numeros($t6)
	lb $t8, tabla_aux($t6)
	beq $t7, $t8, esuperiord
	addi $t6, $zero, 6 
	lb $t7, tabla_numeros($t6)
	lb $t8, tabla_aux($t6)
	beq $t7, $t8, einferiori
	addi $t6, $zero, 8 
	lb $t7, tabla_numeros($t6)
	lb $t8, tabla_aux($t6)
	beq $t7, $t8, einferiord
	jal final
	centro:
		sw $s1, tabla_numeros($t6)
		jal final
		jr $ra
	einferiord:
		sw $s1, tabla_numeros($t6)
		jal final
		jr $ra
	einferiori:
		sw $s1, tabla_numeros($t6)
		jal final
		jr $ra
	esuperiord:
		sw $s1, tabla_numeros($t6)
		jal final
		jr $ra
	esuperiori:
		sw $s1, tabla_numeros($t6)
		jal final
		jr $ra
    final:
        jal Comprobacion
        lw $ra, 0($sp)
        jr $ra



EmpateySeguirjuego:    
        addi $t9, $zero, 0
        lb $t7, tabla_numeros ($t9)
        lb $t8, tabla_aux ($t9)
        while10:
            beq $t##it10
            beq $t7, $t8, siguiente
            addi $v0, $zero, 0
            jr $ra
        siguiente:
            addi $t9, $t9, 1
            addi $t8, $t8, 1
            j while10
        exit10:
            addi $v0, $zero, -1
            jr $ra