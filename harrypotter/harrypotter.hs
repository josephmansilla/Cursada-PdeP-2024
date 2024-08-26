import Data.List

data Persona = Persona {
  nombrePersona :: String,
  suerte :: Int,
  inteligencia :: Int,
  fuerza :: Int
} deriving (Show, Eq)

data Pocion = Pocion {
  nombrePocion :: String,
  ingredientes :: [Ingrediente]
}

type Efecto = Persona -> Persona

data Ingrediente = Ingrediente {
  nombreIngrediente :: String,
  efectos :: [Efecto]
}

ingredientesProhibidos :: [String]
ingredientesProhibidos = [
 "sangre de unicornio",
 "veneno de basilisco",
 "patas de cabra",
 "efedrina"]

maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun _ [ x ] = x
maximoSegun  f ( x : y : xs)
  | f x > f y = maximoSegun f (x:xs)
  | otherwise = maximoSegun f (y:xs)

sumaDeNiveles :: Persona -> Int
sumaDeNiveles (Persona _ suerte inteligencia fuerza) = suerte + fuerza + inteligencia

niveles :: Persona -> [Int]
niveles persona = [suerte persona, inteligencia persona, fuerza persona]

ordenNiveles :: Persona -> [Int]
ordenNiveles = sort.niveles

diferenciaDeNiveles :: Persona -> Int
diferenciaDeNiveles persona = maximum orden - minimum orden
    where
        orden = ordenNiveles persona

nivelesMayoresA :: Persona -> Int -> Int
nivelesMayoresA persona = length.flip filter (niveles persona).(>=)

efectosDePocion :: Pocion -> [Efecto]
efectosDePocion = concatMap efectos . ingredientes

pocionesHardcore :: [Pocion] -> [String]
pocionesHardcore = map nombrePocion . filter ((>=4) . length . efectosDePocion)

pocionesProhibidas :: [Pocion] -> Int
pocionesProhibidas =  length . filter esProhibido

esProhibido :: Pocion -> Bool
esProhibido =  any (flip elem ingredientesProhibidos . nombreIngrediente) . ingredientes

sonTodosDulce :: [Pocion] -> Bool
sonTodosDulce = all (any (("azúcar" ==) . nombreIngrediente) . ingredientes)

tomarPocion :: Pocion -> Persona -> Persona
tomarPocion pocion persona = foldl (flip ($)) persona (efectosDePocion pocion) 

esAntidotoDe :: Pocion -> Pocion -> Persona -> Bool
esAntidotoDe pocion antidoto persona = ( (==persona) . tomarPocion pocion . tomarPocion antidoto) persona 

type Cuantificadora = (Persona -> Int)

personaMasAfectada :: Pocion -> Cuantificadora -> [Persona] -> Persona
personaMasAfectada pocion criterio = maximoSegun (criterio . tomarPocion pocion)