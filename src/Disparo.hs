module Disparo where

-- Mover el disparo en una trayectoria parabólica
moverDisparo :: Int -> Maybe (Int, Int) -> IO ()
moverDisparo _ Nothing = return ()  -- Si no hay disparo, no hace nada
moverDisparo canonPos (Just (x, y))
    | y <= 0 = return ()  -- El disparo "desaparece" al llegar al suelo
    | otherwise = do
        let newX = x + 1
            newY = max 0 (y - 1) -- Movimiento parabólico básico (ajustable para más realismo)
        putStrLn $ replicate newX ' ' ++ "*"  -- Mostrar el disparo en la nueva posición
        moverDisparo canonPos (Just (newX, newY))
