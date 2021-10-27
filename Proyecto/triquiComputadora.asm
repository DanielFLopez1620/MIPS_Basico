#_____________________________ DATOS DEL PROGRAMA ___________________________________
.data
    #----------------------Reservas y arreglos de juego------------------------------
	tablero: .space 36
    tabla_numeros:   .byte   '1', '2', '3', '4', '5', '6', '7', '8', '9'
	tabla_aux:   .byte   '1', '2', '3', '4', '5', '6', '7', '8', '9'
    #---------------------Movimientos y aspectos de juego----------------------------
	nume_joc:      .asciiz   " \n\n Las señales seran X y O \n"
    descripcion:     .asciiz   " Juador (X)  -  Maquina (O) \n\n"
    j1: .byte 'X'
    j2: .byte 'O'
    #----------------------Partes de impresión del tablero de juego--------------------
	parte1:       .asciiz   "     |     |     \n"
    parte2:       .asciiz   "  "
    parte3:       .asciiz   "  |  "
    parte4:       .asciiz   "_____|_____|_____\n"
    parte5:       .asciiz   "  \n"
	#----------------------Mensaje para usuarios de juego-------------------------------
    MensajeJuga:   .asciiz   "Ingrese su movimiento (1-9) : "
	empa: .asciiz "Los jugadores empataron el juego"
	gana1: .asciiz "Gana el jugador 1"
	gana2: .asciiz "Gana el jugador 2"
	maquina: .asciiz "\nJuega la maquina...\n"
	titulo: .asciiz "Bienvenidos al triqui máquina vs jugador: "
