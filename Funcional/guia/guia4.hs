

-- Ejercicio Extra

-- ghci> :t (!!)
-- (!!) :: GHC.Stack.Types.HasCallStack => [a] -> Int -> a 

-- ghci> :t head
-- head :: GHC.Stack.Types.HasCallStack => [a] -> a

-- ghci> :t tail
-- tail :: GHC.Stack.Types.HasCallStack => [a] -> [a]

-- ghci> :t null
-- null :: Foldable t => t a -> Bool

-- ghci> :t concat 
-- concat :: Foldable t => t [a] -> [a]

-- ghci> :t init
-- init :: GHC.Stack.Types.HasCallStack => [a] -> [a]

-- ghci> :t length
-- length :: Foldable t => t a -> Int

-- ghci> :t last
-- last :: GHC.Stack.Types.HasCallStack => [a] -> a

-- Ejercicio 1
sumaDeLista :: [Int] -> Int
sumaDeLista [] = 0
sumaDeLista lista = sum lista

-- Ejercicio 2
frecuenciaCardiaca :: [Int]
frecuenciaCardiaca = [80, 100, 120, 128, 130, 123, 125]

promedioFrecuenciaCardiaca :: Int
promedioFrecuenciaCardiaca = sum frecuenciaCardiaca `div` length frecuenciaCardiaca

frecuenciaCardiacaMinuto :: Int -> Int
frecuenciaCardiacaMinuto minuto = frecuenciaCardiaca !! (div minuto 10)

frecuenciasHastaMomento :: Int -> [Int]
frecuenciasHastaMomento minuto = take ((div minuto 10)+1) frecuenciaCardiaca


-- Ejercicio 3
esCapicua :: Eq a => [[a]] -> Bool
esCapicua [] = False
esCapicua lista = concat (reverse lista) == concat lista

-- Ejercicio 4
duracionLlamadas :: ((String, [Integer]), (String, [Integer]))
duracionLlamadas = (("horarioReducido",[20,10,25,15]),("horarioNormal",[10,5,8,2,9,10]))

-- Ejercicio 4 A 
cuandoHabloMasMinutos :: String
cuandoHabloMasMinutos
    | minutosReducido > minutosNormal = "horarioReducido"
    | minutosReducido < minutosNormal = "horarioNormal"
    where
        reducido = snd duracionLlamadas
        minutosReducido = sum (snd reducido)
        normal = snd duracionLlamadas
        minutosNormal = sum (snd normal)

-- Ejercicio 4 B
cuandoHizoMasLlamadas :: String
cuandoHizoMasLlamadas
    | cantReducido > cantNormal = "horarioReducido"
    | cantReducido < cantNormal = "horarioNormal"
    where
        reducido = snd duracionLlamadas
        cantReducido = length (snd reducido)
        normal = snd duracionLlamadas
        cantNormal = length (snd normal)

-- ORDEN SUPERIOR

fst3 :: (a, b, c) -> a
fst3 (n,_,_) = n
snd3 :: (a, b, c) -> b
snd3 (_,m,_) = m
trd3 :: (a, b, c) -> c
trd3 (_,_,j) = j

--Ejercicio 1
existsAny :: (a -> Bool) -> (a,a,a) -> Bool
existsAny funcion tupla = funcion (fst3 tupla) || funcion (snd3 tupla) || funcion (trd3 tupla)

-- Ejercicio 2

cuadrado :: Int -> Int
cuadrado x = x * x

triple :: Int -> Int
triple x = x * 3

mejor:: (Int->Int) -> (Int->Int) -> Int -> Int
mejor func1 func2 number
    | func1 number > func2 number = func1 number
    | otherwise = func2 number

-- Ejercicio 3
aplicarPar:: (Int -> Int) -> (Int, Int) -> (Int, Int)
aplicarPar funcion (x,y)= (funcion x, funcion y)

-- Ejercicio 4
parDeFuncs :: (Int -> a) -> (Int -> b) -> Int -> (a,b)
parDeFuncs func1 func2 number = (func1 number, func2 number)


-- ORDEN SUPERIOR ++ LISTA JEJE
-- paresEntre n1 n2 = filter even [n1..n2] 
-- sumarN n lista = map (+n) lista
-- sumarElDobleDeN n lista = map (+ (doble n)) lista
--all even [2,48,14] = True -- Indica si todos los elementos de una lista cumplen una condición. 
--all even [2,49,14] = False 
--any even [2,48,14] = True -- Indica si algunos de los elementos de una lista cumplen una condición

-- Ejercicio 1

esMultiploDeAlguno :: Int -> [Int] -> Bool
esMultiploDeAlguno divisor = any ((==0).(`mod` divisor))


-- Ejercicio 2

prom :: [Int] -> Int
prom lista = sum lista `div` length lista

promedios :: [[Int]] -> [Int]
promedios = map prom
-- aplicacion parcial de lista

-- Ejercicio 3

promediosSinAplazos :: [[Int]] -> [Int]
promediosSinAplazos lista = filter (> 4) (promedios lista)

-- Ejercicio 4

mejoresNotas :: [[Int]] -> [Int]
mejoresNotas = map maximum
--aplicacion parcial de lista

