module Juego where

import System.IO
import Control.Concurrent
import Control.Monad (when)

-- Mostrar el cañón en la posición indicada
mostrarCanon :: Int -> IO ()
mostrarCanon pos = putStrLn $ replicate pos ' ' ++ "0-¨°°¨-0"

-- Mostrar el campo de batalla con el cañón, disparo y muro
mostrarCampo :: Int -> Int -> Maybe (Int, Int) -> Maybe (Int, Int) -> IO ()
mostrarCampo canonPos1 canonPos2 mbDisparo1 mbDisparo2 = do
    clearScreen
    let alturaCampo = 20
    mapM_ (mostrarLinea canonPos1 canonPos2 mbDisparo1 mbDisparo2) [0..alturaCampo]
  where
    -- Dibujar el muro en el centro de la pantalla (columna 40)
    mostrarLinea canonPos1 canonPos2 (Just (x, y)) (Just (a, b)) fila
        | fila == y = putStrLn $ replicate x ' ' ++ "*" ++ replicate (40 - x - 1) ' ' ++ replicate a ' ' ++ "*" -- Mostrar la bala en (x, y)
        | fila == 20 = putStrLn $ replicate canonPos1 ' ' ++ "0-¨°°¨-0" ++ replicate (40 - canonPos1 - 1) ' ' ++ replicate canonPos2 ' ' ++ "0-¨°°¨-0" -- Mostrar los cañones
        | otherwise = putStrLn $ replicate 80  ' ' ++ "#"  -- Muro en la columna 40

    mostrarLinea canonPos1 canonPos2 Nothing (Just (a, b)) fila
        | fila == b = putStrLn $ replicate a ' ' ++ "*" ++ replicate 39 ' ' ++ "#" -- Mostrar la bala del segundo mortero
        | fila == 20 = putStrLn $ replicate canonPos1 ' ' ++ "0-¨°°¨-0" ++ replicate (40 - canonPos1 - 1) ' ' ++ replicate canonPos2 ' ' ++ "0-¨°°¨-0" -- Mostrar los cañones
        | otherwise = putStrLn $ replicate 80 ' ' ++ "#"  -- Muro en la columna 40

    mostrarLinea canonPos1 canonPos2 (Just (x, y)) Nothing fila
        | fila == y = putStrLn $ replicate x ' ' ++ "*" ++ replicate (40 - x - 1) ' ' -- Mostrar la bala del primer mortero
        | fila == 20 = putStrLn $ replicate canonPos1 ' ' ++ "0-¨°°¨-0" ++ replicate (40 - canonPos1 - 1) ' ' ++ replicate canonPos2 ' ' ++ "0-¨°°¨-0" -- Mostrar los cañones
        | otherwise = putStrLn $ replicate 80 ' ' ++ "#"  -- Muro en la columna 40

    mostrarLinea canonPos1 canonPos2 Nothing Nothing fila
        | fila == 20 = putStrLn $ replicate canonPos1 ' ' ++ "0-¨°°¨-0" ++ replicate (40 - canonPos1 - 1) ' ' ++ replicate canonPos2 ' ' ++ "0-¨°°¨-0" -- Mostrar los cañones
        | otherwise = putStrLn $ replicate 80 ' ' ++ "#"  -- Muro en la columna 40

-- Limpiar la pantalla
clearScreen :: IO ()
clearScreen = putStr "\ESC[2J"
-- hola
-- Escuchar en tiempo real para mover los cañones
escucharEnTiempoReal :: Int -> Int -> IO ()
escucharEnTiempoReal pos1 pos2 = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    mostrarCampo pos1 pos2 Nothing Nothing
    inputLoop pos1 pos2 Nothing Nothing

