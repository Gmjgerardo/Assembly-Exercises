bits 64

global seno, coseno, tangente, arcoSeno, arcoCoseno, arcoTangente:function
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
	je seno
	cmp rax, 3
	je coseno
	cmp rax, 4
	je tangente
	cmp rax, 5
	je arcoSeno
	cmp rax, 6
	je arcoCoseno
	cmp rax, 7
	je arcoTangente
	jmp finaliza
	
seno:
	cmp rax, 2		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 2		; Indicara que despues de inicio debe regresar a SENO
	jne inicio

	movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	
	; Obtener el seno del valor X
	fsin						; Obtener el seno de x

	fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
	movsd xmm0,[rbp - 8]		; Resultado en XMM0 para retorno a main.py

	jmp finaliza
    
coseno:
	cmp rax, 3		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 3		; Indicara que despues de inicio debe regresar a COSENO
	jne inicio
    
    movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
    fld qword[rbp - 8]			; Cargar X en el stack fpu
    
    ; Obtener el coseno del valor X
    fcos						; Obtener el coseno de x

    fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
    movsd xmm0,[rbp - 8]		; Resultado en XMM0 para retorno a main.py

    jmp finaliza

tangente:
	cmp rax, 4		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 4		; Indicara que despues de inicio debe regresar a TANGENTE
	jne inicio
    
    movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	
	; Obtener la tangente del valor X (Con formula = sen/cos)
	fsin						; Obtener el seno de x

	fld qword[rbp - 8]			; Cargar X en el stack fpu
	fcos						; Obtener el seno de x
    fdiv						; Obtener la tangente
    
	fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
	movsd xmm0,[rbp - 8]		; Resultado en XMM0 para retorno a main.py

    jmp finaliza
    
arcoSeno:
	cmp rax, 5		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 5		; Indicara que despues de inicio debe regresar a ASEN
	jne inicio

	movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	
	; Obtener el arcoSeno (Con formula = atan(x/(sqrt(1-x²))))
		; DIVISOR
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	
		; DIVIDENDO
	fld1						; Cargar 1 en el stack
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	fmul						; Obtener x² (quedará en st0)
	fsub						; Restar (1 - x²)
	fsqrt						; Obtener DIVIDENDO final
	fdiv						; Dividir (X / SQRT(1 - x²))
	
		; Utilizar función arcotangente de la FPUx87
	fld1			; Para mantener el resultado (Se dividira el resultado con st0)
	fpatan				; Obtener el arcoseno en base al arcotangente
	
	fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
	movsd xmm0,[rbp - 8]		; Resultado en XMM0 para retorno a main.py

	jmp finaliza

arcoCoseno:
	cmp rax, 6		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 6		; Indicara que despues de inicio debe regresar a ACOS
	jne inicio

	movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	
	; Obtener el arcoCoseno (Con formula = atan( (sqrt(1-x²)) / x))
		; DIVISOR
	fld1						; Cargar 1 en el stack
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	fmul						; Obtener x² (quedará en st0)
	fsub						; Restar (1 - x²)
	fsqrt						; Obtener Divisor final
	
		; DIVIDENDO
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	fdiv						; Dividir (SQRT(1 - x²) / X)
	
		; Utilizar función arcotangente de la FPUx87
	fld1		; Para mantener el resultado (Se dividira el resultado con st0)
	fpatan				; Obtener el arcocoseno en base al arcotangente
	
	fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
	movsd xmm0,[rbp - 8]		; Resultado en XMM0 para retorno a main.py

	jmp finaliza

arcoTangente:
	cmp rax, 7		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 7		; Indicara que despues de inicio debe regresar a ATAN
	jne inicio

	movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	
	; Obtener el arcotangente del valor X (Directo)
	fld1			; Para mantener el resultado (Se dividira el resultado con st0)
	fpatan						; Obtener el arcotangente (Se queda en st0)
	
	fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
	movsd xmm0,[rbp - 8]		; Resultado en XMM0 para retorno a main.py

	jmp finaliza
    
finaliza:
	mov rax, 0
	
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
