section .bss
complejo1:	resq 2		; 2 flotantes de 64 bits (Variables solo para ver en ddd)
complejo2:	resq 2
resu:		resq 2

section .text
global multiplicarComplejos
multiplicarComplejos:
	; Estado Inicial - Reservando espacio
	push rbp
	mov rbp, rsp
	sub rsp, 48

	; Guardar parametros de main en registros XMM_
		; Primer parametro en RDI (direccion a 2 double)
	movupd xmm0, [rdi] ; Mover flotantes doble precision sin alinear (a y b)
	
		; Primer parametro en RSI (direccion a 2 double)
	movupd xmm1, [rsi] ; Mover flotantes doble precision sin alinear (c y d)
	
	; Almacenamiento para visualizar en ddd
	mov rbx, complejo1	; Direccion del primer complejo
	movupd [rbx], xmm0	; Guardar 2 reales de 64 bits
	mov rbx, complejo2	; Direccion del primer complejo
	movupd [rbx], xmm1
	
	; Acomodar vectores
	movupd xmm2, xmm1	; Copiar coeficientes del segundo complejo en xmm2
		; 'Desempacar' e intercalar los elementos en la posicion mas baja de cada registro
	unpcklpd xmm1, xmm1	; Al ser el mismo, los números serán iguales
		; 'Desempacar' e intercalar los elementos en la posicion mas alta de cada registro
	unpckhpd xmm2, xmm2	; Al ser el mismo, los números serán iguales
	; El resultado seria algo como: xmm1 = c, c  y  xmm2 = d, d
	
	; Multiplicaciones vectoriales
	mulpd xmm1, xmm0	; Multiplicar vectores xmm1 = xmm1 * xmm0(c*a y c*a)
	mulpd xmm2, xmm0 	; Multiplicar vectores xmm2 = xmm1 * xmm0(d*a y d*b)
	
	; Mover resultados de las multiplicaciones para sumarlas despues
	shufpd xmm2, xmm2, 0001b	; Intercambiar extremos de un vector
	
	; Suma de multiplicaciones calculadas
	addsubpd xmm1, xmm2	; Suma aquellos valores en 'posiciones' impares
						; Resta aquellos valores en 'posiciones' pares
						; xmm1[0] = xmm1[0] - xmm2[0], xmm1[1] = xmm1[1] + xmm2[1]
	
	; Almacenar resultado en una variable
	mov rbx, resu
	movups [rbx], xmm1
	
finaliza:
	; Devolver todo a su estado inicial
	add rsp, 48
	mov rsp, rbp
	pop rbp
	
	mov rax, rbx	; Retornar resultado (Dirección a 2 double)
	ret				; Terminar función y retornar a main
