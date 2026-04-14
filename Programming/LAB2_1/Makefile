#*****************************************************************************#
#                                                                             #
#  Makefile                                               TTTTTTTT SSSSSSS II #
#                                                            TT    SS      II #
#  By: st93642@students.tsi.lv                               TT    SSSSSSS II #
#                                                            TT         SS II #
#  Created: Apr 12 2026 15:51 st93642                        TT    SSSSSSS II #
#  Updated: Apr 12 2026 17:49 st93642                                         #
#                                                                             #
#   Transport and Telecommunication Institute - Riga, Latvia                  #
#                       https://tsi.lv                                        #
#*****************************************************************************#

NAME		= main

CC			= g++
CFLAGS		= -Wall -Wextra -Werror -pedantic

RM			= rm -f

SRC			= main.cpp

OBJ			= $(SRC:.cpp=.o)

all:		$(NAME)

$(NAME):	$(OBJ)
			$(CC) $(CFLAGS) $(OBJ) -o $(NAME)

clean:		
			@$(RM) $(OBJ)

fclean:		clean
			@$(RM) $(NAME)

re:			fclean all

.PHONY:		all clean fclean re
