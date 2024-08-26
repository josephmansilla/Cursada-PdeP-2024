import Text.Show.Functions
import Data.List

data Planeta = Planeta {
    nombre :: String,
    posicion :: Posicion,
    relacionTiempo :: Float -> Float
} deriving (Show)

data Posicion = Posicion {
    x :: Float,
    y :: Float,
    z :: Float
} deriving (Show)

data Astronauta = Astronauta {
    name :: String,
    edad :: Float,
    planeta :: Planeta
} deriving (Show)

-- PUNTO 1 A --

distanciaEntre :: Planeta -> Planeta -> Float
distanciaEntre p1 = distancia (posicion p1) . posicion 

distancia :: Posicion -> Posicion -> Float
distancia p1 = sqrt . sum . map (^2) . (`diferencia `p1) 

diferencia :: Posicion -> Posicion -> [Float]
diferencia (Posicion x1 y1 z1) (Posicion x2 y2 z2) = [x1-x2,y1-y2,z1-z2]

-- PUNTO 1 B -- 

viaje :: Float -> Planeta -> Planeta -> Float
viaje velocidad p1 = (/velocidad) . distanciaEntre p1 

-- PUNTO 2 -- 

pasarTiempo:: Float -> Astronauta -> Planeta -> Astronauta
pasarTiempo años astro planeta = astro {edad = edad astro + relacionTiempo planeta años}

xz202 = Planeta {
    nombre = "xz202",
    posicion = Posicion 20 100 400,
    relacionTiempo = (*2)
}

laTierra = Planeta {
    nombre = "La Tierra",
    posicion = Posicion 0 0 0,
    relacionTiempo = (+0)
}

beto = Astronauta {
    name = "Roberto",
    edad = 14,
    planeta = xz202
}

carla = Astronauta {
    name = "Carla",
    edad = 24,
    planeta = laTierra
}

-- PUNTO 3 -- 

viajar :: Planeta -> Nave -> Astronauta -> Astronauta
viajar destino nave astro = 
    cambiarPlaneta destino . 
    pasarTiempo (viaje (nave (planeta astro) destino) (planeta astro) destino) astro $ destino

cambiarPlaneta :: Planeta -> Astronauta -> Astronauta
cambiarPlaneta nuevo astro = astro {planeta = nuevo}

-- A --
type Nave = Planeta -> Planeta -> Float

naveVieja :: Float -> Nave
naveVieja tanques = viaje (velocidadTanques tanques)  

velocidadTanques :: Float -> Float
velocidadTanques cantidad
    | cantidad < 6 = 10.0
    | otherwise = 7.0

-- B --

naveFuturista :: Nave
naveFuturista _ _ = 0


-- Punto 4 -- 

-- A -- 

type Rescate = Nave -> Astronauta -> [Astronauta]

rescate :: [Astronauta] -> Nave -> Astronauta -> [Astronauta]
rescate astros nave salvado = 
    -- cambiarEdad ((edad (irABuscar salvado nave astros)) - (edad (head astros)) ) . last . 
    (viajamos (planeta (head astros)) nave.
    flip incorporarAstro (pasarTiempo (edadDespues - edad (head astros)) salvado (planeta salvado)) .
    viajaTripulacion) 
    astros
    where
        viajaTripulacion = irABuscar salvado nave
        edadDespues = edad (head (irABuscar salvado nave astros))

incorporarAstro :: [Astronauta] -> Astronauta -> [Astronauta]
incorporarAstro astros astro = astros ++ [astro]

irABuscar :: Astronauta -> Nave -> [Astronauta] -> [Astronauta]
irABuscar objetivo = viajamos (planeta objetivo) 

viajamos :: Planeta -> Nave -> [Astronauta] -> [Astronauta]
viajamos planeta nave = map (viajar planeta nave)

cambiarEdad :: Float -> Astronauta -> [Astronauta]
cambiarEdad tiempo astro = [astro {edad = edad astro + tiempo}]

esMayor :: Astronauta -> Bool
esMayor = (>90) . edad

rescates :: Nave -> [Astronauta] -> [Astronauta] -> [Astronauta]
rescates nave rescatistas varados = undefined

esPosibleRescatar :: Nave -> [Astronauta] -> Astronauta -> Bool
esPosibleRescatar nave rescatistas =
    all (not . esMayor) . rescate rescatistas nave

f :: (Ord b, Num d) => (b -> a -> b) -> b -> (d -> a -> Bool) -> [a] -> Bool
f a b c = any ((> b) . a b) . filter (c 10) 