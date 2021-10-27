#____________________ DATOS DEL PROGRAMA ____________________________________________
.data
    #----------------------Reservas y arreglos de juego------------------------------
	tablero: .space 36
    tabla_numeros:   .byte   '1', '2', '3', '4', '5', '6', '7', '8', '9'
	tabla_aux:   .byte   '1', '2', '3', '4', '5', '6', '7', '8', '9'
	#---------------------Movimientos y aspectos de juego-----------------------------
    nume_joc:      .asciiz   " \n\n Las señales seran X y O \n"
    descripcion:     .asciiz   " Jugador 1 (X)  -  Jugador 2 (O) \n\n"
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
	titulo: .asciiz "Bienvenidos al triqui de 2 jugadores: "
#_________________________ DESARROLLO DEL PROGRAMA _____________________________________
.text
    #_______________________________DESARROLLO DEL MAIN_________________________________
    .globl main  #Llamado a l main
    main:
        li $v0, 4
		la $a0, titulo
		syscall
		la $k0, tabla_numeros # Cargar arreglo
        jal MostrarTablero
        whileprincipal: # Ciclo de jugabilidad base
            lb $s1, j1
            jal Jugada # Movimiento del jugador 1
            jal MostrarTablero
            lb $s1, j2
            jal Jugada # Movimiento del jugador 2
            jal MostrarTablero
			jal EmpateySeguirjuego # Verifica si hay mov disponibles y si existe un ganador
			beq $v1, $zero, whileprincipal
			beq $v1, -1, empate # Verificación de empate para salir del juego
	empate:
		# Comandos para impresión de texto:
		li $v0, 4
		la $a0, empa
    	# Preparación para finalizar ejecución:
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
        jr $ra
	#------Función que lee una posición y efectua el movimiento----------
    Jugada:
   	la $a0, MensajeJuga
    	li $v0,4
    	syscall
    	li $v0,5
    	syscall 
    	addi $t9,$v0,-1
    	sb $s1, tabla_numeros($t9)
    	addi $sp, $sp, -16 # Reserva de memoria dinámica de 4 bits
    	sw $ra, 0($sp) # Guardado de dirección de salto
    	jal Comprobacion
    	lw $ra, 0($sp) # Lectura de dirección de salto
    	jr $ra
	#----Función que manda al mensaje correspondiente de ganador----
	ganador:
		jal MostrarTablero
		lb $t9, j1 # Lectura de byte
		beq $s1, $t9, Gana1 # Si es igual al simbolo j1, gana jugador 1
		lb $t9, j2
		beq $s1, $t9, Gana2 # Si es igual al simbolo j2, gana jugador 2
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
		sw $ra, 0($sp) #Guardado de dirección de salto 
        while10: # Bucle while realizado con saltos y etiquetas
			lb $t7, tabla_numeros ($t9)
        	lb $t8, tabla_aux ($t9)
            beq $t7, '9', exit10 # Condición de salida
            bne $t7, $t8, siguiente
			lw $ra, 0($sp)
            jr $ra
        siguiente: # Etiqueta de subfunción de sumatoria
            addi $t9, $t9, 1
            j while10
        exit10: # Salida del bucle
            addi $v0, $zero, -1
			lw $ra, 0($sp) #Cargar dirección de salto previo
            jr $ra
	#---------Función auxiliar para mostrar datos del arreglo-----------
	linea:
		addi $t9, $zero,0 # Contador en cero
		while11:
		lb $t8, tabla_numeros($t9) # Carga de byte respectivo
		li $v0, 11
		addi $a0, $t8, 0 #Mostrado de byte
		syscall
		addi $t9, $t9, 1 #Suma al contador
		bne  $t9, '9', while11 # Verificación de ciclo
		jr $ra # Salto de salida y ruptura de While
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
		lb $t8, 8($k0) #Load byte a arreglo
		la $a0, nume_joc
		addi $v0, $zero, 4
		syscall
		la $a0, descripcion
		syscall
		la $a0, parte1 #Mostrado inicial de tablero
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
	#---------------Función de comprobación de tres en raya---------------
	# Verifica horizontales, verticales y diagonales
	Comprobacion:
    	#Revisión de filas:
		addi $s3, $zero, 3
    	div $t9, $s3 # Division en registros $hi y $lo
    	mflo $s2 # Carga del registro low
    	mul $s2, $s2, $s3
    	sub $s4, $t9, $s2
    	addi $s5,$s4,1
    	addi $s6,$s4,2
    	div $s5, $s3
    	mfhi $s5  # Carga del registro high
    	div $s6, $s3
    	mfhi $s6
    	add $s5,$s5,$s2
    	add $s6,$s6,$s2
    	lb $t7, tabla_numeros($t9) # Carga de acceso de byte de arreglo
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
		vertical: # Verficación de columnas:
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
	diago: #Revision de diagonales:
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