import Juego
import System.IO
import Text.Read (readMaybe)
import Control.Monad (when)

main :: IO ()
main = do
    putStrLn "\n===== Bienvenido a CANOWARS ====="
    putStrLn "La HP inicial de los morteros es 15 puntos."
    
    let hp1 = 15
    let hp2 = 15

    putStrLn "\nConfiguración completa. Comienza el juego!"
    inputLoopConHp 0 10 Nothing Nothing hp1 hp2

-- Función que maneja la entrada del juego y el flujo en tiempo real
inputLoopConHp :: Int -> Int -> Maybe (Int, Int) -> Maybe (Int, Int) -> Int -> Int -> IO ()
inputLoopConHp pos1 pos2 mbDisparo1 mbDisparo2 hp1 hp2 = do
    hSetBuffering stdin NoBuffering
    hSetEcho stdin False
    mostrarCampo pos1 pos2 mbDisparo1 mbDisparo2
    when (hp1 > 0 && hp2 > 0) $ do
        putStrLn "\nElige una acción (a: mover mortero 1, d: mover mortero 1, < : mover mortero 2, >: mover mortero 2, w: disparar mortero 1, e: disparar mortero 2, q: salir): "
        char <- getChar  -- Espera la entrada del usuario
        case char of
            'a' -> inputLoopConHp (max 0 (pos1 - 1)) pos2 mbDisparo1 mbDisparo2 hp1 hp2 -- Mover el primer mortero
            'd' -> inputLoopConHp (min 40 (pos1 + 1)) pos2 mbDisparo1 mbDisparo2 hp1 hp2 -- Mover el primer mortero
            'j' -> inputLoopConHp pos1 (max 41 (pos2 - 1)) mbDisparo1 mbDisparo2 hp1 hp2 -- Mover el segundo mortero
            'l' -> inputLoopConHp pos1 (min 80 (pos2 + 1)) mbDisparo1 mbDisparo2 hp1 hp2 -- Mover el segundo mortero
            'w' -> if mbDisparo1 == Nothing 
                      then disparar1Main pos1 pos2 hp1 hp2
                      else inputLoopConHp pos1 pos2 mbDisparo1 mbDisparo2 hp1 hp2
            'i' -> if mbDisparo2 == Nothing
                      then disparar2Main pos1 pos2 hp1 hp2
                      else inputLoopConHp pos1 pos2 mbDisparo1 mbDisparo2 hp1 hp2
            'q' -> putStrLn "Juego terminado."
            _   -> inputLoopConHp pos1 pos2 mbDisparo1 mbDisparo2 hp1 hp2  -- Si la tecla no es válida, vuelve a mostrar el menú

-- Función para disparar el primer mortero
disparar1Main :: Int -> Int -> Int -> Int -> IO ()
disparar1Main canonPos1 canonPos2 hp1 hp2 = inputLoopConHp canonPos1 canonPos2 (Just (canonPos1 + 4, 18)) Nothing hp1 hp2

-- Función para disparar el segundo mortero
disparar2Main :: Int -> Int -> Int -> Int -> IO ()
disparar2Main canonPos1 canonPos2 hp1 hp2 = inputLoopConHp canonPos1 canonPos2 Nothing (Just (canonPos2 + 4, 18)) hp1 hp2