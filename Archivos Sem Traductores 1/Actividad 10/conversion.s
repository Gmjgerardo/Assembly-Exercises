bits 64

section .data
constanteGrados	dq 57.29578

global cambiarSigno, convertirAGrados, convertirARadianes:function
section .text
inicio:
	; Estado Inicial - Reservando espacio
	push rbp
	mov rbp, rsp
	sub rsp, 32		; (RBP - 8) variable local de 64 bits

	; Permitir la re-entrancia/concurrencia
	push rbx
	push r12
	push r13
	push r14
	push r15
	
	; Volver a la funcion original
	cmp rax, 2
	je cambiarSigno
	cmp rax, 3
	je convertirAGrados
	cmp rax, 4
	je convertirARadianes
	jmp finaliza
	
cambiarSigno:
	cmp rax, 2		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 2		; Indicara que despues de inicio debe regresar a CSIGNO
	jne inicio
    
	movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	
    fchs						; Cambiar signo del tope del stack
    
	fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
	movsd xmm0,[rbp - 8]		; Resultado en XMM0 para retorno a main.py

    jmp finaliza

convertirAGrados:
	cmp rax, 3		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 3		; Indicara que despues de inicio debe regresar a CGrados
	jne inicio

	movsd qword[rbp - 8], xmm0		; Pasar el parametro a variable local
	fld qword[rbp - 8]				; Cargar X en el stack fpu
    fld qword[rel constanteGrados]	; Cargar constante en el stack
    fmul							; multiplicar radianes por la constante
    
	fstp qword[rbp - 8]				; Recuperar el resultado en la variable local
	movsd xmm0,[rbp - 8]			; Resultado en XMM0 para retorno a main.py

	jmp finaliza

convertirARadianes:
	cmp rax, 4		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 4		; Indicara que despues de inicio debe regresar a CRadianes
	jne inicio

	movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	
	; Convertir grados a radianes (Con formula = Grados/57.29578)
		; DIVISOR
	fld qword[rbp - 8]				; Cargar X en el stack fpu
	
		; DIVIDENDO
	fld qword[rel constanteGrados]	; Cargar constante en el stack
	fdiv							; Dividir grados por la constante
	
	fstp qword[rbp - 8]				; Recuperar el resultado en la variable local
	movsd xmm0,[rbp - 8]			; Resultado en XMM0 para retorno a main.py

	jmp finaliza

finaliza:
	; Recuperar valores originales
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx

	; Devolver todo a su estado inicial
	add rsp, 32
	mov rsp, rbp
	pop rbp

	ret		; Terminar función y retornar a main