#_________________________ DESARROLLO DEL PROGRAMA _____________________________________
.text
    #_______________________________DESARROLLO DEL MAIN_________________________________
    .globl main
    main:
        li $v0, 4
		la $a0, titulo
		syscall
		la $k0, tabla_numeros
        jal MostrarTablero
        whileprincipal:
            lb $s1, j1
            jal Jugada #Movimiento del jugador
            jal MostrarTablero
			#jal linea
            lb $s1, j2
            jal JugadaMaquina #Movimiento de la máquina
			jal Comprobacion
            jal MostrarTablero #Mostrar el tablero actualizado
			#jal linea
			jal EmpateySeguirjuego #Verifica si hay mv disponibles o un ganador
			beq $v1, $zero, whileprincipal
			beq $v1, -1, empate #Verifica si hay emparte para terminar juego
	empate:
		#Comandos para impresión de cadenas:
		li $v0, 4
		la $a0, empa
    	#Preparación para finalizar ejecución:
        li $v0, 10  
        syscall
	
    #________________DEFINICION DE FUNCIONES______________________________
    #------Función que carga el vector a temporales----------------------
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
        jr $ra #Comando de retorno a donde se realizo el salto
	#------Función que lee una posición y efectua el movimiento------------------
    Jugada:
   		la $a0, MensajeJuga
    	li $v0,4
    	syscall
    	li $v0, 5 #Lectura de entero por teclado
    	syscall 
    	addi $t9,$v0,-1
    	sb $s1, tabla_numeros($t9)
    	addi $sp, $sp, -16
    	sw $ra, 0($sp)
    	jal Comprobacion
    	lw $ra, 0($sp)
    	jr $ra
	#------------------Función para el movimiento de máquina---------------------
	# Busca analizar bloquear tres en línea del oponente y completar un movimiento
	JugadaMaquina:
		la $a0, maquina
		li $v0, 4
		syscall
		addi $t9, $zero, 0
		addi $s3, $zero, 3
		addi $sp, $sp, -20
		sw $ra, 0($sp)
	whilefila:
		beq $t9, 9, columnas
		lb $t7, tabla_numeros($t9)
		lb $t8, tabla_aux($t9)
		beq $t7, $t8, salidaF	
		puntof:
		addi $t9, $t9, 1
		j whilefila
		salidaF: 
				div  $t9, $s3
				mflo $s2 #Registro para obtener el cociente
				mul $s2, $s2, $s3
				sub $s4, $t9, $s2
				addi $s5,$s4,1
				addi $s6,$s4,2
				div $s5, $s3
				mfhi $s5 #Registro para obtener el residuo
				div $s6, $s3
				mfhi $s6 #Registro para obtener el residuo
				add $s5,$s5,$s2
				add $s6,$s6,$s2
				lb $t7, tabla_numeros($s5)
				lb $t8, tabla_aux($s5)
				bne $t7, $t8, filaMaquina
				j puntof
				filaMaquina:
					lb $t8, tabla_numeros($s6)
					beq $t7, $t8, filaMaquina1
					j puntof
					filaMaquina1:
						sb $s1, tabla_numeros($t9)
						jal final
	columnas:				
			addi $t9, $zero, 0
			la $a0, empa
			li $v0,4
			syscall
		whilecolumnas:
			beq $t9, 9, diagonales
			lb $t7, tabla_numeros($t9)
			lb $t8, tabla_aux($t9)
			beq $t7, $t8, salidaC
			puntoc:
			addi $t9, $t9, 1
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
				bne $t7, $t8, colMaquina
				j puntoc
				colMaquina:
					lb $t8, tabla_numeros($s6)
					beq $t7, $t8, colMaquina1
					j puntoc
					colMaquina1:
						sb $s1, tabla_numeros($t9)
						jal final
		diagonales:
			addi $s2, $zero,0
			beq $t9, $s2, DiagoD1
			addi $s2, $zero, 4
			beq $t9, $s2, DiagoD2
			addi $s2, $zero, 8
			beq $t9, $s2, DiagoD3
			addi $s2, $zero,  2
			beq $t9, $s2, DiagoI1
			addi $s2, $zero,  4
			beq $t9, $s2, DiagoI2
			addi $s2, $zero,  6
			beq $t9, $s2, DiagoI3
			sali:
			jal especiales
			DiagoD1:
				lb $t7, tabla_numeros($t9)
				lb $t8, tabla_aux($t9)
				sw $ra, 4($sp)
				beq $t7, $t8, DiagoD11
				lw $ra, 4($sp)
				j sali
				DiagoD11:
					addi $s3, $t9, 4
					lb $t8, tabla_aux($s3)
					lb $t7, tabla_numeros($s3)
					sw $ra,8($sp)
					bne $t8, $t7,diagoD111
					lw $ra, 8($sp)
					j sali
					diagoD111:
						addi $s3, $s3, 4
						lb $t8, tabla_numeros($s3)
						sw $ra, 12($sp)
						beq $t7, $t8,diagod1fin
						lw $ra, 12($sp)
						j sali
						diagod1fin:
							sb $s1, tabla_numeros($t9)
							jal final
			DiagoD2:
				lb $t7, tabla_numeros($t9)
				lb $t8, tabla_aux($t9)
				sw $ra, 4($sp)
				beq $t7, $t8, DiagoD21
				lw $ra, 4($sp)
				j sali
				DiagoD21:
					addi $s3, $t9, 4
					lb $t8, tabla_aux($s3)
					lb $t7, tabla_numeros($s3)
					sw $ra, 8($sp)
					bne $t8, $t7,diagoD211
					lw $ra, 8($sp)
					j sali
					diagoD211:
						subi $s3, $s3, 8
						lb $t8, tabla_numeros($s3)
						sw $ra, 12($sp)
						beq $t7, $t8, diagod2fin
						lw $ra, 12($sp)
						j sali
						diagod2fin:
							sb $s1, tabla_numeros($t9)
							jal final
			DiagoD3:
				lb $t7, tabla_numeros($t9)
				lb $t8, tabla_aux($t9)
				sw $ra, 4($sp)
				beq $t7, $t8, DiagoD31
				lw $ra, 4($sp)
				j sali
				DiagoD31:
					subi $s3, $t9, 4
						lb $t8, tabla_aux($s3)
						lb $t7, tabla_numeros($s3)
						sw $ra, 8($sp)
					bne $t8, $t7,diagoD311
					lw $ra, 8($sp)
					j sali
					diagoD311:
						subi $s3, $s3, 4
							lb $t8, tabla_numeros($s3)
							sw $ra, 12($sp)
						beq $t7, $t8,diagod3fin
						lw $ra, 12($sp)
						j sali
						diagod3fin:
							sb $s1, tabla_numeros($t9)
							j final
			DiagoI1:
				lb $t7, tabla_numeros($t9)
				lb $t8, tabla_aux($t9)
				sw $ra, 4($sp)
				beq $t7, $t8, DiagoI11
				lw $ra, 4($sp)
				j sali
				DiagoI11:
					addi $s3, $t9, 2
						lb $t8, tabla_aux($s3)
						lb $t7, tabla_numeros($s3)
						sw $ra, 8($sp)
					bne $t8, $t7,diagoI111
					lw $ra, 8($sp)
					j sali
					diagoI111:
						addi $s3, $s3, 2
							lb $t8, tabla_numeros($s3)
							sw $ra, 12($sp)
						beq $t7, $t8,diagoI1fin
						lw $ra, 12($sp)
						j sali
						diagoI1fin:
							sb $s1, tabla_numeros($t9)
							j final
			DiagoI2:
				lb $t7, tabla_numeros($t9)
				lb $t8, tabla_aux($t9)
				sw $ra, 4($sp)
				beq $t7, $t8, DiagoI21
				lw $ra, 4($sp)
				j sali
				DiagoI21:
					addi $s3, $t9, 2
						lb $t8, tabla_aux($s3)
						lb $t7, tabla_numeros($s3)
						sw $ra, 8($sp)
					bne $t8, $t7,diagoI211
					lw $ra, 8($sp)
					j sali
					diagoI211:
						subi $s3, $s3, 4
							lb $t8, tabla_numeros($s3)
							sw $ra, 12($sp)
						beq $t7, $t8,diagoI2fin
						lw $ra, 12($sp)
						j sali
						diagoI2fin:
							sb $s1, tabla_numeros($t9)
							j final
			DiagoI3:
				lb $t7, tabla_numeros($t9)
				lb $t8, tabla_aux($t9)
				sw $ra, 4($sp)
				beq $t7, $t8, DiagoI21
				lw $ra, 4($sp)
				j sali
				DiagoI31:
					subi $s3, $t9, 2
						lb $t8, tabla_aux($s3)
						lb $t7, tabla_numeros($s3)
						sw $ra, 8($sp)
					bne $t8, $t7,diagoI311
					lw $ra, 8($sp)
					j sali
					diagoI311:
						subi $s3, $s3, 4
							lb $t8, tabla_numeros($s3)
							sw $ra, 12($sp)
						beq $t7, $t8,diagoI3fin
						lw $ra, 12($sp)
						j sali
						diagoI3fin:
							sb $s1, tabla_numeros($t9)
							jal final
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
			sb $s1, tabla_numeros($t6)
			jal final
		einferiord:
			sb $s1, tabla_numeros($t6)
			jal final
		einferiori:
			sb $s1, tabla_numeros($t6)
			jal final
		esuperiord:
			sb $s1, tabla_numeros($t6)
			jal final
		esuperiori:
			sb $s1, tabla_numeros($t6)
			jal final
		final:
			jal Comprobacion
			lw $ra, 0($sp)
			jr $ra
	#----Función que manda al mensaje correspondiente de ganador----
	ganador:
		jal MostrarTablero
		lb $t9, j1
		beq $s1, $t9, Gana1
		lb $t9, j2
		beq $s1, $t9, Gana2
	#----Función que muestra que el jugador 1 gano------------------
	Gana1:
		li $v0, 4
		la $a0, gana1
		syscall
		# Preparación para finalizar ejecución:
		li $v0, 10  
		syscall
	#----Función que muestra que el jugador 2 gano------------------
	Gana2:
		li $v0, 4
		la $a0, gana2
		syscall
		# Preparación para finalizar ejecución:
		li $v0, 10  
		syscall
	#----Función que verifica existencia de movimeintos libres------
	EmpateySeguirjuego:    
        addi $t9, $zero, 0
		addi $v1, $zero, 0
		addi $sp,$sp,-4
		sw $ra, 0($sp)
        while10:
			lb $t7, tabla_numeros ($t9)
        	lb $t8, tabla_aux ($t9)
            beq $t7, '9', exit10
            bne $t7, $t8, siguiente
			lw $ra, 0($sp)
            jr $ra
        siguiente:
            addi $t9, $t9, 1
            j while10
        exit10:
            addi $v0, $zero, -1
			lw $ra, 0($sp)
            jr $ra
	linea:
		addi $t9, $zero,0
		while11:
		lb $t8, tabla_numeros($t9)
		li $v0, 11
		addi $a0, $t8, 0
		syscall
		addi $t9, $t9, 1
		bne  $t9, '9', while11
		jr $ra
