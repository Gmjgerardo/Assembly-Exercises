bits 64

global raizCuadrada, elevarCuadrado, logaritmo, antilogaritmo:function
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
	je raizCuadrada
	cmp rax, 3
	je elevarCuadrado
	cmp rax, 4
	je logaritmo
	cmp rax, 5
	je antilogaritmo
	jmp finaliza
	
raizCuadrada:
	cmp rax, 2		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 2		; Indicara que despues de inicio debe regresar a RAIZ
	jne inicio

	movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	fld qword[rbp - 8]			; Cargar X en el stack fpu

	fsqrt						; Obtener raiz cuadrada de X

	fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
	movsd xmm0, [rbp - 8]		; Resultado en XMM0 para retorno a main.py
	
    jmp finaliza

elevarCuadrado:
	cmp rax, 3		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 3		; Indicara que despues de inicio debe regresar a CUADRADO
	jne inicio
	
	movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	
	; Obtener x²
    fld qword[rbp - 8]			; Cargar X en el stack fpu
    fld qword[rbp - 8]			; Cargar X en el stack fpu
    fmul						; Multiplicar X * X = X²
    
	fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
	movsd xmm0, [rbp - 8]		; Resultado en XMM0 para retorno a main.py
    
    jmp finaliza

logaritmo:
	cmp rax, 4		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 4		; Indicara que despues de inicio debe regresar a LOGARITMO
	jne inicio
	
	movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	
	; Obtener logaritmo de X (formula = (log2(X)) / (log2(10)))
		; DIVISOR
	fld1						; Cargar 1 en el stack
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	; Obtener log2(X)
	fyl2x	; (Calcula el log2 del st0 = (x) y multiplica el resultado por st1 = (1))
	
		; DIVIDENDO
    fldl2t						; Cargar log2(10) en el stack
    fdiv						; Dividir (log2(X) / log2(10))
    
	fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
	movsd xmm0, [rbp - 8]		; Resultado en XMM0 para retorno a main.py

	jmp finaliza
	
antilogaritmo:
	cmp rax, 5		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 5		; Indicara que despues de inicio debe regresar a ANTILOG
	jne inicio

	movsd qword[rbp - 8], xmm0	; Pasar el parametro a variable local
	
	; Obtener antilogaritmo de X (formula = 2^ (X*log2(10)) )
	fld qword[rbp - 8]			; Cargar X en el stack fpu
	fldl2t						; Cargar log2(10) en el stack
	fmul						; Calcular exponente (X*log2(10))
	
		; Obtener parte decimal del exponente calculado
    fst qword[rbp - 8]			; Guardar exponente en variable local
    frndint						; Redondear el exponente (en st0)
    fst qword[rbp - 16]			; Guardar parte entera del exponente en VL2
    fld qword[rbp - 8]			; Cargar exponente en variable local
    fld qword[rbp - 16]			; Cargar exponente parte entera de VL2
    fsub						; Obtener parte decimal del exponente (exponente con decimales - exponente entero)
    
		; Obtener 2^(X*log2(10))
    f2xm1						; Realizar 2^(X*log2(10) - 1)
    fld1						; Cargar 1 en el stack (Reponer el -1)
    fadd						; Sumar resultado + 1
    fscale						; Resultado final (truncar st1 y añadir st0(2^(X*log2(10))) como exponente)
    
	fstp qword[rbp - 8]			; Recuperar el resultado en la variable local
	movsd xmm0, [rbp - 8]		; Resultado en XMM0 para retorno a main.py

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
