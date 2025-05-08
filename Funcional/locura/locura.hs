import Text.Show.Functions

data Investigador = Investigador {
    nombre :: String,
    cordura :: Int,
    items :: [Item],
    sucesosEvitados :: [String]
} deriving (Show,Eq)

data Item = Item {
    nombreItem :: String,
    valor :: Int
} deriving (Show,Eq)


maximoSegun :: (Foldable t, Ord a1) => (a2 -> a1) -> t a2 -> a2
maximoSegun f = foldl1 (mayorSegun f)
mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f a b
    | f a > f b = a
    | otherwise = b


deltaSegun :: Num a => (b -> a) -> (b -> b) -> b -> a
deltaSegun ponderacion transformacion valor =
    abs ((ponderacion . transformacion) valor - ponderacion valor )


enloquezca :: Int -> Investigador -> Investigador
enloquezca numero inves = inves {cordura = max 0 (cordura inves - numero)}

enloquezca' :: Int -> Investigador -> Int
enloquezca' numero inves = max 0 (cordura inves - numero)

hallarItem :: Item -> Investigador -> Investigador
hallarItem item inves = inves {
    items = items inves ++ [item],
    cordura = cordura (valor item `enloquezca` inves)
}

tieneItem :: Item -> Investigador -> Bool
tieneItem item inves = item `elem` items inves

tienenItem :: Item -> [Investigador] -> Bool
tienenItem item = any (item `tieneItem`)

-- PUNTO 3 --

valorMaximoItem :: Investigador -> Int
valorMaximoItem inves =
    valor (maximoSegun valor (items inves))

formulaPotencial :: Investigador -> Int
formulaPotencial inves  =
    cordura inves* (1+3*length (sucesosEvitados inves)) + valorMaximoItem inves

formulaPotencial' :: Investigador -> Int
formulaPotencial' inv =
  (*cordura inv) . (+ (1 + 3 * length (sucesosEvitados inv))) . valorMaximoItem  $ inv


potencial :: Investigador -> Int
potencial inves
    | cordura inves == 0 = 0
    | otherwise = formulaPotencial inves

liderActual :: [Investigador] -> Investigador
liderActual = maximoSegun potencial

-- Punto 4 -- 
-- A -- 

corduraTotal :: Int -> [Investigador] -> Int
corduraTotal numero = sum . map (numero `enloquezca'`)

-- B --

potecialNoLoco :: [Investigador] -> Int
potecialNoLoco = potencial . head . filter (\inves -> 0 /= cordura inves) 

-- C -- 

-- seria imposible con los ambos casos debido a que no hay ningun condicion para que este
-- deje de realizar comparación como en el filter o aplicacando una funcion en el map
-- se quedarian hasta el infinito

type Suceso = [Investigador] -> [Investigador]

necronomicon = Item "Necronomicón" 10
dagaMaldita = Item "Daga Maldita" 3

enloquezer :: Int -> [Investigador] -> [Investigador]
enloquezer numero = map (numero `enloquezca`)

despertarAntiguo :: Suceso
despertarAntiguo investigadores
    | necronomicon `tienenItem` investigadores = investigadores
    | otherwise = enloquezer 10 (drop 1 investigadores) 

ritualEnInnsmouth :: Suceso
ritualEnInnsmouth investigadores
    | (potencial . liderActual $ investigadores) > 100 = investigadores
    | otherwise = hallarItem' . despertarAntiguo . enloquezer 2 $ investigadores

hallarItem' :: [Investigador] -> [Investigador]
hallarItem' investigadores = 
    drop 1 investigadores ++ 
    [dagaMaldita `hallarItem` head investigadores] 

enfrentarSuceso :: [Investigador] -> [Suceso] -> [Investigador]
enfrentarSuceso investigadores = foldl (flip ($)) (1 `enloquezer` investigadores) 

evitoSucesos :: [Investigador] -> [Suceso] -> Bool
evitoSucesos investigadores sucesos =
    investigadores `enfrentarSuceso` sucesos == investigadores

eventoSucesos :: [Investigador] -> [Suceso] -> [Investigador]
eventoSucesos investigadores sucesos 
    | investigadores `evitoSucesos` sucesos = investigadores
    | otherwise = investigadores `enfrentarSuceso` sucesos

sucesosMasAterrador :: [Investigador] -> [Suceso] -> Suceso
sucesosMasAterrador investigadores sucesos =
    undefined -- falta definir puntos 4 a y b con delta segun para definir este punto,
    -- nada del otro mundo esta funcion, pero no entiendo como funciona deltaSegun
    