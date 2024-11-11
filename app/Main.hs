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
    
    putStr "HP del Mortero 1: "
    hFlush stdout
    hp1 <- leerHp

    putStr "HP del Mortero 2: "
    hFlush stdout
    hp2 <- leerHp

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
inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 turno = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    mostrarCampo pos1 pos2 fuel1 fuel2 hp1 hp2
    when (hp1 > 0 && hp2 > 0) $ do
        if turno `mod` 2 == 1
            then do -- Turno del jugador 1
                putStrLn "\nElige una acción (Jugador 1):"
                putStrLn "(a: mover izquierda, d: mover derecha, w: disparar)"
            else do -- Turno del jugador 2
                putStrLn "\nElige una acción (Jugador 2):"
                putStrLn "(<: mover izquierda, >: mover derecha, e: disparar)"
        
        putStrLn "(q: salir)"
        char <- getChar
        case char of
            'a' -> inputLoopConHp (max 0 (pos1 - 1)) pos2 fuel1 fuel2 hp1 hp2 (turno + 1) -- Mover mortero 1
            'd' -> inputLoopConHp (min 40 (pos1 + 1)) pos2 fuel1 fuel2 hp1 hp2 (turno + 1) -- Mover mortero 1
            '<' -> inputLoopConHp pos1 (max 41 (pos2 - 1)) fuel1 fuel2 hp1 hp2 (turno + 1) -- Mover mortero 2
            '>' -> inputLoopConHp pos1 (min 80 (pos2 + 1)) fuel1 fuel2 hp1 hp2 (turno + 1) -- Mover mortero 2
            'w' -> if fuel1 >= 3 && turno `mod` 2 == 1 then disparar1Main pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1) else inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1)
            'e' -> if fuel2 >= 3 && turno `mod` 2 == 0 then disparar2Main pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1) else inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1)
            'q' -> putStrLn "Juego terminado."
            _   -> inputLoopConHp pos1 pos2 fuel1 fuel2 hp1 hp2 (turno + 1)

-- Función para leer y validar el ángulo de disparo
leerAngulo :: IO Double
leerAngulo = do
    putStr "Ingresa el ángulo de disparo (0-90 grados): "
    hFlush stdout
    input <- getLine
    let maybeAngulo = readMaybe input :: Maybe Double
    case maybeAngulo of
        Just angulo | angulo >= 0 && angulo <= 90 -> return angulo
        _ -> do
            putStrLn "El ángulo debe ser un número entre 0 y 90. Intenta nuevamente."
            leerAngulo

disparar1Main :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
disparar1Main pos1 pos2 fuel1 fuel2 hp1 hp2 turno = do
    let newFuel1 = fuel1 - 3
    putStrLn "\nJugador 1 dispara..."
    angulo <- leerAngulo
    (hit, newHp2) <- animarDisparoParabolico pos1 pos2 pos1 pos2 hp2 angulo
    if hit
        then putStrLn "¡Impacto! Jugador 2 recibe daño."
        else putStrLn "¡Fallaste!"
    threadDelay 1000000  -- Pausa para mostrar el resultado
    inputLoopConHp pos1 pos2 newFuel1 fuel2 hp1 newHp2 turno

disparar2Main :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> IO ()
disparar2Main pos1 pos2 fuel1 fuel2 hp1 hp2 turno = do
    let newFuel2 = fuel2 - 3
    putStrLn "\nJugador 2 dispara..."
    angulo <- leerAngulo
    (hit, newHp1) <- animarDisparoParabolico pos2 pos1 pos1 pos2 hp1 angulo
    if hit
        then putStrLn "¡Impacto! Jugador 1 recibe daño."
        else putStrLn "¡Fallaste!"
    threadDelay 1000000  -- Pausa para mostrar el resultado
    inputLoopConHp pos1 pos2 fuel1 newFuel2 newHp1 hp2 turno



-- Función para animar un disparo parabólico con ángulo
calcularDanio :: IO Int
calcularDanio = do
    critico <- randomRIO (1, 100) :: IO Int
    if critico <= 5
        then randomRIO (7, 9)  -- Daño crítico
        else randomRIO (1, 3)  -- Daño normal

animarDisparoParabolico :: Int -> Int -> Int -> Int -> Int -> Double -> IO (Bool, Int)
animarDisparoParabolico posInicial posObjetivo pos1 pos2 hpObjetivo angulo = do
    let distancia = abs (posObjetivo - posInicial)
        direccion = if posObjetivo > posInicial then 1 else -1
        pasos = [0..distancia]
        radianes = angulo * pi / 180
        velocidadInicial = 20.0  -- Ajusta este valor según sea necesario
        xObjetivo = posObjetivo
        yObjetivo = 9  -- Ajustar según la altura del objetivo
    hit <- foldM (\hit paso -> do
        let t = fromIntegral paso / fromIntegral (length pasos)
            x = posInicial + round (t * fromIntegral distancia * cos radianes) * direccion
            y = round $ t * velocidadInicial * sin radianes - 0.5 * 9.8 * t^2
        clearScreen
        mostrarCampoConBala x y pos1 pos2 -- Muestra la bala en la posición (x, y)
        threadDelay 100000                 -- Pausa para la animación
        return (hit || (x == xObjetivo && y == yObjetivo))
        ) False pasos
    clearScreen
    if hit
        then do
            danio <- calcularDanio
            let newHpObjetivo = hpObjetivo - danio
            putStrLn $ "¡Impacto! El objetivo recibe " ++ show danio ++ " puntos de daño."
            return (hit, newHpObjetivo)
        else return (hit, hpObjetivo)




-- Función para mostrar el campo con la bala
mostrarCampoConBala :: Int -> Int -> Int -> Int -> IO ()
mostrarCampoConBala x y pos1 pos2 = do
    putStrLn "Jugador 1 - HP: 100 | Combustible: 100"
    putStrLn "Jugador 2 - HP: 100 | Combustible: 100"
    putStrLn "___________________________________________________________________________________________________"
    let alturaCampo = 10
    mapM_ (mostrarLineaConBala x y pos1 pos2) [0..alturaCampo]
    putStrLn "|_________________________________________________________________________________________________|"

-- Muestra una línea del campo con la bala
mostrarLineaConBala :: Int -> Int -> Int -> Int -> Int -> IO ()
mostrarLineaConBala x y pos1 pos2 fila
    | fila == y = putStrLn $ "|" ++ replicate x ' ' ++ "*" ++ replicate (97 - x) ' ' ++ "|"
    | fila == 9 = putStrLn $ "|" ++ replicate pos1 ' ' ++ "0-¨°°¨-0" ++ replicate (pos2 - pos1 - 8) ' ' ++ "0-¨°°¨-0" ++ replicate (97 - pos2 - 8) ' ' ++ "|"
    | otherwise = putStrLn $ "|" ++ replicate 97 ' ' ++ "|"

simularDisparo :: Int -> Int -> Bool
simularDisparo posDisparo posObjetivo = posDisparo == posObjetivo
