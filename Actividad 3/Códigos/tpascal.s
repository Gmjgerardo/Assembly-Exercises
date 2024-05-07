section .data
inicio:     dw "---- Actividad 3.b: Triangulo de Pascal ----", 10, 0
linicio:    equ $-inicio
ingresa:    dw "Ingresa un número (Máximo 13): ", 10, 0
lingresa:   equ $-ingresa
errorcad:	db "ERROR: El número ingresado es mayor a 13", 10, 0
lerror:		equ $-errorcad

section .bss
pisos:	resb 1
resp:  	resb 1
combM:  resb 8
combN:  resb 8

section .text
global main
main:
    ; Estado Inicial - Reservando espacio
    push rbp
    mov rbp, rsp
    sub rsp, 48
    
    ; Impresión de Actividad
    mov rax, 1	; SysWrite
    mov rdi, 1	; Terminal
    mov rsi, inicio
    mov rdx, linicio
    syscall
    
    ; Impresión de Instrucción
    mov rax, 1	; SysWrite
    mov rdi, 1	; Terminal
    mov rsi, ingresa
    mov rdx, lingresa
    syscall

	; Lectura desde terminal
	mov rax, 0	; SysRead
	mov rdi, 0	; Terminal
	mov rsi, resp
	mov rdx, 4
	syscall

	; Conversión de ASCII a entero
	mov rbx, resp

	cmp byte[rbx + 1], 10	; Evaluando que NO sea un solo digito
	jz soloUnidad

	mov al, byte[rbx]		; Decenas

	sub al, 0x30			; Quitar ASCII y dejar digito solo
	mov rcx, 10
	mul rcx
	
	mov rcx, rax			; Guardar el resultado obtenido
    
    xor rax, rax			; Vaciar registro RAX
    mov al, byte[rbx + 1]	; Unidades
	
	jmp continuar
    
	soloUnidad:
		mov rcx, 0				; Limpiar RCX
		mov rax, 0				; Limpiar RAX
		
		mov al, byte[rbx]		; Digito unico

	continuar:
		sub al, 0x30		
		add rcx, rax          	; Unir decenas y unidades
		
		cmp rcx, 13
		ja error
		
triangulo:
	mov rbx, pisos
	mov byte[rbx], cl	; Guardar el número de pisos a mostrar
	
	mov rcx, 0			; Establecer contador en 0
	
	piso:
		mov rbx, rcx				; Temporal (Acumulador)
		
		push rcx					; factorial utiliza y modifica RCX
		call factorial				; combM!
		pop rcx						; Recupera valor original RCX

		mov rbx, combM
		mov qword[rbx], rax			; Guardar resultado combM!
		
		xor rdx, rdx				; Iterador de elementos combinatorios
		
		elemento:
			; Encontrar combN!
			push rcx				; Guardar i (RCX se necesita en Fact)
			
			mov rcx, rdx			; RCX = N! (0 a i)
			mov rbx, rcx			; Temporal (Acumulador)
			
			
			push rdx				; Guardar j (RDX se modifica en factorial)
			call factorial
			pop rdx					; Recuperar j
			
			mov rbx, combN
			mov qword[rbx], rax		; Guardar resultado combN!
			
			pop rcx					; Recuperar i
			
			; Encontrar (i - j)!
			push rcx				; Guardar i (RCX se necesita en Fact)
			push rdx				; Guardar j (RDX se modifica en Fact)
			
			sub rcx, rdx			; RCX = N! (0 a i)
			mov rbx, rcx			; Temporal (Acumulador)
			
			call factorial			; Resultado almacenado en RAX
			
					; Operaciones finales
			
			; Multiplicar CombN * (i - j)!
			mov rbx, combN
			mov rcx, qword[rbx]		; Rescatar valor de CombN
			mul rcx					; Multiplicarlo con RAX
			
			; Dividir CombM entre el resultado anterior
			mov rcx, rax			; Almacenar divisor final
			mov rbx, combM
			mov rax, qword[rbx]		; Rescatar dividendo (CombM)
			div rcx					; Resultado FINAL en RAX
			
			; IMPRESION
			call mostrarValor		; Mostrar el elemento Combinatorio m n
			pop rdx					; Recuperar j
			pop rcx					; Recuperar i

			inc rdx					; j + 1
			cmp rdx, rcx			
			jbe elemento			; Mientras j <= i
		
		; Despues de cada piso
		
		mov byte[rel resp], 0x0A	; Almacenando Salto de linea
		
		; IMPRESION DEL SALTO
		push rcx
		
		mov rax, 1	; SysWrite
		mov rdi, 1	; Terminal
		mov rsi, resp	; Digito
		mov rdx, 1
		syscall
		
		pop rcx
		
		inc rcx
		cmp cl, byte[rel pisos]
		jb piso
	
	jmp salir
    
factorial:
	cmp rcx, 1		; Verificar si es factorial de 1
	mov rax, 1		; Resultado de 1! y 0! == 1
	jbe finalFact	; Terminar "funcion" y devolver 1
	
	mov rax, rbx	; N y Acumulado
	dec rcx			; N - 1
	
	mul rcx
	mov rbx, rax	; Auxiliar (Guardar acumulado)

	cmp rcx, 1
    ja factorial	; Se detiene cuando rcx = 1
    
    finalFact:
		ret			; Resultado se almacena en RAX

salir:
	; Recuperar posiciones y espacio inicial
	add rsp, 48
	mov rsp, rbp
	pop rbp	
	
	; Terminar el proceso correctamente
    mov rax, 60		; SysExit
    mov rdi, 0		; Código de error
    syscall
    
error:
	; Impresión de Error
    mov rax, 1	; SysWrite
    mov rdi, 1	; Terminal
    mov rsi, errorcad
    mov rdx, lerror
    syscall

	jmp salir


mostrarValor:
	xor rcx, rcx		; Contador de cifras (inicializado en 0)
	mov rbx, 10			; Base Decimal
	
	dividirCifras:
		xor rdx, rdx	; Resetear resultado de divisiones
		
		div rbx
		push rdx		; Almacenar el digito obtenido en la pila
		inc rcx			; Aumentar contador de cifras
		
		test rax, rax	; Verificar que RAX no este vacio
		jnz dividirCifras	; Repetir hasta que ya no haya digitos por guardar
		
	impresionDigitos:
		pop rdx			; Recuperar digito de la pila
		add rdx, 0x30	; Obtener valor en ASCII
		
		mov byte[rel resp], dl	; Almacenando digito a imprimir
		
		push rcx		; Guardar contador (Syscall lo manda lejos...)
		
		; IMPRESION DEL DIGITO
		mov rax, 1	; SysWrite
		mov rdi, 1	; Terminal
		mov rsi, resp	; Digito
		mov rdx, 1
		syscall
		
		pop rcx			; Recuperar contador original
		loop impresionDigitos
		
		mov byte[rel resp], 0x20	; Almacenando Espacio
		
		; IMPRESION DEL ESPACIO
		mov rax, 1	; SysWrite
		mov rdi, 1	; Terminal
		mov rsi, resp	; Digito
		mov rdx, 1
		syscall
		
		ret
