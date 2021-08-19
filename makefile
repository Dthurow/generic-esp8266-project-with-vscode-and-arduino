DIR := ${CURDIR}
SKETCH = $(DIR)/src/mainFile.cpp
BUILD_DIR = $(DIR)/build
BOARD = huzzah
LIBS = $(HOME)/.arduino15/packages/esp8266/hardware/esp8266/2.7.4/libraries $(HOME)/Arduino/libraries 
EXCLUDE_DIRS = test
include $(DIR)/makeEspArduino/makeEspArduino.mk


TARGET_EXTENSION=.out
#Path Definitions
PATHU = test/unity/
PATHS = src/
PATHT = test/
PATHI = inc/
PATHB = build/

#determine our source files
SRCU = $(PATHU)unity.c
SRCS = $(PATHS)rssReader.cpp
SRCT = $(wildcard $(PATHT)*.cpp)
SRC = $(SRCU) $(SRCS) $(SRCT)

#Files We Are To Work With
OBJU = $(patsubst $(PATHU)%.c,$(PATHB)%.o,$(SRCU))
OBJS = $(patsubst $(PATHS)%.cpp,$(PATHB)%.o,$(SRCS))
OBJT = $(patsubst $(PATHT)%.cpp,$(PATHB)%.o,$(SRCT))
OBJ = $(OBJU) $(OBJS) $(OBJT)

#Other files we care about
DEP = $(PATHU)unity.h $(PATHU)unity_internals.h
TGT = $(PATHB)test$(TARGET_EXTENSION)

#Tool Definitions
CC=g++
CFLAGS=-I. -I$(PATHU) -I$(PATHI) -I$(PATHS) -DTEST

test: $(PATHB) $(TGT)
	echo "running tests"
	./$(TGT)

$(PATHB)%.o:: $(PATHS)%.cpp $(DEP)
	echo "source compiling"
	$(CC) -c $(CFLAGS) $< -o $@

$(PATHB)%.o:: $(PATHT)%.cpp $(DEP)
	echo "tests compiling"
	$(CC) -c $(CFLAGS) $< -o $@

$(PATHB)%.o:: $(PATHU)%.c $(DEP)
	echo "unity compiling"
	$(CC) -c $(CFLAGS) $< -o $@

$(TGT): $(OBJ)
	echo "linking"
	$(CC) -o $@ $^

.PHONY: test

