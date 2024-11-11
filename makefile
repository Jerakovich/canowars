# Compiler
HC = ghc

# Directories
SRC_DIR = src
APP_DIR = app
BIN_DIR = bin

# Source files
SRC_FILES = $(SRC_DIR)/Juego.hs
SRC_UTILS = $(SRC_DIR)/Utils.hs
APP_FILES = $(APP_DIR)/Main.hs

# Output binary
TARGET = canowars

# Default target
all: clean $(TARGET)

# Build the target
$(TARGET): $(SRC_FILES) $(SRC_UTILS) $(APP_FILES)
	$(HC) -o $(TARGET) -outputdir $(BIN_DIR) -hidir $(BIN_DIR) -package random $(SRC_UTILS) $(APP_FILES) $(SRC_FILES)

# Clean up build artifacts
clean:
	rm -f $(TARGET) $(BIN_DIR)/*.hi $(BIN_DIR)/*.o

.PHONY: all clean
