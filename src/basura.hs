import System.IO
import Control.Concurrent
import Control.Monad (when)

-- Mostrar el cañón en la posición indicada
mostrarCanon :: Int -> IO ()
mostrarCanon pos = putStrLn $ replicate pos ' ' ++ "0-¨°°¨-0"

-- Mostrar el campo de batalla con el cañón y el disparo
mostrarCampo :: Int -> Maybe (Int, Int) -> IO ()
mostrarCampo canonPos mbDisparo = do
    clearScreen
    let alturaCampo = 20
    mapM_ (mostrarLinea canonPos mbDisparo) [0..alturaCampo]
  where
    mostrarLinea canonPos (Just (x, y)) fila
        | fila == y = putStrLn $ replicate x ' ' ++ "*" -- Mostrar la bala en (x, y)
        | fila == 20 = putStrLn $ replicate canonPos ' ' ++ "0-¨°°¨-0" -- Mostrar el cañón
        | otherwise = putStrLn ""
    mostrarLinea canonPos Nothing fila
        | fila == 20 = putStrLn $ replicate canonPos ' ' ++ "0-¨°°¨-0" -- Mostrar el cañón
        | otherwise = putStrLn ""

-- Limpiar la pantalla
clearScreen :: IO ()
clearScreen = putStr "\ESC[2J"

-- Escuchar en tiempo real para mover el cañón
escucharEnTiempoReal :: Int -> IO ()
escucharEnTiempoReal pos = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    mostrarCampo pos Nothing
    inputLoop pos Nothing

inputLoop :: Int -> Maybe (Int, Int) -> IO ()
inputLoop pos mbDisparo = do
    threadDelay 100000 -- Controla la velocidad de actualización
    inputAvailable <- hReady stdin
    if inputAvailable
        then do
            char <- getChar
            case char of
                'a' -> actualizarPos (max 0 (pos - 1)) mbDisparo
                'd' -> actualizarPos (min 80 (pos + 1)) mbDisparo -- Limita posición máxima
                'w' -> if mbDisparo == Nothing 
                          then disparar pos
                          else inputLoop pos mbDisparo
                'q' -> putStrLn "Juego terminado."
                _   -> inputLoop pos mbDisparo
        else moverDisparo pos mbDisparo
  where
    actualizarPos newPos mbPos = do
        mostrarCampo newPos mbPos
        inputLoop newPos mbPos

-- Función para disparar (inicia la trayectoria parabólica)
disparar :: Int -> IO ()
disparar canonPos = inputLoop canonPos (Just (canonPos + 4, 18))

-- Mover el disparo en una trayectoria parabólica
moverDisparo :: Int -> Maybe (Int, Int) -> IO ()
moverDisparo canonPos Nothing = inputLoop canonPos Nothing
moverDisparo canonPos (Just (x, y))
    | y <= 0 = inputLoop canonPos Nothing -- El disparo "desaparece" al llegar al suelo
    | otherwise = do
        let newX = x + 1
            newY = max 0 (y - 1) -- Movimiento parabólico básico (puedes ajustar para más realismo)
        mostrarCampo canonPos (Just (newX, newY))
        inputLoop canonPos (Just (newX, newY))

main :: IO ()
main = escucharEnTiempoReal 10
