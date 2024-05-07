section .data
cad1: db "estoy en archi2",10,0

section .text
global miMulti, miDivi
miMulti:
	push rbp
	mov rbp,rsp
        ;registros temporales para mult y div.
	xor rax,rax
	xor rbx,rbx
	xor rdx,rdx

	mov rax,rdi  ;edi
	mov rbx,rsi ;esi
	mul ebx

	mov rsp,rbp
	pop rbp
	ret

miDivi:
	push rbp
	mov rbp,rsp

	xor rax,rax
	xor rbx,rbx
	xor rdx,rdx

	mov rax,rdi ;edi
	mov rbx,rsi ;esi
	div ebx
	mov rax,rdx
	mov rsp,rbp
	pop rbp
	ret