inputLoop :: Int -> Int -> Maybe (Int, Int) -> Maybe (Int, Int) -> IO ()
inputLoop pos1 pos2 mbDisparo1 mbDisparo2 = do
    threadDelay 100000 -- Controla la velocidad de actualización
    inputAvailable <- hReady stdin
    if inputAvailable
        then do
            char <- getChar
            case char of
                'a' -> actualizarPos1 (max 0 (pos1 - 1)) mbDisparo1 mbDisparo2 -- Mover el primer mortero
                'd' -> actualizarPos1 (min 40 (pos1 + 1)) mbDisparo1 mbDisparo2 -- Limita posición máxima para el primer mortero
                '<' -> actualizarPos2 (max 41 (pos2 - 1)) mbDisparo1 mbDisparo2 -- Mover el segundo mortero a la izquierda
                '>' -> actualizarPos2 (min 80 (pos2 + 1)) mbDisparo1 mbDisparo2 -- Mover el segundo mortero a la derecha
                'w' -> if mbDisparo1 == Nothing 
                          then disparar1 pos1 pos2
                          else inputLoop pos1 pos2 mbDisparo1 mbDisparo2
                'e' -> if mbDisparo2 == Nothing
                          then disparar2 pos1 pos2
                          else inputLoop pos1 pos2 mbDisparo1 mbDisparo2
                'q' -> putStrLn "Juego terminado."
                _   -> inputLoop pos1 pos2 mbDisparo1 mbDisparo2
        else moverDisparo1 pos1 pos2 mbDisparo1 >> moverDisparo2 pos1 pos2 mbDisparo2

  where
    -- Actualizar posición del primer mortero
    actualizarPos1 newPos mbDisparo1 mbDisparo2 = do
        mostrarCampo newPos pos2 mbDisparo1 mbDisparo2
        inputLoop newPos pos2 mbDisparo1 mbDisparo2
    
    -- Actualizar posición del segundo mortero
    actualizarPos2 newPos mbDisparo1 mbDisparo2 = do
        mostrarCampo pos1 newPos mbDisparo1 mbDisparo2
        inputLoop pos1 newPos mbDisparo1 mbDisparo2

-- Función para disparar del primer mortero
disparar1 :: Int -> Int -> IO ()
disparar1 canonPos1 canonPos2 = inputLoop canonPos1 canonPos2 (Just (canonPos1 + 4, 18)) Nothing

-- Función para disparar del segundo mortero
disparar2 :: Int -> Int -> IO ()
disparar2 canonPos1 canonPos2 = inputLoop canonPos1 canonPos2 Nothing (Just (canonPos2 + 4, 18))

-- Mover el disparo en una trayectoria parabólica
moverDisparo1 :: Int -> Int -> Maybe (Int, Int) -> IO ()
moverDisparo1 canonPos1 canonPos2 Nothing = inputLoop canonPos1 canonPos2 Nothing Nothing
moverDisparo1 canonPos1 canonPos2 (Just (x, y))
    | y <= 0 = inputLoop canonPos1 canonPos2 Nothing Nothing -- El disparo "desaparece" al llegar al suelo
    | otherwise = do
        let newX = x + 1
            newY = max 0 (y - 1)
        mostrarCampo canonPos1 canonPos2 (Just (newX, newY)) Nothing
        inputLoop canonPos1 canonPos2 (Just (newX, newY)) Nothing

moverDisparo2 :: Int -> Int -> Maybe (Int, Int) -> IO ()
moverDisparo2 canonPos1 canonPos2 Nothing = inputLoop canonPos1 canonPos2 Nothing Nothing
moverDisparo2 canonPos1 canonPos2 (Just (x, y))
    | y <= 0 = inputLoop canonPos1 canonPos2 Nothing Nothing -- El disparo "desaparece" al llegar al suelo
    | otherwise = do
        let newX = x + 1
            newY = max 0 (y - 1)
        mostrarCampo canonPos1 canonPos2 Nothing (Just (newX, newY))
        inputLoop canonPos1 canonPos2 Nothing (Just (newX, newY))
