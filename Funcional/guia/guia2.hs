-- APLICACION PARCIAL
-- Ejercicio 1

siguiente' :: Integer -> Integer
siguiente' numero = numero + 1

siguiente :: Integer -> Integer
siguiente = (+1)

-- Ejercicio 2
mitad :: Double -> Double
mitad = (/2)

-- Ejercicio 3
inversa':: Double -> Double 
inversa' = (1/) 

-- Ejercicio 4
triple :: Integer -> Integer
triple = (*3)

-- Ejercicio 5
pos :: Integer -> Bool
pos = (>0)
esNumeroPositivo :: Integer -> Bool
esNumeroPositivo = pos

-- COMPOSICION
-- Ejercicio 6
esMultiploDe :: Integer -> Integer -> Bool
esMultiploDe dividendo = (==0). (dividendo `mod`) 

-- Ejercicio 7

--esBisiesto n = (not (100 `esMultiploDe`)).(||).(4 `esMultiploDe` ).(&&).(400 `esMultiploDe`)

-- Ejercicio 8 
inversaRaizCuadrada :: Double -> Double
inversaRaizCuadrada = inversa' . sqrt 

-- Ejercicio 9
incrementMCuadradoN:: Double -> Double -> Double
incrementMCuadradoN m = (+m).(^2) 

-- Ejercicio 10
elevar' :: (Integral b, Num a) => a -> b -> a
elevar' = (^)

elevar :: (Integral b, Num a) => a -> b -> a
elevar = (^) 

esResultadoPar :: (Integral b, Integral a) => b -> a -> Bool
esResultadoPar n = even . (n `elevar`)