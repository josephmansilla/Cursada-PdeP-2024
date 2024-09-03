-- Ejercicio 1

fst3 :: (a, b, c) -> a
fst3 (n,_,_) = n
snd3 :: (a, b, c) -> b
snd3 (_,m,_) = m
trd3 :: (a, b, c) -> c
trd3 (_,_,j) = j

-- Ejercicio 2

-- FUNCIONES PARA PROBAR LA FUNCION APLICAR...
doble :: Int -> Int
doble x = x + x
triple :: Int -> Int
triple x = x*3

aplicar :: (t -> a, t -> b) -> t -> (a, b)
aplicar (funcionUno, funcionDos) argumento = (funcionUno argumento , funcionDos argumento)

-- Ejercicio 3
cuentaBizarra :: (Int, Int) -> Int
cuentaBizarra (first, second)
    | first > second = first + second
    | (second - first) >= 10 = second - first
    | (second - first) < 10 = second * first

-- Ejercicio 4

-- NOTA DE ALUMNO: (nota1, nota2). 2 en el primero y 7 en el segundo = (2,7)
esNotaBochazo :: Int -> Bool
esNotaBochazo nota = nota >= 6
aprobo :: (Int, Int) -> Bool
aprobo (nota1, nota2) = esNotaBochazo nota1 && esNotaBochazo nota2

promociono :: (Int, Int) -> Bool
promociono (nota1, nota2) = nota1 >= 7 && nota2 >= 7

primerParcial :: (Int, Int) -> String
primerParcial (nota1, nota2)
    | esNotaBochazo nota1 = "Aprobo el primer parcial !!!"
    | otherwise = "Desaprobo el primer parcial..."

-- Ejercicio 5
-- Ahora tenemos dos parciales con dos recuperatorios.
-- representados como: (par1, par2) y (rec1, rec2)

-- si no se rindió recuperatorio se agrega un -1 (trabajar con positivos para el resto de casos)

-- Ejercicio 5 A
notasFinales :: ((Int, Int), (Int, Int)) -> (Int, Int)
notasFinales ( (primerParcialito, segundoParcialito) , (primerRecuperatorito, segundoRecuperatorito) )
    | pp >= pr && sp <= sr = (pp, sr)
    | pp >= pr && sp >= sr = (pp, sp)
    | pp < pr && sp > sr = (pr, sp)
    | pp < pr && sp < sr = (pr, sr)
    where
        pp = primerParcialito
        sp = segundoParcialito
        pr = primerRecuperatorito
        sr = segundoRecuperatorito

-- Ejercicio 5 B
recursante :: ((Int, Int), (Int, Int)) -> Bool
recursante ( (primerParcialito, segundoParcialito) , (primerRecuperatorito, segundoRecuperatorito) ) = 
    fst (notasFinales ((pp,sp),(pr,sr))) < 6 && snd (notasFinales ((pp,sp),(pr,sr))) < 6
    where
        pp = primerParcialito
        sp = segundoParcialito
        pr = primerRecuperatorito
        sr = segundoRecuperatorito

-- Ejercicio 5 C
recuperoPrimerParcial :: ((Int, Int), (Int, Int)) -> Bool
recuperoPrimerParcial ( (primerParcialito, segundoParcialito) , (primerRecuperatorito, segundoRecuperatorito) ) = primerRecuperatorito == -1

-- Ejercicio 5 D
esAprobadoBochazo :: (Int, Int) -> Bool
esAprobadoBochazo (nota1, nota2) = nota1 > 6 && nota2 > 6

recuperoAlgunParcial :: (Int, Int) -> Bool
recuperoAlgunParcial (nota1, nota2) = nota1 == -1 || nota2 == -1

recuperoDeGusto :: ((Int, Int), (Int, Int)) -> Bool
recuperoDeGusto ( (primerParcialito, segundoParcialito) , (primerRecuperatorito, segundoRecuperatorito) ) = 
    esAprobadoBochazo (fst notasAlumno) && recuperoAlgunParcial (snd notasAlumno)
    where
        notasAlumno = ( (primerParcialito, segundoParcialito) , (primerRecuperatorito, segundoRecuperatorito) )

-- Ejercicio 6

esMayorDeEdad :: (a,Int) -> Bool
esMayorDeEdad (nombre, edad) = edad > 20

-- Ejercicio 7

siguiente :: Int -> Int
siguiente x = x + 1

-- ya tengo la funcion doble también

esParDupla :: (Int,Int) -> Bool 
esParDupla (x, y) = even x

esImparDupla :: (Int,Int) -> Bool 
esImparDupla (x, y) = odd y

calcular :: (Int,Int) -> (Int, Int)
calcular (primerElemento, segundoElemento) 
    | esParDupla dupla && esImparDupla dupla       =    ( doble primero , siguiente segundo )
    | not (esParDupla dupla) && esImparDupla dupla =    ( primero , siguiente segundo )
    | esParDupla dupla && not(esImparDupla dupla)  =    ( doble primero , segundo )
    | otherwise = (primerElemento, segundoElemento)
    where
        dupla = (primerElemento, segundoElemento)
        primero = fst dupla
        segundo = snd dupla