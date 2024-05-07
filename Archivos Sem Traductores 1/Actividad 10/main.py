from tkinter import *
from tkinter import ttk
double_click_flag = False

from pynput.keyboard import Key, Controller
keyboard = Controller()

from ctypes import *

cdll.LoadLibrary("libAritmeticaASM.so")
libreria = CDLL("libAritmeticaASM.so")

suma = libreria.suma
suma.argtypes = [c_double, c_double]
suma.restype = c_double

resta = libreria.resta
resta.argtypes = [c_double, c_double]
resta.restype = c_double

multiplicacion = libreria.multiplicacion
multiplicacion.argtypes = [c_double, c_double]
multiplicacion.restype = c_double

division = libreria.division
division.argtypes = [c_double, c_double]
division.restype = c_double

seno = libreria.seno
seno.argtypes = [c_double]
seno.restype = c_double

coseno = libreria.coseno
coseno.argtypes = [c_double]
coseno.restype = c_double

tangente = libreria.tangente
tangente.argtypes = [c_double]
tangente.restype = c_double

arcoseno = libreria.arcoSeno
arcoseno.argtypes = [c_double]
arcoseno.restype = c_double

arcocoseno = libreria.arcoCoseno
arcocoseno.argtypes = [c_double]
arcocoseno.restype = c_double

arcotangente = libreria.arcoTangente
arcotangente.argtypes = [c_double]
arcotangente.restype = c_double

raiz = libreria.raizCuadrada
raiz.argtypes = [c_double]
raiz.restype = c_double

elevar = libreria.elevarCuadrado
elevar.argtypes = [c_double]
elevar.restype = c_double

log = libreria.logaritmo
log.argtypes = [c_double]
log.restype = c_double

antilog = libreria.antilogaritmo
antilog.argtypes = [c_double]
antilog.restype = c_double

cSigno = libreria.cambiarSigno
cSigno.argtypes = [c_double]
cSigno.restype = c_double

cGrados = libreria.convertirAGrados
cGrados.argtypes = [c_double]
cGrados.restype = c_double

cRadianes = libreria.convertirARadianes
cRadianes.argtypes = [c_double]
cRadianes.restype = c_double

