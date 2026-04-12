/*****************************************************************************/
/*                                                                           */
/*  main.cpp                                             TTTTTTTT SSSSSSS II */
/*                                                          TT    SS      II */
/*  By: st93642@students.tsi.lv                             TT    SSSSSSS II */
/*                                                          TT         SS II */
/*  Created: Apr 12 2026 15:25 st93642                      TT    SSSSSSS II */
/*  Updated: Apr 12 2026 15:42 st93642                                       */
/*                                                                           */
/*   Transport and Telecommunication Institute - Riga, Latvia                */
/*                       https://tsi.lv                                      */
/*****************************************************************************/

#include <iostream>
#include <limits>
#include <string>

void	shortestWord(const char *str, char *result)
{
	size_t	best_start = 0;
	size_t	best_len = 0;
	size_t	i = 0;
	bool	found = false;

	while (str[i])
	{
		while (str[i] == ' ') i++;
		if (!str[i])
			break;
		size_t word_start = i;
		while (str[i] && str[i] != ' ') i++;
		size_t len = i - word_start;
		if (!found || len < best_len)
		{
			best_start = word_start;
			best_len = len;
			found = true;
		}
	}
	if (found)
	{
		for (size_t j = 0; j < best_len; j++)
			result[j] = str[best_start + j];
		result[best_len] = '\0';
	}
	else
		*result = '\0';
}

void	shortestWord(const std::string &str, std::string &result)
{
	size_t	best_start = 0;
	size_t	best_len = 0;
	size_t	len = str.length();
	size_t	i = 0;
	bool	found = false;

	while (i < len)
	{
		while (i < len && str[i] == ' ') i++;
		if (i >= len)
			break;
		size_t word_start = i;
		while (i < len && str[i] != ' ') i++;
		size_t word_len = i - word_start;
		if (!found || word_len < best_len)
		{
			best_len = word_len;
			best_start = word_start;
			found = true;
		}
	}
	if (found)
		result = str.substr(best_start, best_len);
	else
		result = "";
}

int		main(void)
{
	const int	MAX_STRINGS = 10;
	const int	MAX_LEN = 256;
	char		c_arr[MAX_STRINGS][MAX_LEN];
	std::string	s_arr[MAX_STRINGS];
	char		result_c[MAX_LEN];
	std::string	result_s;
	int			n;
	int			i;

	std::cout << "Task Nr " << 93642 % 25 << std::endl;
	std::cout << "Enter number of strings: ";
	if (!(std::cin >> n))
	{
		std::cout << "Invalid count" << std::endl;
		return (1);
	}
	std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

	if (n <= 0 || n > MAX_STRINGS)
	{
		std::cout << "Invalid count" << std::endl;
		return (1);
	}

	i = -1;
	while (++i < n)
	{
		std::cout << "Enter string " << i + 1 << ": ";
		if (!std::cin.getline(c_arr[i], MAX_LEN))
		{
			std::cout << "Invalid input" << std::endl;
			return (1);
		}
		s_arr[i] = c_arr[i];
	}

	std::cout << std::endl << "Results (c-string version):" << std::endl;
	i = -1;
	while (++i < n)
	{
		shortestWord(c_arr[i], result_c);
		std::cout << "\"" << c_arr[i] << "\" -> \""
			<< result_c << "\"" << std::endl;
	}

	std::cout << std::endl << "Results (string version):" << std::endl;
	i = -1;
	while (++i < n)
	{
		shortestWord(s_arr[i], result_s);
		std::cout << "\"" << s_arr[i] << "\" -> \""
			<< result_s << "\"" << std::endl;
	}

	return (0);
}
