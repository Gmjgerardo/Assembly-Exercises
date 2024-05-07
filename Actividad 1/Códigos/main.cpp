#include <iostream>

extern "C" void fibonacci(int tope);

int main() {
	int topeSerie(0);
	
	std::cout << "\t ---- Actividad 1.1: Fibonacci ----" << std::endl;
	std::cout << "Ingresa un número para calcular la secuencia de fibonacci: \t(Máximo: 46) \n";
	
	std::cin >> topeSerie;
	std::cin.clear();
	std::cin.ignore(10000, '\n');		
	
	if(topeSerie <= 93) {		
		if(topeSerie > 46)
			std::cout << "El tope era 46 ¬¬° pero si se puede, ahi te va: " << std::endl;
			
		fibonacci(topeSerie);
		}
	else	
		std::cout << "No se puede :( Rebasaste el limite posible para 64 bits!" << std::endl;
	
	return 0;
	}
