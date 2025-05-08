import invitado.*

class Disfraz{
    const property nombre = ""
    const property fechaConfeccion = 0
    const personaje = null // tiene valor
    const nivelGracia = 0

    method puntuacion(invitado) = self.gracioso(invitado) + self.tobaras(invitado) + self.caretas() + self.sexies(invitado)

    method gracioso(invitado) = nivelGracia * (if(invitado.edad() > 50) 3 else 1)
    method tobaras(invitado) = if(invitado.fechaCompra(2)) 5 else 3
    method caretas() = personaje.valor()
    method sexies(invitado) = if(invitado.esSexi()) 15 else 2

    method nombrePar() = nombre % 2 == 0
    method hechoHaceMenosDe(tiempo) = fechaConfeccion / 100 <= tiempo
}

class Personaje{
    method valor()
}
object mickeyMouse inherits Personaje{
    override method valor() = 8
}
object osoCarolina inherits Personaje{
    override method valor() = 6
}

object sinDisfraz inherits Disfraz{
    override method puntuacion(invitado) = 0
}