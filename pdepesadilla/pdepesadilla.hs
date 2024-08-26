import Data.List

data Persona = Persona {
    nombre :: String,
    recuerdos :: [String]
} deriving (Show, Eq)


suki :: Persona
suki = Persona {
    nombre = "Susana Kitimporta",
    recuerdos = ["abuelita", "escuela primaria", "examen aprobado", "novio"]
}

pesadillaDeMovimiento :: Int -> Int-> Persona -> Persona
pesadillaDeMovimiento pos elemento (Persona nombre recuerdos) =
    Persona nombre (take pos recuerdos ++ [recuerdos !! elemento] ++ filter (/=(recuerdos !! elemento)) (drop pos recuerdos))

pesadillaDeSustitucion :: Int -> String -> Persona -> Persona
pesadillaDeSustitucion pos string (Persona nombre recuerdos) = 
    Persona nombre (take pos recuerdos ++ [string] ++ drop (pos + 1) recuerdos)

pesadillaEspejo :: Persona -> Persona
pesadillaEspejo persona = persona {recuerdos = (reverse . recuerdos) $ persona}

pesadillaDesmemorizadora :: String -> Persona -> Persona
pesadillaDesmemorizadora string persona = persona {recuerdos = filter (/= string) (recuerdos persona)}

sueño :: Persona -> Persona
sueño persona = persona

type Pesadilla = Persona -> Persona

seriePesadillas :: Persona -> [Pesadilla] -> Persona 
seriePesadillas = foldl (flip ($))

pesadillaEspecial :: Int -> Persona -> Persona
pesadillaEspecial numero persona
 = Persona (nombre persona) (filter (\recuerdo -> length recuerdo > numero) (recuerdos persona))

-- Situaciones Excepcionales -- 

segmentationFault :: Persona -> [Persona] -> Bool
segmentationFault persona pesadillas = length (recuerdos persona)  > length pesadillas

bugInicial :: Persona -> [Pesadilla] -> Bool
bugInicial persona pesadillas = 
    recuerdos (persona `seriePesadillas` [head pesadillas]) /= [head (recuerdos persona)]

pesadillasNashe :: [Persona -> Persona]
pesadillasNashe = [pesadillaEspejo, pesadillaDesmemorizadora "novio"]

falsaAlarma :: Persona -> [Pesadilla] -> Bool
falsaAlarma persona pesadillas = 
    recuerdos persona == recuerdos (persona `seriePesadillas` pesadillas)
