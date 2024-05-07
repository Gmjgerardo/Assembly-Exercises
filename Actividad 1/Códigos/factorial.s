extern printf

section .data
inicio:     dw "---- Actividad 1.2: Factorial ----", 10, 0
linicio:    equ $-inicio
ingresa:    dw "Ingresa un número (Máximo 20): ", 10, 0
lingresa:   equ $-ingresa

section .bss
resp:   resb 8

section .data
format: db "%ld", 10, 0

section .text
global main
main:
    mov rbp, rsp; for correct debugging
    
    ; Alivianar el debugger
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
    mov al, byte[rbx]		; Decenas
    
    sub al, 0x30		
    mov rcx, 10
    mul rcx
    
    mov rcx, rax			; Guardar el resultado obtenido
    
    xor rax, rax			; Vaciar registro RAX
    mov al, byte[rbx + 1]	; Unidades
    sub al, 0x30
    
    add rcx, rax          	; Unir decenas y unidades
    
    mov rax, rcx			; N (La multiplicación requiere del registro RAX)
    dec rcx					; N - 1
    
factorial:
    mov rbx, rcx		; N - (1, 2, 3, ...) > 0    
    mul rbx				; Resultado acumulado en RAX
    
    dec rcx    
    jnz factorial		; Se detiene cuando rcx = 0

	; IMPRESION DEL RESULTADO
    mov rdi, format
    mov rsi, rax
    mov rax, 0
    
    call printf
    
    ; Recuperar posiciones y espacio inicial
    add rsp, 48
    mov rsp, rbp
    pop rbp
    
    ; Terminar el proceso correctamente
    mov rax, 60		; SysExit
    mov rdi, 0		; Código de error
    syscall       
  
    ; ret			; Finalización para SASM
