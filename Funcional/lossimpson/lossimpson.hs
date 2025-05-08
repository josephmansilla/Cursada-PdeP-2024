
data Personaje = Personaje {
    felicidad :: Int,
    dinero :: Int
} deriving (Show, Eq, Read)


-- 1. ACTIVIDADES DE LOS PERSONAJES

lisaSimpson :: Personaje
lisaSimpson = Personaje 100 20

homeroSimpson :: Personaje
homeroSimpson = Personaje 80 200

skinner :: Personaje
skinner = Personaje 40 150

isLisa :: Personaje -> Bool
isLisa personaje = personaje == lisaSimpson

irEscuela :: Personaje -> Personaje
irEscuela (Personaje felicidad dinero)
    | isLisa (Personaje felicidad dinero) = Personaje (felicidad + 20) dinero
    | otherwise = Personaje (felicidad - 20) dinero


comerDona :: Personaje -> Int -> Personaje
comerDona (Personaje felicidad dinero) dona = Personaje (felicidad + 10 * dona) (dinero - 10 * dona)

trabajarEscuela :: Personaje -> Personaje
trabajarEscuela = irEscuela

modificacionPersona :: Personaje -> Int -> Int -> Personaje
modificacionPersona (Personaje felicidad dinero) felicidadNuevo dineroNuevo = Personaje felicidadNuevo dineroNuevo

verPersona :: Personaje -> Personaje
verPersona persona = persona

trabajar:: Personaje -> [Char] -> Personaje
trabajar (Personaje felicidad dinero) trabajo = Personaje felicidad (dinero + length trabajo)


-- 2. LOGROS
srBurns :: Personaje
srBurns = Personaje 0 500

joseph:: Personaje
joseph = Personaje 0 495

serMillonario :: Personaje -> Bool
serMillonario personaje = dinero personaje > dinero srBurns
        
alegrarse :: Personaje -> Bool
alegrarse (Personaje felicidad _) = felicidad >= 80

irAVerElProgramaDeKrosti :: Personaje -> Bool
irAVerElProgramaDeKrosti (Personaje _ dinero) = dinero >= 10

esPobre :: Personaje -> Bool
esPobre (Personaje felicidad dinero) = dinero <= 20 && felicidad <= 40

-- PUNTO A
actividadDecisiva :: Personaje -> [Char] -> Bool
actividadDecisiva (Personaje felicidad dinero) decision = 
    serMillonario (trabajar jugador decision) || 
    irAVerElProgramaDeKrosti (trabajar jugador decision) ||
    not (esPobre(trabajar jugador decision))
    where
        jugador = Personaje felicidad dinero

-- PUNTO B


serieActividadesDecisiva :: [Personaje->Personaje]->(Personaje->Bool)->Personaje->Personaje
serieActividadesDecisiva [] _ personaje = personaje
serieActividadesDecisiva (act1:acts) logro personaje
    | logro (act1 personaje) = act1 personaje
    | not (logro (act1 personaje)) = serieActividadesDecisiva acts logro personaje
    | otherwise = personaje
    
-- PUNTO C

-- comerDona
-- trabajarEscuela
-- irEscuela
-- trabajar
-- irProgramaKrosti
