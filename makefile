# Makefile for Canowars project

# Compiler
HC = ghc

# Directories
SRC_DIR = src
APP_DIR = app
BIN_DIR = bin

# Source files
SRC_FILES = $(SRC_DIR)/juego.hs
SRC_CATAPULTA = $(SRC_DIR)/catapulta.hs
SRC_ESCENARIO = $(SRC_DIR)/escenario.hs
APP_FILES = $(APP_DIR)/main.hs

# Output binary
TARGET = canowars

# Default target
all: $(TARGET)

# Build the target
$(TARGET): $(SRC_FILES) $(SRC_SRC_ESCENARIO) $(SRC_CATAPULTA) $(APP_FILES)
	$(HC) -o $(TARGET) -outputdir $(BIN_DIR) -hidir $(BIN_DIR) -package random $(SRC_ESCENARIO) $(SRC_CATAPULTA) $(APP_FILES) $(SRC_FILES)

# Clean up build artifacts
clean:
	rm -f $(TARGET) $(BIN_DIR)/*.hi $(BIN_DIR)/*.o

.PHONY: all clean