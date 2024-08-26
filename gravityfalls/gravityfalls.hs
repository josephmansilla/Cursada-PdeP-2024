import Text.Show.Functions
import Data.List

type Item = String

data Persona = Persona {
    edad :: Int,
    iventario :: [Item],
    experiencia :: Int
} deriving (Show, Eq)

data Criatura = Criatura {
    nombre :: String,
    peligrosidad :: Int,
    puedeDeshacerseDeElla :: Persona -> Bool
} deriving (Show)

siempreDetras :: Criatura
siempreDetras = Criatura {
    nombre = "siempredetras",
    peligrosidad = 0,
    puedeDeshacerseDeElla = (\_ -> False)
}

gnomos :: Int -> Criatura
gnomos cantidad = Criatura {
    nombre = "gnomos",
    peligrosidad = 2 ^ cantidad,
    puedeDeshacerseDeElla = tieneItem "sopladorDeHojas"
}

tieneItem :: Item -> Persona -> Bool
tieneItem item persona = item `elem` iventario persona

fantasmas :: Int -> (Persona -> Bool) -> Criatura
fantasmas categoria asuntoPendiente = Criatura {
    nombre = "fantasma",
    peligrosidad = 20 * categoria,
    puedeDeshacerseDeElla = asuntoPendiente
}

ganarExperiencia :: Persona -> Int -> Persona
ganarExperiencia persona cantidad = persona {experiencia = experiencia persona + cantidad}

enfrentarCriatura :: Persona -> Criatura -> Persona
enfrentarCriatura persona criatura
    | persona `leGano` criatura = persona `ganarExperiencia` (peligrosidad criatura)
    | otherwise = persona `ganarExperiencia` 1

leGano :: Persona -> Criatura -> Bool
leGano persona criatura = (puedeDeshacerseDeElla criatura) persona

enfrentaminetosSucesivos :: Persona -> [Criatura] -> Persona
enfrentaminetosSucesivos = foldl enfrentarCriatura

experienciaPosterior :: Persona -> [Criatura] -> Int
experienciaPosterior persona = subtract (experiencia persona) .
    experiencia . enfrentaminetosSucesivos persona 

ejemploCriaturas :: [Criatura]
ejemploCriaturas = [
    
    siempreDetras,
    gnomos 10,
    fantasmas 3 (\persona -> edad persona > 13 && tieneItem "disfrazDeOveja" persona),
    fantasmas 1 (\persona -> experiencia persona > 10)

    ]

dipper :: Persona
dipper = Persona 15 ["disfrazDeOveja", "sexo"] 20