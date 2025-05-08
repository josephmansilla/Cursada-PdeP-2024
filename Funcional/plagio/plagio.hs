import Data.List
import Text.Show.Functions


data Obra = Obra {
    nombre :: String,
    año :: Int
} deriving (Show, Eq)

data Autores = Autores {
    obras :: [Obra],
    nombreAutor :: String
} deriving (Show,Eq)


-- Modelar obras 

a :: Obra
a = Obra "Habia una vez un pato." 1997
b :: Obra
b = Obra "¡Había una vez un pato!" 1996
c :: Obra
c = Obra "Mirtha, Susana y Moria." 2010
d :: Obra
d = Obra "La semántica funcional del amoblamiento vertebral es riboficiente" 2020
e :: Obra
e = Obra "La semántica funcional de Mirtha, Susana y Moria." 2022

letrasProhibidas :: Char -> Char
letrasProhibidas 'á' = 'a'
letrasProhibidas 'í' = 'i'
letrasProhibidas 'ó' = 'o'
letrasProhibidas 'ú' = 'u'
letrasProhibidas 'é' = 'e'
letrasProhibidas letra = letra

esLetra :: Char -> Bool
esLetra letra = letra `elem` ['A'..'Z'] ++ ['a'..'z'] ++ [' ']

sacarSignos :: String -> String
sacarSignos = filter esLetra

crudo :: String -> String
crudo = sacarSignos . map letrasProhibidas

versionCruda :: Obra -> Obra
versionCruda obra = obra {nombre = crudo (nombre obra)}

