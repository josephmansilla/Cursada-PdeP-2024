
data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

bart :: Jugador
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd :: Jugador
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa :: Jugador
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

between :: (Eq a, Enum a) => a -> a -> a -> Bool
between n m x = x `elem` [n .. m]

maximoSegun :: (Foldable t, Ord a1) => (a2 -> a1) -> t a2 -> a2
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

--Punto 1A

type Palo = Habilidad -> Tiro

putter:: Palo
putter (Habilidad fuerzaJugador precisionJugador) = UnTiro {
  velocidad = 10,
  precision = precisionJugador*2,
  altura = 0
}

madera :: Palo
madera (Habilidad fuerzaJugador precisionJugador) = UnTiro {
  velocidad = 100,
  precision = precisionJugador `div` 2,
  altura = 5
}

hierros :: Int -> Palo
hierros n (Habilidad fuerzaJugador precisionJugador) = UnTiro {
  velocidad = fuerzaJugador * n,
  precision = precisionJugador `div` n,
  altura = (n - 3) `max` 0
}

-- PUNTO 1B

palos :: [Palo]
palos = [putter, madera] ++ map hierros [1..10]

-- Punto 2

golpe:: Jugador -> Palo -> Tiro
golpe jugadorElegido paloElegido = paloElegido (habilidad jugadorElegido)

golpe' :: Palo -> Jugador -> Tiro
golpe' paloElegido = paloElegido.habilidad

-- PUNTO 3


vasAlRasDelSuelo :: Tiro -> Bool
vasAlRasDelSuelo = (==0).altura

noSupera :: Tiro
noSupera = UnTiro 0 0 0

superaTunel :: Tiro -> Bool
superaTunel tiro = precision tiro > 90 && vasAlRasDelSuelo tiro 

superaLaguna :: Tiro -> Bool
superaLaguna tiro = velocidad tiro > 80 && between 1 5 (altura tiro) 

superaHoyo :: Tiro -> Bool
superaHoyo tiro = between 5 20 (velocidad tiro) && precision tiro > 95 && vasAlRasDelSuelo tiro

efectoTunelRampita :: Tiro -> Tiro
efectoTunelRampita tiro = tiro{velocidad = velocidad tiro  * 2, precision = 100, altura = 0}

efectoLaguna:: Int -> Tiro -> Tiro
efectoLaguna largoLaguna tiro = tiro {altura =  (altura tiro) `div` largoLaguna} 

efectoHoyo :: Tiro -> Tiro
efectoHoyo tiro = tiro {velocidad = 0, precision = 0, altura = 0}

data Obstaculo = UnObstaculo {
  puedeSuperarObstaculo :: Tiro -> Bool,
  unaVezSuperadoObstaculo :: Tiro -> Tiro
  }

{-pasaObstaculo :: (Tiro -> Bool) -> Obstaculo -> Tiro -> Tiro
pasaObstaculo condicion efecto tiro
  | condicion tiro = efecto tiro
  | otherwise = noSupera-}

intentarSuperarObstaculo :: Obstaculo -> Tiro -> Tiro
intentarSuperarObstaculo obstaculo tiroOriginal
  | puedeSuperarObstaculo obstaculo tiroOriginal = unaVezSuperadoObstaculo obstaculo tiroOriginal
  | otherwise = noSupera

tunelRampita :: Obstaculo
tunelRampita = UnObstaculo superaTunel efectoTunelRampita

laguna :: Int -> Obstaculo
laguna largo = UnObstaculo superaLaguna (efectoLaguna largo)

hoyo :: Obstaculo
hoyo = UnObstaculo superaTunel efectoTunelRampita

-- PUNTO 4

cumplePasaObstaculo :: Jugador -> Obstaculo -> Palo -> Bool
cumplePasaObstaculo jugador obstaculo palo = puedeSuperarObstaculo obstaculo (golpe' palo jugador)

-- A

palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugadorElegido obstaculo = 
  filter (cumplePasaObstaculo jugadorElegido obstaculo) palos


-- B EXTRA

obstaculosConsecutivos :: Tiro -> [Obstaculo]  -> Int
obstaculosConsecutivos tiro = length . takeWhile (\obstaculo tiroNuevo -> puedeSuperarObstaculo obstaculo tiro)




-- C
{-paloMasUtil :: Jugador -> [Obstaculo] -> [Palo]
paloMasUtil jugador obstaculos = -}