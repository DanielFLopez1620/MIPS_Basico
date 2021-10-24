.data
    letrero1: .asciiz "Digite un entero: "
    letrero2: .asciiz "Digite un flotante: "
    letrero3: .asciiz "Digite un doble: "
    letrero4: .asciiz "Digite una cadena: "
    mostrar: .asciiz "Lo obtenido es: "
    saltoLinea: .asciiz "\n"
    zeroD: .double 0.0
    zeroF: .float 0.0
    entradaCadena: .space 20
.text
    main:
        # --Lectura de entero-------------------------
        li $v0, 4
        la $a0, letrero1
        syscall
        li $v0, 5
        syscall
        move $t1,$v0
        jal lectura
        jal imprimirEntero
        jal saltarLinea
        # --Lectura de flotante-----------------------
        li $v0, 4
        la $a0, letrero2
        syscall
        li $v0, 6
        syscall
        jal lectura
        jal imprimirFlotante
        jal saltarLinea
        # --Lectura de doble--------------------------
        li $v0, 4
        la $a0, letrero3
        syscall
        li $v0, 7
        syscall
        jal lectura
        jal imprimirDoble
        jal saltarLinea
        # --Lectura de cadema-------------------------
        li $v0, 4
        la $a0, letrero4
        syscall
        li $v0, 8
        la $a0, entradaCadena
        li $a1, 20
        syscall
        jal lectura
        jal imprimirCadena
        jal saltarLinea
        # --Preparación para finalizar ejecución-----
        li $v0, 10  
        syscall 

    imprimirEntero:
        li $v0, 1
        add $a0, $zero, $t1
        syscall
        jr $ra

    imprimirFlotante:
        lwc1 $f3, zeroF
        li $v0, 2
        add.s $f12, $f3, $f0
        syscall
        jr $ra

    imprimirDoble:
        ldc1 $f2, zeroD
        add.d $f12, $f2, $f0
        syscall
        jr $ra

    imprimirCadena:
        li $v0, 4
        la $a0, entradaCadena
        syscall
        jr $ra

    saltarLinea:
        li $v0,4
        la $a0, saltoLinea
        syscall
        jr $ra # Retorno a la posicion donde fue llamado
    
    lectura:
        li $v0, 4
        la $a0, mostrar
        syscall
        jr $ra


