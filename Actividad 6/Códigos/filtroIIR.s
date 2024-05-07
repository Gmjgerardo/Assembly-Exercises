global filtrar
section .text
filtrar:
	; Estado Inicial - Reservando espacio
	push rbp
	mov rbp, rsp
	sub rsp, 56
	
	; Permitir la re-entrancia/concurrencia
	push rbx
	push r12
	push r13
	push r14
	push r15
	
	; Incializar variables locales
	; Calcular número de iteraciones principales
	mov rax, rdx		; Mover tamaño del arreglo a RAX (Dividendo)
	mov rdx, 0        	; Limpiar Dividendo
	mov rcx, 8    		; Divisor (caben 8 flotantes p.simple en 256 bits)
	div rcx           	; Resultado en RAX
	mov rcx, rax		; Número de iteraciones
	
	mov dword[rbp - 4], 3f000000h	; 0.5 convertido a simple precision en hexadecimal (Constante)
	mov dword[rbp - 8], 0			; Variable local de inmediato anterior(iniciada en 0)
	
	; xmm1 sera un vector para obtener las mitades de los elementos de X
	movss xmm0, dword[rbp - 4]		; Mover 0.5 a xmm1 como flotante de 32 bits
	vbroadcastss ymm0, xmm0			; Copiar el 0.5 en 8 posiciones (32 bits)
	
obtenerOcho:
	; Nuevos 8 elementos
	vmovups ymm1, [rdi]				; Obtener 8 elementos de X y ponerlos en ymm1
	vmulps ymm1, ymm0				; Obtener x[n] ... x[n + 8] / 2 y almacenarlos en ymm1
	
	; Guardar elementos X en vector local (8 de 32 bits)
	vmovups [rbp - 40], ymm1		; Mover 8 flotantes simples sin alinear
	
	; Utilizar a RDX como puntero al vector local
	mov rdx, rbp
	sub rdx, 40						; RDX = inicio de vector local
	
	; Iterar sobre los 8 elementos de X
	push rcx						; Respaldar iterador original
	mov rcx, 8						; Nuevo iterador = 8 (x[n] ... x[n + 8])
	obtenerY:
		; Mover flotante unico de 32 bits (X[n] * 0.5)
		movss xmm1, dword[rdx]		; Mover elemento del vector local(X) a xmm1
		
		; Multiplicar Y[n-1] por 0.5
		movss xmm2, dword[rbp - 8]	; Mover inmediato anterior a xmm2
		mulss xmm2, xmm0			; Multiplicar por 0.5
		
		; Sumar (x[n] * 0.5) + Y[n-1] * 0.5
		addss xmm1, xmm2			; Sumar xmm1 +  xmm2 y guardarlo en xmm1 (suma de flotantes sencillos)
		movss dword[rdx], xmm1		; Guardar resultado en vector local
		movss dword[rbp - 8], xmm1	; Actualizar valor del inmediato anterior
		add rdx, 4					; Mover apuntador a siguiente elemento de X
		
		loop obtenerY
	pop rcx		; Recuperar iterador original
	
	vmovups ymm1, [rbp - 40]		; Mover vector local (resultados) a ymm1
	vmovups [rsi], ymm1				; Mover elementos en ymm1 a vector resultado(python)
	
	add rdi, 32	; 4(bytes p/c flotante)*8(Flotantes en ymm) = 32
	add rsi, 32
	loop obtenerOcho				; Iteraciones calculadas al inicio

termina:
	; Recuperar valores originales
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	
	; Devolver todo a su estado inicial
	add rsp, 56
	mov rsp, rbp
	pop rbp
	
	ret		; Terminar función y retornar a main
