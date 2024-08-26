import Text.Show.Functions
import Data.List

data Aspecto = Aspecto {
    tipoDeAspecto :: String,
    grado :: Float
} deriving (Show,Eq)

type Situacion = [Aspecto]

-- Auxiliares --
mejorAspecto :: Aspecto -> Aspecto -> Bool
mejorAspecto mejor peor = grado mejor < grado peor
mismoAspecto :: Aspecto -> Aspecto -> Bool
mismoAspecto a1 a2 = tipoDeAspecto a1 == tipoDeAspecto a2
buscarAspecto :: Aspecto -> [Aspecto] -> Aspecto
buscarAspecto aspectoBuscado = head . filter (mismoAspecto aspectoBuscado)
buscarAspectoDeTipo :: String -> [Aspecto] -> Aspecto
buscarAspectoDeTipo tipo = buscarAspecto (Aspecto tipo 0)
reemplazarAspecto :: Aspecto -> [Aspecto] -> [Aspecto]
reemplazarAspecto aspectoBuscado situacion = 
    aspectoBuscado : filter (not . mismoAspecto aspectoBuscado) situacion
-- PUNTO 1 --

-- A --
modificarAspecto :: (Float -> Float) -> Aspecto -> Aspecto
modificarAspecto cambio aspecto = aspecto {grado = cambio . grado $ aspecto}

-- B -- 

mejorSituacion :: Situacion -> Situacion -> Bool
mejorSituacion situacion1 situacion2 = 
    all (\aspecto1 -> mejorAspecto aspecto1 (buscarAspecto aspecto1 situacion2)) situacion1

-- C --
modificarSituacion :: (Float -> Float) -> Aspecto -> Situacion -> Situacion
modificarSituacion cambio aspectoBuscado situacion = 
    flip reemplazarAspecto situacion . 
    modificarAspecto cambio .
    buscarAspecto aspectoBuscado $ situacion 

-- PUNTO 2 --
-- A --
data Gemas = Gemas {
    nombre :: String,
    fuerza :: Int,
    personalidad :: Situacion -> Situacion
} deriving (Show)
-- B -- 
tension :: Aspecto
tension = Aspecto "Tension" 50
peligro :: Aspecto
peligro = Aspecto "Peligro" 100
incertidumbre :: Aspecto
incertidumbre = Aspecto "Incertidumbre" 20

type Personalidad = Situacion -> Situacion
-- i --
vidente :: Personalidad
vidente situacion =
    map (modificarAspecto (/2)) listaIncertidumbre  
    ++ map (modificarAspecto (10-)) listaTension 
    ++ filter (undefined) situacion
    where
        listaIncertidumbre = filter (mismoAspecto incertidumbre) situacion
        listaTension = filter (mismoAspecto tension) situacion