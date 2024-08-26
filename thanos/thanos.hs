import Data.List
import Text.Show.Functions

data Guante = Guante {
    material :: String,
    gemas :: Habilidad
} deriving (Show)

data Personaje = Personaje {
    edad :: Int, 
    energia :: Int,
    habilidades :: [Habilidad],
    nombre :: String,
    planeta :: String
} deriving (Show)

type Universo = [Personaje]

chasquido :: [Int] -> [Int]
chasquido per = take (length per `div` 2) per 

edadMenor :: Int -> Personaje -> Bool
edadMenor años = (<años) . edad  

universoApto :: (Personaje -> Bool) -> [Personaje] -> Bool
universoApto criterio personajes = any criterio personajes

energiaTotalUnivero :: [Personaje] -> Int
energiaTotalUnivero = sum . map energia 

type Habilidad = (Personaje -> Personaje)

sacarEnergia :: Int -> Personaje -> Personaje
sacarEnergia valor personaje = personaje {energia = energia personaje - valor}

mente :: Int -> Habilidad
mente valor personaje = sacarEnergia valor personaje

-- alma :: Habilidad -> Habilidad
-- alma habilidad personaje = 10 `sacarEnergia` personaje {
--     habilidades = filter (habilidad) (habilidades personaje)
-- }

cambiarPlaneta :: String -> Habilidad
cambiarPlaneta planetaNuevo personaje = personaje{planeta = planetaNuevo}

espacio :: String -> Habilidad
espacio planeta = sacarEnergia 20 . cambiarPlaneta planeta 

poder :: Habilidad 
poder personaje
    | length (habilidades personaje) < 3 = energia personaje `sacarEnergia` personaje {habilidades = []}
    | otherwise = energia personaje `sacarEnergia` personaje

tiempo :: Habilidad
tiempo personaje = 50 `sacarEnergia` personaje {
    edad = max 18 (edad personaje `div` 2)
} 

gemaLoca :: Habilidad -> Habilidad 
gemaLoca gema = gema . gema 

-- PUNTO 5 --

utilizar :: Personaje -> [Habilidad] -> Personaje
utilizar = foldl (flip ($))