class App(Tk):
	def operacion(self, operador):
		x = float(self.operando_x.get()) if (self.operando_x.get() != '') else float(self.display.get())
		y = float(self.operando_y.get()) if (self.operando_y.get() != '') else float(self.display.get())
		
		if(operador == "+"):
			self.display.set(str(suma(x, y)))
		elif(operador == "-"):
			self.display.set(str(resta(x, y)))
		elif(operador == "*"):
			self.display.set(str(multiplicacion(x, y)))
		elif(operador == "/"):
			self.display.set(str(division(x, y)))
		elif(operador == "sqrt"):
			self.display.set(str(raiz(x)))
		elif(operador == "pow"):
			self.display.set(str(elevar(x)))
		elif(operador == "RG"):
			if(self.unidad):
				self.display.set(str(cGrados(float(self.display.get()))))
			else:
				self.display.set(str(cRadianes(float(self.display.get()))))
				
			self.unidad = not(self.unidad)
		elif(operador == "CS"):
			if(self.operando_x.get() == '' and self.operando_y.get() == ''):
				self.display.set(str(cSigno(float(self.display.get()))))
			else:
				cambiar = self.operando_x if (self.entryActivo == "X") else self.operando_y
				cantidad = str(cSigno(float(cambiar.get())))
				cambiar.delete(0, 'end')
				cambiar.insert(0, cantidad)
			return
			
		self.operando_x.delete(0, 'end')
		self.operando_y.delete(0, 'end')
		
	def borrar(self, event):
		self.display.set(str("0.0"))
		
	def sen(self, event):
		self.unidad = True
		self.display.set(str(seno(float(self.operando_x.get()))))
		
	def asen(self, event):
		self.unidad = False
		self.display.set(str(cGrados(arcoseno(float(self.operando_x.get())))))
		
	def cos(self, event):
		self.unidad = True
		self.display.set(str(coseno(float(self.operando_x.get()))))
		
	def acos(self, event):
		self.unidad = False
		self.display.set(str(cGrados(arcocoseno(float(self.operando_x.get())))))
		
	def tang(self, event):
		self.unidad = True
		self.display.set(str(tangente(float(self.operando_x.get()))))
		
	def atang(self, event):
		self.unidad = False
		self.display.set(str(cGrados(arcotangente(float(self.operando_x.get())))))
		
	def log(self, event):
		self.display.set(str(log(float(self.operando_x.get()))))
		
	def alog(self, event):
		self.display.set(str(antilog(float(self.operando_x.get()))))
	
	def __init__(self):
		super().__init__()

		self.geometry("1500x900")
		self.title('Calculadora Ensamblador')
		self.minsize(1450, 900)
		self.config(bg='#c7ebd1')
		
		# Etiqueta variable (display)
		self.display = StringVar()
		self.display.set("0.0")
		self.unidad = True # Radianes
		self.entryActivo = "N"

		# Grid Principal
		self.grid_rowconfigure(index=0, weight=4)
		self.grid_rowconfigure(index=1, weight=2)
		self.grid_rowconfigure(index=2, weight=1)
		self.grid_rowconfigure(index=3, weight=1)
		self.grid_rowconfigure(index=4, weight=1)
		self.grid_rowconfigure(index=5, weight=1)
		self.grid_rowconfigure(index=6, weight=1)

		self.grid_columnconfigure(index=0, weight=1)
		self.grid_columnconfigure(index=1, weight=1)
		self.grid_columnconfigure(index=2, weight=2)
		self.grid_columnconfigure(index=3, weight=1)
		self.grid_columnconfigure(index=4, weight=1)

		self.crear_widgets()

	def crear_widgets(self):
		resultado = Label(self, textvariable=self.display, font=('Arial Bold', 25), relief=SOLID)
		resultado.grid(row=0, column=0, columnspan=5, sticky="nsew", padx=25, pady=(30, 10))

		# Text fields (Operandos)
		self.operando_x = ttk.Entry(self, font=('Arial', 25))
		self.operando_x.grid(row=1, column=0, columnspan=2, sticky="nsew", padx=(25, 15), pady=(5, 10))

		self.operando_y = ttk.Entry(self, font=('Arial', 25))
		self.operando_y.grid(row=1, column=3, columnspan=2, sticky="nsew", padx=(15, 25), pady=(5, 10))
		
		self.operando_x.bind("<FocusIn>", self.entradaX)
		self.operando_y.bind("<FocusIn>", self.entradaY)

		# Botones (Numeros y Operadores)

		# Números
		boton_9 = Button(self, text="9", bg="#145225", fg="white", font=('Arial', 16), command=lambda: keyboard.press("9"))
		boton_9.grid(row=2, column=3, sticky="nsew", padx=25, pady=15)

		boton_8 = Button(self, text="8", bg="#145225", fg="white", font=('Arial', 16), command=lambda: keyboard.press("8"))
		boton_8.grid(row=2, column=2, sticky="nsew", padx=25, pady=15)

		boton_7 = Button(self, text="7", bg="#145225", fg="white", font=('Arial', 16), command=lambda: keyboard.press("7"))
		boton_7.grid(row=2, column=1, sticky="nsew", padx=25, pady=15)

		boton_6 = Button(self, text="6", bg="#145225", fg="white", font=('Arial', 16), command=lambda: keyboard.press("6"))
		boton_6.grid(row=3, column=3, sticky="nsew", padx=25, pady=15)

		boton_5 = Button(self, text="5", bg="#145225", fg="white", font=('Arial', 16), command=lambda: keyboard.press("5"))
		boton_5.grid(row=3, column=2, sticky="nsew", padx=25, pady=15)

		boton_4 = Button(self, text="4", bg="#145225", fg="white", font=('Arial', 16), command=lambda: keyboard.press("4"))
		boton_4.grid(row=3, column=1, sticky="nsew", padx=25, pady=15)

		boton_3 = Button(self, text="3", bg="#145225", fg="white", font=('Arial', 16), command=lambda: keyboard.press("3"))
		boton_3.grid(row=4, column=3, sticky="nsew", padx=25, pady=15)

		boton_2 = Button(self, text="2", bg="#145225", fg="white", font=('Arial', 16), command=lambda: keyboard.press("2"))
		boton_2.grid(row=4, column=2, sticky="nsew", padx=25, pady=15)

		boton_1 = Button(self, text="1", bg="#145225", fg="white", font=('Arial', 16), command=lambda: keyboard.press("1"))
		boton_1.grid(row=4, column=1, sticky="nsew", padx=25, pady=15)

		boton_0 = Button(self, text="0", bg="#145225", fg="white", font=('Arial', 16), command=lambda: keyboard.press("0"))
		boton_0.grid(row=5, column=2, sticky="nsew", padx=25, pady=15)

		boton_signo = Button(self, text="±", bg="#104a20", fg="white", font=('Arial', 16), command=lambda: self.operacion("CS"))
		boton_signo.grid(row=5, column=1, sticky="nsew", padx=25, pady=15)

		boton_punto = Button(self, text=".", bg="#104a20", fg="white", font=('Arial', 25), command=lambda: keyboard.press("."))
		boton_punto.grid(row=5, column=3, sticky="nsew", padx=25, pady=15)

		# Operadores Básicos
		boton_suma = Button(self, text="+", bg="#14523d", fg="white", font=('Arial', 16), command=lambda: self.operacion("+"))
		boton_suma.grid(row=2, column=4, sticky="nsew", padx=25, pady=15)

		boton_resta = Button(self, text="-", bg="#14523d", fg="white", font=('Arial', 16), command=lambda: self.operacion("-"))
		boton_resta.grid(row=3, column=4, sticky="nsew", padx=25, pady=15)

		boton_mult = Button(self, text="*", bg="#14523d", fg="white", font=('Arial', 16), command=lambda: self.operacion("*"))
		boton_mult.grid(row=4, column=4, sticky="nsew", padx=25, pady=15)

		boton_div = Button(self, text="÷", bg="#14523d", fg="white", font=('Arial', 16), command=lambda: self.operacion("/"))
		boton_div.grid(row=5, column=4, sticky="nsew", padx=25, pady=15)

		# Operadores Trigonometricos
		boton_seno = Button(self, text="Sen", bg="#14523d", fg="white", font=('Arial', 16))
		boton_seno.grid(row=2, column=0, sticky="nsew", padx=25, pady=15)
		boton_seno.bind('<Button-1>', self.sen)
		boton_seno.bind('<Double-1>', self.asen)

		boton_coseno = Button(self, text="Cos", bg="#14523d", fg="white", font=('Arial', 16))
		boton_coseno.grid(row=3, column=0, sticky="nsew", padx=25, pady=15)
		boton_coseno.bind('<Button-1>', self.cos)
		boton_coseno.bind('<Double-1>', self.acos)
		
		boton_tang = Button(self, text="Tan", bg="#14523d", fg="white", font=('Arial', 16))
		boton_tang.grid(row=4, column=0, sticky="nsew", padx=25, pady=15)
		boton_tang.bind('<Button-1>', self.tang)
		boton_tang.bind('<Double-1>', self.atang)

		boton_log = Button(self, text="Log", bg="#14523d", fg="white", font=('Arial', 16))
		boton_log.grid(row=5, column=0, sticky="nsew", padx=25, pady=15)
		boton_log.bind('<Button-1>', self.log)
		boton_log.bind('<Double-1>', self.alog)

		# Utilma fila
		boton_grado_radian = Button(self, text="CR °", bg="#14523d", fg="white", font=('Arial', 16), command=lambda: self.operacion("RG"))
		boton_grado_radian.grid(row=6, column=0, sticky="nsew", padx=25, pady=15)

		boton_igual = Button(self, text="=", bg="#0e6e69", fg="white", font=('Arial', 16), command=lambda: self.operacion("="))
		boton_igual.grid(row=6, column=1, columnspan=2, sticky="nsew", padx=25, pady=15)
		boton_igual.bind('<Double-1>', self.borrar)

		boton_elevar = Button(self, text="x²", bg="#14523d", fg="white", font=('Arial', 16), command=lambda: self.operacion("pow"))
		boton_elevar.grid(row=6, column=3, sticky="nsew", padx=25, pady=15)

		boton_raiz = Button(self, text="√", bg="#14523d", fg="white", font=('Arial', 16), command=lambda: self.operacion("sqrt"))
		boton_raiz.grid(row=6, column=4, sticky="nsew", padx=25, pady=15)
	
	def entradaX(self, event):
		self.entryActivo = "X"

	def entradaY(self, event):
		self.entryActivo = "Y"
		
if __name__ == "__main__":
    app = App()
    app.mainloop()
