import Prelude

-- Ejercicio 1

-- esMultiploTres: devuelve true si un numero es multiple de 3 
esMultiploTres:: Int -> Bool
esMultiploTres numero = mod numero 3 == 0

-- Ejercicio 2
esMultiploDe:: Int -> Int -> Bool
esMultiploDe multiplo numero = mod numero multiplo == 0

-- Ejercicio 3
cubo:: Int -> Int
cubo numero = numero * numero * numero

-- Ejercicio 4
area:: Int -> Int -> Int
area base altura = base * altura

-- Ejercicio 5
esBisiesto:: Int -> Bool
esBisiesto año = esMultiploDe 400 año && (not(esMultiploDe 100 año) || esMultiploDe 4 año) 

-- Ejercicio 6
celsiusToFahr :: Double -> Double
celsiusToFahr celsius = (celsius * 1.8) + 32 


-- Ejercicio 7
fahrToCelsius :: Double -> Double
fahrToCelsius fahr = (fahr - 32) * (5/9)


-- Ejercicio 8
haceFrioF :: Double -> Bool
haceFrioF fahr = fahrToCelsius fahr < 8

-- Ejercicio 9
mcm :: Int -> Int -> Int
mcm a b = div (a * b) (gcd a b)

minimoTres :: Ord a => a -> a -> a -> a
minimoTres a b c = min a (min b c)

maximoTres :: Ord a => a -> a -> a -> a
maximoTres a b c = max a (max b c)

-- Ejercicio 10
dispersion :: (Num a, Ord a) => a -> a -> a -> a
dispersion x y z = maximoTres x y z - minimoTres x y z

diasLocos :: (Num a, Ord a) => a -> a -> a -> Bool
diasLocos x y z = dispersion x y z < 30

diasParejos :: (Num a, Ord a) => a -> a -> a -> Bool
diasParejos x y z = dispersion x y z > 100

diasNormales :: (Num a, Ord a) => a -> a -> a -> Bool
diasNormales x y z = not (diasParejos x y z) && not (diasLocos x y z)

-- Ejercicio 11
pesoPino :: (Ord a, Fractional a) => a -> a
pesoPino altura
    | altura <= 300.0 = altura * 3 -- hasta 3 metros
    | otherwise = (300.0*3) + ((altura - 300) * 2) -- arriba de 3 metros

esPesoUtil :: (Ord a, Num a) => a -> Bool
esPesoUtil peso = peso >= 400 && peso <= 1000

sirvePino :: (Ord a, Fractional a) => a -> Bool
sirvePino altura = esPesoUtil (pesoPino altura)

-- Ejercicio 12
-- https://es.wikipedia.org/wiki/Cuadrado_perfecto

esCuadradoPerfecto:: Int -> Bool
esCuadradoPerfecto numero = buscarCuadradoPerfecto 0 numero

cuadradoPerfecto:: Int -> Int
cuadradoPerfecto numero = (2 * numero) - 1

buscarCuadradoPerfecto:: Int -> Int -> Bool
buscarCuadradoPerfecto 0 0 = True
buscarCuadradoPerfecto indice objetivo
    | cuadradoPerfecto indice == objetivo = True
    | cuadradoPerfecto indice < objetivo = buscarCuadradoPerfecto (indice + 1) objetivo
    | otherwise = False

