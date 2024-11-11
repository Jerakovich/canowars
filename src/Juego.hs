-- src/Juego.hs
module Juego where

import System.IO
import Control.Concurrent

-- Mostrar el campo de batalla con los cañones y las barras de HP y combustible
mostrarCampo :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
mostrarCampo pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 = do
    clearScreen
    -- Mostrar la barra de HP y combustible antes de las acciones
    putStrLn $ "Jugador 1 - HP: " ++ show hp1 ++ " | Combustible: " ++ show fuel1 ++ " | Ángulo: " ++ show angle1 ++ "°"
    putStrLn $ "Jugador 2 - HP: " ++ show hp2 ++ " | Combustible: " ++ show fuel2 ++ " | Ángulo: " ++ show angle2 ++ "°"
    putStrLn ""
    let alturaCampo = 10
    -- Mostrar la separación con asteriscos y el perímetro del tablero
    putStrLn "_____________________________________________________________________________________________________"
    -- Mostrar la visualización del campo de batalla (proyectiles, morteros)
    mapM_ (mostrarLinea pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2) [0..alturaCampo]
    putStrLn "|###################################################################################################|"

-- Mostrar cada línea del campo de batalla
mostrarLinea :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
mostrarLinea pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 fila
    
    | fila == 9 = do
        -- Línea de cañones en la parte más baja
        putStrLn $ "|" ++ replicate pos1 ' ' ++ "0-¨°°¨-0" ++ replicate (40 - pos1) ' ' ++ "***" ++ replicate (pos2 - 41) ' ' ++ "0-¨°°¨-0" ++ replicate (81-pos2) ' ' ++ "|"
    | fila == 8 =
        if angle1 == 0 && angle2 == 0 then -- Listo
            putStrLn $ "|" ++ replicate (pos1 + 3) ' ' ++ "____"  ++ replicate (41 - pos1) ' ' ++ "***" ++ replicate (pos2 - 40) ' ' ++ "____" ++ replicate (84-pos2) ' ' ++ "|"
        
        else if angle1 == 90 && angle2 == 90 then --Listo
            putStrLn $ "|" ++ replicate (pos1 + 2) ' ' ++ " |"  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ " |" ++ replicate (83-pos2) ' ' ++ "|"
        
        else if angle1 == 0 && angle2 == 90 then --
            putStrLn $ "|" ++ replicate (pos1 + 3) ' ' ++ "____"  ++ replicate (41 - pos1) ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ " |" ++ replicate (83-pos2) ' ' ++ "|"
        
        else if angle1 == 90 && angle2 == 0 then -- 
            putStrLn $ "|" ++ replicate (pos1 + 2) ' ' ++ " |"  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate (pos2 - 40) ' ' ++ "____" ++ replicate (84-pos2) ' ' ++ "|"

        else if angle1 == 0 then --Listo
            putStrLn $ "|" ++ replicate (pos1 + 3) ' ' ++ "____"  ++ replicate (41 - pos1) ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ combineAngle2 angle2 ++ replicate (84-pos2) ' ' ++ "|"
       
        else if angle2 == 0 then -- Listo
            putStrLn $ "|" ++ replicate (pos1 + 3) ' ' ++ combineAngle1 angle1  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate (pos2 - 40) ' ' ++ "____" ++ replicate (84-pos2) ' ' ++ "|"

        else if angle1 == 90 then -- Listo
           putStrLn $ "|" ++ replicate (pos1 + 2) ' ' ++ " |"  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ combineAngle2 angle2 ++ replicate (84-pos2) ' ' ++ "|"
       
       else if angle2 == 90 then -- Listo
           putStrLn $ "|" ++ replicate (pos1 + 3) ' ' ++ combineAngle1 angle1  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ " |" ++ replicate (83-pos2) ' ' ++ "|"

        else  
            putStrLn $ "|" ++ replicate (pos1 + 3) ' ' ++ combineAngle1 angle1  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ combineAngle2 angle2 ++ replicate (84-pos2) ' ' ++ "|"
            
    | fila == 7 = 
        if angle1 == 0 && angle2 == 0 then -- Listo
            putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate 48 ' ' ++"|"
        
        else if angle1 == 90 && angle2 == 90 then --Listo
            putStrLn $ "|" ++ replicate (pos1 + 2) ' ' ++ " |"  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ " |" ++ replicate (83-pos2) ' ' ++ "|"
        
        else if angle1 == 0 && angle2 == 90 then -- Listo
            putStrLn $ "|" ++ replicate 48 ' '  ++ "***" ++ replicate (pos2 - 37) ' ' ++ " |" ++ replicate (83-pos2) ' ' ++ "|"

        else if angle1 == 90 && angle2 == 0 then -- Listo
            putStrLn $ "|" ++ replicate (pos1 + 2) ' ' ++ " |"  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate 48 ' ' ++ "|"

        else if angle1 == 0 then --
            putStrLn $ "|" ++  replicate 48 ' ' ++ "***" ++ replicate (pos2 - 38) ' ' ++ combineAngle2 angle2 ++ replicate (85-pos2) ' ' ++ "|"
    
        else if angle2 == 0 then -- Listo
            putStrLn $ "|" ++ replicate (pos1 + 4) ' ' ++ combineAngle1 angle1  ++ replicate (43 - pos1) ' ' ++ "***" ++ replicate 48 ' ' ++ "|"

        else if angle1 == 90 then -- 
            putStrLn $ "|" ++ replicate (pos1 + 2) ' ' ++ " |"  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate (pos2 - 38) ' ' ++ combineAngle2 angle2 ++ replicate (85-pos2) ' ' ++ "|"
    
         else if angle2 == 90 then -- 
            putStrLn $ "|" ++ replicate (pos1 + 4) ' ' ++ combineAngle1 angle1  ++ replicate (43 - pos1) ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ " |" ++ replicate (83-pos2) ' ' ++ "|"

        else  
            putStrLn $ "|" ++ replicate (pos1 + 4) ' ' ++ combineAngle1 angle1  ++ replicate (43 - pos1) ' ' ++ "***" ++ replicate (pos2 - 38) ' ' ++ combineAngle2 angle2 ++ replicate (85-pos2) ' ' ++ "|"

    | fila == 6 = 
        if angle1 == 0 && angle2 == 0 then -- Listo
            putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate 48 ' ' ++"|"
        
        else if angle1 == 90 && angle2 == 90 then --Listo
            putStrLn $ "|" ++ replicate (pos1 + 2) ' ' ++ " |"  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ " |" ++ replicate (83-pos2) ' ' ++ "|"
        
        else if angle1 == 0 && angle2 == 90 then -- Listo
            putStrLn $ "|" ++ replicate 48 ' '  ++ "***" ++ replicate (pos2 - 37) ' ' ++ " |" ++ replicate (83-pos2) ' ' ++ "|"

        else if angle1 == 90 && angle2 == 0 then -- Listo
            putStrLn $ "|" ++ replicate (pos1 + 2) ' ' ++ " |"  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate 48 ' ' ++ "|"
        
        else if angle1 == 90 && angle2 < 45  then -- 
            putStrLn $ "|" ++ replicate (pos1 + 2) ' ' ++ " |"  ++ replicate (44 - pos1) ' ' ++ "***" ++ replicate 48 ' ' ++ "|"

        else if angle2 == 90  && angle1 < 45 then -- 
            putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ " |" ++ replicate (83-pos2) ' ' ++ "|"

        else if angle2 == 90 then
            putStrLn $ "|" ++ replicate (pos1 + 5) ' ' ++ combineAngle1 angle1  ++ replicate (42 - pos1) ' ' ++ "***" ++ replicate (pos2 - 37) ' ' ++ " |" ++ replicate (83-pos2) ' ' ++ "|"
        
        else if angle1 > 45 && angle2 > 45 then --Listo
            putStrLn $ "|" ++ replicate (pos1 + 5) ' ' ++ "/"  ++ replicate (42 - pos1) ' ' ++ "***" ++ replicate (pos2 - 39) ' ' ++ "\\" ++ replicate (86-pos2) ' ' ++ "|"
        else if angle1 > 45 then
            putStrLn $ "|" ++ replicate (pos1 + 5) ' ' ++ "/"  ++ replicate (42 - pos1) ' ' ++ "***" ++ replicate 48 ' ' ++ "|"
        else if angle2 > 45 then
            putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate (pos2 - 39) ' ' ++ combineAngle2 angle2 ++ replicate (86-pos2) ' ' ++ "|"
        else
            putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate 48 ' ' ++"|"

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

combineAngle2 :: Int -> String
combineAngle2 angle2
    | angle2 < 45 && angle2 > 0 = "\\"
    | angle2 >= 45 && angle2 < 90 = "\\"
    | angle2 == 90 = "|"
    | otherwise = ""

combineAngle1 :: Int -> String
combineAngle1 angle1
    | angle1 < 45 && angle1 > 0 = "/"
    | angle1 >= 45 && angle1 < 90 = "/"
    | angle1 == 90 = "|"
    | otherwise = ""
