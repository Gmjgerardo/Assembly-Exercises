section .data
cad1: db "estoy en archi1",10,0
lcad: equ $-cad1
section .text
global miSuma, miResta
miSuma:
	push rbp
	mov rbp,rsp
        
	push rdi
	push rsi
	mov rax,1
	mov rdi,1
	mov rsi,cad1
	mov rdx,lcad
	syscall

	pop rsi
	pop rdi
	mov rax,rdi ; edi
	mov rbx,rsi ;esi
	add rax,rbx

	mov rsp,rbp
	pop rbp
	ret

miResta:
	push rbp
	mov rbp,rsp

	mov rax,rdi
	mov rbx,rsi
	sub rax,rbx

	mov rsp,rbp
	pop rbp
	ret


