import mascotas.*

class Familia{
    var property personas
    var property mascotas = []
    var tamanioCasa // en m^3
            //
    method tamanioOcupadoPersonas() = personas.forEach{ persona => persona.espacioOcupado() }
    method hayLugarPara(animal) = self.tamanioOcupadoPersonas() + animal.espacioOcupado() <= tamanioCasa 
            //
    method hayProblemaCon(animal) = 
        (self.alguienEsAlergica() && animal.esPeludo()) || self.algunaMascotaEsAgresivaA(animal) || self.algunoNoLeCaeBien(animal)
    
    method algunoNoLeCaeBien(animal) = personas.any{ persona => persona.preferenciaAniales().contains(animal.tipoAnimal())}
    method algunaMascotaEsAgresivaA(animal) = mascotas.any{ mascota => not mascota.seLlevaBienCon(animal) }
    method alguienEsAlergica() = personas.any{ persona => personas.esAlergica() }
            //
    method puedeAdoptar(animal) = self.hayLugarPara(animal) && not self.hayProblemaCon(animal)
            //
    method tienenMenoresDeEdad() = personas.any{ persona => persona.esMenor()}
    method hayMascota() = not mascotas.isEmpty()
            //
    method sumarMascota(animal){ mascotas.add(animal) }
}

class Persona{
    var edad
    var property preferenciaAnimales = []
    method esAlergica() = true
    method espacioOcupado() = if(edad>13) 1 else 0.75
    method esMenor() = edad < 18
}