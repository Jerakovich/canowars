module Catapulta where
import System.Random (randomRIO)

data Catapulta = Catapulta {
    posicionX :: Float,
    posicionY :: Float,
    angulo :: Float,
    potencia :: Float,
    vida :: Int,
    combustible :: Int
} deriving (Show, Eq)

-- Función para crear una nueva catapulta
nuevaCatapulta :: Float -> Float -> Float -> Float -> Catapulta
nuevaCatapulta x y ang pot = Catapulta {
    posicionX = x,
    posicionY = y,
    angulo = ang,
    potencia = pot,
    vida = 30,
    combustible = 100
}

-- Función para disparar la catapulta
disparar :: Catapulta -> (Float, Float)
disparar catapulta = (alcance, altura)
  where
    g = 9.81 -- Aceleración debido a la gravedad
    radianes = angulo catapulta * pi / 180
    alcance = (potencia catapulta ^ 2 * sin (2 * radianes)) / g
    altura = (potencia catapulta ^ 2 * (sin radianes ^ 2)) / (2 * g)


-- Función para calcular el daño del disparo
calcularDanio :: IO Int
calcularDanio = do
    critico <- randomRIO (1, 100) :: IO Int
    if critico <= 5
        then randomRIO (7, 9)
        else randomRIO (1, 3)