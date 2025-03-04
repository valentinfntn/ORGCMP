.ifndef __graficos__
.equ __graficos__, 0
.include "constantes.s"

//-------------------------------------------------------------------------------------------

cuadrado:
	// Recibe dos coordenadas que seran la posicion de inicio del cuadrado junto con ancho y alto
	// PARAMETROS::  X:x1, Y:x2, Ancho:x3, Alto:x4, Color:x10
	sub sp,sp, 40
	stur x1, [sp, 0]
    stur x2, [sp, 8]
    stur x3, [sp, 16]
	stur x4, [sp, 24]
	stur lr, [sp, 32]

	loopcuad0:
		bl setpixel
		add x1, x1, 1   		// Siguiente coordenada en X
		sub x3, x3, 1			// Falta un pixel menos para llegar al ancho
		cbnz x3, loopcuad0		// Si el ancho que falta no es 0, sigue pintando   
		ldur x3, [sp, 16]		// Si el contador de ancho llego a 0, lo resetea
		ldur x1, [sp, 0] 		// Tambien resetea la coord X
		sub x4, x4, 1			// Falta una fila menos para llegar a la altura
		add x2, x2, 1			// Siguiente coordenada en Y
		cbz x4, cuadrado_end	// Si el alto que falta es 0, ya pinto todo
		b loopcuad0

	cuadrado_end:
	ldur x1, [sp, 0]
    ldur x2, [sp, 8]
    ldur x3, [sp, 16]
	ldur x4, [sp, 24]
	ldur lr, [sp, 32]
	add sp,sp, 40
ret // Recibe dos coordenadas que seran la posicion de inicio del cuadrado junto con ancho y alto

//-------------------------------------------------------------------------------------------

setpixel: 
    // Recibe dos coordenadas y pinta el pixel con el color dado
    // PARAMETROS::  X:x1, Y:x2, COLOR:w10
    sub sp,sp, 24
    stur x1, [sp, 0]
    stur x2, [sp, 8]
    stur x3, [sp, 16]

    coord:
        // x3 = Dirección de inicio + 4 * [x + (y * 640)]
        mov x3, 640    // x3 =   640
        mul x3, x3, x2 // x3 =   640*y
        add x3, x3, x1 // x3 =  (640*y)+x
        lsl x3, x3, 2  // x3 = [(640*y)+x]*4
        add x3, x3, x0 // x3 = [(640*y)+x]*4 + Direccion de inicio
    //

    stur w10, [x3] // Colorea el pixel en la posicion calculada

    ldur x1, [sp, 0]
    ldur x2, [sp, 8]
    ldur x3, [sp, 16]
    add sp,sp, 24
ret // Recibe dos coordenadas y pinta el pixel con el color dado

//-------------------------------------------------------------------------------------------

pintarfondo:
    // Pinta el fondo con un color dado
    // PARAMETROS::  Color:x10 
    sub sp, sp, 24
    stur x1, [sp, 0]
    stur x2, [sp, 8]
    stur x0, [sp, 16]

	mov x2, SCREEN_HEIGH         // Y Size
    loop1:
        mov x1, SCREEN_WIDTH         // X Size
    loop0:
        stur w10,[x0]  // Colorear el pixel N
        add x0,x0,4    // Siguiente pixel
        sub x1,x1,1    // Decrementar contador X
        cbnz x1,loop0  // Si no terminó la fila, salto
        sub x2,x2,1    // Decrementar contador Y
        cbnz x2,loop1  // Si no es la última fila, salto

    ldur x1, [sp, 0]
    ldur x2, [sp, 8]
    ldur x0, [sp, 16]
    add sp, sp, 24
ret // Pinta el fondo con un color dado

//-------------------------------------------------------------------------------------------

.endif
