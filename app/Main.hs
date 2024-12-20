import Juego
import System.IO
import Text.Read (readMaybe)
import Control.Monad (when, foldM)
import Control.Concurrent (threadDelay)
import System.IO (hFlush, stdout)
import Data.Fixed (mod')
import System.Random (randomRIO)

main :: IO ()
main = do
    putStrLn "\n===== Bienvenido a CANOWARS ====="
    putStrLn "Configura la HP inicial de los morteros (mínimo 10 puntos)."

    putStr "HP de las Catapultas: "
    hFlush stdout
    hp1 <- leerHp
    let hp2 = hp1
    putStrLn "\nConfiguración completa. Comienza el juego!"
    inputLoopConHp 20 60 100 100 45 45 hp1 hp2 1

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
inputLoopConHp :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
-- pos1: posición del mortero 1
-- pos2: posición del mortero 2
-- fuel1: combustible del mortero 1
-- fuel2: combustible del mortero 2
-- angle1: grado de inclinación del mortero 1
-- angle2: grado de inclinación del mortero 2
-- hp1: HP del mortero 1
-- hp2: HP del mortero 2
-- turno: número de turno actual
inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 turno = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    mostrarCampo pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2
    
    -- Si ambos morteros tienen HP positivos, el juego continúa
    when (hp1 > 0 && hp2 > 0) $ do
        -- Mostrar acciones disponibles para el jugador actual
        if turno `mod` 2 == 1
            then do -- Turno del jugador 1
                putStrLn "\nElige una acción (Jugador 1):"
                putStrLn "(a: mover izquierda, d: mover derecha,  e: disparar)"
                char1 <- getChar
                case char1 of
                    -- Mover mortero 1 izquierda (gasta 5 de combustible, no permite combustible negativo)
                    'a' -> if fuel1 >= 5
                        then inputLoopConHp (max 0 (pos1 - 1)) pos2 (max 0 (fuel1 - 5)) fuel2 angle1 angle2 hp1 hp2 turno 
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 (turno + 1)
                    
                    -- Mover mortero 1 derecha (gasta 5 de combustible, no permite combustible negativo)
                    'd' -> if fuel1 >= 5
                        then inputLoopConHp (min 40 (pos1 + 1)) pos2 (max 0 (fuel1 - 5)) fuel2 angle1 angle2 hp1 hp2 turno 
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 (turno + 1)

                    -- Mover cañon hacia arriba (gasta 1 de combustible, no permite combustible negativo)
                    'w' -> if fuel1 >= 1
                        then inputLoopConHp pos1 pos2 (max 0 (fuel1 - 1)) fuel2 (min 90 (angle1 + 1)) angle2 hp1 hp2 turno
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 (turno + 1)
                    
                    -- Mover cañon hacia abajo (gasta 1 de combustible, no permite combustible negativo)
                    's' -> if fuel1 >= 1
                        then inputLoopConHp pos1 pos2 (max 0 (fuel1 - 1)) fuel2 (max 0 (angle1 - 1)) angle2 hp1 hp2 turno
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 (turno + 1)

                    -- Disparar mortero 1 (gasta 3 de combustible, no permite combustible negativo)
                    'e' -> if fuel1 >= 3 
                        then disparar1Main pos1 pos2 (max 0 (fuel1 - 3)) fuel2 angle1 angle2 hp1 hp2 (turno + 1)
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 (turno + 1)
                    
                    
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
                        then inputLoopConHp pos1 (max 41 (pos2 - 1)) fuel1 (max 0 (fuel2 - 5)) angle1 angle2 hp1 hp2 turno 
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 (turno + 1)
                    
                    -- Mover mortero 2 derecha (gasta 5 de combustible, no permite combustible negativo)
                    '6' -> if fuel2 >= 5
                        then inputLoopConHp pos1 (min 81 (pos2 + 1)) fuel1 (max 0 (fuel2 - 5)) angle1 angle2 hp1 hp2 turno 
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 (turno + 1)
                    -- Mover cañon hacia arriba (gasta 1 de combustible, no permite combustible negativo)
                    '8' -> if fuel2 >= 1
                        then inputLoopConHp pos1 pos2 fuel1 (max 0 (fuel2 - 1)) angle1 (min 90 (angle2 + 1)) hp1 hp2 turno
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 (turno + 1)
                    
                    -- Mover cañon hacia abajo (gasta 1 de combustible, no permite combustible negativo)
                    '5' -> if fuel2 >= 1
                        then inputLoopConHp pos1 pos2 fuel1 (max 0 (fuel2 - 1)) angle1 (max 0 (angle2 - 1)) hp1 hp2 turno
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 (turno + 1)

                    -- Disparar mortero 2 (gasta 3 de combustible, no permite combustible negativo)
                    '7' -> if fuel2 >= 3 
                        then disparar2Main pos1 pos2 fuel1 (max 0 (fuel2 - 3)) angle1 angle2 hp1 hp2 (turno + 1)
                        else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 (turno + 1)
                    
                    -- Salir del juego
                    'p' -> putStrLn "Juego terminado."

                    _   -> putStrLn "Jugador 2. Espera tu turno!"

        
        putStrLn "(p: salir)"

        -- Llamada recursiva para el siguiente turno, alternando entre los jugadores
        if fuel1 == 0 || fuel1 < 3
            then inputLoopConHp pos1 pos2 100 fuel2 angle1 angle2 hp1 hp2 0
            else if fuel2 == 0 || fuel2 < 3
                then inputLoopConHp pos1 pos2 fuel1 100 angle1 angle2 hp1 hp2 1
                else inputLoopConHp pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 turno
        

 




-- Función para disparar el primer mortero
disparar1Main :: Int -> Int -> Int -> Int -> Int -> Int-> Int -> Int -> Int -> IO ()
disparar1Main pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 turno = do
    putStrLn "\nJugador 1 dispara..."
    let angulo = fromIntegral angle1

    (hit, newHp2) <- animarDisparoParabolico pos1 pos2 pos1 pos2 hp2 angulo
    if hit
        then putStrLn "¡Impacto! Jugador 2 recibe daño."
        else putStrLn "¡Fallaste!"
    threadDelay 1000000  -- Pausa para mostrar el resultado
    inputLoopConHp pos1 pos2 100 100 angle1 angle2 hp1 newHp2 turno

-- Función para disparar el segundo mortero
disparar2Main :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int-> Int -> IO ()
disparar2Main pos1 pos2 fuel1 fuel2 angle1 angle2 hp1 hp2 turno = do
    putStrLn "\nJugador 2 dispara..."
    let angulo = fromIntegral angle2
    (hit, newHp1) <- animarDisparoParabolico pos2 pos1 pos1 pos2 hp1 angulo
    if hit
        then putStrLn "¡Impacto! Jugador 1 recibe daño."
        else putStrLn "¡Fallaste!"
    threadDelay 1000000  -- Pausa para mostrar el resultado
    inputLoopConHp pos1 pos2 100 100 angle1 angle2 newHp1 hp2 turno




-- Función para animar un disparo parabólico con ángulo
calcularDanio :: IO Int
calcularDanio = do
    critico <- randomRIO (1, 100) :: IO Int
    if critico <= 5
        then randomRIO (7, 9)  -- Daño crítico
        else randomRIO (1, 3)  -- Daño normal



animarDisparoParabolico :: Int -> Int -> Int -> Int -> Int -> Double -> IO (Bool, Int)
animarDisparoParabolico posInicial posObjetivo pos1 pos2 hpObjetivo angulo = do
    let radianes = angulo * pi / 180
        velocidadInicial = 20.0  -- Velocidad inicial
        g = 10  -- Gravedad

    -- Cálculo de distancia, dirección y tiempos
    let distancia = abs (posObjetivo - posInicial)
        direccion = if posObjetivo > posInicial then 1 else -1
        tiempoTotal = 2 * velocidadInicial * sin radianes / g
        numPasos = 20  -- Número de pasos para la animación
        deltaT = tiempoTotal / fromIntegral numPasos

    -- Animar la trayectoria parabólica del disparo
    hit <- foldM (\hit paso -> do
        let t = deltaT * fromIntegral paso
            x = posInicial + round (velocidadInicial * cos radianes * t) * direccion
            y = round (velocidadInicial * sin radianes * t - 0.5 * g * t^2)

        -- Limpiar pantalla y mostrar la posición de la bala
        clearScreen
        mostrarCampoConBala x y pos1 pos2
        threadDelay 100000  -- Pausa breve para la animación

        let toleranciaX = 2  -- Ajusta según el rango de impacto permitido
        let toleranciaY = 2  -- Ajusta según la altura aceptable para el impacto
        return (hit || (x >= posObjetivo - toleranciaX && x <= posObjetivo + toleranciaX && y <= toleranciaY))
        ) False [0..numPasos]

    return (hit, if hit then posInicial else posObjetivo)

    -- Aquí se hace el daño solo si hay un impacto
    if hit then do
        -- Cálculo de daño
        danio <- calcularDanio
        let nuevoHp = hpObjetivo - danio
        return (True, nuevoHp)
    else
        return (False, hpObjetivo)



-- Función para mostrar el campo con la bala
mostrarCampoConBala :: Int -> Int -> Int -> Int -> IO ()
mostrarCampoConBala x y pos1 pos2 = do
    putStrLn "Jugador 1 - HP: 100 | Combustible: 100"
    putStrLn "Jugador 2 - HP: 100 | Combustible: 100"
    putStrLn "___________________________________________________________________________________________________"
    let alturaCampo = 10
    mapM_ (mostrarLineaConBala x y pos1 pos2) [0..alturaCampo]
    putStrLn "|###################################################################################################|"




mostrarLineaConBala :: Int -> Int -> Int -> Int -> Int -> IO ()
mostrarLineaConBala x y pos1 pos2 fila
    | fila == (alturaCampo - y) = putStrLn $ "|" ++ replicate x ' ' ++ "*" ++ replicate (97 - x) ' ' ++ "|"
    | fila == 9 = putStrLn $ "|" ++ replicate pos1 ' ' ++ "0-¨°°¨-0" ++ replicate (40 - pos1) ' ' ++ "***" ++ replicate (pos2 - 41) ' ' ++ "0-¨°°¨-0" ++ replicate (81-pos2) ' ' ++ "|"
    | fila == 8 = putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate 48 ' ' ++"|"
    | fila == 7 = putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate 48 ' ' ++"|"
    | fila == 6 = putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate 48 ' ' ++"|"
    | fila == 5 = putStrLn $ "|" ++ replicate 48 ' ' ++ "***" ++ replicate 48 ' ' ++"|"
    | fila == 4 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | fila == 3 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | fila == 2 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | fila == 1 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | fila == 0 = putStrLn $ "|" ++ replicate 48 ' ' ++ "   " ++ replicate 48 ' ' ++"|"
    | otherwise = return()

  where
    alturaCampo = 10  -- Ajusta este valor si la altura del campo es diferente