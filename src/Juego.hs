-- src/Juego.hs
module Juego where

import System.IO
import Control.Concurrent

-- Mostrar el campo de batalla con los cañones y las barras de HP y combustible
mostrarCampo :: Int -> Int -> Int -> Int -> Int -> Int -> IO ()
mostrarCampo pos1 pos2 fuel1 fuel2 hp1 hp2 = do
    clearScreen
    -- Mostrar la barra de HP y combustible antes de las acciones
    putStrLn $ "Jugador 1 - HP: " ++ show hp1 ++ " | Combustible: " ++ show fuel1
    putStrLn $ "Jugador 2 - HP: " ++ show hp2 ++ " | Combustible: " ++ show fuel2
    putStrLn ""
    let alturaCampo = 10
    -- Mostrar la separación con asteriscos y el perímetro del tablero
    putStrLn "_____________________________________________________________________________________________________"
    -- Mostrar la visualización del campo de batalla (proyectiles, morteros)
    mapM_ (mostrarLinea pos1 pos2 fuel1 fuel2 hp1 hp2) [0..alturaCampo]
    putStrLn "|###################################################################################################|"

-- Mostrar cada línea del campo de batalla
mostrarLinea :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
mostrarLinea pos1 pos2 fuel1 fuel2 hp1 hp2 fila
    | fila == 9 = do
        -- Línea de cañones en la parte más baja
        putStrLn $ "|" ++ replicate pos1 ' ' ++ "0-¨°°¨-0" ++ replicate (40 - pos1) ' ' ++ "***" ++ replicate (pos2 - 41) ' ' ++ "0-¨°°¨-0" ++ replicate (81-pos2) ' ' ++ "|"
    | fila == 8 = putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate 48 ' ' ++"|"
    | fila == 7 = putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate 48 ' ' ++"|"
    | fila == 6 = putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate 48 ' ' ++"|"
    | fila == 5 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | fila == 4 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | fila == 3 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | fila == 2 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | fila == 1 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | fila == 0 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | otherwise = return ()

-- Limpiar la pantalla
clearScreen :: IO ()
clearScreen = putStr "\ESC[2J\ESC[H"
