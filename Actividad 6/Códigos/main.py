from ctypes import *
from random import uniform

cdll.LoadLibrary("libFiltro.so")
libreria = CDLL("libFiltro.so")

filtrarVector = libreria.filtrar
filtrarVector.restype = None

def imprimirElementos(vector, tam):
	if(tam <= 16):
		for i in range(tam):
			print(vector[i], end="\n")
	else:
		print(str(vector[:3]) + str(vector[-3:]))

#1048576
if __name__ == "__main__":
	print("---- Actividad 6: Filtro IIR aplicado en vectores ----")
	tamano = int(input("Ingresa un tamaño para el vector: "))
	
	restante = (tamano % 8)		# Verificar que sea multiplo de 8
	if(restante != 0):			# Completar multiplos de 8
		tamano = (int(tamano / 8) * 8)
		if(restante > 6 or tamano == 0):
			tamano += 8
			
	Vector = c_float * tamano	# Crear "Tipo" vector (float * tamaño)
	# Parametros = 1.Vector Original(X), 2.Vector Resultado(Y), tamaño
	filtrarVector.argtypes = [Vector, Vector, c_int]
	
	# Instanciar vectores a utilizar
	original = Vector()			
	resultado = Vector()
	
	# Generar elementos aleatorios para el arreglo original
	for i in range(tamano):
		original[i] = uniform(0.0, 32767.0)

	print("Original:")
	imprimirElementos(original, tamano)
	filtrarVector(original, resultado, tamano)

	print("\nResultado:")
	imprimirElementos(resultado, tamano)
