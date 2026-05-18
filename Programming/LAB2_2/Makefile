CXX      := g++
CXXFLAGS := -Wextra -Wall -Werror -pedantic -std=c++98
TARGET   := shops
SRC      := main.cpp
OBJ      := $(SRC:.cpp=.o)
TEST     := test_main.sh

.PHONY: all clean run test

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

run: $(TARGET)
	./$(TARGET)

test:
	./$(TEST)

clean:
	rm -f $(OBJ) $(TARGET)
