section .text
global miSuma,miResta

miSuma:
	push rbp
	mov rbp,rsp
	;sub rsp,16

;agregado para permitir la re-entrancia/concurrencia
	push rbx
	push r12
	push r13
	push r14
	push r15

	mov rax,rdi ;primer parm
 	mov rbx,rsi ;segundo parm

	add rax,rbx

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	
       ;add rsp,16
	mov rsp,rbp
	pop rbp
	ret


miResta:
	push rbp
	mov rbp,rsp
	sub rsp,16

;agregado para permitir la re-entrancia/concurrencia
	push rbx
	push r12
	push r13
	push r14
	push r15

	mov rax,rdi ;primer parm
 	mov rbx,rsi ;segundo parm

	sub rax,rbx

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	
	add rsp,16
	mov rsp,rbp
	pop rbp
	ret


