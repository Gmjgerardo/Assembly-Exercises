#include <iostream>

extern "C" double* multiplicarComplejos(double*, double*); //2 flotantes de doble precision(64 bits) 128 bits para un registro xmm_

void imprimirComplejo(double*);
	
int main() {
	double complejo1[2], complejo2[2], *resultado;
	bool repetir(0);
	
	do {
		std::cout << "---- Actividad 5.a: Multiplicación de números complejos ----" << std::endl;
		std::cout << "Ingresa la parte REAL del primer imaginario: ";
		std::cin >> complejo1[0];
		std::cout << "Ingresa la parte IMAGINARIA del primer imaginario: ";
		std::cin >> complejo1[1];
		std::cout << "Ingresa la parte REAL del segundo imaginario: ";
		std::cin >> complejo2[0];
		std::cout << "Ingresa la parte IMAGINARIA del segundo imaginario: ";
		std::cin >> complejo2[1];
		
		std::cout << "Se registro: (";
		imprimirComplejo(complejo1);
		std::cout << ")";
		
		std::cout << "*(";
		imprimirComplejo(complejo2);
		std::cout << ")";
		
		resultado = multiplicarComplejos(complejo1, complejo2);
		std::cout << "\n\nEl resultado es: ";
		imprimirComplejo(resultado);

		std::cout << "\n¿Deseas intentarlo de nuevo? \t1)SI  0)NO" << std::endl;
		std::cin >> repetir;
		std::system ("clear");
	} while(repetir);
	
	return 0;
	}

void imprimirComplejo(double *complejo) {
	std::cout << complejo[0];
	
	if(complejo[1] > 0) {
			std::cout << "+";
			}
			
	std::cout << complejo[1] << "i";
	}
