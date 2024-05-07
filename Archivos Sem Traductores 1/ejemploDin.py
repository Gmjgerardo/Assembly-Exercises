from ctypes import *
cdll.LoadLibrary("libLasCosas.so")
LasCosas=CDLL("libLasCosas.so")

miSuma=LasCosas.miSuma
miSuma.restype=c_int

miMulti=LasCosas.miMulti
miMulti.restype=c_int


a=int(input("meter dato:"))
b=int(input("meter dato:"))

s=miSuma(a,b)
m=miMulti(a,b)


print("la suma :",s)
print("la multiplicacion :",m)

