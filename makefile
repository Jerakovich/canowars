# Nombre del ejecutable
EXECUTABLE = canowars

# Archivos fuente (incluyendo los módulos mencionados)
SRC =  src/Juego.hs app/Main.hs

# Comando de compilación
GHC = ghc

# Flags de compilación
GHC_FLAGS = -Wall

# Objetivo por defecto: compilar y generar el ejecutable
all: $(EXECUTABLE)

# Regla para compilar el proyecto
$(EXECUTABLE): $(SRC)
	$(GHC) $(GHC_FLAGS) -o $(EXECUTABLE) $(SRC)

# Limpiar archivos generados
clean:
	rm -f $(EXECUTABLE) *.hi *.o

# Ejecutar el programa
run: $(EXECUTABLE)
	./$(EXECUTABLE)
