-- src/Utils.hs
module Utils where

-- Función para mostrar los mensajes de ayuda
mostrarAyuda :: IO ()
mostrarAyuda = do
    putStrLn "===== Instrucciones del juego ====="
    putStrLn "Cada jugador tiene un mortero con HP y combustible."
    putStrLn "Puedes mover el mortero usando las teclas a/d (Jugador 1) y < /> (Jugador 2)."
    putStrLn "Puedes disparar usando las teclas w (Jugador 1) y e (Jugador 2)."
    putStrLn "Cada disparo consume 3 unidades de combustible."
    putStrLn "El objetivo es reducir la HP del otro mortero a cero."
    putStrLn "Presiona q para salir."
    putStrLn "===================================="
