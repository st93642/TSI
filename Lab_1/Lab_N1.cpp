/*****************************************************************************/
/*                                                                           */
/*  Lab_N1.cpp                                           TTTTTTTT SSSSSSS II */
/*                                                          TT    SS      II */
/*  By: st93642@students.tsi.lv                             TT    SSSSSSS II */
/*                                                          TT         SS II */
/*  Created: Oct 05 2025 17:34 st93642                      TT    SSSSSSS II */
/*  Updated: Oct 06 2025 11:50 st93642                                       */
/*                                                                           */
/*   Transport and Telecommunication Institute - Riga, Latvia                */
/*                       https://tsi.lv                                      */
/*****************************************************************************/

#include <iostream>
#include <cmath>

int	main(void)
{
	int				input_degr;
	int				normalized_input;
	double			alfa_rad;
	double			z1;
	double			z2;
	double			diff;

	const double	PI = acos(-1.0);

	std::cout << "Task Nr " << 93642%20 << std::endl;
	std::cout << "Enter angle in degrees: ";
	std::cin >> input_degr;

	normalized_input = input_degr % 360;
	if (normalized_input < 0) normalized_input += 360;
	alfa_rad = normalized_input * PI / 180.0;

	z1 = cos(alfa_rad) + sin(alfa_rad) + cos(3 * alfa_rad) + sin(3 * alfa_rad);
	z2 = 2 * sqrt(2) * cos(alfa_rad) * sin(PI / 4 + 2 * alfa_rad);
	diff = fabs(z1 - z2);

	std::cout << "Z1 = " << z1 << std::endl;
	std::cout << "Z2 = " << z2 << std::endl;
	std::cout << "Diff = " << diff << std::endl;

	return (0);
}
