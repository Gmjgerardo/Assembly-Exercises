#include <iostream>

extern "C" float(*transponer(float [][4]))[4];

void imprimirMatriz(float [][4]);
	
int main() {
	float matriz[4][4], entrada;
	float (*resultado)[4];
	
	bool repetir(0);
	
	do {
		std::system ("clear");
		std::cout << "---- Actividad 5.b: Transpuesta de una matriz ----" << std::endl;
		
		std::cout << "---- INGRESAR ELEMENTOS ----" << std::endl;
		for(int i(0) ; i < 4 ; i++) {
			for(int j(0) ; j < 4 ; j++) {
				std::cout << "Ingresa un valor para la posición [";
				std::cout << i << "] [" << j << "]: " << std::endl;
				
				std::cin >> entrada;
				matriz[i][j] = entrada;
				}
			}
			
		std::cout << "---- La matriz ingresada fue: ----" << std::endl;
		imprimirMatriz(matriz);
		
		resultado = transponer(matriz);
		
		std::cout << "---- La matriz trasnpuesta es: ----" << std::endl;
		imprimirMatriz(resultado);

		std::cout << "\n¿Deseas intentarlo de nuevo? \t1)SI  0)NO" << std::endl;
		std::cin >> repetir;
		
	} while(repetir);
	
	return 0;
	}

void imprimirMatriz(float m[][4]) {
	for(int i(0) ; i < 4 ; i++) {
		for(int j(0) ; j < 4 ; j++) {
			std::cout << m[i][j] << " ";
			}
		std::cout << std::endl;
		}
	}
