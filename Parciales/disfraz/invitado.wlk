import disfraz.*

class Fiesta{
    const lugar
    var fecha
    const invitados = []

    method esBodrio() = invitados.all{ invitado => not invitado.satisfecho() }
    method mejorDisfraz() = invitados.max{ invitado => invitado.puntuacion() }
    method condicionProjectoX() = invitados.all{ invitado => invitado.satisfecho() && invitado.esSexi() }

    method agregarInvitado(invitado){ self.verificarInvitado(invitado) invitados.add(invitado) }
    method verificarInvitado(invitado){
        if(self.invitadoYaCargado(invitado)){ self.error("Ya está cargado en el sistema")}
        if(not invitado.tieneDisfraz()) self.error("No tiene disfraz este pancho")
    }
    method invitadoYaCargado(invitado) = invitados.contains(invitado)
    method esFiestaInolvidable() = self.condicionProjectoX()

    method estanEnMimsaJoda(unInvitado, otroInvitado) = invitados.intersects([unInvitado, otroInvitado])
    method algunoDisconforme(unInvitado, otroInvitado) = not (otroInvitado.satisfecho() && unInvitado.satisfecho())
    method intercambioSatisfactorio(principal, otro) = principal.ambosSatisfechosConNuevoDisfraz(otro)

    method intercambiarDisfraz(unInvitado, otroInvitado){
        if( not self.estanEnMimsaJoda(unInvitado, otroInvitado) ) self.error("No estan en la misma fiesta")
        if( not self.algunoDisconforme(unInvitado, otroInvitado)) self.error("No están los dos disconformes")
        if( not self.intercambioSsatisfactorio(unInvitado, otroInvitado)) self.error("No quedan satisfechos al cambiar")
        unInvitado.intercambiarDisfraz(otroInvitado)
    }
}

class Invitado{
    var property disfraz
    const property edad
    var property personalidad
    const fechaCompraDisfraz
            //
    method puntuacion() = disfraz.puntuacion(self)
    method esSexi() = personalidad.esSexy()
            //
    method fechaCompra(cantidadDias) = cantidadDias >= fechaCompraDisfraz
            //
    method cambiarPersonalidad(personalidadNueva){ personalidad = personalidadNueva }
            //
    method satisfecho() = self.puntuacionMayorA(10) && self.condicion()
    method puntuacionMayorA(cantidad) = self.puntuacion() > cantidad
    method condicion()
            //
    method invitadoTieneDisfraz() = disfraz.puntuacion() == 0
            //
    method cambiarDisfraz(newDisfraz){ disfraz = newDisfraz }

    method ambosSatisfechosConNuevoDisfraz(invitado){
        self.intercambiarDisfraz(invitado)
        return invitado.satisfecho() && self.satisfecho()
    }
    method intercambiarDisfraz(invitado){ 
        const unDisfraz = self.disfraz()
        const otroDisfraz = invitado.disfraz()
        invitado.cambiarDisfraz(unDisfraz)
        self.cambiarDisfraz(otroDisfraz) 
    }
}

class Caprichoso inherits Invitado{
    override method condicion() = disfraz.nombrePar()
}
class Pretencioso inherits Invitado{
    override method condicion() = disfraz.hechoHaceMenosDe(30)
}
class Numerologo inherits Invitado{
    var property numeroFavorito
    override method condicion() = self.puntuacion() == numeroFavorito
}


object alegre{
    method esSexy(invitado) = false
}
object taciturnas{
    method esSexy(invitado) = invitado.edad() < 30
}