import Data.List

data Jugador = Jugador {
    nombre :: String,
    edad :: Int,
    promedioGol :: Float,
    habilidad :: Float, -- entre 0 y 99
    valorDeCansancio :: Float -- 0 es el valor mas bajo
} deriving (Show,Eq)

data Equipo = Equipo {
    nombreEquipo :: String,
    grupo :: Char,
    formacion :: [Jugador]
} deriving (Show, Eq)

martin = Jugador "Martin" 26 0.0 50 35.0
juan = Jugador "Juancho" 30 0.2 50 40.0
maxi = Jugador "Maxi Lopez" 27 0.4 68 30.0

equipo1 :: Equipo
equipo1 = Equipo
    "Lo Que Vale Es El Intento"
    'F'
    [martin, juan, maxi]

jonathan = Jugador "Chueco" 20 1.5 80 99.0
lean = Jugador "Hacha" 23 0.01 50 35.0
brian = Jugador "Panadero" 21 5.0 80 15.0

losDeSiempre = Equipo
    "Los De Siempre"
    'F'
    [jonathan, lean, brian]

garcia = Jugador "Sargento" 30 1.0 80 13.0
messi = Jugador "Pulga" 26 10.0 99 43.0
aguero = Jugador "Aguero" 24 5.0 90 5.0
restoDelMundo = Equipo
    "Resto Del Mundo"
    'A'
    [garcia, messi, aguero]

quickSort :: (a -> a -> Bool) -> [a] -> [a]
quickSort _ [] = []
quickSort criterio (x:xs) =
    (quickSort criterio . filter (not . criterio x))
    xs ++ [x] ++
    (quickSort criterio . filter (criterio x)) xs

figuraEquipo :: Equipo -> [Jugador]
figuraEquipo = quickSort mejorJugador . filter esFigura . formacion

mejorJugador :: Jugador -> Jugador -> Bool
mejorJugador j1 j2 
    | habilidad j1 == habilidad j2 = promedioGol j1 > promedioGol j2
    | otherwise = habilidad j1 > habilidad j2  

esFigura :: Jugador -> Bool
esFigura jugador = ((>0) . promedioGol) jugador && ((>70) . habilidad) jugador

jugadoresFaranduleros :: [String]
jugadoresFaranduleros = ["Maxi Lopez",
                        "Icardi",
                        "Aguero",
                        "Caniggia",
                        "Demichelis"]

equipoPorNombres :: [Jugador] -> [String]
equipoPorNombres = map nombre

esFarandulero :: Jugador -> Bool
esFarandulero = flip elem jugadoresFaranduleros . nombre

hayFarandulero :: Equipo -> Bool
hayFarandulero =
    any esFarandulero . formacion

esJoven :: Jugador -> Bool
esJoven = (<27) . edad

esDificil :: Jugador -> Bool
esDificil jugador = (not . esFarandulero) jugador
                    && esFigura jugador
                    && esJoven jugador

figuritasDificiles :: Char -> [Equipo] -> [Jugador]
figuritasDificiles char serieEquipos =
    concatMap (filter esDificil . formacion)
    (filter ((==char) . grupo ) serieEquipos)

jugarPartido :: Equipo -> Equipo
jugarPartido equipo = equipo {formacion = map cansancioJugador (formacion equipo)}

cansancioJugador :: Jugador -> Jugador
cansancioJugador jugador
    | esDificil jugador = jugador {valorDeCansancio = 50}
    | esJoven jugador = jugador {valorDeCansancio = valorDeCansancio jugador + ((* 0.1) . valorDeCansancio) jugador}
    | not (esJoven jugador) && esFigura jugador = jugador {valorDeCansancio = ((+20). valorDeCansancio) jugador}
    | otherwise = jugador {valorDeCansancio = ((*2) . valorDeCansancio) jugador}


menosCansado :: Jugador -> Jugador -> Bool
menosCansado j1 j2 = valorDeCansancio j1 < valorDeCansancio j2

menosCansados :: Equipo -> [Jugador]
menosCansados equipo = quickSort menosCansado (formacion equipo)

seleccionarOnce :: Equipo -> Equipo
seleccionarOnce equipo = equipo {formacion = take 11 (menosCansados equipo)}

promedioGolEquipo :: Equipo -> Float
promedioGolEquipo = sum . map promedioGol . formacion

leGanoA :: Equipo -> Equipo -> Bool
leGanoA equipo1 equipo2 =
    promedioGolEquipo (seleccionarOnce equipo1)
    > promedioGolEquipo (seleccionarOnce equipo2)

enfrentamiento :: Equipo -> Equipo -> Equipo
enfrentamiento e1 e2
    | e1 `leGanoA` e2 = jugarPartido e1
    | otherwise = jugarPartido e2

ganadorTorneo :: [Equipo] -> Equipo
ganadorTorneo = foldl1 enfrentamiento

type NombreFigura = String

entregarPremio :: [Equipo] -> String
entregarPremio equipos = 
    nombre (head (figuraEquipo (ganadorTorneo equipos)))

entregarPremio' :: [Equipo] -> String
entregarPremio' = 
    nombre . head . figuraEquipo . ganadorTorneo