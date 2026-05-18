/*****************************************************************************/
/*                                                                           */
/*  main.cpp                                             TTTTTTTT SSSSSSS II */
/*                                                          TT    SS      II */
/*  By: st93642@students.tsi.lv                             TT    SSSSSSS II */
/*                                                          TT         SS II */
/*  Created: May 16 2026 12:46 st93642                      TT    SSSSSSS II */
/*  Updated: May 18 2026 17:55 93642                                         */
/*                                                                           */
/*   Transport and Telecommunication Institute - Riga, Latvia                */
/*                       https://tsi.lv                                      */
/*****************************************************************************/

#include <cstring>
#include <fstream>
#include <iostream>
#include <limits>

const int	MAX_SHOPS = 100;
const char	DATABASE_FILE[] = "shops.dat";

struct Shop
{
	char title[64];
	char address[128];
	char phone[32];
};

int readShops(Shop *shops)
{
	std::ifstream file(DATABASE_FILE, std::ios::binary);
	int count = 0;

	if (!file) return (0);
	file.read(reinterpret_cast<char *>(&count), sizeof(count));
	if (!file || count < 0 || count > MAX_SHOPS) return (0);
	if (count > 0)
	{
		file.read(reinterpret_cast<char *>(shops), sizeof(Shop) * count);
		if (!file) return (0);
	}
	return (count);
}

bool writeShops(const Shop *shops, int count)
{
	std::ofstream file(DATABASE_FILE, std::ios::binary);

	if (!file)
	{
		std::cout << "Cannot open file for writing.\n";
		return (false);
	}
	file.write(reinterpret_cast<const char *>(&count), sizeof(count));
	file.write(reinterpret_cast<const char *>(shops), sizeof(Shop) * count);
	if (!file)
	{
		std::cout << "Cannot write data to file.\n";
		return (false);
	}
	return (true);
}

void addData(Shop *shops, int *count)
{
	int index = *count;

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

void viewData(const Shop *shops, int count)
{
	if (!count)
	{
		std::cout << "File is empty or does not exist.\n";
		return;
	}
	std::cout << "\nShops in file: " << count << '\n';
	for (int index = 0; index < count; index++)
		std::cout << "Shop " << index + 1 << ":\n"
				  << "  Title: " << shops[index].title << '\n'
				  << "  Address: " << shops[index].address << '\n'
				  << "  Tel. number: " << shops[index].phone << '\n';
}

void definePhoneByAddress(const Shop *shops, int count)
{
	char address[128];

	if (!count)
	{
		std::cout << "File is empty or does not exist.\n";
		return;
	}
	std::cout << "Enter address: ";
	std::cin.getline(address, 128);
	for (int index = 0; index < count; index++)
		if (std::strcmp(shops[index].address, address) == 0)
		{
			std::cout << "Tel. number: " << shops[index].phone << '\n';
			return;
		}
	std::cout << "Shop with this address was not found.\n";
}

int main(void)
{
	Shop shops[MAX_SHOPS];
	int count = readShops(shops);
	int menuItem;

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