#-----Función de actualización de datos en vector-------------------
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
	#-----------------Impresión de tablero-----------------------------
	Primeraesquina:
		addi $a0, $t0, 0
		addi $v0, $zero, 11
		syscall
		la $a0, parte3
		addi $v0, $zero, 4
		syscall
	Arribamitad:
		addi $a0, $t1, 0
		addi $v0, $zero, 11
		syscall
		la $a0, parte3
		addi $v0, $zero, 4
		syscall
	EsquinaDerecha:
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
	Medioizquierda:
		addi $a0, $t3, 0
		addi $v0, $zero, 11
		syscall
		la $a0, parte3
		addi $v0, $zero, 4
		syscall
	Mitad:
		addi $a0, $t4, 0
		addi $v0, $zero, 11
		syscall
		la $a0, parte3
		addi $v0, $zero, 4
		syscall
	MitadDerecha:
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
	AbajoIzquierda:
		addi $a0, $t6, 0
		addi $v0, $zero, 11
		syscall
		la $a0, parte3
		addi $v0, $zero, 4
		syscall
	Abajomedio:
		addi $a0, $t7, 0
		addi $v0, $zero, 11
		syscall
		la $a0, parte3
		addi $v0, $zero, 4
		syscall
	AbajoFinal:
		addi $a0, $t8, 0
		addi $v0, $zero, 11
		syscall
		la $a0, parte5
		addi $v0, $zero, 4
		syscall
		la $a0, parte1
		syscall
		jr $ra
	#---------------Función de comprobación de tres en raya-------------------
	#Esta función pasa por horizontales, luego verticales y después diagonales
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
    	lb $t7, tabla_numeros($t9)
    	lb $t8, tabla_numeros($s5)
    	sw $ra, 4($sp)
    	beq $t7,$t8,primeroHBien
    	jal vertical
    	primeroHBien:
	    	lb $t8, tabla_numeros($s6)
	    	sw $ra, 8($sp)
    		beq  $t8,$t7,ganador
    		lw $ra, 8($sp)
    		jr $ra
		vertical:
    	div $t9, $s3
    	mflo $s2
    	addi $s5, $s2,1
    	addi $s6, $s2,2
    	div $s5, $s3
    	mfhi $s5
    	div $s6, $s3
    	mfhi $s6
    	mul $s5, $s5, $s3
    	mul $s6, $s6, $s3
    	add $s5, $s5, $s4
    	add $s6, $s6, $s4
    	lb $t8, tabla_numeros($s5)
    	beq $t7,$t8,primeroVBien
    	jal diago
    	primeroVBien:
    		lb $t8, tabla_numeros($s6)
    		sw $ra, 8($sp)
    		beq  $t7,$t8,ganador
    		lw $ra, 8($sp)
    		jr $ra
	diago: 
    	beq $t9, 0, diagoD1 	
    	addi $s2, $zero, 4
    	beq $t9, $s2, diagoD2
    	addi $s2, $zero, 8
    	beq $t9, $s2, diagoD3
    	addi $s2, $zero, 2
    	beq $t9, $s2, diagoI1
    	addi $s2, $zero, 4
    	beq $t9, $s2, diagoI2  
    	addi $s2, $zero, 6
    	beq $t9, $s2, diagoI3
    	sal:
	    lw $ra, 4($sp)
    	jr $ra
    	diagoD1:
    		addi $s3, $s2, 4
    		lb $t8, tabla_numeros($s2)
    	    lb $t7, tabla_numeros($s3)
    		beq $t8, $t7,diagoD11
    		j sal
    		diagoD11:
    			addi $s3, $s2, 4
    	       	lb $t7, tabla_numeros($s3)
    			beq $t7, $t8,ganador
    			j sal
    	diagoD2:
    		addi $s3, $s2, 4
    		lb $t8, tabla_numeros($s2)
    	    lb $t7, tabla_numeros($s3)
    		beq $t8, $t7,diagoD21
    		j sal
    		diagoD21:
    			subi $s3, $s3, 8
    	       	lb $t7, tabla_numeros($s3)
    			beq $t7, $t8,ganador
    			j sal
    	diagoD3:
    		subi $s3, $s2, 4
    		lb $t8, tabla_numeros($s2)
    	    lb $t7, tabla_numeros($s3)
    		beq $t7, $t8,diagoD31
    		j sal
    		diagoD31:
    			subi $s3, $s3, 4
    	       	lb $t7, tabla_numeros($s3)
    			beq $t7, $t8,ganador
    			j sal
    	diagoI1:
    		addi $s3, $s2, 2
    		lb $t8, tabla_numeros($s2)
    	    lb $t7, tabla_numeros($s3)
    		beq $t7, $t8,diagoI11
    		j sal
    		diagoI11:
    			addi $s3, $s3, 2
    	       	lb $t7, tabla_numeros($s3)
    			beq $t7, $t8,ganador
    			j sal
    	diagoI2:
    		addi $s3, $s2, 2
    		lb $t8, tabla_numeros($s2)
    	    lb $t7, tabla_numeros($s3)
    		beq $t7, $t8,diagoI21
    		j sal
    		diagoI21:
    			subi $s3, $s3, 4
    	        lb $t7, tabla_numeros($s3)
    			beq $t7, $t8,ganador
    			j sal
    	diagoI3:
    		subi $s3, $s2, 2
    		lb $t8, tabla_numeros($s2)
    	    lb $t7, tabla_numeros($s3)
    		beq $t7, $t8,diagoI31
    		j sal
    		diagoI31:
    			subi $s3, $s3, 2
    	        lb $t7, tabla_numeros($s3)
    			beq $t7, $t8,ganador
    			j sal