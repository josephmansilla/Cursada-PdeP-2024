class Animal{
    const nombre
    method espacioOcupado()
    method esPeludo()
    method seLlevaBienCon(animal)
    method tipoAnimal()
}


// PERRO
class Perro inherits Animal{
    const raza
    override method espacioOcupado() = raza.tamanioTotalRaza()
    override method esPeludo() = raza.pelaje()
    override method seLlevaBienCon(animal) = raza.esAgresivoCon(self, animal)
    override method tipoAnimal() = "Perro"
}

// TAMAÑOS DE RAZAS DE PERROS

class RazaPerro{
    var property pelaje // bool
    method pelaje(estado){ pelaje = estado } // se queda pelado o le crece :D
    method tamanioTotalRaza()
    method esAgresivoCon(perro, animal)
}
class RazaChica inherits RazaPerro{ // debo inicializar el pelaje
    override method tamanioTotalRaza() = 0.5
    override method esAgresivoCon(perro, animal) = animal.espacioOcupado() > perro.espacioOcupado() 
}
class RazaGrande inherits RazaPerro{
    const tamanioRazaGrande
    override method tamanioTotalRaza() = tamanioRazaGrande
    override method esAgresivoCon(perro, animal) = animal.espacioOcupado().between(0.5, perro.espacioOcupado())
}


// PERRO SALVAJE

class PerroSalvaje inherits Perro{
    override method esPeludo() = true
    override method espacioOcupado() = 2 * super()
}

const mandy = new Perro(nombre = mandy, raza = new RazaChica(pelaje = true))


// PEZ DORADO
class PezDorado inherits Animal{
    override method espacioOcupado() = 0
    override method esPeludo() = false
    override method seLlevaBienCon(aniaml) = true
    override method tipoAnimal() = "Pez Dorado"
}

// GATO
class Gato inherits Animal{
    const actitud

    override method espacioOcupado() = 0.5
    override method esPeludo() = true
    override method seLlevaBienCon(animal) = actitud.esAgresivoCon(self, animal)
    override method tipoAnimal() = "Gato"
}

// TIPOS DE ACTITUDES GATO

object malaOnda{
    method esAgresivoCon(gato, animal) = false
}
object buenaOnda{
    method esAgresivoCon(gato, animal) = true
}