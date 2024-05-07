section .data
cuatro:		dq 4.00		; Operando para: -4 * a * c
dos:		dq 2.00		; Operando para: 2 * a

section .bss
valorA:		resq 1 ; Si se utiliza printf se necesitaran 128 para imprimir XMM0
valorB:		resq 1
valorC:		resq 1
raiz:		resq 1
discr: 		resq 1

section .text
global raiz2
raiz2:
	; Estado Inicial - Reservando espacio
	push rbp
	mov rbp, rsp
	sub rsp, 48
	
	; Guardar el valor A
	mov rax, qword[rdi]		; RDI: Dirección del primer parametro (A)
	mov rbx, valorA			; Guardar dirección de la variable en rbx
	mov qword[rbx], rax		; Guardar valor de A (c++) a variable A en ensamblador
	
	; Guardar el valor B
	mov rax, qword[rsi]		; RSI: Dirección del segundo parametro (B)
	mov rbx, valorB
	mov qword[rbx], rax
	
	; Guardar el valor C
	mov rax, qword[rdx]		; RDX: Dirección del tercer parametro (C)
	mov rbx, valorC
	mov qword[rbx], rax
	
				; INICIO CALCULOS (DISCRIMINANTE)
	; Obtener B²
	fld qword[rel valorB]	; Cargar B en el registro st0
	fld qword[rel valorB]	; Cargar B en el registro st0
	fmul					; Multiplicar st0 y st1 (st0 = st0 * st1)
	
	; Obtener 4ac
	fld qword[rel cuatro]	; Cargar 4 en el registro st0
	fld qword[rel valorA]	; Cargar A en el registro st0
	fmul					; st0 = st0 * st1 (4*a)
	fld qword[rel valorC]	; Cargar C en el registro st0
	fmul					; st0 = st0 * st1 ((4*a)*c)
	
	; Obtener Discriminante
	fsub					; Restar st1 - st0 (b² - 4ac)
	
	; Evaluar resultado obtenido
	fldz					; Cargar 0 en el registro st0 (Para comparación)
	fcomip					; Comparar st0 con st1 y "pop st0" (st0 = st1)
	
	jz solucionUnica		; st1 y st0 son 0, por lo que solo hay una raíz
	jb dosSoluciones		; st0 < st1 (0 < Discriminante)	2 Raíces
	ja solucionNoReal		; st0 > st1 (0 > Discriminante) Raíz imaginaria

finaliza:
	; Devolver todo a su estado inicial
	add rsp, 48
	mov rsp, rbp
	pop rbp

	ret ; Volver a la ejecución en c++

solucionUnica:
	; Obtener valor de -b
	fld qword[rel valorB]		; Cargar B en el registro st0
	fchs					; Cambiar signo a st0 (st0 = -b)
	
	; Obtener valor de 2a
	fld qword[rel dos]			; Cargar 2 en el registro st0
	fld qword[rel valorA]		; Cargar A en el registro st0
	fmul					; st0 = st0 * st1 (st0 = 2*a)
	
	; Obtener unica raíz (-b / 2a)
	fdiv					; st0 = st1 / st0
	
	; Guardar resultado en variable a_Raiz1 de c++
	mov rbx, raiz			; Cargar dirección de variable raiz
	fstp qword[rbx]			; Cargar la raíz calculada desde st0
	
	mov rax, qword[rbx]		; Almacenar valor de la raíz en RAX
	mov qword[rdi], rax		; RDI: Dirección de primer parametro
	
	mov rax, 1				; Retornar 1 para indicar a main que solo hay una raíz
	jmp finaliza			; Terminar función y retornar a main
	
dosSoluciones:
	; Obtener raíz cuadrada del discriminante
	fsqrt					; st0 = raíz cuadrada de st0
	
	mov rbx, discr 			; Cargar dirección de la variable discriminante
	fstp qword[rbx]			; Cargar valor st0 hacia la variable y liberar st0
	
	;		---- PRIMERA RAIZ ----
	; Obtener valor de -b
	fld qword[rel valorB]	; Cargar B en el registro st0
	fchs					; Cambiar signo a st0 (st0 = -b)
	fst qword[rel valorB]	; Almacenar -b en la variable (sin hacer pop)
	
	; Obtener númerador -b + Discriminante (Raíz 1)
	fld qword[rbx]			; Cargar discriminante en el registro st0
	fadd					; st0 = st0 + st1 (-b + discriminante)
	
	; Obtener denominador 2a
	fld qword[rel dos]		; Cargar 2 en el registro st0
	fld qword[rel valorA]	; Cargar A en el registro st0
	fmul					; st0 = st0 * st1 (2 * a)
	fst qword[rel valorA]	; Almacenar 2a en la variable a - Auxiliar (Denominador)
	
	; Resultado
	fdiv					; División st0 = st1 / st0 ((-b+discr)/2a)
	
	mov rbx, raiz			; Cargar dirección de variable raiz
	fstp qword[rbx]			; Cargar valor st0 hacia raiz y liberar st0
	
	movsd xmm0, qword[rbx]	; Cargar en xmm0 el resultado calculado
	movsd qword[rdi], xmm0	; RDI: Dirección de primer parametro
	
	;		---- SEGUNDA RAIZ ----	
	; Obtener númerador -b - Discriminante (Raíz 2)
	fld qword[rel valorB]	; Cargar -b en el registro st0
	fld qword[rel discr]	; Cargar discriminante en st0
	fsub					; st0 = st1 - st0 (-b - discriminante)
	
	; Obtener denominador 2a
	fld qword[rel valorA]		; Cargar 2a en el registro st0
	
	; Resultado
	fdiv
	
	mov rbx, raiz			; Cargar dirección de variable raiz
	fstp qword[rbx]			; Cargar valor st0 hacia raiz y liberar st0
	
	movsd xmm0, qword[rbx]	; Cargar en xmm0 el resultado calculado
	movsd qword[rsi], xmm0	; RSI: Dirección de segundo parametro
	
	mov rax, 2				; Retornar 2 para indicar a main que exiten 2 raíces
	jmp finaliza			; Terminar función y retornar a main

solucionNoReal:
	mov rbx, discr			; Cargar dirección de variable discriminante
	fstp qword[rbx]			; Cargar valor de st0 hacia discr y liberar st0
	
	movsd xmm0, qword[rbx]
	movsd qword[rdx], xmm0	; RDX: Dirección del tercer parametro
	
	mov rax, 0				; Retornar 0 para indicar a main que NO exiten raíces reales
	jmp finaliza			; Terminar función y retornar a main
