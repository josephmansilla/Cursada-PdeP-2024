
data Participante = UnParticipante{
    nombre :: String,
    edad :: Int,
    nivelAtractivo :: Int,
    nivelPersonalidad :: Int,
    nivelInteligencia :: Int,
    criterioVoto :: [Participante] -> Participante
} deriving (Show, Eq)

type IndiceExito = Int

-- min 0 (max 100 indiceExito)

doble:: Int -> Int
doble x = x + x

between :: (Eq a, Enum a) => a -> a -> a -> Bool
between n m x = x `elem` [n..m]

type Prueba = Participante -> Bool
type Pruebas = Participante -> Int

criterioBaileTikTok :: Prueba
criterioBaileTikTok p = nivelPersonalidad p >= 20
efectoBaileTikTok :: Pruebas
efectoBaileTikTok p = doble (nivelAtractivo p) + nivelPersonalidad p

criterioBotonRojo :: Prueba
criterioBotonRojo p = nivelPersonalidad p >= 10 && nivelInteligencia p >= 20

criterioCuentasRapidas :: Prueba
criterioCuentasRapidas p = nivelInteligencia p >= 40
efectoCuentasRapias :: Pruebas
efectoCuentasRapias p = nivelInteligencia p + nivelPersonalidad p - nivelAtractivo p

baileDeTikTok:: Pruebas
baileDeTikTok participante
    | criterioBaileTikTok participante = efectoBaileTikTok participante
    | otherwise = 0

botonRojo :: Pruebas
botonRojo participante
    | criterioBotonRojo participante = 100
    | otherwise = 0

cuentasRapidas :: Pruebas
cuentasRapidas participante
    | criterioCuentasRapidas participante = efectoCuentasRapias participante
    | otherwise = 0

criterios :: [Prueba]
criterios = [criterioBaileTikTok,criterioBotonRojo,criterioCuentasRapidas]
pruebasTest :: [Pruebas]
pruebasTest = [baileDeTikTok, baileDeTikTok, cuentasRapidas]

quienesSuperan :: Prueba -> [Participante] -> [Participante]
quienesSuperan _ [] = []
quienesSuperan criterio lista = filter criterio lista

promedioSuperan :: Prueba -> [Participante] -> Int
promedioSuperan criterio lista = length (quienesSuperan criterio lista) `div` length lista

esFavorito :: Participante -> [Pruebas] -> Bool
esFavorito participante = all (\prueba -> prueba participante > 50)

--PUNTO 3

mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f a b
    | f a > f b = a
    | otherwise = b
menorSegun :: Ord a => (t -> a) -> t -> t -> t
menorSegun f a b
    | f a < f b = a
    | otherwise = b
maximoSegun :: (Foldable t, Ord a1) => (a2 -> a1) -> t a2 -> a2
maximoSegun f = foldl1 (mayorSegun f)
minimoSegun :: (Foldable t, Ord a1) => (a2 -> a1) -> t a2 -> a2
minimoSegun f = foldl1 (menorSegun f)

menosInteligente :: [Participante] -> Participante
menosInteligente = minimoSegun nivelInteligencia

masAtractivo :: [Participante] -> Participante
masAtractivo  = maximoSegun nivelAtractivo

masViejo:: [Participante] -> Participante
masViejo = maximoSegun edad

javier :: Participante
javier = UnParticipante{
    nombre = "Javier Tulei",
    edad = 52,
    nivelAtractivo = 30,
    nivelPersonalidad = 70,
    nivelInteligencia = 35,
    criterioVoto = menosInteligente
}

minimo :: Participante
minimo = UnParticipante{
    nombre = "Minimo Kirchner",
    edad = 46,
    nivelAtractivo = 0,
    nivelPersonalidad = 40,
    nivelInteligencia = 50,
    criterioVoto = masAtractivo
}

horacio :: Participante
horacio = UnParticipante{
    nombre = "Horacio Berreta",
    edad = 57,
    nivelAtractivo = 10,
    nivelPersonalidad = 60,
    nivelInteligencia = 50,
    criterioVoto = masAtractivo
}

myriam :: Participante
myriam = UnParticipante{
    nombre = "Myriam Bregwoman",
    edad = 51,
    nivelAtractivo = 40,
    nivelPersonalidad = 40,
    nivelInteligencia = 60,
    criterioVoto = masViejo
}

-- punto 5

participantes :: [Participante]
participantes = [myriam, horacio, minimo, javier]

votar :: Participante -> [Participante] -> Participante
votar = criterioVoto

votoParticipante :: [Participante] -> [Participante]
votoParticipante [] = []
votoParticipante lista = map (`votar` lista) lista


-- Punto 6 

alHorno :: Participante -> [Participante] -> Bool
alHorno participante nominados = length (filter (==participante) nominados) >= 3

algoPersonal :: Participante -> [Participante] -> Bool
algoPersonal participante nominados =  all (==participante) (votoParticipante nominados)

zafo :: Participante -> [Participante] -> Bool
zafo participante nominados =  participante `notElem` votoParticipante nominados