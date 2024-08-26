
data Auto = Auto {
    color :: String,
    velocidad :: Int,
    distancia :: Int
} deriving (Show, Eq)

type Carrera = [Auto]

-- Punto 1

-- a

distanciaEntre :: Auto -> Auto -> Int
distanciaEntre auto1 auto2 = abs((distancia auto1) - (distancia auto2))

distanciaEntre' :: Auto -> Auto -> Int
distanciaEntre' auto1 auto2 = (abs . (distancia auto1 -) . distancia) auto2

estaCerca :: Auto -> Auto -> Bool
estaCerca auto1 auto2 = auto1 /= auto2 && (auto1 `distanciaEntre` auto2) < 10

--b 

leVaGanando :: Auto -> Auto -> Bool
leVaGanando ganador = (< distancia ganador) . distancia

vaGanando :: Auto -> Carrera -> Bool
vaGanando auto = all ((< distancia auto) . distancia) . filter (/=auto)

tieneAlgunAutoCerca :: Auto -> Carrera -> Bool
tieneAlgunAutoCerca auto = any (auto `estaCerca`) 

vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo auto carrera = (not.tieneAlgunAutoCerca auto) carrera  && auto `vaGanando` carrera

-- C

puesto :: Auto -> Carrera -> Int
puesto auto = (1+) . length . filter ( not . leVaGanando auto )

-- Punto 2

-- A

correr :: Int -> Auto -> Auto
correr tiempo auto = auto {
    distancia = distancia auto + (tiempo * velocidad auto)
}

-- B 
-- i

type ModificadorDeVel = (Int -> Int)

alterarVelocidad :: (Int -> Int) -> Auto -> Auto
alterarVelocidad modificador auto = 
    auto {velocidad = (modificador . velocidad) auto}


-- (Int -> Int) -> (Int) pero este Int va dentro del Auto y devuelve el Auto 
-- 100 `bajar` 10 = 90 
-- (2-) . velocidad

-- ii
bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad velocidadABajar auto = subtract velocidadABajar `alterarVelocidad` auto

-- Punto 3 

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista
    = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

type PowerUp = Auto -> Carrera -> Carrera

--A 

terromoto :: PowerUp
terromoto auto = afectarALosQueCumplen (estaCerca auto) (bajarVelocidad 50) 

-- B

miguelitos :: Int -> PowerUp 
miguelitos velocidadABajar auto =
    afectarALosQueCumplen (leVaGanando auto) (bajarVelocidad velocidadABajar)

-- C

jetpack :: Int -> PowerUp 
jetpack tiempo auto  = 
    afectarALosQueCumplen (==auto) 
    ( alterarVelocidad (\_-> velocidad auto). correr tiempo . alterarVelocidad (*2) )



-- Punto 4


-- A

type Color = String
type Evento = Carrera -> Carrera

simularCarrera :: Carrera -> [Evento] -> [(Int, Color)]
simularCarrera carreraInicial eventos = (tablaDePosiciones . procesarEventos eventos) carreraInicial 

tablaDePosiciones :: Carrera -> [(Int, Color)]
tablaDePosiciones carrera = map (entradaDeTabla carrera) carrera

entradaDeTabla :: Carrera -> Auto -> (Int, Color)
entradaDeTabla carrera auto = (puesto auto carrera, color auto)

procesarEventos :: [Evento] -> Carrera -> Carrera 
procesarEventos eventos carreraInicial = 
    foldl (\carreraActual eventos -> eventos carreraActual) carreraInicial eventos 

procesarEventos' :: [Evento] -> Carrera -> Carrera 
procesarEventos' eventos carreraInicial = 
    foldl (flip ($)) carreraInicial eventos 


-- B

-- i
correnTodos :: Int -> Evento
correnTodos tiempo = map (tiempo `correr`)

-- ii
usaPowerUp :: PowerUp -> Color -> Evento
usaPowerUp powerUp colorBuscado carrera = 
    powerUp autoQueGatillaPoder carrera
    where
        autoQueGatillaPoder = find ((==colorBuscado).color) carrera

find :: (c -> Bool) -> [c] -> c
find cond =  head . filter cond 

-- C 

ejemploDeUsoSimularCarrera :: [Evento] -> [(Int, Color)]
ejemploDeUsoSimularCarrera evento = 
    simularCarrera autosDeEjemplos [
        correnTodos 30,
        usaPowerUp (jetpack 3) "azul",
        usaPowerUp terromoto "blanco"
    ]

autosDeEjemplos :: [Auto]
autosDeEjemplos = map (\color -> Auto color 120 0) ["rojo", "blanco", "azul", "negro"]


