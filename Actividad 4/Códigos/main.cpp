#include <iostream>

extern "C" int raiz2(double& a, double& b, double& c);

int main() {
	double a_Raiz1(0), b_Raiz2(0), c_Discriminante(0);
	int resultado(0);
	bool repetir(0);

	do {
		std::cout << "---- Actividad 4: Trinomio Cuadrado Perfecto (Fórmula General) ----" << std::endl;
		std::cout << "Ingresa el valor para 'A' (Ax²): ";
		std::cin >> a_Raiz1;
		std::cout << "Ingresa el valor para 'B' (bx): ";
		std::cin >> b_Raiz2;
		std::cout << "Ingresa el valor para 'C' (C): ";
		std::cin >> c_Discriminante;
		
		std::cout << "Trinomio Cuadrático: " << a_Raiz1 << "x²+";
		std::cout << b_Raiz2 << "x+" << c_Discriminante << "\n\n";
	
		if((resultado = raiz2(a_Raiz1, b_Raiz2, c_Discriminante)) > 0) {
		if(resultado == 1) {
			std::cout << "Discriminante 0, Raíces iguales: " << a_Raiz1 <<  " & " << a_Raiz1 << std::endl;
			}
		else {
			std::cout << "Raíces diferentes! \t Raíz 1: " << a_Raiz1 << "\t Raíz 2: " << b_Raiz2 << std::endl;
			}
		}
		else {
			std::cout << "Raíces imaginarias debido al Discriminante: " << c_Discriminante << std::endl;
			}
			
		std::cout << "¿Deseas intentarlo de nuevo? \t1)SI  0)NO" << std::endl;
		std::cin >> repetir;
		std::system ("clear");
	} while(repetir);
	
	return 0;
	}
