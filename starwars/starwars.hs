import Text.Show.Functions
import Data.List

data Naves = Naves {
    nombre :: String,
    durabilidad :: Int,
    escudo :: Int,
    ataque :: Int,
    poder :: Naves -> Naves
} deriving (Show)

tie :: Naves
tie = Naves {
    nombre = "TIE Fighter",
    durabilidad = 200,
    escudo = 100,
    ataque = 50,
    poder = turbo
}
turbo :: Naves -> Naves
turbo nave = nave {ataque = 25 + ataque nave}

xwing = Naves {
    nombre = "TIE Fighter",
    durabilidad = 300,
    escudo = 150,
    ataque = 100,
    poder = reparacionEmergencia
}

reparacionEmergencia :: Naves -> Naves
reparacionEmergencia nave = nave {
    durabilidad = durabilidad nave + 50,
    ataque = ataque nave - 30
}

naveDV :: Naves
naveDV = Naves {
    nombre = "TIE Fighter",
    durabilidad = 500,
    escudo = 300,
    ataque = 200,
    poder = superTurbo
}

super :: Naves -> Naves
super nave = turbo (turbo (turbo nave))

superTurbo :: Naves -> Naves
superTurbo nave = super nave {
    durabilidad = durabilidad nave - 45
}

mf :: Naves
mf = Naves {
    nombre = "Millennium Falcon",
    durabilidad = 1000,
    escudo = 500,
    ataque = 50,
    poder = reparacionEspecial
}

reparacionEspecial :: Naves -> Naves
reparacionEspecial nave = reparacionEmergencia nave {
    durabilidad = durabilidad nave + 100
}

durabilidadTotal :: [Naves] -> Int
durabilidadTotal = sum . map durabilidad

atacaA :: Naves -> Naves -> Naves
atacaA nave1 nave2 = nave2 {
    durabilidad = max 0 (durabilidad n2 - max 0 (escudo n2 - ataque n1))
}
    where
        n1 = poder nave1 nave1
        n2 = poder nave2 nave2

type Criterio = [Naves] -> [Naves]

fueraDeCombate :: Naves -> Bool
fueraDeCombate = (==0) . durabilidad

navesDebiles :: [Naves] -> [Naves]
navesDebiles = filter ((<200). escudo)

navesConCiertaPeligrosidad :: Int -> [Naves] -> [Naves]
navesConCiertaPeligrosidad numero = filter ((>numero) . ataque)

navesFueraCombate :: [Naves] -> [Naves]
navesFueraCombate = filter fueraDeCombate 

atacar :: Naves -> Criterio -> [Naves] -> [Naves]
atacar atacante estrategia flotaEnemiga
    | puedeAtacar estrategia flotaEnemiga = 
        map (atacante `atacaA`) (estrategia flotaEnemiga)
    | otherwise = flotaEnemiga

puedeAtacar :: Criterio -> [Naves] -> Bool
puedeAtacar criterio = not . null . criterio 

evaluarAtaque :: Naves -> [Naves] -> Criterio -> Criterio -> [Naves]
evaluarAtaque atacante flota c1 c2 
    | durabilidadTotal (atacar atacante c1 flota) >
        durabilidadTotal (atacar atacante c2 flota) 
        = atacar atacante c2 flota
    | otherwise = atacar atacante c1 flota

-- No va a ser posible, debido a que la funcion sum necesita de la final de la lista
-- para poder ejecutarse y dar un resultado

-- como la lista es inifita la mision no va a terminar nunca