module Escenario where

-- Definimos el tamaño del escenario
anchoEscenario :: Int
anchoEscenario = 52

altoEscenario :: Int
altoEscenario = 30

-- Posición de la línea al medio
lineaMedio :: Int
lineaMedio = 26

-- Posiciones iniciales de las catapultas
posicionCatapulta1 :: Int
posicionCatapulta1 = 16

posicionCatapulta2 :: Int
posicionCatapulta2 = 39

-- Función para verificar si una catapulta está en una posición válida
posicionValida :: Int -> Bool
posicionValida pos = pos >= 0 && pos < anchoEscenario

-- Función para mover una catapulta
moverCatapulta :: Int -> Int -> Int
moverCatapulta pos movimiento
    | nuevaPosicion < 0 = 0
    | nuevaPosicion >= anchoEscenario = anchoEscenario - 1
    | otherwise = nuevaPosicion
    where
        nuevaPosicion = pos + movimiento

-- Función para verificar si una catapulta puede moverse
puedeMoverse :: Int -> Int -> Bool
puedeMoverse pos movimiento
    | pos < lineaMedio && nuevaPosicion >= lineaMedio = False
    | pos >= lineaMedio && nuevaPosicion < lineaMedio = False
    | otherwise = posicionValida nuevaPosicion
    where
        nuevaPosicion = pos + movimiento