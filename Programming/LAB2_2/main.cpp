/*****************************************************************************/
/*                                                                           */
/*  main.cpp                                             TTTTTTTT SSSSSSS II */
/*                                                          TT    SS      II */
/*  By: st93642@students.tsi.lv                             TT    SSSSSSS II */
/*                                                          TT         SS II */
/*  Created: May 16 2026 12:46 st93642                      TT    SSSSSSS II */
/*  Updated: May 18 2026 18:41 93642                                         */
/*                                                                           */
/*   Transport and Telecommunication Institute - Riga, Latvia                */
/*                       https://tsi.lv                                      */
/*****************************************************************************/

#include <cstring>
#include <cstddef>
#include <fstream>
#include <iostream>
#include <limits>

const std::size_t	MAX_SHOPS = 100;
const char			*DATABASE_FILE = "shops.dat";

struct Shop
{
	char title[64];
	char address[128];
	char phone[32];
};

std::size_t readShops(Shop *shops)
{
	std::ifstream file(DATABASE_FILE, std::ios::binary);
	int			rawCount = 0;
	std::size_t	count;

	if (!file) return (0);
	file.read(reinterpret_cast<char *>(&rawCount), sizeof(rawCount));
	if (!file || rawCount < 0 || static_cast<std::size_t>(rawCount) > MAX_SHOPS) return (0);
	count = static_cast<std::size_t>(rawCount);
	if (count > 0)
	{
		file.read(reinterpret_cast<char *>(shops), sizeof(Shop) * count);
		if (!file) return (0);
	}
	return (count);
}

bool writeShops(const Shop *shops, std::size_t count)
{
	std::ofstream file(DATABASE_FILE, std::ios::binary);
	int rawCount = static_cast<int>(count);

	if (!file)
	{
		std::cout << "Cannot open file for writing.\n";
		return (false);
	}
	file.write(reinterpret_cast<const char *>(&rawCount), sizeof(rawCount));
	file.write(reinterpret_cast<const char *>(shops), sizeof(Shop) * count);
	if (!file)
	{
		std::cout << "Cannot write data to file.\n";
		return (false);
	}
	return (true);
}

void addData(Shop *shops, std::size_t *count)
{
	std::size_t index = *count;

	if (index >= MAX_SHOPS)
	{
		std::cout << "Database is full.\n";
		return;
	}

	std::cout << "Enter shop title: ";
	std::cin.getline(shops[index].title, 64);
	std::cout << "Enter address: ";
	std::cin.getline(shops[index].address, 128);
	std::cout << "Enter tel. number: ";
	std::cin.getline(shops[index].phone, 32);
	*count = index + 1;
	if (!writeShops(shops, *count))
	{
		*count = index;
		return;
	}
	std::cout << "Data saved.\n";
}

void viewData(const Shop *shops, std::size_t count)
{
	if (!count)
	{
		std::cout << "File is empty or does not exist.\n";
		return;
	}
	std::cout << "\nShops in file: " << count << '\n';
	for (std::size_t index = 0; index < count; index++)
		std::cout << "Shop " << index + 1 << ":\n"
				  << "  Title: " << shops[index].title << '\n'
				  << "  Address: " << shops[index].address << '\n'
				  << "  Tel. number: " << shops[index].phone << '\n';
}

void definePhoneByAddress(const Shop *shops, std::size_t count)
{
	char address[128];

	if (!count)
	{
		std::cout << "File is empty or does not exist.\n";
		return;
	}
	std::cout << "Enter address: ";
	std::cin.getline(address, 128);
	for (std::size_t i = 0; i < count; i++)
		if (std::strcmp(shops[i].address, address) == 0)
		{
			std::cout << "Tel. number: " << shops[i].phone << '\n';
			return;
		}
	std::cout << "Shop with this address was not found.\n";
}

int main(void)
{
	Shop shops[MAX_SHOPS];
	std::size_t	count = readShops(shops);
	int			menuItem;

	std::cout << "Task 2\n";
	for (;;)
	{
		std::cout << "\nMenu:\n"
				  << "1. Add data\n"
				  << "2. View data\n"
				  << "3. Define tel. number by address\n"
				  << "4. Exit\n"
				  << "Enter menu item: ";
		if (!(std::cin >> menuItem))
		{
			std::cin.clear();
			std::cout << "Invalid menu item.\n";
		}
		std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
		if (menuItem == 1)
			addData(shops, &count);
		else if (menuItem == 2)
			viewData(shops, count);
		else if (menuItem == 3)
			definePhoneByAddress(shops, count);
		else if (menuItem == 4)
			break;
		else
			std::cout << "Invalid menu item.\n";
	}
	return (0);
}
