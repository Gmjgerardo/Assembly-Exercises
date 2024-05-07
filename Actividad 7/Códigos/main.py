from ctypes import *
from tkinter import *
from tkinter import ttk
from tkinter import filedialog
from pydub import AudioSegment
from pydub.playback import play
import wave
import struct


cdll.LoadLibrary("libFiltro.so")
libreria = CDLL("libFiltro.so")

filtrarVector = libreria.filtrar
filtrarVector.restype = None


def isNaN(num):
	return 0.0 if (num != num) else num


def cargarVector():
	global original, resultado, tamano
	archivo = wave.open(n_Archivo, "r")
	ncanales, num_bytes, frecuencia, tamano, tipocomp, _ = archivo.getparams()
	# El tamaño se obtiene a partir de multiplicar el número de frames y el de canales
	tamano *= ncanales
	
	assert ncanales == 2 and num_bytes == 2 and tipocomp == "NONE"
	
	Vector = c_float * tamano	# Crear "Tipo" vector (float * tamaño)
	# Parametros = 1.Vector Original(X), 2.Vector Resultado(Y), tamaño
	filtrarVector.argtypes = [Vector, Vector, c_int]
	
	# Instanciar vectores a utilizar
	original = Vector()
	resultado = Vector()

	# Obtener datos del archivo de audio y guardarlos en un arreglo
	for i in range(0, tamano, 2):
		frames = (struct.unpack("<hh", archivo.readframes(1)))	# Obtiene 4 bytes y los divide en 2 floats de 16
		original[i] = isNaN(frames[0])
		original[i + 1] = isNaN(frames[1])

	archivo.close()
	
	print("Original:")	
	imprimirElementos(original, tamano)
	
	filtrarVector(original, resultado, tamano)	

	print("\nResultado:")
	imprimirElementos(resultado, tamano)
	
	crearWavFiltrado('filtrado.wav', frecuencia, ncanales, num_bytes)
	
	del(original)
	del(resultado)


def crearWavFiltrado(n_ArchivoS, frecue, canales, anchob):
	# Parametros originales del archivo
	archivo = wave.open(n_ArchivoS, "w")
	archivo.setnchannels(canales)
	archivo.setsampwidth(anchob)
	archivo.setframerate(frecue)
	
	for i in range(0, tamano):
		archivo.writeframesraw(struct.pack('<h', int(resultado[i]))) # Copia cada frame
		
	archivo.close()


def imprimirElementos(vector, tam):
	if(tam <= 16):
		for i in range(tam):
			print(vector[i], end="\n")
	else:
		print(str(vector[:3]) + str(vector[-3:]))


