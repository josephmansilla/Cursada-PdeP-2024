import Data.List
import Text.Show.Functions

data Persona = Persona{
    nombre :: String,
    edad :: Int,
    nivelFelicidad :: Int,
    estres :: Int,
    guita :: Int,
    habilidades :: [Persona -> Persona]
} deriving (Show)

anabel :: Persona
anabel = Persona "anabel" 21 60 15 19 []

bruno :: Persona
bruno = Persona "bruno" 15 90 5 0 []

clara :: Persona
clara = Persona "clara" 31 10 90 25 []

jovenesAdultos :: [Persona] -> [Persona]
jovenesAdultos = filter esJovenAdulto

esJoven :: Persona -> Bool
esJoven = (<31) . edad
esAdulto :: Persona -> Bool
esAdulto = (>18) .edad

esJovenAdulto :: Persona -> Bool
esJovenAdulto persona = esJoven persona && esAdulto persona

cocinar :: Persona -> Persona
cocinar = cambiarEstres (4-) . cambiarFelicidad (+5)

cambiarEstres :: (Int -> Int) -> Persona -> Persona
cambiarEstres modificador persona = persona {estres = modificador . estres $ persona}

cambiarFelicidad :: (Int -> Int) -> Persona -> Persona
cambiarFelicidad modificador persona = persona {nivelFelicidad = modificador . nivelFelicidad $ persona}

cambiarGuita :: (Int -> Int) -> Persona -> Persona
cambiarGuita modificador persona = persona {guita = modificador . guita $ persona}

tenerMascota :: Persona -> Persona
tenerMascota persona
    | guita persona >= 60 = efectoMascota . cambiarEstres (10-) $ persona
    | otherwise = efectoMascota . cambiarEstres (+5) $ persona

efectoMascota :: Persona -> Persona
efectoMascota = cambiarFelicidad (+20) . cambiarGuita (5-)

trabajarSoftware :: Persona -> Persona
trabajarSoftware = cambiarGuita (+20) . cambiarEstres (+10)

trabajarDocencia :: Persona -> Persona
trabajarDocencia = cambiarEstres (+30)

trabajar :: Persona -> Persona
trabajar = cambiarGuita (+5) . cambiarEstres (+5)

compartirCasa :: Persona -> Persona -> Persona
compartirCasa = efectoCompartirCasa 

efectoCompartirCasa :: Persona -> Persona -> Persona
efectoCompartirCasa p1 p2 =
    cambiarFelicidad (+5) . cambiarEstres (+diferenciasEstres p1 p2) . tieneMasGuita p2 $ p1

masGuita :: Persona -> Persona -> Bool
masGuita p1 p2 = guita p1 > guita p2

diferenciasEstres :: Persona -> Persona -> Int
diferenciasEstres p1 p2 = (estres p1 - estres p2) `div` 2

tieneMasGuita :: Persona -> Persona -> Persona
tieneMasGuita p1 p2
        | p1 `masGuita` p2 = cambiarGuita (+10) p1
        | otherwise = cambiarGuita (+10) p2

limiteHabilidades :: Persona -> Int
limiteHabilidades persona
    | (<18) . edad $ persona = 3
    | esJovenAdulto persona = 6
    | otherwise = 4

type Habilidad = Persona -> Persona

aprenderHabilidad :: Habilidad -> Persona -> Persona
aprenderHabilidad habilidad persona = persona {habilidades =  habilidad : habilidades persona}

descartarHabilidad :: Persona -> Persona
descartarHabilidad persona = persona {habilidades = take (limiteHabilidades persona) (habilidades persona)}

incorporarHabilidad :: Habilidad -> Persona -> Persona 
incorporarHabilidad habilidad persona 
    | limiteHabilidades persona < length (habilidades persona) = aprenderHabilidad habilidad persona
    | otherwise = descartarHabilidad . aprenderHabilidad habilidad $ persona 

cambioFelicidad :: Habilidad -> Persona -> Bool
cambioFelicidad habilidad persona = nivelFelicidad persona /= nivelFelicidad (habilidad persona)
cambioGuita :: Habilidad -> Persona -> Bool
cambioGuita habilidad persona = guita persona /= guita (habilidad persona)

valeAprenderHabilidad :: Habilidad -> Persona -> Bool
valeAprenderHabilidad habilidad persona = cambioFelicidad habilidad persona || cambioFelicidad habilidad persona

cursoIntensivo :: Persona -> [Habilidad] -> Persona
cursoIntensivo = foldl (flip ($)) 

cumplirAños :: Persona -> Persona
cumplirAños persona = persona {edad = (+1) . edad $ persona }

felizCumpleaños :: Persona -> Persona
felizCumpleaños = descartarHabilidad . cumplirAños  