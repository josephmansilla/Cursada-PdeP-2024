class Personaje {
    const casa
    const conyuges
    const acompaniantes
    var estaVivo = true

    method casa() = casa
    method conyuges() = conyuges
    method estaVivo() = estaVivo

    method puedeCasarseCon(personaje) = casa.puedenCasarse(personaje, self) && personaje.casa().puedenCasarse(personaje, self)
    method tieneUnaSolaPareja() = conyuges.size() <= 1
    method estaSoltero() = conyuges.isEmpty()

    method casar(personaje) {
        if(self.puedeCasarseCon(personaje)){
            self.agregarConyuge(personaje)
            personaje.agregarConyuge(self)
        } else {
            throw new DomainException(message = "Alguna de las casas no aprueba el casamiento")
        }
    }
    method agregarConyuge(conyuge) { conyuges.add(conyuge)}

    method patrimonio() = casa.patrimonio() / casa.cantidadMiembros()

    method estaSolo() = acompaniantes.isEmpty()

    method aliados() = conyuges + acompaniantes + casa.miembros()
    method esAliado(personaje) = self.aliados().contains(personaje)

    method esPeligroso() = self.estaVivo() && self.auxEsPeligroso()

    method auxEsPeligroso() = self.patrimonioAliados(10000) || self.conyugesRicos() || self.alianzaPeligrosa()
    method patrimonioAliados(cantidad) = self.aliados().sum{ aliado => aliado.patrimonio()} >= cantidad
    method conyugesRicos() = conyuges.all{ conyuge => conyuge.casa().esRica()}
    method alianzaPeligrosa() = self.aliados().any{ aliado => aliado.esPeligroso()}

    method morir(){ estaVivo = false}
}

const hodor = new Personaje(casa = lannister, conyuges = [], acompaniantes = [])

class Casa {
    var patrimonio
    const ciudad
    const miembros

    method patrimonio() = patrimonio
    method ciudad() = ciudad

    method puedenCasarse(personaje, otroPersonaje)

    method esRica() = patrimonio >= 1000

    method cantidadMiembros() = miembros.size()

    method perderPatrimonio(valor) { patrimonio = 0.max(patrimonio - valor)} // considero el patrimonio >= 0
}

class Ciudad {
    const casas

    method casaMasPobre() = casas.min{ casa => casa.patrimonio()}
}

class Lannister inherits Casa {

    override method puedenCasarse(personaje, otroPersonaje) = personaje.tieneUnaSolaPareja() && otroPersonaje.tieneUnaSolaPareja()
}

const lannister = new Lannister(patrimonio = 10000, ciudad = "Bs As", miembros = [])

class Stark inherits Casa {

    override method puedenCasarse(personaje, otroPersonaje) = personaje.casa() != otroPersonaje.casa()
}

class GuardiaDeLaNoche inherits Casa {

    override method puedenCasarse(personaje, otroPersonaje) = false
}

class Animal {

    method patrimonio() = 0
    method esPeligroso() = false
    method esHuargo() = false
}

class Dragon inherits Animal {
    override method esPeligroso() = true
}

class Lobo inherits Animal {
    override method esPeligroso() = self.esHuargo()
    override method esHuargo() = true
}

class Conspiracion {
    var objetivo
    var complotados
    var ejecutada = false

    method ejecutada() = ejecutada
    method conspiracionEjecutada(){ ejecutada = true}

    method objetivo() = objetivo
    method complotados() = complotados

    method constructor(nuevoObjetivo, nuevosComplotados) {
        if(objetivo.esPeligroso() || objetivo == hodor){
            throw new DomainException(message = "No se puede complotar contra ese objetivo")
        } else {
            objetivo = nuevoObjetivo
            complotados = nuevosComplotados
        }
    }

    method cantidadTraidores() {
        const traidores = complotados.filter{ complotado => objetivo.esAliado(complotado)}

        return traidores.size()
    }

    method ejecutar() { 
        if(!ejecutada){
            complotados.forEach{ complotado => complotado.conspiracion(objetivo)}}
            self.conspiracionEjecutada()
}

    method objetivoFueCumplido() = self.ejecutada() && !objetivo.esPeligroso()
}

class Sutiles {
    method conspiracion(personaje) {
        const casaMasPobre = personaje.casa().ciudad().casaMasPobre()
        const otroPersonaje = casaMasPobre.find{ personaje => personaje.estaVivo() && personaje.estaSoltero()}

        if(otroPersonaje != null) {
            personaje.casar(otroPersonaje)
        } else {
            throw new DomainException(message = "No se pudo casa con nadie")
        }
    }
}

class Asesinos {
    method conspiracion(personaje) { 
        if(personaje.estaVivo()) {
            personaje.morir()}
}
}

class AsesinosPrecavidos {
    method conspiracion(personaje){
        if(personaje.estaSolo() && personaje.estaVivo()){
            personaje.morir()
        }
    }
}

class Disipados {
    const porcentaje

    method conspiracion(personaje) {
        const perdida = personaje.casa().patrimonio() * porcentaje

        personaje.casa().perderPatrimonio(perdida) 
    }
}

class Miedodos {
    method conspiracion(personaje){ } // no hacen nada
}