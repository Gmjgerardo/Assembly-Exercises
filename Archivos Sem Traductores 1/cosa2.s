section .data
cad: db "liga dinamica..",10,0
lcad: equ $-cad
section .text
global miMulti,miDivi

miMulti:
	push rbp
	mov rbp,rsp
	sub rsp,16

;agregado para permitir la re-entrancia/concurrencia
	push rbx
	push r12
	push r13
	push r14
	push r15
        
	xor rax,rax
	xor rbx,rbx
	xor rdx,rdx

	mov rax,rdi ;primer parm
 	mov rbx,rsi ;segundo parm

	mul rbx

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	
	add rsp,16
	mov rsp,rbp
	pop rbp
	ret


miDivi:
	push rbp
	mov rbp,rsp
	sub rsp,16

;agregado para permitir la re-entrancia/concurrencia
	push rbx
	push r12
	push r13
	push r14
	push r15
        push rdi
	push rsi

	mov rax,1
	mov rdi,1
	mov rsi,cad
	mov rdx,lcad
	syscall

	pop rsi
	pop rdi
	
	xor rax,rax
	xor rbx,rbx
	xor rdx,rdx


	mov rax,rdi ;primer parm
 	mov rbx,rsi ;segundo parm

	div rbx
	;mov rax,rdx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	
	add rsp,16
	mov rsp,rbp
	pop rbp
	ret



