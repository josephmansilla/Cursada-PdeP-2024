import Data.List

data Personaje = UnPersonaje {
    nombre :: String,
    puntaje :: Int,
    inventario :: [Material]
} deriving (Show, Eq)

type Material = String

-- Craft

-- fogata : madera y fósforo . tarda 10 segundos
-- pollo asado : fogata y pollo . tarda 300 segundos
-- sueter : lana aguja y tintura . tarda 600 segundos

fogata :: [Material]
fogata = ["madera", "fosforo"]
polloAsado :: [Material]
polloAsado = ["fogata", "pollo"]
sueter:: [Material]
sueter = ["lana", "aguja", "tintura"]

steve :: Personaje
steve = (UnPersonaje "Steve" 1500 ["fogata", "pollo", "lana","fogata","fosforo"])

estaEnInventario :: Personaje -> Material -> Bool
estaEnInventario steve item = item `elem` (inventario steve)

noEstaEnInventario :: Personaje -> Material -> Bool
noEstaEnInventario steve item = item `notElem` (inventario steve)

puedeCraftear :: Personaje -> [Material] -> Bool
puedeCraftear steve receta = all (steve `estaEnInventario`) receta

aumentarPuntos :: Personaje -> Int -> Personaje
aumentarPuntos (UnPersonaje nombre puntaje inventario) segundos = UnPersonaje {
    nombre = nombre,
    puntaje = puntaje + 10 * segundos,
    inventario = inventario
}

eliminarItems :: Personaje -> [Material] -> [Material]
eliminarItems steve receta = inventario steve \\ receta

type Receta = ([Material], Int, [Material])

craftFogata :: Receta
craftFogata = (["madera", "fosforo"], 10, ["fogata"])
craftPolloAsado :: Receta
craftPolloAsado = (["fogata", "pollo"], 300, ["polloAsado"])
craftSueter:: Receta
craftSueter = (["lana", "aguja", "tintura"], 600, ["sueter"])

fst3 :: (a, b, c) -> a
fst3 (n,_,_) = n
snd3 :: (a, b, c) -> b
snd3 (_,m,_) = m
trd3 :: (a, b, c) -> c
trd3 (_,_,j) = j

craft :: Personaje -> Receta -> Personaje
craft steve receta
    | steve `puedeCraftear` (fst3 receta) = UnPersonaje {
        nombre = nombre steve,
        puntaje = (puntaje steve) + 10 * (snd3 receta),
        inventario = steve `eliminarItems` (fst3 receta) ++ (trd3 receta) 
    }
    | otherwise = UnPersonaje {
        nombre = nombre steve,
        puntaje = (puntaje steve) - 100,
        inventario = inventario steve
    }

steve2 :: Personaje
steve2 = (UnPersonaje "Steve" 3000 ["fogata", "pollo", "madera", "fosforo"]) 

craftPolloAsadoDos :: [Receta]
craftPolloAsadoDos = [craftPolloAsado, craftFogata]

darInventario :: Personaje -> [Material]
darInventario steve = inventario steve

recetaDuplica :: Personaje -> Receta -> Bool
recetaDuplica steve receta = (puntaje (steve `craft` receta)) >= (puntaje steve * 2)


craftearRecetas :: Personaje -> [Receta] -> Personaje
craftearRecetas steve [x] = steve `craft` x 
craftearRecetas steve (x:xs) = (steve `craft` x ) `craftearRecetas` xs


puedeDuplicar :: Personaje -> [Receta] -> Bool
puedeDuplicar steve recetas = (puntaje (steve `craftearRecetas` recetas )) >= (puntaje steve * 2)

-- Mine

tieneElementoNecesario :: Personaje -> Material -> Bool
tieneElementoNecesario steve elemento = elemento `elem` (inventario steve)

artico = ["hielo","iglues", "lobo"]

type Bioma = [Material]

--herramienta :: Personaje -> Bioma -> [Material]
--herramienta steve bioma 
--    | steve `tieneElementoNecesario` "hacha" = last bioma
--    | steve `tieneElementoNecesario` "esapada" = head bioma
--     | steve `tieneElementoNecesario` "pico" ++ [1..5] = bioma !! (last(find (==["pico"] ++ [1..5]) (inventario steve)))
--    | otherwise = []



--minarEnBioma :: Personaje -> Personaje
--minarEnBioma steve elemento 
--    | steve `tieneElementoNecesario` elemento = UnPersonaje {
 --       nombre = nombre steve,
 --       puntaje = puntaje steve + 50,
 --       inventario = inventario steve ++ undefined
  --  }
  --  | otherwise = steve

