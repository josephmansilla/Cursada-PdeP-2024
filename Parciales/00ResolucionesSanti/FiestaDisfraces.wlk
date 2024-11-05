class Fiesta {
    var property lugar 
    var property fecha 
    var property invitados    

    method esUnBodrio() = invitados.all{ invitado => !invitado.estaSatisfecho()}
    method mejorDisfraz() = invitados.max{ invitado => invitado.disfraz().puntosDisfraz(invitado, self)}
    method agregarInvitado(invitado) = invitado.tieneDisfraz() && !invitados.contains(invitado)
    method esInolvidable() = invitados.all{ invitado => invitado.esSexie() && invitado.estaSatisfecho()}
}

class Invitado {
    var disfraz
    var property edad
    const criterioSatisfaccion

    method esSexie()
    method estaSatisfecho() = disfraz.puntosDisfraz() >= 10 && criterioSatisfaccion.estaSatisfecho(disfraz)
    
    method disfraz() = disfraz
    method cambiarDisfraz(nuevoDisfraz) { disfraz = nuevoDisfraz}
    method puedenIntercambiarDisfraz(fiesta, invitado) = self.estanEnMismaFiesta(fiesta, invitado) && 
                                                         self.algunoEstaDisconforme(invitado) && 
                                                         self.cambianYEstanConformes(invitado)

    method estanEnMismaFiesta(fiesta, invitado) = fiesta.invitados().contains(self) && fiesta.invitados().contains(invitado)
    method algunoEstaDisconforme(invitado) = !self.estaSatisfecho() || !invitado.estaSatisfecho()
    method cambianYEstanConformes(invitado) {
        const unDisfraz = self.disfraz()
        const otroDisfraz = invitado.disfraz()

        invitado.cambiarDisfraz(unDisfraz)
        self.cambiarDisfraz(otroDisfraz)
       

        return self.estaSatisfecho() && invitado.estaSatisfecho()}

    method tieneDisfraz() = disfraz.puntosDisfraz() > 0
}

class Alegre inherits Invitado {
    override method esSexie() = false

}

class Taciturna inherits Invitado {
    override method esSexie() = self.edad() < 30
}

class Cambiante inherits Taciturna {
    var personalidadActual

    method cambiarPersonalidad(nuevaPersonalidad) { personalidadActual = nuevaPersonalidad}
    method personalidadActual() = personalidadActual

    override method esSexie() = personalidadActual.esSexie()
}

class Caprichoso {
    method estaSatisfecho(disfraz) = disfraz.nombreDisfraz().size() % 2 == 0
}

class Pretencioso {
    const fechaActual

    method estaSatisfecho(disfraz) = (fechaActual - disfraz.fechaConfeccion()).abs() < 30  
}

class Numerologo {
    var property numero 

    method estaSatisfecho(disfraz) = disfraz.puntosDisfraz() == numero
}

class Disfraz {
    var property nombreDisfraz
    var property fechaConfeccion
    const caracteristicas

    method puntosDisfraz(invitado, fiesta) = caracteristicas.sum{ caracteristica => caracteristica.puntos(invitado, fiesta)}
}

class Gracioso inherits Disfraz {
    const nivelGracia
    
    method obtenerNivelGracia() = 1.max(10.min(nivelGracia))
    method puntos(invitado, fiesta) {
        if(invitado.edad() > 50) return 3 * self.obtenerNivelGracia() else return self.obtenerNivelGracia()
    }
}

class Tobara inherits Disfraz {
    const diaCompra

    method puntos(invitado, fiesta) {
        if(fiesta.fecha() - diaCompra <= 2) return 5 else return 3
    }

}

class Careta inherits Disfraz {
    const careta 

    method puntos(invitado, fiesta) = careta.valorPersonaje()
}

class Sexie inherits Disfraz {
    method puntos(invitado, fiesta) {
        if(invitado.esSexie()) return 15 else return 2
    }
}

class CaretaPersonaje {
    const valorCareta

    method valorPersonaje() = valorCareta
}

const mickey = new CaretaPersonaje(valorCareta = 8)
const osoCarolina = new CaretaPersonaje(valorCareta = 6)