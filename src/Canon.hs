-- Canon.hs
module Canon where

-- Mostrar el cañón en la posición indicada
mostrarCanon :: Int -> IO ()
mostrarCanon pos = putStrLn $ replicate pos ' ' ++ "0-¨°|||°¨-0"
