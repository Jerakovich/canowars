-- app/Main.hs
import Juego
import System.IO
import Text.Read (readMaybe)
import Control.Monad (when)

main :: IO ()
main = do
    putStrLn "\n===== Bienvenido a CANOWARS ====="
    putStrLn "Configura la HP inicial de los morteros (mínimo 10 puntos)."

    putStr "HP de las Catapultas: "
    hFlush stdout
    hp1 <- leerHp
    let hp2 = hp1
    putStrLn "\nConfiguración completa. Comienza el juego!"
    inputLoopConHp 20 60 100 100 hp1 hp2 1

-- Función para leer y validar la HP del jugador
leerHp :: IO Int
leerHp = do
    input <- getLine
    let maybeHp = readMaybe input :: Maybe Int
    case maybeHp of
        Just hp | hp >= 10 -> return hp
        _ -> do
            putStrLn "La HP debe ser un número entero igual o mayor a 10. Intenta nuevamente."
            leerHp

-- Función que maneja el ciclo del juego por turnos
inputLoopConHp :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
-- pos1: posición del mortero 1
-- pos2: posición del mortero 2
-- fuel1: combustible del mortero 1
-- fuel2: combustible del mortero 2
-- angle1: grado de inclinación del mortero 1
-- angle2: grado de inclinación del mortero 2
-- hp1: HP del mortero 1
-- hp2: HP del mortero 2
-- turno: número de turno actual
inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 turno = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    mostrarCampo pos1 pos2 fuel1 fuel2 hp1 hp2
    
    -- Si ambos morteros tienen HP positivos, el juego continúa
    when (hp1 > 0 && hp2 > 0) $ do
        -- Mostrar acciones disponibles para el jugador actual
        if turno `mod` 2 == 1
            then do -- Turno del jugador 1
                putStrLn "\nElige una acción (Jugador 1):"
                putStrLn "(a: mover izquierda, d: mover derecha, e: disparar)"
                char1 <- getChar
                case char1 of
                    -- Mover mortero 1 izquierda (gasta 5 de combustible, no permite combustible negativo)
                    'a' -> if fuel1 >= 5
                        then inputLoopConHp (max 0 (pos1 - 1)) pos2 (max 0 (fuel1 - 5)) fuel2 hp1 hp2 turno 
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1)
                    
                    -- Mover mortero 1 derecha (gasta 5 de combustible, no permite combustible negativo)
                    'd' -> if fuel1 >= 5
                        then inputLoopConHp (min 40 (pos1 + 1)) pos2 (max 0 (fuel1 - 5)) fuel2 hp1 hp2 turno 
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1)
                    
                    -- Disparar mortero 1 (gasta 3 de combustible, no permite combustible negativo)
                    'e' -> if fuel1 >= 3 
                        then disparar1Main pos1 pos2 (max 0 (fuel1 - 3)) fuel2 hp1 hp2 (turno + 1)
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1)
                    
                    
                    -- Salir del juego
                    'p' -> putStrLn "Juego terminado."

                    _   -> putStrLn "Jugador 1. Espera tu turno!"
                    
            
            else do -- Turno del jugador 2
                putStrLn "\nElige una acción (Jugador 2):"
                putStrLn "(4: mover izquierda, 6: mover derecha, 9: disparar)"
                char2 <- getChar
                case char2 of
                    -- Mover mortero 2 izquierda (gasta 5 de combustible, no permite combustible negativo)
                    '4' -> if fuel2 >= 5
                        then inputLoopConHp pos1 (max 41 (pos2 - 1)) fuel1 (max 0 (fuel2 - 5)) hp1 hp2 turno 
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1)
                    
                    -- Mover mortero 2 derecha (gasta 5 de combustible, no permite combustible negativo)
                    '6' -> if fuel2 >= 5
                        then inputLoopConHp pos1 (min 81 (pos2 + 1)) fuel1 (max 0 (fuel2 - 5)) hp1 hp2 turno 
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1)

                    -- Disparar mortero 2 (gasta 3 de combustible, no permite combustible negativo)
                    '7' -> if fuel2 >= 3 
                        then disparar2Main pos1 pos2 fuel1 (max 0 (fuel2 - 3)) hp1 hp2 (turno + 1)
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1)
                    
                    -- Salir del juego
                    'p' -> putStrLn "Juego terminado."

                    _   -> putStrLn "Jugador 2. Espera tu turno!"

        
        putStrLn "(p: salir)"

        -- Llamada recursiva para el siguiente turno, alternando entre los jugadores
        if fuel1 == 0 || fuel1 < 3
            then inputLoopConHp pos1 pos2 100 fuel2 hp1 hp2 0
            else if fuel2 == 0 || fuel2 < 3
                then inputLoopConHp pos1 pos2 fuel1 100 hp1 hp2 1
                else inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 turno
        

 
-- Función para disparar el primer mortero
disparar1Main :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
disparar1Main pos1 pos2 fuel1 fuel2 hp1 hp2 turno = do
    let newFuel1 = fuel1 - 3
    let newHp2 = if pos1 == pos2 then hp2 - 10 else hp2
    inputLoopConHp pos1 pos2 newFuel1 fuel2 hp1 newHp2 turno

-- Función para disparar el segundo mortero
disparar2Main :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
disparar2Main pos1 pos2 fuel1 fuel2 hp1 hp2 turno = do
    let newHp1 = if pos1 == pos2 then hp1 - 10 else hp1
    inputLoopConHp pos1 pos2 100 100 newHp1 hp2 turno
