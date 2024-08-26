import Data.List
import Text.Show.Functions


-- PUNTO 1 -- 
-- A --
data Pais = Pais {
    ingresoCapita :: Float,
    poblacionPublico :: Float,
    poblacionPrivado :: Float,
    recursosNaturales :: [String],
    deuda :: Float
} deriving (Show, Eq)
-- B --
namibia :: Pais
namibia = Pais 4140 400000 650000 ["mineria" , "ecoturismo"] 50000000

-- PUNTO 2
prestarDolares :: Float -> Pais -> Pais
prestarDolares cantidad pais = pais {deuda = endeudar (*1.5) cantidad pais}

endeudar :: (Float -> Float) -> Float -> Pais -> Float
endeudar porcentaje cantidad = (+porcentaje cantidad) . deuda

reducirPuestosPublicos :: Float -> Pais -> Pais
reducirPuestosPublicos cantidad pais =
    pais {poblacionPublico = poblacionPublico pais - cantidad}

disminuirIngresoCapita :: (Float -> Float) -> Pais -> Float
disminuirIngresoCapita porcentaje pais =
    (-) (ingresoCapita pais) . porcentaje . ingresoCapita $ pais


efectoReduccionPublico :: Float -> Pais -> Pais
efectoReduccionPublico cantidad pais
    | cantidad > 100 = reducirPuestosPublicos cantidad pais {ingresoCapita = disminuirIngresoCapita (*0.2) pais}
    | otherwise = reducirPuestosPublicos cantidad pais {ingresoCapita = disminuirIngresoCapita (*0.15) pais}

removerRecursoNatural :: String -> Pais -> Pais
removerRecursoNatural recurso pais = pais {recursosNaturales = filter (/= recurso) (recursosNaturales pais)}

explotarRecursosNaturales :: String -> Pais -> Pais
explotarRecursosNaturales recurso pais = removerRecursoNatural recurso pais {deuda = deuda pais - 2000000}

poblacionActiva :: Pais -> Float
poblacionActiva pais = (+poblacionPublico pais) . poblacionPrivado $ pais

pbi :: Pais -> Float
pbi pais = (*ingresoCapita pais) . poblacionActiva $ pais

establecerBlindaje :: Pais -> Pais
establecerBlindaje pais = pais{
    poblacionPublico = poblacionPublico pais - 500,
    deuda = deuda pais + (pbi pais/ 2)
}

-- PUNTO 3 -- 
-- A --
-- prestarDolares 200000000 . explotarRecursosNaturales "mineria" $ pais
-- B --
aplicarFunc :: Pais
aplicarFunc = prestarDolares 200000000 . explotarRecursosNaturales "mineria" $ namibia

-- PUNTO 4 -- 
-- A --
zafar :: [Pais] -> [Pais]
zafar = filter zafo

zafo :: Pais -> Bool
zafo pais = "Petroleo" `elem` recursosNaturales pais
-- B --
deudaTotal :: [Pais] -> Float
deudaTotal paises = foldl1 sumarDuedas (map deuda paises)

sumarDuedas :: Float -> Float  -> Float
sumarDuedas deuda deuda' = deuda + deuda 
-- C -- 

-- PUNTO 5 -- 

esMejorReceta' :: Pais -> [Pais -> Pais] -> Pais
esMejorReceta' = foldl (flip ($))

mejoresRecetas' :: Pais -> [Pais -> Pais] -> Bool
mejoresRecetas' pais recetas = pbi (esMejorReceta' pais recetas) > pbi pais 

mejorReceta :: Pais -> [Pais -> Pais] -> Bool
mejorReceta pais [] = True
mejorReceta pais receta
    | pbi pais < pbi mejorPais = mejorReceta mejorPais receta
    | otherwise = False
    where
        mejorPais = esMejorReceta' pais receta

-- PUNTO 6 --
recursosNaturalesInfinitos :: [String]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos
-- A -- 
-- En esa funcion seguira evaluandose y no tiene condicion de frenado
-- B -- 
-- direcamente nunca se va a poder evaluar el foldl debido
-- a que quedará infinitamente mapeando todos las deudas de los paises 
-- en la lista infinita