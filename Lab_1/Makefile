#*****************************************************************************#
#                                                                             #
#  Makefile                                               TTTTTTTT SSSSSSS II #
#                                                            TT    SS      II #
#  By: st93642@students.tsi.lv                               TT    SSSSSSS II #
#                                                            TT         SS II #
#  Created: Oct 06 2025 19:01 st93642                        TT    SSSSSSS II #
#  Updated: Oct 06 2025 19:04 st93642                                         #
#                                                                             #
#   Transport and Telecommunication Institute - Riga, Latvia                  #
#                       https://tsi.lv                                        #
#*****************************************************************************#

CXX ?= g++
CXXFLAGS ?= -std=c++17 -Wall -Wextra -Werror -O2
SRC := Lab_N1.cpp
BASENAME := $(basename $(notdir $(SRC)))
OUT_LINUX := $(BASENAME)
OUT_WIN := $(BASENAME).exe

.PHONY: linux windows msvc clean

# Auto-detect platform and set default goal:
# - Linux -> linux
# - MINGW/CYGWIN -> windows (MinGW g++)
# - Windows_NT (native) -> msvc (expect Developer Command Prompt)
OS_NAME := $(shell uname -s 2>/dev/null || echo)

ifeq ($(OS_NAME),)
	# uname not available (likely native Windows cmd). Check OS env var.
	ifeq ($(OS),Windows_NT)
		DEFAULT_GOAL := msvc
	else
		DEFAULT_GOAL := linux
	endif
else ifneq (,$(findstring Linux,$(OS_NAME)))
	DEFAULT_GOAL := linux
else ifneq (,$(findstring MINGW,$(OS_NAME)))
	DEFAULT_GOAL := windows
else ifneq (,$(findstring CYGWIN,$(OS_NAME)))
	DEFAULT_GOAL := windows
else ifneq (,$(findstring Darwin,$(OS_NAME)))
	DEFAULT_GOAL := linux
else
	DEFAULT_GOAL := linux
endif

.DEFAULT_GOAL := $(DEFAULT_GOAL)

linux: $(OUT_LINUX)

windows: CXX := x86_64-w64-mingw32-g++
windows: $(OUT_WIN)

$(OUT_LINUX): $(SRC)
	$(CXX) $(CXXFLAGS) $< -o $@

$(OUT_WIN): $(SRC)
	$(CXX) $(CXXFLAGS) $< -o $@

msvc:
	@echo "Building with MSVC (cl). Run this target from a Developer Command Prompt where cl is available."
	@if not exist "$(SRC)" (echo "Source not found" & exit 1)
	@cl /EHsc /std:c++17 /W4 /WX "$(SRC)" /Fe:"$(OUT_WIN)"

clean:
	@rm -f "$(OUT_LINUX)" "$(OUT_WIN)"
