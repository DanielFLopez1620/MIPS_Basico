.data
    tablero: .word 0:9 
    lenght: .word 9
    jugador1: .word 1
    jugador2: .word 2
    mensaje1: .asciiz "Digite su movimiento: "
    mensaje2: .asciiz " La computadora ha ganado "
    mensaje3: .asciiz " Él usuario ha ganado "
    saltoLinea: .asciiz "\n" 
    espacioLinea: .asciiz "  "
#Variables ocupadas:
# $t0-> tablero
# $t1-> tamaño
# $t2-> contador
# $t3-> posicion de juego
# $t4-> verificar
# $t5-> valor en posición / ----
.text
    #---DEFINICIÓN DEL MAIN:  ------------------------
    main:
        la $t0, tablero #base adress
        la $t1, lenght
        # --Preparación para finalizar ejecución------
        li $v0, 10  
        syscall
        
    #---DEFINICIÓN DE FUNCIONES: ---------------------

    comprobarGanador:

        whilecomprobarGanador:

            beq $t4, 9, exitcomporbarGanador

            beq 


            j while

        exitcomporbarGanador:
        syscall
        
        

    saltarLinea:
        li $v0, 4
        la $a0, saltoLinea
        syscall
        jr $ra

    imprimirTablero:
        li $t2, $zero
        addi $t2, $zero, 1
        whileTablero:
            beq $t1, $t2, exitTablero
            j exitTablero
            lw $t5, tablero($t2)
            add $t2, $t2, 1
            li $v0, 1
            move $a0, $t5
        exitTablero:
        syscall
        jr $ra

    Jugada:
        li $v0, 4
        la $a0, mensaje1
        syscall
        li $v0, 5
        syscall
        move 	$t3, $v0		# $t3 = $t1
        lw tablero($t3),
        
    