class App(Tk):
	def __init__(self):
		super().__init__()

		self.geometry("1500x620")
		self.title('Filtro IIR')
		self.minsize(1500, 620)

		# Grid Principal
		self.grid_rowconfigure(index=0, weight=2)
		self.grid_rowconfigure(index=1, weight=4)
		self.grid_rowconfigure(index=2, weight=1)

		self.grid_columnconfigure(index=0, weight=3)
		self.grid_columnconfigure(index=1, weight=1)
		self.grid_columnconfigure(index=2, weight=2)

		self.crear_Widgets()

	def crear_Widgets(self):
		Label(self, text='---- Actividad 7: Filtro IIR aplicado en archivos WAV ----', font=('Arial Bold', 28))\
			.grid(row=0, column=0, columnspan=3, sticky="nsew")

		# Grids Secundarios
		apartado_1 = Frame(self, bg='#00274c')	# Botones
		apartado_2 = Frame(self, bg='#00274c')	# Cortar Audio

		apartado_1.grid(row=1, column=0, sticky="nsew", padx=15, pady=15)
		apartado_2.grid(row=1, column=2, sticky="nsew", padx=15, pady=15)


		# Botones
		apartado_1.grid_rowconfigure(0, weight=1)
		apartado_1.grid_rowconfigure(1, weight=1)
		apartado_1.grid_rowconfigure(2, weight=1)

		apartado_1.grid_columnconfigure(0, weight=1)

		boton_archivo = Button(apartado_1, text="Abrir Archivo", font=('Arial', 16), command=self.buscaArchivo)
		boton_archivo.grid(row=0, column=0, sticky="nsew", padx=25, pady=15)
		
		boton_filtrar = Button(apartado_1, text="Filtrar", font=('Arial', 16), command=cargarVector)
		boton_filtrar.grid(row=1, column=0, sticky="nsew", padx=25, pady=15)
		
		boton_reproducir = Button(apartado_1, text="Reproducir", font=('Arial', 16), command=self.reproducir)
		boton_reproducir.grid(row=2, column=0, sticky="nsew", padx=25, pady=15)
		
		
		# Cortar Audio
		apartado_2.grid_rowconfigure(0, weight=2)
		apartado_2.grid_rowconfigure(1, weight=1)
		apartado_2.grid_rowconfigure(2, weight=1)
		apartado_2.grid_rowconfigure(3, weight=2)
		apartado_2.grid_rowconfigure(4, weight=2)
		
		apartado_2.grid_columnconfigure(0, weight=80)
		apartado_2.grid_columnconfigure(1, weight=1)
		
		self.e_duracion = Label(apartado_2, text="", font=('Arial', 20), 
		justify=LEFT, bg='#00274c', fg='white')
		self.e_duracion.grid(row=0, column=0, columnspan=2, sticky="ew", padx=(50,50), pady=(0, 5))
		
		Label(apartado_2, text="Inicio:", font=('Arial', 14), justify=LEFT). \
			grid(row=1, column=0, sticky="ew", padx=(50, 0), pady=(5, 0))

		self.inicio_corte = ttk.Spinbox(apartado_2, from_=1, to=30)
		self.inicio_corte.grid(row=1, column=1, sticky="ew", padx=(2, 50), pady=(5, 0))

		Label(apartado_2, text="Final:", font=('Arial', 14), justify=RIGHT). \
			grid(row=2, column=0, sticky="ew", padx=(50, 0), pady=(5, 0))

		self.fin_corte = ttk.Spinbox(apartado_2, from_=1, to=30)
		self.fin_corte.grid(row=2, column=1, sticky="ew", padx=(2, 50), pady=(5, 0))
		
		boton_cortar = Button(apartado_2, text="Cortar", font=('Arial', 16), command=self.cortarClip)
		boton_cortar.grid(row=3, column=0, columnspan=2, sticky="nsew", padx=50, pady=(2, 5))

		# Etiqueta archivo
		self.etiq_Archivo = Label(self, text='Archivo Seleccionado: ', font=('Arial Bold', 14))
		self.etiq_Archivo.grid(row=2, column=0, columnspan=3, sticky="nsew")
		
		
	def buscaArchivo(self):
		global n_Archivo
		n_Archivo = filedialog.askopenfilename(initialdir = "/home",
		title = "Elige un archivo", filetypes = (("Audio", "*.wav*"),
		("Todos", "*.*")))
		
		# Imprimir duración
		arch = wave.open(n_Archivo,'r')
		frames = arch.getnframes()
		rate = arch.getframerate()		
		self.e_duracion.configure(text="El audio dura: "+str(frames / float(rate))+
		" segundos")
		arch.close()
		
		self.etiq_Archivo.configure(text="Archivo Seleccionado: "+n_Archivo)
		
		
	def reproducir(self):
		audio = AudioSegment.from_wav(n_Archivo)
		play(audio)
		print(n_Archivo)


	def cortarClip(self):
		audio = AudioSegment.from_wav(n_Archivo)	# Abrir original
		# Obtener clip
		clip = audio[(int(self.inicio_corte.get())*1000):(int(self.fin_corte.get())*1000)]
		# Exportar clip
		clip.export(out_f = "clipTemp.wav", format = "wav")


if __name__ == "__main__":
	app = App()
	app.mainloop()
