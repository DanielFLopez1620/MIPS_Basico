.data   #Apartado de declaración de datos
    num1: .word 15  #.word para representar datos enteros
	num2: .word 10
    pedir: .asciiz "Digite un numero:"  
	letrero1: .asciiz "Suma: "  #.ascciz para representar cadenas o string
	letrero2: .asciiz "Resta: "
    letrero3: .asciiz "Multiplicacion: "
    letrero4: .asciiz "Division entera: "
	saltoLinea: .asciiz "\n" # \n representa un enter o salto de línea
.text
    main: # Etiqueta de función base o principal
        # --Cargar numeros----------------------------------------------------
        lw $t0,num1 #load .word num1 a temporal 0
        lw $t1,num2 
        #--Incluir lectura por parte del usuario------------------------------
        li $v0, 4
        la $a0, pedir
        syscall
        li $v0, 5 #li con parametro cinco permite la lectura de un entero por teclado
        syscall
        add $t0, $zero, $v0 #Guardado del valor leido al temporal
        li $v0, 4
        la $a0, pedir
        syscall
        li $v0, 5
        syscall
        add $t1, $zero, $v0
        # --Calcular operaciones----------------------------------------------
        add $t2,$t0,$t1  #Cargar el resultado de $t0 y $t1 al primer parametro
        sub $t3,$t0,$t1
        mul $t4,$t0,$t1
        div $t5,$t0,$t1
        # --Desplegar resultados de suma--------------------------------------
        li $v0,4 # Load inmediate -> Prepara impresion string
        la $a0, letrero1 # Load adress
        syscall # Ejecución
        li $v0,1 # Load inmediate -> Prepara impresion entera
        add $a0, $zero, $t2 # Suma para pasar a $a0
        syscall
        jal saltarLinea # Llamado a la funcion para imprimir \n
        # --Desplegar resultados de resta------------
        li $v0,4
        la $a0, letrero2
        syscall
        li $v0,1
        add $a0, $zero, $t3
        syscall
        jal saltarLinea
        #--- Desplegar resultados de multiplicacion--
        li $v0,4
        la $a0, letrero3
        syscall
        li $v0,1
        add $a0, $zero, $t4
        syscall
        jal saltarLinea
        #--- Desplegar resultados de division-------
        li $v0,4
        la $a0, letrero4
        syscall
        li $v0,1
        add $a0, $zero, $t5
        syscall
        # --Preparación para finalizar ejecución-----
        li $v0, 10  
        syscall 
    saltarLinea:
        li $v0,4
        la $a0, saltoLinea
        syscall
        jr $ra # Retorno a la posicion donde fue llamado
