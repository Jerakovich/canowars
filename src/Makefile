# Nombre del ejecutable
TARGET = juego

# Archivos fuente
SOURCES = Main.hs Canon.hs Disparo.hs Juego.hs

# Directorio de compilación
BUILD_DIR = build

# Archivos compilados (object y interface files)
O_FILES = $(SOURCES:%.hs=$(BUILD_DIR)/%.o)
HI_FILES = $(SOURCES:%.hs=$(BUILD_DIR)/%.hi)

# Compilación
all: $(TARGET)

$(TARGET): $(O_FILES)
	ghc -o $(TARGET) $(O_FILES)

# Regla para compilar .hs a .o y .hi en el directorio build
$(BUILD_DIR)/%.o: %.hs
	ghc -c $< -o $@

$(BUILD_DIR)/%.hi: %.hs
	ghc -c $< -o $@

# Limpiar los archivos generados
clean:
	rm -f $(TARGET) $(BUILD_DIR)/*.hi $(BUILD_DIR)/*.o
