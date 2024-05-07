section .data
inicio:			db "---- Actividad 3.a: Torres de Hanoi ----", 10, 0
linicio:		equ $-inicio
ingresa:		db "Var1		Var2		Var3", 10, 0
lingresa:		equ $-ingresa
varillas:		db "12358		_____		_____", 10, 0
finalcad:		db "Se termino el desplazamiento de 'discos' en: # movimientos", 10, 0

section .bss
resp:  	resb 1

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

	; Impresión de Instrucción
	mov rax, 1	; SysWrite
	mov rdi, 1	; Terminal
	mov rsi, varillas
	mov rdx, 21
	syscall

	; Almacenando tope de cada varilla
	mov rbx, varillas			; tope varilla 1
	mov r9, varillas + 11		; tope varilla 2
	mov r10, varillas + 18		; tope varilla 3

	; Variables de control
	mov rcx, 0		; Contador de moviemientos
	mov rdx, 5		; Número de "discos"

	mov rsi, rbx	; Primer "fuente" es la varilla 1
	mov rdi, r10	; Primer "destino" es la varilla 3

	call hanoi
	
finaliza:
	mov rax, rcx		; Total de movimientos de RCX a RAX
	
	push rax
	
	; Impresión final_1
	mov rax, 1	; SysWrite
	mov rdi, 1	; Terminal
	mov rsi, finalcad
	mov rdx, 45
	syscall
	
	pop rax
	
	call mostrarValor	; Impresión del total de movimientos (RAX)
	
	mov rbx, finalcad + 46		; Despues del '#'
	; Impresión final_2
	mov rax, 1	; SysWrite
	mov rdi, 1	; Terminal
	mov rsi, rbx
	mov rdx, 13
	syscall

	; Devolver todo a su estado inicial
	add rsp, 48
	mov rsp, rbp
	pop rbp

	; Teminar la ejecución correctamente
	mov rax, 60
	mov rdi, 0
	syscall

hanoi:
	cmp rdx, 1			; Disco '1' Criterio de paro a la recursion
	jz imprimirVarillas	; Mover e imprimir movimiento
	
	push rdx			; Almacenar el disco mayor en la pila hasta que se pueda mover
	
	; Invertir la varilla auxiliar y la varilla de destino
	dec rdx				; Mover el siguiente disco mas pequeño
	mov rbx, rdi		; Temporal (Auxiliar)
	mov rdi, r9			; Nuevo destino
	mov r9, rbx			; Nuevo auxiliar
	call hanoi
	
	pop rdx				; Recuperar disco para moverlo
	
	; Devolver estado original de movimiento de disco
	mov rbx, rdi		; Temporal (Auxiliar)
	mov rdi, r9
	mov r9, rbx
	
	call imprimirVarillas	; Mover e imprimir movimiento
	
	; Preparar siguiente llamado a Hanoi (Invertir Origen y Auxiliar)
	dec rdx				; Mover el siguiente disco mas pequeño
	mov rbx, rsi 		; Temporal (Auxiliar)
	mov rsi, r9
	mov r9, rbx
	
	inc rsi				; Mover tope del origen
	call hanoi
	dec rsi				; Devolver estado
	
	; Devolver estado original de movimiento de disco
	mov rbx, r9
	mov r9, rsi
	mov rsi, rbx	

	ret
	
imprimirVarillas:	
	mov al, byte[rdi]		; Obtener tope de la varilla destino
	
	cmp al, 0x5F			; Verificar que haya un espacio donde insertar
	jnz ajusteDest			; Si no hay espacio, buscar la siguiente posición
	
	mov al, byte[rsi]		; Obtener tope de la varilla origen
	
	cmp al, 0x5F			; Verificar que haya un valor distinto a "_"
	jz ajusteFue			; Encontrar ese valor en caso necesario
	
	cmp al, 0x38			; Verificar que el disco a mover sea el ultimo
	jz final				; Asignar el destino correcto (BUG)
	
	moverDiscos:
		inc rcx				; Incrementar el contador de movimientos
		push rcx			; Guardar el valor del contador (syscall :( )
		push rdx			; Guardar el valor del disco a mover	
		push rsi			; Guardar origen (Se cambia en la impresión)
		push rdi			; Guardar destino (Se cambia en la impresión)
		
		mov al, byte[rsi]	; Obtener valor del disco del tope de origen
		mov byte[rdi], al	; Mandar el disco al destino
		mov byte[rsi], 0x5F	; Borrar el valor del origen y dejarlo "_"
		
		; Impresión de Varillas
		mov rax, 1	; SysWrite
		mov rdi, 1	; Terminal
		mov rsi, varillas
		mov rdx, 21
		syscall
			
		; Recuperar datos guardados
		pop rdi
		pop rsi
		pop rdx
		pop rcx
		
		inc rsi		; Indicar donde esta el nuevo tope del origen
		dec rdi		; Indicar donde esta el nuevo tope del destino
		
		ret

ajusteDest:
	dec rdi
	mov al, byte[rdi]
	
	cmp al, 0x5F
	jnz ajusteDest
	
	jmp imprimirVarillas
	
ajusteFue:
	inc rsi
	mov al, byte[rsi]
	
	cmp al, 0x5F
	jz ajusteFue
	
	jmp imprimirVarillas
	
final:
	mov rdi, varillas + 18
	
	jmp moverDiscos

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
		
		ret
