.data   #Apartado de declaración de datos
    num1: .word 15  #.word para representar datos enteros
	num2: .word 10  
	letrero1: .asciiz "Suma: "  #.ascciz para representar cadenas o string
	letrero2: .asciiz "Resta: "
    letrero3: .asciiz "Multiplicacion: "
    letrero4: .asciiz "Division: "
	saltoLinea: .asciiz "\n" # \n representa un enter o salto de línea
.text
    main: # Etiqueta de función base o principal
        # --Cargar numeros-----------------------
        lw $t0,num1
        lw $t1,num2
        # --Calcular operaciones------------------
        add $t2,$t0,$t1
        sub $t3,$t0,$t1
        # --Desplegar resultados de suma----------
        li $v0,4
        la $a0, letrero1
        syscall
        li $v0,1
        add $a0, $zero, $t2
        syscall
        li $v0,4
        la $a0, saltoLinea
        syscall
        # --Desplegar resultados de resta---------
        li $v0,4
        la $a0, letrero2
        syscall
        li $v0,1
        add $a0, $zero, $t3
        syscall
        li $v0,4
        la $a0, saltoLinea
        syscall
        # --Preparación para finalizar ejecución--
        li $v0, 10  
        syscall 