-- Ejercicio 5
aprobo :: [Int] -> Bool
aprobo = all (>=6)
--aplicación parcial de lista

-- Ejercicio 6
aprobaron :: [[Int]] -> [[Int]]
aprobaron [] = []
aprobaron lista
    | aprobo principio = principio : aprobaron resto
    | otherwise = aprobaron resto
    where
        principio = head lista
        resto = tail lista

-- Ejercicio 7
divisores :: Int -> [Int]
divisores numero = filter ((==0).(mod numero)) [1..numero]


-- Ejercicio 8
exists :: (Int->Bool) -> [Int] -> Bool
exists = any

-- Ejercicio 9
hayAlgunNegativo :: [Int] -> a -> Bool
hayAlgunNegativo lista _ = any (<0) lista

-- Ejercicio 10
aplicarFunciones :: [Int->Int] -> Int -> [Int]
aplicarFunciones [] _ = []
aplicarFunciones lista valor = head lista valor : aplicarFunciones (tail lista) valor

-- Ejercicio 11
sumarF :: [Int -> Int] -> Int -> Int
sumarF funciones valor = sum (aplicarFunciones funciones valor)

-- Ejercicio 12
subirHabilidad :: Int -> [Int] -> [Int]
subirHabilidad _ [] = []
subirHabilidad valor jugadores
    | head jugadores + valor >= 12 = 12 : subirHabilidad valor (tail jugadores)
    | otherwise = head jugadores + valor : subirHabilidad valor (tail jugadores)

-- Ejercicio 13
flimitada:: (Int -> Int) -> Int -> Int
flimitada funcion = (`max` 0).(`min` 12).funcion

-- Punto A
cambiarHabilidad :: (Int -> Int) -> [Int] -> [Int]
cambiarHabilidad _ [] = []
cambiarHabilidad func jugadores = map (func `flimitada`) jugadores

-- Punto B
flimitada2:: (Int -> Int) -> Int -> Int
flimitada2 _ = (`max` 4)

cambiarHabilidad2:: (Int ->Int) -> [Int] -> [Int]
cambiarHabilidad2 func = map (func `flimitada2`)
-- por aplicación parcial

-- Ejercicio 14
--takeWhile hace lo que dice...

-- Ejercicio 15
primerosPares:: [Int] -> [Int]
primerosPares = takeWhile even

esDivisor :: Int->Int -> Bool
esDivisor numero= (0==).(`mod` numero)

primerosNoDivisores :: Int -> [Int] -> [Int]
primerosNoDivisores numero = takeWhile (not.esDivisor numero)

-- Ejercicio 16

compararListas :: [Int] -> [Int] -> [Int]
compararListas [] [] = []
compararListas (x:xs) (y:ys) = (x-y) : compararListas xs ys

huboMesMejorDe:: [Int] -> [Int] -> Int -> Bool
huboMesMejorDe ingresos egresos valor = any (> valor) (ingresos `compararListas` egresos)

-- Ejercicio 17

crecimientoAnual :: Int -> Int
crecimientoAnual edad
    | edad < 10 = 24 - (edad * 2)
    | edad >= 10 && edad <= 15 = 4
    | edad == 16 || edad == 17 = 2
    | edad == 18 || edad == 19 = 1
    | otherwise = 0

crecimientoEntreEdades :: Int -> Int -> Int
crecimientoEntreEdades edad1 edad2 = sum (map crecimientoAnual [edad1 .. (edad2-1)])

alturasEnUnAnio :: Int -> [Int] -> [Int]
alturasEnUnAnio edad = map (\x -> crecimientoAnual edad + x)

alturaEnEdades :: Int -> Int -> [Int] -> [Int]
alturaEnEdades altura edadActual = map ((+altura).crecimientoEntreEdades edadActual) 

-- Ejercicio 18

lluviasEnero :: [Int]
lluviasEnero = [0,2,5,1,34,2,0,21,0,0,0,5,9,18,4,0]


rachasLluvia2 :: [Int] -> [[Int]]
rachasLluvia2 lista
    | null lista = []
    | null racha = []
    | otherwise = racha : rachasLluvia2 recursivo
    where
        comienzo = dropWhile (==0) lista
        racha = takeWhile (/=0) comienzo
        recursivo = dropWhile (/=0) comienzo

prueba :: [Int] -> [Int]
prueba = dropWhile (==0)

p :: [[Int]]
p = rachasLluvia2 lluviasEnero

mayorRachaDeLluvias :: [[Int]] -> Int
mayorRachaDeLluvias [] = 0
mayorRachaDeLluvias rachas = maximum (map length rachas)


-- Ejercicio 19

sumaListaNumeros:: [Int] -> Int
sumaListaNumeros = foldl (+) 0

-- Ejercicio 20

productoListaNumeros:: [Int] -> Int
productoListaNumeros = foldl (*) 1

-- Ejercicio 21

k :: Double
k = 0.00119457

dispersion :: [Int] -> Int
dispersion [] = 0
dispersion [x] = 0
dispersion (x:xs) = foldr (\y acc -> max (max acc y) x) 0 xs


esMayuscula:: String -> Bool
esMayuscula = foldr (\ x -> (&&) (x `elem` ['A'..'Z'])) True 