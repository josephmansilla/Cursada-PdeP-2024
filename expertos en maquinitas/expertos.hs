import Data.List

data Persona = Persona {
    nombre :: String,
    dinero :: Dinero,
    suerte :: Int,
    factores :: [Factor]
} deriving (Show, Eq)

data Factor = Factor {
    descripcion :: String,
    valor :: Int,
    permitda :: Bool
} deriving (Show, Eq)

cosmeFulanito :: Persona
cosmeFulanito = Persona{
    nombre = "Cosme Fulanito",
    dinero = 100,
    suerte = 30,
    factores = [Factor "amuleto" 3 True,
                Factor "manos magicas" 100 True,
                Factor "paciencia" (-10) True]
}

elCoco :: Persona
elCoco = Persona{
    nombre = "El Coco",
    dinero = 20,
    suerte = 70,
    factores = [Factor "inteligencia" 55 True,
                Factor "paciencia" 50 True]
}

-- Funciones Auxiliares --

factorBuscado :: String -> Persona -> Factor
factorBuscado factorBuscado = head . filter ((==factorBuscado). descripcion) . factores

-- PUNTO 2 --

cuantoFactor :: String -> Persona -> Int
cuantoFactor fb persona = max 0 (valor (fb `factorBuscado` persona))

potencialPersona :: Persona -> Int
potencialPersona persona =
    (suerte persona + (sum . map valor . factores) persona) `div` 100

esTramposa :: Persona -> Bool
esTramposa = all (not . permitda) . factores


-- Punto 3

-- A

type Dinero = Int
type Ganancia = Dinero -> Dinero

type CriterioDeterminante = Persona -> Bool

data Juego = Juego {
    name :: String,
    ganancia :: Ganancia,
    criterio :: [CriterioDeterminante]
}

puedeGanar :: Persona -> Juego -> Bool
puedeGanar persona = all ($ persona) . criterio

ruleta :: Juego
ruleta = Juego "ruleta" (*37)
        [ (>70).potencialPersona ,
        not . esTramposa ]

maquinita :: Dinero -> Juego
maquinita jackpot = Juego "maquinita" (jackpot +)
                    [  (>=50).suerte ,
                    (>=40) . cuantoFactor "paciencia"]

blackJack :: Juego
blackJack = Juego "black jack" (\x -> x + x)
            [\persona -> suerte persona >= 30 || esTramposa persona]

-- e -- 

-- cosmeFulanito `puedeGanar` (ruleta)
-- elCoco `puedeGanar` (maquinita 200)


-- Punto 4 --

accion :: Juego -> Dinero -> Persona -> Persona
accion juego apuesta = jugar juego apuesta . apostar apuesta

apostar :: Dinero -> Persona -> Persona
apostar apuesta persona
    | apuesta <= dinero persona = (-apuesta) `cambiarSaldo` persona
    | otherwise = error "Saldo insuficiente"

cambiarSaldo :: Dinero -> Persona -> Persona
cambiarSaldo apuesta persona = persona {dinero = dinero persona + apuesta}

jugar :: Juego -> Dinero -> Persona -> Persona
jugar juego apuesta persona
    | persona `puedeGanar` juego = cambiarSaldo (ganancia juego (dinero persona)) persona
    | otherwise = persona

-- Punto 5 -- 

superIA :: Persona -> Dinero -> [Juego] -> Int
superIA persona apuesta = foldl (flip ganancia) (dinero persona) . filter (puedeGanar persona)

--https://github.com/pdep-mit/ejemplos-de-clase-haskell/blob/2018/Expertos_en_maquinitas-clase_dise%C3%B1osa.hs
