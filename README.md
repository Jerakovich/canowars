
# CANOWARS

Bienvenido a **CANOWARS**, un juego de combate estratégico entre dos jugadores donde cada uno controla un mortero. El objetivo es reducir la HP del otro mortero a cero, utilizando habilidades de movimiento y disparo, ¡todo mientras gestionas tu combustible!

## Estructura del Proyecto

La estructura del proyecto es la siguiente:

```
CANOWARS/
├── app/
│   └── Main.hs        # Archivo principal que inicia el juego y maneja la lógica de turnos
├── bin/               # Carpeta para los archivos de compilación intermedios (.hi, .o)
├── src/
│   ├── Juego.hs       # Lógica del juego, incluida la visualización del campo de batalla y el estado
│   └── Utils.hs       # Funciones de utilidad para mostrar ayuda y otros mensajes
├── Makefile           # Script de construcción para compilar el juego
└── README.md          # Documentación del proyecto
```

### Archivos

- **app/Main.hs**: Contiene la lógica de inicio del juego y gestiona el ciclo de turnos. Permite a los jugadores ingresar comandos para moverse y disparar, gestionando el combustible y la HP de cada mortero.
- **src/Juego.hs**: Define funciones para mostrar el campo de batalla, renderizar los morteros y mostrar barras de HP y combustible.
- **src/Utils.hs**: Incluye funciones auxiliares como la visualización de instrucciones del juego.

## Requisitos Previos

Para ejecutar este proyecto, necesitas:

- [GHC (Glasgow Haskell Compiler)](https://www.haskell.org/ghc/) para compilar el código.
- Opcional: Make (para compilar el proyecto con el archivo `Makefile`).

## Cómo Jugar

1. Compila el proyecto utilizando el Makefile:

    ```bash
    make
    ```

2. Ejecuta el juego:

    ```bash
    ./canowars
    ```

3. Sigue las instrucciones en pantalla para mover los morteros y disparar.

   - **Jugador 1**:
     - Mover izquierda: `a`
     - Mover derecha: `d`
     - Disparar: `e`
   - **Jugador 2**:
     - Mover izquierda: `4`
     - Mover derecha: `6`
     - Disparar: `9`

4. El objetivo es reducir la HP del otro mortero a cero.

### Teclas Especiales

- `p`: Salir del juego.

## Instrucciones de Compilación

Este proyecto incluye un `Makefile` para facilitar la compilación.

### Comandos Disponibles en el Makefile

- `make` o `make all`: Compila el juego y genera el ejecutable `canowars` en el directorio raíz.

- `make clean_bin`: Limpia únicamente el contenido de la carpeta `bin`.

## Créditos

Sebastian Pangue - [sebastian.pangue@alumnos.uach.cl](mailto:sebastian.pangue@alumnos.uach.cl)
Jeral Ojeda - [jeral.ojeda@alumnos.uach.cl](mailto:jeral.ojeda@alumnos.uach.cl)
Luis Olivares - [luis.olivares@alumnos.uach.cl](mailto:luis.olivares@alumnos.uach.cl)
Eduardo Leal - [eduardo.leal@alumnos.uach.cl](mailto:eduardo.leal@alumnos.uach.cl)

