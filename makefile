# Makefile for Canowars project

# Compiler
HC = ghc

# Directories
SRC_DIR = src
APP_DIR = app

# Source files
SRC_FILES = $(SRC_DIR)/juego.hs
APP_FILES = $(APP_DIR)/main.hs

# Output binary
TARGET = canowars

# Default target
all: $(TARGET)

# Build the target
$(TARGET): $(SRC_FILES) $(APP_FILES)
	$(HC) -o $(TARGET) $(APP_FILES) $(SRC_FILES)

# Clean up build artifacts
clean:
	rm -f $(TARGET) $(SRC_DIR)/*.hi $(SRC_DIR)/*.o $(APP_DIR)/*.hi $(APP_DIR)/*.o

.PHONY: all clean