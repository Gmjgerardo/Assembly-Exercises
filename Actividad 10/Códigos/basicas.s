bits 64

global suma, resta, multiplicacion, division:function
section .text
inicio:
	; Estado Inicial - Reservando espacio
	push rbp
	mov rbp, rsp
	sub rsp, 16

	; Permitir la re-entrancia/concurrencia
	push rbx
	push r12
	push r13
	push r14
	push r15
	
	cmp rax, 1
	je suma
	cmp rax, 3
	je resta
	cmp rax, 4
	je multiplicacion
	cmp rax, 5
	je division
	jmp finaliza
	
suma:
	cmp rax, 1		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 1		; Indicara que despues de inicio debe regresar a SUMA
	jne inicio
    
    ; Relizar la suma entre operandos
    addsd xmm0, xmm1	; Resultado en xmm0 (Para devolver a main)
    
    jmp finaliza
    
resta:
	cmp rax, 3		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 3		; Indicara que despues de inicio debe regresar a RESTA
	jne inicio
    
    ; Relizar la resta entre operandos
    subsd xmm0, xmm1	; Resultado en xmm0 (Para devolver a main)
    
    jmp finaliza
    
multiplicacion:
	cmp rax, 4		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 4		; Indicara que despues de inicio debe regresar a MUL
	jne inicio
    
    ; Relizar la multiplicación entre operandos
    mulsd xmm0, xmm1	; Resultado en xmm0 (Para devolver a main)
    
    jmp finaliza

division:
	cmp rax, 5		; Evaluar si ya se respaldaron los valores en inicio
	mov rax, 5		; Indicara que despues de inicio debe regresar a DIV
	jne inicio
	
    ; Relizar la división entre operandos
    divsd xmm0, xmm1	; Resultado en xmm0 (Para devolver a main)
    
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
	add rsp, 16
	mov rsp, rbp
	pop rbp

	ret		; Terminar función y retornar a main
