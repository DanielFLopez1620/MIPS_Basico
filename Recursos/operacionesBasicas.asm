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
        li $v0, 10  # Preparación para finalizar ejecución
        syscall 