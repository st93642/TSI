/*****************************************************************************/
/*                                                                           */
/*  main.cpp                                             TTTTTTTT SSSSSSS II */
/*                                                          TT    SS      II */
/*  By: st93642@students.tsi.lv                             TT    SSSSSSS II */
/*                                                          TT         SS II */
/*  Created: May 16 2026 12:46 st93642                      TT    SSSSSSS II */
/*  Updated: May 16 2026 13:56 st93642                                       */
/*                                                                           */
/*   Transport and Telecommunication Institute - Riga, Latvia                */
/*                       https://tsi.lv                                      */
/*****************************************************************************/

#include <cstdio>
#include <climits>
#include <cstring>

#define DATA_FILE "shops.txt"
#define MAX_SHOPS 100

typedef struct s_shop
{
	char	title[64];
	char	address[128];
	char	telephone[32];
} t_shop;

void	trim_line(char *text)
{
	size_t	len;

	len = strlen(text);
	while (len > 0 && (text[len - 1] == '\n' || text[len - 1] == '\r'))
		text[--len] = '\0';
}

int	read_text(const char *prompt, char *text, size_t size)
{
	if (size == 0 || size > (size_t)INT_MAX)
		return (0);
	printf("%s", prompt);
	if (fgets(text, (int)size, stdin) == NULL)
		return (0);
	trim_line(text);
	if (strchr(text, '|') != NULL)
		return (-1);
	return (1);
}

int	read_field(const char *prompt, char *text, size_t size)
{
	int	status;

	status = read_text(prompt, text, size);
	if (status == 0)
		printf("Invalid input.\n");
	else if (status < 0)
		printf("Character '|' is not allowed in data.\n");
	return (status > 0);
}

int	append_shop(const t_shop *shop)
{
	FILE	*file;

	file = fopen(DATA_FILE, "a");
	if (file == NULL)
		return (0);
	fprintf(file, "%s|%s|%s\n", shop->title, shop->address, shop->telephone);
	fclose(file);
	return (1);
}

int	parse_shop(char *line, t_shop *shop)
{
	trim_line(line);
	return (sscanf(line, "%63[^|]|%127[^|]|%31[^\n]",
			shop->title, shop->address, shop->telephone) == 3);
}

size_t	load_shops(t_shop shops[])
{
	FILE	*file;
	char	line[256];
	size_t	count;

	file = fopen(DATA_FILE, "r");
	if (file == NULL)
		return (0);
	count = 0;
	while (count < MAX_SHOPS && fgets(line, sizeof(line), file) != NULL)
		if (line[0] != '\n' && line[0] != '\0' && parse_shop(line, &shops[count]))
			count++;
	fclose(file);
	return (count);
}

void	view_data(void)
{
	t_shop	shops[MAX_SHOPS];
	size_t	count;
	size_t	i;

	count = load_shops(shops);
	if (count == 0)
	{
		printf("File is empty or does not exist.\n");
		return ;
	}
	printf("Count of shops in file: %zu\n", count);
	i = 0;
	while (i < count)
	{
		printf("Shop %zu:\n", i + 1);
		printf("  Title: %s\n", shops[i].title);
		printf("  Address: %s\n", shops[i].address);
		printf("  Tel. number: %s\n", shops[i].telephone);
		i++;
	}
}

void	add_data(void)
{
	t_shop	shop;

	if (!read_field("Enter shop title: ", shop.title, sizeof(shop.title)))
		return ;
	if (!read_field("Enter address: ", shop.address, sizeof(shop.address)))
		return ;
	if (!read_field("Enter tel. number: ", shop.telephone,
			sizeof(shop.telephone)))
		return ;
	if (!append_shop(&shop))
		return ((void)printf("Cannot open file for writing.\n"));
	printf("Data saved.\n");
}

const char	*find_phone(const t_shop shops[], size_t count, const char *address)
{
	size_t	index;

	index = 0;
	while (index < count)
	{
		if (strcmp(shops[index].address, address) == 0)
			return (shops[index].telephone);
		index++;
	}
	return (NULL);
}

void	individual_task(void)
{
	t_shop	shops[MAX_SHOPS];
	char	address[128];
	const char	*telephone;
	size_t		count;

	count = load_shops(shops);
	if (count == 0)
	{
		printf("File is empty or does not exist.\n");
		return ;
	}
	if (!read_field("Enter address to find tel. number: ", address,
			sizeof(address)))
		return ;
	telephone = find_phone(shops, count, address);
	if (telephone != NULL)
		printf("Tel. number: %s\n", telephone);
	else
		printf("Shop with this address was not found.\n");
}

void	print_menu(void)
{
	printf("\nMenu:\n");
	printf("1. View data\n");
	printf("2. Add data\n");
	printf("3. Define tel. number by address\n");
	printf("4. Exit\n");
	printf("Enter number of menu> ");
}

int		main(void)
{
	char	line[32];
	int	choice;

	printf("Task Nr %d\n", 93642 % 20);
	while (1)
	{
		print_menu();
		if (fgets(line, sizeof(line), stdin) == NULL
			|| sscanf(line, "%d", &choice) != 1)
		{
			printf("Invalid menu item.\n");
			continue ;
		}
		if (choice == 1)
			view_data();
		else if (choice == 2)
			add_data();
		else if (choice == 3)
			individual_task();
		else if (choice == 4)
			break ;
		else
			printf("Invalid menu item.\n");
	}
	return (0);
}
