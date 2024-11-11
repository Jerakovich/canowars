-- src/Utils.hs
module Utils where

-- Función para mostrar los mensajes de ayuda
mostrarAyuda :: IO ()
mostrarAyuda = do
    putStrLn "===== Instrucciones del juego ====="
    putStrLn "Cada jugador tiene una catapulta con HP y combustible. (El HP inicial se escoje al inicio del juego)."
    putStrLn "Puedes mover la catapulta usando las teclas a/d (Jugador 1) y <4/6> (Jugador 2)."
    putStrLn "Puedes mover la cañon usando las teclas w/s (Jugador 1) y <8/5> (Jugador 2), para asignar el grado de inclinación del cañon."
    putStrLn "Puedes disparar usando las teclas w (Jugador 1) y e (Jugador 2)."
    putStrLn "Mover la catapulta consume 5 unidades de combustible."
    putStrLn "Mover el cañon consume 1 unidad de combustible."
    putStrLn "Cada disparo consume 3 unidades de combustible."
    putStrLn "El objetivo es reducir el HP de la otra catapulta a cero."
    putStrLn "Presiona q para salir."
    putStrLn "===================================="
