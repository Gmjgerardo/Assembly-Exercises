section .bss
vec1:	resd 4
vec2:	resd 4
vec3:	resd 4
vec4:	resd 4

section .text
global transponer
transponer:
	; Estado Inicial - Reservando espacio
	push rbp
	mov rbp, rsp
	sub rsp, 48
	
	; Guardar parametros de main en registros XMM_
		; Parametro en RDI (direccion a 4 arreglos de 4 flotantes de precision sencilla cada uno)
		; Primer Arreglo
	movups xmm0, [rdi]	; Mover flotantes de precision simple sin alinear
		; Segundo Arreglo
	movups xmm1, [rdi + 16] ; 128/8 = 16
		; Tercer Arreglo
	movups xmm2, [rdi + 32]	; 16 + 16 = 32
		; Cuarto Arreglo
	movups xmm3, [rdi + 48]	; 32 + 16 = 48
	
	; Almacenamiento para visualizar en ddd y Retornar resultado a main
	mov rbx, vec1
	movups [rbx], xmm0
	mov rbx, vec2
	movups [rbx], xmm1
	mov rbx, vec3
	movups [rbx], xmm2
	mov rbx, vec4
	movups [rbx], xmm3
	
	; Acomodar elementos para la transpuesta
		; xmm4 sera el vector 1 de la transpuesta
	movups xmm4, xmm0	; Copiar elementos de xmm0 a xmm4
	unpcklps xmm4, xmm1	; Desempaquetar e intercalar los elementos en las posiciones mas bajas
						; Los primeros 2 elementos del vector 1 ya estan en su posicion final
						
	unpckhps xmm0, xmm1	; Desempaquetar e intercalar los elementos en las posiciones mas altas
						; los ultimos 2 elementos del vector 3 ya estan en su posicion final
						
		; xmm5 sera el vector 2 de la transpuesta
	movups xmm5, xmm2	; Copiar elementos de xmm2 a xmm5
	
	; Mover los 2 ultimos valores del vector 2 final
	unpcklps xmm5, xmm3	; Desempaquetar e intercalar los elementos en las posiciones mas bajas
						
	; Mover elementos a sus posiciones finales (2 ultimos del vector 3 y 4 final)
	unpckhps xmm2, xmm3 ; Desempaquetar e intercalar los elementos en las posiciones mas altas
	
	; Respaldar los 2 primeros valores del vector 2 final
	movups xmm1, xmm4	; Copiar elementos de xmm4 a xmm1
	
	; Mover los 2 ultimos valores del vector 1 final
	movlhps xmm4, xmm5	; Mover los elementos en las posiciones mas bajas (primero las 2 de xmm5 y luego las 2 de xmm4)
	
	; Mover los 2 primeros valores del vector 2 final
	movhlps xmm5, xmm1	; Mover los elementos en las posiciones mas altas (primero las de xmm5 y luego las de xmm1)
		
		; xmm6 sera el vector 3 de la transpuesta
	; Mover los 2 ultimos valores del vector 3 final
	movups xmm6, xmm0	; Copiar elementos de xmm0 a xmm6
	
	; Mover los 2 primeros valores del vector 3 final
	movlhps xmm6, xmm2	; Mover los elementos en las posiciones mas bajas (primero las de xmm2 y luego las de xmm6)
	
		; xmm7 sera el vector 4 de la transpuesta
	; Mover los 2 ultimoa valores del vector 4 final
	movups xmm7, xmm2	; Copiar elementos de xmm2 a xmm7
	
	; Mover los 2 primeros valores del vector 4 final
	movhlps xmm7, xmm0	; Mover los elementos en las posiciones mas altas (primero las de xmm7 y luego las de xmm0)

	; Mover los nuevos arreglos a retornar
	mov rbx, vec1
	movups [rbx], xmm4	; En main = resultado[0]
	mov rbx, vec2
	movups [rbx], xmm5	; En main = resultado[1]
	mov rbx, vec3
	movups [rbx], xmm6	; En main = resultado[2]
	mov rbx, vec4
	movups [rbx], xmm7	; En main = resultado[3]
	
finaliza:
	; Devolver todo a su estado inicial
	add rsp, 48
	mov rsp, rbp
	pop rbp
	
	mov rax, vec1	; Retornar resultado (Dirección a la matriz transpuesta)
	ret				; Terminar función y retornar a main
