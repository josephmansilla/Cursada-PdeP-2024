   
data Auto = Auto{
    color :: String,
    velocidad :: Int,
    distancia :: Int
} deriving(Show, Eq)

type Carrera = [Auto]

autoRojo :: Auto
autoRojo = Auto "Rojo" 120 100

autoBlanco :: Auto
autoBlanco = Auto "Blanco" 120 150

autoAzul :: Auto
autoAzul = Auto "Azul" 120 0

autoNegro :: Auto
autoNegro = Auto "Negro" 120 0



-- Punto 1

noEsMismoAuto :: Auto -> Auto -> Bool
noEsMismoAuto (Auto color1 _ _) (Auto color2 _ _) = color1 /= color2

cercaniaAuto :: Auto -> Auto -> Bool
cercaniaAuto auto1 auto2 = auto1 `noEsMismoAuto` auto2 && (abs (distancia auto1) - (distancia auto2)) < 10 

esMayorDistancia:: Auto -> Auto -> Bool
esMayorDistancia (Auto _ _ dis1) (Auto _ _ dis2) = dis1 < dis2

vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo auto carrera = (all (not.cercaniaAuto auto) carrera) && (all (auto `esMayorDistancia`) carrera) 


--puestoSiListaOrdenada :: Auto -> Carrera -> Int
--puestoSiListaOrdenada (Auto color _ _) carrera = length (takeWhile ((/=).color) carrera) + 1 

esMenorDistancia:: Auto -> Auto -> Bool
esMenorDistancia (Auto _ _ dis1) (Auto _ _ dis2) = dis1 > dis2

autosPorDebajo :: Auto -> Auto -> Bool
autosPorDebajo auto1 auto2 = (auto1 `noEsMismoAuto` auto2) && (auto1 `esMenorDistancia` auto2)

puesto :: Auto -> Carrera -> Int
puesto auto carrera = length ((filter (`autosPorDebajo` auto) carrera)) + 1


-- Punto 2

corra :: Auto -> Int -> Auto
corra (Auto color velocidad distancia) tiempo = Auto {
    color = color,
    velocidad = velocidad,
    distancia = distancia + (tiempo * velocidad)
}  

modificarVelocidad::(Int->Int)->Auto->Auto
modificarVelocidad modificador auto = auto {velocidad=max 0 (modificador (velocidad auto))}

bajarVelocidad::Int->Auto->Auto
bajarVelocidad n auto = modificarVelocidad (\v -> v - n) auto 

-- Punto 3 

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista = 
    (map efecto . filter criterio) lista ++ filter (not.criterio) lista

terremoto :: Auto -> Carrera -> Carrera
terremoto auto carrera = afectarALosQueCumplen (cercaniaAuto auto) (bajarVelocidad 50) carrera

autosPorEncima:: Auto -> Auto -> Bool
autosPorEncima auto1 auto2 = (auto1 `noEsMismoAuto` auto2) && (auto1 `esMayorDistancia` auto2)

miguelitos :: Auto -> Int -> Carrera -> Carrera
miguelitos auto cantidad carrera = afectarALosQueCumplen (auto `autosPorEncima`) (cantidad `bajarVelocidad` ) carrera

efectoJetpack :: Int -> Auto -> Auto
efectoJetpack tiempo (Auto color velocidad distancia) = corra (Auto color (velocidad*2) distancia) tiempo

jetpack :: Auto -> Int -> Carrera -> Carrera
jetpack auto tiempo carrera = afectarALosQueCumplen ((== (color auto)). color) (tiempo `efectoJetpack`) carrera


type Eventos = Carrera -> Carrera

type Posiciones = [(Int, String)]

producirEvento::Carrera->(Carrera->Carrera)->Carrera
producirEvento carrera funcion = funcion carrera

type Color = String

simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, Color)]
simularCarrera carrera eventos = map (\auto -> (auto `puesto` (foldl producirEvento carrera eventos), color auto)) (foldl (producirEvento) carrera eventos)


correnTodos :: Carrera -> Int -> Carrera
correnTodos carrera tiempo = map (`corra` tiempo) carrera

usaPowerUp :: (Auto -> Carrera -> Carrera) -> Color -> Carrera -> Carrera
usaPowerUp powerUp colorBuscado carrera = powerUp (colorBuscado `obtenerAuto` carrera) carrera 

obtenerAuto :: Color -> Carrera -> Auto
obtenerAuto colorBuscado carrera =  head (filter ((==colorBuscado).(color)) carrera)

carrera1 :: Carrera
carrera1 = [autoRojo, autoBlanco, autoAzul, autoNegro]

eventos1 :: [Eventos]
eventos1 = [(`correnTodos` 30), jetpack autoAzul 3, terremoto autoBlanco, (`correnTodos` 40), miguelitos autoBlanco 20, jetpack autoNegro 6, (`correnTodos` 10)]

-- simularCarrera carrera1 eventos1

--5a ) se puede realizar gracias a la función obtener auto, esta nos permite tener un misil teledirigido.
--5b ) el punto 1b , no se podria usar debido a que estaría constantemente comprobando si todos los 
-- elementos de la lista cumplen la condición de cercania, lo cual no pararía nunca.
-- en el punto 1c, pasaría lo mismo siempre buscaría hacer un filtrado de la infinita lista
-- estaría comprobando elemento por elemento hasta que me muera.