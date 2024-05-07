extern printf

section .data
format:	db "%ld", 10 ,0

section .text
global fibonacci
fibonacci:
	; Alivianar al debugger
	push rbp
	mov rbp, rsp
	sub rsp, 48
		
	; Paso de parametro (Tope de sucesión)
	mov rcx, rdi
	inc rcx
	
	; Inicializando "Semillas"
	xor rax, rax	; Semilla "0"
	xor rbx, rbx
	inc rbx			; Semilla "1"	
	
calculo:
	; Guardando valores en la pila
	push rax
	push rcx
	
	; IMPRESION DEL RESULTADO
	mov rdi, format
	mov rsi, rax
	mov rax, 0
	
	call printf
	
	; Recuperando valores de la pila
	pop rcx
	pop rax	
		
	mov rdx, rax	
	mov rax, rbx	; Guarda siguiente "Fn-2"
	
	add rbx, rdx	; Fn = Fn-1 + Fn-2
	
	dec rcx
	jnz calculo	; Se detiene cuando rcx = 0
	
	; Recuperar posiciones y espacio inicial
	add rsp, 48
	mov rsp, rbp
	pop rbp
	
	ret	
