class Personaje{
    const property fuerza
    const property inteligencia
    var property rol

    method potencialOfensivo() = 10 * fuerza + rol.potencialOfensivoExtra()
    method esGroso() = self.esInteligente() || self.esGrosoParaSuRol()

    method esInteligente()
    method esGrosoParaSuRol() = rol.esGroso(self)
}

class Humano inherits Personaje{

    override method esInteligente() = inteligencia >= 50
}

class Orco inherits Personaje{

    override method potencialOfensivo() = super() * 1.1

    override method esInteligente() = false
    
}

class Guerrero{
    
    method potencialOfensivoExtra() = 100
    method esGroso(personaje) = personaje.fuerza() > 50
}

class Mascota{
    const property fuerza
    const property edad
    const tieneGarras

    method potencialOfensivo(){if(tieneGarras){return fuerza * 2} else {return fuerza}}
    method esLongeva() = edad > 10
}

class Cazador{

    const mascota
    method potencialOfensivoExtra() = mascota.potenciaOfesivo()
    method esGroso(personaje) = mascota.esLongeva()

}

class Brujo{
    method potencialOfensivoExtra() = 0
    method esGroso(personaje) = true
}



class Ejercito{
    const property miembros = []
    method potencialOfensivo() = miembros.sum{personaje => personaje.potencialOfensivo()}
    method invasion(zona){
        if(zona.potencialDefensivo() < self.potencialOfensivo()){
            zona.serOcupadaPor(self)
        }
    }
}

class Aldea inherits Localidad{
    const property tamanioMaximo

    override method serOcupadaPor(ejercito){
        if(ejercito.miembros().size() > tamanioMaximo){
            const nuevosHabitantes = ejercito.miembros().sortedBy{uno, otro => uno.potencialOfensivo() > otro.potencialOfensivo()}.take(10)
            super(new Ejercito(miembros = nuevosHabitantes))
            ejercito.miembros().removeAll(nuevosHabitantes)
        } else {
            super(ejercito)
        }
    }
    
}

class Ciudad inherits Localidad{
    override method potencialDefensivo() = super() + 300
}

class Localidad{
    var property ocupantes
    
    method potencialDefensivo() = ocupantes.potencialOfensivo()
    method serOcupadaPor(ejercitoAtacante){ocupantes = ejercitoAtacante}
}